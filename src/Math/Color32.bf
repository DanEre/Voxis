using System;
namespace Voxis
{
	[Ordered]
	public struct Color32
	{
		public uint8 R, G, B, A;

		public this(uint8 r, uint8 g, uint8 b, uint8 a = uint8.MaxValue)
		{
			R = r;
			G = g;
			B = b;
			A = a;
		}

		public static Color32 White{ get { return Color32(uint8.MaxValue, uint8.MaxValue, uint8.MaxValue); } }
	}
}
