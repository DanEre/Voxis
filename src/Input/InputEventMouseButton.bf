namespace Voxis
{
	public class InputEventMouseButton : InputEvent
	{
		public MouseButton Button { get; }
		public InputAction Action { get; }

		public this(MouseButton button, InputAction action)
		{
			Button = button;
			Action = action;
		}
	}
}
