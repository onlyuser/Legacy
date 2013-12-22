#ifndef H_TEXTBOX
#define H_TEXTBOX

#include "ITagged.h"
#include "Vector.h"
#include "TDexGL.h" // DEXGL_FONTGEN
#include "String.h"

class Font : public ITagged
{
public:
	Font();
	~Font();
	void lock(std::string name, int size, bool bold, bool italic, bool underline, bool strikeOut, DEXGL_FONTGEN funcFontGen);
	void unlock(DEXGL_FONTKILL funcFontKill);
	void apply(std::string text, Vector &v, long color, DEXGL_FONTPRINT funcFontPrint);
};

#endif