namespace Voxis
{
	public struct ItemStack
	{
		public static ItemStack Empty
		{
			get
			{
				return ItemStack(null, 0);
			}
		}

		public readonly Item Item;
		public readonly int Count;

		public this(Item item, int count)
		{
			Item = item;
			Count = count;
		}

		public ItemStack Subtract(int amount)
		{
			return ItemStack(Item, Count - amount);
		}
	}
}