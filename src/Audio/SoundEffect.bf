using Voxis.Framework;

namespace Voxis
{
	public class SoundEffect
	{
		public Wav Wave { get; }

		public this(Wav wav)
		{
			Wave = wav;
		}

		public ~this()
		{
			delete Wave;
		}
	}
}
