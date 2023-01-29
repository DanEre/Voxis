using System.Collections;

namespace Voxis
{
	public struct BoundingBox
	{
		public readonly Vector3 Min;
		public readonly Vector3 Max;

		public Vector3 Size
		{
			get
			{
				return Max - Min;
			}
		}
		public Vector3 Extents
		{
			get
			{
				return Size * 0.5f;
			}
		}
		public Vector3 Center
		{
			get
			{
				return Min + Extents;
			}
		}

		public this(Vector3 min, Vector3 max)
		{
			Min = min;
			Max = max;
		}

		public BoundingBox Inflate(Vector3 half)
		{
			return BoundingBox(Min - half, Max + half);
		}

		public BoundingBox WithOffset(Vector3 offset)
		{
			return BoundingBox(Min + offset, Max + offset);
		}

		public bool Intersects(BoundingBox other)
		{
			return
				(Min.X <= other.Max.X && Max.X >= other.Min.X) &&
				(Min.Y <= other.Max.Y && Max.Y >= other.Min.Y) &&
				(Min.Z <= other.Max.Z && Max.Z >= other.Min.Z);
		}

		public PlaneIntersectionType Intersects(Plane other)
		{
			Vector3 positiveVertex;
			Vector3 negativeVertex;

			if (other.Normal.X >= 0)
			{
			    positiveVertex.X = Max.X;
			    negativeVertex.X = Min.X;
			}
			else
			{
			    positiveVertex.X = Min.X;
			    negativeVertex.X = Max.X;
			}

			if (other.Normal.Y >= 0)
			{
			    positiveVertex.Y = Max.Y;
			    negativeVertex.Y = Min.Y;
			}
			else
			{
			    positiveVertex.Y = Min.Y;
			    negativeVertex.Y = Max.Y;
			}

			if (other.Normal.Z >= 0)
			{
			    positiveVertex.Z = Max.Z;
			    negativeVertex.Z = Min.Z;
			}
			else
			{
			    positiveVertex.Z = Min.Z;
			    negativeVertex.Z = Max.Z;
			}

			// Inline Vector3.Dot(plane.Normal, negativeVertex) + plane.D;
			var distance = other.Normal.X * negativeVertex.X + other.Normal.Y * negativeVertex.Y + other.Normal.Z * negativeVertex.Z + other.D;
			if (distance > 0)
			{
			    return PlaneIntersectionType.Front;
			}

			// Inline Vector3.Dot(plane.Normal, positiveVertex) + plane.D;
			distance = other.Normal.X * positiveVertex.X + other.Normal.Y * positiveVertex.Y + other.Normal.Z * positiveVertex.Z + other.D;
			if (distance < 0)
			{
			    return PlaneIntersectionType.Back;
			}

			return PlaneIntersectionType.Intersecting;
		}

		public float IntersectRay(Vector3 origin, Vector3 direction)
		{
			float low = float.NegativeInfinity;
			float high = float.PositiveInfinity;

			for(int i = 0; i < 3; i++)
			{
				float dimLow = (Min[i] - origin[i]) / direction[i];
				float dimHigh = (Max[i] - origin[i]) / direction[i];

				if (dimLow > dimHigh) Swap!(dimLow, dimHigh);

				if (dimHigh < low || dimLow > high) return float.PositiveInfinity;

				if (dimLow > low) low = dimLow;
				if (dimHigh < high) high = dimHigh;
			}

			return low > high ? float.PositiveInfinity : low;
		}

		public bool IntersectSegment(Vector3 origin, Vector3 end, ref Vector3 intersection, ref double fraction, ref Vector3 safePos, ref Vector3 normal)
		{
			Vector3 direction = (end - origin).Normalize();

			float maxDist = Vector3.Distance(origin, end);

			// Distance in world coordinates
			float distance = IntersectRay(origin, direction);

			if (distance == float.PositiveInfinity || distance == float.NegativeInfinity)
			{
				return false;
			}

			if (System.Math.Abs(distance) > maxDist) return false;

			intersection = origin + direction * distance;

			fraction = System.Math.Abs(distance);
			safePos = origin + direction * (distance - System.Math.Sign(distance) * 0.001f);
			normal = GetNormalFromPoint(intersection);

			return true;
		}

		public Vector3 GetNormalFromPoint(Vector3 point)
		{
			Vector3 normal = Vector3.Zero;
			double min = double.MaxValue;
			double distance;
			Vector3 pc = point - Center;
			distance = System.Math.Abs(Extents.X - System.Math.Abs(pc.X));
			if (distance < min)
			{
				min = distance;
				normal = System.Math.Sign(pc.X) * Vector3.UnitX;
				// Cardinal axis for X
			}
			distance = System.Math.Abs(Extents.Y - System.Math.Abs(pc.Y));
			if (distance < min)
			{
				min = distance;
				normal = System.Math.Sign(pc.Y) * Vector3.UnitY;
				// Cardinal axis for Y
			}
			distance = System.Math.Abs(Extents.Z - System.Math.Abs(pc.Z));
			if (distance < min)
			{
				min = distance;
				normal = System.Math.Sign(pc.Z) * Vector3.UnitZ;
				// Cardinal axis for Z
			}
			return normal;
		}

		public bool Contains(Vector3 point)
		{
			return
				point.X >= Min.X && point.X <= Max.X &&
				point.Y >= Min.Y && point.Y <= Max.Y &&
				point.Z >= Min.Z && point.Z <= Max.Z;
		}
	}
}
