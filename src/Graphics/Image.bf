using System.Diagnostics;

namespace Voxis
{
	public class Image
	{
		public enum SampleQuality
		{
			Bilinear = 0,
			Point = 1
		}

		public int Width { get; private set; }
		public int Height { get; private set; }

		private Color[] pixels;

		public this(int width, int height)
		{
			Debug.Assert(width > 0 && height > 0);

			Width = width;
			Height = height;

			pixels = new Color[width * height];
		}

		public ~this()
		{
			delete pixels;
		}

		public void SetPixel(int x, int y, Color pixel)
		{
			Debug.Assert(x >= 0 && x < Width && y >= 0 && y < Height);

			pixels[x + y * Width] = pixel;
		}
		public Color GetPixel(int x, int y)
		{
			Debug.Assert(x >= 0 && x < Width && y >= 0 && y < Height);

			return pixels[x + y * Width];
		}
		public Color SamplePixel(float x, float y, SampleQuality quality)
		{
			Debug.Assert(x >= 0f && x <= 1.0f && y >= 0f && y <= 1f);

			switch(quality)
			{
			case .Bilinear:
				System.Runtime.NotImplemented();
			case .Point:
				return GetPixel(int(x * Width), int(y * Height));
			}
		}
		public Color[] GetPixels()
		{
			return pixels;
		}

		public void Resize(int width, int height)
		{
			Debug.Assert(width > 0 && height > 0);

			Color[] newPixels = new Color[width * height];

			for(int x = 0; x < width; x++)
			{
				for(int y = 0; y < height; y++)
				{
					newPixels[x + y * width] = SamplePixel(x / float(width), y / float(width), .Point);
				}
			}

			delete pixels;
			pixels = newPixels;
			Width = width;
			Height = height;
		}

		public void Fill(Color fillColor)
		{
			for(int i = 0; i < pixels.Count; i++)
			{
				pixels[i] = fillColor;
			}
		}

		public void FlipY()
		{
			Color[] newPixels = new Color[Width * Height];

			for(int row = 0; row < Height; row++)
			{
				pixels.CopyTo(newPixels, row * Width, (Height - 1 - row) * Width, Width);
			}

			delete pixels;
			pixels = newPixels;
		}

		// Create pixels from raw byte data stored as 4 byte RGBA components
		public void FromRawData(uint8* rawData)
		{
			for(int x = 0; x < Width; x++)
			{
				for(int y = 0; y < Height; y++)
				{
					int index = x + y * Width;
					int offset = index * 4;
					uint8 r = rawData[offset];
					uint8 g = rawData[offset + 1];
					uint8 b = rawData[offset + 2];
					uint8 a = rawData[offset + 3];

					pixels[index] = Color.FromBytes(r, g, b, a);
				}
			}
		}
	}
}
