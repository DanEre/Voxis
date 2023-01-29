using System;
using System.Collections;

namespace Voxis
{
	public static class InputServer
	{
		public static Event<delegate void(InputEvent)> OnInputEvent = Event<delegate void(InputEvent)>();

		public static float CurrentMouseX { get; private set; }
		public static float CurrentMouseY { get; private set; }

		private static Dictionary<KeyboardKey, InputState> keyboardStateMap = new Dictionary<KeyboardKey, InputState>() ~ delete _;

		public static void OnInitialize()
		{
			// Subscribe to events
			WindowServer.OnCharacterTyped.Add(new => OnCharacterTyped);
			WindowServer.OnKeyboardKey.Add(new => OnKeyboardKey);
			WindowServer.OnMouseButton.Add(new => OnMouseButton);
			WindowServer.OnMouseMovement.Add(new => OnMouseMovement);
			WindowServer.OnScroll.Add(new => OnMouseScroll);
		}

		public static void OnShutdown()
		{
			OnInputEvent.Dispose();
		}

		public static bool IsKeyPressed(KeyboardKey key)
		{
			return keyboardStateMap.ContainsKey(key) && keyboardStateMap[key] == .Pressed;
		}

		private static void OnCharacterTyped(char32 param)
		{
			OnInputEvent.Invoke(scope InputEventCharacterTyped(param));
		}
		private static void OnKeyboardKey (KeyboardKey keyboardKey, int32 scancode, InputAction inputAction)
		{
			if (inputAction == .Press)
			{
				keyboardStateMap[keyboardKey] = .Pressed;
			}
			else if(inputAction == .Release)
			{
				keyboardStateMap[keyboardKey] = .Released;
			}

			OnInputEvent.Invoke(scope InputEventKeyboardKey(keyboardKey, scancode, inputAction));
		}
		private static void OnMouseButton(MouseButton mouseButton, InputAction inputAction)
		{
			OnInputEvent.Invoke(scope InputEventMouseButton(mouseButton, inputAction));
		}
		private static void OnMouseMovement(float x, float y)
		{
			float deltaX = CurrentMouseX - x;
			float deltaY = CurrentMouseY - y;

			OnInputEvent.Invoke(scope InputEventMouseMovement(x, y, deltaX, deltaY));

			CurrentMouseX = x;
			CurrentMouseY = y;
		}
		private static void OnMouseScroll(float x, float y)
		{
			OnInputEvent.Invoke(scope InputEventMouseScroll(x, y));
		}
	}
}
