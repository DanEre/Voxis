using System;

namespace Voxis
{
	public static class RenderPipeline3D
	{
		// Basic Shader Programs for rendering
		public static ShaderProgram DefaultOpaque { get; private set; }
		public static ShaderProgram DefaultCutout { get; private set; }
		public static ShaderProgram DefaultTransparent { get; private set; }
		public static ShaderProgram DefaultChunckShader { get; private set; }
		public static ShaderProgram DefaultSkyboxShader { get; private set; }

		// Default 3D vertex layout
		public static VertexLayout DefaultVertexLayout { get; private set; }

		// Builtin template materials
		public static Material DefaultOpaqueMaterial { get; private set; }
		public static Material DefaultCutoutMaterial { get; private set; }
		public static Material DefaultTransparentMaterial { get; private set; }
		public static Material ChunckRenderMaterial { get; private set; }
		public static Material DefaultSkyboxMaterial { get; private set; }

		public static EnvironmentSettings Environment { get; set; }

		// Utility Meshes
		public static Mesh CubeMesh { get; private set; }

		public static void OnLoad()
		{
			String vertexText = ResourceServer.LoadTextFile("shaders/default_vertex.glsl");

			String opaqueText = ResourceServer.LoadTextFile("shaders/default_frag_opaque.glsl");
			String cutoutText = ResourceServer.LoadTextFile("shaders/default_frag_cutout.glsl");
			String transparentText = ResourceServer.LoadTextFile("shaders/default_frag_transparent.glsl");

			DefaultOpaque = GraphicsServer.CreateShaderProgram(vertexText, opaqueText);
			DefaultCutout = GraphicsServer.CreateShaderProgram(vertexText, cutoutText);
			DefaultTransparent = GraphicsServer.CreateShaderProgram(vertexText, transparentText);

			DefaultVertexLayout = new VertexLayout(
				VertexLayoutElement("POSITION", .Vector3),
				VertexLayoutElement("TEXCOORD", .Vector2),
				VertexLayoutElement("COLOR", .Vector4),
				VertexLayoutElement("NORMAL", .Vector3)
				);

			// Create and initialize generic 3D materials
			DefaultOpaqueMaterial = new Material(DefaultOpaque, RasterizerState(.Back, .CounterClockwise, false, false), BlendState(false), DepthState(true, true, .Less));
			DefaultTransparentMaterial = new Material(DefaultTransparent, RasterizerState(.Back, .CounterClockwise, false, false), BlendState(true), DepthState(true, false, .Less));
			DefaultCutoutMaterial = new Material(DefaultCutout, RasterizerState(.Back, .CounterClockwise, false, false), BlendState(false), DepthState(true, true, .Less));

			// Set default texture of material to white
			DefaultOpaqueMaterial.SetMaterialProperty("MAIN_TEX", new MaterialParameterTexture2D(GraphicsServer.WhiteTexture));

			// Create and initialize default chunck material
			String chunckVertex = ResourceServer.LoadTextFile("shaders/chunck_vertex.glsl");
			String chunckFragment = ResourceServer.LoadTextFile("shaders/chunck_fragment.glsl");
			DefaultChunckShader = GraphicsServer.CreateShaderProgram(chunckVertex, chunckFragment);
			ChunckRenderMaterial = new Material(DefaultChunckShader, RasterizerState(.Back, .CounterClockwise, false, false), BlendState(false), DepthState(true, true, .Less));

			// Create and initialize default skybox material
			String skyboxVertex = ResourceServer.LoadTextFile("shaders/skybox_vertex.glsl");
			String skyboxFragment = ResourceServer.LoadTextFile("shaders/skybox_fragment.glsl");
			DefaultSkyboxShader = GraphicsServer.CreateShaderProgram(skyboxVertex, skyboxFragment);
			DefaultSkyboxMaterial = new Material(DefaultSkyboxShader, RasterizerState(.None, .CounterClockwise, false, false), BlendState(false), DepthState(true, true, .Less));

			Vertex3D[] cubeVertices = scope Vertex3D[](
				// Back
				Vertex3D(Vector3(-1, -1, -1), Vector2(0, 0), .White, Vector3(0, 0, -1)),
				Vertex3D(Vector3(-1, 1, -1), Vector2(0, 1), .White, Vector3(0, 0, -1)),
				Vertex3D(Vector3(1, 1, -1), Vector2(1, 1), .White, Vector3(0, 0, -1)),
				Vertex3D(Vector3(1, -1, -1), Vector2(1, 0), .White, Vector3(0, 0, -1)),

				// Front
				Vertex3D(Vector3(1, -1, 1), Vector2(0, 0), .White, Vector3(0, 0, 1)),
				Vertex3D(Vector3(1, 1, 1), Vector2(0, 1), .White, Vector3(0, 0, 1)),
				Vertex3D(Vector3(-1, 1, 1), Vector2(1, 1), .White, Vector3(0, 0, 1)),
				Vertex3D(Vector3(-1, -1, 1), Vector2(1, 0), .White, Vector3(0, 0, 1)),

				// Left
				Vertex3D(Vector3(-1, -1, 1), Vector2(0, 0), .White, Vector3(-1, 0, 0)),
				Vertex3D(Vector3(-1, 1, 1), Vector2(0, 1), .White, Vector3(-1, 0, 0)),
				Vertex3D(Vector3(-1, 1, -1), Vector2(1, 1), .White, Vector3(-1, 0, 0)),
				Vertex3D(Vector3(-1, -1, -1), Vector2(1, 0), .White, Vector3(-1, 0, 0)),

				// Right
				Vertex3D(Vector3(1, -1, -1), Vector2(0, 0), .White, Vector3(1, 0, 0)),
				Vertex3D(Vector3(1, 1, -1), Vector2(0, 1), .White, Vector3(1, 0, 0)),
				Vertex3D(Vector3(1, 1, 1), Vector2(1, 1), .White, Vector3(1, 0, 0)),
				Vertex3D(Vector3(1, -1, 1), Vector2(1, 0), .White, Vector3(1, 0, 0)),

				// Bottom
				Vertex3D(Vector3(-1, -1, 1), Vector2(0, 0), .White, Vector3(0, -1, 0)),
				Vertex3D(Vector3(-1, -1, -1), Vector2(0, 1), .White, Vector3(0, -1, 0)),
				Vertex3D(Vector3(1, -1, -1), Vector2(1, 1), .White, Vector3(0, -1, 0)),
				Vertex3D(Vector3(1, -1, 1), Vector2(1, 0), .White, Vector3(0, -1, 0)),

				// Top
				Vertex3D(Vector3(-1, 1, -1), Vector2(0, 0), .White, Vector3(0, 1, 0)),
				Vertex3D(Vector3(-1, 1, 1), Vector2(0, 1), .White, Vector3(0, 1, 0)),
				Vertex3D(Vector3(1, 1, 1), Vector2(1, 1), .White, Vector3(0, 1, 0)),
				Vertex3D(Vector3(1, 1, -1), Vector2(1, 0), .White, Vector3(0, 1, 0))
				);
			uint16[] cubeIndices = scope uint16[](
				0, 1, 2,
				2, 3, 0,

				4, 5, 6,
				6, 7, 4,

				8, 9, 10,
				10, 11, 8,

				12, 13, 14,
				14, 15, 12,

				16, 17, 18,
				18, 19, 16,

				20, 21, 22,
				22, 23, 20
			);

			CubeMesh = new Mesh(false);
			CubeMesh.SetVertices(cubeVertices);
			CubeMesh.SetIndices(cubeIndices);
		}

		public static void OnShutdown()
		{
			delete DefaultVertexLayout;

			delete ChunckRenderMaterial;

			delete DefaultOpaqueMaterial;
			delete DefaultCutoutMaterial;
			delete DefaultTransparentMaterial;
			delete DefaultSkyboxMaterial;

			delete CubeMesh;
		}

		public static void ApplyMaterial(Material material)
		{
			GraphicsServer.SetShaderProgram(material.Shader);

			// Apply builtin world parameters
			GraphicsServer.SetProgramParameter(material.Shader, "SUN_DIR", Environment.SunDirection);
			GraphicsServer.SetProgramParameter(material.Shader, "SUN_COLOR", Environment.SunColor);
			GraphicsServer.SetProgramParameter(material.Shader, "AMBIENT_COLOR", Environment.AmbientColor);
			GraphicsServer.SetProgramParameter(material.Shader, "TIME", float(Time.Elapsed));
			GraphicsServer.SetProgramParameter(material.Shader, "FOG_COLOR", Environment.FogColor);
			GraphicsServer.SetProgramParameter(material.Shader, "FOG_DENSITY", Environment.FogDensity);

			// Apply material specific parameters
			material.Apply();

			// Apply rendering states
			GraphicsServer.SetBlendState(material.BlendState);
			GraphicsServer.SetDepthState(material.DepthState);
			GraphicsServer.SetRasterizerState(material.RasterizerState);
		}

		// Draws a mesh
		public static void DrawMesh(Mesh mesh, Matrix4x4 projection, Matrix4x4 view, Matrix4x4 modelMatrix, VertexLayout vertexLayout, Material material)
		{
			ApplyMaterial(material);

			GraphicsServer.SetProgramParameter(material.Shader, "PROJECTION", projection);
			GraphicsServer.SetProgramParameter(material.Shader, "VIEW", view);
			GraphicsServer.SetProgramParameter(material.Shader, "MODEL", modelMatrix);

			GraphicsServer.SetVertexLayout(vertexLayout);

			GraphicsServer.SetVertexBuffer(mesh.[Friend]vertexBuffer);
			GraphicsServer.SetIndexBuffer(mesh.[Friend]indexBuffer);

			GraphicsServer.DrawIndexedPrimitives(mesh.IndexCount);

			Performance.CurrentFrame.DrawCalls3D++;
		}

		public static void DrawMesh(Mesh mesh, Matrix4x4 projection, Matrix4x4 view, Matrix4x4 modelMatrix, VertexLayout vertexLayout, Material material, MaterialInstanceProperties overrideProps)
		{
			ApplyMaterial(material);

			overrideProps.Apply(material);

			GraphicsServer.SetProgramParameter(material.Shader, "PROJECTION", projection);
			GraphicsServer.SetProgramParameter(material.Shader, "VIEW", view);
			GraphicsServer.SetProgramParameter(material.Shader, "MODEL", modelMatrix);

			GraphicsServer.SetVertexLayout(vertexLayout);

			GraphicsServer.SetVertexBuffer(mesh.[Friend]vertexBuffer);
			GraphicsServer.SetIndexBuffer(mesh.[Friend]indexBuffer);

			GraphicsServer.DrawIndexedPrimitives(mesh.IndexCount);

			Performance.CurrentFrame.DrawCalls3D++;
		}
	}
}
