namespace Voxis
{
	public class VertexBuffer : IGraphicsResource
	{
		public readonly uint32 Size { get; }
		public readonly uint BufferName { get;}

		private this(uint bufferName, uint32 size)
		{
			BufferName = bufferName;
			Size = size;
		}
	}
}
