#ifndef H_TEST
#define H_TEST

#include "cui.h"

void test_timer();
void test_display();
void test_keyDown(BYTE key);
void test_keyUp(BYTE key);
void test_mouseDown(long button, long x, long y);
void test_mouseMove(long button, long x, long y);
void test_mouseUp(long button, long x, long y);
void test_load(char *appPath, char *resPath, long handle);
void test_unload();

#endif