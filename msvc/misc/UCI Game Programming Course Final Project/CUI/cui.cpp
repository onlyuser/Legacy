#include "cui.h"

#define MOD_TEST

string mPathA;
string mPathB;

void playMusic(FMUSIC_MODULE *handle, bool loop)
{
	FMUSIC_PlaySong(handle);
	FMUSIC_SetMasterVolume(handle, DEF_VOLUME);
	FMUSIC_SetLooping(handle, loop);
}

long playSound(FSOUND_SAMPLE *handle, bool loop)
{
	long result;

	result = FSOUND_PlaySound(FSOUND_FREE, handle);
	FSOUND_SetVolume(result, DEF_VOLUME);
	if (loop)
		FSOUND_SetLoopMode(result, FSOUND_LOOP_NORMAL);
	else
		FSOUND_SetLoopMode(result, FSOUND_LOOP_OFF);
	return result;
}

void timer()
{
	#ifdef MOD_TEST
		test_timer();
	#else
		benc_timer();
		robk_timer();
		vinh_timer();
		game_timer();
	#endif
}

void display()
{
	#ifdef MOD_TEST
		test_display();
	#else
		benc_display();
		robk_display();
		vinh_display();
		game_display();
	#endif
}

void keyDown(BYTE key)
{
	#ifdef MOD_TEST
		test_keyDown(key);
	#else
		benc_keyDown(key);
		robk_keyDown(key);
		vinh_keyDown(key);
		game_keyDown(key);
	#endif
}

void keyUp(BYTE key)
{
	#ifdef MOD_TEST
		test_keyUp(key);
	#else
		benc_keyUp(key);
		robk_keyUp(key);
		vinh_keyUp(key);
		game_keyUp(key);
	#endif
}

void mouseDown(long button, long x, long y)
{
	#ifdef MOD_TEST
		test_mouseDown(button, x, y);
	#else
		benc_mouseDown(button, x, y);
		robk_mouseDown(button, x, y);
		vinh_mouseDown(button, x, y);
		game_mouseDown(button, x, y);
	#endif
}

void mouseMove(long button, long x, long y)
{
	#ifdef MOD_TEST
		test_mouseMove(button, x, y);
	#else
		benc_mouseMove(button, x, y);
		robk_mouseMove(button, x, y);
		vinh_mouseMove(button, x, y);
		game_mouseMove(button, x, y);
	#endif
}

void mouseUp(long button, long x, long y)
{
	#ifdef MOD_TEST
		test_mouseUp(button, x, y);
	#else
		benc_mouseUp(button, x, y);
		robk_mouseUp(button, x, y);
		vinh_mouseUp(button, x, y);
		game_mouseUp(button, x, y);
	#endif
}

void load(char *appPath, char *resPath, long handle)
{
	#ifdef MOD_TEST
		test_load(appPath, resPath, handle);
	#else
		benc_load(appPath, resPath, handle);
		robk_load(appPath, resPath, handle);
		vinh_load(appPath, resPath, handle);
		game_load(appPath, resPath, handle);
	#endif
}

void unload()
{
	#ifdef MOD_TEST
		test_unload();
	#else
		benc_unload();
		robk_unload();
		vinh_unload();
		game_unload();
	#endif
}