#ifndef H_PARSERTABLE
#define H_PARSERTABLE

#include <vector>
#include <map>
#include "ParserRow.h"
#include "String.h"

class ParserTable
{
private:
	std::vector<std::string> mSymTable;
	std::map<std::string, int> mSymTableR;
	std::vector<ParserRow *> mRowList;
public:
	ParserTable(std::string symbols);
	~ParserTable();
	//=============================================================================
	int size();
	ParserRow &operator[](int row);
	//=============================================================================
	void addRow(ParserRow *row);
	//=============================================================================
	std::map<std::string, int> &getSymTableR();
	std::string getSymbols();
	//=============================================================================
	std::string toString();
	//=============================================================================
};

#endif