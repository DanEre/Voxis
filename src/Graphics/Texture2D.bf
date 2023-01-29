namespace Voxis
{
	public class Texture2D : IGraphicsResource
	{
		public int Width { get; protected set; }
		public int Height { get; protected set; }

		public float TexelWidth { get{ return 1.0f / Width; } }
		public float TexelHeight { get { return 1.0f / Height; } }
		public Vector2 TexelSize { get { return Vector2(1.0f / Width, 1.0f / Height); } };

		public readonly uint TextureName;

		private this(uint texName, int width, int height)
		{
			TextureName = texName;
			Width = width;
			Height = height;
		}
	}
}
