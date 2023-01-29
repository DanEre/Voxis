namespace Voxis
{
	public class Mesh
	{
		private VertexBuffer vertexBuffer;
		private IndexBuffer indexBuffer;
		private bool isDynamic;

		public int IndexCount { get; private set; }

		public this(bool isDynamic)
		{
			this.isDynamic = isDynamic;
		}

		public ~this()
		{
			if (vertexBuffer != null) GraphicsServer.DestroyResource(vertexBuffer);
			if (indexBuffer != null) GraphicsServer.DestroyResource(indexBuffer);
		}

		public void SetVertices<T>(T* pointer, int32 length)
		{
			uint32 byteCount = uint32(length * sizeof(T));
			if (vertexBuffer == null)
			{
				vertexBuffer = GraphicsServer.CreateVertexBuffer(isDynamic ? .DynamicDraw : .StaticDraw, byteCount);
			}
			else if(vertexBuffer.Size < byteCount)
			{
				GraphicsServer.DestroyResource(vertexBuffer);

				vertexBuffer = GraphicsServer.CreateVertexBuffer(isDynamic ? .DynamicDraw : .StaticDraw, byteCount);
			}
			GraphicsServer.UpdateVertexBuffer(vertexBuffer, 0, byteCount, pointer);
		}

		public void SetIndices(uint16* pointer, int32 length)
		{
			uint32 byteSize = uint32(length * sizeof(uint16));
			if (indexBuffer == null)
			{
				indexBuffer = GraphicsServer.CreateIndexBuffer(isDynamic ? .DynamicDraw : .StaticDraw, byteSize);
			}
			else if(indexBuffer.Size < byteSize)
			{
				GraphicsServer.DestroyResource(indexBuffer);

				indexBuffer = GraphicsServer.CreateIndexBuffer(isDynamic ? .DynamicDraw : .StaticDraw, byteSize);
			}
			GraphicsServer.UpdateIndexBuffer(indexBuffer, 0, byteSize, pointer);

			IndexCount = length;
		}

		public void SetVertices<T>(T[] vertices) where T : struct
		{
			uint32 byteCount = uint32(vertices.Count * sizeof(T));
			if (vertexBuffer == null)
			{
				vertexBuffer = GraphicsServer.CreateVertexBuffer(isDynamic ? .DynamicDraw : .StaticDraw, byteCount);
			}
			else if(vertexBuffer.Size < byteCount)
			{
				GraphicsServer.DestroyResource(vertexBuffer);

				vertexBuffer = GraphicsServer.CreateVertexBuffer(isDynamic ? .DynamicDraw : .StaticDraw, byteCount);
			}
			GraphicsServer.UpdateVertexBuffer(vertexBuffer, 0, (uint32)vertices.Count, vertices);
		}
		public void SetIndices(uint16[] indices)
		{
			uint32 byteSize = uint32(indices.Count * sizeof(uint16));
			if (indexBuffer == null)
			{
				indexBuffer = GraphicsServer.CreateIndexBuffer(isDynamic ? .DynamicDraw : .StaticDraw, byteSize);
			}
			else if(indexBuffer.Size < byteSize)
			{
				GraphicsServer.DestroyResource(indexBuffer);

				indexBuffer = GraphicsServer.CreateIndexBuffer(isDynamic ? .DynamicDraw : .StaticDraw, byteSize);
			}
			GraphicsServer.UpdateIndexBuffer(indexBuffer, 0, uint32(indices.Count), indices);

			IndexCount = indices.Count;
		}
	}
}
