namespace Voxis
{
	public class PlacementFeature : TerrainFeature
	{
		public BlockState BlockToPlace { get; }
		public BlockState UnderBlock { get; }
		public float Chance { get; }

		public this(BlockState blockToPlace, BlockState underBlock, float chance)
		{
			BlockToPlace = blockToPlace;
			UnderBlock = underBlock;
			Chance = chance;
		}

		public override void Generate(ChunckAccess access, BlockPos worldPos, int surfaceHeight, System.Random random, TerrainGenerator generator)
		{
			if (worldPos.Y == surfaceHeight && random.NextDouble() < Chance && access.GetBlockState(worldPos) == UnderBlock)
			{
				access.SetBlockState(worldPos.Offset(OcclusionDirection.Up), BlockToPlace, BlockstatUpdateFlags.None);
			}
		}
	}
}
