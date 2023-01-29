using System;

namespace Voxis
{
	public class Block : RegistryObject
	{
		public BlockStateContainer BlockStateContainer { get; };
		public BlockModelBaker ModelBaker { get; set; }

		public BlockState DefaultState
		{
			get
			{
				return BlockStateContainer.DefaultState;
			}
		}

		public this()
		{
			BlockStateContainer = new BlockStateContainer(this);

			AppendProperties(BlockStateContainer);

			BlockStateContainer.Build();
		}

		public ~this()
		{
			delete BlockStateContainer;
			if (ModelBaker != null) delete ModelBaker;
		}

		public virtual bool GeneratesCollision(BlockState state)
		{
			return true;
		}
		public virtual bool DoesRender(BlockState state)
		{
			return true;
		}
		public virtual bool DoesOcclude(BlockState state, OcclusionDirection direction)
		{
			return true;
		}
		public virtual BoundingBox GetCollisionBox(BlockState state)
		{
			return BoundingBox(.Zero, .One);
		}
		public virtual bool HasCollision(BlockState state)
		{
			return true;
		}
		public virtual bool LetsLightThrough(BlockState state)
		{
			return false;
		}
		public virtual VoxelLights GetLightValue(BlockState state)
		{
			return VoxelLights.Empty;
		}

		protected virtual void AppendProperties(BlockStateContainer container)
		{

		}
	}
}
