namespace Voxis
{
	public struct EnvironmentSettings
	{
		// Used by RenderPipeline3D for every Object
		public Vector3 SunDirection;
		public Color SunColor;
		public Color AmbientColor;

		// Applied by camera
		public Color HorizonColor;
		public Color SkyColor;

		// Changed at runtime (day night cycle and stuffs)
		public Color FogColor { get; set mut; }
		public float FogDensity { get; set mut; }

		public this(Vector3 sunDir, Color sunColor, Color ambientColor, Color horizon, Color sky, float fogDensity)
		{
			SunDirection = sunDir;
			SunColor = sunColor;
			AmbientColor = ambientColor;
			SkyColor = sky;
			HorizonColor = horizon;

			FogColor = horizon;
			FogDensity = fogDensity;
		}
	}
}
