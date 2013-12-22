#ifndef H_BNF_UTIL
#define H_BNF_UTIL

#include <map>
#include <vector>
#include <set>
#include "BNF_Rule.h"
#include "SharedSym.h"
#include "String.h"

class BNF_Util
{
private:
	//=============================================================================
	static bool isIncludeRegex(std::string ptn1, std::string ptn2);
	//=============================================================================
	static int findTerm(
		std::vector<BNF_Rule *> *ruleList,
		int &start, std::string symbol, int &termPos
		);
	//=============================================================================
	static bool addToSet(std::set<std::string> *set, std::string item);
	static bool addToSet(
		std::set<std::string> *setA, std::set<std::string> *setB,
		bool filter, bool &change
		);
	//=============================================================================
	static std::set<std::string> *getFirstSet(
		std::vector<BNF_Rule *> *ruleList, std::string symbol,
		std::map<std::string, bool> &visMap
		);
	static std::set<std::string> *getFollowSet(
		std::vector<BNF_Rule *> *ruleList, std::string root, std::string symbol,
		std::map<std::string, bool> &visMap
		);
	//=============================================================================
	static std::set<std::string> *getFirstSet(
		std::vector<BNF_Rule *> *ruleList, std::string symbol
		);
	//=============================================================================
public:
	//=============================================================================
	static bool matchRegex(char c, std::string ptn);
	static bool isSpanRegex(std::string ptn1, std::string ptn2);
	static bool isOverlapRegex(std::string ptn1, std::string ptn2);
	//=============================================================================
	static int findLHS(
		std::vector<BNF_Rule *> *ruleList, int &start, std::string symbol
		);
	static bool isTerm(std::vector<BNF_Rule *> *ruleList, std::string symbol);
	//=============================================================================
	static std::set<std::string> *getFirstSetEx(
		std::vector<BNF_Rule *> *ruleList, std::string expr
		);
	static std::set<std::string> *getFollowSet(
		std::vector<BNF_Rule *> *ruleList, std::string root, std::string symbol
		);
	//=============================================================================
	static std::string getFirst(
		std::vector<BNF_Rule *> *ruleList, std::string expr
		);
	static std::string getFollow(
		std::vector<BNF_Rule *> *ruleList, std::string root, std::string expr
		);
	//=============================================================================
	static std::string format(std::string expr);
	//=============================================================================
};

#endif