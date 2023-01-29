using System;

namespace Voxis.Framework
{
	public static class STBImage
	{
		[Import("STBLib.dll"), CLink]
		private extern static uint8* stbi_load(char8* filePath, int32* width, int32* height, int32* channels, int32 desiredChannels);
		public static uint8* Load(StringView filepath, ref int32 width, ref int32 height, ref int32 channels, int32 desired)
		{
			return stbi_load(filepath.ToScopeCStr!(), &width, &height, &channels, desired);
		}

		[Import("STBLib.dll"), CLink]
		private extern static char8* stbi_failure_reason();
		public static StringView GetFailureReason()
		{
			return StringView(stbi_failure_reason());
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbi_image_free(uint8* data);
		public static void ImageFree(uint8* data)
		{
			stbi_image_free(data);
		}
	}
}
