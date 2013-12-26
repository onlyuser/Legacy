#include "DexCalc.h"

DexCalc::DexCalc()
{
	mTurbo = false;
	this->enterScope();
}

DexCalc::~DexCalc()
{
	this->reset();
	this->exitScope();
}

//=============================================================================

void DexCalc::enterScope()
{
	mVarStack.push(new std::map<std::string, std::string>());
}

int DexCalc::exitScope()
{
	delete mVarStack.top();
	mVarStack.pop();
	return mVarStack.size();
}

void DexCalc::reset()
{
	while (this->exitScope());
	this->enterScope();
}

//=============================================================================

void DexCalc::setTurbo(bool value)
{
	mTurbo = value;
}

std::string DexCalc::compile(std::string expr)
{
	return mExprBuf = TS_Util::fixExpr(expr);
}

//=============================================================================

float DexCalc::eval(std::string expr)
{
	int i;
	std::string result;
	std::string newExpr, token, prevToken;
	std::stack<std::string> opStack, elemStack, inStack;
	int depth;
	newExpr = "(" + expr + ")";
	if (!mTurbo)
		newExpr = TS_Util::fixExpr(newExpr);
	newExpr = replaceEx(newExpr, "E", "*10^");
	// STEP #1 (GROUP)
	// group tokens into operators and operands
	// (check for syntax errors)
	//
	// "(1 * 2 + 3)"
	//
	// [O]: ( * + )
	// [E]: 1 2 3
	// [I]:
	token = "";
	depth = 0;
	i = 0;
	while (i < newExpr.length())
	{
		prevToken = token;
		//==============================
		token = getNextTerm(newExpr, i);
		//==============================
		depth += (token == "(") ? 1 : 0;
		depth -= (token == ")") ? 1 : 0;
		if (depth < 0)
			throw Exception("expected end of statement");
		#ifndef TURBO_MODE
			if (TS_Util::rankOp(prevToken[0]) > 0 || prevToken == "(")
			{
				if (token == "+")
				{
					token = prevToken;
					continue;
				}
				if (token == "-") token = "neg";
				if (token == "!") token = "not";
				if (token == "~") token = "bnot";
				std::string prefix = left(token, 2);
				std::string value = lcase(right(token, token.length() - 2));
				if (prefix == "0x")
					token = changeBase(value, 16, 10);
				if (prefix == "0o")
					token = changeBase(value, 8, 10);
				if (prefix == "0b")
					token = changeBase(value, 2, 10);
			}
			if (
				TS_Util::rankOp(prevToken[0]) && (token[0] == OP_INC || token[0] == OP_DEC) ||
				(prevToken[0] == OP_INC || prevToken[0] == OP_DEC) && TS_Util::rankOp(token[0])
				)
				elemStack.push("0");
			else if (TS_Util::isFunc(prevToken) && token != "@" && token != ")")
				opStack.push("@");
			else
				TS_Util::checkSyntaxError(prevToken, token);
		#endif
		//=================================
		if (TS_Util::rankOp(token[0]))
			opStack.push(token);
		else
			elemStack.push(token);
		//=================================
	}
	if (depth > 0)
		throw Exception("expected close paren");
	// force operator into inStack
	// (start chain reaction)
	//
	// "(1 * 2 + 3)"
	//
	// [O]: ( * +
	// [E]: 1 2 3
	// [I]: )
	inStack.push(opStack.top());
	opStack.pop();
	while (!inStack.empty())
	{
		// STEP #2 (LOAD)
		// load inStack with opStack, elemStack elements
		// (stop at appropriate point)
		//
		// "(1 * 2 + 3)"
		//
		// [O]: (
		// [E]: 1
		// [I]: ) 3 + 2 *
		while
			(
				(opStack.top()[0] == OP_SET && TS_Util::rankOp(opStack.top()[0]) > TS_Util::rankOp(inStack.top()[0])) ||
				(opStack.top()[0] != OP_SET && TS_Util::rankOp(opStack.top()[0]) >= TS_Util::rankOp(inStack.top()[0])) ||
				opStack.top() == ")"
			)
		{
			// transfer close-parens to inStack
			// (if any)
			while (opStack.top() == ")")
			{
				inStack.push(opStack.top());
				opStack.pop();
			}
			// transfer operand to inStack
			inStack.push(elemStack.top());
			elemStack.pop();
			// force operator into inStack
			// (continue chain reaction)
			if (opStack.top() != "(")
			{
				inStack.push(opStack.top());
				opStack.pop();
			}
		}
		// STEP #3 (BIND)
		// bind elemStack, inStack operands with an opStack operator
		// (push result into elemStack)
		//
		// "(1 * 2 + 3)"
		//
		// [O]: ( *
		// [E]: 1
		// [I]: ) 3 + 2
		//
		// [O]: ( +
		// [E]: 2
		// [I]: ) 3
		//
		// [O]: (
		// [E]: 5
		// [I]: )
		//
		// [O]:
		// [E]: 5
		// [I]:
		while (TS_Util::rankOp(opStack.top()[0]) <= TS_Util::rankOp(inStack.top()[0]))
		{
			if (TS_Util::rankOp(inStack.top()[0]))
			{
				//======================================================
				opStack.push(inStack.top());
				inStack.pop();
				float temp =
					this->bind(
						elemStack.top(), opStack.top()[0], inStack.top()
						);
				result = (fabs(temp) == HUGE_VAL) ? "0" : cstr(temp);
				opStack.pop();
				elemStack.pop();
				//======================================================
			}
			else
				result = inStack.top();
			//============
			inStack.pop();
			//============
			while (!opStack.empty() && opStack.top() == "(" && inStack.top() == ")")
			{
				opStack.pop();
				inStack.pop();
			}
			if (inStack.empty())
			{
				if (isNumeric(result))
					return val(result);
				else
					return this->getVar(result);
			}
			else
				elemStack.push(result);
		}
	}
	throw Exception("unknown error");
}

//=============================================================================

std::map<std::string, std::string> *DexCalc::loadVarTable(std::string var)
{
	std::map<std::string, std::string> *result;
	std::stack<std::map<std::string, std::string> *> tempStack;
	result = NULL;
	if (mVarStack.size())
	{
		result = (std::map<std::string, std::string> *) mVarStack.top();
		if (result->find(var) == result->end())
		{
			do
			{
				tempStack.push(mVarStack.top());
				mVarStack.pop();
				if (mVarStack.size())
					result = (std::map<std::string, std::string> *) mVarStack.top();
				else
				{
					result = NULL;
					break;
				}
			} while (result->find(var) == result->end());
			while (tempStack.size())
			{
				mVarStack.push(tempStack.top());
				tempStack.pop();
			}
			if (result == NULL)
				throw Exception("variable not defined");
		}
		return result;
	}
	throw Exception("variable stack empty");
}

//=============================================================================

void DexCalc::defVar(std::string var)
{
	if (isNumeric(var))
		throw Exception("bad variable name");
	std::map<std::string, std::string> *varTable;
	if (mVarStack.size())
	{
		varTable = (std::map<std::string, std::string> *) mVarStack.top();
		if (varTable->find(var) == varTable->end())
		{
			(*varTable)[var] = "0";
			return;
		}
		throw Exception("variable redefinition");
	}
	throw Exception("variable stack empty");
}

void DexCalc::undefVar(std::string var)
{
	if (isNumeric(var))
		throw Exception("bad variable name");
	std::map<std::string, std::string> *varTable;
	if ((varTable = this->loadVarTable(var)) != NULL)
		varTable->erase(var);
}

//=============================================================================

void DexCalc::setVar(std::string var, float value)
{
	if (isNumeric(var))
		throw Exception("assignment to constant");
	std::map<std::string, std::string> *varTable;
	if ((varTable = this->loadVarTable(var)) != NULL)
		(*varTable)[var] = cstr(value);
}

float DexCalc::getVar(std::string var)
{
	std::map<std::string, std::string> *varTable;
	if ((varTable = this->loadVarTable(var)) != NULL)
		return val((*varTable)[var]);
}

float DexCalc::bind(std::string a, char op, std::string b)
{
	float numA;
	float numB;
	bool assign;
	std::string name;
	float value;
	if (a != "var" && a != "kill")
		if (isNumeric(b))
			numB = val(b);
		else
			numB = this->getVar(b);
	if (op == '@')
	{
		if (a == "var")
			this->defVar(b);
		else if (a == "kill")
			this->undefVar(b);
		else
			return TS_Util::bind(a, numB);
		return 0;
	}
	if (op != OP_SET)
		if (isNumeric(a))
			numA = val(a);
		else
			numA = this->getVar(a);
	assign = true;
	switch (op)
	{
	case OP_INC:
		if (!isNumeric(a))
			this->setVar(name = a, (value = numA) + 1);
		if (!isNumeric(b))
			this->setVar(name = b, value = (numB + 1));
		break;
	case OP_DEC:
		if (!isNumeric(a))
			this->setVar(name = a, (value = numA) - 1);
		if (!isNumeric(b))
			this->setVar(name = b, value = (numB - 1));
		break;
	case OP_SET: this->setVar(name = a, value = numB); break;
	case OP_ADD_SET: this->setVar(name = a, value = numA + numB); break;
	case OP_SUB_SET: this->setVar(name = a, value = numA - numB); break;
	case OP_MUL_SET: this->setVar(name = a, value = numA * numB); break;
	case OP_DIV_SET:
		this->setVar(name = a, value = TS_Util::safeDiv2(numA, numB));
		break;
	case OP_POW_SET: this->setVar(name = a, value = (float) pow(numA, numB)); break;
	default:
		assign = false;
	}
	if (assign)
		return value;
	return TS_Util::bind(numA, op, numB);
}
