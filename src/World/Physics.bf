using System.Collections;

namespace Voxis
{
	public static class Physics
	{
		public const float EPSILON = 0.001f;

		public struct Hit
		{
			public Vector3 Position;
			public Vector3 Delta;
			public Vector3 Normal;
			public float Time;
		}

		public struct Sweep
		{
			public Hit? Hit;
			public Vector3 Position;
			public float Time;
		}

		public static bool IsInsideTerrain(BoundingBox entityBounds, World world)
		{
			int startX = int(entityBounds.Min.X) - 1;
			int startY = int(entityBounds.Min.Y) - 1;
			int startZ = int(entityBounds.Min.Z) - 1;

			int endX = int(entityBounds.Max.X);
			int endY = int(entityBounds.Max.Y);
			int endZ = int(entityBounds.Max.Z);

			for(int x = startX; x <= endX; x++)
			{
				for (int y = startY; y <= endY; y++)
				{
					for (int z = startZ; z <= endZ; z++)
					{
						BlockState state = world.GetBlockState(BlockPos(x, y, z));
						if (state.HasCollision())
						{
							BoundingBox blockBox = state.GetCollisionBox().WithOffset(Vector3(x, y, z)).Inflate(entityBounds.Extents);

							if (blockBox.Intersects(entityBounds)) return true;
						}
					}
				}
			}

			return false;
		}

		public static Vector3 SweepTerrain(BoundingBox entityBounds, World world, Vector3 delta, ref Vector3 normal)
		{
			int startX = int(entityBounds.Min.X) - 1;
			int startY = int(entityBounds.Min.Y) - 1;
			int startZ = int(entityBounds.Min.Z) - 1;

			int endX = int(entityBounds.Max.X) + 1;
			int endY = int(entityBounds.Max.Y) + 1;
			int endZ = int(entityBounds.Max.Z) + 1;

			Vector3 stepped = Vector3(
				System.Math.Floor(delta.X),
				System.Math.Floor(delta.Y),
				System.Math.Floor(delta.Z)
				);
			if (stepped.X < 0.0f) startX += int(stepped.X);
			else endX += int(stepped.X);

			if (stepped.Y < 0.0f) startY += int(stepped.Y);
			else endY += int(stepped.Y);

			if (stepped.Z < 0.0f) startZ += int(stepped.Z);
			else endZ += int(stepped.Z);

			Vector3 safest = entityBounds.Center + delta;
			double smallestT = 1.0f;

			for(int x = startX; x <= endX; x++)
			{
				for (int y = startY; y <= endY; y++)
				{
					for (int z = startZ; z <= endZ; z++)
					{
						BlockState state = world.GetBlockState(BlockPos(x, y, z));
						if (state.HasCollision())
						{
							BoundingBox blockBox = state.GetCollisionBox().WithOffset(Vector3(x, y, z)).Inflate(entityBounds.Extents);

							Vector3 intersect = Vector3.Zero;
							Vector3 safePos = Vector3.Zero;
							double t = 0.0f;
							Vector3 norm = Vector3.Zero;

							if (blockBox.IntersectSegment(entityBounds.Center, entityBounds.Center + delta, ref intersect, ref t, ref safePos, ref norm))
							{
								if (t < smallestT)
								{
									safest = safePos;
									smallestT = t;
									normal = norm;
								}
							}
						}
					}
				}
			}

			return safest;
		}

		public static bool TraceRay(World world, Vector3 origin, Vector3 direction, float maxDistance, ref Vector3 hitPos, ref Vector3 hitNormal)
		{
			float t = 0.0f;

			int ix = int(System.Math.Floor(origin.X));
			int iy = int(System.Math.Floor(origin.Y));
			int iz = int(System.Math.Floor(origin.Z));

			int stepX = (direction.X > 0.0) ? 1 : -1;
			int stepY = (direction.Y > 0.0) ? 1 : -1;
			int stepZ = (direction.Z > 0.0) ? 1 : -1;

			float txDelta = System.Math.Abs(1.0f / direction.X);
			float tyDelta = System.Math.Abs(1.0f / direction.Y);
			float tzDelta = System.Math.Abs(1.0f / direction.Z);

			float xDist = (stepX > 0.0f) ? (ix + 1.0f - origin.X) : (origin.X - ix);
			float yDist = (stepY > 0.0f) ? (iy + 1.0f - origin.Y) : (origin.Y - iy);
			float zDist = (stepZ > 0.0f) ? (iz + 1.0f - origin.Z) : (origin.Z - iz);

			float txMax = (txDelta < float.PositiveInfinity) ? txDelta * xDist : float.PositiveInfinity;
			float tyMax = (tyDelta < float.PositiveInfinity) ? tyDelta * yDist : float.PositiveInfinity;
			float tzMax = (tzDelta < float.PositiveInfinity) ? tzDelta * zDist : float.PositiveInfinity;

			int steppedIndex = -1;

			while(t <= maxDistance)
			{
				BlockPos pos = .(ix, iy, iz);
				if (world.GetBlockState(pos).HasCollision())
				{
					hitPos = origin + t * direction;

					hitNormal = Vector3.Zero;
					if (steppedIndex == 0) hitNormal.X = -stepX;
					if (steppedIndex == 1) hitNormal.Y = -stepY;
					if (steppedIndex == 2) hitNormal.Z = -stepZ;

					return true;
				}

				if (txMax < tyMax)
				{
					if (txMax < tzMax)
					{
						ix += stepX;
						t = txMax;
						txMax += txDelta;
						steppedIndex = 0;
					}
					else
					{
						iz += stepZ;
						t = tzMax;
						tzMax += tzDelta;
						steppedIndex = 2;
					}
				}
				else
				{
					if (tyMax < tzMax)
					{
						iy += stepY;
						t = tyMax;
						tyMax += tyDelta;
						steppedIndex = 1;
					}
					else
					{
						iz += stepZ;
						t = tzMax;
						tzMax += tzDelta;
						steppedIndex = 2;
					}
				}
			}

			hitPos = origin + t * direction;
			hitNormal = Vector3.Zero;
			return false;
		}
	}
}
