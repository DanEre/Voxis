namespace Voxis
{
	public class TextureCubemap : IGraphicsResource
	{
		private uint textureName;

		private this(uint texName)
		{
			textureName = texName;
		}
	}
}
