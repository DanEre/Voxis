using System;
using System.Collections;

namespace Voxis
{
	public class Material
	{
		public ShaderProgram Shader { get; }
		public RasterizerState RasterizerState { get; }
		public BlendState BlendState { get; }
		public DepthState DepthState { get; }

		private Dictionary<String, IMaterialProperty> properties = new Dictionary<String, IMaterialProperty>() ~ DeleteDictionaryAndKeysAndValues!(_);

		public this(ShaderProgram shader, RasterizerState rast, BlendState blend, DepthState depth)
		{
			Shader = shader;
			RasterizerState = rast;
			BlendState = blend;
			DepthState = depth;
		}

		public ~this()
		{
			GraphicsServer.DestroyResource(Shader);
		}

		public void SetMaterialProperty(StringView name, Color color)
		{
			String tempString = new String(name);
			if (properties.ContainsKey(tempString))
			{
				MaterialParameterColor existing = properties[tempString] as MaterialParameterColor;
				existing.SetColor(color);
				delete tempString;
			}
			else
			{
				properties[tempString] = new MaterialParameterColor(color);
			}
		}

		public void SetMaterialProperty(StringView name, IMaterialProperty value)
		{
			String tempSting = new String(name);
			if(properties.ContainsKey(tempSting))
			{
				properties[tempSting] = value;
				delete tempSting;
			}
			else properties[tempSting] = value;

		}

		public void Apply()
		{
			for((String key, IMaterialProperty value) pair in properties)
			{
				pair.value.Apply(this, pair.key);
			}
		}
	}
}
