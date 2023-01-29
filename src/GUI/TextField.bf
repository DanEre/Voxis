using System;

namespace Voxis
{
	public class TextField : GUIElement
	{
		public String Text { get; }

		private int editLocation = 0;

		public this()
		{
			Text = new String();

			HLayoutFlags = .Fill;
			VLayoutFlags = .ShrinkEnd;
		}

		public ~this()
		{
			delete Text;
		}

		public String CopyText()
		{
			return new String(Text);
		}

		public override void OnInputEvent(InputEvent event)
		{
			base.OnInputEvent(event);

			// No event capture if not focused (actually editing text)
			if (!IsFocused) return;

			if (!event.Consumed && event is InputEventCharacterTyped)
			{
				InputEventCharacterTyped charTyped = event as InputEventCharacterTyped;

				Text.Insert((int_strsize)editLocation, charTyped.Codepoint);
				editLocation++;
				ClampEditLocation();

				if (EventFlags == .Stop) event.Consume();
			}
			else if(!event.Consumed && event is InputEventKeyboardKey)
			{
				InputEventKeyboardKey keyEvent = event as InputEventKeyboardKey;

				if(keyEvent.Key == .Left && keyEvent.Action.IsPressOrRepeat)
				{
					editLocation--;
					// Clamp to greater zero
					ClampEditLocation();
					event.Consume();
				}
				else if(keyEvent.Key == .Right && keyEvent.Action.IsPressOrRepeat)
				{
					editLocation++;
					ClampEditLocation();
					event.Consume();
				}
				else if(keyEvent.Key == .Backspace && keyEvent.Action.IsPressOrRepeat)
				{
					if(editLocation > 0)
					{
						Text.Remove(editLocation - 1);
						editLocation--;
						ClampEditLocation();
						event.Consume();
					}
				}
			}
		}

		public override void OnDraw(int currentDepth)
		{
			base.OnDraw(currentDepth);

			GUICanvas.Theme.TextFieldStyle.OnDraw(ScreenRect, currentDepth);

			Rect contentRect = ScreenRect.ApplyMargin(GUICanvas.Theme.TextFieldStyle.ContentMargin);

			if (IsFocused) GUICanvas.Theme.MainFont.RenderTextEx(contentRect.Position, Text, editLocation, currentDepth);
			else GUICanvas.Theme.MainFont.RenderText(contentRect.Position, Text, currentDepth);
		}

		private void ClampEditLocation()
		{
			editLocation = Math.Clamp(editLocation, 0, Text.Length);
		}

		public override Vector2 GetMinSize()
		{
			GUIStyle myStyle = GUICanvas.Theme.TextFieldStyle;
			float height = GUICanvas.Theme.MainFont.LineHeight;
			return Vector2(myStyle.ContentMargin.Left + myStyle.ContentMargin.Right, height + myStyle.ContentMargin.Top + myStyle.ContentMargin.Bottom);
		}
	}
}
