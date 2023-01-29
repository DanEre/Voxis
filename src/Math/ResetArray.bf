namespace Voxis
{
	public class ResetArray<T>
	{
		private T[] array;

		private int currentLength;

		public int Length
		{
			get
			{
				return currentLength;
			}
		}
		public int Capacity
		{
			get
			{
				return array.Count;
			}
		}
		public T* PointerFirst
		{
			get
			{
				return array.CArray();
			}
		}
		public T[] Array
		{
			get
			{
				return array;
			}
		}
		public int CapLeft
		{
			get
			{
				return Capacity - Length;
			}
		}

		public this(int capacity)
		{
			array = new T[capacity];
			currentLength = 0;
		}
		public ~this()
		{
			delete array;
		}

		public void Add(T element)
		{
			array[currentLength] = element;
			currentLength++;
		}
		public void AddRange(params T[] element)
		{
			for (T t in element)
			{
				Add(t);
			}
		}

		public void Clear()
		{
			currentLength = 0;
		}
	}
}
