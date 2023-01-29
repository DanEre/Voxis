namespace Voxis
{
	public struct Ray
	{
		public Vector3 Origin;
		public Vector3 Direction;

		public this(Vector3 origin, Vector3 dir)
		{
			Origin = origin;
			Direction = dir;
		}
	}
}
