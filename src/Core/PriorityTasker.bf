using System.Collections;

namespace Voxis
{
	public static class PriorityTasker
	{
		private struct WorkItem
		{
			public System.Threading.WorkDelegate WorkToDo;
			public int Priority;

			public this(System.Threading.WorkDelegate del, int prio)
			{
				WorkToDo = del;
				Priority = prio;
			}

			public void Dispose()
			{
				delete WorkToDo;
			}
		}

		public static int MaxDispatch = 8;
		public static Vector3 PointOfInterest = Vector3.Zero;

		private static List<WorkItem> actions = new List<WorkItem>();

		public static void ClearTasks()
		{
			DeleteContainerAndDisposeItems!(actions);
		}

		public static void DispatchTasks()
		{
			actions.Sort(scope (a, b) => {
				if (a.Priority < b.Priority) return -1;
				else if (a.Priority > b.Priority) return 1;
				return 0;
				});

			for (int i = 0; i < MaxDispatch && !actions.IsEmpty; i++)
			{
				System.Threading.ThreadPool.QueueUserWorkItem(actions.PopFront().WorkToDo);
			}
		}

		public static void AddTask(System.Threading.WorkDelegate work, int prio)
		{
			actions.Add(WorkItem(work, prio));
		}

		public static void AddPOITask(System.Threading.WorkDelegate work, Vector3 position)
		{
			AddTask(work, int(Vector3.Distance(position, PointOfInterest)));
		}
	}
}