namespace Voxis
{
	public static class Utilities
	{
		public static void CreatePatches(Rect rectangle, Rect[] buffer, Margin border)
		{
		    float x = rectangle.X;
		    float y = rectangle.Y;
		    float w = rectangle.Width;
		    float h = rectangle.Height;
		    float middleWidth = w - border.Left - border.Right;
		    float middleHeight = h - border.Top - border.Bottom;
		    float bottomY = y + h - border.Bottom;
		    float rightX = x + w - border.Right;
		    float leftX = x + border.Left;
		    float topY = y + border.Top;

			buffer[0] = Rect(x, y, border.Left, border.Top);
			buffer[1] = Rect(leftX, y, middleWidth, border.Top);
			buffer[2] = Rect(rightX, y, border.Right, border.Top);
			buffer[3] = Rect(x, topY, border.Left, middleHeight);
			buffer[4] = Rect(leftX, topY, middleWidth, middleHeight);
			buffer[5] = Rect(rightX, topY, border.Right, middleHeight);
			buffer[6] = Rect(x, bottomY, border.Left, border.Bottom);
			buffer[7] = Rect(leftX, bottomY, middleWidth, border.Bottom);
			buffer[8] = Rect(rightX, bottomY, border.Right, border.Bottom);
		}
	}
}
