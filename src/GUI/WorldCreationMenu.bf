namespace Voxis
{
	public class WorldCreationMenu : GUIScreen
	{
		private TextField nameInput;
		private TextField seedInput;

		public override void OnEnterStack()
		{
			base.OnEnterStack();

			Panel panel = new Panel();
			AddChild(panel);
			panel.RelAnch = .Center;
			panel.RelMarg = Margin(-200f, -150f, 200f, 150f);

			VerticalBox vbox = new VerticalBox();
			panel.AddChild(vbox);
			vbox.FillParent();
			vbox.AddChild(new Label("Create new World"));

			vbox.AddChild(new Label("Name:"));
			nameInput = new TextField();
			vbox.AddChild(nameInput);

			vbox.AddChild(new Label("Seed:"));
			seedInput = new TextField();
			vbox.AddChild(seedInput);

			Button createButton = new Button("Create");
			Button cancelButton = new Button("Cancel");

			cancelButton.OnClickEvent.Add(new => OnCancelClick);
			createButton.OnClickEvent.Add(new => OnCreateClick);

			vbox.AddChild(createButton);
			vbox.AddChild(cancelButton);
		}

		private void OnCancelClick()
		{
			GUICanvas.AddScreen(new MainMenu());

			GUICanvas.QueueDeletion(this);
		}

		private void OnCreateClick()
		{
			GUICanvas.AddScreen(new WorldLoadingScreen());

			GUICanvas.QueueDeletion(this);

			VoxisGame.Instance.SetWorld(new World(nameInput.CopyText(), seedInput.CopyText()));
		}
	}
}
