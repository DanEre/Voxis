using System;
using System.Diagnostics;

namespace Voxis
{
	struct VoxelLights
	{
		private uint16 values;

		public uint16 R
		{
			get
			{
				return values & 0xF;
			}
		}

		public uint16 G
		{
			get
			{
				return (values >> 4) & 0xF;
			}
		}

		public uint16 B
		{
			get
			{
				return (values >> 8) & 0xF;
			}
		}

		public uint16 S
		{
			get
			{
				return (values >> 12) & 0xF;
			}
		}

		public bool IsEmpty
		{
			get
			{
				return values == 0;
			}
		}

		public static VoxelLights Empty
		{
			get
			{
				return VoxelLights(0, 0, 0, 0);
			}
		}

		public this(uint16 r, uint16 g, uint16 b, uint16 s)
		{
			Debug.Assert(r <= 15 && g <= 15 && b <= 15 && s <= 15);

			values = (s << 12) | (b << 8) | (g << 4) | (r);
		}

		public uint16 this[int index]
		{
			get
			{
				return (values >> (4 * index)) & 0xF;
			}
			set mut
			{
				Debug.Assert(value <= 15);

				// Zero out previous
				values &= ~(0xFF << (index * 4));

				// Prepare shifted value
				uint16 temp = value << (index * 4);

				values = values | temp;
			}
		}

		public Color32 ToColor32()
		{
			return Color32(
				uint8(R) * 16,
				uint8(G) * 16,
				uint8(B) * 16,
				uint8(S) * 16
				);
		}
	}
}