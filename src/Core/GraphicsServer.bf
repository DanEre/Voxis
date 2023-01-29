using Voxis.Framework;
using System;
using System.Diagnostics;
using System.Collections;

namespace Voxis
{
	public static class GraphicsServer
	{
		private static void OnGLDebugOutput(uint source, uint type, uint id, uint severity, int length, char8* message, void* userparameter)
		{
			GraphicsDeviceDebugMessage msg = GraphicsDeviceDebugMessage();

			String sourceStr;

			switch(source)
			{
			case OpenGL.GL_DEBUG_SOURCE_API:
				sourceStr = "API";
			case OpenGL.GL_DEBUG_SOURCE_APPLICATION:
				sourceStr = "Application";
			case OpenGL.GL_DEBUG_SOURCE_OTHER:
				sourceStr = "Other";
			case OpenGL.GL_DEBUG_SOURCE_SHADER_COMPILER:
				sourceStr = "Shader Compiler";
			case OpenGL.GL_DEBUG_SOURCE_THIRD_PARTY:
				sourceStr = "Third Party";
			case OpenGL.GL_DEBUG_SOURCE_WINDOW_SYSTEM:
				sourceStr = "Window System";
			default:
				sourceStr = "INVALID";
			}

			switch(severity)
			{
			case OpenGL.GL_DEBUG_SEVERITY_HIGH:
				msg.Severity = .High;
				break;
			case OpenGL.GL_DEBUG_SEVERITY_LOW:
				msg.Severity = .Low;
				break;
			case OpenGL.GL_DEBUG_SEVERITY_MEDIUM:
				msg.Severity = .Medium;
				break;
			case OpenGL.GL_DEBUG_SEVERITY_NOTIFICATION:
				msg.Severity = .Info;
				break;
			default:
				Runtime.FatalError("Invalid severity value!");
			}
			msg.Message = StringView(message, length);

			OnDebugMessageEvent.Invoke(msg);
		}

		public static Texture2D WhiteTexture { get; private set; }
		public static Texture2D BlackTexture { get; private set; }
		public static Texture2D MissingTexture { get; private set; }

		public static Event<delegate void(GraphicsDeviceDebugMessage)> OnDebugMessageEvent = Event<delegate void(GraphicsDeviceDebugMessage)>();

		private static Queue<IGraphicsResource> destroyQueue = new Queue<IGraphicsResource>() ~ delete _;
		private static VertexBuffer activeVertexBuffer;
		private static IndexBuffer activeIndexBuffer;
		private static ShaderProgram activeShaderProgram;
		private static VertexLayout activeVertexLayout;

		public static void OnLoad()
		{
			// OpenGL context should be ready

			// Load OpenGL functions
			OpenGL.Init(WindowServer.GetOpenGLAdressFunction());

			// Check if OpenGL debug context is enabled
			int flags = 0;
			OpenGL.glGetIntegerv(OpenGL.GL_CONTEXT_FLAGS, &flags);
			if (flags & OpenGL.GL_CONTEXT_FLAG_DEBUG_BIT != 0)
			{
				// Debug context enabled
				OpenGL.glEnable(OpenGL.GL_DEBUG_OUTPUT);
				OpenGL.glEnable(OpenGL.GL_DEBUG_OUTPUT_SYNCHRONOUS);
				OpenGL.glDebugMessageCallback(=> OnGLDebugOutput, null);
			}

			// Create default textures
			Color[] tempColors = scope Color[](Color.White, Color.White, Color.White, Color.White);
			WhiteTexture = CreateTexture2D(2, 2, .Point, .RGBA, .RGBA, .Float, tempColors.CArray());

			tempColors = scope Color[](Color.Black, Color.Black, Color.Black, Color.Black);
			BlackTexture = CreateTexture2D(2, 2, .Point, .RGBA, .RGBA, .Float, tempColors.CArray());

			tempColors = scope Color[](Color.Black, Color.Purple, Color.Purple, Color.Black);
			MissingTexture = CreateTexture2D(2, 2, .Point, .RGBA, .RGBA, .Float, tempColors.CArray());

			// Create the needed VAO
			uint varray = 0;
			OpenGL.glGenVertexArrays(1, &varray);
			OpenGL.glBindVertexArray(varray);
		}

		public static void OnShutdown()
		{
			DestroyResource(WhiteTexture);
			DestroyResource(BlackTexture);
			DestroyResource(MissingTexture);

			while(destroyQueue.Count > 0)
			{
				IGraphicsResource resource = destroyQueue.PopFront();
				DestroyResource(resource);
			}
		}

		public static void ClearColorTarget(Color color)
		{
			OpenGL.glClearColor(color.R, color.G, color.B, color.A);
			OpenGL.glClear(OpenGL.GL_COLOR_BUFFER_BIT);
		}
		public static void ClearDepthStencilTarget()
		{
			OpenGL.glClearDepth(1.0);
			OpenGL.glClearStencil(0);

			// Have to enable depth write to actually clear depth
			OpenGL.glDepthMask(OpenGL.GL_TRUE);
			OpenGL.glStencilMask(OpenGL.GL_TRUE);

			OpenGL.glClear(OpenGL.GL_DEPTH_BUFFER_BIT | OpenGL.GL_STENCIL_BUFFER_BIT);
		}
		public static VertexBuffer CreateVertexBuffer(VertexHint usageHint, uint32 size)
		{
			uint buffer = 0;
			OpenGL.glGenBuffers(1, &buffer);
			OpenGL.glBindBuffer(OpenGL.GL_ARRAY_BUFFER, buffer);
			OpenGL.glBufferData(OpenGL.GL_ARRAY_BUFFER, size, null, usageHint == .DynamicDraw ? OpenGL.GL_DYNAMIC_DRAW : OpenGL.GL_STATIC_DRAW);
			OpenGL.glBindBuffer(OpenGL.GL_ARRAY_BUFFER, 0);

			return new [Friend]VertexBuffer(buffer, size);
		}

		public static void UpdateVertexBuffer(VertexBuffer buffer, uint32 offset, uint32 size, void* data)
		{
			Debug.Assert(buffer.Size >= size + offset, "Buffer overflow!");

			OpenGL.glBindBuffer(OpenGL.GL_ARRAY_BUFFER, buffer.BufferName);
			OpenGL.glBufferSubData(OpenGL.GL_ARRAY_BUFFER, offset, size, data);
			OpenGL.glBindBuffer(OpenGL.GL_ARRAY_BUFFER, 0);
		}

		public static void DestroyVertexBuffer(VertexBuffer buffer)
		{
			uint bufferName = buffer.BufferName;
			OpenGL.glDeleteBuffers(1, &bufferName);
		}

		public static IndexBuffer CreateIndexBuffer(VertexHint usageHint, uint32 size)
		{
			uint buffer = 0;

			OpenGL.glGenBuffers(1, &buffer);
			OpenGL.glBindBuffer(OpenGL.GL_ELEMENT_ARRAY_BUFFER, buffer);
			OpenGL.glBufferData(OpenGL.GL_ELEMENT_ARRAY_BUFFER, size, null, usageHint == .DynamicDraw ? OpenGL.GL_DYNAMIC_DRAW : OpenGL.GL_STATIC_DRAW);

			OpenGL.glBindBuffer(OpenGL.GL_ELEMENT_ARRAY_BUFFER, 0);

			return new [Friend]IndexBuffer(buffer, size);
		}

		public static void UpdateIndexBuffer(IndexBuffer buffer, uint32 offset, uint32 size, void* data)
		{
			Debug.Assert(buffer.Size >= offset + size, "Buffer Overflow!");

			OpenGL.glBindBuffer(OpenGL.GL_ELEMENT_ARRAY_BUFFER, buffer.BufferName);
			OpenGL.glBufferSubData(OpenGL.GL_ELEMENT_ARRAY_BUFFER, offset, size, data);
			OpenGL.glBindBuffer(OpenGL.GL_ELEMENT_ARRAY_BUFFER, 0);
		}

		public static void DestroyIndexBuffer(IndexBuffer buffer)
		{
			uint bufferName = buffer.BufferName;
			OpenGL.glDeleteBuffers(1, &bufferName);
		}

		public static void SetViewport(uint32 id, uint32 x, uint32 y, uint32 width, uint32 height)
		{
			OpenGL.glViewportIndexedf(id, x, y, width, height);
		}

		public static void SetDepthState(DepthState state)
		{
			if (state.EnableRead)
			{
				OpenGL.glEnable(OpenGL.GL_DEPTH_TEST);

				switch(state.DepthTestFunc)
				{
				case .Always:
					OpenGL.glDepthFunc(OpenGL.GL_ALWAYS);
					break;
				case .Equal:
					OpenGL.glDepthFunc(OpenGL.GL_EQUAL);
					break;
				case .Greater:
					OpenGL.glDepthFunc(OpenGL.GL_GREATER);
					break;
				case .GreaterEqual:
					OpenGL.glDepthFunc(OpenGL.GL_GEQUAL);
					break;
				case .Less:
					OpenGL.glDepthFunc(OpenGL.GL_LESS);
					break;
				case .LessEqual:
					OpenGL.glDepthFunc(OpenGL.GL_LEQUAL);
					break;
				case .Never:
					OpenGL.glDepthFunc(OpenGL.GL_NEVER);
					break;
				case .NotEqual:
					OpenGL.glDepthFunc(OpenGL.GL_NOTEQUAL);
					break;
				}
			}
			else
			{
				OpenGL.glDisable(OpenGL.GL_DEPTH_TEST);
			}

			if (state.EnableWrite)
			{
				OpenGL.glDepthMask(OpenGL.GL_TRUE);
			}
			else
			{
				OpenGL.glDepthMask(OpenGL.GL_FALSE);
			}
		}

		public static void SetIndexBuffer(IndexBuffer indexBuffer)
		{
			activeIndexBuffer = indexBuffer;
		}
		public static void SetShaderProgram(ShaderProgram program)
		{
			activeShaderProgram = program;
		}
		public static void SetVertexBuffer(VertexBuffer vertexBuffer)
		{
			activeVertexBuffer = vertexBuffer;
		}
		public static void SetVertexLayout(VertexLayout layout)
		{
			activeVertexLayout = layout;
		}

		public static void SetRasterizerState(RasterizerState state)
		{
			OpenGL.glEnable(OpenGL.GL_CULL_FACE);
			switch(state.Cull){
			case .Back:
				OpenGL.glCullFace(OpenGL.GL_BACK);
				break;
			case .Front:
				OpenGL.glCullFace(OpenGL.GL_FRONT);
				break;
			case .None:
				OpenGL.glDisable(OpenGL.GL_CULL_FACE);
			}

			switch(state.Front){
			case .Clockwise:
				OpenGL.glFrontFace(OpenGL.GL_CW);
			case .CounterClockwise:
				OpenGL.glFrontFace(OpenGL.GL_CCW);
			}

			if (state.ScissorTest) OpenGL.glEnable(OpenGL.GL_SCISSOR_TEST);
			else OpenGL.glDisable(OpenGL.GL_SCISSOR_TEST);

			if (state.Wireframe) OpenGL.glPolygonMode(OpenGL.GL_FRONT_AND_BACK, OpenGL.GL_LINE);
			else OpenGL.glPolygonMode(OpenGL.GL_FRONT_AND_BACK, OpenGL.GL_FILL);
		}

		public static void SetScissorRect(uint32 x, uint32 y, uint32 width, uint32 height)
		{
			OpenGL.glScissor(x, y, width, height);
		}

		public static ShaderProgram CreateShaderProgram(StringView vertexShaderCode, StringView fragmentShaderCode)
		{
			uint fragShader = OpenGL.glCreateShader(OpenGL.GL_FRAGMENT_SHADER);
			uint vertexShader = OpenGL.glCreateShader(OpenGL.GL_VERTEX_SHADER);

			// Vertex shader compilation
			char8*[] shaderCode = scope char8*[](vertexShaderCode.Ptr);
			int[] lengths = scope int[](vertexShaderCode.Length);
			OpenGL.glShaderSource(vertexShader, 1, shaderCode.CArray(), lengths.CArray());
			OpenGL.glCompileShader(vertexShader);

			// Vertex shader error checking
			String vertexError = scope String();
			if (!CheckShaderError(vertexShader, vertexError))
			{
				GraphicsDeviceDebugMessage dbgMsg = GraphicsDeviceDebugMessage();
				dbgMsg.Message = vertexError;
				dbgMsg.Severity = .High;
				OnDebugMessageEvent.Invoke(dbgMsg);
			}

			// Fragment shader compilation
			shaderCode = scope char8*[](fragmentShaderCode.Ptr);
			lengths = scope int[](fragmentShaderCode.Length);
			OpenGL.glShaderSource(fragShader, 1, shaderCode.CArray(), lengths.CArray());
			OpenGL.glCompileShader(fragShader);

			// Fragment shader error checking
			String fragmentError = scope String();
			if (!CheckShaderError(fragShader, fragmentError))
			{
				GraphicsDeviceDebugMessage dbgMsg = GraphicsDeviceDebugMessage();
				dbgMsg.Message = fragmentError;
				dbgMsg.Severity = .High;
				OnDebugMessageEvent.Invoke(dbgMsg);
			}

			// Shader Programm creation and link
			uint program = OpenGL.glCreateProgram();
			OpenGL.glAttachShader(program, vertexShader);
			OpenGL.glAttachShader(program, fragShader);
			OpenGL.glLinkProgram(program);

			// Shader Program error checking
			String programError = scope String();
			if (!CheckShaderProgramError(program, programError))
			{
				GraphicsDeviceDebugMessage dbgMsg = GraphicsDeviceDebugMessage();
				dbgMsg.Message = programError;
				dbgMsg.Severity = .High;
				OnDebugMessageEvent.Invoke(dbgMsg);
			}

			OpenGL.glDeleteShader(vertexShader);
			OpenGL.glDeleteShader(fragShader);

			return new [Friend]ShaderProgram(program);
		}

		public static void SetProgramParameter(ShaderProgram program, StringView name, Vector3 value)
		{
			Vector3 local = value;
			OpenGL.glUseProgram(program.ProgramID);
			int location = OpenGL.glGetUniformLocation(program.ProgramID, name.ToScopeCStr!());
			Debug.Assert(location >= 0, "Uniform could not be found");
			OpenGL.glUniform3fv(location, 1, &local.X);
			OpenGL.glUseProgram(0);
		}

		public static void SetProgramParameter(ShaderProgram program, StringView name, Color value)
		{
			Color local = value;
			OpenGL.glUseProgram(program.ProgramID);
			int location = OpenGL.glGetUniformLocation(program.ProgramID, name.ToScopeCStr!());
			Debug.Assert(location >= 0, "Uniform could not be found");
			OpenGL.glUniform4fv(location, 1, &local.R);
			OpenGL.glUseProgram(0);
		}


		public static void SetProgramParameter(ShaderProgram program, StringView name, float value)
		{
			OpenGL.glUseProgram(program.ProgramID);
			int location = OpenGL.glGetUniformLocation(program.ProgramID, name.ToScopeCStr!());
			Debug.Assert(location >= 0, "Uniform could not be found");
			OpenGL.glUniform1f(location, value);
			OpenGL.glUseProgram(0);
		}

		public static void SetProgramParameter(ShaderProgram program, StringView name, int value)
		{
			OpenGL.glUseProgram(program.ProgramID);
			int location = OpenGL.glGetUniformLocation(program.ProgramID, name.ToScopeCStr!());
			Debug.Assert(location >= 0, "Uniform could not be found");
			OpenGL.glUniform1i(location, value);
			OpenGL.glUseProgram(0);
		}

		public static Texture2D CreateFromImage(Image image)
		{
			uint texName = 0;
			OpenGL.glGenTextures(1, &texName);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D, texName);
			OpenGL.glTexImage2D(OpenGL.GL_TEXTURE_2D, 0, OpenGL.GL_RGBA, image.Width, image.Height, 0, OpenGL.GL_RGBA, OpenGL.GL_FLOAT, image.GetPixels().CArray());
			OpenGL.glGenerateMipmap(OpenGL.GL_TEXTURE_2D);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D, 0);

			return new [Friend]Texture2D(texName, image.Width, image.Height);
		}

		public static void SetProgramParameter(ShaderProgram program, StringView name, Matrix4x4 value)
		{
			int location = OpenGL.glGetUniformLocation(program.ProgramID, name.ToScopeCStr!());

			Debug.Assert(location >= 0, "Uniform could not be found");

			Matrix4x4 localCopy = value;

			OpenGL.glUseProgram(program.ProgramID);
			OpenGL.glUniformMatrix4fv(location, 1, OpenGL.GL_FALSE, &localCopy.M11);
			OpenGL.glUseProgram(0);
		}

		public static void SetProgramTexture(ShaderProgram program, StringView name, Texture2D texture, uint slot)
		{
			uint textureID = 0;
			if (texture != null)
				textureID = texture.TextureName;

			// Activate texture slot
			OpenGL.glActiveTexture(OpenGL.GL_TEXTURE0 + slot);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D, textureID);

			// Set texture uniform slot in program
			SetProgramParameter(program, name, int(slot));
		}

		public static void SetProgramTexture(ShaderProgram program, StringView name, TextureArray2D array, uint slot)
		{
			OpenGL.glActiveTexture(OpenGL.GL_TEXTURE0 + slot);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D_ARRAY, array.texName);

			SetProgramParameter(program, name, int(slot));
		}

		public static void DrawIndexedPrimitives(int indexCount)
		{
			Debug.Assert(activeVertexBuffer != null);
			Debug.Assert(activeIndexBuffer != null);
			Debug.Assert(activeShaderProgram != null);
			Debug.Assert(activeVertexLayout != null);

			// Bind the buffers
			OpenGL.glBindBuffer(OpenGL.GL_ARRAY_BUFFER, activeVertexBuffer.BufferName);
			OpenGL.glBindBuffer(OpenGL.GL_ELEMENT_ARRAY_BUFFER, activeIndexBuffer.BufferName);
			OpenGL.glUseProgram(activeShaderProgram.ProgramID);

			// Apply vertex layout
			for (int i = 0; i < activeVertexLayout.Elements.Count; i++)
			{
				VertexLayoutElement current = activeVertexLayout.Elements[i];

				OpenGL.glVertexAttribPointer((uint)i, current.ElementType.Count, current.ElementType.ToGLSingleElementType(), (uint8)(current.Normalized ? OpenGL.GL_TRUE : OpenGL.GL_FALSE), activeVertexLayout.Size, (void*)current.Stride);
				OpenGL.glEnableVertexAttribArray((uint)i);
			}

			// Drawcall
			OpenGL.glDrawElements(OpenGL.GL_TRIANGLES, indexCount, OpenGL.GL_UNSIGNED_SHORT, null);

			// Unbind buffers and shader
			OpenGL.glBindBuffer(OpenGL.GL_ARRAY_BUFFER, 0);
			OpenGL.glBindBuffer(OpenGL.GL_ELEMENT_ARRAY_BUFFER, 0);
			OpenGL.glUseProgram(0);

			Performance.CurrentFrame.DrawPrimitive++;
		}

		public static void UpdateTextureArray2D(TextureArray2D tex, int layer, PixelFormat format, BufferType bufferElementType, void* data)
		{
			Debug.Assert(data != null);
			Debug.Assert(tex.Width > 0 && tex.Height > 0 && tex.Layers > 0);

			OpenGL.glActiveTexture(OpenGL.GL_TEXTURE0);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D_ARRAY, tex.texName);
			OpenGL.glTexSubImage3D(OpenGL.GL_TEXTURE_2D_ARRAY, 0, 0, 0, layer, tex.Width, tex.Height, 1, format.ToGlFormat(), bufferElementType.ToGLType(), data);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D_ARRAY, 0);
		}

		public static TextureArray2D CreateTextureArray2D(int width, int height, int layers)
		{
			uint texName = 0;
			OpenGL.glGenTextures(1, &texName);

			Debug.Assert(texName != 0);

			OpenGL.glActiveTexture(OpenGL.GL_TEXTURE0);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D_ARRAY, texName);
			OpenGL.glTexStorage3D(OpenGL.GL_TEXTURE_2D_ARRAY, 1, OpenGL.GL_RGBA8, width, height, layers);

			OpenGL.glTexParameteri(OpenGL.GL_TEXTURE_2D_ARRAY, OpenGL.GL_TEXTURE_MIN_FILTER, OpenGL.GL_NEAREST);
			OpenGL.glTexParameteri(OpenGL.GL_TEXTURE_2D_ARRAY, OpenGL.GL_TEXTURE_MAG_FILTER, OpenGL.GL_NEAREST);
			OpenGL.glTexParameteri(OpenGL.GL_TEXTURE_2D_ARRAY, OpenGL.GL_TEXTURE_WRAP_S, OpenGL.GL_CLAMP_TO_EDGE);
			OpenGL.glTexParameteri(OpenGL.GL_TEXTURE_2D_ARRAY, OpenGL.GL_TEXTURE_WRAP_T, OpenGL.GL_CLAMP_TO_EDGE);
			//OpenGL.glGenerateMipmap(OpenGL.GL_TEXTURE_2D_ARRAY);

			OpenGL.glGenerateMipmap(OpenGL.GL_TEXTURE_2D_ARRAY);

			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D_ARRAY, 0);

			return new [Friend]TextureArray2D(texName, width, height, layers);
		}

		public static void SetCubemapPixels(TextureCubemap cubemap, CubemapSide side, int width, int height, PixelFormat internalFormat, PixelFormat bufferFormat, BufferType bufferElementType, void* data)
		{
			uint id = cubemap.[Friend]textureName;
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_CUBE_MAP, id);

			OpenGL.glTexImage2D(side.Underlying, 0, int(internalFormat.ToGlFormat()), width, height, 0, bufferFormat.ToGlFormat(), bufferElementType.ToGLType(), data);

			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_CUBE_MAP, 0);
		}

		public static TextureCubemap CreateTextureCubemap(TextureFilter filter)
		{
			uint textureName = 0;
			OpenGL.glGenTextures(1, &textureName);

			Debug.Assert(textureName != 0);

			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_CUBE_MAP, textureName);

			OpenGL.glTexParameteri(OpenGL.GL_TEXTURE_CUBE_MAP, OpenGL.GL_TEXTURE_MIN_FILTER, filter.ToGLFilter());
			OpenGL.glTexParameteri(OpenGL.GL_TEXTURE_CUBE_MAP, OpenGL.GL_TEXTURE_MAG_FILTER, filter.ToGLFilter());

			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D, 0);

			return new [Friend]TextureCubemap(textureName);
		}

		public static Texture2D CreateTexture2D(int width, int height, TextureFilter filter, PixelFormat internalFormat, PixelFormat bufferFormat, BufferType bufferElementType, void* data)
		{
			uint texName = 0;
			OpenGL.glGenTextures(1, &texName);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D, texName);
			OpenGL.glTexImage2D(OpenGL.GL_TEXTURE_2D, 0, int(internalFormat.ToGlFormat()), width, height, 0, bufferFormat.ToGlFormat(), bufferElementType.ToGLType(), data);

			OpenGL.glTexParameteri(OpenGL.GL_TEXTURE_2D, OpenGL.GL_TEXTURE_MIN_FILTER, filter.ToGLFilter());
			OpenGL.glTexParameteri(OpenGL.GL_TEXTURE_2D, OpenGL.GL_TEXTURE_MAG_FILTER, filter.ToGLFilter());

			OpenGL.glGenerateMipmap(OpenGL.GL_TEXTURE_2D);
			OpenGL.glBindTexture(OpenGL.GL_TEXTURE_2D, 0);

			return new [Friend]Texture2D(texName, width, height);
		}

		public static void SetBlendState(BlendState state)
		{
			if(state.Enabled)
			{
				OpenGL.glEnable(OpenGL.GL_BLEND);
				OpenGL.glBlendFunc(OpenGL.GL_SRC_ALPHA, OpenGL.GL_ONE_MINUS_SRC_ALPHA);
			}
			else OpenGL.glDisable(OpenGL.GL_BLEND);
		}

		public static void DestroyResource(IGraphicsResource resource)
		{
			Debug.Assert(resource != null);

			if (resource is IndexBuffer)
			{
				uint bufferName = (resource as IndexBuffer).BufferName;
				OpenGL.glDeleteBuffers(1, &bufferName);
			}
			else if(resource is ShaderProgram)
			{
				uint programName = (resource as ShaderProgram).ProgramID;
				OpenGL.glDeleteProgram(programName);
			}
			else if(resource is Texture2D)
			{
				uint textureName = (resource as Texture2D).TextureName;
				OpenGL.glDeleteTextures(1, &textureName);
			}
			else if(resource is VertexBuffer)
			{
				uint bufferName = (resource as VertexBuffer).BufferName;
				OpenGL.glDeleteBuffers(1, &bufferName);
			}
			else
			{
				// Unhandled resource type
				Runtime.NotImplemented();
			}

			// Destroy the actual object
			delete resource;
		}

		public static void QueueResourceDestroy(IGraphicsResource resource)
		{
			destroyQueue.Add(resource);
		}

		// Utility methods

		// Updates a part of the vertex buffer with a part of the given data
		public static void UpdateVertexBuffer<T>(VertexBuffer buffer, uint32 offset, uint32 length, T[] data) where T : struct
		{
			UpdateVertexBuffer(buffer, offset, (uint32)sizeof(T) * length, data.CArray());
		}

		// Updates the vertex buffer with all of the array data
		public static void UpdateVertexbuffer<T>(VertexBuffer buffer, T[] data) where T : struct
		{
			UpdateVertexBuffer(buffer, 0, (uint32)sizeof(T) * (uint32)data.Count, data.CArray());
		}

		// Updates a part of the index buffer with a part of the given data
		public static void UpdateIndexBuffer<T>(IndexBuffer buffer, uint32 offset, uint32 length, T[] data) where T : struct
		{
			UpdateIndexBuffer(buffer, offset, (uint32)sizeof(T) * length, data.CArray());
		}

		// Updates the index buffer with all of the array data
		public static void UpdateIndexBuffer<T>(IndexBuffer indexBuffer, T[] data)
		{
			UpdateIndexBuffer(indexBuffer, 0, (uint32)sizeof(T) * (uint32)data.Count, data.CArray());
		}

		private static uint ToGLType(this BufferType type)
		{
			switch(type)
			{
			case .Byte:
				return OpenGL.GL_BYTE;
			case .Float:
				return OpenGL.GL_FLOAT;
			case .UnsignedByte:
				return OpenGL.GL_UNSIGNED_BYTE;
			}
		}

		private static uint ToGlFormat(this PixelFormat format)
		{
			switch(format)
			{
			case .RGBA:
				return OpenGL.GL_RGBA;
			case .RGB:
				return OpenGL.GL_RGB;
			case .R:
				return OpenGL.GL_RED;
			case .RG:
				return OpenGL.GL_RG;
			}
		}

		private static int ToGLFilter(this TextureFilter filter)
		{
			switch(filter)
			{
			case .Linear:
				return OpenGL.GL_LINEAR;
			case .Point:
				return OpenGL.GL_NEAREST;
			}
		}

		private static bool CheckShaderError(uint shader, String error)
		{
			int success = 0;
			OpenGL.glGetShaderiv(shader, OpenGL.GL_COMPILE_STATUS, &success);

			if (success == OpenGL.GL_FALSE)
			{
				char8[] infoLog = scope char8[512];
				int infoLogLength = 0;
				OpenGL.glGetShaderInfoLog(shader, infoLog.Count, &infoLogLength, infoLog.CArray());

				error.Append(infoLog, 0, infoLogLength);

				return false;
			}
			else
			{
				return true;
			}
		}

		private static bool CheckShaderProgramError(uint program, String buff)
		{
			int success = 0;
			OpenGL.glGetProgramiv(program, OpenGL.GL_LINK_STATUS, &success);

			if (success == OpenGL.GL_FALSE)
			{
				char8[] infoLog = scope char8[512];
				int infoLogLength = 0;
				OpenGL.glGetProgramInfoLog(program, 512, &infoLogLength, infoLog.CArray());

				buff.Append(infoLog, 0, infoLogLength);

				return false;
			}
			else
			{
				return true;
			}
		}

		private static uint ToGLSingleElementType(this VertexElementType elementType)
		{
			switch(elementType)
			{
			case .Float, .Vector2, .Vector3, .Vector4:
				return OpenGL.GL_FLOAT;
			case .Color32:
				return OpenGL.GL_UNSIGNED_BYTE;
			}
		}
	}
}
