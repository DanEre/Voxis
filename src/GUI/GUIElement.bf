namespace Voxis
{
	public abstract class GUIElement
	{
		public Anchor RelAnch { get; set; }
		public Margin RelMarg { get; set; }
		public bool Enabled { get; set; }
		public bool Visible { get; set; }
		public MouseFlags EventFlags { get; set; }
		public LayoutFlags VLayoutFlags { get; set; }
		public LayoutFlags HLayoutFlags { get; set; }
		public System.String Tag { get; set; }

		// Internal state update
		public bool Hovered { get; private set; }
		public bool IsFocused { get; private set; }

		public GUIElement Parent { get; private set; }
		public virtual GUIScreen Root
		{
			get
			{
				return Parent.Root;
			}
		}
		public virtual Rect ScreenRect
		{
			get
			{
				if (Parent == null) return Rect(RelMarg.Left, RelMarg.Top, RelMarg.Right, RelMarg.Bottom);

				Rect parentRect = Parent.ScreenRect;
				return Rect.FromMinMax(
					Vector2(parentRect.X + parentRect.Width * RelAnch.XMin + RelMarg.Left, parentRect.Y + parentRect.Height * RelAnch.YMin + RelMarg.Top),
					Vector2(parentRect.X + parentRect.Width * RelAnch.XMax + RelMarg.Right, parentRect.Y + parentRect.Height * RelAnch.YMax + RelMarg.Bottom)
				);
			}
		}

		protected System.Collections.List<GUIElement> childElements = new System.Collections.List<GUIElement>() ~ DeleteContainerAndItems!(_);

		protected this()
		{
			Enabled = true;
			Visible = true;
			EventFlags = .Stop;
		}

		public void FillParent()
		{
			RelAnch = Anchor(0, 0, 1, 1);
			RelMarg = Margin(0, 0, 0, 0);
		}

		public bool CompareTag(System.StringView tagTest)
		{
			if (Tag == null) return false;

			return Tag == tagTest;
		}

		public T SearchTaggedElement<T>(System.StringView tag) where T : GUIElement
		{
			if (CompareTag(tag)) return (T)this;

			for (GUIElement child in childElements)
			{
				T temp = child.SearchTaggedElement<T>(tag);

				if (temp != null) return temp;
			}

			return null;
		}

		public void AddChild(GUIElement element)
		{
			childElements.Add(element);
			element.Parent = this;
		}

		public virtual void OnUpdate()
		{
			if (!Enabled || !Visible) return;

			for(GUIElement childElement in childElements)
			{
				childElement.OnUpdate();
			}
		}
		public virtual void OnDraw(int currentDepth)
		{
			if (!Visible) return;

			for(GUIElement childElement in childElements)
			{
				childElement.OnDraw(currentDepth + 1);
			}
		}
		public virtual void OnInputEvent(InputEvent event)
		{
			if (!Enabled || !Visible) return;

			// Reverse event order! (Bubble up)
			for (int i = childElements.Count - 1; i >= 0; i--)
			{
				childElements[i].OnInputEvent(event);
			}

			if (event.Consumed) return;

			if (event is InputEventMouseMovement)
			{
				InputEventMouseMovement movement = event as InputEventMouseMovement;

				if (ScreenRect.ContainsPoint(movement.Position))
				{
					if (EventFlags == .Stop) event.Consume();

					if(!Hovered)
					{
						Hovered = true;
						OnMouseEnter();
					}
				}
				else
				{
					if (Hovered)
					{
						Hovered = false;
						OnMouseExit();
					}
				}
			}
			else if(event is InputEventMouseButton)
			{
				InputEventMouseButton mbe = event as InputEventMouseButton;

				if(Hovered && mbe.Button == .Left && mbe.Action == .Press)
				{
					if (!event.Consumed) GUICanvas.SetFocused(this);
					OnMouseClick();
					if (EventFlags == .Stop) event.Consume();
				}
			}
		}

		public virtual Vector2 GetMinSize()
		{
			return Vector2(0, 0);
		}

		protected virtual void OnMouseEnter()
		{

		}
		protected virtual void OnMouseExit()
		{

		}
		protected virtual void OnMouseClick()
		{

		}
		protected virtual void OnFocusEnter()
		{

		}
		protected virtual void OnFocusExit()
		{

		}
	}
}
