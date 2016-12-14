#ifndef H_ROBK
#define H_ROBK

#include "cui.h"

void robk_timer();
void robk_display();
void robk_keyDown(BYTE key);
void robk_keyUp(BYTE key);
void robk_mouseDown(long button, long x, long y);
void robk_mouseMove(long button, long x, long y);
void robk_mouseUp(long button, long x, long y);
void robk_load(char *appPath, char *resPath, long handle);
void robk_unload();

#endif