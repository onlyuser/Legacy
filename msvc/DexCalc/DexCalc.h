#ifndef H_DEXCALC
#define H_DEXCALC

#include <math.h>
#include <stack>
#include <map>
#include "Calc_Util.h"
#include "SharedSym.h"
#include "String.h"
#include "Exception.h"
#include "Util.h"

//#define TURBO_MODE

class DexCalc
{
private:
	std::string mExprBuf;
	bool mTurbo;
	std::stack<std::map<std::string, std::string> *> mVarStack;

	//=============================================================================
	std::map<std::string, std::string> *loadVarTable(std::string var);
	//=============================================================================
	void setVar(std::string var, float value);
	float getVar(std::string var);
	float bind(std::string a, char op, std::string b);
	//=============================================================================
public:
	DexCalc();
	~DexCalc();
	//=============================================================================
	void enterScope();
	int exitScope();
	void reset();
	//=============================================================================
	void setTurbo(bool value);
	std::string compile(std::string expr);
	//=============================================================================
	float eval(std::string expr);
	//=============================================================================
	void defVar(std::string var);
	void undefVar(std::string var);
	//=============================================================================
};

#endif H_DexCalc