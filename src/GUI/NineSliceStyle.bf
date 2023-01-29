namespace Voxis
{
	public class NineSliceStyle : GUIStyle
	{
		public Texture2D Texture { get; }
		public Margin SliceBorder { get; }

		public this(Texture2D texture, Margin border)
		{
			Texture = texture;
			SliceBorder = border;

			ContentMargin = border;
		}

		public override void OnDraw(Rect contentRect, int depth, Color tint = .White)
		{
			// Center
			CanvasRenderPipeline.DrawNineSlice(contentRect, Texture, SliceBorder, tint, depth);
		}
	}
}
