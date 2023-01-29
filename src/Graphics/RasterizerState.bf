namespace Voxis
{
	public struct RasterizerState
	{
		public CullFace Cull;
		public FrontFace Front;
		public bool Wireframe;
		public bool ScissorTest;

		public this(CullFace cullface, FrontFace frontface, bool wire, bool scissor)
		{
			Cull = cullface;
			Front = frontface;
			Wireframe = wire;
			ScissorTest = scissor;
		}
	}
}
