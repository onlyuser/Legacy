#ifndef H_PARSER
#define H_PARSER

#include <set>
#include <vector>
#include <stack>
#include "BNF_Rule.h"
#include "ParserTable.h"
#include "ItemSet.h"
#include "SharedSym.h"
#include "String.h"
#include "Seq_Util.h"
#include "Exception.h"

#define UID_LEN 4
#define LOOP_SAMPLE_LEN 100

template<>
void writeSeq(std::list<int> &pList, std::string s);
template<>
std::string readSeq(std::list<int> &pList);

class Parser
{
private:
	//=============================================================================
	std::string getUID(int &seed);
	void addRule(std::string lhs, std::string rhs, int &start, int &seed);
	void addRule(std::string lhs, std::string rhs);
	//=============================================================================
	void pushState(
		std::stack<std::string> &frameStack,
		std::stack<std::string> &pStack, std::list<int> &output,
		int &s, std::string &a, int &ip, int &ip2, std::string &action
		);
	void applyState(
		std::stack<std::string> &frameStack,
		std::stack<std::string> &pStack, std::list<int> &output,
		int &s, std::string &a, int &ip, int &ip2, std::string &action
		);
	void popState(std::stack<std::string> &frameStack);
	//=============================================================================
	std::string getAction(
		std::stack<std::string> &frameStack,
		std::stack<std::string> &pStack, std::list<int> &output,
		std::string expr, int &s, std::string &a, int &ip, int &ip2,
		std::map<std::string, bool> &visMap
		);
	void handleError(
		std::stack<std::string> &pStack,
		std::string root, std::string expr, int &ip
		);
	//=============================================================================
	std::list<int> *parse(std::string root, std::string expr);
	//=============================================================================
protected:
	std::set<std::string> mTermList, mNonTermList;
public:
	std::vector<BNF_Rule *> mRuleList;
	ParserTable *mActionTable, *mGotoTable;

	Parser();
	~Parser();
	//=============================================================================
	void allocTable(std::string actionSym, std::string gotoSym, int rows);
	void reset();
	//=============================================================================
	void load(std::string filename, std::string root);
	//=============================================================================
	std::string parseEx(std::string root, std::string expr);
	//=============================================================================
	std::string toString();
	//=============================================================================
};

#endif