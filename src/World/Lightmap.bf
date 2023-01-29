using System;
using System.Collections;

namespace Voxis
{
	public class Lightmap
	{
		private VoxelLights[,,] lightValues = new VoxelLights[Chunck.SIZE, Chunck.SIZE, Chunck.SIZE]() ~ delete _;

		public void SetLight(int x, int y, int z, VoxelLights val)
		{
			lightValues[x, y, z] = val;
		}
		public VoxelLights GetLight(int x, int y, int z)
		{
			return lightValues[x, y, z];
		}

		public static void GenerateLightmap(ChunckAccess access)
		{
			Chunck workingChunck = access.GetWorkingChunck();

			Queue<BlockPos> lightQueue = workingChunck.[Friend]lightUpdateQueue;
			Queue<LightupdateEntry> removalQueue = workingChunck.[Friend]lightRemovalQueue;

			// Remove lights
			while(!removalQueue.IsEmpty)
			{
				LightupdateEntry entry = removalQueue.PopFront();
				VoxelLights watedLight = entry.Light;
				VoxelLights isLight = access.GetLight(entry.Pos);

				access.SetLightNoUpdate(entry.Pos, watedLight);

				for (BlockDirection dir in BlockDirection.All)
				{
					BlockPos offsetPos = entry.Pos.Offset(dir);
					VoxelLights neighbourLight = access.GetLight(offsetPos);

					bool removal = false;
					bool propagation = false;

					VoxelLights newNeighbourLight = neighbourLight;

					// RGB
					for (int ci = 0; ci < 4; ci++)
					{
						if (ci == 3 && dir == .DOWN && isLight.S == 15)
						{
							newNeighbourLight[ci] = 0;
							removal = true;
						}
						else if (neighbourLight[ci] != 0 && neighbourLight[ci] < isLight[ci])
						{
							newNeighbourLight[ci] = 0;
							removal = true;
						}
						else if(neighbourLight[ci] > 0 && neighbourLight[ci] >= isLight[ci])
						{
							propagation = true;
						}
					}

					if (removal)
					{
						removalQueue.Add(LightupdateEntry(offsetPos, newNeighbourLight));
					}
					if (propagation)
					{
						lightQueue.Add(offsetPos);
					}
				}
			}

			// Spreading new light values
			while (!lightQueue.IsEmpty)
			{
				BlockPos worldPos = lightQueue.PopFront();

				VoxelLights thisLightlevel = access.GetLight(worldPos);

				for (BlockDirection dir in BlockDirection.All)
				{
					BlockPos neighbourPos = worldPos.Offset(dir);

					BlockState neighbourBlockstate = access.GetBlockState(neighbourPos);

					if (!neighbourBlockstate.LetsLightThrough()) continue;

					VoxelLights neighbourLightlevel = access.GetLight(neighbourPos);

					// Add to update queue if a light component changed
					bool enqueue = false;

					VoxelLights newLight = thisLightlevel;

					// RGB Lights
					for (int ci = 0; ci < 3; ci++)
					{
						if (neighbourLightlevel[ci] + 2 > thisLightlevel[ci])
							continue;

						newLight[ci] = thisLightlevel[ci - 1];

						enqueue = true;
					}

					// Skylights
					// Infinite downwards light propagation
					if (dir == .DOWN && thisLightlevel.S == 15 && neighbourLightlevel.S != 15)
					{
						newLight[3] = 15;
						enqueue = true;
					}
					// Normal skylight propagation
					else if (neighbourLightlevel[3] + 1 < thisLightlevel[3])
					{
						newLight[3] = thisLightlevel[3] - 1;

						enqueue = true;
					}

					if (enqueue)
					{
						access.SetLightNoUpdate(neighbourPos, newLight);
						lightQueue.Add(neighbourPos);
					}
				}
			}

			workingChunck.LightmapDirty = false;
			workingChunck.MeshDirty = true;
			access.UnlockChuncks();
		}
	}
}