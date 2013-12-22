#include "DexCC.h"

DexCC::DexCC()
{
}

DexCC::~DexCC()
{
}

void DexCC::reset()
{
	mParserGen.reset();
}

void DexCC::load(char *filename, char *root)
{
	mParserGen.load(filename, root);
}

void DexCC::toString(char *buffer)
{
	strcpy(buffer, mParserGen.toString().c_str());
}

void DexCC::buildTable(char *root)
{
	mParserGen.buildTable(&mParserGen, root);
}

void DexCC::parse(char *root, char *expr, char *buffer)
{
	std::string s = mParserGen.parseEx(root, expr);
	if (s != "")
		strcpy(buffer, s.c_str());
}

void DexCC::getFirst(char *expr, char *buffer)
{
	strcpy(buffer, BNF_Util::getFirst(&(mParserGen.mRuleList), expr).c_str());
}

void DexCC::getFollow(char *root, char *expr, char *buffer)
{
	strcpy(buffer, BNF_Util::getFollow(&(mParserGen.mRuleList), root, expr).c_str());
}

void DexCC::getItems(char *buffer)
{
	strcpy(buffer, mParserGen.getItems().c_str());
}