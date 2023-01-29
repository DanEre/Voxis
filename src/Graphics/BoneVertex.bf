namespace Voxis
{
	public struct BoneVertex
	{
		public Vector3 Position;
		public Vector2 UV;

		public this(float x, float y, float z, float uvX, float uvY)
		{
			Position = Vector3(x, y, z);
			UV = Vector2(uvX, uvY);
		}
	}
}
