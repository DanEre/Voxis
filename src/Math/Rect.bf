namespace Voxis
{
	public struct Rect
	{
		public float X;
		public float Y;
		public float Width;
		public float Height;

		public float XMax
		{
			get
			{
				return X + Width;
			}
		}
		public float YMax
		{
			get
			{
				return Y + Height;
			}
		}
		public Vector2 Position
		{
			get
			{
				return Vector2(X, Y);
			}
		}
		public Vector2 Size
		{
			get
			{
				return Vector2(Width, Height);
			}
		}
		public Vector2 End
		{
			get
			{
				return Position + Size;
			}
		}

		public this(float x, float y, float width, float height)
		{
			X = x;
			Y = y;
			Width = width;
			Height = height;
		}

		public bool ContainsPoint(Vector2 point)
		{
			return point.X >= X && point.X <= XMax && point.Y >= Y && point.Y <= YMax;
		}

		public static Rect FromMinMax(Vector2 min, Vector2 max)
		{
			return Rect(min.X, min.Y, max.X - min.X, max.Y - min.Y);
		}

		public Rect ApplyMargin(Margin margin)
		{
			return Rect(X + margin.Left, Y + margin.Top, Width - margin.Left - margin.Right, Height - margin.Top - margin.Bottom);
		}
	}
}
