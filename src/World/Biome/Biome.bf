using System;
using System.Collections;

namespace Voxis
{
	public abstract class Biome : RegistryObject
	{
		public float Temperature { get; protected set; }
		public float Humidity { get; protected set; }
		public float Height { get; protected set; }

		public abstract BlockState GetTerrainBlock(BlockPos pos, int height);

		private List<TerrainFeature> features = new List<TerrainFeature>() ~ DeleteContainerAndItems!(_);

		public void GenerateFeatures(ChunckAccess access, BlockPos worldPos, int surfaceHeight, Random random, TerrainGenerator generator)
		{
			for(TerrainFeature feature in features)
			{
				feature.Generate(access, worldPos, surfaceHeight, random, generator);
			}
		}

		public void AddFeature(TerrainFeature feature)
		{
			features.Add(feature);
		}
	}
}
