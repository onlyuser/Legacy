#include "iostream.h"
#include <time.h> /* clock() + srand() :: various */
#include "GL/glut.h" /* glutInit() :: various */
#include "scene.h"
#include "CUI/cui.h"
#include  "crtdbg.h" /* mem-leak tester */

//#define CHECK_LEAK

#define WIN_WIDTH 640
#define WIN_HEIGHT 480
#define WIN_TITLE "GL_Test"
#define WIN_CLASS "GLUT"

const long mPathLen = 80;
char *mAppPath;

#define MAX_SPRCNT 40
scene *mScene;

long mHandle;
keyBase *mKeyBase;
bool mExit;

#define TIMER_INT 10
long mPrevTick;

void bail()
{
	delete mScene;
	delete mKeyBase;
	exit(0);
}

void tick()
{
	if (clock() - mPrevTick > TIMER_INT)
	{
		mPrevTick = clock();
		mScene->update();
		timer();
	}
	if (mKeyBase->dispatchEvts(mExit))
		if (mExit)
		{
			unload();
			bail();
		}
	glutPostRedisplay();
}

void init(int argc, char **argv)
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
	glutInitWindowSize(WIN_WIDTH, WIN_HEIGHT);
	glutCreateWindow(WIN_TITLE);
	glutIdleFunc(tick);
	glutDisplayFunc(display);
	mHandle = (long) FindWindow(WIN_CLASS, WIN_TITLE);
	mKeyBase = new keyBase(mHandle);
	mKeyBase->regEvents(
		keyDown,
		keyUp,
		mouseDown,
		mouseMove,
		mouseUp
	);
	mScene = new scene(WIN_WIDTH, WIN_HEIGHT, MAX_SPRCNT);
	mAppPath = new char[mPathLen];
	GetCurrentDirectory(mPathLen, mAppPath);
}

void lock()
{
	delete []mAppPath;
	mScene->lockScene();
	mPrevTick = 0;
	mExit = false;
}

void main(int argc, char **argv)
{
//=========================================================
// http://www.cs.wisc.edu/~tlabonne/memleak.html
//=========================================================

#ifdef CHECK_LEAK
	// put these close to WinMain (or main) entrance
	#ifndef NDEBUG
		// get current dbg flag (report it)
		int flag = _CrtSetDbgFlag(_CRTDBG_REPORT_FLAG);
		// logically OR leak check bit
		flag |= _CRTDBG_LEAK_CHECK_DF;
		// set the flags again
		_CrtSetDbgFlag(flag); 
	#endif
	// put this right after the flag settings from above
	#ifdef _DEBUG
		#define new new(_NORMAL_BLOCK, __FILE__, __LINE__)
	#endif
#endif

//=========================================================
// block-end
//=========================================================

	srand(time(NULL));
	init(argc, argv);
	load(mAppPath, argv[1], mHandle);
	lock();
	glutMainLoop();
}