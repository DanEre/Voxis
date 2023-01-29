namespace Voxis
{
	public class MaterialParameterVector3 : IMaterialProperty
	{
		private Vector3 value;

		public this(Vector3 value)
		{
			this.value = value;
		}
		public void Apply(Material material, System.String key)
		{
			GraphicsServer.SetProgramParameter(material.Shader, key, value);
		}
	}
}