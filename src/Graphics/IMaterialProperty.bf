using System;

namespace Voxis
{
	public interface IMaterialProperty
	{
		public void Apply(Material material, String key);
	}
}
