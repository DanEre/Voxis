namespace Voxis
{
	public class Panel : GUIElement
	{
		public override void OnDraw(int currentDepth)
		{
			GUICanvas.Theme.PanelStyle.OnDraw(ScreenRect, currentDepth);

			base.OnDraw(currentDepth);
		}
	}
}
