#ifndef H_PARSERGEN
#define H_PARSERGEN

#include <set>
#include <vector>
#include "Parser.h"
#include "BNF_Rule.h"
#include "ItemSet.h"
#include "BNF_Util.h"
#include "String.h"
#include <algorithm>

#define USE_LALR

class ParserGen : public Parser
{
private:
	std::vector<ItemSet *> mSetList;

	//=============================================================================
	int findItemSet(ItemSet *itemSet, bool strict);
	bool addItemSet(ItemSet *itemSet);
	//=============================================================================
	void buildSetList(std::string root);
	void packSetList();
	//=============================================================================
	std::map<std::string, std::string> *buildMergeMap(
		std::set<std::string> &termList
		);
	//=============================================================================
public:
	ParserGen();
	~ParserGen();
	//=============================================================================
	void clearSetList();
	void reset();
	//=============================================================================
	void buildTable(Parser *parser, std::string root);
	//=============================================================================
	std::string getItems();
	//=============================================================================
};

#endif