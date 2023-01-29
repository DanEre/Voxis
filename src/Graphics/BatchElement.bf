namespace Voxis
{
	public abstract class BatchElement
	{
		// Order of drawing, greater goes first!
		public int Depth { get; set; }
		// Order of the element drawn in a batch, less goes first!
		public int SubmitOrder { get; set; }
	}
}
