namespace Voxis
{
	public class VertexLayout
	{
		public readonly VertexLayoutElement[] Elements { get; }

		public int Size { get; }

		public this(params VertexLayoutElement[] elements)
		{
			Elements = new VertexLayoutElement[elements.Count];

			// Calculate vertex size and stride
			int currentSize = 0;
			for (int i = 0; i < Elements.Count; i++)
			{
				VertexLayoutElement currentElement = elements[i];

				// Stride (offset) for the current element
				currentElement.Stride = currentSize;

				// Max size of vertex
				currentSize += currentElement.ElementType.ByteSize;

				// Set the element
				Elements[i] = currentElement;
			}
			Size = currentSize;
		}

		public ~this()
		{
			delete Elements;
		}
	}
}
