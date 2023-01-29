namespace Voxis
{
	public class InputEventKeyboardKey : InputEvent
	{
		public KeyboardKey Key { get; }
		public int32 Scancode { get; }
		public InputAction Action { get; }

		public this(KeyboardKey k, int32 sc, InputAction ac)
		{
			Key = k;
			Scancode = sc;
			Action = ac;
		}
	}
}
