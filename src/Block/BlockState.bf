using System;
using System.Collections;

namespace Voxis
{
	public class BlockState
	{
		public BlockModel Model { get; set; }
		public Block Block { get; }
		public BlockStateContainer Container { get; }

		private Dictionary<IBlockStateProperty, Object> properties;

		public this(Block block, BlockStateContainer container)
		{
			Block = block;
			Container = container;
			properties = new Dictionary<IBlockStateProperty, Object>();
		}
		public this(BlockState cloneFrom)
		{
			Block = cloneFrom.Block;
			Container = cloneFrom.Container;
			properties = new Dictionary<IBlockStateProperty, Object>();
			for(let prop in cloneFrom.properties)
			{
				properties.Add(prop.key, prop.value);
			}
		}
		public ~this()
		{
			DeleteDictionaryAndValues!(properties);
			delete Model;
		}

		public void InsertProperty(IBlockStateProperty property, Object value)
		{
			properties.Add(property, value);
		}
		public Object GetProperty<T>(IBlockStateProperty property)
		{
			return properties[property];
		}
		public BlockState With(IBlockStateProperty property, Object value)
		{
			return Container.With(this, property, value);
		}
		public BoundingBox GetCollisionBox()
		{
			return Block.GetCollisionBox(this);
		}
		public bool DoesOcclude(OcclusionDirection fromDirection)
		{
			return Block.DoesOcclude(this, fromDirection);
		}
		public bool HasCollision()
		{
			return Block.HasCollision(this);
		}
		public bool LetsLightThrough()
		{
			return Block.LetsLightThrough(this);
		}
	}
}
