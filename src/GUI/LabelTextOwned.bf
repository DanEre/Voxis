using System;

namespace Voxis
{
	public class LabelTextOwned : GUIElement
	{
		public HAlign TextHAlign { get; set; }
		public VAlign TextVAlign { get; set; }

		private String _text = new String("") ~ delete _;

		public this(StringView text = "Label")
		{
			SetText(text);

			TextHAlign = .Left;
			TextVAlign = .Center;
		}

		public void SetText(StringView newText)
		{
			_text.Clear();
			_text.Append(newText);
		}

		public override void OnDraw(int currentDepth)
		{
			base.OnDraw(currentDepth);

			Vector2 textStart = GUICanvas.Theme.MainFont.AlignTextStart(_text, ScreenRect, TextVAlign, TextHAlign);

			GUICanvas.Theme.MainFont.RenderText(textStart, _text, currentDepth);
		}

		public override Vector2 GetMinSize()
		{
			return Vector2(GUICanvas.Theme.MainFont.MeasureText(_text), GUICanvas.Theme.MainFont.LineHeight);
		}
	}
}
