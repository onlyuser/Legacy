#ifndef H_CUI
#define H_CUI

#include <string> /* string :: various */
#include "../scene.h"
#include "../keyBase.h"
#include "fmod.h"

extern scene *mScene;
extern keyBase *mKeyBase;

using namespace std;
extern string mPathA;
extern string mPathB;
#define setPath(pathA, pathB) (mPathA = pathA, mPathB = pathB)
#define getPath(path) ((char *) (mPathA + mPathB + path).c_str())

#define DEF_VOLUME 200
#define initSound() (FSOUND_Init(44100, 32, FSOUND_INIT_USEDEFAULTMIDISYNTH))

#define cacheMusic(handle, file) (handle = FMUSIC_LoadSong(getPath(file)))
#define cacheSound(handle, file) (handle = FSOUND_Sample_Load(FSOUND_UNMANAGED, getPath(file), FSOUND_NORMAL, 0))
void playMusic(FMUSIC_MODULE *handle, bool loop);
long playSound(FSOUND_SAMPLE *handle, bool loop);
#define stopMusic(handle) (FMUSIC_StopSong(handle))
#define stopSound(channel) (FSOUND_StopSound(channel))

#define loadStream(handle, file) (handle = FSOUND_Stream_OpenFile(getPath(file), FSOUND_LOOP_NORMAL, 0))
#define playStream(handle) (FSOUND_Stream_Play(FSOUND_FREE, handle))
#define stopStream(handle) (FSOUND_Stream_Stop(handle))

#include "test.h"
#include "benc.h"
#include "robk.h"
#include "vinh.h"
#include "game.h"

void timer();
void display();
void keyDown(BYTE key);
void keyUp(BYTE key);
void mouseDown(long button, long x, long y);
void mouseMove(long button, long x, long y);
void mouseUp(long button, long x, long y);
void load(char *appPath, char *resPath, long handle);
void unload();

#endif H_CUI