namespace Voxis
{
	public class InputEventMouseMovement : InputEvent
	{
		public float NewX { get; }
		public float NewY { get; }
		public float DeltaX { get; }
		public float DeltaY { get; }

		public Vector2 Position
		{
			get
			{
				return Vector2(NewX, NewY);
			}
		}

		public this(float newx, float newy, float deltax, float deltay)
		{
			NewX = newx;
			NewY = newy;
			DeltaX = deltax;
			DeltaY = deltay;
		}
	}
}
