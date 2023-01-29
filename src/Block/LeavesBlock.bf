namespace Voxis
{
	public class LeavesBlock : Block
	{
		public override bool DoesOcclude(BlockState state, OcclusionDirection direction)
		{
			return false;
		}
	}
}
