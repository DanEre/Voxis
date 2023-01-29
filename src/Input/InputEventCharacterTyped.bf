namespace Voxis
{
	public class InputEventCharacterTyped : InputEvent
	{
		public char32 Codepoint { get; }

		public this(char32 codepoint)
		{
			Codepoint = codepoint;
		}
	}
}
