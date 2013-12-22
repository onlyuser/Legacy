#ifndef H_BNF_RULE
#define H_BNF_RULE

#include <vector>
#include <map>
#include "SharedSym.h"
#include "String.h"

class BNF_Rule
{
private:
	std::vector<std::string> mTermList;
	std::map<std::string, int> mTermIndex;

	//=============================================================================
	std::string getRHS(int dotPos);
	//=============================================================================
public:
	std::string mLHS;
	std::string mRHS;
	std::string mBody;

	BNF_Rule(std::string lhs, std::string rhs);
	~BNF_Rule();
	//=============================================================================
	int length();
	std::string &operator[](int index);
	int operator[](std::string term);
	//=============================================================================
	std::string toString(int dotPos);
	//=============================================================================
};

#endif