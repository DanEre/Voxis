using System;
using System.Collections;

namespace Voxis
{
	public static class VoxelTextureManager
	{
		public const int TEX_WIDTH = 16;
		public const int TEX_HEIGHT = 16;

		public static TextureArray2D VoxelTextures { get; private set; }

		private static Dictionary<String, Vector2> cachedImages = new Dictionary<String, Vector2>() ~ DeleteDictionaryAndKeys!(_);

		private static List<Image> loadedTextures = new List<Image>();
		private static int currentTextureIndex = 0;

		private static Image missingImage;

		static this()
		{
			missingImage = new Image(2, 2);
			missingImage.SetPixel(0, 0, .Black);
			missingImage.SetPixel(1, 0, .Purple);
			missingImage.SetPixel(0, 1, .Purple);
			missingImage.SetPixel(1, 1, .Black);
		}

		static ~this()
		{
			delete missingImage;
			delete VoxelTextures;
		}

		public static Vector2 LoadTexture(StringView textureName)
		{
			String tempName = new String(textureName);

			if (cachedImages.ContainsKey(tempName))
			{
				defer delete tempName;
				return cachedImages[tempName];
			}
			else
			{
				String finalPath = scope String()..AppendF("textures/block/{0}.png", textureName);
				Image texImage = ResourceServer.LoadImageOrDefault(finalPath, missingImage);
				loadedTextures.Add(texImage);
				Vector2 finalIndex = Vector2(currentTextureIndex, currentTextureIndex);
				cachedImages.Add(tempName, finalIndex);
				currentTextureIndex += 1;
				return finalIndex;
			}
		}

		public static void BakeTextures()
		{
			// Update texture layers and finalize
			VoxelTextures = GraphicsServer.CreateTextureArray2D(16, 16, loadedTextures.Count);

			for(int i = 0; i < loadedTextures.Count; i++)
			{
				Image currentImage = loadedTextures[i];
				currentImage.Resize(TEX_WIDTH, TEX_HEIGHT);
				currentImage.FlipY();
				GraphicsServer.UpdateTextureArray2D(VoxelTextures, i, .RGBA, .Float, currentImage.GetPixels().CArray());
			}

			RenderPipeline3D.ChunckRenderMaterial.SetMaterialProperty("MAIN_TEX", new MaterialParameterTextureArray2D(VoxelTextures));

			delete loadedTextures;
		}
	}
}
