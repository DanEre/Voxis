namespace Voxis
{
	public struct Anchor
	{
		public float XMin;
		public float YMin;
		public float XMax;
		public float YMax;

		public static Anchor Center
		{
			get
			{
				return Anchor(0.5f, 0.5f, 0.5f, 0.5f);
			}
		}
		public static Anchor Zero
		{
			get
			{
				return Anchor(0, 0, 0, 0);
			}
		}

		public this(float xmin, float ymin, float xman, float ymax)
		{
			XMin = xmin;
			YMin = ymin;
			XMax = xman;
			YMax = ymax;
		}
	}
}
