#ifndef H_DEXCC
#define H_DEXCC

#include "ParserGen.h"
#include "BNF_Util.h"
#include "String.h"

class DexCC
{
private:
	ParserGen mParserGen;
public:
	DexCC();
	~DexCC();
	void reset();
	void load(char *filename, char *root);
	void toString(char *buffer);
	void buildTable(char *root);
	void parse(char *root, char *expr, char *buffer);
	void getFirst(char *expr, char *buffer);
	void getFollow(char *root, char *expr, char *buffer);
	void getItems(char *buffer);
};

#endif