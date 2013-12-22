#ifndef H_LR_ITEM
#define H_LR_ITEM

#include <vector>
#include "BNF_Rule.h"
#include "SharedSym.h"
#include "String.h"
#include "Util.h"

class LR_Item
{
private:
	BNF_Rule *mRule;
public:
	int mRuleIndex;
	int mDotPos;
	std::string mLookAhead;

	LR_Item::LR_Item(std::vector<BNF_Rule *> *ruleList, LR_Item *other);
	LR_Item(
		std::vector<BNF_Rule *> *ruleList,
		int ruleIndex, int dotPos, std::string lookAhead
		);
	~LR_Item();
	//=============================================================================
	bool isEqual(LR_Item *other, bool strict);
	//=============================================================================
	std::string getKernel(int offset);
	std::string getRest();
	void advanceDot();
	bool closed();
	//=============================================================================
	std::string toString();
	//=============================================================================
};

#endif