namespace Voxis
{
	public class Lamp : Block
	{
		public override VoxelLights GetLightValue(BlockState state)
		{
			return VoxelLights(15, 0, 0, 0);
		}
	}
}