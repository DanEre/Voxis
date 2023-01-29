using System.Threading;

namespace Voxis
{
	public class Chunck
	{
		public enum StateFlags
		{
			New = 0,
			TerrainGenerated = 1,
			FeaturesGenerated = 1 << 1,
			StructuresGenerated = 1 << 2,
			Postprocessed = 1 << 3,
			Finished = TerrainGenerated | FeaturesGenerated | StructuresGenerated | Postprocessed
		}

		public const int LOG_SIZE = 5;
		public const int SIZE = 1 << LOG_SIZE;
		public const int MASK = SIZE - 1;

		public World World { get; }
		public ChunckIndex Index { get; }
		public Vector3 Position { get { return Vector3(Index.X, Index.Y, Index.Z) * SIZE; } }
		public Vector3Int PositionI { get { return Vector3Int(Index.Y * SIZE, Index.Y * SIZE, Index.Z * SIZE); } }
		public StateFlags CurrentState { get; private set; }
		public bool Locked { get; set; }
		public bool MeshDirty { get; set; }
		public bool MeshNeedsApply { get; set; }
		public bool MeshDrawable { get; set; }
		public bool LightmapDirty { get; set; }
		public int CurrentLoadTime { get; private set; }
		public bool Visible { get; private set; }
		public BoundingBox Bounds { get { return BoundingBox(Position, Position + Vector3(SIZE, SIZE, SIZE)); } }
		public bool IsUnloaded { get; set; } = false;

		private BlockStorage blockStorage;
		private bool started = false;
		private ChunckMesh chunckMesh;
		private ChunckAccess localAccessCache = new ChunckAccess() ~ delete _;
		private Mesh mesh = new Mesh(false) ~ delete _;
		private Lightmap lightmap = new Lightmap() ~ delete _;

		private System.Collections.Queue<BlockPos> lightUpdateQueue = new System.Collections.Queue<BlockPos>() ~ delete _;
		private System.Collections.Queue<LightupdateEntry> lightRemovalQueue = new System.Collections.Queue<LightupdateEntry>() ~ delete _;

		public this(World world, ChunckIndex index)
		{
			World = world;
			Index = index;
			blockStorage = new BlockStorage(SIZE);
		}

		public ~this()
		{
			delete blockStorage;

			if (chunckMesh != null) delete chunckMesh;
		}

		public BlockState GetBlockState(int x, int y, int z)
		{
			return blockStorage.GetBlockState(x, y, z);
		}
		public void SetBlockState(int x, int y, int z, BlockState blockstate, BlockstatUpdateFlags flags = BlockstatUpdateFlags.All)
		{
			blockStorage.SetBlockState(x, y, z, blockstate);

			if (flags.HasFlag(BlockstatUpdateFlags.Neighbours))
			{
				 World.CheckNeighbourUpdate(Index, x, y, z);
			}
			if (flags.HasFlag(BlockstatUpdateFlags.Lighting))
			{
				// Propagate light from neighbours, block is broken or transparent block was placed
				if (blockstate.LetsLightThrough())
				{
					World.PropagateNeighbourLighting(BlockPos(x, y, z).AddChunckIndexOffset(Index));
				}
				// Solid block placed, handle removal of the current lightvalue
				else
				{
					lightRemovalQueue.Add(LightupdateEntry(BlockPos(x, y, z).AddChunckIndexOffset(Index), VoxelLights.Empty));
				}

				LightmapDirty = true;
			}
			if (flags.HasFlag(BlockstatUpdateFlags.MeshUpdate)) MeshDirty = true;
		}

		public void MarkLightUpdate(BlockPos pos)
		{
			lightUpdateQueue.Add(pos);
			LightmapDirty = true;
		}

		// Set blockstate without any updates, not even meshing
		public void SetBlockstateRaw(int x, int y, int z, BlockState stat)
		{
			blockStorage.SetBlockState(x, y, z, stat);
		}

		// Set blockstate without updating lightmap
		public void SetLightRaw(int x, int y, int z, VoxelLights light)
		{
			lightmap.SetLight(x, y, z, light);

			LightmapDirty = true;
		}

		public VoxelLights GetLight(int x, int y, int z)
		{
			return lightmap.GetLight(x, y, z);	
		}

		public void SetFlag(StateFlags flag)
		{
			CurrentState = CurrentState | flag;
		}
		public bool HasFlag(StateFlags flag)
		{
			return CurrentState.HasFlag(flag);
		}

		public void OnUpdate()
		{
			if (!started)
			{
				started = true;
				OnStart();
				return;
			}

			OnUpdateState();
		}
		public void OnRender(Camera camera)
		{
			Visible = camera.Frustrum.Intersects(Bounds);

			if (MeshDrawable)
			{
				Matrix4x4 modelMatrix = Matrix4x4.CreateTranslation(Position);
				camera.DrawMesh(mesh, modelMatrix, ChunckVertex.Layout, RenderPipeline3D.ChunckRenderMaterial, BoundingBox(Position, Position + Vector3(SIZE, SIZE, SIZE)));
			}
		}
		public void OnTick()
		{

		}
		public void OnFixedUpdate(){

		}

		public void KeepLoaded(int ticks)
		{
			CurrentLoadTime = System.Math.Max(ticks, CurrentLoadTime);
		}

		private void OnStart()
		{

		}
		private void OnUpdateState()
		{
			// Chunck is being worked on or used by others
			if (Locked) return;

			// Check if chunk should be unloaded
			CurrentLoadTime -= 1;
			if(CurrentLoadTime < 0)
			{
				World.UnloadChunck(Index);
				return;
			}

			if (CurrentState != .Finished)
			{
				if(!HasFlag(.TerrainGenerated))
				{
					Locked = true;
					PriorityTasker.AddPOITask(new () => { World.TerrainGenerator.GenerateBaseTerrain(this); }, Position);
					return;
				}

				if (!World.GetChunckAccess(Index, ref localAccessCache))
				{
					return;
				}

				if(!HasFlag(.FeaturesGenerated))
				{
					localAccessCache.LockChuncks();
					PriorityTasker.AddPOITask(new () => { World.TerrainGenerator.GenerateFeatures(localAccessCache); }, Position);
				}
				else if(!HasFlag(.StructuresGenerated))
				{
					localAccessCache.LockChuncks();
					PriorityTasker.AddPOITask(new () => { World.TerrainGenerator.GenerateStructures(localAccessCache); }, Position);
				}
				else if(!HasFlag(.Postprocessed))
				{
					localAccessCache.LockChuncks();
					PriorityTasker.AddPOITask(new () => { World.TerrainGenerator.PostprocessTerrain(localAccessCache); }, Position);
				}
			}
			else if (LightmapDirty)
			{
				if (World.GetChunckAccess(Index, ref localAccessCache))
				{
					localAccessCache.LockChuncks();

					LightmapDirty = false;

					PriorityTasker.AddPOITask(new () => { Lightmap.GenerateLightmap(localAccessCache); }, Position);
				}
			}
			else if(MeshDirty && Visible)
			{
				// Dont mesh if we dont have anything to mesh
				if (blockStorage.IsAir)
				{
					// Save on RAM usage
					if (chunckMesh != null) delete chunckMesh;

					MeshDirty = false;
				}
				else if (World.GetChunckAccess(Index, ref localAccessCache))
				{
					localAccessCache.LockChuncks();

					MeshDirty = false;

					PriorityTasker.AddPOITask(new () => { ChunckMesher.CreateMesh(localAccessCache); }, Position);
				}
			}
			else if(MeshNeedsApply)
			{
				chunckMesh.Upload(mesh);
				MeshDrawable = true;
				MeshNeedsApply = false;
			}
		}
	}
}
