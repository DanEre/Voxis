using System;

namespace Voxis
{
	[Ordered]
	public struct ChunckVertex
	{
		public Vector3 Position;
		public Vector2 TexCoord;
		public Vector2 TexIndex;
		public Color32 Color;
		public Vector3 Normal;

		public static readonly VertexLayout Layout = new VertexLayout(
			VertexLayoutElement("POSITION", .Vector3),
			VertexLayoutElement("TEXCOORD", .Vector2),
			VertexLayoutElement("TEXINDEX", .Vector2),
			VertexLayoutElement("COLOR", .Color32, true),
			VertexLayoutElement("NORMAL", .Vector3)
			) ~ delete _;
	}
}
