namespace Voxis
{
	public struct DepthState
	{
		public bool EnableRead;
		public bool EnableWrite;
		public DepthTestFunction DepthTestFunc;

		public this(bool read, bool write, DepthTestFunction func)
		{
			EnableRead = read;
			EnableWrite = write;
			DepthTestFunc = func;
		}

		public static DepthState Default
		{
			get
			{
				return DepthState(true, true, .LessEqual);
			}
		}
		public static DepthState Always
		{
			get
			{
				return DepthState(false, false, .Always);
			}
		}
	}
}
