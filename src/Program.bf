using System;

namespace Voxis
{
	public class Program
	{
		private static int Main()
		{
			VoxisGame game = new VoxisGame();
			game.Run();
			delete game;
			return 1;
		}
	}
}
