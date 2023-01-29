using System;
using System.Interop;

namespace Voxis.Framework
{
	public static class STBTrueType
	{
		private const String STBLib = "STBLib.dll";

		[CRepr]
		public struct BakedChar
		{
			public c_ushort X0, Y0, X1, Y1;
			public float XOff, YOff, XAdvance;
		}

		[CRepr]
		public struct AlignedQuad
		{
			public float X0, Y0, S0, T0;
			public float X1, Y1, S1, T1;
		}

		[CRepr]
		public struct PackedChar
		{
			public c_ushort X0, Y0, X1, Y1;
			public float XOff, YOff, XAdvance;
			public float XOff2, YOff2;
		}

		[CRepr]
		public struct PackContext
		{
			public void* UserAllocatorContext;
			public void* PackInfo;
			public c_int Width;
			public c_int Height;
			public c_int StrideInBytes;
			public c_int Padding;
			public c_int SkipMissing;
			public c_uint HOversample, VOversample;
			public c_char* Pixels;
			public void* Nodes;
		}

		[CRepr]
		public struct PackRange
		{
			public float FontSize;
			public c_int FirstUnicodeCodepoint;
			public c_int* CodepointArray;
			public c_int NumChars;
			public PackedChar* CharData;
			c_char HOversample, VOversample;
		}

		[CRepr]
		public struct FontInfo
		{
			private void* Userdata;
			private c_uchar* Data;
			private c_int FontStart;
			private c_int NumGlyphs;
			private c_int Loca, Head, Glyf, Hhea, Hmtx, Kern, Gpos, Svg;
			private c_int IndexMap;
			private c_int IndexToLocFormat;

			private STBBuffer cff;
			private STBBuffer charstrings;
			private STBBuffer gsubrs;
			private STBBuffer subrs;
			private STBBuffer fontdicts;
			private STBBuffer fdselect;
		}

		[CRepr]
		private struct STBBuffer
		{
			private c_uchar* data;
			private c_int cursor;
			private c_int size;
		}

		[Import("STBLib.dll"), CLink]
		private extern static c_int stbtt_BakeFontBitmap(c_char* data, c_int offset, float pixelHeight, c_char* pixels, c_int bitmapWidth, c_int bitmapHeight, c_int firstChar, c_int numCharacters, BakedChar* buffer);
		public static c_int BakeFontBitmap(c_char[] data, c_int offset, float pixelHeight, c_char[] pixels, c_int bitmapWidth, c_int bitmapHeight, c_int firstChar, c_int numChars, BakedChar[] buffer)
		{
			System.Diagnostics.Debug.Assert(buffer.Count == numChars);
			return stbtt_BakeFontBitmap(data.CArray(), offset, pixelHeight, pixels.CArray(), bitmapWidth, bitmapHeight, firstChar, numChars, buffer.CArray());
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbtt_GetBakedQuad(BakedChar* chardata, c_int bitmapWidth, c_int bitmapHeight, c_int charIndex, float* xpos, float* ypos, AlignedQuad* quadOut, c_int openglFillRule);
		public static void GetBakedQuad(BakedChar[] chardata, c_int bitmapWidth, c_int bitmapHeight, c_int charIndex, ref float xpos, ref float ypos, ref AlignedQuad quadOut, bool openglFillRule)
		{
			stbtt_GetBakedQuad(chardata.CArray(), bitmapWidth, bitmapHeight, charIndex, &xpos, &ypos, &quadOut, openglFillRule ? 1 : 0);
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbtt_GetCodepointHMetrics(FontInfo* fontInfo, char32 Codepoint, c_int* advanceWidth, c_int* leftSideBearing);
		public static void GetCodepointHMetrics(ref FontInfo fontInfo, char32 Codepoint, ref c_int advanceWidth, ref c_int leftSideBearing)
		{
			stbtt_GetCodepointHMetrics(&fontInfo, Codepoint, &advanceWidth, &leftSideBearing);
		}

		[Import(STBLib), CLink]
		private extern static c_int stbtt_GetCodepointKernAdvance(FontInfo* fontInfo, c_int ch1, c_int ch2);
		public static c_int GetCodepointKernAdvance(FontInfo* fontInfo, char32 from, char32 to)
		{
			return stbtt_GetCodepointKernAdvance(fontInfo, (c_int)from, (c_int)to);
		}

		[Import("STBLib.dll"), CLink]
		private extern static float stbtt_ScaleForPixelHeight(FontInfo* fontInfo, float pixels);
		public static float ScaleForPixelHeight(ref FontInfo fontInfo, float height)
		{
			return stbtt_ScaleForPixelHeight(&fontInfo, height);
		}

		[Import("STBLib.dll"), CLink]
		private extern static c_int stbtt_InitFont(FontInfo* fontInfo, c_uchar* data, c_int offset);
		public static bool InitFont(ref FontInfo fontInfo, c_uchar[] data, c_int offset)
		{
			return stbtt_InitFont(&fontInfo, data.CArray(), offset) != 0;
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbtt_GetFontBoundingBox(FontInfo* fontInfo, c_int* x0, c_int* y0, c_int* x1, c_int* y1);
		public static void GetFontBoundingBox(ref FontInfo fontInfo, ref c_int x0, ref c_int y0, ref c_int x1, ref c_int y1)
		{
			stbtt_GetFontBoundingBox(&fontInfo, &x0, &y0, &x1, &y1);
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbtt_GetScaledFontVMetrics(c_char* fontdata, c_int index, float size, float * ascent, float* descent, float* linegap);
		public static void GetScaledFontVMetrics(c_char[] fontdata, c_int index, float size, ref float ascent, ref float descent, ref float linegap)
		{
			stbtt_GetScaledFontVMetrics(fontdata.CArray(), index, size, &ascent, &descent, &linegap);
		}

		[Import("STBLib.dll"), CLink]
		private extern static c_int stbtt_PackBegin(PackContext* packContext, c_char* pixels, c_int width, c_int height, c_int strideInBytes, c_int padding, void* allocationContext);
		public static bool PackBegin(ref PackContext packContext, c_char[] pixels, c_int width, c_int height, c_int strideInBytes, c_int padding, void* allocationContext)
		{
			return stbtt_PackBegin(&packContext, pixels.CArray(), width, height, strideInBytes, padding, allocationContext) == 1;
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbtt_PackEnd(PackContext* packContext);
		public static void PackEnd(ref PackContext packContext)
		{
			stbtt_PackEnd(&packContext);
		}

		[Import("STBLib.dll"), CLink]
		private extern static c_int stbtt_PackFontRange(PackContext* packContext, c_char* fontData, c_int fontIndex, float fontSize, c_int firstChar, c_int numChars, PackedChar* charData);
		public static c_int PackFontRange(ref PackContext packContext, c_char[] fontData, c_int fontIndex, float fontSize, c_int firstChar, c_int numChar, PackedChar[] charData)
		{
			return stbtt_PackFontRange(&packContext, fontData.CArray(), fontIndex, fontSize, firstChar, numChar, charData.CArray());
		}

		[Import("STBLib.dll"), CLink]
		private extern static c_int stbtt_PackFontRanges(PackContext* packContext, c_char* fontData, c_int fontIndex, PackRange* packRanges, c_int numRanges);
		public static c_int PackFontRanges(ref PackContext packContext, c_char[] fontData, c_int fontIndex, PackRange[] packRanges)
		{
			return stbtt_PackFontRanges(&packContext, fontData.CArray(), fontIndex, packRanges.CArray(), (int32)packRanges.Count);
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbtt_PackSetOversampling(PackContext* packContext, c_uint hOversample, c_uint vOversample);
		public static void PackSetOversampling(ref PackContext packContext, c_uint hOversample, c_uint vOversample)
		{
			stbtt_PackSetOversampling(&packContext, hOversample, vOversample);
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbtt_PackSetSkipMissingCodepoints(PackContext* packContext, c_int skip);
		public static void PackSetSkipMissingCodepoints(ref PackContext packContext, bool skip)
		{
			stbtt_PackSetSkipMissingCodepoints(&packContext, skip ? 1 : 0);
		}

		[Import("STBLib.dll"), CLink]
		private extern static void stbtt_GetPackedQuad(PackedChar* chardata, c_int pw, c_int ph, c_int charIndex, float* xpos, float* ypos, AlignedQuad* quad, c_int alignToc_integer);
		public static void GetPackedQuad(ref PackedChar charData, c_int pw, c_int ph, c_int charIndex, ref float xpos, ref float ypos, ref AlignedQuad quad, bool alignToc_integer)
		{
			stbtt_GetPackedQuad(&charData, pw, ph, charIndex, &xpos, &ypos, &quad, alignToc_integer ? 1 : 0);
		}

		[Import("STBLib.dll"), CLink]
		private extern static c_int stbtt_GetNumberOfFonts(c_char* fontData);
		public static c_int GetNumberOfFonts(c_char[] fontData)
		{
			return stbtt_GetNumberOfFonts(fontData.CArray());
		}

		[Import("STBLib.dll"), CLink]
		private extern static c_int stbtt_GetOffsetForIndex(c_char* fontData, c_int index);
		public static c_int GetOffsetForIndex(c_char[] fontData, c_int index)
		{
			return stbtt_GetOffsetForIndex(fontData.CArray(), index);
		}

		[Import("STBLib.dll"), CLink]
		private extern static c_int stbtt_FindGlyphIndex(FontInfo* fontInfo, c_int uniCodepoint);
		public static c_int FindGlyphIndex(ref FontInfo fontInfo, c_int Codepoint)
		{
			return stbtt_FindGlyphIndex(&fontInfo, Codepoint);
		}

		[Import(STBLib), CLink]
		private extern static float stbtt_ScaleForMappingEmToPixels(FontInfo* fontInfo, float pixels);
		public static float ScaleForMappingEmToPixels(ref FontInfo fontInfo, float pixels)
		{
			return stbtt_ScaleForMappingEmToPixels(&fontInfo, pixels);
		}

		[Import(STBLib), CLink]
		private extern static void stbtt_GetFontVMetrics(FontInfo* fontInfo, c_int* ascent, c_int* descent, c_int* lineGap);
		public static void GetFontVMetrics(ref FontInfo fontInfo, ref c_int ascent, ref c_int descent, ref c_int lineGap)
		{
			stbtt_GetFontVMetrics(&fontInfo, &ascent, &descent, &lineGap);
		}

		[Import(STBLib), CLink]
		private extern static void stbtt_GetFontVMetricsOS2(FontInfo* fontInfo, c_int* ascent, c_int* descent, c_int* lineGap);
		public static void GetFontVMetricsOS2(ref FontInfo fontInfo, ref c_int ascent, ref c_int descent, ref c_int lineGap)
		{
			stbtt_GetFontVMetricsOS2(&fontInfo, &ascent, &descent, &lineGap);
		}

		[Import(STBLib), CLink]
		private extern static c_int stbtt_GetCodepointBox(FontInfo* fontInfo, c_int Codepoint, c_int* x0, c_int* y0, c_int* x1, c_int* y1);
		public static c_int GetCodepointBox(ref FontInfo fontInfo, c_int Codepoint, ref c_int x0, ref c_int y0, ref c_int x1, ref c_int y1)
		{
			return stbtt_GetCodepointBox(&fontInfo, Codepoint, &x0, &y0, &x1, &y1);
		}

		[Import(STBLib), CLink]
		private extern static c_int stbtt_GetGlyphHMetrics(FontInfo* fontInfo, c_int glyphIndex, c_int* advanceWidth, c_int* leftSideBearing);
		public static c_int GetGlyphHMetrics(ref FontInfo fontInfo, c_int glyphIndex, ref c_int advanceWidth, ref c_int leftSideBearking)
		{
			return stbtt_GetGlyphHMetrics(&fontInfo, glyphIndex, &advanceWidth, &leftSideBearking);
		}

		[Import(STBLib), CLink]
		private extern static c_uchar* stbtt_GetCodepointBitmap(FontInfo* fontInfo, float scale_x, float scale_y, c_int Codepoint, c_int* width, c_int* height, c_int* xoff, c_int* yoff);
		public static c_uchar* GetCodepointBitmap(ref FontInfo fontInfo, float scaleX, float scaleY, char32 Codepoint, ref c_int width, ref c_int height, ref c_int xOff, ref c_int yOff)
		{
			return stbtt_GetCodepointBitmap(&fontInfo, scaleX, scaleY, (c_int)Codepoint, &width, &height, &xOff, &yOff);
		}

		[Import(STBLib), CLink]
		private static extern void stbtt_GetCodepointBitmapBox(FontInfo* fontInfo, c_int Codepoint, float scale_x, float scale_y, c_int* ix0, c_int* iy0, c_int* ix1, c_int* iy1);
		public static void GetCodepointBitmapBox(ref FontInfo fontInfo, char32 Codepoint, float scaleX, float scaleY, ref c_int ix0, ref c_int iy0, ref c_int ix1, ref c_int iy1)
		{
			stbtt_GetCodepointBitmapBox(&fontInfo, (c_int)Codepoint, scaleX, scaleY, &ix0, &iy0, &ix1, &iy1);
		}

		[Import(STBLib), CLink]
		private static extern c_int stbtt_GetGlyphKernAdvance(FontInfo* fontInfo, c_int g1, c_int g2);
		public static c_int GetGlyphKernAdvance(ref FontInfo fontInfo, c_int g1, c_int g2)
		{
			return stbtt_GetGlyphKernAdvance(&fontInfo, g1, g2);
		}
	}
}
