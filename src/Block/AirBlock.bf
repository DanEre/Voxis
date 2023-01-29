namespace Voxis
{
	public sealed class AirBlock : Block
	{
		public static AirBlock DEFAULT_AIR;
		public static BlockState DEFAULT_AIR_STATE;

		static this()
		{
			DEFAULT_AIR = new AirBlock();
			DEFAULT_AIR_STATE = DEFAULT_AIR.BlockStateContainer.DefaultState;
		}

		public override bool DoesOcclude(BlockState state, OcclusionDirection direction)
		{
			return false;
		}
		public override bool DoesRender(BlockState state)
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
		public override bool LetsLightThrough(BlockState state)
		{
			return true;
		}
	}
}