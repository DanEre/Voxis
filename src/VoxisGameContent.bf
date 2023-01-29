namespace Voxis
{
	public static class VoxisGameContent
	{
		public static Block Dirt = new Block();
		public static Block Grass = new Block();
		public static Block Stone = new Block();
		public static Block Gravel = new Block();
		public static Block Sand = new Block();

		public static Block Cactus = new Block();

		static this()
		{
			Dirt.ModelBaker = new CubeModelBaker("dirt");
			Grass.ModelBaker = new CubeModelBaker("grass_top", "dirt", "grass_side", "grass_side", "grass_side", "grass_side");
			Stone.ModelBaker = new CubeModelBaker("stone");
			Gravel.ModelBaker = new CubeModelBaker("gravel");
			Sand.ModelBaker = new CubeModelBaker("sand");

			Cactus.ModelBaker = new CubeModelBaker("cactus_top", "cactus_bottom", "cactus_side", "cactus_side", "cactus_side", "cactus_side");
		}

		public static void RegisterContent()
		{
			// VERY IMPORTANT
			GameRegistry.Block.RegisterObject("air", AirBlock.DEFAULT_AIR);

			RegisterBlocks();

			RegisterBiomes();
		}

		private static void RegisterBiomes()
		{
			SimpleTerrainBiome plains = new SimpleTerrainBiome(Grass.DefaultState, Dirt.DefaultState, Stone.DefaultState, 0.5f, 0.3f, 0.35f);
			SimpleTerrainBiome desert = new SimpleTerrainBiome(Sand.DefaultState, Sand.DefaultState, Stone.DefaultState, 1.0f, 0.0f, 0.35f);
			SimpleTerrainBiome hills = new SimpleTerrainBiome(Stone.DefaultState, Stone.DefaultState, Stone.DefaultState, 0.0f, 0.7f, 0.7f);

			GameRegistry.Biome.RegisterObject("plains", plains);
			GameRegistry.Biome.RegisterObject("desert", desert);
			GameRegistry.Biome.RegisterObject("hills", hills);

			desert.AddFeature(new PlacementFeature(Cactus.DefaultState, Sand.DefaultState, 0.03f));
		}

		private static void RegisterBlocks()
		{
			GameRegistry.Block.RegisterObject("dirt", Dirt);
			GameRegistry.Block.RegisterObject("stone", Stone);
			GameRegistry.Block.RegisterObject("grass", Grass);
			GameRegistry.Block.RegisterObject("gravel", Gravel);
			GameRegistry.Block.RegisterObject("sand", Sand);

			GameRegistry.Block.RegisterObject("cactus", Cactus);
		}
	}
}
