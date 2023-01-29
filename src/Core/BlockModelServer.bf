using System;
using System.Collections;

namespace Voxis
{
	public static class BlockModelServer
	{
		public static void BakeModels()
		{
			for(Block block in GameRegistry.Block.Values)
			{
				if (block.ModelBaker == null)
				{
					LoggingServer.LogMessage("No Model Baked for Block with ID: {0}", .Error, block.RegistryID);
					continue;
				}
				for (BlockState state in block.BlockStateContainer.GetAll())
				{
					block.ModelBaker.BakeModel(state);
				}
			}
		}
	}
}
