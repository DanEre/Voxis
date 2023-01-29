namespace Voxis
{
	public class PlantBlock : Block
	{
		public override bool DoesOcclude(BlockState state, OcclusionDirection direction)
		{
			return false;
		}
		public override bool GeneratesCollision(BlockState state)
		{
			return false;
		}
		public override bool HasCollision(BlockState state)
		{
			return false;
		}
	}
}
