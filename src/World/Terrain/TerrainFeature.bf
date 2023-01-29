namespace Voxis
{
	public abstract class TerrainFeature
	{
		public abstract void Generate(ChunckAccess access, BlockPos worldPos, int surfaceHeight, System.Random random, TerrainGenerator generator);
	}
}
