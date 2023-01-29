using System;
using System.Collections;
using Voxis.Framework;

namespace Voxis
{
	public class Font
	{
		public float LineHeight { get; }
		public float Scale { get; }
		public float Ascent { get; }
		public float Descent { get; }
		public float LineGap { get; }

		private STBTrueType.FontInfo fontInfo = .();

		private Dictionary<char32, FontGlyph> glyphs = new Dictionary<char32, FontGlyph>();

		private uint8[] fontData;

		public this(System.IO.FileStream fileStream, float lineHeight)
		{
			LineHeight = lineHeight;

			fontData = new uint8[1 << 20];

			fileStream.TryRead(fontData);

			fontInfo = .();

			if(!STBTrueType.InitFont(ref fontInfo, fontData, 0))
			{
				System.Runtime.FatalError("Error initializing STBTrueType font!");
			}

			Scale = STBTrueType.ScaleForPixelHeight(ref fontInfo, lineHeight);

			int32 lAscent = 0;
			int32 lDescent = 0;
			int32 lLineGap = 0;

			STBTrueType.GetFontVMetrics(ref fontInfo, ref lAscent, ref lDescent, ref lLineGap);

			Ascent = lAscent * Scale;
			Descent = lDescent * Scale;
			LineGap = lLineGap * Scale;

			Console.WriteLine("Ascent: {0} Descent: {1} LineGap: {2} Scale: {3}", Ascent, Descent, LineGap, Scale);
		}

		public ~this()
		{
			for(FontGlyph tex in glyphs.Values)
			{
				GraphicsServer.DestroyResource(tex.Texture);
			}
			delete fontData;
			delete glyphs;
		}

		public float ScaleForPixelHeight(float height)
		{
			return STBTrueType.ScaleForPixelHeight(ref fontInfo, height);
		}

		public FontGlyph GetGlyph(char32 codepoint)
		{
			if (glyphs.ContainsKey(codepoint))
			{
				return glyphs[codepoint];
			}

			int32 width = 0;
			int32 height = 0;
			int32 xoff = 0;
			int32 yoff = 0;
			uint8* pixels = STBTrueType.GetCodepointBitmap(ref fontInfo, Scale, Scale, codepoint, ref width, ref height, ref xoff, ref yoff);

			Color[] colors = new Color[width * height];
			Span<uint8> data = Span<uint8>(pixels, width * height);
			for(int i = 0; i < colors.Count; i++)
			{
				uint8 val = data[i];
				uint8 rgb = uint8.MaxValue;

				colors[i] = Color.FromBytes(rgb, rgb, rgb, val);
			}

			Texture2D tex = GraphicsServer.CreateTexture2D(width, height, .Point, .RGBA, .RGBA, .Float, colors.CArray());
			delete colors;

			FontGlyph glyph = FontGlyph();
			glyph.Texture = tex;
			STBTrueType.GetCodepointBitmapBox(ref fontInfo, codepoint, Scale, Scale, ref glyph.MinX, ref glyph.MinY, ref glyph.MaxX, ref glyph.MaxY);

			int32 advance = 0;
			int32 lsb = 0;
			STBTrueType.GetCodepointHMetrics(ref fontInfo, codepoint, ref advance, ref lsb);
			glyph.Advance = advance * Scale;
			glyph.LSB = lsb * Scale;
			glyphs.Add(codepoint, glyph);

			return glyph;
		}

		public void RenderTextEx(Vector2 bboxStart, StringView text, int carretLocation, int depth, float fontHeight = -1.0f)
		{
			float heightScaling = 1.0f;
			if (fontHeight > 0.0f)
			{
				heightScaling = fontHeight / LineHeight;
			}

			float currentX = bboxStart.X;

			for(int i = 0; i < text.Length; i++)
			{
				char32 c = text[i];
				FontGlyph glyph = GetGlyph(c);

				float y = Ascent + glyph.MinY + bboxStart.Y;
				y *= heightScaling;

				float bear = glyph.LSB;
				bear *= heightScaling;

				CanvasRenderPipeline.DrawTexturedRect(Rect(currentX + bear, y, glyph.Texture.Width, glyph.Texture.Height), glyph.Texture, Rect(0, 0, glyph.Texture.Width, glyph.Texture.Height), .White, depth);

				if (carretLocation == i)
				{
					DrawCharacter(Vector2(currentX, bboxStart.Y), '|', depth, fontHeight);
				}

				currentX += glyph.Advance * heightScaling;
			}

			// Carret is at end of text!
			if (carretLocation == text.Length)
			{
				DrawCharacter(Vector2(currentX, bboxStart.Y), '|', depth, fontHeight);
			}
		}

		public void DrawCharacter(Vector2 position, char32 codepoint, int depth, float fontHeight = -1.0f)
		{
			float heightScaling = 1.0f;
			if (fontHeight > 0.0f)
			{
				heightScaling = fontHeight / LineHeight;
			}

			FontGlyph glyph = GetGlyph(codepoint);

			float y = Ascent + glyph.MinY + position.Y;
			y *= heightScaling;

			float bear = glyph.LSB;
			bear *= heightScaling;

			CanvasRenderPipeline.DrawTexturedRect(Rect(position.X + bear, y, glyph.Texture.Width, glyph.Texture.Height), glyph.Texture, Rect(0, 0, glyph.Texture.Width, glyph.Texture.Height), .White, depth);
		}

		public void RenderText(Vector2 bboxStart, StringView text, int depth = -1, float fontHeight = -1.0f)
		{
			float heightScaling = 1.0f;
			if (fontHeight > 0.0f)
			{
				heightScaling = fontHeight / LineHeight;
			}

			float currentX = bboxStart.X;
			float currentY = bboxStart.Y;

			for(int i = 0; i < text.Length; i++)
			{
				char32 c = text[i];
				FontGlyph glyph = GetGlyph(c);

				float y = Ascent + glyph.MinY + currentY;
				y *= heightScaling;

				float bear = glyph.LSB;
				bear *= heightScaling;

				if (c == '\n')
				{
					currentY += LineHeight;
					currentX = bboxStart.X;
				}

				else
				{
					CanvasRenderPipeline.DrawTexturedRect(Rect(currentX + bear, y, glyph.Texture.Width, glyph.Texture.Height), glyph.Texture, Rect(0, 0, glyph.Texture.Width, glyph.Texture.Height), .White, depth);

					currentX += glyph.Advance * heightScaling;
				}
			}
		}

		public float MeasureText(StringView text, float fontHeight = -1.0f)
		{
			float heightScaling = 1.0f;
			if (fontHeight > 0.0f)
			{
				heightScaling = fontHeight / LineHeight;
			}

			float currentX = 0;

			for(int i = 0; i < text.Length; i++)
			{
				char32 c = text[i];
				FontGlyph glyph = GetGlyph(c);

				float y = Ascent + glyph.MinY;
				y *= heightScaling;

				float bear = glyph.LSB;
				bear *= heightScaling;

				currentX += glyph.Advance * heightScaling;
			}

			return currentX;
		}

		public Vector2 AlignTextStart(StringView text, Rect rectangle, VAlign valign, HAlign halign, float fontHeight = -1.0f)
		{
			float textWidth = MeasureText(text, fontHeight);

			// TODO: THIS IS AN ERROR!!! SCALING NOT APPLIED!
			float textHeight = LineHeight;

			// This text start is at the Top Left Alignment!
			Vector2 textStart = rectangle.Position;
			switch(valign){
			case .Center:
					textStart.Y += rectangle.Height * 0.5f - textHeight * 0.5f;
				break;
			case .Top:
					break;
			case .Bottom:
					textStart.Y += rectangle.Height - textHeight;
				}
				switch(halign){
			case .Left:
					break;
			case .Center:
					textStart.X += rectangle.Width * 0.5f - textWidth * 0.5f;
					break;
			case .Right:
					textStart.X += rectangle.Width - textWidth;
				break;
			}

			return textStart;
		}
	}
}
