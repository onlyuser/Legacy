#ifndef H_TS_UTIL
#define H_TS_UTIL

#include "SharedSym.h"
#include "String.h"

static std::string PI_STR = cstr(PI);

class TS_Util
{
public:
	static float safeDiv2(float a, float b);
	static void checkSyntaxError(std::string prevToken, std::string token);
	static bool isFunc(std::string op);
	static float bind(std::string op, float a);
	static std::string fixExpr(std::string expr);
	static float bind(float a, char op, float b);
	static int rankOp(char op);
};

#endif