using System;

namespace Voxis
{
	public class PlayerHUD : GUIScreen
	{
		public Player Player { get; set; } = null;

		private LabelTextOwned performanceLabel;

		public override void OnEnterStack()
		{
			base.OnEnterStack();

			Texture2D crosshairTexture = ResourceServer.LoadTexture2D("textures/gui/crosshair.png");

			ImageRect crosshair = new ImageRect(crosshairTexture);
			crosshair.RelAnch = .Center;
			crosshair.RelMarg = .(-crosshairTexture.Width * 0.5f, -crosshairTexture.Height * 0.5f, crosshairTexture.Width * 0.5f, crosshairTexture.Height * 0.5f);
			AddChild(crosshair);

			IconProgressBar healthBar = new IconProgressBar();
			healthBar.MaxValue = 10;
			healthBar.Value = 5;
			healthBar.BackgroundIcon = ResourceServer.LoadTexture2D("textures/gui/health_back.png");
			healthBar.ForegroundIcon = ResourceServer.LoadTexture2D("textures/gui/health_fore.png");
			Vector2 healthBarSize = healthBar.GetMinSize();
			healthBar.RelAnch = .(0.5f, 1.0f, 0.5f, 1.0f);
			healthBar.RelMarg = .(-healthBarSize.X * 0.5f, -healthBarSize.Y, healthBarSize.X * 0.5f, 0.0f);
			AddChild(healthBar);

			performanceLabel = new LabelTextOwned();
			performanceLabel.RelAnch = .(0, 0, 1, 1);
			performanceLabel.RelMarg = .(0, 0, 0, 0);
			performanceLabel.TextHAlign = .Left;
			performanceLabel.TextVAlign = .Top;
			AddChild(performanceLabel);
		}

		public override void OnUpdate()
		{
			base.OnUpdate();

			String tempString = scope String();
			tempString.AppendF("Drawcall3D: {0}\nCanvas Drawcalls: {1}\nPrimitive Drawcalls: {2}", Performance.LastFrame.DrawCalls3D, Performance.LastFrame.DrawCallsCanvas, Performance.LastFrame.DrawPrimitive);
			
			performanceLabel.SetText(tempString);
		}

		public override void OnDraw(int currentDepth)
		{
			base.OnDraw(currentDepth);

			Block selectedBlock = GameRegistry.Block.GetAtIndex(Player.SelectedBlockIndex);

			if (selectedBlock != null && selectedBlock.DefaultState.Model != null)
			{
				Quaternion rotation = Quaternion.CreateFromAxisAngle(Vector3.UnitX, ExtMath.Deg2Rad(225.0f));
				rotation *= Quaternion.CreateFromAxisAngle(Vector3.UnitY, ExtMath.Deg2Rad(45.0f));

				CanvasRenderPipeline.DrawBlockModel(selectedBlock.DefaultState.Model, Vector3(200,200,0), rotation, Vector3(100));
			}
		}
	}
}
