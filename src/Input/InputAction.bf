namespace Voxis
{
	public enum InputAction
	{
		case Press;
		case Release;
		case Repeat;

		public bool IsPressOrRepeat
		{
			get
			{
				return this == .Press || this == .Repeat;
			}
		}
	}
}
