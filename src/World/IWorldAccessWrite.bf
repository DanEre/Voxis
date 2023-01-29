namespace Voxis
{
	public interface IWorldAccessWrite
	{
		void SetBlockState(BlockPos position, BlockState state, BlockstatUpdateFlags flags);
	}
}
