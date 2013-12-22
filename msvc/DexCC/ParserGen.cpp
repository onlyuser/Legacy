#include "ParserGen.h"

ParserGen::ParserGen()
{
}

ParserGen::~ParserGen()
{
	this->reset();
}

//=============================================================================

void ParserGen::clearSetList()
{
	for (int i = 0; i < mSetList.size(); i++)
		delete mSetList[i];
	mSetList.clear();
}

void ParserGen::reset()
{
	Parser::reset();
	this->clearSetList();
}

//=============================================================================

int ParserGen::findItemSet(ItemSet *itemSet, bool strict)
{
	for (int i = 0; i < mSetList.size(); i++)
		if (mSetList[i]->isEqual(itemSet, strict))
			return i;
	return -1;
}

bool ParserGen::addItemSet(ItemSet *itemSet)
{
	if (this->findItemSet(itemSet, true) == -1)
	{
		mSetList.push_back(itemSet);
		return true;
	}
	return false;
}

//=============================================================================

void ParserGen::buildSetList(std::string root)
{
	this->clearSetList();
	//=========================================================
	ItemSet *seedItemSet = new ItemSet(&mRuleList);
	int j = 0;
	seedItemSet->addItem(
		new LR_Item(
			&mRuleList,
			BNF_Util::findLHS(&mRuleList, j, BNF_ROOT2),
			0,
			BNF_END
			)
		);
	seedItemSet->applyClosure();
	mSetList.push_back(seedItemSet);
	//=========================================================
	bool change;
	do
	{
		change = false;
		// loop through item sets
		for (int i = 0; i < mSetList.size(); i++)
		{
			ItemSet *itemSet = mSetList[i];
			std::set<std::string> kernelSet;
			// loop through set contents
			std::list<LR_Item *>::iterator p;
			for (p = itemSet->begin(); p != itemSet->end(); p++)
			{
				std::string kernel = (*p)->getKernel(0);
				if (
					kernel != BNF_EMPTY && // (epsilon fix)
					kernelSet.find(kernel) == kernelSet.end()
					) // add if not EMPTY and unique
				{
					kernelSet.insert(kernel);
					ItemSet *gotoSet = itemSet->buildGotoSet(kernel);
					if (change |= this->addItemSet(gotoSet)) // add if unique
						continue; // syntactic-candy :)
					delete gotoSet;
				}
			}
		}
	} while (change);
}

void ParserGen::packSetList()
{
	std::vector<ItemSet *> newSetList; // build new set list from scratch
	// loop through item sets
	for (int i = 0; i < mSetList.size(); i++)
	{
		ItemSet *itemSet = mSetList[i];
		bool match_found = false;
		// loop through new item sets
		for (int j = 0; j < newSetList.size(); j++)
		{
			ItemSet *itemSet2 = newSetList[j];
			if (
				match_found |= itemSet->isEqual(itemSet2, false)
				) // merge if redundant
			{
				newSetList.push_back(itemSet->merge(itemSet2));
				delete itemSet2;
				newSetList.erase(
					std::find(newSetList.begin(), newSetList.end(), itemSet2)
					);
				break;
			}
		}
		if (!match_found)
			newSetList.push_back(new ItemSet(&mRuleList, itemSet));
	}
	//=========================================================
	// copy back contents
	this->clearSetList();
	for (int j = 0; j < newSetList.size(); j++)
		mSetList.push_back(newSetList[j]);
	//=========================================================
}

std::map<std::string, std::string> *ParserGen::buildMergeMap(
	std::set<std::string> &termList
	)
{
	std::map<std::string, std::string> *mergeMap =
		new std::map<std::string, std::string>();
	bool change;
	do
	{
		change = false;
		std::set<std::string>::iterator p;
		for (p = termList.begin(); p != termList.end(); p++)
		{
			std::string newPtn1 = *p;
			//=========================================================
			// find merge candidate
			bool match_found = false;
			std::map<std::string, std::string>::iterator q;
			for (q = mergeMap->begin(); q != mergeMap->end(); q++)
			{
				std::string newPtn2 = (*q).second;
				if (
					newPtn2 != newPtn1 &&
					left(newPtn1, 2) == "'[" && left(newPtn2, 2) == "'["
					)
				{
					std::string s1 = newPtn1.substr(2, newPtn1.length() - 4);
					std::string s2 = newPtn2.substr(2, newPtn2.length() - 4);
					std::string s3 = despace(s1);
					std::string s4 = despace(s2);
					// is there overlap?
					if (match_found |= BNF_Util::isOverlapRegex(s3, s4))
					{
						// is there new non-cover?
						if (change |= !BNF_Util::isSpanRegex(s3, s4))
						{
							s2 = s1 + " " + s2;
							int i = 0;
							while (i < s2.length())
								(*mergeMap)[
									"'[" + scanText(s2, i, " ") + "]'"
									] = "'[" + s2 + "]'";
						}
						if (change)
							break;
					}
				}
			}
			if (!match_found)
				(*mergeMap)[newPtn1] = newPtn1;
			//=========================================================
			if (change)
				break;
		}
	} while (change);
	//=========================================================
	// format mapping
	std::map<std::string, std::string>::iterator r;
	for (r = mergeMap->begin(); r != mergeMap->end(); r++)
		(*mergeMap)[(*r).first] = despace((*r).second);
	//=========================================================
	// ensure uniqueness of mapping
	std::set<std::string> temp;
	std::set<std::string>::iterator s;
	for (s = termList.begin(); s != termList.end(); s++)
		temp.insert(
			(mergeMap->find(*s) != mergeMap->end()) ? (*mergeMap)[*s] : *s
			);
	//=========================================================
	// copy back contents
	termList.clear();
	std::set<std::string>::iterator t;
	for (t = temp.begin(); t != temp.end(); t++)
		termList.insert(*t);
	//=========================================================
	return mergeMap;
}

void ParserGen::buildTable(Parser *parser, std::string root)
{
	if (mRuleList.empty())
		return;
	this->buildSetList(root); // build item sets
	#ifdef USE_LALR
		this->packSetList(); // compress item sets
	#endif
	//=========================================================
	// build merge map
	std::map<std::string, std::string> *mergeMap =
		this->buildMergeMap(mTermList);
	//=========================================================
	// build ACTION field string
	std::string actionSym;
	std::set<std::string>::iterator p;
	for (p = mTermList.begin(); p != mTermList.end(); p++)
		actionSym += *p + " ";
	actionSym = trim(actionSym);
	//=========================================================
	// build GOTO field string
	std::string gotoSym;
	std::set<std::string>::iterator q;
	for (q = mNonTermList.begin(); q != mNonTermList.end(); q++)
		gotoSym += *q + " ";
	gotoSym = trim(gotoSym);
	//=========================================================
	parser->allocTable(
		actionSym, gotoSym, mSetList.size()
		); // allocate new cell
	ParserTable *actionTable = parser->mActionTable;
	ParserTable *gotoTable = parser->mGotoTable;
	// loop through item sets
	for (int i = 0; i < mSetList.size(); i++)
	{
		ItemSet *itemSet = mSetList[i];
		// loop through set contents
		std::list<LR_Item *>::iterator p;
		for (p = itemSet->begin(); p != itemSet->end(); p++)
		{
			LR_Item *item = *p;
			int ruleIndex = item->mRuleIndex;
			BNF_Rule *rule = mRuleList[ruleIndex];
			std::string kernel = item->getKernel(0);
			// if item closed or has EMPTY as a kernel (last term)
			if (
				item->closed() || (
					kernel == BNF_EMPTY &&
					item->mDotPos == rule->length() - 1 // last term
					) // (epsilon fix)
				)
			{
				//=========================================================
				// write ACCEPT or REDUCE into ACTION table
				if (
					mRuleList[ruleIndex]->mLHS == BNF_ROOT2 &&
					item->mLookAhead == BNF_END
					)
				{
					// rule #2c (accept)
					std::string value = BNF_ACC;
					std::string &cell =
						(*actionTable)[i][(*mergeMap)[BNF_END]];
					if (cell == "_" || cell == value)
						cell = value;
					else
						if (cell[0] == 'r')
							throw new Exception("REDUCE/ACCEPT conflict");
						else
							throw new Exception("SHIFT/ACCEPT conflict");
				}
				else
				{
					// rule #2b (reduce)
					std::string value = cstr("r") + cstr(ruleIndex);
					std::string &cell =
						(*actionTable)[i][(*mergeMap)[item->mLookAhead]];
					if (cell == "_")
						cell = value;
					else
						if (cell.find(value) == -1)
							cell = trim(cell + " " + value); // bias SHIFT
				}
				//=========================================================
			}
			else
				// if kernel is a terminal
				if (BNF_Util::isTerm(&mRuleList, kernel))
				{
					//=========================================================
					// write SHIFT into ACTION table
					ItemSet *gotoSet = itemSet->buildGotoSet(kernel);
					#ifdef USE_LALR
						int setIndex = this->findItemSet(gotoSet, false);
					#else
						int setIndex = this->findItemSet(gotoSet, true);
					#endif
					if (setIndex != -1)
					{
						// rule #2a (shift)
						std::string value = cstr("s") + cstr(setIndex);
						std::string &cell =
							(*actionTable)[i][(*mergeMap)[kernel]];
						if (cell == "_")
							cell = value;
						else
							if (cell.find(value) == -1)
								cell = trim(value + " " + cell); // bias SHIFT
					}
					delete gotoSet;
					//=========================================================
				}
			//=========================================================
			// write SHIFT into GOTO table
			ItemSet *gotoSet = itemSet->buildGotoSet(rule->mLHS);
			#ifdef USE_LALR
				int setIndex = this->findItemSet(gotoSet, false);
			#else
				int setIndex = this->findItemSet(gotoSet, true);
			#endif
			if (setIndex != -1)
			{
				// rule #3 (shift)
				std::string value = cstr("s") + cstr(setIndex);
				std::string &cell = (*gotoTable)[i][rule->mLHS];
				if (cell == "_" || cell == value)
					cell = value;
				else
					throw new Exception("SHIFT/SHIFT conflict on GOTO");
			}
			delete gotoSet;
			//=========================================================
		}
	}
}

//=============================================================================

std::string ParserGen::getItems()
{
	std::string result;
	for (int i = 0; i < mSetList.size(); i++)
		result +=
			"Item " + cstr(i) + ":" + VBCRLF +
			mSetList[i]->toString() + VBCRLF +
			VBCRLF;
	if (result != "")
		result = left(result, result.length() - strlen(VBCRLF) * 2);
	return result;
}