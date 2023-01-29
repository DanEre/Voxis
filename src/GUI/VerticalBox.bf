namespace Voxis
{
	public class VerticalBox : GUIElement
	{
		public Margin Padding { get; set; }
		public float Spacing { get; set; }

		public bool ShrinkHeight { get; set; }
		public bool ShrinkWidth { get; set; }

		public this()
		{
			Padding = Margin(5, 5, 5, 5);
			Spacing = 3.0f;

			ShrinkHeight = true;
		}

		public override void OnUpdate()
		{
			base.OnUpdate();

			float currentX = Padding.Left;
			float currentY = Padding.Top;

			// Calculate remaining fill space and already used space by aligned children
			float availableHeight = ScreenRect.Height - Padding.Top - Padding.Bottom;
			availableHeight -= (childElements.Count - 1) * Spacing;
			int fillElements = 0;
			for(GUIElement child in childElements)
			{
				if (child.VLayoutFlags != .Fill)
				{
					availableHeight -= child.GetMinSize().Y;
				}
				else
				{
					fillElements++;
				}
			}
			float fillHeight = availableHeight / (fillElements > 0 ? fillElements : 1);

			for (int i = 0; i < childElements.Count; i++)
			{
				GUIElement current = childElements[i];

				// Calculate size depending on the layout flags
				Vector2 wantedSize = current.GetMinSize();
				if (current.HLayoutFlags == .Fill)
				{
					wantedSize.X = ScreenRect.Width - Padding.Left - Padding.Right;
				}
				if (current.VLayoutFlags == .Fill)
				{
					wantedSize.Y = fillHeight;
				}

				// Calculate anchoring in respect to layout options
				float xAnchor = 0.0f;
				if (current.HLayoutFlags == .Fill)
				{
					xAnchor = currentX;
				}
				else if(current.HLayoutFlags == .ShrinkCenter)
				{
					xAnchor = ScreenRect.Width * 0.5f - wantedSize.X * 0.5f;
				}
				else if(current.HLayoutFlags == .ShrinkEnd)
				{
					xAnchor = ScreenRect.Width - Padding.Right - wantedSize.X;
				}
				else
				{
					xAnchor = currentX;
				}

				current.RelAnch = Anchor.Zero;
				current.RelMarg = Margin(xAnchor, currentY, xAnchor + wantedSize.X, currentY + wantedSize.Y);

				currentY += wantedSize.Y + Spacing;
			}

			// TODO: Remaining vertical Space filling is NOT IMPLEMENTED (LayoutFlags.Fill)
		}

		// OLD ALGORITHM
		/*float targetWidth = ScreenRect.Width - Padding.Left - Padding.Right;
		float targetHeight = (ScreenRect.Height - Padding.Top - Padding.Bottom - ((childElements.Count - 1) * Spacing)) / childElements.Count;

		for(int i = 0; i < childElements.Count; i++)
		{
			GUIElement current = childElements[i];
			current.RelAnch = Anchor(0, 0, 0, 0);
			current.RelMarg = Margin(Padding.Left, Padding.Top + (i * Spacing) + i * targetHeight, Padding.Left + targetWidth, Spacing * i + Padding.Top + i * targetHeight + targetHeight);
		}*/
	}
}
