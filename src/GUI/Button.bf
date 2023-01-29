using System;

namespace Voxis
{
	public class Button : GUIElement
	{
		public StringView Text { get; set; }

		public VAlign TextVAlign { get; set; }
		public HAlign TextHAlign { get; set; }

		public Event<delegate void()> OnClickEvent = Event<delegate void()>();

		public this(StringView text = "Button")
		{
			Text = text;

			TextVAlign = .Center;
			TextHAlign = .Center;

			HLayoutFlags = .Fill;
			VLayoutFlags = .ShrinkCenter;
		}

		public ~this()
		{
			OnClickEvent.Dispose();
		}

		public override void OnDraw(int currentDepth)
		{
			base.OnDraw(currentDepth);

			if (Hovered)
				GUICanvas.Theme.ButtonHoveredStyle.OnDraw(ScreenRect, currentDepth);
			else
				GUICanvas.Theme.ButtonStyle.OnDraw(ScreenRect, currentDepth);

			Rect contentRect = ScreenRect.ApplyMargin(GUICanvas.Theme.ButtonStyle.ContentMargin);

			Vector2 textStart = GUICanvas.Theme.MainFont.AlignTextStart(Text, contentRect, TextVAlign, TextHAlign);

			GUICanvas.Theme.MainFont.RenderText(textStart, Text, currentDepth);
		}

		protected override void OnMouseClick()
		{
			base.OnMouseClick();

			AudioServer.PlayOnce(GUICanvas.Theme.ButtonClickEffect);

			OnClickEvent.Invoke();
		}

		public override Vector2 GetMinSize()
		{
			GUIStyle myStyle = GUICanvas.Theme.ButtonStyle;

			return Vector2(
				GUICanvas.Theme.MainFont.MeasureText(Text) + myStyle.ContentMargin.Left + myStyle.ContentMargin.Right,
				GUICanvas.Theme.MainFont.LineHeight + myStyle.ContentMargin.Top + myStyle.ContentMargin.Bottom
				);
		}
	}
}
