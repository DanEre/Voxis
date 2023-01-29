using System.Collections;
using System;

namespace Voxis
{
	public static class GUICanvas
	{
		public static int Width { get; set; }
		public static int Height { get; set; }
		public static GUITheme Theme { get; set; }

		public static GUIElement FocusedElement { get; private set; }

		private static List<GUIScreen> screens = new List<GUIScreen>() ~ DeleteContainerAndItems!(_);
		private static Queue<GUIScreen> deletionQueue = new Queue<GUIScreen>();

		public static void AddScreen(GUIScreen screen)
		{
			screens.Add(screen);
			screen.OnEnterStack();

			SetFocused(null);
		}
		public static void QueueDeletion(GUIScreen screen)
		{
			deletionQueue.Add(screen);
		}

		public static void SetFocused(GUIElement newFocus)
		{
			if (FocusedElement != null)
			{
				FocusedElement.[Friend]IsFocused = false;
				FocusedElement.[Friend]OnFocusExit();
			}

			FocusedElement = newFocus;

			if (FocusedElement != null)
			{
				FocusedElement.[Friend]IsFocused = true;
				FocusedElement.[Friend]OnFocusEnter();
			}
		 }

		public static T SearchTaggedElement<T>(StringView tag) where T : GUIElement
		{
			for(GUIScreen screen in screens)
			{
				T temp = screen.SearchTaggedElement<T>(tag);

				if (temp != null) return temp;
			}

			return null;
		}

		public static void OnLoad()
		{
			Theme = new GUITheme();
			Theme.OnLoad();

			InputServer.OnInputEvent.Add(new => OnInputEvent);
		}

		public static void OnShutdown()
		{
			delete Theme;
			ProcessDeletionQueue();
			delete deletionQueue;
		}

		public static void OnUpdate()
		{
			ProcessDeletionQueue();

			for(GUIScreen screen in screens){
				screen.OnUpdate();
			}
		}
		public static void OnDraw()
		{
			Width = WindowServer.Width;
			Height = WindowServer.Height;

			Matrix4x4 projectionMatrix = Matrix4x4.CreateOrthographicOffCenter(0, Width, Height, 0, 0.0f, 1000.0f);
			CanvasRenderPipeline.Begin(projectionMatrix);

			int currentCanvasDepth = 0;

			for(GUIScreen screen in screens)
			{
				screen.OnDraw(currentCanvasDepth);

				currentCanvasDepth += 128;
			}
			CanvasRenderPipeline.End();
		}

		private static void OnInputEvent(InputEvent event)
		{
			// Event order is reversed (deeper childs are on top the screen so they should be evaluated first)
			for (int i = screens.Count - 1; i >= 0; i--)
			{
				screens[i].OnInputEvent(event);
			}
		}

		private static void ProcessDeletionQueue()
		{
			while(deletionQueue.Count > 0)
			{
				GUIScreen sc = deletionQueue.PopFront();
				sc.OnExitStack();
				screens.Remove(sc);
				delete sc;
			}
		}
	}
}
