namespace Voxis
{
	public enum VertexElementType
	{
		case Float;
		case Vector2;
		case Vector3;
		case Vector4;
		case Color32;

		public int ByteSize
		{
			get
			{
				switch(this)
				{
				case .Float:
					return sizeof(float);
				case .Vector2:
					return sizeof(float) * 2;
				case .Vector3:
					return sizeof(float) * 3;
				case .Vector4:
					return sizeof(float) * 4;
				case Color32:
					return sizeof(uint8) * 4;
				default:
					return 0;
				}
			}
		}
		public int Count
		{
			get
			{
				switch(this)
				{
				case .Float:
					return 1;
				case .Vector2:
					return 2;
				case .Vector3:
					return 3;
				case .Vector4:
					return 4;
				case .Color32:
					return 4;
				}
			}
		}
	}
}
