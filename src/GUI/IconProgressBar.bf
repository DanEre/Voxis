namespace Voxis
{
	public class IconProgressBar : GUIElement
	{
		public Texture2D ForegroundIcon { get; set; }
		public Texture2D BackgroundIcon { get; set; }
		public int MaxValue { get; set; }
		public int Value { get; set; }
		public Color BackgroundTint { get; set; } = Color.White;
		public Color ForegroundTint { get; set; } = Color.White;
		public int Spacing { get; set; } = 5;

		public override void OnDraw(int currentDepth)
		{
			base.OnDraw(currentDepth);

			if (BackgroundIcon != null)
			{
				float currentX = ScreenRect.X;
				float currentY = ScreenRect.Y;

				for (int i = 0; i < MaxValue; i++)
				{
					CanvasRenderPipeline.DrawTexturedRect(Rect(currentX, currentY, BackgroundIcon.Width, BackgroundIcon.Height), BackgroundIcon, BackgroundTint, currentDepth);
					currentX += Spacing + BackgroundIcon.Width;
				}
			}

			if (ForegroundIcon != null)
			{
				float currentX = ScreenRect.X;
				float currentY = ScreenRect.Y;

				for (int i = 0; i < Value; i++)
				{
					CanvasRenderPipeline.DrawTexturedRect(Rect(currentX, currentY, ForegroundIcon.Width, ForegroundIcon.Height), ForegroundIcon, ForegroundTint, currentDepth);
					currentX += Spacing + ForegroundIcon.Width;
				}
			}
		}

		public override Vector2 GetMinSize()
		{
			if (BackgroundIcon != null){
				return Vector2(
					BackgroundIcon.Width * MaxValue + (Spacing * (MaxValue - 1)),
					BackgroundIcon.Height
					);
			}
			else if (ForegroundIcon != null)
			{
				return Vector2(
					ForegroundIcon.Width * MaxValue + (Spacing * (MaxValue - 1)),
					ForegroundIcon.Height
					);
			}

			return Vector2.Zero;
		}
	}
}