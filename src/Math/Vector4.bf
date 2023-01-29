using System;

namespace Voxis
{
	[Ordered]
	public struct Vector4
	{
		public float X;
		public float Y;
		public float Z;
		public float W;

		public this(float x, float y, float z, float w)
		{
			X = x;
			Y = y;
			Z = z;
			W = w;
		}

		public this(Vector3 vec, float w)
		{
			this.X = vec.X;
			this.Y = vec.Y;
			this.Z = vec.Z;
			this.W = w;
		}

		public Vector4 Transform(Matrix4x4 matrix)
		{
			Vector4 result;
		    var x = (X * matrix.M11) + (Y * matrix.M21) + (Z * matrix.M31) + (W * matrix.M41);
		    var y = (X * matrix.M12) + (Y * matrix.M22) + (Z * matrix.M32) + (W * matrix.M42);
		    var z = (X * matrix.M13) + (Y * matrix.M23) + (Z * matrix.M33) + (W * matrix.M43);
		    var w = (X * matrix.M14) + (Y * matrix.M24) + (Z * matrix.M34) + (W * matrix.M44);
		    result.X = x;
		    result.Y = y;
		    result.Z = z;
		    result.W = w;

			return result;
		}
	}
}
