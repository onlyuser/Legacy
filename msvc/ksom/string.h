#ifndef H_STRING
#define H_STRING

#include <string>
#include <ctype.h>
#include "util.h"

using namespace std;

#define val(s) ((float) atof(s.c_str()))
#define left(s, n) (n <= s.length() ? s.substr(0, n) : s)
#define right(s, n) (n <= s.length() ? s.substr(s.length() - n, n) : s)
#define editReplace(s, ptn, repPtn) (editReplacePtn(s, ptn, "", repPtn))
#define isTerm(c) ((isalnum(c) && c > 0) || c == '_' || c == '.')

static char mBuf[640];

// type conversion
string cstr(int v);
string cstr(float v);
string cstr(bool v);
string cstr(char c);
string cstr(char *c);
char *c_str(string s);

// file access
string loadText(string filename);
void saveText(string filename, string s);
void saveArray(string filename, float *array, int length);

// content analysis
int findLast(string s, string ptn);
int countText(string s, string ptn);
bool isNumeric(string s);
bool patternMatch(string s, string ptn);

// content manipulation
string trim(string s);
string editReplacePtn(string s, string before, string after, string repPtn);
string editSmartReplace(string s, string ptn, string repPtn);
string editDespace(string s);
string editDeRepeat(string s, char c);
string editRepeat(string s, int n);
string editReverse(string s, string sepTerm);

// content extraction
string ucase(string s);
string lcase(string s);
string scanText(string s, int &i, string ptn);
string getEntry(string s, string sepTerm, int index);
string getBtw(string s, int &start, string before, string after);
string getNextTerm(string s, int &start);
string getShellPtn(string s, int &start, string before, string after);

#endif