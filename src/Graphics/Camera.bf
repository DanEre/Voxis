using System;

namespace Voxis
{
	public class Camera
	{
		public Vector3 Position { get; set; }
		public Quaternion Rotation { get; set; }
		public BoundingFrustum Frustrum { get; } = new BoundingFrustum(ProjectionMatrix * ViewMatrix) ~ delete _;

		public Vector3 Forward
		{
			get
			{
				return Vector3.Transform(Vector3.UnitZ, Rotation);
			}
		}
		public Vector3 Right
		{
			get
			{
				return Vector3.Transform(Vector3.UnitX, Rotation);
			}
		}
		public Vector3 Up
		{
			get
			{
				return Vector3.Cross(Forward, Right);
			}
		}
		public Matrix4x4 ViewMatrix
		{
			get
			{
				return Matrix4x4.CreateLookAt(Position, Position + Forward, Up);
			}
		}
		public Matrix4x4 ProjectionMatrix
		{
			get
			{
				float aspect = float(WindowServer.Width) / float(WindowServer.Height);
				return Matrix4x4.CreatePerspectiveFieldOfView(ToRadians(90.0f), aspect, 1.0f, 10000.0f);
			}
		}
		public Matrix4x4 TransformMatrix
		{
			get
			{
				return Matrix4x4.CreateFromQuaternion(Rotation) * Matrix4x4.CreateTranslation(Position);
			}
		}

		public void DrawMesh(Mesh mesh, Matrix4x4 modelMatrix, VertexLayout vertexLayout, Material material, BoundingBox worldBounds)
		{
			// Frustrum culling
			if (!Frustrum.Intersects(worldBounds)) return;

			RenderPipeline3D.DrawMesh(mesh, ProjectionMatrix, ViewMatrix, modelMatrix, vertexLayout, material);
		}

		public void DrawCube(Matrix4x4 data, Color color)
		{
			RenderPipeline3D.DrawMesh(RenderPipeline3D.CubeMesh, ProjectionMatrix, ViewMatrix, data, RenderPipeline3D.DefaultVertexLayout, RenderPipeline3D.DefaultOpaqueMaterial);
		}

		public void DrawCube(Vector3 center, Vector3 extents, Color color)
		{
			Matrix4x4 modelMatrix = Matrix4x4.CreateScale(extents) * Matrix4x4.CreateTranslation(center);

			RenderPipeline3D.DrawMesh(RenderPipeline3D.CubeMesh, ProjectionMatrix, ViewMatrix, modelMatrix, RenderPipeline3D.DefaultVertexLayout, RenderPipeline3D.DefaultOpaqueMaterial);
		}

		public void DrawEnvironment(EnvironmentSettings environment)
		{
			RenderPipeline3D.Environment = environment;

			Material skybox = RenderPipeline3D.DefaultSkyboxMaterial;
			skybox.SetMaterialProperty("SKY", environment.SkyColor);
			skybox.SetMaterialProperty("HORIZON", environment.HorizonColor);

			Matrix4x4 modelMatrix = Matrix4x4.CreateScale(1000, 1000, 1000) * Matrix4x4.CreateTranslation(Position);
			RenderPipeline3D.DrawMesh(RenderPipeline3D.CubeMesh, ProjectionMatrix, ViewMatrix, modelMatrix, RenderPipeline3D.DefaultVertexLayout, skybox);

			// TODO: Only for Debugging the sun is drawn here
			Vector3 sunDir = Vector3.UnitY;
			Quaternion sunRotation = Quaternion.CreateFromAxisAngle(Vector3.UnitX, float(Time.Elapsed));
			sunDir = Vector3.Transform(sunDir, sunRotation);

			Vector3 finalPos = Position + sunDir * 100.0f;

			Matrix4x4 sunMatrix = Matrix4x4.CreateTranslation(finalPos);
			RenderPipeline3D.DrawMesh(RenderPipeline3D.CubeMesh, ProjectionMatrix, ViewMatrix, sunMatrix,RenderPipeline3D.DefaultVertexLayout, RenderPipeline3D.DefaultOpaqueMaterial);
		}

		public void Update()
		{
			Frustrum.Matrix = ViewMatrix * ProjectionMatrix;
		}

		private float ToRadians(float value)
		{
			return value * Math.PI_f / 180.0f;
		}
	}
}
