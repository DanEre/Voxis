namespace Voxis
{
	public class ShaderProgram : IGraphicsResource
	{
		public readonly uint ProgramID { get; }

		private this(uint programID)
		{
			ProgramID = programID;
		}
	}
}
