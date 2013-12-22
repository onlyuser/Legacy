#include "Parser.h"

Parser::Parser()
{
}

Parser::~Parser()
{
	this->reset();
}

//=============================================================================

void Parser::allocTable(std::string actionSym, std::string gotoSym, int rows)
{
	if (mActionTable)
	{
		delete mActionTable;
		mActionTable = NULL;
	}
	if (mGotoTable)
	{
		delete mGotoTable;
		mGotoTable = NULL;
	}
	if (!rows)
		return;
	//=========================================================
	// build ACTION and GOTO field string
	std::string actionRow = trim(repeat("_ ", countText(actionSym, " ") + 1));
	std::string gotoRow = trim(repeat("_ ", countText(gotoSym, " ") + 1));
	//=========================================================
	mActionTable = new ParserTable(actionSym);
	mGotoTable = new ParserTable(gotoSym);
	for (int i = 0; i < rows; i++)
	{
		mActionTable->addRow(
			new ParserRow(&mActionTable->getSymTableR(), actionRow)
			);
		mGotoTable->addRow(
			new ParserRow(&mGotoTable->getSymTableR(), gotoRow)
			);
	}
}

void Parser::reset()
{
	//=========================================================
	for (int i = 0; i < mRuleList.size(); i++)
		delete mRuleList[i];
	mRuleList.clear();
	//=========================================================
	mTermList.clear();
	mNonTermList.clear();
	//=========================================================
	this->allocTable("", "", 0);
}

//=============================================================================

std::string Parser::getUID(int &seed)
{
	return pad(cstr(seed = (seed + 1) % BIG_NUMBER), '0', UID_LEN, true);
}

void Parser::addRule(std::string lhs, std::string rhs, int &start, int &seed)
{
	std::list<std::string> termList;
	std::string buffer;
	bool label = false;
	int i = start;
	while (i < rhs.length())
	{
		std::string token = trim(scanTextEx(rhs, i, "'()|?+*"));
		if (token != "")
			buffer += token + " "; // add token
		char c = rhs[i - 1];
		if (c == '\'')
		{
			if (!label)
				buffer += c; // add begin quote
			else
				buffer = trim(buffer) + c + " "; // add end quote
			label = !label; // toggle quote
			continue;
		}
		if (label)
			switch (c)
			{
				case '(':
				case ')':
				case '|':
				case '?':
				case '+':
				case '*':
					buffer += c; // add quoted control token
			}
		else
		{
			switch (c)
			{
				case '(':
				{
					std::string newLHS = !start ?
						lhs : this->getUID(seed); // inherit or use temp LHS
					buffer += newLHS + " "; // add stub
					this->addRule(newLHS, rhs, i, seed); // branch from new stub
					break;
				}
				case '|':
					termList.push_back(trim(buffer)); // save everything
					buffer = ""; // start anew
					break;
				case ')':
				{
					termList.push_back(trim(buffer)); // save everything
					char op = (i < rhs.length() - 1) ?
						rhs[i + 1] : 0; // get modifier
					std::list<std::string>::iterator p;
					for (p = termList.begin(); p != termList.end(); p++)
					{
						std::string term = *p;
						switch (op)
						{
							case '?': term += cstr(" | ") + BNF_EMPTY; break;
							case '+': term += " | " + term + " " + lhs; break;
							case '*': term +=
								" | " + term + " " + lhs + " | " + BNF_EMPTY;
						}
						this->addRule(lhs, term);
					}
				}
			}
			if (c == ')')
				break; // bail
		}
	}
	start = i;
}

void Parser::addRule(std::string lhs, std::string rhs)
{
	if (rhs.find("|") == -1)
		mRuleList.push_back(new BNF_Rule(lhs, rhs));
	else
	{
		int i = 0;
		while (i < rhs.length())
		{
			std::string rhs2 = trim(scanText(rhs, i, "|"));
			mRuleList.push_back(new BNF_Rule(lhs, rhs2));
		}
	}
}

void Parser::load(std::string filename, std::string root)
{
	this->reset();
	//=========================================================
	// load input
	std::string fileData =
		deRepeat(replaceEx(loadText(filename), "\t", " "), ' ') + VBCRLF;
	fileData = replacePtn(fileData, "//", VBCRLF, VBCRLF);
	fileData = replacePtn(fileData, "/*", "*/", "");
	//=========================================================
	bool table = (getPathPart(filename, PATH::EXTEN) == "par");
	int mode = 0;
	int row = 0;
	//=========================================================
	int seed = 0; // init UID seed
	//=========================================================
	int i = 0;
	while (i < fileData.length())
	{
		std::string token = trim(scanText(fileData, i, VBCRLF));
		if (token == "")
			continue;
		if (token == "[cfg]")
			mode = 0;
		else if (token == "[par]")
			mode = 1;
		else
		{
			if (table)
			{
				// skip row prefix
				int j = 0;
				scanText(token, j, " ");
				token = right(token, token.length() - j);
			}
			switch (mode)
			{
				case 0:
				{
					std::string lhs = trim(getEntry(token, "->", 0));
					std::string rhs = trim(getEntry(token, "->", 1));
					int j = 0;
					this->addRule(lhs, "( " + rhs + " )", j, seed);
					break;
				}
				case 1:
				{
					std::string lhs = trim(getEntry(token, "|", 0));
					std::string rhs = trim(getEntry(token, "|", 1));
					if (!row)
					{
						mActionTable = new ParserTable(lhs);
						mGotoTable = new ParserTable(rhs);
					}
					else
					{
						mActionTable->addRow(
							new ParserRow(&mActionTable->getSymTableR(), lhs)
							);
						mGotoTable->addRow(
							new ParserRow(&mGotoTable->getSymTableR(), rhs)
							);
					}
					row++;
				}
			}
		}
	}
	//=========================================================
	// augment grammar
	if (BNF_Util::isTerm(&mRuleList, BNF_ROOT2))
		mRuleList.push_back(new BNF_Rule(BNF_ROOT2, root));
	//=========================================================
	// generate terminal and non-terminal list through rule list
	for (int j = 0; j < mRuleList.size(); j++)
	{
		BNF_Rule *rule = mRuleList[j];
		if (rule->mLHS != BNF_ROOT2) // (exclude ROOT2)
			mNonTermList.insert(rule->mLHS); // LHS must be non-terminal
		for (int k = 0; k < rule->length(); k++)
		{
			std::string rhs = (*rule)[k];
			if (rhs != BNF_EMPTY) // (epsilon fix; exclude EMPTY)
				mTermList.insert(rhs); // RHS can be terminal or non-terminal
		}
	}
	mTermList.insert(BNF_END); // first terminal is always END
	//=========================================================
	// remove non-terminals from terminal list
	std::set<std::string>::iterator p;
	for (p = mNonTermList.begin(); p != mNonTermList.end(); p++)
		if (mTermList.find(*p) != mTermList.end())
			mTermList.erase(*p);
	//=========================================================
}

//=============================================================================

template<>
void writeSeq(std::list<int> &pList, std::string s)
{
	pList.clear();
	int i = 0;
	while (i < s.length())
	{
		std::string token = scanText(s, i, " ");
		pList.push_back(val(token));
	}
}

template<>
std::string readSeq(std::list<int> &pList)
{
	std::string result;
	std::list<int>::iterator p;
	for (p = pList.begin(); p != pList.end(); p++)
		result += cstr(*p) + " ";
	return trim(result);
}

//=============================================================================

void Parser::pushState(
	std::stack<std::string> &frameStack,
	std::stack<std::string> &pStack, std::list<int> &output,
	int &s, std::string &a, int &ip, int &ip2, std::string &action
	)
{
	//=========================================================
	frameStack.push(readSeq(pStack));
	frameStack.push(readSeq(output));
	//=========================================================
	frameStack.push(cstr(s));
	frameStack.push(a);
	frameStack.push(cstr(ip));
	frameStack.push(cstr(ip2));
	frameStack.push(action);
	//=========================================================
}

void Parser::applyState(
	std::stack<std::string> &frameStack,
	std::stack<std::string> &pStack, std::list<int> &output,
	int &s, std::string &a, int &ip, int &ip2, std::string &action
	)
{
	//=========================================================
	action = popStack(frameStack);
	ip2 = val(popStack(frameStack));
	ip = val(popStack(frameStack));
	a = popStack(frameStack);
	s = val(popStack(frameStack));
	//=========================================================
	writeSeq(output, popStack(frameStack));
	writeSeq(pStack, popStack(frameStack));
	//=========================================================
	this->pushState(frameStack, pStack, output, s, a, ip, ip2, action);
}

void Parser::popState(std::stack<std::string> &frameStack)
{
	//=========================================================
	frameStack.pop(); // action
	frameStack.pop(); // ip2
	frameStack.pop(); // ip
	frameStack.pop(); // a
	frameStack.pop(); // s
	//=========================================================
	frameStack.pop(); // output
	frameStack.pop(); // pStack
	//=========================================================
}

//=============================================================================

std::string Parser::getAction(
	std::stack<std::string> &frameStack,
	std::stack<std::string> &pStack, std::list<int> &output,
	std::string expr, int &s, std::string &a, int &ip, int &ip2,
	std::map<std::string, bool> &visMap
	)
{
	std::string result;
	s = val(pStack.top()); // let "s" be stack top
	a = scanText(expr, ip2 = ip, " "); // let "a" be next token
	if ((result = (*mActionTable)[s][a]) == "_") // if error
		if (!frameStack.empty()) // if more alternatives to try
		{
			//=========================================================
			// pop branch info
			std::string name = popStack(frameStack); // get branch NAME
			int branchCnt = val(popStack(frameStack)); // get branch COUNT
			int branch = val(popStack(frameStack)); // get branch INDEX
			//=========================================================
			this->applyState(
				frameStack, pStack, output, s, a, ip, ip2, result
				); // apply branch STATE
			//=========================================================
			// push branch info
			frameStack.push(cstr(branch)); // push branch INDEX
			frameStack.push(cstr(branchCnt)); // push branch COUNT
			frameStack.push(name); // push branch NAME
			//=========================================================
		}
	//=========================================================
	std::string name =
		cstr(s) + "_" + a + "_" + cstr(ip); // build branch NAME
	std::string state = name + "_" +
		right(readSeq(output), LOOP_SAMPLE_LEN); // build parser STATE
	//=========================================================
	if (result.find(" ") != -1) // if multiple actions possible
	{
		int branchCnt = 1; // init branch COUNT
		int branch = 0; // init branch INDEX
		if (
			!frameStack.empty() && name == frameStack.top()
			) // if revisiting branch
		{
			//=========================================================
			// pop branch info
			frameStack.pop(); // pop branch NAME
			branchCnt = val(popStack(frameStack)); // get branch COUNT
			branch = val(popStack(frameStack)); // get branch INDEX
			//=========================================================
		}
		//=========================================================
		state += "_" + cstr(branch); // build parser STATE
		//=========================================================
		if (branch < branchCnt) // if branch legal
		{
			if (!branch) // if first encounter with branch
			{
				this->pushState(
					frameStack, pStack, output, s, a, ip, ip2, result
					); // push branch STATE
				branchCnt = countText(result, " ") + 1; // calc branch COUNT
			}
			//=========================================================
			result = getEntry(result, " ", branch); // choose this branch INDEX
			//=========================================================
			if (branch == branchCnt - 1) // if last encounter with branch
				this->popState(frameStack); // pop branch STATE
			else
			{
				//=========================================================
				// push branch info
				frameStack.push(cstr(branch + 1)); // push next branch INDEX
				frameStack.push(cstr(branchCnt)); // push branch COUNT
				frameStack.push(name); // push branch NAME
				//=========================================================
			}
		}
		else
			throw new Exception("parsing error");
	}
	//=========================================================
	// check for infinite recursion
	if (visMap.find(state) != visMap.end())
		throw new Exception("parsing error");
	visMap[state] = true; // mark as visited
	//=========================================================
	return result;
}

void Parser::handleError(
	std::stack<std::string> &pStack,
	std::string root, std::string expr, int &ip
	)
{
	while (!pStack.empty())
	{
		int s2 = val(pStack.top());
		bool goto_found = false;
		int best_ip = BIG_NUMBER;
		std::string best_sym;
		std::string best_goto;
		std::set<std::string>::iterator p;
		for (p = mNonTermList.begin(); p != mNonTermList.end(); p++)
		{
			std::string pGoto = (*mGotoTable)[s2][*p];
			if (goto_found |= (pGoto != "_"))
			{
				std::set<std::string> *followSet =
					BNF_Util::getFollowSet(&mRuleList, root, *p);
				std::set<std::string>::iterator q;
				for (q = followSet->begin(); q != followSet->end(); q++)
				{
					int ip3 = expr.find(*q, ip);
					if (ip3 != -1 && ip3 < best_ip)
					{
						best_ip = ip3;
						best_sym = *p;
						best_goto = pGoto;
					}
				}
				delete followSet;
			}
		}
		if (goto_found)
		{
			if (best_ip != BIG_NUMBER)
			{
				pStack.push(best_sym);
				int arg2 =
					val(right(best_goto, best_goto.length() - 1));
				pStack.push(cstr(arg2));
				ip = best_ip;
				break;
			}
			else
				throw new Exception("parsing error");
		}
		else
		{
			pStack.pop();
			pStack.pop();
		}
	}
}

std::list<int> *Parser::parse(std::string root, std::string expr)
{
	std::list<int> *result = new std::list<int>();
	//=========================================================
	std::string newExpr =
		trim(BNF_Util::format(expr) + " " + BNF_END); // load input
	//=========================================================
	std::stack<std::string> pStack;
	std::stack<std::string> frameStack;
	std::map<std::string, bool> visMap;
	pStack.push(cstr(0)); // (buffer for stack top)
	int ip = 0; // init "ip"
	int ip2; // (buffer for next "ip")
	while (true)
	{
		int s;
		std::string a;
		//=========================================================
		// get ACTION
		std::string action = this->getAction(
			frameStack, pStack, *result, newExpr, s, a, ip, ip2, visMap
			);
		int arg = val(right(action, action.length() - 1));
		//=========================================================
		switch (action[0])
		{
			case 's': // shift
			{
				int s2 = arg; // let "s2" be next state
				pStack.push(a); // push "a"
				pStack.push(cstr(s2)); // push "s2"
				ip = ip2; // advance "ip"
				break;
			}
			case 'r': // reduce
			{
				// pop "2*|B|" symbols
				BNF_Rule &rule = *(mRuleList[arg]);
				if (rule.mRHS != BNF_EMPTY) // (epsilon fix)
				{
					int count = rule.length() * 2;
					for (int i = 0; i < count; i++)
						pStack.pop();
				}
				int s2 = val(pStack.top()); // let "s2" be stack top
				pStack.push(rule.mLHS); // push "A"
				//=========================================================
				// get GOTO
				std::string pGoto = (*mGotoTable)[s2][rule.mLHS];
				int arg2 = val(right(pGoto, pGoto.length() - 1));
				//=========================================================
				pStack.push(cstr(arg2)); // push "goto[s2, A]"
				result->push_back(arg); // output "A->B"
				break;
			}
			case 'a': // accept
				return result;
			default: // error
				this->handleError(pStack, root, newExpr, ip);
		}
	}
}

std::string Parser::parseEx(std::string root, std::string expr)
{
	std::string result;
	//=========================================================
	std::list<int> *output = this->parse(root, expr); // load input
	//=========================================================
	int seed = 0; // init UID seed
	//=========================================================
	std::stack<std::string> treeStack;
	std::list<int>::iterator p;
	for (p = output->begin(); p != output->end(); p++)
	{
		BNF_Rule &rule = *(mRuleList[*p]);
		std::string lhs = rule.mLHS;
		if (lhs != root)
			lhs = this->getUID(seed) + "::" + lhs;
		for (int i = rule.length() - 1; i >= 0; i--)
		{
			std::string index = rule.length() > 1 ? "[" + cstr(i) + "]_" : "";
			if (BNF_Util::isTerm(&mRuleList, rule[i]))
			{
				std::string rhs = this->getUID(seed) + "::" + rule[i];
				result += lhs + BNF_ARROW + index + rhs + VBCRLF;
			}
			else
				if (!treeStack.empty())
				{
					std::string prevLHS = treeStack.top();
					result += lhs + BNF_ARROW + index + prevLHS + VBCRLF;
					treeStack.pop();
				}
		}
		treeStack.push(lhs);
	}
	delete output;
	if (result != "")
		result = left(result, result.length() - strlen(VBCRLF));
	return reverse(result, VBCRLF);
}

//=============================================================================

std::string Parser::toString()
{
	std::string result;
	if (!mRuleList.empty())
	{
		result += cstr("[cfg]") + VBCRLF;
		for (int i = 0; i < mRuleList.size(); i++)
			result += "r" + cstr(i) + ":\t" + mRuleList[i]->mBody + VBCRLF;
	}
	if (mActionTable)
	{
		result += cstr("[par]") + VBCRLF;
		result +=
			"_\t" +
			(*mActionTable).getSymbols() + "\t|\t" +
			(*mGotoTable).getSymbols() + VBCRLF;
		for (int i = 0; i < mActionTable->size(); i++)
			result +=
				"s" + cstr(i) + ":\t" +
				(*mActionTable)[i].toString() + "\t|\t" +
				(*mGotoTable)[i].toString() + VBCRLF;
	}
	if (result != "")
		result = left(result, result.length() - strlen(VBCRLF));
	return result;
}