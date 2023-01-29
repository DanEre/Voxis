namespace Voxis
{
	public class GUITheme
	{
		public Font MainFont { get; private set; }

		public GUIStyle PanelStyle { get; private set; }
		public GUIStyle ButtonStyle { get; private set; }
		public GUIStyle ButtonHoveredStyle { get; private set; }
		public GUIStyle TextFieldStyle { get; private set; }
		public GUIStyle ProgressBarBackgroundStyle { get; private set; }
		public GUIStyle ProgressBarForegroundStyle { get; private set; }

		public SoundEffect ButtonClickEffect { get; private set; }

		public ~this()
		{
			delete PanelStyle;
			delete ButtonStyle;
			delete ButtonHoveredStyle;
			delete TextFieldStyle;
			delete ProgressBarBackgroundStyle;
			delete ProgressBarForegroundStyle;
		}

		public void OnLoad()
		{
			MainFont = ResourceServer.LoadFont("fonts/abaddon_light.ttf");

			Texture2D panelBackground = ResourceServer.LoadTexture2D("textures/gui/panel.png");
			PanelStyle = new NineSliceStyle(panelBackground, Margin(8, 8, 8, 8));

			Texture2D button = ResourceServer.LoadTexture2D("textures/gui/button.png");
			Texture2D buttonHover = ResourceServer.LoadTexture2D("textures/gui/button_hovered.png");
			ButtonStyle = new NineSliceStyle(button, Margin(4, 4, 4, 4));
			ButtonHoveredStyle = new NineSliceStyle(buttonHover, Margin(4, 4, 4, 4));

			Texture2D textfield = ResourceServer.LoadTexture2D("textures/gui/text_field.png");
			TextFieldStyle = new NineSliceStyle(textfield, Margin(4, 4, 4, 4));

			ButtonClickEffect = ResourceServer.LoadSoundEffect("sounds/button_click.wav");

			Texture2D barBack = ResourceServer.LoadTexture2D("textures/gui/progress_background.png");
			ProgressBarBackgroundStyle = new NineSliceStyle(barBack, .(4, 4, 4, 4));

			Texture2D barFore = ResourceServer.LoadTexture2D("textures/gui/progress_foreground.png");
			ProgressBarForegroundStyle = new NineSliceStyle(barFore, .(4, 4, 4, 4));
		}
	}
}
