namespace Voxis
{
	public class MaterialParameterTexture2D : IMaterialProperty
	{
		private Texture2D texture;

		public this(Texture2D tex)
		{
			texture = tex;
		}

		public void Apply(Material material, System.String key)
		{
			GraphicsServer.SetProgramTexture(material.Shader, key, texture, 0);
		}
	}
}
