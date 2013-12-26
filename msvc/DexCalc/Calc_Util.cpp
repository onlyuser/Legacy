#include "Calc_Util.h"

float TS_Util::safeDiv2(float a, float b)
{
	if (!b)
		throw Exception("division by zero");
	return a / b;
}

void TS_Util::checkSyntaxError(std::string token1, std::string token2)
{
	// paren + paren && paren1 != paren2
	if (
		rankOp(token1[0]) < 0 && rankOp(token2[0]) < 0 &&
		token1 != token2
		)
		throw Exception("bad paren arrangement");
	// open paren + operator
	if (token1 == "(" && rankOp(token2[0]) > 0)
		throw Exception("expected open paren or operand");
	// operator + closed paren
	if (rankOp(token1[0]) > 0 && token2 == ")")
		throw Exception("expected operand");
	// operator + operator
	if (rankOp(token1[0]) > 0 && rankOp(token2[0]) > 0)
		throw Exception("consecutive binary operators");
}

bool TS_Util::isFunc(std::string op)
{
	if (op == "sin") return true;
	if (op == "cos") return true;
	if (op == "tan") return true;
	if (op == "csc") return true;
	if (op == "sec") return true;
	if (op == "cot") return true;
	if (op == "asin") return true;
	if (op == "acos") return true;
	if (op == "atan") return true;
	if (op == "rad") return true;
	if (op == "deg") return true;
	if (op == "ln") return true;
	if (op == "log") return true;
	if (op == "exp") return true;
	if (op == "abs") return true;
	if (op == "sgn") return true;
	if (op == "neg") return true;
	if (op == "not") return true;
	if (op == "bnot") return true;
	if (op == "int") return true;
	if (op == "floor") return true;
	if (op == "ciel") return true;
	if (op == "round") return true;
	if (op == "rnd") return true;
	if (op == "sqrt") return true;
	if (op == "fact") return true;
	if (op == "var") return true;
	if (op == "kill") return true;
	return false;
}

float TS_Util::bind(std::string op, float a)
{
	if (op == "sin") return (float) sin(a);
	if (op == "cos") return (float) cos(a);
	if (op == "tan") return (float) tan(a);
	if (op == "csc") return safeDiv2(1.0f, (float) sin(a));
	if (op == "sec") return safeDiv2(1.0f, (float) cos(a));
	if (op == "cot") return safeDiv2(1.0f, (float) tan(a));
	if (op == "asin") return (float) asin(a);
	if (op == "acos") return (float) acos(a);
	if (op == "atan") return (float) atan(a);
	if (op == "rad") return (float) toRad(a);
	if (op == "deg") return (float) toDeg(a);
	if (op == "ln") return (float) log(a);
	if (op == "log") return (float) log10(a);
	if (op == "exp") return (float) exp(a);
	if (op == "abs") return (float) fabs(a);
	if (op == "sgn") return sgn(a);
	if (op == "neg") return -a;
	if (op == "not") return !a;
	if (op == "bnot") return (float) ~((int) a);
	if (op == "int") return (float) ((int) a);
	if (op == "floor") return (float) ((int) a);
	if (op == "ciel") return (float) ((int) a + 1);
	if (op == "round") return (float) ((int) (a + 0.5f));
	if (op == "rnd") return !a ? rnd() : rndEx(0, a);
	if (op == "sqrt") return (float) sqrt(a);
	if (op == "fact") return (float) fact((int) a);
	throw Exception("unary operator not found");
}

std::string TS_Util::fixExpr(std::string expr)
{
	std::string result = expr;
	result = despace(result);
	result = replaceEx(result, "++", cstr(OP_INC));
	result = replaceEx(result, "--", cstr(OP_DEC));
	result = replaceEx(result, "+=", cstr(OP_ADD_SET));
	result = replaceEx(result, "-=", cstr(OP_SUB_SET));
	result = replaceEx(result, "*=", cstr(OP_MUL_SET));
	result = replaceEx(result, "/=", cstr(OP_DIV_SET));
	result = replaceEx(result, "^=", cstr(OP_POW_SET));
	result = replaceEx(result, ">=", cstr(OP_GE));
	result = replaceEx(result, "<=", cstr(OP_LE));
	result = replaceEx(result, "!=", cstr(OP_NEQ));
	result = replaceEx(result, "==", cstr(OP_EQ));
	result = replaceEx(result, "=", cstr(OP_SET));
	result = replaceEx(result, "&&", "&");
	result = replaceEx(result, "||", "|");
	result = replaceEx(result, "(xor)", "#");
	result = replaceEx(result, "(nand)", cstr(OP_NAND));
	result = replaceEx(result, "(nor)", cstr(OP_NOR));
	result = replaceEx(result, "(nxor)", cstr(OP_NXOR));
	result = replaceEx(result, "(band)", cstr(OP_BAND));
	result = replaceEx(result, "(bor)", cstr(OP_BOR));
	result = replaceEx(result, "<<", "\\");
	result = replaceEx(result, ">>", "\\-");
	result = replaceEx(result, "(max)", cstr(OP_MAX));
	result = replaceEx(result, "(min)", cstr(OP_MIN));
	result = replaceEx(result, "(imp)", cstr(OP_IMP));
	if (result != "(pi)")
		result = replaceEx(result, "(pi)", PI_STR);
	result = replaceEx(result, "(e)", "exp(1)");
	result = replaceEx(result, "()", "(0)");
	result = replaceEx(result, ")(", ")*(");
	return result;
}

float TS_Util::bind(float a, char op, float b)
{
	switch (op)
	{
	case '+': return a + b;
	case '-': return a - b;
	case '*': return a * b;
	case '/': return safeDiv2(a, b);
	case '%': return (float) ((int) a % (int) b);
	case '^': return (float) pow(a, b);
	case '>': return a > b;
	case '<': return a < b;
	case OP_GE: return a >= b;
	case OP_LE: return a <= b;
	case OP_EQ: return a == b;
	case OP_NEQ: return a != b;
	case '&': return a && b;
	case '|': return a || b;
	case '#': return (float) ((int) a ^ (int) b);
	case OP_NAND: return !(a && b);
	case OP_NOR: return !(a || b);
	case OP_NXOR: return !((int) a ^ (int) b);
	case OP_BAND: return (float) ((int) a & (int) b);
	case OP_BOR: return (float) ((int) a | (int) b);
	case '\\': return a * (float) pow(2, b);
	case '?': return a ? b : BIG_NUMBER;
	case ':': return a != BIG_NUMBER ? a : b;
	case OP_MAX: return (a > b) ? a : b;
	case OP_MIN: return (a < b) ? a : b;
	case OP_IMP: return !a || b;
	}
	throw Exception("binary operator not found");
}

int TS_Util::rankOp(char op)
{
	switch (op)
	{
	case '@':
		return 12;
	case OP_INC:
	case OP_DEC:
		return 11;
	case OP_BAND:
	case OP_BOR:
		return 10;
	case '^':
		return 9;
	case '*':
	case '/':
	case '%':
	case '\\':
		return 8;
	case '+':
	case '-':
		return 7;
	case '>':
	case '<':
	case OP_GE:
	case OP_LE:
	case OP_EQ:
	case OP_NEQ:
	case OP_MAX:
	case OP_MIN:
		return 6;
	case '&':
	case OP_NAND:
		return 5;
	case '|':
	case '#':
	case OP_NOR:
	case OP_NXOR:
	case OP_IMP:
		return 4;
	case '?':
		return 3;
	case ':':
		return 2;
	case OP_SET:
	case OP_ADD_SET:
	case OP_SUB_SET:
	case OP_MUL_SET:
	case OP_DIV_SET:
	case OP_POW_SET:
		return 1;
	case '(':
	case ')':
		return -1;
	}
	return 0;
}