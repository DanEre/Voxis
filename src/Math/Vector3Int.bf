namespace Voxis
{
	public struct Vector3Int
	{
		public int X;
		public int Y;
		public int Z;

		public this(int x, int y, int z)
		{
			X = x;
			Y = y;
			Z = z;
		}

		public static Vector3Int operator +(Vector3Int lhs, Vector3Int rhs)
		{
			return Vector3Int(lhs.X + rhs.X, lhs.Y + rhs.Y, lhs.Z + rhs.Z);
		}
	}
}