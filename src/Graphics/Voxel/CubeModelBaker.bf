using System;

namespace Voxis
{
	public class CubeModelBaker : BlockModelBaker
	{
		private String texBottom, texTop, texLeft, texRight, texFront, texBack;

		public this(StringView textureAll)
		{
			texBottom = new String(textureAll);
			texTop = new String(textureAll);
			texLeft = new String(textureAll);
			texRight = new String(textureAll);
			texFront = new String(textureAll);
			texBack = new String(textureAll);
		}

		public this(StringView top, StringView bottom, StringView right, StringView left, StringView front, StringView back)
		{
			texBottom = new String(bottom);
			texRight = new String(right);
			texLeft = new String(left);
			texBack = new String(back);
			texFront = new String(front);
			texTop = new String(top);
		}

		public ~this()
		{
			delete texBottom;
			delete texTop;
			delete texLeft;
			delete texRight;
			delete texFront;
			delete texBack;
		}

		public override void BakeModel(BlockState forState)
		{
			// Top
			BakedQuad top = new BakedQuad();
			top.Vertices = new Vector3[](
				Vector3(0, 1, 0),
				Vector3(0, 1, 1),
				Vector3(1, 1, 1),
				Vector3(1, 1, 0)
				);
			top.Normal = Vector3.UnitY;
			top.OclDir = .Up;
			top.Texcoords = CreateQuadCoords();
			top.TexIndices = VoxelTextureManager.LoadTexture(texTop);

			// Bottom
			BakedQuad bottom = new BakedQuad();
			bottom.Vertices = new Vector3[](
				Vector3(0, 0, 1),
				Vector3(0, 0, 0),
				Vector3(1, 0, 0),
				Vector3(1, 0, 1)
				);
			bottom.Normal = Vector3.UnitY * -1.0f;
			bottom.OclDir = .Down;
			bottom.TexIndices = VoxelTextureManager.LoadTexture(texBottom);
			bottom.Texcoords = CreateQuadCoords();

			// Back
			BakedQuad back = new BakedQuad();
			back.Vertices = new Vector3[](
				Vector3(0, 0, 0),
				Vector3(0, 1, 0),
				Vector3(1, 1, 0),
				Vector3(1, 0, 0)
				);
			back.Normal = Vector3.UnitZ * -1.0f;
			back.TexIndices =  VoxelTextureManager.LoadTexture(texBack);
			back.Texcoords = CreateQuadCoords();
			back.OclDir = .Back;

			// Front
			BakedQuad front = new BakedQuad();
			front.Vertices = new Vector3[](
				Vector3(1, 0, 1),
				Vector3(1, 1, 1),
				Vector3(0, 1, 1),
				Vector3(0, 0, 1)
			);
			front.TexIndices =  VoxelTextureManager.LoadTexture(texFront);
			front.Texcoords = CreateQuadCoords();
			front.OclDir = .Front;
			front.Normal = Vector3.UnitZ;

			// Right
			BakedQuad right = new BakedQuad();
			right.Vertices = new Vector3[](
				Vector3(1, 0, 0),
				Vector3(1, 1, 0),
				Vector3(1, 1, 1),
				Vector3(1, 0, 1)
				);
			right.OclDir = .Right;
			right.Texcoords = CreateQuadCoords();
			right.TexIndices =  VoxelTextureManager.LoadTexture(texRight);
			right.Normal = .UnitX;

			// Left
			BakedQuad left = new BakedQuad();
			left.Vertices = new Vector3[](
				Vector3(0, 0, 1),
				Vector3(0, 1, 1),
				Vector3(0, 1, 0),
				Vector3(0, 0, 0)
				);
			left.OclDir = .Left;
			left.Normal = .UnitX * -1.0f;
			left.TexIndices =  VoxelTextureManager.LoadTexture(texLeft);
			left.Texcoords = CreateQuadCoords();

			BakedQuad[] quads = new BakedQuad[](top, bottom, front, back, right, left);

			BlockModel model = new BlockModel(quads);

			forState.Model = model;
		}

		private Vector2[] CreateQuadCoords()
		{
			return new Vector2[](
				Vector2(0, 0),
				Vector2(0, 1),
				Vector2(1, 1),
				Vector2(1, 0)
				);
		}
	}
}
