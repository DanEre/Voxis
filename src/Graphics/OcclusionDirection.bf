namespace Voxis
{
	public enum OcclusionDirection
	{
		case None;
		case Right;
		case Left;
		case Up;
		case Down;
		case Front;
		case Back;

		public OcclusionDirection Opposite
		{
			get
			{
				switch(this)
				{
				case Right:
					return .Left;
				case .Left:
					return .Right;
				case .Down:
					return .Up;
				case .Up:
					return .Down;
				case .Front:
					return .Back;
				case .Back:
					return .Front;
				default:
					System.Runtime.FatalError("Cannot take opposite of this direction!");
				}
			}
		}
	}
}
