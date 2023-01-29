using System;
using System.Diagnostics;

namespace Voxis
{
	public static class Time
	{
		public static double DeltaTime { get; private set; }
		public static double DeltaTimeRealtime { get; private set; }
		public static double Elapsed { get; private set; }
		public static double ElapsedRealtime { get; private set; }

		public static double TimeScale { get; set; }

		private static Stopwatch stopwatch;

		static this()
		{
			TimeScale = 1.0f;

			stopwatch = new Stopwatch();
		}

		static ~this()
		{
			delete stopwatch;
		}

		public static void Start()
		{
			stopwatch.Start();
		}

		public static void Frame()
		{
			double elapsed = stopwatch.Elapsed.TotalSeconds;
			stopwatch.Restart();

			DeltaTime = elapsed * TimeScale;
			DeltaTimeRealtime = elapsed;

			Elapsed += DeltaTime;
			ElapsedRealtime += DeltaTimeRealtime;
		}
	}
}
