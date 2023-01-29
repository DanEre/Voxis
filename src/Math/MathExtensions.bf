namespace Voxis
{
	public static class ExtMath
	{
		public static readonly float Deg2RadF = System.Math.PI_f / 180.0f;

		public static float Deg2Rad(float degree)
		{
			return degree * System.Math.PI_f / 180.0f;
		}
	}
}
