namespace Voxis
{
	public class Player : Entity
	{
		public Camera Camera { get; private set; }
		public BoundingBox WorldBounds { get { return localBounds.WithOffset(LocalPosition); } }
		public Vector3 CurrentVelocity { get; private set; }
		public bool IsGrounded { get; private set; }
		public float Yaw { get; set; }
		public float Pitch { get; set; }
		public bool IsFlying { get; private set; }
		public int SelectedBlockIndex { get; private set; }

		public Vector3 Forward { get { return Vector3.Transform(Vector3.UnitZ, Quaternion.CreateFromYawPitchRoll(ExtMath.Deg2Rad(Yaw), 0, 0)); } }
		public Vector3 Right { get { return Vector3.Transform(Vector3.UnitX, Quaternion.CreateFromYawPitchRoll(ExtMath.Deg2Rad(Yaw), 0, 0)); } }

		private float characterHeight = 1.8f;
		private float characterWidth = 0.25f;
		private float jumpSpeed = 7f;
		private float graivty = -20.0f;
		private float lastSpace = 0.0f;
		private float flyingSpeed = 10.0f;

		private Vector3 cameraOffset = Vector3(0, 1.5f, 0);
		private BoundingBox localBounds = BoundingBox(Vector3(-characterWidth, -characterHeight * 0.5f, -characterWidth), Vector3(characterWidth, characterHeight * 0.5f, characterWidth));

		private PlayerHUD hud;

		public this()
		{
			Camera = new Camera();
		}

		public ~this()
		{
			delete Camera;
		}

		public override void OnInputEvent(InputEvent event)
		{
			base.OnInputEvent(event);

			if (event is InputEventMouseMovement)
			{
				InputEventMouseMovement moveEvent = (InputEventMouseMovement)event;

				Pitch -= moveEvent.DeltaY;
				Yaw += moveEvent.DeltaX;

				Pitch = System.Math.Clamp(Pitch, -89.0f, 89.0f);

				Camera.Rotation = Quaternion.CreateFromYawPitchRoll(ExtMath.Deg2Rad(Yaw), ExtMath.Deg2Rad(Pitch), 0);

				event.Consume();
			}

			if (event is InputEventMouseScroll)
			{
				InputEventMouseScroll scrollEvent = (InputEventMouseScroll)event;
				SelectedBlockIndex += (int)(scrollEvent.Y);

				if (SelectedBlockIndex < 0) SelectedBlockIndex = 0;
				else if (SelectedBlockIndex >= GameRegistry.Block.Count) SelectedBlockIndex = GameRegistry.Block.Count - 1;
			}

			if (event is InputEventKeyboardKey)
			{
				InputEventKeyboardKey keyEvent = (InputEventKeyboardKey)event;

				//if (keyEvent.Key == .Space && IsGrounded)
					//CurrentVelocity = Vector3(CurrentVelocity.X, jumpSpeed, CurrentVelocity.Z);

				if (keyEvent.Key == .Space && keyEvent.Action == .Press)
				{
					if (Time.ElapsedRealtime - lastSpace < 0.5f)
					{
						IsFlying = !IsFlying;
					}
					else
					{
						lastSpace = (float)Time.ElapsedRealtime;
					}
				}
			}

			if (event is InputEventMouseButton)
			{
				InputEventMouseButton mbEvent = event as InputEventMouseButton;

				Vector3 hitPos = .Zero;
				Vector3 hitNormal = .Zero;

				if (Physics.TraceRay(World, LocalPosition + cameraOffset, Camera.Forward, 10.0f, ref hitPos, ref hitNormal))
				{
					if (mbEvent.Button == MouseButton.Left)
					{
						Vector3 centerPos = hitPos - hitNormal * 0.5f;
						BlockPos selectedPos = BlockPos.FromVector(centerPos);
	
						World.SetBlockState(selectedPos, AirBlock.DEFAULT_AIR_STATE);
					}
					else if(mbEvent.Button == MouseButton.Right)
					{
						Vector3 centerPos = hitPos + hitNormal * 0.5f;
						BlockPos selectedPos = BlockPos.FromVector(centerPos);

						World.SetBlockState(selectedPos, GameRegistry.Block.Get("dirt").DefaultState);
					}
				}
			}	
		}

		public override void OnRender(Camera camera)
		{
			base.OnRender(camera);

			Vector3 hitPos = .Zero;
			Vector3 hitNormal = .Zero;
			if (Physics.TraceRay(World, LocalPosition + cameraOffset, Camera.Forward, 10.0f, ref hitPos, ref hitNormal))
			{
				Vector3 centerPos = hitPos - hitNormal * 0.5f;

				BlockPos selectedPos = BlockPos(
					int(System.Math.Floor(centerPos.X)),
					int(System.Math.Floor(centerPos.Y)),
					int(System.Math.Floor(centerPos.Z))
					);

				Camera.DrawCube(selectedPos.ToVector() + Vector3.One * 0.5f, Vector3.One * 0.55f, .Purple);
			}

			/*Matrix4x4 cameraMatrix = Camera.TransformMatrix;
			Matrix4x4 testMat = Matrix4x4.CreateTranslation(0, 0, 3);
			Matrix4x4 final = testMat * cameraMatrix;

			Camera.DrawCube(final, .Red);*/
		}

		public override void OnTick()
		{
			base.OnTick();
		}

		public override void OnFixedUpdate()
		{
			base.OnFixedUpdate();

			UpdateCameraValues();

			if (!World.IsChunckGameplayReady(ChunckIndex.FromPosition(LocalPosition)))
			{
				// Freeze until ready
				//return;
			}

			float deltaTime = float(World.FixedUpdateDeltaTime);

			// Only Apply gravity if not flying
			if (!IsFlying)
			{
				CurrentVelocity += Vector3.UnitY * graivty * deltaTime;
			}

			Vector3 walkDelta = Vector3.Zero;
			if (InputServer.IsKeyPressed(.KeyW))
			{
				walkDelta += Forward;
			}
			if (InputServer.IsKeyPressed(.KeyS))
			{
				walkDelta -= Forward;
			}
			if (InputServer.IsKeyPressed(.KeyA))
			{
				walkDelta += Right;
			}
			if (InputServer.IsKeyPressed(.KeyD))
			{
				walkDelta -= Right;
			}

			if (IsFlying) walkDelta = walkDelta.Normalize() * flyingSpeed * deltaTime;
			else walkDelta = walkDelta.Normalize() * 3.0f * deltaTime;
			walkDelta += CurrentVelocity * deltaTime;

			IsGrounded = false;

			if (Physics.IsInsideTerrain(WorldBounds, World))
			{
				// TODO: IDK?
			}

			Vector3 normal = Vector3.Zero;

			LocalPosition = Physics.SweepTerrain(WorldBounds, World, Vector3(walkDelta.X, 0, 0), ref normal);

			LocalPosition = Physics.SweepTerrain(WorldBounds, World, Vector3(0, 0, walkDelta.Z), ref normal);

			LocalPosition = Physics.SweepTerrain(WorldBounds, World, Vector3(0, walkDelta.Y, 0), ref normal);

			if (normal.Y > 0.0f)
			{
				CurrentVelocity = Vector3.Zero;
				IsGrounded = true;
			}

			if (InputServer.IsKeyPressed(.Space))
			{
				if (IsGrounded) CurrentVelocity = Vector3(CurrentVelocity.X, jumpSpeed, CurrentVelocity.Z);
				if (IsFlying) CurrentVelocity = Vector3(CurrentVelocity.X, flyingSpeed, CurrentVelocity.Z);
			}
			else if (InputServer.IsKeyPressed(.LeftShift))
			{
				if (IsFlying) CurrentVelocity = Vector3(CurrentVelocity.X, -flyingSpeed, CurrentVelocity.Z);
			}
			else
			{
				if (IsFlying) CurrentVelocity = Vector3(CurrentVelocity.X, 0.0f, CurrentVelocity.Z);
			}

			// Apply damping when flying
			if (IsFlying)
			{
				CurrentVelocity = CurrentVelocity *= 0.95f;
			}
		}

		protected override void OnStart()
		{
			base.OnStart();

			LocalPosition = Vector3(0, 100, 0);

			hud = new PlayerHUD();
			GUICanvas.AddScreen(hud);
			hud.Player = this;
		}

		public override void OnCollectCameras(System.Collections.List<Camera> cameraList)
		{
			base.OnCollectCameras(cameraList);

			cameraList.Add(Camera);
		}

		private void UpdateCameraValues()
		{
			Camera.Position = LocalPosition + cameraOffset;
			Camera.Update();
		}
	}
}
