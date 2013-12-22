#ifndef H_DEXUSER
#define H_DEXUSER

#include <math.h>
#include "DexBase.h"
#include "Vector.h"
#include "Color.h"
#include "FileBmp.h"
#include "Util.h"

#define THREAD_NUM 1

namespace KEY
{
	enum KEY
	{
		ESCAPE = 27,
		SPACE = 32,
		ENTER = 13,
		SHIFT = 16,
		CTRL = 17,
		ALT = 18,
		TAB = 9,
		BACKSPACE = 8,
		ARROW_LEFT = 37,
		ARROW_UP = 38,
		ARROW_RIGHT = 39,
		ARROW_DOWN = 40
	};
};

namespace GUI
{
	enum GUI
	{
		INIT,
		CONNECT,
		DISCONNECT,
		RESET,
		STOP,
		GO
	};
};

class DexUser : public DexBase
{
private:
	long *mHgtMap;
	int mMapWidth, mMapHeight;

	float getHeight(long *data, int mapWidth, int mapHeight, float x, float z);
public:
	DexUser(
		HINSTANCE libDexGL,
		HINSTANCE libDex3D,
		HINSTANCE libDexSocket,
		HINSTANCE libDexTS
		);
	~DexUser();
	void load(HWND hWnd);
	void unload(int &cancel);
	void resize(int width, int height);
	void paint(HDC hDC);
	void keyDown(int key);
	void keyUp(int key);
	void mouseDown(int button, int x, int y);
	void mouseMove(int button, int x, int y);
	void mouseUp(int button, int x, int y);
	void mouseDblClick();
	void timer();
	void timerEx(long id);
	void user(long wParam, long lParam);
};

#endif