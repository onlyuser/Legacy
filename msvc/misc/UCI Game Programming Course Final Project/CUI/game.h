#ifndef H_GAME
#define H_GAME

#include "cui.h"
#include "collide.h"
#include "car.h"
#include "fmod.h"

#define KEY_CAMERA 192
#define KEY_LOAD 8
#define KEY_IGNITION 13
#define KEY_SHIFTUP 33
#define KEY_SHIFTDN 34
#define KEY_LEFT 37
#define KEY_RIGHT 39
#define KEY_PEDAL 38
#define KEY_BRAKE 40
#define KEY_HORN 9

#define MP3_TRACK_A "in_the_glitter.mp3"
#define MOD_TRACK_A "invtro94.s3m"
#define SND_TRACK_A "city_ambi1.wav"

#define DOLLY_RADIUS_TOP 20
#define DOLLY_RADIUS_CHASE 4
#define DOLLY_PITCH_CHASE 30

#define NPC_MOVSPD 0.1
#define NPC_ROTSPD 5

void game_timer();
void game_display();
void game_keyDown(BYTE key);
void game_keyUp(BYTE key);
void game_mouseDown(long button, long x, long y);
void game_mouseMove(long button, long x, long y);
void game_mouseUp(long button, long x, long y);
void game_load(char *appPath, char *resPath, long handle);
void game_unload();

#endif