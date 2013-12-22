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
		RESET,
		SEND_CHAR,
		SET_RADIAL,
		SET_MIN_X,
		SET_MAX_X,
		SET_MIN_Z,
		SET_MAX_Z,
		SET_STEP_X,
		SET_STEP_Z,
		SET_WIDTH,
		SET_LENGTH,
		SET_HEIGHT,
		PLOT
	};
};

class DexUser : public DexBase
{
private:
	void plotGraph(
		std::string func, bool radial,
		float minX, float maxX, float minZ, float maxZ,
		int stepX, int stepZ, float width, float length, float height
		);
public:
	DexUser(
		HINSTANCE libDexGL,
		HINSTANCE libDex3D,
		HINSTANCE libDexSocket,
		HINSTANCE libDexCalc
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