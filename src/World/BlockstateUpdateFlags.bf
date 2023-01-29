namespace Voxis
{
	enum BlockstatUpdateFlags
	{
		None = 0,
		Neighbours = 1,
		Lighting = 2,
		MeshUpdate = 4,

		All = Neighbours | Lighting | MeshUpdate
	}
}