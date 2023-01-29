namespace Voxis
{
	public class InputEventMouseScroll : InputEvent
	{
		public float X { get; }
		public float Y { get; }

		public this(float x, float y)
		{
			X = x;
			Y = y;
		}
	}
}
