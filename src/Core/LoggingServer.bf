using System;

namespace Voxis
{
	public static class LoggingServer
	{
		public static LogLevel CurrentLogLevel { get; set; }

		public enum LogLevel
		{
			Debug = 0,
			Info = 1,
			Warning = 2,
			Error = 3,
			Fatal = 4
		}

		static this()
		{
			CurrentLogLevel = .Warning;
		}

		public static void LogMessage(StringView message, LogLevel level, params Object[] format)
		{
			if (level < CurrentLogLevel) return;

			String formatedMessage = scope String()..AppendF(message, params format);
			String formatedLog = scope String()..AppendF("[{0}][{1}]: {2}", DateTime.Now, level, formatedMessage);

			ConsoleColor lastColor = Console.ForegroundColor;

			switch(level){
			case .Debug:
				Console.ForegroundColor = .Cyan;
				break;
			case .Error:
				Console.ForegroundColor = .Red;
				break;
			case .Fatal:
				Console.ForegroundColor = .DarkRed;
				break;
			case .Info:
				Console.ForegroundColor = .White;
				break;
			case .Warning:
				Console.ForegroundColor = .Yellow;
				break;
			}

			Console.WriteLine(formatedLog);

			Console.ForegroundColor = lastColor;
		}
	}
}
