using System;

namespace Voxis
{
	public struct ChunckIndex : IHashable
	{
		public int16 X;
		public int16 Y;
		public int16 Z;

		public this(int16 x, int16 y, int16 z)
		{
			X = x;
			Y = y;
			Z = z;
		}

		public int GetHashCode()
		{
			return int32(X) | (int32(Z) << 16) ^ Y;
		}

		public ChunckIndex Offset(int16 x, int16 y, int16 z)
		{
			return ChunckIndex(X + x, Y + y, Z + z);
		}

		public override void ToString(String strBuffer)
		{
			strBuffer.AppendF("{{0}, {1}, {2}}", X, Y, Z);
		}

		public static ChunckIndex FromPosition(Vector3 pos)
		{
			return ChunckIndex(int16(pos.X) >> Chunck.LOG_SIZE, int16(pos.Y) >> Chunck.LOG_SIZE, int16(pos.Z) >> Chunck.LOG_SIZE);
		}
	}
}
