using System;
using System.Collections;

namespace Voxis
{
	public class BlockStateContainer
	{
		public Block Block { get; }
		public BlockState DefaultState { get; private set; }

		private List<IBlockStateProperty> properties = new List<IBlockStateProperty>() ~ delete _;

		private BlockState[] states;

		public this(Block block)
		{
			Block = block;
		}

		public ~this()
		{
			for(BlockState state in states)
			{
				delete state;
			}
			delete states;
		}

		public void Append(IBlockStateProperty property)
		{
			properties.Add(property);
		}

		public BlockState[] GetAll()
		{
			return states;
		}

		public BlockState With(BlockState template, IBlockStateProperty property, Object value)
		{
			for(BlockState state in states)
			{
				bool matches = true;

				for(IBlockStateProperty existing in properties)
				{
					Object val1 = state.GetProperty<Object>(existing);
					Object val2 = template.GetProperty<Object>(existing);

					if (property == existing)
					{
						if (!existing.Matches(val1, val1))
						{
							matches = false;
							break;
						}
					}
					else
					{
						if (!existing.Matches(val1, val2))
						{
							matches = false;
							break;
						}
					}
				}

				if (matches) return state;
			}

			Runtime.FatalError("Failed determining BlockState with modified value.");
		}

		public void Build()
		{
			List<BlockState> generatedStates = new List<BlockState>();

			for(IBlockStateProperty property in properties)
		    {
		        List<BlockState> newGenStates = new List<BlockState>();
			    if(generatedStates.Count == 0)
			    {
			        for(Object val in property.PossibleValues)
			        {
			            newGenStates.Add(new BlockState(Block, this)..InsertProperty(property, val));
		            }
		        }
		        else
			    {
			        for (BlockState state in generatedStates)
		            {
		                for (Object val in property.PossibleValues)
			            {
							BlockState copyState = new BlockState(state);
							copyState.InsertProperty(property, val);
							newGenStates.Add(copyState);
			            }
					}
				}
				delete generatedStates;
				generatedStates = newGenStates;
		    }

			if (generatedStates.Count == 0) generatedStates.Add(new BlockState(Block, this));

			states = new BlockState[generatedStates.Count];
			generatedStates.CopyTo(states);

			delete generatedStates;

			DefaultState = states[0];
		}
	}
}
