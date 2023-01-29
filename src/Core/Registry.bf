using System;
using System.Collections;

namespace Voxis
{
	public class Registry<T> : RegistryBase where T : RegistryObject, delete
	{
		private Dictionary<String, T> objectMap = new Dictionary<String, T>() ~ DeleteDictionaryAndKeysAndValues!(_);

		public Dictionary<String,T>.ValueEnumerator Values
		{
			get
			{
				return objectMap.Values;
			}
		}

		public Dictionary<String, T>.KeyEnumerator IDs
		{
			get
			{	
				return objectMap.Keys;
			}
		}

		public int Count
		{
			get
			{
				 return objectMap.Count;
			}
		}

		public T RegisterObject(StringView id, T object)
		{
			String ownedID = new String(id);
			objectMap.Add(ownedID, object);
			object.RegistryID = ownedID;
			return object;
		}
		public T Get(StringView id)
		{
			String compareString = scope String(id);
			return objectMap[compareString];
		}

		public T[] GetAllAsArray()
		{
			T[] array = new T[objectMap.Count];

			int index = 0;
			for(T value in objectMap.Values)
			{
				array[index] = value;
				index++;
			}

			return array;
		}

		public T GetAtIndex(int index)
		{
			T[] temp = GetAllAsArray();
			T result = temp[index];
			delete temp;
			return result;
		}
	}
}
