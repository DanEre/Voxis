namespace Voxis
{
	public class MaterialParameterColor : IMaterialProperty
	{
		private Color col;

		public this(Color color)
		{
			col = color;
		}

		public void Apply(Material material, System.String key)
		{
			GraphicsServer.SetProgramParameter(material.Shader, key, col);
		}

		public void SetColor(Color newColor)
		{
			col = newColor;
		}
	}
}
