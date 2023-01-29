namespace Voxis
{
	public enum BlockDirection
	{
		case RIGHT = 0;
		case LEFT = 1;
		case UP = 2;
		case DOWN = 3;
		case FRONT = 4;
		case BACK = 5;

		public static BlockDirection[6] All
		{
			get
			{
				return BlockDirection[]
				(
					.RIGHT,
					.LEFT,
					.UP,
					.DOWN,
					.FRONT,
					.BACK
				);
			}
		}
	}
}