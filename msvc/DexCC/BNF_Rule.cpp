#include "BNF_Rule.h"

BNF_Rule::BNF_Rule(std::string lhs, std::string rhs)
{
	int count = 0;
	int i = 0;
	while (i < rhs.length())
	{
		std::string token = scanText(rhs, i, " ");
		mTermList.push_back(token);
		mTermIndex[token] = count;
		count++;
	}
	mBody = (mLHS = lhs) + BNF_ARROW + (mRHS = rhs);
}

BNF_Rule::~BNF_Rule()
{
}

//=============================================================================

int BNF_Rule::length()
{
	return mTermList.size();
}

std::string &BNF_Rule::operator[](int index)
{
	return mTermList[index];
}

int BNF_Rule::operator[](std::string term)
{
	std::map<std::string, int>::iterator p = mTermIndex.find(term);
	return (p != mTermIndex.end()) ? (*p).second : -1;
}

//=============================================================================

std::string BNF_Rule::getRHS(int dotPos)
{
	std::string result;
	for (int i = 0; i < mTermList.size(); i++)
	{
		if (i == dotPos)
			result += ".";
		result += mTermList[i] + " ";
	}
	result = trim(result);
	if (i == dotPos)
		result += ".";
	return result;
}

//=============================================================================

std::string BNF_Rule::toString(int dotPos)
{
	return mLHS + BNF_ARROW + this->getRHS(dotPos);
}