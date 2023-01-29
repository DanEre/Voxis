using System;

namespace Voxis
{
	public interface IBlockStateProperty : System.IHashable
	{
		public String Name { get; }
		public Object[] PossibleValues { get; }

		public bool Matches(Object a, Object b);
		public String ToString(String buffer);
		public Object FromString(StringView str);
	}
}
