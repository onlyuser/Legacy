#include "ParserTable.h"

ParserTable::ParserTable(std::string symbols)
{
	int count = 0;
	int i = 0;
	while (i < symbols.length())
	{
		std::string token = scanText(symbols, i, " ");
		mSymTable.push_back(token);
		mSymTableR[token] = count;
		count++;
	}
}

ParserTable::~ParserTable()
{
	std::vector<ParserRow *>::iterator p;
	for (p = mRowList.begin(); p != mRowList.end(); p++)
		delete *p;
}

//=============================================================================

int ParserTable::size()
{
	return mRowList.size();
}

ParserRow &ParserTable::operator [](int row)
{
	return *(mRowList[row]);
}

void ParserTable::addRow(ParserRow *row)
{
	mRowList.push_back(row);
}

//=============================================================================

std::map<std::string, int> &ParserTable::getSymTableR()
{
	return mSymTableR;
}

std::string ParserTable::getSymbols()
{
	std::string result;
	for (int i = 0; i < mSymTable.size(); i++)
		result += mSymTable[i] + "\t";
	if (result != "")
		result = left(result, result.length() - 1);
	return result;
}

//=============================================================================

std::string ParserTable::toString()
{
	std::string result;
	result += this->getSymbols() + VBCRLF;
	for (int i = 0; i < this->size(); i++)
		result += "s" + cstr(i) + ":\t" + (*this)[i].toString() + VBCRLF;
	if (result != "")
		result = left(result, result.length() - strlen(VBCRLF));
	return result;
}