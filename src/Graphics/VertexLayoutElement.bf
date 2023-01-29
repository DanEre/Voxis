using System;

namespace Voxis
{
	public struct VertexLayoutElement
	{
		public StringView AttributeName;
		public VertexElementType ElementType;
		public bool Normalized;

		public int Stride;

		public this(StringView attribName, VertexElementType type, bool normalized = false)
		{
			AttributeName = attribName;
			ElementType = type;

			Stride = 0;

			Normalized = normalized;
		}
	}
}
