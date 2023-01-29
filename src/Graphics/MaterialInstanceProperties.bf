using System.Collections;
using System;

namespace Voxis
{
	public class MaterialInstanceProperties
	{
		private Dictionary<String, IMaterialProperty> properties = new Dictionary<String, IMaterialProperty>() ~ DeleteDictionaryAndKeys!(_);

		public void SetMaterialProperty(StringView name, IMaterialProperty value)
		{
			properties[new String(name)] = value;
		}

		public void Apply(Material forMaterial)
		{
			for((String key, IMaterialProperty value) pair in properties)
			{
				pair.value.Apply(forMaterial, pair.key);
			}
		}
	}
}
