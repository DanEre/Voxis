namespace Voxis
{
	public abstract class TerrainGenerator
	{
		public abstract int GetSurfaceHeight(BlockPos pos);

		public abstract void GenerateBaseTerrain(Chunck chunck);
		public abstract void GenerateFeatures(ChunckAccess access);
		public abstract void GenerateStructures(ChunckAccess access);
		public abstract void PostprocessTerrain(ChunckAccess access);
	}
}
