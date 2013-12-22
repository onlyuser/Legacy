#include "LR_Item.h"

LR_Item::LR_Item(std::vector<BNF_Rule *> *ruleList, LR_Item *other)
{
	mRule = (*ruleList)[mRuleIndex = other->mRuleIndex];
	mDotPos = other->mDotPos;
	mLookAhead = other->mLookAhead;
}

LR_Item::LR_Item(
	std::vector<BNF_Rule *> *ruleList,
	int ruleIndex, int dotPos, std::string lookAhead
	)
{
	mRule = (*ruleList)[mRuleIndex = ruleIndex];
	mDotPos = dotPos;
	mLookAhead = lookAhead;
}

LR_Item::~LR_Item()
{
}

//=============================================================================

bool LR_Item::isEqual(LR_Item *other, bool strict)
{
	return
		mRuleIndex == other->mRuleIndex &&
		mDotPos == other->mDotPos &&
		(mLookAhead == other->mLookAhead || !strict);
}

//=============================================================================

std::string LR_Item::getKernel(int offset)
{
	int index = mDotPos + offset;
	return (index < mRule->length()) ? (*mRule)[index] : "";
}

std::string LR_Item::getRest()
{
	std::string result;
	for (int i = mDotPos + 1; i < mRule->length(); i++)
		result += (*mRule)[i] + " ";
	return trim(result);
}

void LR_Item::advanceDot()
{
	mDotPos = min(mDotPos + 1, mRule->length());
}

bool LR_Item::closed()
{
	return mDotPos == mRule->length();
}

//=============================================================================

std::string LR_Item::toString()
{
	return mRule->toString(mDotPos) + BNF_COMMA + mLookAhead;
}