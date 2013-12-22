#include "Font.h"

Font::Font()  {mNumID = 0;}
Font::~Font() {}

void Font::lock(std::string name, int size, bool bold, bool italic, bool underline, bool strikeOut, DEXGL_FONTGEN funcFontGen)
{
	if (name != "")
		mNumID = funcFontGen(
			(char *) name.c_str(), size,
			bold, italic, underline, strikeOut
			);
}

void Font::unlock(DEXGL_FONTKILL funcFontKill)
{
	if (mNumID)
	{
		funcFontKill(mNumID);
		mNumID = 0;
	}
}

void Font::apply(std::string text, Vector &v, long color, DEXGL_FONTPRINT funcFontPrint)
{
	funcFontPrint(mNumID, (char *) text.c_str(), v.x, v.y, v.z, color);
}