using System;
using System.Diagnostics;
using System.Collections;

namespace Voxis
{
	public static class CanvasRenderPipeline
	{
		public const int MAX_VERTICES = 2048;
		public const int MAX_INDICES = 1024;
		public const int MAX_TEXTURES = 16;

		private static VertexBuffer vertexBuffer;
		private static IndexBuffer indexBuffer;
		private static ShaderProgram shaderProgram;
		private static VertexLayout vertexLayout;

		private static ResetArray<Vertex2D> vertexArray;
 		private static ResetArray<uint16> indexArray;

		private static Rect[] ninceSliceTargetBuffer = new Rect[9] ~ delete _;
		private static Rect[] nineSliceTextureBuffer = new Rect[9] ~ delete _;

		// BATCHING STATE RELEVANT
		private static int currentOrder = 0;
		private static bool isInBatch = false;
		private static Matrix4x4 projectionMatrix;
		private static Texture2D[] textureCollection;
		private static SortOrder currentSortOrder;

		private static List<BatchElement> drawElements = new List<BatchElement>() ~ DeleteContainerAndItems!(_);
		private static MaterialInstanceProperties canvas3DMaterialProperties;
		private static Material blockModelMaterial;

		public static void OnShutdown()
		{
			GraphicsServer.DestroyResource(vertexBuffer);
			GraphicsServer.DestroyResource(indexBuffer);
			GraphicsServer.DestroyResource(shaderProgram);
			delete vertexLayout;
			delete vertexArray;
			delete indexArray;
			delete textureCollection;
			delete canvas3DMaterialProperties;
		}

		public static void OnLoad()
		{
			vertexArray = new ResetArray<Vertex2D>(MAX_VERTICES);
			indexArray = new ResetArray<uint16>(MAX_INDICES);
			textureCollection = new Texture2D[MAX_TEXTURES];

			vertexBuffer = GraphicsServer.CreateVertexBuffer(.DynamicDraw, MAX_VERTICES * sizeof(Vertex2D));
			indexBuffer = GraphicsServer.CreateIndexBuffer(.DynamicDraw, MAX_INDICES * sizeof(uint16));

			String vertexShaderText = ResourceServer.LoadTextFile("shaders/rp2d_vertex.glsl");
			String fragmentShaderText = ResourceServer.LoadTextFile("shaders/rp2d_fragment.glsl");

			vertexLayout = new VertexLayout(
				VertexLayoutElement("POSITION", .Vector4),
				VertexLayoutElement("TEXCOORD", .Vector2),
				VertexLayoutElement("COLOR", .Vector4)
				);

			shaderProgram = GraphicsServer.CreateShaderProgram(vertexShaderText, fragmentShaderText);

			// Create and initialize default chunck material
			String chunckVertex = ResourceServer.LoadTextFile("shaders/chunck_vertex.glsl");
			String chunckFragment = ResourceServer.LoadTextFile("shaders/chunck_fragment.glsl");
			ShaderProgram blockModelShader = GraphicsServer.CreateShaderProgram(chunckVertex, chunckFragment);
			blockModelMaterial = new Material(blockModelShader, RasterizerState(.Back, .CounterClockwise, false, false), BlendState(false), DepthState(false, false, .Always));

			canvas3DMaterialProperties = new MaterialInstanceProperties();
			canvas3DMaterialProperties.SetMaterialProperty("SUN_DIR", new MaterialParameterVector3(Vector3(0, 0, 1)));
			canvas3DMaterialProperties.SetMaterialProperty("SUN_COLOR", new MaterialParameterColor(Color(1, 1, 1)));
			canvas3DMaterialProperties.SetMaterialProperty("AMBIENT_COLOR", new MaterialParameterColor(Color(0.3f, 0.3f, 0.3f)));
		}

		public static void Begin(Matrix4x4 projection, SortOrder order = .BackToFront)
		{
			Debug.Assert(!isInBatch);

			ClearAndDeleteItems!(drawElements);
			currentSortOrder = order;
			projectionMatrix = projection;
			isInBatch = true;
		}

		public static void End()
		{
			Debug.Assert(isInBatch);

			switch(currentSortOrder)
			{
			case .BackToFront:
				drawElements.Sort(scope => Sort_BackToFront);
				break;
			case .FrontToBack:
				drawElements.Sort(scope => Sort_FrontToBack);
				break;
			}

			for(BatchElement element in drawElements)
			{
				// TODO: Move functionality to classes itself
				if(element is BatchElementTexturedQuad)
				{
					BatchElementTexturedQuad quad = element as BatchElementTexturedQuad;

					Validate(4, 6);

					int textureIndex = SearchTexture(quad.Texture);

					uint16 currentIndex = (uint16)vertexArray.Length;

					vertexArray.Add(Vertex2D(Vector4(quad.StartPosition.X, quad.StartPosition.Y, 0.0f, textureIndex), quad.TexRegionStart, quad.Tint));
					vertexArray.Add(Vertex2D(Vector4(quad.EndPosition.X, quad.StartPosition.Y, 0.0f, textureIndex), Vector2(quad.TexRegionEnd.X, quad.TexRegionStart.Y), quad.Tint));
					vertexArray.Add(Vertex2D(Vector4(quad.EndPosition.X, quad.EndPosition.Y, 0.0f, textureIndex), quad.TexRegionEnd, quad.Tint));
					vertexArray.Add(Vertex2D(Vector4(quad.StartPosition.X, quad.EndPosition.Y, 0.0f, textureIndex), Vector2(quad.TexRegionStart.X, quad.TexRegionEnd.Y), quad.Tint));

					indexArray.Add(currentIndex);
					indexArray.Add(currentIndex + 1);
					indexArray.Add(currentIndex + 2);
					indexArray.Add(currentIndex + 2);
					indexArray.Add(currentIndex + 3);
					indexArray.Add(currentIndex);
				}
			}

			FlushBatch();

			isInBatch = false;
		}

		private static int SearchTexture(Texture2D texture)
		{
			for(int i = 0; i < textureCollection.Count; i++)
			{
				if(textureCollection[i] == null)
				{
					textureCollection[i] = texture;
					return i;
				}
				else if(textureCollection[i] == texture)
				{
					return i;
				}
			}
			// Texture space exhausted, flush batch and start new one
			FlushBatch();
			return SearchTexture(texture);
		}

		private static void Validate(int vertexCap, int indexCap)
		{
			Debug.Assert(isInBatch);
			if(vertexArray.CapLeft < vertexCap) FlushBatch();
			else if(indexArray.CapLeft < indexCap) FlushBatch();
		}

		public static void FlushBatch()
		{
			// Upload vertex and index data
			GraphicsServer.UpdateVertexBuffer(vertexBuffer, 0, uint32(vertexArray.Length), vertexArray.Array);
			GraphicsServer.UpdateIndexBuffer(indexBuffer, 0, uint32(indexArray.Length), indexArray.Array);

			GraphicsServer.SetDepthState(DepthState(false, false, .LessEqual));
			GraphicsServer.SetRasterizerState(RasterizerState(.None, .Clockwise, false, false));
			GraphicsServer.SetBlendState(BlendState(true));

			GraphicsServer.SetVertexBuffer(vertexBuffer);
			GraphicsServer.SetIndexBuffer(indexBuffer);
			GraphicsServer.SetShaderProgram(shaderProgram);
			GraphicsServer.SetVertexLayout(vertexLayout);

			GraphicsServer.SetProgramParameter(shaderProgram, "PROJECTION", projectionMatrix);

			for(int i = 0; i < MAX_TEXTURES; i++)
			{
				String textureName = scope String()..AppendF("TEXTURES[{0}]", i);
				GraphicsServer.SetProgramTexture(shaderProgram, textureName, textureCollection[i], (uint)i);
			}

			GraphicsServer.DrawIndexedPrimitives(indexArray.Length);

			vertexArray.Clear();
			indexArray.Clear();
			for(int i = 0; i < textureCollection.Count; i++)
			{
				textureCollection[i] = null;
			}

			Performance.CurrentFrame.DrawCallsCanvas++;
		}

		// DRAWING METHODS

		public static void DrawBlockModel(BlockModel model, Vector3 position, Quaternion rotation, Vector3 scale)
		{
			// Need to flush this batch as we render a 3d model in GUI
			FlushBatch();

			Matrix4x4 transform = Matrix4x4.CreateScale(scale) * Matrix4x4.CreateFromQuaternion(rotation) * Matrix4x4.CreateTranslation(position);
			Matrix4x4 view = Matrix4x4.CreateLookAt(Vector3(0, 0, 0), Vector3(0, 0, -1.0f), Vector3.UnitY);

			ChunckMesh mesh = new ChunckMesh();
			Mesh resMesh = new Mesh(false);

			for (BakedQuad quad in model.Quads)
			{
				mesh.InsertQuad(quad, VoxelLights(0,0,0,15), Vector3.Zero);
			}
			mesh.Upload(resMesh);

			RenderPipeline3D.DrawMesh(resMesh, projectionMatrix, view, transform, ChunckVertex.Layout, blockModelMaterial, canvas3DMaterialProperties);

			delete mesh;
			delete resMesh;
		}

		public static void DrawTexturedRect(Rect targetRect, Texture2D texture, Rect textureRegion, Color tint = Color.White, int depth = 1)
		{
			BatchElementTexturedQuad quad = new BatchElementTexturedQuad();
			quad.Depth = depth;
			quad.SubmitOrder = currentOrder++;
			quad.StartPosition = targetRect.Position;
			quad.EndPosition = targetRect.Position + targetRect.Size;
			quad.TexRegionStart = textureRegion.Position * texture.TexelSize;
			quad.TexRegionEnd = textureRegion.End * texture.TexelSize;
			quad.Texture = texture;
			quad.Tint = tint;

			drawElements.Add(quad);
		}

		public static void DrawTexturedRect(Rect targetRect, Texture2D texture, Color tint = Color.White, int depth = 1)
		{
			DrawTexturedRect(targetRect, texture, Rect(0, 0, texture.Width, texture.Height), tint, depth);
		}

		public static void DrawNineSlice(Rect targetRect, Texture2D texture, Margin sliceBorder, Color tint, int depth = 1)
		{
			Utilities.CreatePatches(targetRect, ninceSliceTargetBuffer, sliceBorder);
			Utilities.CreatePatches(Rect(0, 0, texture.Width, texture.Height), nineSliceTextureBuffer, sliceBorder);

			for(int i = 0; i < ninceSliceTargetBuffer.Count; i++)
			{
				DrawTexturedRect(ninceSliceTargetBuffer[i], texture, nineSliceTextureBuffer[i], tint, depth);
			}
		}

		// END DRAWING METHODS

		// SORTING METHODS

		private static int Sort_BackToFront(BatchElement left, BatchElement right)
		{
			if (left.Depth > right.Depth) return 1;
			else if(left.Depth < right.Depth) return -1;
			else return Sort_SubmitOrder(left, right);
		}
		private static int Sort_FrontToBack(BatchElement left, BatchElement right)
		{
			if (left.Depth > right.Depth) return -1;
			else if(left.Depth < right.Depth) return 1;
			else return Sort_SubmitOrder(left, right);
		}
		private static int Sort_SubmitOrder(BatchElement left, BatchElement right)
		{
			if (left.SubmitOrder < right.SubmitOrder) return -1;
			else if (right.SubmitOrder > right.SubmitOrder) return 1;
			else return 0;
		}

		// END SORTING METHODS
	}
}
