namespace Voxis
{
	public static class GameRegistry
	{
		public static Registry<Block> Block = new Registry<Block>();
		public static Registry<Biome> Biome = new Registry<Biome>();

		static ~this()
		{
			delete Block;
			delete Biome;
		}
	}
}