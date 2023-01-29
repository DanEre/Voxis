namespace Voxis
{
	public class ImageRect : GUIElement
	{
		public Texture2D Texture { get; set; }

		public this(Texture2D texture)
		{
			Texture = texture;
		}

		public override void OnDraw(int currentDepth)
		{
			CanvasRenderPipeline.DrawTexturedRect(ScreenRect, Texture, .(0, 0, Texture.Width, Texture.Height), .White, currentDepth);

			base.OnDraw(currentDepth);
		}
	}
}
