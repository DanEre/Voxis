namespace Voxis
{
	public struct PaletteEntry
	{
		public BlockState State { get; set mut; }
		public int Reference { get; set mut; }

		public this()
		{
			State = null;
			Reference = 0;
		}
	}
}
