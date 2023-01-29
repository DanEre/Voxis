namespace Voxis
{
	public class BakedQuad
	{
		public Vector3[] Vertices;
		public Vector2[] Texcoords;

		public Vector2 TexIndices;
		public Vector3 Normal;
		public OcclusionDirection OclDir;

		public ~this()
		{
			delete Vertices;
			delete Texcoords;
		}

		public void NormalFromVertices()
		{
			Normal = Vector3.Cross(Vertices[1] - Vertices[0], Vertices[2] - Vertices[1]);
		}

		public void Rotate(Vector3 angles)
		{
			System.Runtime.NotImplemented();
		}
	}
}
