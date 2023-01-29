namespace Voxis
{
	public class BlockModel
	{
		public BakedQuad[] Quads;

		public this(BakedQuad[] quads)
		{
			Quads = quads;
		}

		public ~this()
		{
			for (BakedQuad quad in Quads)
			{
				delete quad;
			}
			delete Quads;
		}

		public void Rotate(Vector3 angles)
		{
			for(BakedQuad quad in Quads)
			{
				quad.Rotate(angles);
			}
		}
	}
}
