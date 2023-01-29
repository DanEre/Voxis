namespace Voxis
{
	public class IndexBuffer : IGraphicsResource
	{
		public readonly uint32 Size { get; }
		public readonly uint BufferName { get; }

		private this(uint bufName, uint32 size)
		{
			BufferName = bufName;
			Size = size;
		}
	}
}
