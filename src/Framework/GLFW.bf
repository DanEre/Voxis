using System;
using System.Interop;

namespace Voxis.Framework
{
	public static class GLFW
	{
		public const c_int GLFW_TRUE = 1;
		public const c_int GLFW_FALSE = 0;

		public enum InitHint
		{
			JoystickHatButtons = 0x00050001,
			CocoaCHDIRResources = 0x00051001,
			CocoaMenubar = 0x00051002
		}

		public enum KeyAction
		{
			Release = 0,
			Press = 1,
			Repeat = 2,
		}

		public enum HatState
		{
			Centered = 0,
			Up = 1,
			Right = 2,
			Down = 4,
			Left = 8,
			RightUp = Right | Up,
			RightDown = Right | Down,
			LeftUp = Left | Up,
			LeftDown = Left | Down,
		}

		public enum Key
		{
			Unknown = -1,
			Space = 32,
			Apostrophe = 39,
			Comma = 44,
			Minus = 45,
			Period = 46,
			Slash = 47,
			Key0 = 48,
			Key1 = 49,
			Key2 = 50,
			Key3 = 51,
			Key4 = 52,
			Key5 = 53,
			Key6 = 54,
			Key7 = 55,
			Key8 = 56,
			Key9 = 57,
			Semicolon = 59,
			Equal = 61,
			KeyA = 65,
			KeyB = 66,
			KeyC = 67,
			KeyD = 68,
			KeyE = 69,
			KeyF = 70,
			KeyG = 71,
			KeyH = 72,
			KeyI = 73,
			KeyJ = 74,
			KeyK = 75,
			KeyL = 76,
			KeyM = 77,
			KeyN = 78,
			KeyO = 79,
			KeyP = 80,
			KeyQ = 81,
			KeyR = 82,
			KeyS = 83,
			KeyT = 84,
			KeyU = 85,
			KeyV = 86,
			KeyW = 87,
			KeyX = 88,
			KeyY = 89,
			KeyZ = 90,
			LeftBracket = 91,
			Backslash = 92,
			RightBracket = 93,
			GraveAccent = 96,
			World1 = 161,
			World2 = 162,
			Escapce = 256,
			Enter = 257,
			Tab = 258,
			Backspace = 259,
			Insert = 260,
			Delete = 261,
			Right = 262,
			Left = 263,
			Down = 264,
			Up = 265,
			PageUp = 266,
			PageDown = 267,
			Home = 268,
			End =269,
			CapsLock = 280,
			ScrollLock = 281,
			NumLock = 282,
			PrintScreen = 283,
			Pause = 284,
			F1 = 290,
			F2 = 291,
			F3 = 292,
			F4 = 293,
			F5 = 294,
			F6 = 295,
			F7 = 296,
			F8 = 297,
			F9 = 298,
			F10 = 299,
			F11 = 300,
			F12 = 301,
			F13 = 302,
			F14 = 303,
			F15 = 304,
			F16 = 305,
			F17 = 306,
			F18 = 307,
			F19 = 308,
			F20 = 309,
			F21 = 310,
			F22 = 311,
			F23 = 312,
			F24 = 313,
			F25 = 314,
			KP0 = 320,
			KP1 = 321,
			KP2 = 322,
			KP3 = 323,
			KP4 = 324,
			KP5 = 325,
			KP6 = 326,
			KP7 = 327,
			KP8 = 328,
			KP9 = 329,
			KPDecimal = 330,
			KPDivide = 331,
			KPMultiply = 332,
			KPSubtract = 333,
			KPAdd = 334,
			KPEnter = 335,
			KPEqual = 336,
			LeftShift = 340,
			LeftControl = 341,
			LeftAlt = 342,
			LeftSuper = 343,
			RightShift = 344,
			RightControl = 345,
			RightAlt = 346,
			RightSuper = 347,
			Menu = 348,
		}

		public enum KeyModifier
		{
			Shift = 0x0001,
			Control = 0x0002,
			Alt = 0x0004,
			Super = 0x0008,
			CapsLock = 0x0010,
			NumLock = 0x0020,
		}

		[AllowDuplicates]
		public enum MouseButton
		{
			Button1 = 0,
			Button2 = 1,
			Button3 = 2,
			Button4 = 3,
			Button5 = 4,
			Button6 = 5,
			Button7 = 6,
			Button8 = 7,
			Left = Button1,
			Right = Button2,
			Míddle = Button3,
		}

		public enum Joystick
		{
			Joystick1 = 0,
			Joystick2 = 1,
			Joystick3 = 2,
			Joystick4 = 3,
			Joystick5 = 4,
			Joystick6 = 5,
			Joystick7 = 6,
			Joystick8 = 7,
			Joystick9 = 8,
			Joystick10 = 9,
			Joystick11 = 10,
			Joystick12 = 11,
			Joystick13 = 12,
			Joystick14 = 13,
			Joystick15 = 14,
			Joystick16 = 15,
		}

		[AllowDuplicates]
		public enum GamepadButton
		{
			A = 0,
			B = 1,
			X = 2,
			Y = 3,
			LeftBumper = 4,
			RightBumper = 5,
			Back = 6,
			Start = 7,
			Guide = 8,
			LeftThumb = 9,
			RightThumb = 10,
			DPadUp = 11,
			DPadRight = 12,
			DPadDown = 13,
			DPadLeft = 14,

			Cross = A,
			Circle = B,
			Square = X,
			Triangle = Y
		}

		public enum GamepadAxis
		{
			LeftX = 0,
			LeftY = 1,
			RightX = 2,
			RightY = 3,
			LeftTrigger = 4,
			RightTrigger = 5,
		}

		public enum ErrorCode
		{
			NoError = 0,
			NotInitialized = 0x00010001,
			NoCurrentContext = 0x00010002,
			InvalidEnum = 0x00010003,
			InvalidValue = 0x00010004,
			OutOfMemory = 0x00010005,
			APIUnavailable = 0x00010006,
			VersionUnavailable = 0x00010007,
			PlatformError = 0x00010008,
			FormatUnavailable = 0x00010009,
			NoWindowContext = 0x0001000A,
		}

		public enum WindowState
		{
			Focused = 0x00020001,
			Iconified = 0x00020002,
			Resizable = 0x00020003,
			Visible = 0x00020004,
			Decorated = 0x00020005,
			Iconify = 0x00020006,
			Floating = 0x00020007,
			Maximized = 0x00020008,
			CenterCursor = 0x00020009,
			TransparentFramebuffer = 0x0002000A,
			Hovered = 0x0002000B,
			FocusOnShow = 0x0002000C,
		}

		public enum FramebufferBitDepth
		{
			RedBits = 0x00021001,
			GreenBits = 0x00021002,
			BlueBits = 0x00021003,
			AlphaBits = 0x00021004,
			DepthBits = 0x00021005,
			StencilBits = 0x00021006,
			AccumRedBits = 0x00021007,
			AccumGreenBits = 0x00021008,
			AccumBlueBits = 0x00021009,
			AccumAlphaBits = 0x0002100A,
			AuxBuffers = 0x0002100B,
			Stereo = 0x0002100C,
			Samples = 0x0002100D,
			SRGBCapable = 0x0002100E,
			RefreshRate = 0x0002100F,
			DoubleBuffer = 0x00021010,
		}

		public enum ClientEnum
		{
			ClientAPI = 0x00022001,
			ContextVersionMajor = 0x00022002,
			ContextVersionMinor = 0x00022003,
			ContextRevision = 0x00022004,
			ContextRobustness = 0x00022005,
			OpenGLForwardCompat = 0x00022006,
			OpenGLDebugContext = 0x00022007,
			OpenGLProfile = 0x00022008,
			ContextReleaseBehaviour = 0x00022009,
			ContextNoError = 0x0002200A,
			ContextCreationAPI = 0x0002200B,
			ScaleToMonitor = 0x0002200C,
			COCOARetinaFramebuffer = 0x00023001,
			COCOAFrameName = 0x00023002,
			COCOAGraphicsSwitching = 0x00023003,
			X11ClassName = 0x00024001,
			X11InstanceName = 0x00024002
		}

		public enum API
		{
			NoAPI = 0,
			OpenGL = 0x00030001,
			OpenGLES = 0x00030002
		}

		public enum ContextRobustness
		{
			None = 0,
			ResetNotification = 0x00031001,
			LoseOnReset = 0x00031002
		}

		public enum Profile
		{
			Any = 0,
			OpenGLCore = 0x00032001,
			OpenFLCompat = 0x00032002
		}

		public enum KeyMode
		{
			Cursor = 0x00033001,
			StickyKeys = 0x00033002,
			StickyMouseButtons = 0x00033003,
			LockKeyMods = 0x00033004,
			RawMouseMotion = 0x00033005
		}

		public enum CursorState
		{
			Normal = 0x00034001,
			Hidden = 0x00034002,
			Disabled = 0x00034003
		}

		public enum ReleaseBehaviour
		{
			Any = 0,
			Flush = 0x00035001,
			None = 0x00035002
		}

		public enum ContextAPI
		{
			Native = 0x00036001,
			ELG = 0x00036002,
			OSMesa = 0x00036003
		}

		public enum CursorShape
		{
			Arrow = 0x00036001,
			IBeam = 0x00036002,
			Crosshair = 0x00036003,
			Hand = 0x00036004,
			HResize = 0x00036005,
			VResize = 0x00036006
		}

		public enum MonitorConnectionState
		{
			Connected = 0x00040001,
			Disconnected = 0x00040002
		}

		[CRepr]
		public struct GLFWMonitor;

		[CRepr]
		public struct GLFWWindow;

		[CRepr]
		public struct GLFWCursor;

		public function void ErrorCallback(c_int errorCode, char8* error);
		public function void WindowPositionCallback(GLFWWindow* window, c_int posX, c_int posY);
		public function void WindowSizeCallback(GLFWWindow* window, c_int width, int height);
		public function void WindowCloseCallback(GLFWWindow* window);
		public function void WindowRefreshCallback(GLFWWindow* window);
		public function void WindowFocusCallback(GLFWWindow* window, c_int focus);
		public function void WindowIconifyCallback(GLFWWindow* window, c_int icon);
		public function void WindowMaximizeCallback(GLFWWindow* window, c_int max);
		public function void FramebufferSizeCallback(GLFWWindow* window, c_int width, c_int height);
		public function void WindowContentScaleCallback(GLFWWindow* window, float width, float height);
		public function void MouseButtonCallback(GLFWWindow* window, c_int mouseButton, c_int action, c_int modifiers);
		public function void CursorPositionCallback(GLFWWindow* window, double x, double y);
		public function void CursorEnterCallback(GLFWWindow* window, c_int entered);
		public function void ScrollCallback(GLFWWindow* window, double x, double y);
		public function void KeyCallback(GLFWWindow* window, c_int key, c_int scancode, c_int action, c_int mods);
		public function void CharacterCallback(GLFWWindow* window, uint32 codepoint);
		public function void CharacterModifiedCallback(GLFWWindow* window, uint32 codepoint, c_int mods);
		public function void DropCallback(GLFWWindow* window, c_int pathCount, char8*[] paths);
		public function void MonitorCallback(GLFWMonitor* monitor, c_int event);
		public function void JoystickCallback(c_int joystickID, c_int event);

		[CRepr]
		public struct VideoMode
		{
			public c_int Width;
			public c_int Height;
			public c_int RedBits;
			public c_int GreenBits;
			public c_int BlueBits;
			public c_int RefreshRate;
		}

		[CRepr]
		public struct GammaRamp
		{
			public int16* Red;
			public int16* Green;
			public int16* Blue;
			public uint16 Size;
		}

		[CRepr]
		public struct Image
		{
			public c_int Width;
			public c_int Height;
			public uint8* Pixels;
		}

		[CRepr]
		public struct GamepadState
		{
			public uint8[15] Buttons;
			public float[6] Axes;
		}

		[CLink]
		private extern static c_int glfwInit();
		public static bool Init()
		{
			c_int result = glfwInit();
			return result == GLFW_TRUE;
		}

		[CLink]
		private extern static void glfwTerminate();
		public static void Terminate(){
			glfwTerminate();
		}

		[CLink]
		private extern static void glfwInitHint(c_int hint, c_int value);
		public static void InitHint(InitHint hint, bool enabled){
			glfwInitHint(hint.Underlying, enabled ? GLFW_TRUE : GLFW_FALSE);
		}

		[CLink]
		private extern static void glfwGetVersion(c_int* major, c_int* minor, c_int* rev);
		public static void GetVersion(ref c_int major, ref c_int minor, ref c_int rev){
			glfwGetVersion(&major, &minor, &rev);
		}

		[CLink]
		private extern static char8* glfwGetVersionString();
		public static void GetVersionString(String buffer){
			buffer.Append(glfwGetVersionString());
		}

		[CLink]
		private extern static c_int glfwGetError(char8** description);
		public static ErrorCode GetError(String buffer){
			char8* chars = scope char8();
			c_int error = glfwGetError(&chars);
			if(chars != null) buffer.Append(chars);
			return (ErrorCode)error;
		}

		[CLink]
		private extern static ErrorCallback glfwSetErrorCallback(ErrorCallback errorFunc);
		public static ErrorCallback SetErrorCallback(ErrorCallback errorFunction){
			return glfwSetErrorCallback(errorFunction);
		}

		[CLink]
		private extern static GLFWMonitor** glfwGetMonitors(c_int* count);
		public static GLFWMonitor** GetMonitors(c_int* count){
			return glfwGetMonitors(count);
		}

		[CLink]
		private extern static GLFWMonitor* glfwGetPrimaryMonitor();
		public static GLFWMonitor* GetPrimaryMonitor(){
			return glfwGetPrimaryMonitor();
		}

		[CLink]
		private extern static void glfwGetMonitorPos(GLFWMonitor* monitor, c_int* xpos, c_int* ypos);
		public static void GetMonitorPos(GLFWMonitor* monitor, c_int* xpos, c_int* ypos){
			glfwGetMonitorPos(monitor, xpos, ypos);
		}

		[CLink]
		private extern static void glfwGetMonitorWorkarea(GLFWMonitor* monitor, c_int* xpos, c_int* ypos, c_int* width, c_int* height);
		public static void GetMonitorWorkingArea(GLFWMonitor* monitor, c_int* xpos, c_int* ypos, c_int* widht, c_int* height){
			glfwGetMonitorWorkarea(monitor, xpos, ypos, widht, height);
		}

		[CLink]
		private extern static void glfwGetMonitorPhysicalSize(GLFWMonitor* monitor, c_int* widthMM, c_int* heightMM);
		public static void GetMonitorPhysicalSize(GLFWMonitor* monitor, c_int* widthMM, c_int* heightMM){
			glfwGetMonitorPhysicalSize(monitor, widthMM, heightMM);
		}

		[CLink]
		private extern static void glfwGetMonitorContentScale(GLFWMonitor* monitor, float* xScale, float* yScale);
		public static void GetMonitorContentScale(GLFWMonitor* monitor, float* xscale, float* yscale){
			glfwGetMonitorContentScale(monitor, xscale, yscale);
		}

		[CLink]
		private extern static char8* glfwGetMonitorName(GLFWMonitor* monitor);
		public static char8* GetMonitorName(GLFWMonitor* monitor){
			return glfwGetMonitorName(monitor);
		}

		[CLink]
		private extern static void glfwSetMonitorUserPointer(GLFWMonitor* monitor, void* pointer);
		public static void SetMonitorUserPointer(GLFWMonitor* monitor, void* pointer){
			glfwSetMonitorUserPointer(monitor, pointer);
		}

		[CLink]
		private extern static void* glfwGetMonitorUserPointer(GLFWMonitor* monitor);
		public static void* GetMonitorUserPointer(GLFWMonitor* monitor){
			return glfwGetMonitorUserPointer(monitor);
		}

		[CLink]
		private extern static MonitorCallback glfwSetMonitorCallback(MonitorCallback callback);
		public static MonitorCallback SetMonitorCallback(MonitorCallback callback){
			return glfwSetMonitorCallback(callback);
		}

		[CLink]
		private extern static VideoMode* glfwGetVideoModes(GLFWMonitor* monitor, c_int* count);
		public static VideoMode* GetVideoModes(GLFWMonitor* monitor, c_int* count){
			return glfwGetVideoModes(monitor, count);
		}

		[CLink]
		private extern static VideoMode* glfwGetVideoMode(GLFWMonitor* monitor);
		public static VideoMode* GetVideoMode(GLFWMonitor* monitor){
			return glfwGetVideoMode(monitor);
		}

		[CLink]
		private extern static void glfwSetGamma(GLFWMonitor* monitor, float gamma);
		public static void SetGamma(GLFWMonitor* monitor, float gamma){
			glfwSetGamma(monitor, gamma);
		}

		[CLink]
		private extern static GammaRamp* glfwGetGammaRamp(GLFWMonitor* monitor);
		public static GammaRamp* GetGammaRamp(GLFWMonitor* monitor){
			return glfwGetGammaRamp(monitor);
		}

		[CLink]
		private extern static void glfwSetGammaRamp(GLFWMonitor* monitor, GammaRamp* ramp);
		public static void SetGammaRamp(GLFWMonitor* monitor, GammaRamp* ramp){
			glfwSetGammaRamp(monitor, ramp);
		}

		[CLink]
		private extern static void glfwDefaultWindowHints();
		public static void DefaultWindowHints(){
			glfwDefaultWindowHints();
		}

		[CLink]
		private extern static void glfwWindowHint(c_int hint, c_int value);
		public static void WindowHint(c_int hint, c_int value){
			glfwWindowHint(hint, value);
		}

		[CLink]
		private extern static void glfwWindowHintString(c_int hint, char8* value);
		public static void WindowHintString(c_int hint, char8* value){
			glfwWindowHintString(hint, value);
		}

		[CLink]
		private extern static GLFWWindow* glfwCreateWindow(c_int widht, c_int height, char8* title, GLFWMonitor* monitor, GLFWWindow* share);
		public static GLFWWindow* CreateWindow(c_int width, c_int height, char8* title, GLFWMonitor* monitor, GLFWWindow* share){
			return glfwCreateWindow(width, height, title, monitor, share);
		}

		[CLink]
		private extern static void glfwDestroyWindow(GLFWWindow* window);
		public static void DestroyWindow(GLFWWindow* window){
			glfwDestroyWindow(window);
		}

		[CLink]
		private extern static int glfwWindowShouldClose(GLFWWindow* window);
		public static bool WindowShouldClose(GLFWWindow* window){
			return glfwWindowShouldClose(window) == GLFW_TRUE;
		}

		[CLink]
		private extern static void glfwSetWindowShouldClose(GLFWWindow* window, c_int value);
		public static void SetWindowShouldClose(GLFWWindow* window, c_int value){
			glfwSetWindowShouldClose(window, value);
		}

		[CLink]
		private extern static void glfwSetWindowTitle(GLFWWindow* window, char8* title);
		public static void SetWindowTitle(GLFWWindow* window, char8* title){
			glfwSetWindowTitle(window, title);
		}

		[CLink]
		private extern static void glfwSetWindowIcon(GLFWWindow* window, c_int count, Image* images);
		public static void SetWindowIcon(GLFWWindow* window, c_int count, Image* images){
			glfwSetWindowIcon(window, count, images);
		}

		[CLink]
		private extern static void glfwGetWindowPos(GLFWWindow* window, c_int* xpos, c_int* ypos);
		public static void GetWindowPos(GLFWWindow* window, c_int* xpos, c_int* ypos){
			glfwGetWindowPos(window, xpos, ypos);
		}

		[CLink]
		private extern static void glfwSetWindowPos(GLFWWindow* window, c_int xpos, c_int ypos);
		public static void SetWindowPos(GLFWWindow* window, c_int xpos, c_int ypos){
			glfwSetWindowPos(window, xpos, ypos);
		}

		[CLink]
		private extern static void glfwGetWindowSize(GLFWWindow* window, c_int* widht, c_int* height);
		public static void GetWindowSize(GLFWWindow* window, c_int* widht, c_int* height){
			glfwGetWindowSize(window, widht, height);
		}

		[CLink]
		private extern static void glfwSetWindowSizeLimits(GLFWWindow* window, c_int minWidth, c_int minHeight, c_int maxWidth, c_int maxHeight);
		public static void SetWindowSizeLimits(GLFWWindow* window, c_int mintWidth, c_int minHeight, c_int maxWidth, c_int maxHeight){
			glfwSetWindowSizeLimits(window, mintWidth, minHeight, maxWidth, maxHeight);
		}

		[CLink]
		private extern static void glfwSetWindowAspectRatio(GLFWWindow* window, c_int numer, c_int denom);
		public static void SetWindowAspectRatio(GLFWWindow* window, c_int numer, c_int denom){
			glfwSetWindowAspectRatio(window, numer, denom);
		}

		[CLink]
		private extern static void glfwSetWindowSize(GLFWWindow* window, c_int width, c_int height);
		public static void SetWindowSize(GLFWWindow* window, c_int width, c_int height){
			glfwSetWindowSize(window, width, height);
		}

		[CLink]
		private extern static void glfwGetFramebufferSize(GLFWWindow* window, c_int* width, c_int* height);
		public static void GetFramebufferSize(GLFWWindow* window, c_int* width, c_int* height){
			glfwGetFramebufferSize(window, width, height);
		}

		[CLink]
		private extern static void glfwGetWindowFrameSize(GLFWWindow* window, c_int* left, c_int* top, c_int* right, c_int* bottom);
		public static void GetWindowFrameSize(GLFWWindow* window, c_int* left, c_int* top, c_int* right, c_int* bottom){
			glfwGetWindowFrameSize(window, left, top, right, bottom);
		}

		[CLink]
		private extern static void glfwGetWindowContentScale(GLFWWindow* window, float* xScale, float* yScale);
		public static void GetWindowContentScale(GLFWWindow* window, float* xScale, float* yScale){
			glfwGetWindowContentScale(window, xScale, yScale);
		}

		[CLink]
		private extern static float glfwGetWindowOpacity(GLFWWindow* window);
		public static float GetWindowOpacity(GLFWWindow* window){
			return glfwGetWindowOpacity(window);
		}

		[CLink]
		private extern static void glfwSetWindowOpacity(GLFWWindow* window, float opacity);
		public static void SetWindowOpacity(GLFWWindow* window, float opacity){
			glfwSetWindowOpacity(window, opacity);
		}

		[CLink]
		private extern static void glfwIconifyWindow(GLFWWindow* window);
		public static void IconifyWindow(GLFWWindow* window){
			glfwIconifyWindow(window);
		}

		[CLink]
		private extern static void glfwRestoreWindow(GLFWWindow* window);
		public static void RestoreWindow(GLFWWindow* window){
			glfwRestoreWindow(window);
		}

		[CLink]
		private extern static void glfwMaximizeWindow(GLFWWindow* window);
		public static void MaximizeWindow(GLFWWindow* window){
			glfwMaximizeWindow(window);
		}

		[CLink]
		private extern static void glfwShowWindow(GLFWWindow* window);
		public static void ShowWindow(GLFWWindow* window){
			glfwShowWindow(window);
		}

		[CLink]
		private extern static void glfwHideWindow(GLFWWindow* window);
		public static void HideWindow(GLFWWindow* window){
			glfwHideWindow(window);
		}

		[CLink]
		private extern static void glfwFocusWindow(GLFWWindow* window);
		public static void FocusWindow(GLFWWindow* window){
			glfwFocusWindow(window);
		}

		[CLink]
		private extern static void glfwRequestWindowAttention(GLFWWindow* window);
		public static void RequestWindowAttention(GLFWWindow* window){
			glfwRequestWindowAttention(window);
		}

		[CLink]
		private extern static GLFWMonitor* glfwGetWindowMonitor(GLFWWindow* window);
		public static GLFWMonitor* GetWindowMonitor(GLFWWindow* window){
			return glfwGetWindowMonitor(window);
		}

		[CLink]
		private extern static void glfwSetWindowMonitor(GLFWWindow* window, GLFWMonitor* monitor, int xpos, int ypos, int widht, int height, int refreshRate);
		public static void SetWindowMonitor(GLFWWindow* window, GLFWMonitor* monitor, int xpos, int ypos, int width, int height, int refreshRate){
			glfwSetWindowMonitor(window, monitor, xpos, ypos, width, height, refreshRate);
		}

		[CLink]
		private extern static int glfwGetWindowAttrib(GLFWWindow* window, int attrib);
		public static void GetWindowAttrib(GLFWWindow* window, int attrib){
			glfwGetWindowAttrib(window, attrib);
		}

		[CLink]
		private extern static void glfwSetWindowAttrib(GLFWWindow* window, int attrib, int value);
		public static void SetWindowAttrib(GLFWWindow* window, int attrib, int value){
			glfwSetWindowAttrib(window, attrib, value);
		}

		[CLink]
		private extern static void glfwSetWindowUserPointer(GLFWWindow* window, void* pointer);
		public static void SetWindowUserPointer(GLFWWindow* window, void* pointer){
			glfwSetWindowUserPointer(window, pointer);
		}

		[CLink]
		private extern static void* glfwGetWindowUserPointer(GLFWWindow* window);
		public static void* GetWindowUserPointer(GLFWWindow* window){
			return glfwGetWindowUserPointer(window);
		}

		[CLink]
		private extern static WindowPositionCallback glfwSetWindowPosCallback(GLFWWindow* window, WindowPositionCallback callback);
		public static WindowPositionCallback SetWindowPositionCallback(GLFWWindow* window, WindowPositionCallback callback){
			return glfwSetWindowPosCallback(window, callback);
		}

		[CLink]
		private extern static WindowSizeCallback glfwSetWindowSizeCallback(GLFWWindow* window, WindowSizeCallback callback);
		public static WindowSizeCallback SetWindowPositionCallback(GLFWWindow* window, WindowSizeCallback callback){
			return glfwSetWindowSizeCallback(window, callback);
		}

		[CLink]
		private extern static WindowCloseCallback glfwSetWindowCloseCallback(GLFWWindow* window, WindowCloseCallback callback);
		public static WindowCloseCallback SetWindowCloseCallback(GLFWWindow* window, WindowCloseCallback callback){
			return glfwSetWindowCloseCallback(window, callback);
		}

		[CLink]
		private extern static WindowRefreshCallback glfwSetWindowRefreshCallback(GLFWWindow* window, WindowRefreshCallback callback);
		public static WindowRefreshCallback SetWindowRefreshCallback(GLFWWindow* window, WindowRefreshCallback callback){
			return glfwSetWindowRefreshCallback(window, callback);
		}

		[CLink]
		private extern static WindowFocusCallback glfwSetWindowFocusCallback(GLFWWindow* window, WindowFocusCallback callback);
		public static WindowFocusCallback SetWindowFocusCallback(GLFWWindow* window, WindowFocusCallback callback){
			return glfwSetWindowFocusCallback(window, callback);
		}

		[CLink]
		private extern static WindowIconifyCallback glfwSetWindowIconifyCallback(GLFWWindow* window, WindowIconifyCallback callback);
		public static WindowIconifyCallback Window(GLFWWindow* window, WindowIconifyCallback callback){
			return glfwSetWindowIconifyCallback(window, callback);
		}

		[CLink]
		private extern static WindowMaximizeCallback glfwSetWindowMaximizeCallback(GLFWWindow* window, WindowMaximizeCallback callback);
		public static WindowMaximizeCallback SetWindowPositionCallback(GLFWWindow* window, WindowMaximizeCallback callback){
			return glfwSetWindowMaximizeCallback(window, callback);
		}

		[CLink]
		private extern static FramebufferSizeCallback glfwSetFramebufferSizeCallback(GLFWWindow* window, FramebufferSizeCallback callback);
		public static FramebufferSizeCallback SetFramebufferSizeCallback(GLFWWindow* window, FramebufferSizeCallback callback){
			return glfwSetFramebufferSizeCallback(window, callback);
		}

		[CLink]
		private extern static WindowContentScaleCallback glfwSetWindowContentScaleCallback(GLFWWindow* window, WindowContentScaleCallback callback);
		public static WindowContentScaleCallback SetWindowPositionCallback(GLFWWindow* window, WindowContentScaleCallback callback){
			return glfwSetWindowContentScaleCallback(window, callback);
		}

		[CLink]
		private extern static void glfwPollEvents();
		public static void PollEvents(){
			glfwPollEvents();
		}

		[CLink]
		private extern static void glfwWaitEvents();
		public static void WaitEvents(){
			glfwWaitEvents();
		}

		[CLink]
		private extern static void glfwWaitEventsTimeout(double timeout);
		public static void WaitEventsTimeout(double timeout){
			glfwWaitEventsTimeout(timeout);
		}

		[CLink]
		private extern static void glfwPostEmptyEvent();
		public static void PostEmptyEvent(){
			glfwPostEmptyEvent();
		}

		[CLink]
		private extern static c_int glfwGetInputMode(GLFWWindow* window, int mode);
		public static c_int GetInputMode(GLFWWindow* window, int mode){
			return glfwGetInputMode(window, mode);
		}

		[CLink]
		private extern static void glfwSetInputMode(GLFWWindow* window, int mode, int value);
		public static void SetInputMode(GLFWWindow* window, c_int mode, c_int value){
			glfwSetInputMode(window, mode, value);
		}

		[CLink]
		private extern static int glfwRawMouseMotionSupported();
		public static bool RawMouseMotionSupported(){
			return glfwRawMouseMotionSupported() == GLFW_TRUE;
		}

		[CLink]
		private extern static char8* glfwGetKeyName(c_int key, c_int scancode);
		public static char8* GetKeyName(c_int key, c_int scancode){
			return glfwGetKeyName(key, scancode);
		}

		[CLink]
		private extern static c_int glfwGetKeyScancode(c_int key);
		public static c_int GetKeyScancode(c_int key){
			return glfwGetKeyScancode(key);
		}

		[CLink]
		private extern static c_int glfwGetKey(GLFWWindow* window, c_int key);
		public static c_int GetKey(GLFWWindow* window, c_int key){
			return glfwGetKey(window, key);
		}

		[CLink]
		private extern static c_int glfwGetMouseButton(GLFWWindow* window, int button);
		public static c_int GetMouseButton(GLFWWindow* window, int button){
			return glfwGetMouseButton(window, button);
		}

		[CLink]
		private extern static void glfwGetCursorPos(GLFWWindow* window, double* xpos, double* ypos);
		public static void GetCursorPos(GLFWWindow* window, double* xpos, double* ypos){
			glfwGetCursorPos(window, xpos, ypos);
		}

		[CLink]
		private extern static void glfwSetCursorPos(GLFWWindow* window, double xpos, double ypos);
		public static void SetCursorPos(GLFWWindow* window, double xpos, double ypos){
			glfwSetCursorPos(window, xpos, ypos);
		}

		[CLink]
		private extern static GLFWCursor* glfwCreateCursor(Image* image, c_int xhot, c_int yhot);
		public static GLFWCursor* CreateCursor(Image* image, c_int xhot, c_int yhot){
			return glfwCreateCursor(image, xhot, yhot);
		}

		[CLink]
		private	extern static GLFWCursor* glfwCreateStandardCursor(c_int shape);
		public static GLFWCursor* CreateStandardCursor(c_int shape){
			return glfwCreateStandardCursor(shape);
		}

		[CLink]
		private extern static void glfwDestroyCursor(GLFWCursor* cursor);
		public static void DestroyCursor(GLFWCursor* cursor){
			glfwDestroyCursor(cursor);
		}

		[CLink]
		private extern static void glfwSetCursor(GLFWWindow* window, GLFWCursor* cursor);
		public static void SetCursor(GLFWWindow* window, GLFWCursor* cursor){
			glfwSetCursor(window, cursor);
		}

		[CLink]
		private extern static KeyCallback glfwSetKeyCallback(GLFWWindow* window, KeyCallback callback);
		public static KeyCallback SetKeyCallback(GLFWWindow* window, KeyCallback callback){
			return glfwSetKeyCallback(window, callback);
		}

		[CLink]
		private extern static CharacterCallback glfwSetCharCallback(GLFWWindow* window, CharacterCallback callback);
		public static CharacterCallback SetCharCallback(GLFWWindow* window, CharacterCallback callback){
			return glfwSetCharCallback(window, callback);
		}

		[CLink]
		private extern static CharacterModifiedCallback glfwSetCharModsCallback(GLFWWindow* window, CharacterModifiedCallback callback);
		public static CharacterModifiedCallback SetCharModsCallback(GLFWWindow* window, CharacterModifiedCallback callback){
			return glfwSetCharModsCallback(window, callback);
		}

		[CLink]
		private extern static MouseButtonCallback glfwSetMouseButtonCallback(GLFWWindow* window, MouseButtonCallback callback);
		public static MouseButtonCallback SetMouseButtonCallback(GLFWWindow* window, MouseButtonCallback callback){
			return glfwSetMouseButtonCallback(window, callback);
		}

		[CLink]
		private extern static CursorPositionCallback glfwSetCursorPosCallback(GLFWWindow* window, CursorPositionCallback callback);
		public static CursorPositionCallback SetCursorPosCallback(GLFWWindow* window, CursorPositionCallback callback){
			return glfwSetCursorPosCallback(window, callback);
		}

		[CLink]
		private extern static CursorEnterCallback glfwSetCursorEnterCallback(GLFWWindow* window, CursorEnterCallback callback);
		public static CursorEnterCallback SetCursorEnterCallback(GLFWWindow* window, CursorEnterCallback callback){
			return glfwSetCursorEnterCallback(window, callback);
		}

		[CLink]
		private extern static ScrollCallback glfwSetScrollCallback(GLFWWindow* window, ScrollCallback callback);
		public static ScrollCallback SetScrollCallback(GLFWWindow* window, ScrollCallback callback){
			return glfwSetScrollCallback(window, callback);
		}

		[CLink]
		private extern static DropCallback glfwSetDropCallback(GLFWWindow* window, DropCallback callback);
		public static DropCallback SetDropCallback(GLFWWindow* window, DropCallback callback){
			return glfwSetDropCallback(window, callback);
		}

		[CLink]
		private extern static c_int glfwJoystickPresent(c_int jid);
		public static bool JoystickPresent(c_int jid){
			return glfwJoystickPresent(jid) == GLFW_TRUE;
		}

		[CLink]
		private extern static float* glfwGetJoystickAxes(c_int jid, c_int* count);
		public static float* GetJoystickAxes(c_int jid, c_int* count){
			return glfwGetJoystickAxes(jid, count);
		}

		[CLink]
		private extern static uint8* glfwGetJoystickButtons(c_int jid, c_int* count);
		public static uint8* GetJoystickButtons(c_int jid, c_int* count){
			return glfwGetJoystickButtons(jid, count);
		}

		[CLink]
		private extern static uint8* glfwGetJoystickHats(c_int jid, c_int* count);
		public static uint8* GetJoystickHats(c_int jid, c_int* count){
			return glfwGetJoystickHats(jid, count);
		}

		[CLink]
		private extern static char8* glfwGetJoystickName(c_int jid);
		public static char8* GetJoystickName(c_int jid){
			return glfwGetJoystickName(jid);
		}

		[CLink]
		private extern static char8* glfwGetJoystickGUID(c_int jid);
		public static char8* GetJoystickGUID(c_int jid){
			return glfwGetJoystickGUID(jid);
		}

		[CLink]
		private extern static void glfwSetJoystickUserPointer(c_int jid, void* pointer);
		public static void SetJoystickUserPointer(c_int jid, void* pointer){
			glfwSetJoystickUserPointer(jid, pointer);
		}

		[CLink]
		private extern static void* glfwGetJoystickUserPointer(c_int jid);
		public static void* GetJoystickUserPointer(c_int jid){
			return glfwGetJoystickUserPointer(jid);
		}

		[CLink]
		private extern static c_int glfwJoystickIsGamepad(c_int jid);
		public static bool JoystickIsGamepad(c_int jid){
			return glfwJoystickIsGamepad(jid) == GLFW_TRUE;
		}

		[CLink]
		private extern static JoystickCallback glfwSetJoystickCallback(JoystickCallback callback);
		public static JoystickCallback SetJoystickCallback(JoystickCallback callback){
			return glfwSetJoystickCallback(callback);
		}

		[CLink]
		private extern static c_int glfwUpdateGamepadMappings(char8* string);
		public static c_int UpdateGamepadMappings(char8* string){
			return glfwUpdateGamepadMappings(string);
		}

		[CLink]
		private extern static char8* glfwGetGamepadName(c_int jid);
		public static char8* GetGamepadName(c_int jid){
			return glfwGetGamepadName(jid);
		}

		[CLink]
		private extern static c_int glfwGetGamepadState(c_int jid, GamepadState* state);
		public static c_int GetGamepadState(c_int jid, GamepadState* state){
			return glfwGetGamepadState(jid, state);
		}

		[CLink]
		private extern static void glfwSetClipboadString(GLFWWindow* window, char8* string);
		public static void SetClipboardString(GLFWWindow* window, char8* string){
			glfwSetClipboadString(window, string);
		}

		[CLink]
		private extern static char8* glfwGetClipboardString(GLFWWindow* window);
		public static char8* GetClipboardString(GLFWWindow* window){
			return glfwGetClipboardString(window);
		}

		[CLink]
		private extern static double glfwGetTime();
		public static double GetTime(){
			return glfwGetTime();
		}

		[CLink]
		private extern static void glfwSetTime(double time);
		public static void SetTime(double time){
			glfwSetTime(time);
		}

		[CLink]
		private extern static uint64 glfwGetTimerValue();
		public static uint64 GetTimerValue(){
			return glfwGetTimerValue();
		}

		[CLink]
		private extern static uint64 glfwGetTimerFrequeny();
		public static uint64 GetTimerFrequeny(){
			return glfwGetTimerFrequeny();
		}

		[CLink]
		private extern static void glfwMakeContextCurrent(GLFWWindow* window);
		public static void MakeContextCurrent(GLFWWindow* window){
			glfwMakeContextCurrent(window);
		}

		[CLink]
		private extern static GLFWWindow* glfwGetCurrentContext();
		public static GLFWWindow* GetCurrentContext(){
			return glfwGetCurrentContext();
		}

		[CLink]
		private extern static void glfwSwapBuffers(GLFWWindow* window);
		public static void SwapBuffers(GLFWWindow* window){
			glfwSwapBuffers(window);
		}

		[CLink]
		private extern static void glfwSwapInterval(c_int interval);
		public static void SwapInterval(c_int interval){
			glfwSwapInterval(interval);
		}

		[CLink]
		private extern static c_int glfwExtensionSupported(char8* ext);
		public static bool ExtensionSupported(char8* ext){
			return glfwExtensionSupported(ext) == GLFW_TRUE;
		}

		[CLink]
		private extern static void* glfwGetProcAddress(char8* procname);
		public static void* GetProcAddress(StringView procname){
			return glfwGetProcAddress(procname.ToScopeCStr!());
		}

		[CLink]
		private extern static c_int glfwVulkanSupported();
		public static bool VulkanSupported(){
			return glfwVulkanSupported() == GLFW_TRUE;
		}

		[CLink]
		private extern static char8** glfwGetRequiredInstanceExtensions(c_uint* count);
		public static char8** GetRequiredInstanceExtensions(c_uint* count){
			return glfwGetRequiredInstanceExtensions(count);
		}
	}
}
