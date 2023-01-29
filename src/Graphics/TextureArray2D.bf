namespace Voxis
{
	public class TextureArray2D : IGraphicsResource
	{
		public int Width { get; }
		public int Height { get; }
		public int Layers { get; }

		public uint texName = 0;

		private this(uint name, int width, int height, int layers)
		{
			texName = name;
			Width = width;
			Height = height;
			Layers = layers;
		}
	}
}
