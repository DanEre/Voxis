using System;

namespace Voxis
{
	public static class ChunckMesher
	{
		public static void CreateMesh(ChunckAccess access)
		{
			Chunck workingChunck = access.GetWorkingChunck();
			ChunckIndex workingIndex = workingChunck.Index;
			ChunckMesh mesh = workingChunck.[Friend]chunckMesh;
			if (mesh == null) mesh = new ChunckMesh();

			mesh.Clear();

			for (int x = 0; x < Chunck.SIZE; x++)
			{
				for (int y = 0; y < Chunck.SIZE; y++)
				{
					for (int z = 0; z < Chunck.SIZE; z++)
					{
						BlockPos currentPos = BlockPos(x, y, z).AddChunckIndexOffset(workingIndex);
						BlockState currentBlockState = workingChunck.GetBlockState(x, y, z);
						BlockModel model = currentBlockState.Model;

						Vector3 offset = Vector3(x, y, z);

						// No Model baked. Dont render!
						if (model == null) continue;

						for(BakedQuad quad in model.Quads)
						{
							// TODO: Decouple occlusion dir from lighting dir
							VoxelLights lightValue = access.GetLight(currentPos);

							// If block has occlusion, check for it
							if (quad.OclDir != .None)
							{
								BlockPos nPos = currentPos.Offset(quad.OclDir);
	
								BlockState neighbourBlockState = access.GetBlockState(nPos);
	
								if (neighbourBlockState.DoesOcclude(quad.OclDir.Opposite))
								{
									continue;
								}

								lightValue = access.GetLight(currentPos.Offset(quad.OclDir));
							}

							mesh.InsertQuad(quad, lightValue, offset);
						}
					}
				}
			}

			workingChunck.[Friend]chunckMesh = mesh;

			workingChunck.MeshNeedsApply = true;

			access.UnlockChuncks();
		}
	}
}
