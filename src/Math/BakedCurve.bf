namespace Voxis
{
	// Curve with pre-sampled points so it's faster
	// At least it should be
	public class BakedCurve
	{
		private float[] samples;

		public this(Curve fromCurve, int numSamples = 1000)
		{
			samples = new float[numSamples];

			for(int i = 0; i < numSamples; i++)
			{
				samples[i] = fromCurve.Interpolate(i / float(numSamples));
			}
		}
		public ~this()
		{
			delete samples;
		}

		public float Interpolate(float x)
		{
			return samples[int(x * (samples.Count - 1))];
		}
	}
}