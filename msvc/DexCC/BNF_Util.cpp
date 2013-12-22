#include "BNF_Util.h"

bool BNF_Util::matchRegex(char c, std::string ptn)
{
	int start = (ptn[0] == '^');
	bool match_found = false;
	for (int i = start; i < ptn.length(); i++)
	{
		if (ptn[i] == '-')
			if (match_found |= inRange(c, ptn[i - 1] + 1, ptn[i + 1] - 1))
				break;
		if (match_found |= ptn[i] == c)
			break;
	}
	return match_found ^ start == 1;
}

// at least one char in ptn1 is described by ptn2
bool BNF_Util::isIncludeRegex(std::string ptn1, std::string ptn2)
{
	for (int i = 0; i < ptn1.length(); i++)
		if (ptn1[i] != '-')
			if (matchRegex(ptn1[i], ptn2))
				return true;
	return false;
}

// every char in ptn1 is described by ptn2
bool BNF_Util::isSpanRegex(std::string ptn1, std::string ptn2)
{
	for (int i = 0; i < ptn1.length(); i++)
		if (ptn1[i] != '-')
			if (!matchRegex(ptn1[i], ptn2))
				return false;
	return true;
}

bool BNF_Util::isOverlapRegex(std::string ptn1, std::string ptn2)
{
	return isIncludeRegex(ptn1, ptn2) || isIncludeRegex(ptn2, ptn1);
}

//=============================================================================

int BNF_Util::findLHS(
	std::vector<BNF_Rule *> *ruleList, int &start, std::string symbol
	)
{
	if (symbol[0] != '\'')
		for (int i = start; i < ruleList->size(); i++)
			if ((*ruleList)[i]->mLHS == symbol)
				return start = i;
	return start = -1;
}

bool BNF_Util::isTerm(std::vector<BNF_Rule *> *ruleList, std::string symbol)
{
	int start = 0;
	return findLHS(ruleList, start, symbol) == -1;
}

int BNF_Util::findTerm(
	std::vector<BNF_Rule *> *ruleList,
	int &start, std::string symbol, int &termPos
	)
{
	for (int i = start; i < ruleList->size(); i++)
		if ((termPos = (*(*ruleList)[i])[symbol]) != -1)
			return start = i;
	return start = -1;
}

//=============================================================================

bool BNF_Util::addToSet(std::set<std::string> *set, std::string item)
{
	if (set->find(item) == set->end())
	{
		set->insert(item);
		return true;
	}
	return false;
}

bool BNF_Util::addToSet(
	std::set<std::string> *setA, std::set<std::string> *setB,
	bool filter, bool &change
	)
{
	bool empty_found = false;
	std::set<std::string>::iterator p;
	for (p = setB->begin(); p != setB->end(); p++)
	{
		if (!filter || *p != BNF_EMPTY)
			change |= addToSet(setA, *p);
		if (*p == BNF_EMPTY)
			empty_found = true;
	}
	return empty_found;
}

//=============================================================================

std::set<std::string> *BNF_Util::getFirstSet(
	std::vector<BNF_Rule *> *ruleList, std::string symbol,
	std::map<std::string, bool> &visMap
	)
{
	std::set<std::string> *result = new std::set<std::string>();
	//=========================================================
	// check for infinite recursion
	if (visMap.find(symbol) != visMap.end())
		return result;
	visMap[symbol] = true; // mark as visited
	//=========================================================
	// rule #1 (include symbol if terminal)
	if (isTerm(ruleList, symbol))
	{
		result->insert(symbol);
		return result;
	}
	bool change;
	do
	{
		change = false;
		for (
			int index = findLHS(ruleList, index = 0, symbol);
			index != -1;
			findLHS(ruleList, ++index, symbol)
			)
		{
			BNF_Rule *rule = (*ruleList)[index];
			// rule #2 (include EMPTY if derived)
			if (rule->mRHS == BNF_EMPTY)
				change |= addToSet(result, BNF_EMPTY);
			else
			{
				// rule #3 (include FIRST while EMPTY is derived)
				bool all_derive_empty = true; // assume TRUE
				for (int i = 0; i < rule->length(); i++)
				{
					//=========================================================
					// get FIRST and loop through it
					std::set<std::string> *firstSet =
						getFirstSet(ruleList, (*rule)[i], visMap);
					all_derive_empty &= addToSet( // if EMPTY found, bias FALSE
						result, firstSet, false, change
						); // add everything
					delete firstSet;
					if (all_derive_empty)
						continue; // syntactic candy :)
					break;
					//=========================================================
				}
				if (all_derive_empty) // if assumption holds
					change |= addToSet(result, BNF_EMPTY);
			}
		}
	} while (change);
	return result;
}

std::set<std::string> *BNF_Util::getFirstSetEx(
	std::vector<BNF_Rule *> *ruleList, std::string expr
	)
{
	std::set<std::string> *result = new std::set<std::string>();
	// rule #1 (include non-EMPTY terms in FIRST while EMPTY is derived)
	bool all_derive_empty = true; // assume TRUE
	int i = 0;
	while (i < expr.length())
	{
		std::string token = scanText(expr, i, " ");
		//=========================================================
		// get FIRST and loop through it
		std::set<std::string> *firstSet = getFirstSet(ruleList, token);
		bool dummy;
		all_derive_empty &= addToSet( // if EMPTY found, bias FALSE
			result, firstSet, true, dummy
			); // add non-EMPTY terms
		delete firstSet;
		if (all_derive_empty)
			continue; // syntactic candy :)
		break;
		//=========================================================
	}
	if (all_derive_empty) // if assumption holds
		result->insert(BNF_EMPTY);
	return result;
}

std::set<std::string> *BNF_Util::getFollowSet(
	std::vector<BNF_Rule *> *ruleList, std::string root, std::string symbol,
	std::map<std::string, bool> &visMap
	)
{
	std::set<std::string> *result = new std::set<std::string>();
	//=========================================================
	// check for infinite recursion
	if (visMap.find(symbol) != visMap.end())
		return result;
	visMap[symbol] = true; // mark as visited
	//=========================================================
	// rule #1 (include END if symbol is ROOT)
	if (symbol == root)
		result->insert(BNF_END);
	bool change;
	do
	{
		change = false;
		for (
			int termPos,
			int index = findTerm(ruleList, index = 0, symbol, termPos);
			index != -1;
			findTerm(ruleList, ++index, symbol, termPos)
			)
		{
			BNF_Rule *rule = (*ruleList)[index];
			// rule #2 (include non-EMPTY terms in FIRST of next term)
			bool derives_empty = false; // assume FALSE
			if (termPos == rule->length() - 1) // if last term
				derives_empty = true; // mark and proceed
			else
			{
				//=========================================================
				// get FIRST of next term and loop through it
				std::set<std::string> *firstSet =
					getFirstSet(ruleList, (*rule)[termPos + 1]);
				derives_empty |= addToSet( // if EMPTY found, bias TRUE
					result, firstSet, true, change
					); // add non-EMPTY terms
				delete firstSet;
				//=========================================================
			}
			// rule #3 (inherit FOLLOW of parent if EMPTY is derived)
			if (derives_empty) // if assumption fails
			{
				// get FOLLOW of parent
				std::set<std::string> *followSet =
					getFollowSet(ruleList, root, rule->mLHS, visMap);
				addToSet(result, followSet, false, change); // add everything
				delete followSet;
			}
		}
	} while (change);
	return result;
}

//=============================================================================

std::set<std::string> *BNF_Util::getFirstSet(
	std::vector<BNF_Rule *> *ruleList, std::string symbol
	)
{
	std::map<std::string, bool> visMap;
	return getFirstSet(ruleList, symbol, visMap);
}

std::set<std::string> *BNF_Util::getFollowSet(
	std::vector<BNF_Rule *> *ruleList, std::string root, std::string symbol
	)
{
	std::map<std::string, bool> visMap;
	return getFollowSet(ruleList, root, symbol, visMap);
}

//=============================================================================

std::string BNF_Util::getFirst(
	std::vector<BNF_Rule *> *ruleList, std::string expr
	)
{
	std::string result;
	//=========================================================
	std::set<std::string> *firstSet = BNF_Util::getFirstSetEx(ruleList, expr);
	std::set<std::string>::iterator p;
	for (p = firstSet->begin(); p != firstSet->end(); p++)
		result += *p + BNF_COMMA;
	delete firstSet;
	//=========================================================
	if (result != "")
		result = left(result, result.length() - strlen(BNF_COMMA));
	return "FIRST(" + expr + ") = {" + result + "}";
}

std::string BNF_Util::getFollow(
	std::vector<BNF_Rule *> *ruleList, std::string root, std::string expr
	)
{
	std::string result;
	//=========================================================
	std::set<std::string> *followSet = BNF_Util::getFollowSet(ruleList, root, expr);
	std::set<std::string>::iterator p;
	for (p = followSet->begin(); p != followSet->end(); p++)
		result += *p + BNF_COMMA;
	delete followSet;
	//=========================================================
	if (result != "")
		result = left(result, result.length() - strlen(BNF_COMMA));
	return "FOLLOW(" + expr + ") = {" + result + "}";
}

//=============================================================================

std::string BNF_Util::format(std::string expr)
{
	std::string result =
		"\'" + replaceEx(trim(deRepeat(expr, ' ')), " ", "' '") + "\'";
	return (result != "''") ? result : "";
}