using System.Collections;

namespace Voxis
{
	public class Curve
	{
		private struct CurvePoint
		{
			public float Position;
			public float Value;

			public this(float pos, float val)
			{
				Position = pos;
				Value = val;
			}
		}

		private List<CurvePoint> points = new List<CurvePoint>() ~ delete _;

		public void Bake()
		{
			// Sort ascending for better performance
			points.Sort(scope (x, y) => {
				if (x.Position > y.Position) return 1;
				else if (x.Position == y.Position) return 0;
				else return -1;
			});
		}

		public void AddPoint(float position, float value)
		{
			points.Add(CurvePoint(position, value));

			Bake();
		}
		public void RemovePoint(int index)
		{
			points.RemoveAt(index);

			// TODO: No bake needed?
		}
		public void GetNearest(float position, ref float p1, ref float p2, ref float v1, ref float v2)
		{
			// No Curve points defined
			if (points.Count <= 0)
			{
				p1 = p2 = v1 = v2 = 0.0f;
				return;
			}

			// Only one curve point
			else if (points.Count == 1)
			{
				float pos = points[0].Position;
				float val = points[0].Value;
				p1 = p2 = pos;
				v1 = v2 = val;
			}

			int nearIndex = 0;
			float nearDist = System.Math.Abs(points[nearIndex].Position - position);

			// Search for least distance
			for (int i = 1; i < points.Count; i++)
			{
				if (System.Math.Abs(points[i].Position - position) < nearDist)
				{
					nearIndex = i;
					nearDist = System.Math.Abs(points[i].Position - position);
				}
			}

			// Left or right next point
			if (position < points[nearIndex].Position)
			{
				// Clamping to the left
				if (nearIndex != 0)
				{
					p1 = points[nearIndex - 1].Position;
					v1 = points[nearIndex - 1].Value;
					p2 = points[nearIndex].Position;
					v2 = points[nearIndex].Value;
				}
				else
				{
					p1 = p2 = points[nearIndex].Position;
					v1 = v2 = points[nearIndex].Value;
				}
			}
			else
			{
				// Clamping to the right
				if (nearIndex != points.Count - 1)
				{
					p1 = points[nearIndex].Position;
					v1 = points[nearIndex].Value;

					p2 = points[nearIndex + 1].Position;
					v2 = points[nearIndex + 1].Value;
				}
				else
				{
					p1 = p2 = points[nearIndex].Position;
					v1 = v2 = points[nearIndex].Value;
				}
			}
		}
		public float Interpolate(float x)
		{
			if (x <= 0.0f) return points[0].Value;
			if (x >= 1.0f) return points[points.Count - 1].Value;

			float p1 = 0, p2 = 0, v1 = 0, v2 = 0;

			GetNearest(x, ref p1, ref p2, ref v1, ref v2);

			float delta = v2 - v1;
			float partial = (x - p1) / (p2 - p1);

			return v1 + partial * delta;
		}
	}
}