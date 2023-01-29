using Voxis.Framework;
namespace Voxis
{
	public enum CubemapSide : uint
	{
		PositiveX = OpenGL.GL_TEXTURE_CUBE_MAP_POSITIVE_X,
		NegativeX = OpenGL.GL_TEXTURE_CUBE_MAP_NEGATIVE_X,
		PositiveY = OpenGL.GL_TEXTURE_CUBE_MAP_POSITIVE_Y,
		NegativeY = OpenGL.GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,
		PositiveZ = OpenGL.GL_TEXTURE_CUBE_MAP_POSITIVE_Z,
		NegativeZ = OpenGL.GL_TEXTURE_CUBE_MAP_NEGATIVE_Z
	}
}
