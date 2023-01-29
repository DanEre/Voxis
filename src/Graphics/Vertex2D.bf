using System;

namespace Voxis
{
	[Ordered]
	public struct Vertex2D
	{
		public Vector4 Position;
		public Vector2 TexCoord;
		public Color Color;

		public this(Vector4 pos, Vector2 tex, Color col)
		{
			Position = pos;
			TexCoord = tex;
			Color = col;
		}

		public this(Vector2 position, int depth, int textureIndex, Vector2 texcoord, Color color)
		{
			Position = Vector4(position.X, position.Y, depth, textureIndex);
			TexCoord = texcoord;
			Color = color;
		}
	}
}
