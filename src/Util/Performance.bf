using System;
using System.Collections;

namespace Voxis
{
	public static class Performance
	{
		public struct Metrics
		{
			public int DrawCalls3D = 0;
			public int DrawCallsCanvas = 0;
			public int DrawPrimitive = 0;
		}

		public static Metrics CurrentFrame;
		public static Metrics LastFrame;

		public static void Reset()
		{
			LastFrame = CurrentFrame;
			CurrentFrame = Metrics();
		}
	}
}