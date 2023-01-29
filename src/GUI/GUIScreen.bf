namespace Voxis
{
	public abstract class GUIScreen : GUIElement
	{
		public override GUIScreen Root
		{
			get
			{
				return this;
			}
		}

		public override Rect ScreenRect
		{
			get
			{
				return Rect(0, 0, GUICanvas.Width, GUICanvas.Height);
			}
		}

		private GUICanvas canvas;

		public this()
		{
			// This is only an invisible container, dont stop events!
			EventFlags = .Pass;
		}

		public void SetCanvas(GUICanvas canvas)
		{
			this.canvas = canvas;
		}

		public virtual void OnEnterStack(){}
		public virtual void OnExitStack(){}
	}
}
