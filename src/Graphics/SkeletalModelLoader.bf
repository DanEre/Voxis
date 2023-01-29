using System;
using System.Collections;

namespace Voxis
{
	public static class SkeletalModelLoader
	{
		public static SkeletalModel Parse(String data)
		{
			SkeletalModel newModel = new SkeletalModel();

			StringSplitEnumerator lineEnumerator = data.Split('\n');

			while(lineEnumerator.MoveNext())
			{
				StringView currentLine = lineEnumerator.Current;

				// Ignores Comment lines
				if (currentLine.StartsWith("#")) continue;
				// Bone definition
				else if (currentLine.StartsWith("bone "))
				{
					SkeletalBone newBone = ParseBone(ref lineEnumerator);
					newModel.AddBone(newBone);
				}
				// Unknown keyword
				else Runtime.FatalError("Unknown data!");
			}

			return newModel;
		}

		private static SkeletalBone ParseBone(ref StringSplitEnumerator enumerator)
		{
			// Parse bone info
			StringSplitEnumerator beginLine = enumerator.Current.Split(' ');

			StringView boneName = beginLine.GetNext();
			StringView parentName = beginLine.GetNext();
			List<BoneVertex> vertices = new List<BoneVertex>();
			defer delete vertices;
			Vector3 translation = Vector3.Zero;

			while(enumerator.MoveNext())
			{
				// Parse Vertex Data
				if (enumerator.Current.StartsWith("end")) break;
				else if(enumerator.Current.StartsWith("v "))
				{
					BoneVertex vertex = ParseVertex(enumerator.Current);

					vertices.Add(vertex);
				}
				else if(enumerator.Current.StartsWith("t "))
				{
					translation = ParseTransform(enumerator.Current);
				}
			}

			return new SkeletalBone(new String(boneName), new String(parentName), vertices, translation);
		}

		private static BoneVertex ParseVertex(StringView line)
		{
			StringSplitEnumerator enumerator = line.Split(' ');

			// Skip the 'v'
			enumerator.MoveNext();

			StringView posX = enumerator.GetNext();
			StringView posY = enumerator.GetNext();
			StringView posZ = enumerator.GetNext();

			StringView uvX = enumerator.GetNext();
			StringView uvY = enumerator.GetNext();

			float fposX = float.Parse(posX);
			float fposY = float.Parse(posY);
			float fposZ = float.Parse(posZ);

			float fuvX = float.Parse(uvX);
			float fuvY = float.Parse(uvY);

			return BoneVertex(fposX, fposY, fposZ, fuvX, fuvY);
		}
		private static Vector3 ParseTransform(StringView line)
		{
			StringSplitEnumerator enumerator = line.Split(' ');

			StringView posX = enumerator.GetNext();
			StringView posY = enumerator.GetNext();
			StringView posZ = enumerator.GetNext();

			float fx = float.Parse(posX);
			float fy = float.Parse(posY);
			float fz = float.Parse(posZ);

			return Vector3(fx, fy, fz);
		}
	}
}
