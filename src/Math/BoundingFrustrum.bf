using System;

namespace Voxis
{
    public class BoundingFrustum
    {
        private Matrix4x4 _matrix;
        private readonly Vector3[] _corners = new Vector3[CornerCount] ~ delete _;
        private readonly Plane[] _planes = new Plane[PlaneCount] ~ delete _;

        public const int PlaneCount = 6;
        public const int CornerCount = 8;

        public Matrix4x4 Matrix
        {
            get { return this._matrix; }
            set
            {
                this._matrix = value;
                this.CreatePlanes();
                this.CreateCorners();
            }
        }

        public Plane Near
        {
            get { return this._planes[0]; }
        }
        public Plane Far
        {
            get { return this._planes[1]; }
        }
        public Plane Left
        {
            get { return this._planes[2]; }
        }
        public Plane Right
        {
            get { return this._planes[3]; }
        }
        public Plane Top
        {
            get { return this._planes[4]; }
        }
        public Plane Bottom
        {
            get { return this._planes[5]; }
        }

        public this(Matrix4x4 value)
        {
            this._matrix = value;
            this.CreatePlanes();
            this.CreateCorners();
        }

        public ContainmentType Contains(BoundingBox boxx)
        {
            var result = default(ContainmentType);
            this.Contains(boxx, out result);
            return result;
        }

        public void Contains(BoundingBox boxx, out ContainmentType result)
        {
            var intersects = false;
            for (var i = 0; i < PlaneCount; ++i)
            {
                var planeIntersectionType = boxx.Intersects(this._planes[i]);
                switch (planeIntersectionType)
                {
                case PlaneIntersectionType.Front:
                    result = ContainmentType.Disjoint; 
                    return;
                case PlaneIntersectionType.Intersecting:
                    intersects = true;
                    break;
				default:
                }
            }
            result = intersects ? ContainmentType.Intersects : ContainmentType.Contains;
        }

        public ContainmentType Contains(BoundingFrustum frustum)
        {
            if (this == frustum)                // We check to see if the two frustums are equal
                return ContainmentType.Contains;// If they are, there's no need to go any further.

            var intersects = false;
            for (var i = 0; i < PlaneCount; ++i)
            {
                PlaneIntersectionType planeIntersectionType;
                frustum.Intersects(_planes[i], out planeIntersectionType);
                switch (planeIntersectionType)
                {
                    case PlaneIntersectionType.Front:
                        return ContainmentType.Disjoint;
                    case PlaneIntersectionType.Intersecting:
                        intersects = true;
                        break;
					default:
                }
            }
            return intersects ? ContainmentType.Intersects : ContainmentType.Contains;
        }

        /// <summary>
        /// Containment test between this <see cref="BoundingFrustum"/> and specified <see cref="BoundingSphere"/>.
        /// </summary>
        /// <param name="sphere">A <see cref="BoundingSphere"/> for testing.</param>
        /// <returns>Result of testing for containment between this <see cref="BoundingFrustum"/> and specified <see cref="BoundingSphere"/>.</returns>
        //public ContainmentType Contains(BoundingSphere sphere)
        //{
            //var result = default(ContainmentType);
            //this.Contains(ref sphere, out result);
            //return result;
        //}

        /// <summary>
        /// Containment test between this <see cref="BoundingFrustum"/> and specified <see cref="BoundingSphere"/>.
        /// </summary>
        /// <param name="sphere">A <see cref="BoundingSphere"/> for testing.</param>
        /// <param name="result">Result of testing for containment between this <see cref="BoundingFrustum"/> and specified <see cref="BoundingSphere"/> as an output parameter.</param>
        //public void Contains(ref BoundingSphere sphere, out ContainmentType result)
        //{
            //var intersects = false;
            //for (var i = 0; i < PlaneCount; ++i) 
            //{
                //var planeIntersectionType = default(PlaneIntersectionType);

                // TODO: we might want to inline this for performance reasons
                //sphere.Intersects(ref this._planes[i], out planeIntersectionType);
                //switch (planeIntersectionType)
                //{
                //case PlaneIntersectionType.Front:
                    //result = ContainmentType.Disjoint; 
                    //return;
                //case PlaneIntersectionType.Intersecting:
                    //intersects = true;
                    //break;
                //}
            //}
            //result = intersects ? ContainmentType.Intersects : ContainmentType.Contains;
        //}

        /// <summary>
        /// Containment test between this <see cref="BoundingFrustum"/> and specified <see cref="Vector3"/>.
        /// </summary>
        /// <param name="point">A <see cref="Vector3"/> for testing.</param>
        /// <returns>Result of testing for containment between this <see cref="BoundingFrustum"/> and specified <see cref="Vector3"/>.</returns>
        public ContainmentType Contains(Vector3 point)
        {
            var result = default(ContainmentType);
            this.Contains(point, out result);
            return result;
        }

        public void Contains(Vector3 point, out ContainmentType result)
        {
            for (var i = 0; i < PlaneCount; ++i)
            {
                // TODO: we might want to inline this for performance reasons
                if (PlaneHelper.ClassifyPoint(point, this._planes[i]) > 0)
                {   
                    result = ContainmentType.Disjoint;
                    return;
                }
            }
            result = ContainmentType.Contains;
        }

        #endregion

        /// <summary>
        /// Compares whether current instance is equal to specified <see cref="BoundingFrustum"/>.
        /// </summary>
        /// <param name="other">The <see cref="BoundingFrustum"/> to compare.</param>
        /// <returns><c>true</c> if the instances are equal; <c>false</c> otherwise.</returns>
        public bool Equals(BoundingFrustum other)
        {
            return (this == other);
        }

        /// <summary>
        /// Returns a copy of internal corners array.
        /// </summary>
        /// <returns>The array of corners.</returns>
        public Vector3[] GetCorners()
        {
			// TODO: Later clone!!!
            return (Vector3[])this._corners;
        }

        /// <summary>
        /// Returns a copy of internal corners array.
        /// </summary>
        /// <param name="corners">The array which values will be replaced to corner values of this instance. It must have size of <see cref="BoundingFrustum.CornerCount"/>.</param>
		public void GetCorners(Vector3[] corners)
        {
			if (corners == null) Runtime.FatalError();
		    if (corners.Count < CornerCount) Runtime.FatalError();

            this._corners.CopyTo(corners, 0);
        }

        public bool Intersects(BoundingBox boxx)
        {
			var result = false;
			this.Intersects(boxx, out result);
			return result;
        }

        /// <summary>
        /// Gets whether or not a specified <see cref="BoundingBox"/> intersects with this <see cref="BoundingFrustum"/>.
        /// </summary>
        /// <param name="box">A <see cref="BoundingBox"/> for intersection test.</param>
        /// <param name="result"><c>true</c> if specified <see cref="BoundingBox"/> intersects with this <see cref="BoundingFrustum"/>; <c>false</c> otherwise as an output parameter.</param>
        public void Intersects(BoundingBox boxx, out bool result)
        {
			var containment = default(ContainmentType);
			this.Contains(boxx, out containment);
			result = containment != ContainmentType.Disjoint;
		}

        /// <summary>
        /// Gets whether or not a specified <see cref="BoundingFrustum"/> intersects with this <see cref="BoundingFrustum"/>.
        /// </summary>
        /// <param name="frustum">An other <see cref="BoundingFrustum"/> for intersection test.</param>
        /// <returns><c>true</c> if other <see cref="BoundingFrustum"/> intersects with this <see cref="BoundingFrustum"/>; <c>false</c> otherwise.</returns>
        public bool Intersects(BoundingFrustum frustum)
        {
            return Contains(frustum) != ContainmentType.Disjoint;
        }

        /// <summary>
        /// Gets whether or not a specified <see cref="BoundingSphere"/> intersects with this <see cref="BoundingFrustum"/>.
        /// </summary>
        /// <param name="sphere">A <see cref="BoundingSphere"/> for intersection test.</param>
        /// <returns><c>true</c> if specified <see cref="BoundingSphere"/> intersects with this <see cref="BoundingFrustum"/>; <c>false</c> otherwise.</returns>
        //public bool Intersects(BoundingSphere sphere)
        //{
            //var result = default(bool);
            //this.Intersects(ref sphere, out result);
            //return result;
        //}

        public PlaneIntersectionType Intersects(Plane plane)
        {
            PlaneIntersectionType result;
            Intersects(plane, out result);
            return result;
        }

        public void Intersects(Plane plane, out PlaneIntersectionType result)
        {
            result = plane.Intersects(_corners[0]);
            for (int i = 1; i < _corners.Count; i++)
                if (plane.Intersects(_corners[i]) != result)
                    result = PlaneIntersectionType.Intersecting;
        }
        
        /// <summary>
        /// Gets the distance of intersection of <see cref="Ray"/> and this <see cref="BoundingFrustum"/> or null if no intersection happens.
        /// </summary>
        /// <param name="ray">A <see cref="Ray"/> for intersection test.</param>
        /// <returns>Distance at which ray intersects with this <see cref="BoundingFrustum"/> or null if no intersection happens.</returns>
        //public float? Intersects(Ray ray)
        //{
            //float? result;
            //Intersects(ref ray, out result);
            //return result;
        //}

        /// <summary>
        /// Gets the distance of intersection of <see cref="Ray"/> and this <see cref="BoundingFrustum"/> or null if no intersection happens.
        /// </summary>
        /// <param name="ray">A <see cref="Ray"/> for intersection test.</param>
        /// <param name="result">Distance at which ray intersects with this <see cref="BoundingFrustum"/> or null if no intersection happens as an output parameter.</param>
        //public void Intersects(ref Ray ray, out float? result)
        //{
            //ContainmentType ctype;
            //this.Contains(ref ray.Position, out ctype);

            //switch (ctype)
            //{
                //case ContainmentType.Disjoint:
                  //  result = null;
                    //return;
                //case ContainmentType.Contains:
                  //  result = 0.0f;
                    //return;
                //case ContainmentType.Intersects:
                  //  Runtime.FatalError();
                //default:
                  //  Runtime.FatalError();
            //}
        //} 

        private void CreateCorners()
        {
            IntersectionPoint(ref this._planes[0], ref this._planes[2], ref this._planes[4], out this._corners[0]);
            IntersectionPoint(ref this._planes[0], ref this._planes[3], ref this._planes[4], out this._corners[1]);
            IntersectionPoint(ref this._planes[0], ref this._planes[3], ref this._planes[5], out this._corners[2]);
            IntersectionPoint(ref this._planes[0], ref this._planes[2], ref this._planes[5], out this._corners[3]);
            IntersectionPoint(ref this._planes[1], ref this._planes[2], ref this._planes[4], out this._corners[4]);
            IntersectionPoint(ref this._planes[1], ref this._planes[3], ref this._planes[4], out this._corners[5]);
            IntersectionPoint(ref this._planes[1], ref this._planes[3], ref this._planes[5], out this._corners[6]);
            IntersectionPoint(ref this._planes[1], ref this._planes[2], ref this._planes[5], out this._corners[7]);
        }

        private void CreatePlanes()
        {            
            this._planes[0] = Plane(-this._matrix.M13, -this._matrix.M23, -this._matrix.M33, -this._matrix.M43);
            this._planes[1] = Plane(this._matrix.M13 - this._matrix.M14, this._matrix.M23 - this._matrix.M24, this._matrix.M33 - this._matrix.M34, this._matrix.M43 - this._matrix.M44);
            this._planes[2] = Plane(-this._matrix.M14 - this._matrix.M11, -this._matrix.M24 - this._matrix.M21, -this._matrix.M34 - this._matrix.M31, -this._matrix.M44 - this._matrix.M41);
            this._planes[3] = Plane(this._matrix.M11 - this._matrix.M14, this._matrix.M21 - this._matrix.M24, this._matrix.M31 - this._matrix.M34, this._matrix.M41 - this._matrix.M44);
            this._planes[4] = Plane(this._matrix.M12 - this._matrix.M14, this._matrix.M22 - this._matrix.M24, this._matrix.M32 - this._matrix.M34, this._matrix.M42 - this._matrix.M44);
            this._planes[5] = Plane(-this._matrix.M14 - this._matrix.M12, -this._matrix.M24 - this._matrix.M22, -this._matrix.M34 - this._matrix.M32, -this._matrix.M44 - this._matrix.M42);
            
            this.NormalizePlane(ref this._planes[0]);
            this.NormalizePlane(ref this._planes[1]);
            this.NormalizePlane(ref this._planes[2]);
            this.NormalizePlane(ref this._planes[3]);
            this.NormalizePlane(ref this._planes[4]);
            this.NormalizePlane(ref this._planes[5]);
        }

        private static void IntersectionPoint(ref Plane a, ref Plane b, ref Plane c, out Vector3 result)
        {
            // Formula used
            //                d1 ( N2 * N3 ) + d2 ( N3 * N1 ) + d3 ( N1 * N2 )
            //P =   -------------------------------------------------------------------------
            //                             N1 . ( N2 * N3 )
            //
            // Note: N refers to the normal, d refers to the displacement. '.' means dot product. '*' means cross product
            
            Vector3 v1, v2, v3;
            Vector3 cross;

			cross = Vector3.Cross(b.Normal, c.Normal);
            
            float f = Vector3.Dot(a.Normal, cross);
            f *= -1.0f;

			cross = Vector3.Cross(b.Normal, c.Normal);
			v1 = cross * a.D;
            //v1 = (a.D * (Vector3.Cross(b.Normal, c.Normal)));

			cross = Vector3.Cross(c.Normal, a.Normal);
            v2 = cross * b.D;
            //v2 = (b.D * (Vector3.Cross(c.Normal, a.Normal)));
            
            cross = Vector3.Cross(a.Normal, b.Normal);
			v3 = cross * c.D;
            //v3 = (c.D * (Vector3.Cross(a.Normal, b.Normal)));
            
            result.X = (v1.X + v2.X + v3.X) / f;
            result.Y = (v1.Y + v2.Y + v3.Y) / f;
            result.Z = (v1.Z + v2.Z + v3.Z) / f;
        }
        
        private void NormalizePlane(ref Plane p)
        {
            float factor = 1f / p.Normal.Length;
            p.Normal.X *= factor;
            p.Normal.Y *= factor;
            p.Normal.Z *= factor;
            p.D *= factor;
        }

        #endregion
    }
}