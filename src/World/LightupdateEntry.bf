namespace Voxis
{
	public struct LightupdateEntry
	{
		public BlockPos Pos;
		public VoxelLights Light;

		public this(BlockPos pos, VoxelLights currentLight){
			Pos = pos;
			Light = currentLight;
		}
	}
}