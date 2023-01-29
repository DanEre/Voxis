namespace Voxis
{
	public class ChunckMesh
	{
		// Allocate this buffer size
		public const int DEFAULT_BUFFER_SIZE = uint16.MaxValue;

		private ResetArray<ChunckVertex> vertices = new ResetArray<ChunckVertex>(DEFAULT_BUFFER_SIZE) ~ delete _;
		private ResetArray<uint16> indices = new ResetArray<uint16>(DEFAULT_BUFFER_SIZE) ~ delete _;

		public void InsertQuad(BakedQuad quad, VoxelLights lightvalue, Vector3 offset)
		{
			uint16 startIndex = (uint16)vertices.Length;

			// Convert and add vertices
			for(int i = 0; i < quad.Vertices.Count; i++)
			{
				ChunckVertex chunckVertex = ChunckVertex()
				{
					Position = quad.Vertices[i] + offset,
					TexCoord = quad.Texcoords[i],
					TexIndex = quad.TexIndices,
					Normal = quad.Normal,
					Color = lightvalue.ToColor32()
				};

				vertices.Add(chunckVertex);
			}

			// Add quad indices as triangle
			indices.AddRange(startIndex, startIndex + 1, startIndex + 2, startIndex + 2, startIndex + 3, startIndex);
		}

		public void Clear()
		{
			vertices.Clear();
			indices.Clear();
		}

		public void Upload(Mesh targetMesh)
		{
			targetMesh.SetVertices(vertices.PointerFirst, (int32)vertices.Length);
			targetMesh.SetIndices(indices.PointerFirst, (int32)indices.Length);
		}
	}
}
