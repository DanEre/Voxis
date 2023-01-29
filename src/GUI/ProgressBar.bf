namespace Voxis
{
	public class ProgressBar : GUIElement
	{
		public float Value { get; set; }
		public float MinValue { get; set; }
		public float MaxValue { get; set; }
		public Color Tint { get; set; }

		public override void OnDraw(int currentDepth)
		{
			GUICanvas.Theme.ProgressBarBackgroundStyle.OnDraw(ScreenRect, currentDepth, .White);
			GUICanvas.Theme.ProgressBarForegroundStyle.OnDraw(ScreenRect, currentDepth, Tint);

			base.OnDraw(currentDepth);
		}
	}
}
