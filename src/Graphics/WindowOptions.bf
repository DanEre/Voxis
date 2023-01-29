using System;

namespace Voxis
{
	public struct WindowOptions
	{
		public int32 Width;
		public int32 Height;
		public String Title;
		public bool EnableDebugContext;

		public static WindowOptions Default
		{
			get
			{
				WindowOptions newOptions = WindowOptions();
				newOptions.Width = 800;
				newOptions.Height = 600;
				newOptions.Title = "Voxis Window";
#if DEBUG				
				newOptions.EnableDebugContext = true;
#else
				newOptions.EnableDebugContext = false;
#endif
				return newOptions;
			}
		}
	}
}
