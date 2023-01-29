using Voxis.Framework;
using System;

namespace Voxis
{
	public static class WindowServer
	{
		public static uint32 Width
		{
			get
			{
				int32 height = 0;
				int32 width = 0;
				GLFW.GetWindowSize(window, &width, & height);

				return (uint32)width;
			}

			set
			{
				GLFW.SetWindowSize(window, (int32)value, (int32)Height);
			}
		}

		public static uint32 Height
		{
			get
			{
				int32 height = 0;
				int32 width = 0;
				GLFW.GetWindowSize(window, &width, &height);
				return (uint32)height;
			}
			set
			{
				GLFW.SetWindowSize(window, (int32)Width, (int32)value);
			}
		}

		public static StringView Title
		{
			get
			{
				System.Runtime.NotImplemented();
			}
			set
			{
				GLFW.SetWindowTitle(window, value.ToScopeCStr!());
			}
		}

		public static bool WindowExists
		{
			get
			{
				return !GLFW.WindowShouldClose(window);
			}
		}

		public static Event<delegate void(char32)> OnCharacterTyped = .();
		public static Event<delegate void(KeyboardKey, int32, InputAction)> OnKeyboardKey = .();
		public static Event<delegate void(float, float)> OnScroll = .();
		public static Event<delegate void(float, float)> OnMouseMovement = .();
		public static Event<delegate void(MouseButton, InputAction)> OnMouseButton = .();
		public static Event<delegate void(float, float)> OnMouseScroll = .();

		private static GLFW.GLFWWindow* window;

		public static void OnInitialize()
		{
			if (!GLFW.Init())
			{
				System.Runtime.FatalError("Failed to initialize GLFW!");
			}

			// Apply window options
			GLFW.WindowHint(GLFW.ClientEnum.OpenGLDebugContext.Underlying, GLFW.GLFW_TRUE);
			GLFW.WindowHint(GLFW.ClientEnum.ContextVersionMinor.Underlying, 5);
			GLFW.WindowHint(GLFW.ClientEnum.ContextVersionMajor.Underlying, 4);
			GLFW.WindowHint(GLFW.ClientEnum.OpenGLProfile.Underlying, GLFW.Profile.OpenGLCore.Underlying);

			window = GLFW.CreateWindow(800, 600, "Hello World", null, null);

			// Setup callbacks
			GLFW.SetCharCallback(window, => GLFW_CharCallback);
			GLFW.SetKeyCallback(window, => GLFW_KeyCallback);
			GLFW.SetMouseButtonCallback(window, => GLFW_MouseButtonCallback);
			GLFW.SetScrollCallback(window, => GLFW_ScrollCallback);
			GLFW.SetCursorPosCallback(window, => GLFW_CursorPosCallback);
			GLFW.SetScrollCallback(window, => GLFW_ScrollCallback);

			GLFW.MakeContextCurrent(window);
		}

		public static void OnShutdown()
		{
			OnCharacterTyped.Dispose();
			OnKeyboardKey.Dispose();
			OnMouseButton.Dispose();
			OnScroll.Dispose();
			OnMouseMovement.Dispose();
		}

		public static void OnUpdate()
		{
			GLFW.PollEvents();
		}

		public static OpenGL.GetProcAddressFunc GetOpenGLAdressFunction()
		{
			return => GLFW.GetProcAddress;
		}

		public static void SwapBuffers()
		{
			GLFW.SwapBuffers(window);
		}

		private static void GLFW_CharCallback(GLFW.GLFWWindow* window, uint32 codepoint)
		{
			OnCharacterTyped.Invoke(char32(codepoint));
		}
		private static void GLFW_KeyCallback(GLFW.GLFWWindow* window, int32 key, int32 scancode, int32 action, int32 mods)
		{
			KeyboardKey k = ConvertKeyboardKey((GLFW.Key)key);
			InputAction a = ConvertAction(action);

			OnKeyboardKey.Invoke(k, scancode, a);
		}
		private static void GLFW_ScrollCallback(GLFW.GLFWWindow* window, double x, double y)
		{
			OnScroll.Invoke((float)x, (float)y);
		}
		private static void GLFW_CursorPosCallback(GLFW.GLFWWindow* window, double x, double y)
		{
			OnMouseMovement.Invoke((float)x, (float)y);
		}
		private static void GLFW_MouseButtonCallback(GLFW.GLFWWindow* window, int32 button, int32 action, int32 mods)
		{
			MouseButton mb = ConvertMouseButton(button);
			InputAction ac = ConvertAction(action);

			OnMouseButton.Invoke(mb, ac);
		}

		private static MouseButton ConvertMouseButton(int32 button)
		{
			switch(button)
			{
			case GLFW.MouseButton.Left.Underlying:
				return .Left;
			case GLFW.MouseButton.Right.Underlying:
				return .Right;
			case GLFW.MouseButton.Míddle.Underlying:
				return .Middle;
			default:
				return .Middle;
			}
		}

		private static InputAction ConvertAction(int32 action)
		{
			switch(action){
			case GLFW.KeyAction.Press.Underlying:
				return .Press;
			case GLFW.KeyAction.Release.Underlying:
				return .Release;
			case GLFW.KeyAction.Repeat.Underlying:
				return .Repeat;
			default:
				System.Runtime.NotImplemented();
			}
		}

		private static KeyboardKey ConvertKeyboardKey(GLFW.Key key)
		{
			return (KeyboardKey)key.Underlying;
		}
	}
}
