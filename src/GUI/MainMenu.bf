namespace Voxis
{
	public class MainMenu : GUIScreen
	{
		public override void OnEnterStack()
		{
			base.OnEnterStack();

			Panel panel = new Panel();
			AddChild(panel);
			panel.RelAnch = Anchor(0.5f, 0.5f, 0.5f, 0.5f);
			panel.RelMarg = Margin(-200.0f, -150.0f, 200.0f, 150.0f);

			VerticalBox vbox = new VerticalBox();
			panel.AddChild(vbox);
			vbox.RelAnch = Anchor(0, 0, 1, 1);
			vbox.RelMarg = Margin(0, 0, 0, 0);

			vbox.AddChild(new Label("Voxis - Main Menu"));

			Button loadWorldButton = new Button("Load World");
			vbox.AddChild(loadWorldButton);
			Button createWorldButton = new Button("Create World");
			vbox.AddChild(createWorldButton);
			Button optionsButton = new Button("Options");
			vbox.AddChild(optionsButton);
			Button modsButton = new Button("Mods");
			vbox.AddChild(modsButton);
			Button exitButton = new Button("Exit");
			vbox.AddChild(exitButton);

			createWorldButton.OnClickEvent.Add(new => OnCreateWorldClick);
		}

		private void OnCreateWorldClick()
		{
			GUICanvas.AddScreen(new WorldCreationMenu());

			GUICanvas.QueueDeletion(this);
		}
	}
}
