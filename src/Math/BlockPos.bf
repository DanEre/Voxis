namespace Voxis
{
	public struct BlockPos
	{
		public int X, Y, Z;

		public this(int x, int y, int z)
		{
			X = x;
			Y = y;
			Z = z;
		}

		public ChunckIndex GetChunckIndex()
		{
			return ChunckIndex(int16(X >> Chunck.LOG_SIZE), int16(Y >> Chunck.LOG_SIZE), int16(Z >> Chunck.LOG_SIZE));
		}

		public (int x, int y, int z) GetChunckLocalPosition()
		{
			return (X & Chunck.MASK, Y & Chunck.MASK, Z & Chunck.MASK);
		}

		public BlockPos AddChunckIndexOffset(ChunckIndex index)
		{
			return BlockPos(X + index.X * Chunck.SIZE, Y + index.Y * Chunck.SIZE, Z + index.Z * Chunck.SIZE);
		}

		public BlockPos Offset(OcclusionDirection direction)
		{
			switch(direction){
			case .Back:
				return BlockPos(X, Y, Z - 1);
			case .Down:
				return BlockPos(X, Y - 1, Z);
			case .Front:
				return BlockPos(X, Y, Z + 1);
			case .Left:
				return BlockPos(X - 1, Y, Z);
			case .Right:
				return BlockPos(X + 1, Y, Z);
			case .Up:
				return BlockPos(X, Y + 1, Z);
			default:
				System.Runtime.FatalError("Invalid direction supplied!");
			}
		}

		public BlockPos Offset(BlockDirection dir)
		{
			switch (dir)
			{
			case .BACK:
				return BlockPos(X, Y, Z - 1);
			case .FRONT:
				return BlockPos(X, Y, Z + 1);
			case .LEFT:
				return BlockPos(X - 1, Y, Z);
			case .RIGHT:
				return BlockPos(X + 1, Y, Z);
			case .UP:
				return BlockPos(X, Y + 1, Z);
			case .DOWN:
				return BlockPos(X, Y - 1, Z);
			default:
				System.Runtime.FatalError("Invalid direction supplied!");
			}
		}

		public Vector3 ToVector()
		{
			return Vector3(X, Y, Z);
		}

		public static BlockPos FromVector(Vector3 vec)
		{
			return BlockPos(
				int(System.Math.Floor(vec.X)),
				int(System.Math.Floor(vec.Y)),
				int(System.Math.Floor(vec.Z))
				);
		}
		public static BlockPos FromVectorI(Vector3Int vec)
		{
			return BlockPos(vec.X, vec.Y, vec.Z);
		}
	}
}
