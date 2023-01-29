using System;

namespace Voxis
{
	// Fast Access to a working chunck with its neighbours
	// Working coordinates are in local space relative to the
	// working chunck. Center chunck is at x = 0 y = 0 z = 0
	public class ChunckAccess : IWorldAccessRead, IWorldAccessWrite
	{
		private Chunck[] chuncks;
		private ChunckIndex indexOffset;

		public bool Locked { get; private set; }
		public Chunck[] ChunckArray
		{
			get
			{
				return chuncks;
			}
		}

		public this()
		{
			this.chuncks = new Chunck[27];
			this.indexOffset = indexOffset;
		}

		public ~this()
		{
			delete chuncks;
		}

		public void LockChuncks()
		{
			if (Locked) Runtime.FatalError("Tried to lock chunck access twice");

			Locked = true;
			for (Chunck ch in chuncks)
			{
				ch.Locked = true;
			}
		}
		public void UnlockChuncks()
		{
			Locked = false;
			for (Chunck ch in chuncks)
			{
				 ch.Locked = false;
			}
		}

		public void UpdateState(Chunck[] newArray, ChunckIndex newOffset)
		{
			if (Locked) Runtime.FatalError("Tried to modify a locked chunck access");

			chuncks = newArray;
			indexOffset = newOffset;
		}

		// The chunck in the middle
		public Chunck GetWorkingChunck()
		{
			return chuncks[13];
		}

		public BlockState GetBlockState(BlockPos position)
		{
			let localPos = position.GetChunckLocalPosition();
			return chunckFromBlockPos(position).GetBlockState(localPos.x, localPos.y, localPos.z);
		}
		public void SetBlockState(BlockPos position, BlockState state, BlockstatUpdateFlags flags = BlockstatUpdateFlags.All)
		{
			let localPos = position.GetChunckLocalPosition();
			chunckFromBlockPos(position).SetBlockState(localPos.x, localPos.y, localPos.z, state, flags);
		}
		public void SetLight(BlockPos position, VoxelLights lights)
		{
			let localPos = position.GetChunckLocalPosition();
			chunckFromBlockPos(position).SetLightRaw
				(localPos.x, localPos.y, localPos.z, lights);
		}
		public void SetLightNoUpdate(BlockPos position, VoxelLights lights)
		{
			let localPos = position.GetChunckLocalPosition();
			chunckFromBlockPos(position).SetLightRaw
				(localPos.x, localPos.y, localPos.z, lights);
		}
		public VoxelLights GetLight(BlockPos pos)
		{
			let localPos = pos.GetChunckLocalPosition();
			return chunckFromBlockPos(pos).GetLight(localPos.x, localPos.y, localPos.z);
		}

		private Chunck chunckFromBlockPos(BlockPos position)
		{
			ChunckIndex index = position.GetChunckIndex();
			index = index.Offset(-indexOffset.X, -indexOffset.Y, -indexOffset.Z);
			index = index.Offset(1, 1, 1);

			return chuncks[index.Z * 9 + index.Y * 3 + index.X];
		}
	}
}
