using System.Collections;
using System;

namespace Voxis
{
	public class SkeletalModel
	{
		private List<SkeletalBone> bones = new List<SkeletalBone>();

		public void AddBone(SkeletalBone newBone)
		{
			bones.Add(newBone);
		}

		public void Print()
		{
			Console.WriteLine("Skeletal Model");

			for (SkeletalBone bone in bones)
			{
				Console.WriteLine("Name: {0}", bone.Name);
				Console.WriteLine("Parent: {0}", bone.Name);
				Console.WriteLine("Translation: {0}", bone.LocalTranslation);
				Console.WriteLine("Vertices:");

				for(BoneVertex vertex in bone.Vertices)
				{
					Console.WriteLine("    Position: {0} UV: {1}", vertex.Position, vertex.UV);
				}
			}
		}
	}
}
