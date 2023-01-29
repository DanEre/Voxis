using System;
using System.Collections;

namespace Voxis
{
	public class SkeletalBone
	{
		public String Name { get; }
		public String Parent { get; }
		public List<BoneVertex> Vertices { get; }
		public Vector3 LocalTranslation { get; }

		public this(String name, String parent, List<BoneVertex> vertices, Vector3 localTranslation)
		{
			Name = name;
			Parent = parent;
			Vertices = vertices;
			LocalTranslation = localTranslation;
		}

		public ~this()
		{
			delete Name;
			delete Parent;
			delete Vertices;
		}
	}
}
