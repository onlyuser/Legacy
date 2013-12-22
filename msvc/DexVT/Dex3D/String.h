#ifndef H_STRING
#define H_STRING

#include <math.h> // atof()
#include <ctype.h> // isalpha()
#include <string> // std::string
#include "Exception.h"
#include "Util.h" // limit()

#define VBCRLF "\r\n"
#define VBLF "\n"

#define val(s) ((float) atof(s.c_str()))
#define left(s, n) (inRange(n, 0, s.length()) ? s.substr(0, n) : s)
#define right(s, n) (inRange(n, 0, s.length()) ? s.substr(s.length() - (n), n) : s)
#define replace(s, ptn, repPtn) (replacePtn(s, ptn, "", repPtn))
#define isTerm(c) \
	( \
		inRange(c, 'A', 'Z') || inRange(c, 'a', 'z') || inRange(c, '0', '9') || \
		c == '_' || c == '.' \
	)

static char mBuf[256];
static const char *mHexPool = "0123456789abcdef";
static const char *mVowelPool = "aeiou";

namespace PATH
{
	enum PATH
	{
		DRIVE,
		DIR,
		NAME,
		NAME_ONLY,
		EXTEN
	};
};

// type conversion
std::string cstr(bool v);
std::string cstr(int v);
std::string cstr(float v);
std::string cstr(char c);
std::string cstr(char *c);

// content creation
std::string repeat(std::string s, int n);
std::string changeBase(std::string expr, int base, int newBase);

// file access
std::string loadText(std::string &filename);
void saveText(std::string &filename, std::string s);

// content analysis
int findLast(std::string &s, std::string ptn);
int countText(std::string &s, std::string ptn);
bool isNumeric(std::string &s);
bool matchPtn(std::string &s, std::string ptn);
bool isVowel(char c);

// content manipulation
std::string ucase(std::string &s);
std::string lcase(std::string &s);
std::string trim(std::string &s);
std::string trimUnix(std::string &s);
std::string pad(std::string &s, char c, int n, bool padLeft);
std::string replacePtn(std::string &s, std::string before, std::string after, std::string repPtn);
std::string replaceEx(std::string &s, std::string ptn, std::string repPtn);
std::string despace(std::string &s);
std::string despaceUnix(std::string &s);
std::string deRepeat(std::string &s, char c);
std::string reverse(std::string &s, std::string sepTerm);

// content extraction
std::string scanText(std::string &s, int &start, std::string ptn);
std::string getEntry(std::string &s, std::string sepTerm, int n);
std::string getBtw(std::string &s, int &start, std::string before, std::string after);
std::string getPathPart(std::string path, PATH::PATH part);
std::string getNextTerm(std::string &s, int &start);
std::string getShellPtn(std::string &s, int &start, std::string before, std::string after);

#endif