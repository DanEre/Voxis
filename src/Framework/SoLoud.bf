using System;
using System.Interop;
using System.Text;

namespace Voxis.Framework
{
	public class SoloudObject
	{
		public const String LIBRARY_NAME = "soloud_x64.dll";
		public const c_int C_FALSE = 0;
		public const c_int C_TRUE = 1;

	    public void* objhandle;
	}

public class Soloud : SoloudObject
{
	public const int AUTO = 0;
	public const int SDL1 = 1;
	public const int SDL2 = 2;
	public const int PORTAUDIO = 3;
	public const int WINMM = 4;
	public const int XAUDIO2 = 5;
	public const int WASAPI = 6;
	public const int ALSA = 7;
	public const int JACK = 8;
	public const int OSS = 9;
	public const int OPENAL = 10;
	public const int COREAUDIO = 11;
	public const int OPENSLES = 12;
	public const int VITA_HOMEBREW = 13;
	public const int MINIAUDIO = 14;
	public const int NOSOUND = 15;
	public const int NULLDRIVER = 16;
	public const int BACKEND_MAX = 17;
	public const int CLIP_ROUNDOFF = 1;
	public const int ENABLE_VISUALIZATION = 2;
	public const int LEFT_HANDED_3D = 4;
	public const int NO_FPU_REGISTER_CHANGE = 8;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Soloud_create();
	public this()
	{
		objhandle = Soloud_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Soloud_destroy(void* aObjHandle);
	public ~this()
	{
		Soloud_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_initEx(void* aObjHandle, uint aFlags, uint aBackend, uint aSamplerate, uint aBufferSize, uint aChannels);
	public int init(uint aFlags = CLIP_ROUNDOFF, uint aBackend = AUTO, uint aSamplerate = AUTO, uint aBufferSize = AUTO, uint aChannels = 2)
	{
		return Soloud_initEx(objhandle, aFlags, aBackend, aSamplerate, aBufferSize, aChannels);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_deinit(void* aObjHandle);
	public void deinit()
	{
		Soloud_deinit(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getVersion(void* aObjHandle);
	public uint getVersion()
	{
		return Soloud_getVersion(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Soloud_getErrorString(void* aObjHandle, int aErrorCode);
	public StringView getErrorString(int aErrorCode)
	{
		void* p = Soloud_getErrorString(objhandle, aErrorCode);
		return StringView((char8*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getBackendId(void* aObjHandle);
	public uint getBackendId()
	{
		return Soloud_getBackendId(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Soloud_getBackendString(void* aObjHandle);
	public StringView getBackendString()
	{
		void* p = Soloud_getBackendString(objhandle);
		return StringView((char8*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getBackendChannels(void* aObjHandle);
	public uint getBackendChannels()
	{
		return Soloud_getBackendChannels(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getBackendSamplerate(void* aObjHandle);
	public uint getBackendSamplerate()
	{
		return Soloud_getBackendSamplerate(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getBackendBufferSize(void* aObjHandle);
	public uint getBackendBufferSize()
	{
		return Soloud_getBackendBufferSize(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_setSpeakerPosition(void* aObjHandle, uint aChannel, float aX, float aY, float aZ);
	public int setSpeakerPosition(uint aChannel, float aX, float aY, float aZ)
	{
		return Soloud_setSpeakerPosition(objhandle, aChannel, aX, aY, aZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_getSpeakerPosition(void* aObjHandle, uint aChannel, float[] aX, float[] aY, float[] aZ);
	public int getSpeakerPosition(uint aChannel, float[] aX, float[] aY, float[] aZ)
	{
		return Soloud_getSpeakerPosition(objhandle, aChannel, aX, aY, aZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_playEx(void* aObjHandle, void* aSound, float aVolume, float aPan, int aPaused, uint aBus);
	public uint play(SoloudObject aSound, float aVolume = -1.0f, float aPan = 0.0f, int aPaused = 0, uint aBus = 0)
	{
		return Soloud_playEx(objhandle, aSound.objhandle, aVolume, aPan, aPaused, aBus);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_playClockedEx(void* aObjHandle, double aSoundTime, void* aSound, float aVolume, float aPan, uint aBus);
	public uint playClocked(double aSoundTime, SoloudObject aSound, float aVolume = -1.0f, float aPan = 0.0f, uint aBus = 0)
	{
		return Soloud_playClockedEx(objhandle, aSoundTime, aSound.objhandle, aVolume, aPan, aBus);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_play3dEx(void* aObjHandle, void* aSound, float aPosX, float aPosY, float aPosZ, float aVelX, float aVelY, float aVelZ, float aVolume, int aPaused, uint aBus);
	public uint play3d(SoloudObject aSound, float aPosX, float aPosY, float aPosZ, float aVelX = 0.0f, float aVelY = 0.0f, float aVelZ = 0.0f, float aVolume = 1.0f, int aPaused = 0, uint aBus = 0)
	{
		return Soloud_play3dEx(objhandle, aSound.objhandle, aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aPaused, aBus);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_play3dClockedEx(void* aObjHandle, double aSoundTime, void* aSound, float aPosX, float aPosY, float aPosZ, float aVelX, float aVelY, float aVelZ, float aVolume, uint aBus);
	public uint play3dClocked(double aSoundTime, SoloudObject aSound, float aPosX, float aPosY, float aPosZ, float aVelX = 0.0f, float aVelY = 0.0f, float aVelZ = 0.0f, float aVolume = 1.0f, uint aBus = 0)
	{
		return Soloud_play3dClockedEx(objhandle, aSoundTime, aSound.objhandle, aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aBus);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_playBackgroundEx(void* aObjHandle, void* aSound, float aVolume, int aPaused, uint aBus);
	public uint playBackground(SoloudObject aSound, float aVolume = -1.0f, int aPaused = 0, uint aBus = 0)
	{
		return Soloud_playBackgroundEx(objhandle, aSound.objhandle, aVolume, aPaused, aBus);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_seek(void* aObjHandle, uint aVoiceHandle, double aSeconds);
	public int seek(uint aVoiceHandle, double aSeconds)
	{
		return Soloud_seek(objhandle, aVoiceHandle, aSeconds);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_stop(void* aObjHandle, uint aVoiceHandle);
	public void stop(uint aVoiceHandle)
	{
		Soloud_stop(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_stopAll(void* aObjHandle);
	public void stopAll()
	{
		Soloud_stopAll(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_stopAudioSource(void* aObjHandle, void* aSound);
	public void stopAudioSource(SoloudObject aSound)
	{
		Soloud_stopAudioSource(objhandle, aSound.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_countAudioSource(void* aObjHandle, void* aSound);
	public int countAudioSource(SoloudObject aSound)
	{
		return Soloud_countAudioSource(objhandle, aSound.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setFilterParameter(void* aObjHandle, uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aValue);
	public void setFilterParameter(uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aValue)
	{
		Soloud_setFilterParameter(objhandle, aVoiceHandle, aFilterId, aAttributeId, aValue);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getFilterParameter(void* aObjHandle, uint aVoiceHandle, uint aFilterId, uint aAttributeId);
	public float getFilterParameter(uint aVoiceHandle, uint aFilterId, uint aAttributeId)
	{
		return Soloud_getFilterParameter(objhandle, aVoiceHandle, aFilterId, aAttributeId);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_fadeFilterParameter(void* aObjHandle, uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aTo, double aTime);
	public void fadeFilterParameter(uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aTo, double aTime)
	{
		Soloud_fadeFilterParameter(objhandle, aVoiceHandle, aFilterId, aAttributeId, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_oscillateFilterParameter(void* aObjHandle, uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aFrom, float aTo, double aTime);
	public void oscillateFilterParameter(uint aVoiceHandle, uint aFilterId, uint aAttributeId, float aFrom, float aTo, double aTime)
	{
		Soloud_oscillateFilterParameter(objhandle, aVoiceHandle, aFilterId, aAttributeId, aFrom, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Soloud_getStreamTime(void* aObjHandle, uint aVoiceHandle);
	public double getStreamTime(uint aVoiceHandle)
	{
		return Soloud_getStreamTime(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Soloud_getStreamPosition(void* aObjHandle, uint aVoiceHandle);
	public double getStreamPosition(uint aVoiceHandle)
	{
		return Soloud_getStreamPosition(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_getPause(void* aObjHandle, uint aVoiceHandle);
	public int getPause(uint aVoiceHandle)
	{
		return Soloud_getPause(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getVolume(void* aObjHandle, uint aVoiceHandle);
	public float getVolume(uint aVoiceHandle)
	{
		return Soloud_getVolume(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getOverallVolume(void* aObjHandle, uint aVoiceHandle);
	public float getOverallVolume(uint aVoiceHandle)
	{
		return Soloud_getOverallVolume(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getPan(void* aObjHandle, uint aVoiceHandle);
	public float getPan(uint aVoiceHandle)
	{
		return Soloud_getPan(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getSamplerate(void* aObjHandle, uint aVoiceHandle);
	public float getSamplerate(uint aVoiceHandle)
	{
		return Soloud_getSamplerate(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_getProtectVoice(void* aObjHandle, uint aVoiceHandle);
	public int getProtectVoice(uint aVoiceHandle)
	{
		return Soloud_getProtectVoice(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getActiveVoiceCount(void* aObjHandle);
	public uint getActiveVoiceCount()
	{
		return Soloud_getActiveVoiceCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getVoiceCount(void* aObjHandle);
	public uint getVoiceCount()
	{
		return Soloud_getVoiceCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_isValidVoiceHandle(void* aObjHandle, uint aVoiceHandle);
	public int isValidVoiceHandle(uint aVoiceHandle)
	{
		return Soloud_isValidVoiceHandle(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getRelativePlaySpeed(void* aObjHandle, uint aVoiceHandle);
	public float getRelativePlaySpeed(uint aVoiceHandle)
	{
		return Soloud_getRelativePlaySpeed(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getPostClipScaler(void* aObjHandle);
	public float getPostClipScaler()
	{
		return Soloud_getPostClipScaler(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getGlobalVolume(void* aObjHandle);
	public float getGlobalVolume()
	{
		return Soloud_getGlobalVolume(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getMaxActiveVoiceCount(void* aObjHandle);
	public uint getMaxActiveVoiceCount()
	{
		return Soloud_getMaxActiveVoiceCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_getLooping(void* aObjHandle, uint aVoiceHandle);
	public int getLooping(uint aVoiceHandle)
	{
		return Soloud_getLooping(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Soloud_getLoopPoint(void* aObjHandle, uint aVoiceHandle);
	public double getLoopPoint(uint aVoiceHandle)
	{
		return Soloud_getLoopPoint(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setLoopPoint(void* aObjHandle, uint aVoiceHandle, double aLoopPoint);
	public void setLoopPoint(uint aVoiceHandle, double aLoopPoint)
	{
		Soloud_setLoopPoint(objhandle, aVoiceHandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setLooping(void* aObjHandle, uint aVoiceHandle, int aLooping);
	public void setLooping(uint aVoiceHandle, int aLooping)
	{
		Soloud_setLooping(objhandle, aVoiceHandle, aLooping);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_setMaxActiveVoiceCount(void* aObjHandle, uint aVoiceCount);
	public int setMaxActiveVoiceCount(uint aVoiceCount)
	{
		return Soloud_setMaxActiveVoiceCount(objhandle, aVoiceCount);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setInaudibleBehavior(void* aObjHandle, uint aVoiceHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(uint aVoiceHandle, int aMustTick, int aKill)
	{
		Soloud_setInaudibleBehavior(objhandle, aVoiceHandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setGlobalVolume(void* aObjHandle, float aVolume);
	public void setGlobalVolume(float aVolume)
	{
		Soloud_setGlobalVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setPostClipScaler(void* aObjHandle, float aScaler);
	public void setPostClipScaler(float aScaler)
	{
		Soloud_setPostClipScaler(objhandle, aScaler);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setPause(void* aObjHandle, uint aVoiceHandle, int aPause);
	public void setPause(uint aVoiceHandle, int aPause)
	{
		Soloud_setPause(objhandle, aVoiceHandle, aPause);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setPauseAll(void* aObjHandle, int aPause);
	public void setPauseAll(int aPause)
	{
		Soloud_setPauseAll(objhandle, aPause);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_setRelativePlaySpeed(void* aObjHandle, uint aVoiceHandle, float aSpeed);
	public int setRelativePlaySpeed(uint aVoiceHandle, float aSpeed)
	{
		return Soloud_setRelativePlaySpeed(objhandle, aVoiceHandle, aSpeed);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setProtectVoice(void* aObjHandle, uint aVoiceHandle, int aProtect);
	public void setProtectVoice(uint aVoiceHandle, int aProtect)
	{
		Soloud_setProtectVoice(objhandle, aVoiceHandle, aProtect);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setSamplerate(void* aObjHandle, uint aVoiceHandle, float aSamplerate);
	public void setSamplerate(uint aVoiceHandle, float aSamplerate)
	{
		Soloud_setSamplerate(objhandle, aVoiceHandle, aSamplerate);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setPan(void* aObjHandle, uint aVoiceHandle, float aPan);
	public void setPan(uint aVoiceHandle, float aPan)
	{
		Soloud_setPan(objhandle, aVoiceHandle, aPan);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setPanAbsoluteEx(void* aObjHandle, uint aVoiceHandle, float aLVolume, float aRVolume, float aLBVolume, float aRBVolume, float aCVolume, float aSVolume);
	public void setPanAbsolute(uint aVoiceHandle, float aLVolume, float aRVolume, float aLBVolume = 0, float aRBVolume = 0, float aCVolume = 0, float aSVolume = 0)
	{
		Soloud_setPanAbsoluteEx(objhandle, aVoiceHandle, aLVolume, aRVolume, aLBVolume, aRBVolume, aCVolume, aSVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setVolume(void* aObjHandle, uint aVoiceHandle, float aVolume);
	public void setVolume(uint aVoiceHandle, float aVolume)
	{
		Soloud_setVolume(objhandle, aVoiceHandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setDelaySamples(void* aObjHandle, uint aVoiceHandle, uint aSamples);
	public void setDelaySamples(uint aVoiceHandle, uint aSamples)
	{
		Soloud_setDelaySamples(objhandle, aVoiceHandle, aSamples);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_fadeVolume(void* aObjHandle, uint aVoiceHandle, float aTo, double aTime);
	public void fadeVolume(uint aVoiceHandle, float aTo, double aTime)
	{
		Soloud_fadeVolume(objhandle, aVoiceHandle, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_fadePan(void* aObjHandle, uint aVoiceHandle, float aTo, double aTime);
	public void fadePan(uint aVoiceHandle, float aTo, double aTime)
	{
		Soloud_fadePan(objhandle, aVoiceHandle, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_fadeRelativePlaySpeed(void* aObjHandle, uint aVoiceHandle, float aTo, double aTime);
	public void fadeRelativePlaySpeed(uint aVoiceHandle, float aTo, double aTime)
	{
		Soloud_fadeRelativePlaySpeed(objhandle, aVoiceHandle, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_fadeGlobalVolume(void* aObjHandle, float aTo, double aTime);
	public void fadeGlobalVolume(float aTo, double aTime)
	{
		Soloud_fadeGlobalVolume(objhandle, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_schedulePause(void* aObjHandle, uint aVoiceHandle, double aTime);
	public void schedulePause(uint aVoiceHandle, double aTime)
	{
		Soloud_schedulePause(objhandle, aVoiceHandle, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_scheduleStop(void* aObjHandle, uint aVoiceHandle, double aTime);
	public void scheduleStop(uint aVoiceHandle, double aTime)
	{
		Soloud_scheduleStop(objhandle, aVoiceHandle, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_oscillateVolume(void* aObjHandle, uint aVoiceHandle, float aFrom, float aTo, double aTime);
	public void oscillateVolume(uint aVoiceHandle, float aFrom, float aTo, double aTime)
	{
		Soloud_oscillateVolume(objhandle, aVoiceHandle, aFrom, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_oscillatePan(void* aObjHandle, uint aVoiceHandle, float aFrom, float aTo, double aTime);
	public void oscillatePan(uint aVoiceHandle, float aFrom, float aTo, double aTime)
	{
		Soloud_oscillatePan(objhandle, aVoiceHandle, aFrom, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_oscillateRelativePlaySpeed(void* aObjHandle, uint aVoiceHandle, float aFrom, float aTo, double aTime);
	public void oscillateRelativePlaySpeed(uint aVoiceHandle, float aFrom, float aTo, double aTime)
	{
		Soloud_oscillateRelativePlaySpeed(objhandle, aVoiceHandle, aFrom, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_oscillateGlobalVolume(void* aObjHandle, float aFrom, float aTo, double aTime);
	public void oscillateGlobalVolume(float aFrom, float aTo, double aTime)
	{
		Soloud_oscillateGlobalVolume(objhandle, aFrom, aTo, aTime);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setGlobalFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setGlobalFilter(uint aFilterId, SoloudObject aFilter)
	{
		Soloud_setGlobalFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_setVisualizationEnable(void* aObjHandle, int aEnable);
	public void setVisualizationEnable(int aEnable)
	{
		Soloud_setVisualizationEnable(objhandle, aEnable);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Soloud_calcFFT(void* aObjHandle);

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Soloud_getWave(void* aObjHandle);

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getApproximateVolume(void* aObjHandle, uint aChannel);
	public float getApproximateVolume(uint aChannel)
	{
		return Soloud_getApproximateVolume(objhandle, aChannel);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_getLoopCount(void* aObjHandle, uint aVoiceHandle);
	public uint getLoopCount(uint aVoiceHandle)
	{
		return Soloud_getLoopCount(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_getInfo(void* aObjHandle, uint aVoiceHandle, uint aInfoKey);
	public float getInfo(uint aVoiceHandle, uint aInfoKey)
	{
		return Soloud_getInfo(objhandle, aVoiceHandle, aInfoKey);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Soloud_createVoiceGroup(void* aObjHandle);
	public uint createVoiceGroup()
	{
		return Soloud_createVoiceGroup(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_destroyVoiceGroup(void* aObjHandle, uint aVoiceGroupHandle);
	public int destroyVoiceGroup(uint aVoiceGroupHandle)
	{
		return Soloud_destroyVoiceGroup(objhandle, aVoiceGroupHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_addVoiceToGroup(void* aObjHandle, uint aVoiceGroupHandle, uint aVoiceHandle);
	public int addVoiceToGroup(uint aVoiceGroupHandle, uint aVoiceHandle)
	{
		return Soloud_addVoiceToGroup(objhandle, aVoiceGroupHandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_isVoiceGroup(void* aObjHandle, uint aVoiceGroupHandle);
	public int isVoiceGroup(uint aVoiceGroupHandle)
	{
		return Soloud_isVoiceGroup(objhandle, aVoiceGroupHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_isVoiceGroupEmpty(void* aObjHandle, uint aVoiceGroupHandle);
	public int isVoiceGroupEmpty(uint aVoiceGroupHandle)
	{
		return Soloud_isVoiceGroupEmpty(objhandle, aVoiceGroupHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_update3dAudio(void* aObjHandle);
	public void update3dAudio()
	{
		Soloud_update3dAudio(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Soloud_set3dSoundSpeed(void* aObjHandle, float aSpeed);
	public int set3dSoundSpeed(float aSpeed)
	{
		return Soloud_set3dSoundSpeed(objhandle, aSpeed);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Soloud_get3dSoundSpeed(void* aObjHandle);
	public float get3dSoundSpeed()
	{
		return Soloud_get3dSoundSpeed(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dListenerParametersEx(void* aObjHandle, float aPosX, float aPosY, float aPosZ, float aAtX, float aAtY, float aAtZ, float aUpX, float aUpY, float aUpZ, float aVelocityX, float aVelocityY, float aVelocityZ);
	public void set3dListenerParameters(float aPosX, float aPosY, float aPosZ, float aAtX, float aAtY, float aAtZ, float aUpX, float aUpY, float aUpZ, float aVelocityX = 0.0f, float aVelocityY = 0.0f, float aVelocityZ = 0.0f)
	{
		Soloud_set3dListenerParametersEx(objhandle, aPosX, aPosY, aPosZ, aAtX, aAtY, aAtZ, aUpX, aUpY, aUpZ, aVelocityX, aVelocityY, aVelocityZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dListenerPosition(void* aObjHandle, float aPosX, float aPosY, float aPosZ);
	public void set3dListenerPosition(float aPosX, float aPosY, float aPosZ)
	{
		Soloud_set3dListenerPosition(objhandle, aPosX, aPosY, aPosZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dListenerAt(void* aObjHandle, float aAtX, float aAtY, float aAtZ);
	public void set3dListenerAt(float aAtX, float aAtY, float aAtZ)
	{
		Soloud_set3dListenerAt(objhandle, aAtX, aAtY, aAtZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dListenerUp(void* aObjHandle, float aUpX, float aUpY, float aUpZ);
	public void set3dListenerUp(float aUpX, float aUpY, float aUpZ)
	{
		Soloud_set3dListenerUp(objhandle, aUpX, aUpY, aUpZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dListenerVelocity(void* aObjHandle, float aVelocityX, float aVelocityY, float aVelocityZ);
	public void set3dListenerVelocity(float aVelocityX, float aVelocityY, float aVelocityZ)
	{
		Soloud_set3dListenerVelocity(objhandle, aVelocityX, aVelocityY, aVelocityZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dSourceParametersEx(void* aObjHandle, uint aVoiceHandle, float aPosX, float aPosY, float aPosZ, float aVelocityX, float aVelocityY, float aVelocityZ);
	public void set3dSourceParameters(uint aVoiceHandle, float aPosX, float aPosY, float aPosZ, float aVelocityX = 0.0f, float aVelocityY = 0.0f, float aVelocityZ = 0.0f)
	{
		Soloud_set3dSourceParametersEx(objhandle, aVoiceHandle, aPosX, aPosY, aPosZ, aVelocityX, aVelocityY, aVelocityZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dSourcePosition(void* aObjHandle, uint aVoiceHandle, float aPosX, float aPosY, float aPosZ);
	public void set3dSourcePosition(uint aVoiceHandle, float aPosX, float aPosY, float aPosZ)
	{
		Soloud_set3dSourcePosition(objhandle, aVoiceHandle, aPosX, aPosY, aPosZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dSourceVelocity(void* aObjHandle, uint aVoiceHandle, float aVelocityX, float aVelocityY, float aVelocityZ);
	public void set3dSourceVelocity(uint aVoiceHandle, float aVelocityX, float aVelocityY, float aVelocityZ)
	{
		Soloud_set3dSourceVelocity(objhandle, aVoiceHandle, aVelocityX, aVelocityY, aVelocityZ);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dSourceMinMaxDistance(void* aObjHandle, uint aVoiceHandle, float aMinDistance, float aMaxDistance);
	public void set3dSourceMinMaxDistance(uint aVoiceHandle, float aMinDistance, float aMaxDistance)
	{
		Soloud_set3dSourceMinMaxDistance(objhandle, aVoiceHandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dSourceAttenuation(void* aObjHandle, uint aVoiceHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dSourceAttenuation(uint aVoiceHandle, uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Soloud_set3dSourceAttenuation(objhandle, aVoiceHandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_set3dSourceDopplerFactor(void* aObjHandle, uint aVoiceHandle, float aDopplerFactor);
	public void set3dSourceDopplerFactor(uint aVoiceHandle, float aDopplerFactor)
	{
		Soloud_set3dSourceDopplerFactor(objhandle, aVoiceHandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_mix(void* aObjHandle, float[] aBuffer, uint aSamples);
	public void mix(float[] aBuffer, uint aSamples)
	{
		Soloud_mix(objhandle, aBuffer, aSamples);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Soloud_mixSigned16(void* aObjHandle, void* aBuffer, uint aSamples);
	public void mixSigned16(void* aBuffer, uint aSamples)
	{
		Soloud_mixSigned16(objhandle, aBuffer, aSamples);
	}
}

public class BassboostFilter : SoloudObject
{
	public const int WET = 0;
	public const int BOOST = 1;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* BassboostFilter_create();
	public this()
	{
		objhandle = BassboostFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* BassboostFilter_destroy(void* aObjHandle);
	~this()
	{
		BassboostFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int BassboostFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return BassboostFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* BassboostFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = BassboostFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint BassboostFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return BassboostFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float BassboostFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return BassboostFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float BassboostFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return BassboostFilter_getParamMin(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int BassboostFilter_setParams(void* aObjHandle, float aBoost);
	public int setParams(float aBoost)
	{
		return BassboostFilter_setParams(objhandle, aBoost);
	}
}

public class BiquadResonantFilter : SoloudObject
{
	public const int LOWPASS = 0;
	public const int HIGHPASS = 1;
	public const int BANDPASS = 2;
	public const int WET = 0;
	public const int TYPE = 1;
	public const int FREQUENCY = 2;
	public const int RESONANCE = 3;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* BiquadResonantFilter_create();
	public this()
	{
		objhandle = BiquadResonantFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* BiquadResonantFilter_destroy(void* aObjHandle);
	public ~this()
	{
		BiquadResonantFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int BiquadResonantFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return BiquadResonantFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* BiquadResonantFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = BiquadResonantFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint BiquadResonantFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return BiquadResonantFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float BiquadResonantFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return BiquadResonantFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float BiquadResonantFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return BiquadResonantFilter_getParamMin(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int BiquadResonantFilter_setParams(void* aObjHandle, int aType, float aFrequency, float aResonance);
	public int setParams(int aType, float aFrequency, float aResonance)
	{
		return BiquadResonantFilter_setParams(objhandle, aType, aFrequency, aResonance);
	}
}

public class Bus : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Bus_create();
	public this()
	{
		objhandle = Bus_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Bus_destroy(void* aObjHandle);
	public ~this()
	{
		Bus_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Bus_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Bus_playEx(void* aObjHandle, void* aSound, float aVolume, float aPan, int aPaused);
	public uint play(SoloudObject aSound, float aVolume = 1.0f, float aPan = 0.0f, int aPaused = 0)
	{
		return Bus_playEx(objhandle, aSound.objhandle, aVolume, aPan, aPaused);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Bus_playClockedEx(void* aObjHandle, double aSoundTime, void* aSound, float aVolume, float aPan);
	public uint playClocked(double aSoundTime, SoloudObject aSound, float aVolume = 1.0f, float aPan = 0.0f)
	{
		return Bus_playClockedEx(objhandle, aSoundTime, aSound.objhandle, aVolume, aPan);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Bus_play3dEx(void* aObjHandle, void* aSound, float aPosX, float aPosY, float aPosZ, float aVelX, float aVelY, float aVelZ, float aVolume, int aPaused);
	public uint play3d(SoloudObject aSound, float aPosX, float aPosY, float aPosZ, float aVelX = 0.0f, float aVelY = 0.0f, float aVelZ = 0.0f, float aVolume = 1.0f, int aPaused = 0)
	{
		return Bus_play3dEx(objhandle, aSound.objhandle, aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aPaused);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Bus_play3dClockedEx(void* aObjHandle, double aSoundTime, void* aSound, float aPosX, float aPosY, float aPosZ, float aVelX, float aVelY, float aVelZ, float aVolume);
	public uint play3dClocked(double aSoundTime, SoloudObject aSound, float aPosX, float aPosY, float aPosZ, float aVelX = 0.0f, float aVelY = 0.0f, float aVelZ = 0.0f, float aVolume = 1.0f)
	{
		return Bus_play3dClockedEx(objhandle, aSoundTime, aSound.objhandle, aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Bus_setChannels(void* aObjHandle, uint aChannels);
	public int setChannels(uint aChannels)
	{
		return Bus_setChannels(objhandle, aChannels);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_setVisualizationEnable(void* aObjHandle, int aEnable);
	public void setVisualizationEnable(int aEnable)
	{
		Bus_setVisualizationEnable(objhandle, aEnable);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_annexSound(void* aObjHandle, uint aVoiceHandle);
	public void annexSound(uint aVoiceHandle)
	{
		Bus_annexSound(objhandle, aVoiceHandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Bus_calcFFT(void* aObjHandle);

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Bus_getWave(void* aObjHandle);

	[Import("soloud_x64.dll"), CLink]
	internal static extern float Bus_getApproximateVolume(void* aObjHandle, uint aChannel);
	public float getApproximateVolume(uint aChannel)
	{
		return Bus_getApproximateVolume(objhandle, aChannel);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Bus_getActiveVoiceCount(void* aObjHandle);
	public uint getActiveVoiceCount()
	{
		return Bus_getActiveVoiceCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Bus_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Bus_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Bus_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Bus_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Bus_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Bus_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Bus_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Bus_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Bus_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Bus_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Bus_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Bus_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Bus_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Bus_stop(void* aObjHandle);
	public void stop()
	{
		Bus_stop(objhandle);
	}
}

public class DCRemovalFilter : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* DCRemovalFilter_create();
	public this()
	{
		objhandle = DCRemovalFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* DCRemovalFilter_destroy(void* aObjHandle);
	public ~this()
	{
		DCRemovalFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int DCRemovalFilter_setParamsEx(void* aObjHandle, float aLength);
	public int setParams(float aLength = 0.1f)
	{
		return DCRemovalFilter_setParamsEx(objhandle, aLength);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int DCRemovalFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return DCRemovalFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* DCRemovalFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = DCRemovalFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint DCRemovalFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return DCRemovalFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float DCRemovalFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return DCRemovalFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float DCRemovalFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return DCRemovalFilter_getParamMin(objhandle, aParamIndex);
	}
}

public class EchoFilter : SoloudObject
{
	public const int WET = 0;
	public const int DELAY = 1;
	public const int DECAY = 2;
	public const int FILTER = 3;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* EchoFilter_create();
	public this()
	{
		objhandle = EchoFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* EchoFilter_destroy(void* aObjHandle);
	public ~this()
	{
		EchoFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int EchoFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return EchoFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* EchoFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = EchoFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint EchoFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return EchoFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float EchoFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return EchoFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float EchoFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return EchoFilter_getParamMin(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int EchoFilter_setParamsEx(void* aObjHandle, float aDelay, float aDecay, float aFilter);
	public int setParams(float aDelay, float aDecay = 0.7f, float aFilter = 0.0f)
	{
		return EchoFilter_setParamsEx(objhandle, aDelay, aDecay, aFilter);
	}
}

public class FFTFilter : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FFTFilter_create();
	public this()
	{
		objhandle = FFTFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FFTFilter_destroy(void* aObjHandle);
	public ~this()
	{
		FFTFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int FFTFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return FFTFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FFTFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = FFTFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint FFTFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return FFTFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float FFTFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return FFTFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float FFTFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return FFTFilter_getParamMin(objhandle, aParamIndex);
	}
}

public class FlangerFilter : SoloudObject
{
	public const int WET = 0;
	public const int DELAY = 1;
	public const int FREQ = 2;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FlangerFilter_create();
	public this()
	{
		objhandle = FlangerFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FlangerFilter_destroy(void* aObjHandle);
	public ~this()
	{
		FlangerFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int FlangerFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return FlangerFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FlangerFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = FlangerFilter_getParamName(objhandle, aParamIndex);

		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint FlangerFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return FlangerFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float FlangerFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return FlangerFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float FlangerFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return FlangerFilter_getParamMin(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int FlangerFilter_setParams(void* aObjHandle, float aDelay, float aFreq);
	public int setParams(float aDelay, float aFreq)
	{
		return FlangerFilter_setParams(objhandle, aDelay, aFreq);
	}
}

public class FreeverbFilter : SoloudObject
{
	public const int WET = 0;
	public const int FREEZE = 1;
	public const int ROOMSIZE = 2;
	public const int DAMP = 3;
	public const int WIDTH = 4;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FreeverbFilter_create();
	public this()
	{
		objhandle = FreeverbFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FreeverbFilter_destroy(void* aObjHandle);
	public ~this()
	{
		FreeverbFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int FreeverbFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return FreeverbFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* FreeverbFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = FreeverbFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint FreeverbFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return FreeverbFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float FreeverbFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return FreeverbFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float FreeverbFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return FreeverbFilter_getParamMin(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int FreeverbFilter_setParams(void* aObjHandle, float aMode, float aRoomSize, float aDamp, float aWidth);
	public int setParams(float aMode, float aRoomSize, float aDamp, float aWidth)
	{
		return FreeverbFilter_setParams(objhandle, aMode, aRoomSize, aDamp, aWidth);
	}
}

public class LofiFilter : SoloudObject
{
	public const int WET = 0;
	public const int SAMPLERATE = 1;
	public const int BITDEPTH = 2;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* LofiFilter_create();
	public this()
	{
		objhandle = LofiFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* LofiFilter_destroy(void* aObjHandle);
	public ~this()
	{
		LofiFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int LofiFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return LofiFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* LofiFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = LofiFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint LofiFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return LofiFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float LofiFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return LofiFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float LofiFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return LofiFilter_getParamMin(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int LofiFilter_setParams(void* aObjHandle, float aSampleRate, float aBitdepth);
	public int setParams(float aSampleRate, float aBitdepth)
	{
		return LofiFilter_setParams(objhandle, aSampleRate, aBitdepth);
	}
}

public class Monotone : SoloudObject
{
	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Monotone_create();
	public this()
	{
		objhandle = Monotone_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Monotone_destroy(void* aObjHandle);
	public ~this()
	{
		Monotone_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Monotone_setParamsEx(void* aObjHandle, int aHardwareChannels, int aWaveform);
	public int setParams(int aHardwareChannels, int aWaveform)
	{
		return Monotone_setParamsEx(objhandle, aHardwareChannels, aWaveform);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Monotone_load(void* aObjHandle, c_char* aFilename);
	public int load(StringView aFilename)
	{
		return Monotone_load(objhandle, aFilename.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Monotone_loadMemEx(void* aObjHandle, void* aMem, uint aLength, int aCopy, int aTakeOwnership);
	public int loadMem(void* aMem, uint aLength, int aCopy= C_FALSE, int aTakeOwnership= C_TRUE)
	{
		return Monotone_loadMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Monotone_loadFile(void* aObjHandle, void* aFile);
	public int loadFile(SoloudObject aFile)
	{
		return Monotone_loadFile(objhandle, aFile.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Monotone_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Monotone_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Monotone_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Monotone_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Monotone_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Monotone_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Monotone_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Monotone_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Monotone_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Monotone_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Monotone_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Monotone_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Monotone_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Monotone_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Monotone_stop(void* aObjHandle);
	public void stop()
	{
		Monotone_stop(objhandle);
	}
}

public class Noise : SoloudObject
{
	public const int WHITE = 0;
	public const int PINK = 1;
	public const int BROWNISH = 2;
	public const int BLUEISH = 3;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Noise_create();
	public this()
	{
		objhandle = Noise_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Noise_destroy(void* aObjHandle);
	public ~this()
	{
		Noise_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_setOctaveScale(void* aObjHandle, float aOct0, float aOct1, float aOct2, float aOct3, float aOct4, float aOct5, float aOct6, float aOct7, float aOct8, float aOct9);
	public void setOctaveScale(float aOct0, float aOct1, float aOct2, float aOct3, float aOct4, float aOct5, float aOct6, float aOct7, float aOct8, float aOct9)
	{
		Noise_setOctaveScale(objhandle, aOct0, aOct1, aOct2, aOct3, aOct4, aOct5, aOct6, aOct7, aOct8, aOct9);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_setType(void* aObjHandle, int aType);
	public void setType(int aType)
	{
		Noise_setType(objhandle, aType);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Noise_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Noise_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Noise_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Noise_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Noise_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Noise_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Noise_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Noise_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Noise_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Noise_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Noise_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Noise_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Noise_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Noise_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Noise_stop(void* aObjHandle);
	public void stop()
	{
		Noise_stop(objhandle);
	}
}

public class Openmpt : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Openmpt_create();
	public this()
	{
		objhandle = Openmpt_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Openmpt_destroy(void* aObjHandle);
	public ~this()
	{
		Openmpt_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Openmpt_load(void* aObjHandle, c_char* aFilename);
	public int load(StringView aFilename)
	{
		return Openmpt_load(objhandle, aFilename.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Openmpt_loadMemEx(void* aObjHandle, void* aMem, uint aLength, int aCopy, int aTakeOwnership);
	public int loadMem(void* aMem, uint aLength, int aCopy= C_FALSE, int aTakeOwnership= C_TRUE)
	{
		return Openmpt_loadMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Openmpt_loadFile(void* aObjHandle, void* aFile);
	public int loadFile(SoloudObject aFile)
	{
		return Openmpt_loadFile(objhandle, aFile.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Openmpt_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Openmpt_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Openmpt_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Openmpt_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Openmpt_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Openmpt_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Openmpt_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Openmpt_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Openmpt_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Openmpt_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Openmpt_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Openmpt_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Openmpt_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Openmpt_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Openmpt_stop(void* aObjHandle);
	public void stop()
	{
		Openmpt_stop(objhandle);
	}
}

public class Queue : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Queue_create();
	public this()
	{
		objhandle = Queue_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Queue_destroy(void* aObjHandle);
	public ~this()
	{
		Queue_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Queue_play(void* aObjHandle, void* aSound);
	public int play(SoloudObject aSound)
	{
		return Queue_play(objhandle, aSound.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint Queue_getQueueCount(void* aObjHandle);
	public uint getQueueCount()
	{
		return Queue_getQueueCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Queue_isCurrentlyPlaying(void* aObjHandle, void* aSound);
	public int isCurrentlyPlaying(SoloudObject aSound)
	{
		return Queue_isCurrentlyPlaying(objhandle, aSound.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Queue_setParamsFromAudioSource(void* aObjHandle, void* aSound);
	public int setParamsFromAudioSource(SoloudObject aSound)
	{
		return Queue_setParamsFromAudioSource(objhandle, aSound.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Queue_setParamsEx(void* aObjHandle, float aSamplerate, uint aChannels);
	public int setParams(float aSamplerate, uint aChannels = 2)
	{
		return Queue_setParamsEx(objhandle, aSamplerate, aChannels);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Queue_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Queue_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Queue_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Queue_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Queue_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Queue_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Queue_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Queue_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Queue_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Queue_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Queue_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Queue_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Queue_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Queue_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Queue_stop(void* aObjHandle);
	public void stop()
	{
		Queue_stop(objhandle);
	}
}

public class RobotizeFilter : SoloudObject
{
	public const int WET = 0;
	public const int FREQ = 1;
	public const int WAVE = 2;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* RobotizeFilter_create();
	public this()
	{
		objhandle = RobotizeFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* RobotizeFilter_destroy(void* aObjHandle);
	public ~this()
	{
		RobotizeFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int RobotizeFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return RobotizeFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* RobotizeFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = RobotizeFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint RobotizeFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return RobotizeFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float RobotizeFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return RobotizeFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float RobotizeFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return RobotizeFilter_getParamMin(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void RobotizeFilter_setParams(void* aObjHandle, float aFreq, int aWaveform);
	public void setParams(float aFreq, int aWaveform)
	{
		RobotizeFilter_setParams(objhandle, aFreq, aWaveform);
	}
}

public class Sfxr : SoloudObject
{
	public const int COIN = 0;
	public const int LASER = 1;
	public const int EXPLOSION = 2;
	public const int POWERUP = 3;
	public const int HURT = 4;
	public const int JUMP = 5;
	public const int BLIP = 6;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Sfxr_create();
	public this()
	{
		objhandle = Sfxr_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Sfxr_destroy(void* aObjHandle);
	public ~this()
	{
		Sfxr_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_resetParams(void* aObjHandle);
	public void resetParams()
	{
		Sfxr_resetParams(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Sfxr_loadParams(void* aObjHandle, c_char* aFilename);
	public int loadParams(StringView aFilename)
	{
		return Sfxr_loadParams(objhandle, aFilename.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Sfxr_loadParamsMemEx(void* aObjHandle, void* aMem, uint aLength, int aCopy, int aTakeOwnership);
	public int loadParamsMem(void* aMem, uint aLength, bool aCopy= false, bool aTakeOwnership= true)
	{
		return Sfxr_loadParamsMemEx(objhandle, aMem, aLength, aCopy ? C_TRUE : C_FALSE, aTakeOwnership ? C_TRUE : C_FALSE);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Sfxr_loadParamsFile(void* aObjHandle, void* aFile);
	public int loadParamsFile(SoloudObject aFile)
	{
		return Sfxr_loadParamsFile(objhandle, aFile.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Sfxr_loadPreset(void* aObjHandle, int aPresetNo, int aRandSeed);
	public int loadPreset(int aPresetNo, int aRandSeed)
	{
		return Sfxr_loadPreset(objhandle, aPresetNo, aRandSeed);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Sfxr_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Sfxr_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Sfxr_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Sfxr_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Sfxr_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Sfxr_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Sfxr_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Sfxr_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Sfxr_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Sfxr_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Sfxr_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Sfxr_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Sfxr_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Sfxr_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Sfxr_stop(void* aObjHandle);
	public void stop()
	{
		Sfxr_stop(objhandle);
	}
}

public class Speech : SoloudObject
{
	public const int KW_SAW = 0;
	public const int KW_TRIANGLE = 1;
	public const int KW_SIN = 2;
	public const int KW_SQUARE = 3;
	public const int KW_PULSE = 4;
	public const int KW_NOISE = 5;
	public const int KW_WARBLE = 6;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Speech_create();
	public this()
	{
		objhandle = Speech_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Speech_destroy(void* aObjHandle);
	public ~this()
	{
		Speech_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Speech_setText(void* aObjHandle, c_char* aText);
	public int setText(StringView aText)
	{
		return Speech_setText(objhandle, aText.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Speech_setParamsEx(void* aObjHandle, uint aBaseFrequency, float aBaseSpeed, float aBaseDeclination, int aBaseWaveform);
	public int setParams(uint aBaseFrequency = 1330, float aBaseSpeed = 10.0f, float aBaseDeclination = 0.5f, int aBaseWaveform = KW_TRIANGLE)
	{
		return Speech_setParamsEx(objhandle, aBaseFrequency, aBaseSpeed, aBaseDeclination, aBaseWaveform);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Speech_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Speech_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Speech_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Speech_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Speech_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Speech_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Speech_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Speech_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Speech_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Speech_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Speech_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Speech_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Speech_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Speech_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Speech_stop(void* aObjHandle);
	public void stop()
	{
		Speech_stop(objhandle);
	}
}

public class TedSid : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* TedSid_create();
	public this()
	{
		objhandle = TedSid_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* TedSid_destroy(void* aObjHandle);
	public ~this()
	{
		TedSid_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int TedSid_load(void* aObjHandle, c_char* aFilename);
	public int load(StringView aFilename)
	{
		return TedSid_load(objhandle, aFilename.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int TedSid_loadToMem(void* aObjHandle, c_char* aFilename);
	public int loadToMem(StringView aFilename)
	{
		return TedSid_loadToMem(objhandle, aFilename.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int TedSid_loadMemEx(void* aObjHandle, void* aMem, uint aLength, int aCopy, int aTakeOwnership);
	public int loadMem(void* aMem, uint aLength, int aCopy= C_FALSE, int aTakeOwnership= C_TRUE)
	{
		return TedSid_loadMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int TedSid_loadFileToMem(void* aObjHandle, void* aFile);
	public int loadFileToMem(SoloudObject aFile)
	{
		return TedSid_loadFileToMem(objhandle, aFile.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int TedSid_loadFile(void* aObjHandle, void* aFile);
	public int loadFile(SoloudObject aFile)
	{
		return TedSid_loadFile(objhandle, aFile.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		TedSid_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		TedSid_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		TedSid_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		TedSid_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		TedSid_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		TedSid_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		TedSid_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		TedSid_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		TedSid_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		TedSid_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		TedSid_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double TedSid_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return TedSid_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		TedSid_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void TedSid_stop(void* aObjHandle);
	public void stop()
	{
		TedSid_stop(objhandle);
	}
}

public class Vic : SoloudObject
{
	public const int PAL = 0;
	public const int NTSC = 1;
	public const int BASS = 0;
	public const int ALTO = 1;
	public const int SOPRANO = 2;
	public const int NOISE = 3;
	public const int MAX_REGS = 4;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Vic_create();
	public this()
	{
		objhandle = Vic_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Vic_destroy(void* aObjHandle);
	public ~this()
	{
		Vic_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_setModel(void* aObjHandle, int model);
	public void setModel(int model)
	{
		Vic_setModel(objhandle, model);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Vic_getModel(void* aObjHandle);
	public int getModel()
	{
		return Vic_getModel(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_setRegister(void* aObjHandle, int reg, c_uchar value);
	public void setRegister(int reg, uint8 value)
	{
		Vic_setRegister(objhandle, reg, value);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern c_uchar Vic_getRegister(void* aObjHandle, int reg);
	public c_uchar getRegister(int reg)
	{
		return Vic_getRegister(objhandle, reg);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Vic_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Vic_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Vic_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Vic_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Vic_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Vic_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Vic_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Vic_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Vic_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Vic_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Vic_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Vic_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Vic_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Vic_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vic_stop(void* aObjHandle);
	public void stop()
	{
		Vic_stop(objhandle);
	}
}

public class Vizsn : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Vizsn_create();
	public this()
	{
		objhandle = Vizsn_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Vizsn_destroy(void* aObjHandle);
	public ~this()
	{
		Vizsn_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_setText(void* aObjHandle, c_char* aText);
	public void setText(StringView aText)
	{
		Vizsn_setText(objhandle, aText.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Vizsn_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Vizsn_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Vizsn_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Vizsn_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Vizsn_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Vizsn_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Vizsn_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Vizsn_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Vizsn_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Vizsn_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Vizsn_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Vizsn_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Vizsn_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Vizsn_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Vizsn_stop(void* aObjHandle);
	public void stop()
	{
		Vizsn_stop(objhandle);
	}
}

public class Wav : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Wav_create();
	public this()
	{
		objhandle = Wav_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* Wav_destroy(void* aObjHandle);
	public ~this()
	{
		Wav_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Wav_load(void* aObjHandle, c_char* aFilename);
	public int load(StringView aFilename)
	{
		return Wav_load(objhandle, aFilename.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Wav_loadMemEx(void* aObjHandle, void* aMem, uint aLength, int aCopy, int aTakeOwnership);
	public int loadMem(void* aMem, uint aLength, int aCopy= C_FALSE, int aTakeOwnership= C_TRUE)
	{
		return Wav_loadMemEx(objhandle, aMem, aLength, aCopy, aTakeOwnership);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Wav_loadFile(void* aObjHandle, void* aFile);
	public int loadFile(SoloudObject aFile)
	{
		return Wav_loadFile(objhandle, aFile.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Wav_loadRawWave8Ex(void* aObjHandle, void* aMem, uint aLength, float aSamplerate, uint aChannels);
	public int loadRawWave8(void* aMem, uint aLength, float aSamplerate = 44100.0f, uint aChannels = 1)
	{
		return Wav_loadRawWave8Ex(objhandle, aMem, aLength, aSamplerate, aChannels);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Wav_loadRawWave16Ex(void* aObjHandle, void* aMem, uint aLength, float aSamplerate, uint aChannels);
	public int loadRawWave16(void* aMem, uint aLength, float aSamplerate = 44100.0f, uint aChannels = 1)
	{
		return Wav_loadRawWave16Ex(objhandle, aMem, aLength, aSamplerate, aChannels);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int Wav_loadRawWaveEx(void* aObjHandle, float[] aMem, uint aLength, float aSamplerate, uint aChannels, int aCopy, int aTakeOwnership);
	public int loadRawWave(float[] aMem, uint aLength, float aSamplerate = 44100.0f, uint aChannels = 1, int aCopy= C_FALSE, int aTakeOwnership= C_TRUE)
	{
		return Wav_loadRawWaveEx(objhandle, aMem, aLength, aSamplerate, aChannels, aCopy, aTakeOwnership);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Wav_getLength(void* aObjHandle);
	public double getLength()
	{
		return Wav_getLength(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		Wav_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		Wav_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		Wav_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		Wav_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		Wav_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		Wav_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		Wav_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		Wav_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		Wav_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		Wav_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		Wav_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double Wav_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return Wav_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		Wav_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void Wav_stop(void* aObjHandle);
	public void stop()
	{
		Wav_stop(objhandle);
	}
}

public class WaveShaperFilter : SoloudObject
{
	public const int WET = 0;
	public const int AMOUNT = 1;

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* WaveShaperFilter_create();
	public this()
	{
		objhandle = WaveShaperFilter_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* WaveShaperFilter_destroy(void* aObjHandle);
	public ~this()
	{
		WaveShaperFilter_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int WaveShaperFilter_setParams(void* aObjHandle, float aAmount);
	public int setParams(float aAmount)
	{
		return WaveShaperFilter_setParams(objhandle, aAmount);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int WaveShaperFilter_getParamCount(void* aObjHandle);
	public int getParamCount()
	{
		return WaveShaperFilter_getParamCount(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* WaveShaperFilter_getParamName(void* aObjHandle, uint aParamIndex);
	public StringView getParamName(uint aParamIndex)
	{
		void* p = WaveShaperFilter_getParamName(objhandle, aParamIndex);
		return StringView((c_char*)p);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern uint WaveShaperFilter_getParamType(void* aObjHandle, uint aParamIndex);
	public uint getParamType(uint aParamIndex)
	{
		return WaveShaperFilter_getParamType(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float WaveShaperFilter_getParamMax(void* aObjHandle, uint aParamIndex);
	public float getParamMax(uint aParamIndex)
	{
		return WaveShaperFilter_getParamMax(objhandle, aParamIndex);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern float WaveShaperFilter_getParamMin(void* aObjHandle, uint aParamIndex);
	public float getParamMin(uint aParamIndex)
	{
		return WaveShaperFilter_getParamMin(objhandle, aParamIndex);
	}
}

public class WavStream : SoloudObject
{

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* WavStream_create();
	public this()
	{
		objhandle = WavStream_create();
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void* WavStream_destroy(void* aObjHandle);
	public ~this()
	{
		WavStream_destroy(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int WavStream_load(void* aObjHandle, c_char* aFilename);
	public int load(StringView aFilename)
	{
		return WavStream_load(objhandle, aFilename.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int WavStream_loadMemEx(void* aObjHandle, void* aData, uint aDataLen, int aCopy, int aTakeOwnership);
	public int loadMem(void* aData, uint aDataLen, bool aCopy= false, bool aTakeOwnership= true)
	{
		return WavStream_loadMemEx(objhandle, aData, aDataLen, aCopy ? C_TRUE : C_FALSE, aTakeOwnership ? C_TRUE : C_FALSE);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int WavStream_loadToMem(void* aObjHandle, c_char* aFilename);
	public int loadToMem(StringView aFilename)
	{
		return WavStream_loadToMem(objhandle, aFilename.ToScopeCStr!());
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int WavStream_loadFile(void* aObjHandle, void* aFile);
	public int loadFile(SoloudObject aFile)
	{
		return WavStream_loadFile(objhandle, aFile.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern int WavStream_loadFileToMem(void* aObjHandle, void* aFile);
	public int loadFileToMem(SoloudObject aFile)
	{
		return WavStream_loadFileToMem(objhandle, aFile.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double WavStream_getLength(void* aObjHandle);
	public double getLength()
	{
		return WavStream_getLength(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_setVolume(void* aObjHandle, float aVolume);
	public void setVolume(float aVolume)
	{
		WavStream_setVolume(objhandle, aVolume);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_setLooping(void* aObjHandle, int aLoop);
	public void setLooping(int aLoop)
	{
		WavStream_setLooping(objhandle, aLoop);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_set3dMinMaxDistance(void* aObjHandle, float aMinDistance, float aMaxDistance);
	public void set3dMinMaxDistance(float aMinDistance, float aMaxDistance)
	{
		WavStream_set3dMinMaxDistance(objhandle, aMinDistance, aMaxDistance);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_set3dAttenuation(void* aObjHandle, uint aAttenuationModel, float aAttenuationRolloffFactor);
	public void set3dAttenuation(uint aAttenuationModel, float aAttenuationRolloffFactor)
	{
		WavStream_set3dAttenuation(objhandle, aAttenuationModel, aAttenuationRolloffFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_set3dDopplerFactor(void* aObjHandle, float aDopplerFactor);
	public void set3dDopplerFactor(float aDopplerFactor)
	{
		WavStream_set3dDopplerFactor(objhandle, aDopplerFactor);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_set3dListenerRelative(void* aObjHandle, int aListenerRelative);
	public void set3dListenerRelative(int aListenerRelative)
	{
		WavStream_set3dListenerRelative(objhandle, aListenerRelative);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_set3dDistanceDelay(void* aObjHandle, int aDistanceDelay);
	public void set3dDistanceDelay(int aDistanceDelay)
	{
		WavStream_set3dDistanceDelay(objhandle, aDistanceDelay);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_set3dColliderEx(void* aObjHandle, void* aCollider, int aUserData);
	public void set3dCollider(SoloudObject aCollider, int aUserData = 0)
	{
		WavStream_set3dColliderEx(objhandle, aCollider.objhandle, aUserData);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_set3dAttenuator(void* aObjHandle, void* aAttenuator);
	public void set3dAttenuator(SoloudObject aAttenuator)
	{
		WavStream_set3dAttenuator(objhandle, aAttenuator.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_setInaudibleBehavior(void* aObjHandle, int aMustTick, int aKill);
	public void setInaudibleBehavior(int aMustTick, int aKill)
	{
		WavStream_setInaudibleBehavior(objhandle, aMustTick, aKill);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_setLoopPoint(void* aObjHandle, double aLoopPoint);
	public void setLoopPoint(double aLoopPoint)
	{
		WavStream_setLoopPoint(objhandle, aLoopPoint);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern double WavStream_getLoopPoint(void* aObjHandle);
	public double getLoopPoint()
	{
		return WavStream_getLoopPoint(objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_setFilter(void* aObjHandle, uint aFilterId, void* aFilter);
	public void setFilter(uint aFilterId, SoloudObject aFilter)
	{
		WavStream_setFilter(objhandle, aFilterId, aFilter.objhandle);
	}

	[Import("soloud_x64.dll"), CLink]
	internal static extern void WavStream_stop(void* aObjHandle);
	public void stop()
	{
		WavStream_stop(objhandle);
	}
}
}
