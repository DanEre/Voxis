using System;
using System.Collections;
using System.Threading;

namespace Voxis
{
	public class BlockStorage
	{
		public int Size { get; }

		public bool IsEmpty
		{
			get
			{
				return isEmpty;
			}
		}

		public bool IsAir
		{
			get
			{
				if (IsEmpty) return true;

				for (PaletteEntry entriy in palette)
				{
					if (entriy.State != AirBlock.DEFAULT_AIR_STATE && entriy.Reference > 0) return false;
				}

				return true;
			}
		}

		private uint8[] blocktypes;

		private PaletteEntry[] palette = new PaletteEntry[1] ~ delete _;

		private bool isEmpty = true;

		public this(int size)
		{
			Size = size;

			blocktypes = new uint8[Size * Size * Size];
		}

		public ~this()
		{
			delete blocktypes;
		}

		public BlockState GetBlockState(int x, int y, int z)
		{
			uint8 paletteIndex = blocktypes[ConvertIndex(x, y, z)];

			if (paletteIndex == 0) return AirBlock.DEFAULT_AIR.BlockStateContainer.DefaultState;

			return palette[paletteIndex - 1].State;
		}
		public void SetBlockState(int x, int y, int z, BlockState blockstate)
		{
			// Decrease old block reference count
			BlockState old = GetBlockState(x, y, z);

			if (old != AirBlock.DEFAULT_AIR.BlockStateContainer.DefaultState)
			{
				DereferencePaletteIndex(old);
			}

			// If its not an air block, block storage is not empty
			if (blockstate != AirBlock.DEFAULT_AIR_STATE)
			{
				isEmpty = false;
			}

			// Get or create block reference index
			int newIndex = ReferencePaletteIndex(blockstate);

			blocktypes[ConvertIndex(x, y, z)] = uint8(newIndex + 1);
		}

		private int ConvertIndex(int x, int y, int z)
		{
			return (x + Size * (y + Size * z));
		}

		private int GetPaletteIndex(BlockState state)
		{
			// Search for existing entry and decrease
			for(int i = 0; i < palette.Count; i++)
			{
				if (palette[i].State == state)
				{
					return i;
				}
			}

			Runtime.FatalError("BlockState not in palette!");
		}

		private void DereferencePaletteIndex(BlockState state)
		{
			// Search for existing entry and decrease
			for(int i = 0; i < palette.Count; i++)
			{
				if (palette[i].State == state)
				{
					palette[i].Reference++;
					return;
				}
			}
		}

		private int ReferencePaletteIndex(BlockState state)
		{
			// Search for existing entry
			for(int i = 0; i < palette.Count; i++)
			{
				if (palette[i].State == state)
				{
					palette[i].Reference++;
					return i;
				}
			}

			// Not in palette, add to palette
			for(int i = 0; i < palette.Count; i++)
			{
				if (palette[i].State == null || palette[i].Reference <= 0)
				{
					palette[i].State = state;
					palette[i].Reference = 1;
				}
			}

			// Not in palette and no space for new entry, resize the palette
			PaletteEntry[] newArray = new PaletteEntry[palette.Count * 2];
			palette.CopyTo(newArray);

			delete palette;

			palette = newArray;

			return ReferencePaletteIndex(state);
		}
	}
}
