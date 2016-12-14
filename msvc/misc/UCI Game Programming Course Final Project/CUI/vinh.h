#ifndef H_VINH
#define H_VINH

#include "cui.h"

void vinh_timer();
void vinh_display();
void vinh_keyDown(BYTE key);
void vinh_keyUp(BYTE key);
void vinh_mouseDown(long button, long x, long y);
void vinh_mouseMove(long button, long x, long y);
void vinh_mouseUp(long button, long x, long y);
void vinh_load(char *appPath, char *resPath, long handle);
void vinh_unload();

#endif