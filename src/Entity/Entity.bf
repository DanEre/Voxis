using System;
using System.Collections;

namespace Voxis
{
	public class Entity
	{
		public String Name { get; set; }
		public String Tag { get; set; }
		public World World { get; set; }

		public Vector3 LocalPosition { get; set; }
		public Quaternion LocalRotation { get; set; }

		public Matrix4x4 ModelMatrix
		{
			get
			{
				Matrix4x4 temp = Matrix4x4.CreateTranslation(LocalPosition);
				temp.Transform(LocalRotation);
				temp *= Matrix4x4.CreateScale(Vector3.One);

				return temp;
			}
		}

		private bool started = false;

		private List<Component> components = new List<Component>();

		public this()
		{

		}
		public ~this()
		{
			delete components;
		}

		// Creates and adds a new component instance
		// TODO: Testing needed, could be buggy
		public T AddComponent<T>() where T : Component
		{
			Type t = typeof(T);
			T instance = t.CreateObject().Value as T;

			AddComponent(instance);

			return instance;
		}

		// Adds a component to an entity
		public Component AddComponent(Component component)
		{
			if (component.Owner != null)
			{
				Runtime.FatalError("Component already attached to another Entity! Cant add single component to multiple entites!");
			}

			component.[Friend]Owner = this;

			component.OnComponentAdded();

			return component;
		}

		// Finds a component, return null if none found
		public T GetComponent<T>() where T : Component
		{
			for(Component c in components)
			{
				if (c is T) return c;
			}

			return null;
		}

		// Only removes a component
		public void RemoveComponent(Component componentToRemove)
		{
			if (components.Contains(componentToRemove))
			{
				componentToRemove.OnComponentRemove();

				components.Remove(componentToRemove);

				componentToRemove.[Friend]Owner = null;
			}
			else
			{
				Runtime.FatalError("Component wasnt found on Entity");
			}
		}

		// Removes AND destroys a component on an Entity
		public void DestroyComponent(Component componentToRemove)
		{
			if (components.Contains(componentToRemove))
			{
				RemoveComponent(componentToRemove);

				componentToRemove.OnComponentDestroy();

				delete componentToRemove;
			}
			else
			{
				Runtime.FatalError("Could not find component on entity");
			}
		}

		public virtual void OnUpdate()
		{
			if (!started)
			{
				OnStart();
				started = true;
			}
		}
		public virtual void OnRender(Camera camera)
		{

		}
		public virtual void OnDestroy()
		{
			for (Component c in components)
			{
				DestroyComponent(c);
			}
		}
		public virtual void OnFixedUpdate()
		{

		}
		public virtual void OnTick()
		{

		}
		public virtual void OnInputEvent(InputEvent event)
		{

		}
		public virtual void OnCollectCameras(System.Collections.List<Camera> cameraList)
		{

		}

		protected virtual void OnStart()
		{

		}
	}
}
