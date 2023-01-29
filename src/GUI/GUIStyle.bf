namespace Voxis
{
	public abstract class GUIStyle
	{
		public Margin ContentMargin { get; protected set; }

		public abstract void OnDraw(Rect contentRect, int depth, Color tint = .White);
	}
}
