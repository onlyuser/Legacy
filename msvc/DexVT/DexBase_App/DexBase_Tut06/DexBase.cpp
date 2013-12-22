#include "DexBase.h"

DexBase::DexBase(
	HINSTANCE libDexGL,
	HINSTANCE libDex3D,
	HINSTANCE libDexSocket,
	HINSTANCE libDexCalc
	)
{
	//=============================================================================
	mDexGL_load      = (DEXGL_LOAD)      GetProcAddress(libDexGL, "DexGL_load");
	mDexGL_unload    = (DEXGL_UNLOAD)    GetProcAddress(libDexGL, "DexGL_unload");
	//=============================================================================
	mDexGL_resize    = (DEXGL_RESIZE)    GetProcAddress(libDexGL, "DexGL_resize");
	mDexGL_clear     = (DEXGL_CLEAR)     GetProcAddress(libDexGL, "DexGL_clear");
	mDexGL_paint     = (DEXGL_PAINT)     GetProcAddress(libDexGL, "DexGL_paint");
	mDexGL_saveImage = (DEXGL_SAVEIMAGE) GetProcAddress(libDexGL, "DexGL_saveImage");
	//=============================================================================
	mDexGL_listGen   = (DEXGL_LISTGEN)   GetProcAddress(libDexGL, "DexGL_listGen");
	mDexGL_listKill  = (DEXGL_LISTKILL)  GetProcAddress(libDexGL, "DexGL_listKill");
	mDexGL_texGen    = (DEXGL_TEXGEN)    GetProcAddress(libDexGL, "DexGL_texGen");
	mDexGL_texKill   = (DEXGL_TEXKILL)   GetProcAddress(libDexGL, "DexGL_texKill");
	mDexGL_texBind   = (DEXGL_TEXBIND)   GetProcAddress(libDexGL, "DexGL_texBind");
	mDexGL_fontGen   = (DEXGL_FONTGEN)   GetProcAddress(libDexGL, "DexGL_fontGen");
	mDexGL_fontKill  = (DEXGL_FONTKILL)  GetProcAddress(libDexGL, "DexGL_fontKill");
	mDexGL_fontPrint = (DEXGL_FONTPRINT) GetProcAddress(libDexGL, "DexGL_fontPrint");
	mDexGL_view      = (DEXGL_VIEW)      GetProcAddress(libDexGL, "DexGL_view");
	mDexGL_model     = (DEXGL_MODEL)     GetProcAddress(libDexGL, "DexGL_model");
	mDexGL_light     = (DEXGL_LIGHT)     GetProcAddress(libDexGL, "DexGL_light");
	mDexGL_brush     = (DEXGL_BRUSH)     GetProcAddress(libDexGL, "DexGL_brush");
	mDexGL_blend     = (DEXGL_BLEND)     GetProcAddress(libDexGL, "DexGL_blend");
	mDexGL_mode      = (DEXGL_MODE)      GetProcAddress(libDexGL, "DexGL_mode");
	mDexGL_fog       = (DEXGL_FOG)       GetProcAddress(libDexGL, "DexGL_fog");
	mDexGL_tri       = (DEXGL_TRI)       GetProcAddress(libDexGL, "DexGL_tri");
	//=============================================================================
	mDex3D_load      = (DEX3D_LOAD)      GetProcAddress(libDex3D, "Dex3D_load");
	mDex3D_unload    = (DEX3D_UNLOAD)    GetProcAddress(libDex3D, "Dex3D_unload");
	//=============================================================================
	mDex3D_regDrwFncEx = (DEX3D_REGDRWFNCEX) GetProcAddress(libDex3D, "Dex3D_regDrwFncEx");
	mDex3D_regDrwFnc   = (DEX3D_REGDRWFNC)   GetProcAddress(libDex3D, "Dex3D_regDrwFnc");
	//=============================================================================
	mDex3D_setCamera = (DEX3D_SETCAMERA) GetProcAddress(libDex3D, "Dex3D_setCamera");
	mDex3D_setLight  = (DEX3D_SETLIGHT)  GetProcAddress(libDex3D, "Dex3D_setLight");
	mDex3D_resize    = (DEX3D_RESIZE)    GetProcAddress(libDex3D, "Dex3D_resize");
	//=============================================================================
	mDex3D_moveTo    = (DEX3D_MOVETO)    GetProcAddress(libDex3D, "Dex3D_moveTo");
	mDex3D_lookAt    = (DEX3D_LOOKAT)    GetProcAddress(libDex3D, "Dex3D_lookAt");
	mDex3D_lookFrom  = (DEX3D_LOOKFROM)  GetProcAddress(libDex3D, "Dex3D_lookFrom");
	mDex3D_orbit     = (DEX3D_ORBIT)     GetProcAddress(libDex3D, "Dex3D_orbit");
	//=============================================================================
	mDex3D_remMesh   = (DEX3D_REMMESH)   GetProcAddress(libDex3D, "Dex3D_remMesh");
	mDex3D_clear     = (DEX3D_CLEAR)     GetProcAddress(libDex3D, "Dex3D_clear");
	mDex3D_relock    = (DEX3D_RELOCK)    GetProcAddress(libDex3D, "Dex3D_relock");
	//=============================================================================
	mDex3D_copyMesh  = (DEX3D_COPYMESH)  GetProcAddress(libDex3D, "Dex3D_copyMesh");
	mDex3D_load3ds   = (DEX3D_LOAD3DS)   GetProcAddress(libDex3D, "Dex3D_load3ds");
	mDex3D_addBox    = (DEX3D_ADDBOX)    GetProcAddress(libDex3D, "Dex3D_addBox");
	mDex3D_addGrid   = (DEX3D_ADDGRID)   GetProcAddress(libDex3D, "Dex3D_addGrid");
	mDex3D_addSprite = (DEX3D_ADDSPRITE) GetProcAddress(libDex3D, "Dex3D_addSprite");
	mDex3D_addHud    = (DEX3D_ADDHUD)    GetProcAddress(libDex3D, "Dex3D_addHud");
	mDex3D_addCylndr = (DEX3D_ADDCYLNDR) GetProcAddress(libDex3D, "Dex3D_addCylndr");
	mDex3D_addCone   = (DEX3D_ADDCONE)   GetProcAddress(libDex3D, "Dex3D_addCone");
	mDex3D_addSphere = (DEX3D_ADDSPHERE) GetProcAddress(libDex3D, "Dex3D_addSphere");
	mDex3D_addHemis  = (DEX3D_ADDHEMIS)  GetProcAddress(libDex3D, "Dex3D_addHemis");
	mDex3D_addCapsul = (DEX3D_ADDCAPSUL) GetProcAddress(libDex3D, "Dex3D_addCapsul");
	mDex3D_addTorus  = (DEX3D_ADDTORUS)  GetProcAddress(libDex3D, "Dex3D_addTorus");
	mDex3D_addOcta   = (DEX3D_ADDOCTA)   GetProcAddress(libDex3D, "Dex3D_addOcta");
	mDex3D_addTetra  = (DEX3D_ADDTETRA)  GetProcAddress(libDex3D, "Dex3D_addTetra");
	//=============================================================================
	mDex3D_modify    = (DEX3D_MODIFY)    GetProcAddress(libDex3D, "Dex3D_modify");
	mDex3D_query     = (DEX3D_QUERY)     GetProcAddress(libDex3D, "Dex3D_query");
	mDex3D_pointAt   = (DEX3D_POINTAT)   GetProcAddress(libDex3D, "Dex3D_pointAt");
	mDex3D_rotArb    = (DEX3D_ROTARB)    GetProcAddress(libDex3D, "Dex3D_rotArb");
	mDex3D_applyImp  = (DEX3D_APPLYIMP)  GetProcAddress(libDex3D, "Dex3D_applyImp");
	mDex3D_link      = (DEX3D_LINK)      GetProcAddress(libDex3D, "Dex3D_link");
	//=============================================================================
	mDex3D_sectPoly  = (DEX3D_SECTPOLY)  GetProcAddress(libDex3D, "Dex3D_sectPoly");
	mDex3D_pick      = (DEX3D_PICK)      GetProcAddress(libDex3D, "Dex3D_pick");
	//=============================================================================
	mDex3D_setVertex = (DEX3D_SETVERTEX) GetProcAddress(libDex3D, "Dex3D_setVertex");
	mDex3D_relockMsh = (DEX3D_RELOCKMSH) GetProcAddress(libDex3D, "Dex3D_relockMsh");
	mDex3D_setAxis   = (DEX3D_SETAXIS)   GetProcAddress(libDex3D, "Dex3D_setAxis");
	mDex3D_alignAxis = (DEX3D_ALIGNAXIS) GetProcAddress(libDex3D, "Dex3D_alignAxis");
	mDex3D_invert    = (DEX3D_INVERT)    GetProcAddress(libDex3D, "Dex3D_invert");
	mDex3D_imprint   = (DEX3D_IMPRINT)   GetProcAddress(libDex3D, "Dex3D_imprint");
	mDex3D_normalize = (DEX3D_NORMALIZE) GetProcAddress(libDex3D, "Dex3D_normalize");
	mDex3D_setHgtMap = (DEX3D_SETHGTMAP) GetProcAddress(libDex3D, "Dex3D_setHgtMap");
	mDex3D_setColor  = (DEX3D_SETCOLOR)  GetProcAddress(libDex3D, "Dex3D_setColor");
	//=============================================================================
	mDex3D_setTexMap = (DEX3D_SETTEXMAP) GetProcAddress(libDex3D, "Dex3D_setTexMap");
	mDex3D_setFont   = (DEX3D_SETFONT)   GetProcAddress(libDex3D, "Dex3D_setFont");
	//=============================================================================
	mDex3D_setSolid  = (DEX3D_SETSOLID)  GetProcAddress(libDex3D, "Dex3D_setSolid");
	mDex3D_setWire   = (DEX3D_SETWIRE)   GetProcAddress(libDex3D, "Dex3D_setWire");
	mDex3D_setAlpha  = (DEX3D_SETALPHA)  GetProcAddress(libDex3D, "Dex3D_setAlpha");
	//=============================================================================
	mDex3D_setAttrib = (DEX3D_SETATTRIB) GetProcAddress(libDex3D, "Dex3D_setAttrib");
	mDex3D_setText   = (DEX3D_SETTEXT)   GetProcAddress(libDex3D, "Dex3D_setText");
	mDex3D_setVis    = (DEX3D_SETVIS)    GetProcAddress(libDex3D, "Dex3D_setVis");
	mDex3D_setNoClip = (DEX3D_SETNOCLIP) GetProcAddress(libDex3D, "Dex3D_setNoClip");
	mDex3D_setPhys   = (DEX3D_SETPHYS)   GetProcAddress(libDex3D, "Dex3D_setPhys");
	//=============================================================================
	mDex3D_update    = (DEX3D_UPDATE)    GetProcAddress(libDex3D, "Dex3D_update");
	mDex3D_paint     = (DEX3D_PAINT)     GetProcAddress(libDex3D, "Dex3D_paint");
	//=============================================================================
	mDexSocket_open  = (DEXSOCKET_OPEN)  GetProcAddress(libDexSocket, "DexSocket_open");
	mDexSocket_close = (DEXSOCKET_CLOSE) GetProcAddress(libDexSocket, "DexSocket_close");
	mDexSocket_send  = (DEXSOCKET_SEND)  GetProcAddress(libDexSocket, "DexSocket_send");
	mDexSocket_recv  = (DEXSOCKET_RECV)  GetProcAddress(libDexSocket, "DexSocket_recv");
	//=============================================================================
	mDexCalc_setModeVB = (DEXCALC_SETMODEVB) GetProcAddress(libDexCalc, "DexCalc_setModeVB");
	mDexCalc_changeBse = (DEXCALC_CHANGEBSE) GetProcAddress(libDexCalc, "DexCalc_changeBse");
	mDexCalc_enterScpe = (DEXCALC_ENTERSCPE) GetProcAddress(libDexCalc, "DexCalc_enterScpe");
	mDexCalc_exitScope = (DEXCALC_EXITSCOPE) GetProcAddress(libDexCalc, "DexCalc_exitScope");
	mDexCalc_reset     = (DEXCALC_RESET)     GetProcAddress(libDexCalc, "DexCalc_reset");
	mDexCalc_setTurbo  = (DEXCALC_SETTURBO)  GetProcAddress(libDexCalc, "DexCalc_setTurbo");
	mDexCalc_compile   = (DEXCALC_COMPILE)   GetProcAddress(libDexCalc, "DexCalc_compile");
	mDexCalc_eval      = (DEXCALC_EVAL)      GetProcAddress(libDexCalc, "DexCalc_eval");
	mDexCalc_defVar    = (DEXCALC_DEFVAR)    GetProcAddress(libDexCalc, "DexCalc_defVar");
	mDexCalc_undefVar  = (DEXCALC_UNDEFVAR)  GetProcAddress(libDexCalc, "DexCalc_undefVar");
	//=============================================================================
}

DexBase::~DexBase()
{
}

std::string DexBase::getPath()
{
	char buf[256];
	GetModuleFileName(NULL, buf, 256);
	return getPathPart(buf, PATH::DIR);
}

void DexBase::msgBox(std::string text)
{
	MessageBox(hWnd, (char *) text.c_str(), "", 0);
}

void DexBase::setText(std::string text)
{
	SetWindowText(hWnd, (char *) (cstr("DexBase: ") + text).c_str());
}

void DexBase::setSize(int width, int height)
{
	RECT rect;
	GetWindowRect(hWnd, &rect);
	SetWindowPos(hWnd, HWND_TOP, rect.left, rect.top, width, height, SWP_SHOWWINDOW);
}

void DexBase::quit()
{
	SendMessage(hWnd, WM_CLOSE, 0, 0);
}

void DexBase::saveImage(std::string filename)
{
	long *color = new long[mWidth * mHeight];
	mDexGL_saveImage(color, false, 0, 0);
	FileBmp::saveBmp(filename, color, mWidth, mHeight);
	delete []color;
}

void DexBase::saveDepthMap(std::string filename, float power, float scale, float bias)
{
	float *depth = new float[mWidth * mHeight];
	mDexGL_saveImage(depth, true, scale, bias);
	long *color = new long[mWidth * mHeight];
	for (int i = 0; i < mWidth * mHeight; i++)
	{
		int c = (int) (pow(depth[i], power) * 255);
		if (c == 255)
			c = 0;
		color[i] = rgb(c, c, c);
	}
	delete []depth;
	FileBmp::saveBmp(filename, color, mWidth, mHeight);
	delete []color;
}

void DexBase::load(HWND hWnd)
{
	this->hWnd = hWnd;
	//=============================================================================
	mDexGL_load(hWnd);
	mDex3D_load();
	mDex3D_regDrwFnc(
		mDexGL_tri,
		mDexGL_listGen, mDexGL_listKill,
		mDexGL_texGen, mDexGL_texKill, mDexGL_texBind,
		mDexGL_fontGen, mDexGL_fontKill, mDexGL_fontPrint,
		mDexGL_view, mDexGL_model,
		mDexGL_light, mDexGL_brush, mDexGL_blend,
		mDexGL_mode
		);
	//=============================================================================
}

void DexBase::unload(int &cancel)
{
	//=============================================================================
	mDex3D_unload();
	mDexGL_unload();
	//=============================================================================
}

void DexBase::resize(int width, int height)
{
	mWidth = width;
	mHeight = height;
	//=============================================================================
	mDexGL_resize(width, height);
	//=============================================================================
}

void DexBase::paint(HDC hDC)
{
	//=============================================================================
	mDexGL_clear();
	mDex3D_paint();
	mDexGL_paint();
	//=============================================================================
}

void DexBase::timer()
{
	mDex3D_update();
	//=============================================================================
	this->paint(NULL);
	//=============================================================================
}