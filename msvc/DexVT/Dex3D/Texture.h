#ifndef H_TEXTURE
#define H_TEXTURE

#include "ITagged.h"
#include "IAttrib.h"
#include "Vector.h"
#include "FileBmp.h"
#include "IMesh.h"
#include "TDexGL.h" // DEXGL_TEXGEN
#include "TDex3D.h" // DIR::DIR

class Texture : public ITagged, public IAttrib
{
public:
	bool mGlow;

	Texture();
	~Texture();
	void lock(std::string filename, std::string maskFile, long maskColor, bool mipmap, DEXGL_TEXGEN funcTexGen);
	void unlock(DEXGL_TEXKILL funcTexKill);
	static void setHgtMap(IMesh *mesh, std::string filename, float height);
	static void project(IMesh *mesh, DIR::DIR dir);
	void apply(DEXGL_BRUSH funcBrush, DEXGL_TEXBIND funcTexBind);
};

#endif