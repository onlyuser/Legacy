#include "ItemSet.h"

ItemSet::ItemSet(std::vector<BNF_Rule *> *ruleList)
{
	mRuleList = ruleList;
}

ItemSet::ItemSet(std::vector<BNF_Rule *> *ruleList, ItemSet *other)
{
	mRuleList = ruleList;
	std::list<LR_Item *>::iterator p;
	for (p = other->begin(); p != other->end(); p++)
		this->addItem(new LR_Item(ruleList, *p));
}

ItemSet::~ItemSet()
{
	std::list<LR_Item *>::iterator p;
	for (p = mItemList.begin(); p != mItemList.end(); p++)
		delete *p;
}

//=============================================================================

int ItemSet::size()
{
	return mItemList.size();
}

const std::list<LR_Item *>::iterator ItemSet::begin()
{
	return mItemList.begin();
}

const std::list<LR_Item *>::iterator ItemSet::end()
{
	return mItemList.end();
}

//=============================================================================

bool ItemSet::hasItem(LR_Item *item, bool strict)
{
	std::list<LR_Item *>::iterator p;
	for (p = mItemList.begin(); p != mItemList.end(); p++)
		if ((*p)->isEqual(item, strict))
			return true;
	return false;
}

bool ItemSet::isEqual(ItemSet *other, bool strict)
{
	//=========================================================
	if (strict && mItemList.size() != other->size())
		return false;
	//=========================================================
	std::list<LR_Item *>::iterator p;
	for (p = other->begin(); p != other->end(); p++)
		if (!this->hasItem(*p, strict))
			return false;
	std::list<LR_Item *>::iterator q;
	for (q = mItemList.begin(); q != mItemList.end(); q++)
		if (!other->hasItem(*q, strict))
			return false;
	return true;
}

bool ItemSet::addItem(LR_Item *item)
{
	if (!this->hasItem(item, true))
	{
		mItemList.push_back(item);
		return true;
	}
	return false;
}

ItemSet *ItemSet::merge(ItemSet *other)
{
	ItemSet *result = new ItemSet(mRuleList);
	std::list<LR_Item *>::iterator p;
	for (p = mItemList.begin(); p != mItemList.end(); p++)
		result->addItem(new LR_Item(mRuleList, *p));
	std::list<LR_Item *>::iterator q;
	for (q = other->begin(); q != other->end(); q++)
		result->addItem(new LR_Item(mRuleList, *q));
	return result;
}

//=============================================================================

void ItemSet::advanceDot()
{
	std::list<LR_Item *>::iterator p;
	for (p = mItemList.begin(); p != mItemList.end(); p++)
		(*p)->advanceDot();
}

bool ItemSet::closeItem(LR_Item *item)
{
	std::string kernel = item->getKernel(0);
	// for each production
	bool change = false;
	for (
		int index = BNF_Util::findLHS(mRuleList, index = 0, kernel);
		index != -1;
		BNF_Util::findLHS(mRuleList, ++index, kernel)
		)
	{
		//=========================================================
		// get FIRST SET and loop through it
		std::set<std::string> *firstSet =
			BNF_Util::getFirstSetEx(
				mRuleList, trim(item->getRest() + " " + item->mLookAhead)
				);
		std::set<std::string>::iterator p;
		for (p = firstSet->begin(); p != firstSet->end(); p++)
		{
			LR_Item *item = new LR_Item(mRuleList, index, 0, *p);
			if (change |= this->addItem(item)) // add if unique
				continue; // syntactic-candy :)
			delete item;
		}
		delete firstSet;
		//=========================================================
	}
	return change;
}

void ItemSet::applyClosure()
{
	bool change;
	do
	{
		change = false;
		std::list<LR_Item *>::iterator p;
		for (p = mItemList.begin(); p != mItemList.end(); p++)
			if (!(*p)->closed())
				change |= this->closeItem(*p);
	} while (change);
}

ItemSet *ItemSet::buildGotoSet(std::string symbol)
{
	ItemSet *result = new ItemSet(mRuleList);
	std::list<LR_Item *>::iterator p;
	for (p = mItemList.begin(); p != mItemList.end(); p++)
		if ((*p)->getKernel(0) == symbol)
			result->addItem(new LR_Item(mRuleList, *p));
	result->advanceDot();
	result->applyClosure();
	return result;
}

//=============================================================================

std::string ItemSet::toString()
{
	std::string result;
	std::list<LR_Item *>::iterator p;
	for (p = mItemList.begin(); p != mItemList.end(); p++)
		result += (*p)->toString() + VBCRLF;
	if (result != "")
		result = left(result, result.length() - strlen(VBCRLF));
	return result;
}