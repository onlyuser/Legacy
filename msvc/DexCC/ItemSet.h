#ifndef H_ITEMSET
#define H_ITEMSET

#include <vector>
#include <list>
#include "BNF_Rule.h"
#include "LR_Item.h"
#include "BNF_Util.h"
#include "SharedSym.h"
#include "String.h"

class ItemSet
{
private:
	std::vector<BNF_Rule *> *mRuleList;
	std::list<LR_Item *> mItemList;
public:
	ItemSet(std::vector<BNF_Rule *> *ruleList);
	ItemSet(std::vector<BNF_Rule *> *ruleList, ItemSet *other);
	~ItemSet();
	//=============================================================================
	int size();
	const std::list<LR_Item *>::iterator begin();
	const std::list<LR_Item *>::iterator end();
	//=============================================================================
	bool hasItem(LR_Item *item, bool strict);
	bool isEqual(ItemSet *other, bool strict);
	bool addItem(LR_Item *item);
	ItemSet *merge(ItemSet *other);
	//=============================================================================
	void advanceDot();
	bool closeItem(LR_Item *item);
	void applyClosure();
	ItemSet *buildGotoSet(std::string symbol);
	//=============================================================================
	std::string toString();
	//=============================================================================
};

#endif