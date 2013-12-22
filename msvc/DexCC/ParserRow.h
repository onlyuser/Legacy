#ifndef H_PARSERROW
#define H_PARSERROW

#include <map>
#include <vector>
#include "BNF_Util.h"
#include "String.h"

class ParserRow
{
private:
	std::map<std::string, int> *mSymTableR;
	std::vector<std::string> mRowData;
	std::string mDummy;
public:
	ParserRow(std::map<std::string, int> *symTableR, std::string rowData);
	~ParserRow();
	//=============================================================================
	std::string &operator[](std::string symbol);
	std::string &operator[](int col);
	//=============================================================================
	std::string toString();
	//=============================================================================
};

#endif