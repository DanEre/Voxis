namespace Voxis
{
	public class MaterialParameterTextureArray2D : IMaterialProperty
	{
		private readonly TextureArray2D array;

		public this(TextureArray2D array)
		{
			this.array = array;
		}

		public void Apply(Material material, System.String key)
		{
			GraphicsServer.SetProgramTexture(material.Shader, key, array, 0);
		}
	}
}
