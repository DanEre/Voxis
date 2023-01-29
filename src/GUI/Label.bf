using System;

namespace Voxis
{
	public class Label : GUIElement
	{
		public StringView Text { get; set; }
		public HAlign TextHAlign { get; set; }
		public VAlign TextVAlign { get; set; }

		public this(StringView text = "Label")
		{
			Text = text;

			TextHAlign = .Left;
			TextVAlign = .Center;

			HLayoutFlags = .None;
			VLayoutFlags = .None;
		}

		public override void OnDraw(int currentDepth)
		{
			base.OnDraw(currentDepth);

			Vector2 textStart = GUICanvas.Theme.MainFont.AlignTextStart(Text, ScreenRect, TextVAlign, TextHAlign);

			GUICanvas.Theme.MainFont.RenderText(textStart, Text, currentDepth);
		}

		public override Vector2 GetMinSize()
		{
			return Vector2(GUICanvas.Theme.MainFont.MeasureText(Text), GUICanvas.Theme.MainFont.LineHeight);
		}
	}
}
