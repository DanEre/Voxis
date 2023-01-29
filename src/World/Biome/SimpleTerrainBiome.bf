namespace Voxis
{
	public class SimpleTerrainBiome : Biome
	{
		private BlockState coverBlock, shallowBlock, deepBlock;

		private float baseHeight, heightAmplitude, noiseScale;

		private OpenSimplex2S heightNoise = new OpenSimplex2S(1132) ~ delete _;

		public this(BlockState cover, BlockState shallow, BlockState deep, float temp, float hum, float height)
		{
			coverBlock = cover;
			shallowBlock = shallow;
			deepBlock = deep;

			Temperature = temp;
			Humidity = hum;
			Height = height;
		}

		public override BlockState GetTerrainBlock(BlockPos pos, int height)
		{
			if (pos.Y > height) return AirBlock.DEFAULT_AIR_STATE;
			else if (pos.Y == height) return coverBlock;
			else if (pos.Y > height - 5) return shallowBlock;
			else return deepBlock;
		}
	}
}
