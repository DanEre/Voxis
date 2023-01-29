using Voxis.Framework;

namespace Voxis
{
	public static class AudioServer
	{
		private static Soloud soloud;

		static ~this()
		{
			delete soloud;
		}

		public static void OnInitialize()
		{
			soloud = new Soloud();

			soloud.init();
		}

		public static void OnUpdate()
		{

		}
		public static void PlayOnce(SoundEffect effect, float volume = 1.0f, float pan = 0.0f)
		{
			soloud.play(effect.Wave, volume, pan);
		}
		public static SoundEffect LoadSoundEffect(System.StringView fileName)
		{
			Wav wav = new Wav();
			wav.load(fileName);

			return new SoundEffect(wav);
		}
	}
}
