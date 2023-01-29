namespace Voxis
{
	public class Component
	{
		public Entity Owner { get; private set; }

		public virtual void OnComponentAdded(){}
		public virtual void OnComponentRemove(){}
		public virtual void OnComponentDestroy(){}

		public virtual void OnUpdate(){}
		public virtual void OnRender(){}
	}
}
