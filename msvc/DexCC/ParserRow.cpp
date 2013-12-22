#include "ParserRow.h"

ParserRow::ParserRow(std::map<std::string, int> *symTableR, std::string rowData)
{
	mSymTableR = symTableR;
	int i = 0;
	while (i < rowData.length())
	{
		std::string token = scanText(rowData, i, " ");
		mRowData.push_back(replaceEx(token, "/", " "));
	}
}

ParserRow::~ParserRow()
{
}

//=============================================================================

std::string &ParserRow::operator[](std::string symbol)
{
	std::map<std::string, int>::iterator p = mSymTableR->find(symbol);
	if (p != mSymTableR->end())
		return mRowData[(*p).second];
	else
	{
		std::string newSym = symbol;
		if (left(newSym, 1) == "\'")
		{
			newSym = newSym.substr(1, newSym.length() - 2);
			for (p = mSymTableR->begin(); p != mSymTableR->end(); p++)
			{
				std::string newPtn = (*p).first;
				if (left(newPtn, 2) == "'[")
				{
					newPtn = newPtn.substr(2, newPtn.length() - 4);
					if (BNF_Util::matchRegex(newSym[0], newPtn))
						return mRowData[(*p).second];
				}
			}
		}
	}
	return mDummy;
}

std::string &ParserRow::operator[](int col)
{
	return mRowData[col];
}

//=============================================================================

std::string ParserRow::toString()
{
	std::string result;
	for (int i = 0; i < mRowData.size(); i++)
		result += replaceEx(mRowData[i], " ", "/") + "\t";
	if (result != "")
		result = left(result, result.length() - 1);
	return result;
}