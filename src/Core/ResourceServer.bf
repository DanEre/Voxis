using Voxis.Framework;
using System;
using System.Collections;
using System.IO;
using System.Diagnostics;

namespace Voxis
{
	public class Resource<T>
	{
		public T InternalResource { get; }
		public int RefCount { get; private set; }

		internal this(T res)
		{
			InternalResource = res;
		}

		private void Decrement()
		{
			RefCount--;
		}
		private void Increment()
		{
			RefCount++;
		}

		public ResourceHandle<T> CreateHandle()
		{
			Increment();
			return new[Friend] ResourceHandle<T>(this);
		}
	}

	public class ResourceHandle<T>
	{
		public T Resource
		{
			get
			{
				return reference.InternalResource;
			}
		}

		private Resource<T> reference;

		private this(Resource<T> res)
		{
			reference = res;
		}

		public ~this()
		{
			reference.[Friend]Decrement();
		}
	}

	public static class ResourceServer
	{
		private static List<String> mountedDirectories = new List<String>() ~ DeleteContainerAndItems!(_);
		private static Dictionary<String, Object> resourceCache = new Dictionary<String, Object>() ~ DeleteDictionaryAndKeysAndValues!(_);

		public static Image LoadImageOrDefault(StringView filePath, Image defaultValue)
		{
			String foundPath = scope String();

			if(SearchFile(filePath, foundPath))
			{
				int32 imageWidth = 0;
				int32 imageHeight = 0;
				int32 imageChannels = 0;
				uint8* imageData = STBImage.Load(foundPath, ref imageWidth, ref imageHeight, ref imageChannels, 4);

				if(imageData == null)
				{
					Console.Error.WriteLine("Image could not be read!");
				}

				// Convert from raw pixels array to Image class instance
				Image image = new Image(imageWidth, imageHeight);
				image.FromRawData(imageData);

				resourceCache.Add(new String(filePath), image);

				return image;
			}
			else
			{
				Console.WriteLine("Resource at path {0} not found. Using default Value!", filePath);

				return defaultValue;
			}
		}

		public static Texture2D LoadTexture2D(StringView filePath)
		{
			String foundPath = scope String();

			if(SearchFile(filePath, foundPath))
			{
				int32 imageWidth = 0;
				int32 imageHeight = 0;
				int32 imageChannels = 0;
				uint8* imageData = STBImage.Load(foundPath, ref imageWidth, ref imageHeight, ref imageChannels, 4);

				if(imageData == null)
				{
					Runtime.FatalError("Error loading image!");
				}

				Texture2D texture = GraphicsServer.CreateTexture2D(imageWidth, imageHeight, .Point, .RGBA, .RGBA, .UnsignedByte, imageData);

				GraphicsServer.QueueResourceDestroy(texture);

				return texture;
			}
			else
			{
				Runtime.FatalError("File could not be found!");
			}
		}

		public static SkeletalModel LoadSkeletalModel(StringView filePath)
		{
			String foundPath = scope String();

			if (SearchFile(filePath, foundPath))
			{
				String textContent = new String();
				defer delete textContent;
				File.ReadAllText(foundPath, textContent);

				SkeletalModel resultModel = SkeletalModelLoader.Parse(textContent);

				resourceCache.Add(new String(filePath), resultModel);

				return resultModel;
			}
			else
			{
				Runtime.FatalError("SkeletalModel could not be found!");
			}
		}

		public static String LoadTextFile(StringView filePath)
		{
			String foundPath = scope String();
			String cacheCheck = scope String(filePath);

			if (resourceCache.ContainsKey(cacheCheck))
			{
				return resourceCache[cacheCheck] as String;
			}

			if(SearchFile(filePath, foundPath))
			{
				String resultText = new String();
				File.ReadAllText(foundPath, resultText);

				resourceCache.Add(new String(filePath), resultText);

				return resultText;
			}
			else
			{
				Runtime.FatalError("File could not be found!");
			}
		}

		public static Font LoadFont(String filePath)
		{
			String foundPath = scope String();

			if(SearchFile(filePath, foundPath))
			{
				FileStream stream = new FileStream();
				stream.Open(foundPath, .Read);

				Font font = new Font(stream, 32.0f);

				stream.Close();
				delete stream;
				resourceCache.Add(new String(filePath), font);

				return font;
			}
			else
			{
				Runtime.FatalError("File could not be found!");
			}
		}

		public static SoundEffect LoadSoundEffect(String filePath)
		{
			String foundPath = scope String();

			if(SearchFile(filePath, foundPath))
			{
				SoundEffect effect = AudioServer.LoadSoundEffect(foundPath);

				resourceCache.Add(new String(filePath), effect);

				return effect;
			}
			else
			{
				Runtime.FatalError("File could not be found!");
			}
		}

		public static void MountDirectory(StringView path)
		{
			Debug.Assert(Path.IsDirectorySeparatorChar(path[path.Length - 1]));

			mountedDirectories.Add(new String(path));
		}

		public static bool SearchFile(StringView filePath, String buffer)
		{
			for(String mount in mountedDirectories)
			{
				String finalPath = scope String(mount);
				finalPath.Append(filePath);

				if (File.Exists(finalPath))
				{
					buffer.Append(finalPath);
					return true;
				}
			}
			return false;
		}
	}
}
