namespace Voxis
{
	public struct Color
	{
		public float R;
		public float G;
		public float B;
		public float A;

		public this(float r, float g, float b, float a = 1.0f)
		{
			R = r;
			G = g;
			B = b;
			A = a;
		}

		public static Color Red { get { return Color(1.0f, 0.0f, 0.0f); } }
		public static Color White { get { return Color(1.0f, 1.0f, 1.0f); } }
		public static Color Black { get { return Color(0.0f, 0.0f, 0.0f); } }
		public static Color Purple { get { return Color(1.0f, 0.0f, 1.0f); } }

		public static Color FromBytes(uint8 r, uint8 g, uint8 b, uint8 a)
		{
			return Color(
				r / float(uint8.MaxValue),
				g / float(uint8.MaxValue),
				b / float(uint8.MaxValue),
				a / float(uint8.MaxValue)
				);
		}
	}
}
