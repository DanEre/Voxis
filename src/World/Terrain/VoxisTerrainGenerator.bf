namespace Voxis
{
	public class VoxisTerrainGenerator : TerrainGenerator
	{
		private const float OceanFloorHeight = 32.0f;
		private const float TerrainHeightLimit = 128.0f;

		private OpenSimplex2S temperatureNoise = new OpenSimplex2S(69) ~ delete _;
		private OpenSimplex2S humidityNoise = new OpenSimplex2S(88) ~ delete _;
		private OpenSimplex2S heightNoise = new OpenSimplex2S(54) ~ delete _;

		private Biome[] allBiomes;

		private BakedCurve bakedTerrainCurve;

		public this()
		{
			// Cache all biomes
			allBiomes = GameRegistry.Biome.GetAllAsArray();

			Curve terrainHeightCurve = scope Curve();

			// Populate terrain height curve
			// Ocean floor
			terrainHeightCurve.AddPoint(0.0f, 0.0f);
			terrainHeightCurve.AddPoint(0.15f, 0.0f);
			// Beaches
			terrainHeightCurve.AddPoint(0.2f, 0.3f);
			// Forest
			terrainHeightCurve.AddPoint(0.5f, 0.4f);
			// Hills
			terrainHeightCurve.AddPoint(0.7f, 1.0f);

			bakedTerrainCurve = new BakedCurve(terrainHeightCurve);
		}

		public ~this()
		{
			delete bakedTerrainCurve;
			delete allBiomes;
		}

		public override int GetSurfaceHeight(BlockPos position)
		{
			// Generate base height noise
			double unsampledHeight = heightNoise.Noise2FBM(position.X, position.Z, 6, 0.7, 0.001, 2.2, 0.6);
			unsampledHeight = (unsampledHeight + 1.0) * 0.5;
			unsampledHeight = System.Math.Clamp(unsampledHeight, 0.0, 1.0);
			float sampled = OceanFloorHeight + bakedTerrainCurve.Interpolate(float(unsampledHeight)) * (TerrainHeightLimit - OceanFloorHeight);

			return int(sampled);
		}

		public override void GenerateBaseTerrain(Chunck chunck)
		{
			for(int x = 0; x < Chunck.SIZE; x++)
			{
				for (int z = 0; z < Chunck.SIZE; z++)
				{
					Biome realBiome = GetBiomeAtPos(BlockPos(x, 0, z).AddChunckIndexOffset(chunck.Index));
					int height = GetSurfaceHeight(BlockPos(x, 0, z).AddChunckIndexOffset(chunck.Index));

					for (int y = 0; y < Chunck.SIZE; y++)
					{
						BlockState targetBlock = realBiome.GetTerrainBlock(BlockPos(x, y,z).AddChunckIndexOffset(chunck.Index), height);

						// No BlockState updates because of performance
						chunck.SetBlockState(x, y, z, targetBlock, BlockstatUpdateFlags.None);

						// Only handle sky light propagation if truly is air
						if (targetBlock != AirBlock.DEFAULT_AIR_STATE) continue;

						chunck.SetLightRaw(x, y, z, VoxelLights(0, 0, 0, 15));
					}
				}
			}

			chunck.SetFlag(.TerrainGenerated);
			chunck.MeshDirty = true;

			chunck.Locked = false;
		}

		public override void GenerateFeatures(ChunckAccess access)
		{
			System.Random random = scope System.Random(access.GetWorkingChunck().Index.GetHashCode());

			Chunck workingChunck = access.GetWorkingChunck();

			for (int x = 0; x < Chunck.SIZE; x++)
			{
				for (int z = 0; z < Chunck.SIZE; z++)
				{
					BlockPos columnPos = BlockPos(x, 0, z).AddChunckIndexOffset(workingChunck.Index);
					int surfaceHeight = GetSurfaceHeight(BlockPos(x, 0,z).AddChunckIndexOffset(workingChunck.Index));
					Biome biome = GetBiomeAtPos(columnPos);

					for (int y = 0; y < Chunck.SIZE; y++)
					{
						BlockPos realPos = BlockPos(x, y, z).AddChunckIndexOffset(workingChunck.Index);
						biome.GenerateFeatures(access, realPos, surfaceHeight, random, this);
					}
				}
			}

			workingChunck.SetFlag(.FeaturesGenerated);

			access.UnlockChuncks();
		}

		public override void GenerateStructures(ChunckAccess access)
		{
			access.GetWorkingChunck().SetFlag(.StructuresGenerated);

			access.UnlockChuncks();
		}

		public override void PostprocessTerrain(ChunckAccess access)
		{
			access.GetWorkingChunck().SetFlag(.Postprocessed);

			access.UnlockChuncks();
		}

		private Biome GetBiomeAtPos(BlockPos pos)
		{
			// Generate parameters
			float temperature = float(temperatureNoise.Noise2(pos.X * 0.01f, pos.Z * 0.01f));
			float humidity =float(humidityNoise.Noise2(pos.X * 0.01f, pos.Z * 0.01f));
			float height = float(heightNoise.Noise2(pos.X * 0.01f, pos.Z * 0.01f));

			// Find the nearest Biome with corresponding values
			Biome nearest = allBiomes[0];
			float distance = Vector3.DistanceSquared(Vector3(nearest.Temperature, nearest.Humidity, nearest.Height), Vector3(temperature, humidity, height));

			for (Biome biome in allBiomes)
			{
				float newDist = Vector3.DistanceSquared(Vector3(biome.Temperature, biome.Humidity, biome.Height), Vector3(temperature, humidity, height));
				if (newDist < distance)
				{
					nearest = biome;
					distance = newDist;
				}
			}

			return nearest;
		}

		private Biome GetBiomeAtIndex(ChunckIndex index)
		{
			return GetBiomeAtPos(BlockPos(0, 0, 0).AddChunckIndexOffset(index));
		}
	}
}
