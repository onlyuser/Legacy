#include "String.h"

//=============================================================================
// TYPE CONVERSION
//=============================================================================

std::string cstr(bool v)  {sprintf(mBuf, "%d", (int) v); return cstr(mBuf);}
std::string cstr(int v)   {sprintf(mBuf, "%d", v); return cstr(mBuf);}
std::string cstr(float v) {sprintf(mBuf, "%f", v); return cstr(mBuf);}
std::string cstr(char c)  {sprintf(mBuf, "%c", c); return cstr(mBuf);}
std::string cstr(char *c) {return std::string((c != NULL) ? c : "");}

//=============================================================================
// CONTENT CREATION
//=============================================================================

std::string repeat(std::string s, int n)
{
	std::string result;
	for (int i = 0; i < n; i++)
		result += s;
	return result;
}

std::string changeBase(std::string expr, int base, int newBase)
{
	std::string result;
	std::string temp = cstr(mHexPool);
	long sum = 0;
	for (int i = 0; i < expr.length(); i++)
	{
		long coef = temp.find(cstr(expr[i]));
		long expo = (long) pow(base, (expr.length() - 1) - i);
		sum += coef * expo;
	}
	for (int j = (int) (log((float) sum) / log((float) newBase)); j >= 0; j--)
	{
		long expo = (long) pow(newBase, j);
		long coef = sum / expo;
		result += cstr(temp[coef]);
		sum -= coef * expo;
	}
	return result;
}

//=============================================================================
// FILE ACCESS
//=============================================================================

std::string loadText(std::string filename)
{
	if (FILE *stream = fopen(filename.c_str(), "rb"))
	{
		fseek(stream, 0, SEEK_END);
		int size = ftell(stream);
		rewind(stream);
		char *buffer = new char[size + 1];
		fread(buffer, sizeof(char), size, stream);
		buffer[size] = 0;
		std::string result = cstr(buffer);
		delete []buffer;
		fclose(stream);
		return result;
	}
	throw new Exception("cannot read from file");
}

void saveText(std::string filename, std::string s)
{
	if (FILE *stream = fopen(filename.c_str(), "wb"))
	{
		fwrite(s.c_str(), sizeof(char), s.length(), stream);
		fclose(stream);
		return;
	}
	throw new Exception("cannot write to file");
}

//=============================================================================
// CONTENT ANALYSIS
//=============================================================================

int findLast(std::string &s, std::string ptn)
{
	for (int i = s.length() - ptn.length(); i >= 0; i--)
		if (s.substr(i, ptn.length()) == ptn)
			return i;
	return -1;
}

int countText(std::string &s, std::string ptn)
{
	int result = 0;
	for (int i = 0; (i = s.find(ptn, i)) != -1; i += ptn.length())
		result++;
	return result;
}

bool isNumeric(std::string &s)
{
	if (s == "-")
		return false;
	int start = (s[0] == '-');
	bool pointMet = false;
	for (int i = start; i < s.length(); i++)
		if (!isdigit(s[i]))
			if (s[i] == '.')
			{
				if (pointMet || i == start || i == s.length() - 1)
					return false;
				pointMet = true;
			}
			else
				return false;
	return true;
}

bool matchPtn(std::string &s, std::string ptn)
{
	std::string token;
	int i = 0;
	token = scanText(ptn, i, "*"); // find first *
	if (left(s, token.length()) != token && ptn[0] != '*')
		return false;
	int j = 0;
	while (i < ptn.length())
	{
		token = scanText(ptn, i, "*"); // keep scanning for *
		if (token != "")
			scanText(s, j, token); // update j to match i's progress
		if (j == s.length() && i < ptn.length()) // if j done, but i not yet
			return false;
	}
	if (right(s, token.length()) != token && right(ptn, 1) != "*")
		return false;
	return true;
}

//=============================================================================
// CONTENT MANIPULATION
//=============================================================================

std::string ucase(std::string &s)
{
	for (int i = 0; i < s.length(); i++)
		mBuf[i] = toupper(s[i]);
	mBuf[i] = 0;
	return cstr(mBuf);
}

std::string lcase(std::string &s)
{
	for (int i = 0; i < s.length(); i++)
		mBuf[i] = tolower(s[i]);
	mBuf[i] = 0;
	return cstr(mBuf);
}

std::string trim(std::string &s)
{
	for (int i = 0; i < s.length() && s[i] == ' '; i++);
	for (int j = s.length() - 1; j >= 0 && s[j] == ' '; j--);
	return s.substr(i, j - i + 1);
}

std::string pad(std::string &s, char c, int n, bool padLeft)
{
	std::string result = s;
	while (result.length() < n)
		if (padLeft)
			result = cstr(c) + result;
		else
			result += cstr(c);
	return result;
}

std::string replacePtn(std::string &s, std::string before, std::string after, std::string repPtn)
{
	std::string result;
	int i = 0;
	while (i < s.length())
	{
		result += scanText(s, i, before);
		if (i < s.length() || right(s, before.length()) == before)
		{
			if (after != "")
			{
				std::string rest = scanText(s, i, after);
				if (i < s.length() || right(s, after.length()) == after)
					result += repPtn;
				else
					result += before + rest;
			}
			else
				result += repPtn;
		}
	}
	return result;
}

std::string replaceSmart(std::string &s, std::string ptn, std::string repPtn)
{
	std::string result = s;
	result = replaceEx(result, repPtn, ptn);
	result = replaceEx(result, ptn, repPtn);
	return result;
}

std::string despaceEx(std::string &s, bool unix)
{
	std::string result = s;
	result = replaceEx(result, " ", "");
	result = replaceEx(result, unix ? VBLF : VBCRLF, "");
	result = replaceEx(result, "\t", "");
	return result;
}

std::string deRepeat(std::string &s, char c)
{
	std::string result;
	char prevChar = 0;
	for (int i = 0; i < s.length(); i++)
	{
		if (prevChar == 0 || s[i] != prevChar || s[i] != c)
			result += cstr(s[i]);
		prevChar = s[i];
	}
	return result;
}

std::string reverse(std::string &s, std::string sepPtn)
{
	std::string result;
	int i = 0;
	while (i < s.length())
		result = sepPtn + scanText(s, i, sepPtn) + result;
	if (result != "")
		return right(result, result.length() - sepPtn.length());
	return result;
}

//=============================================================================
// CONTENT EXTRACTION
//=============================================================================

std::string scanText(std::string &s, int &start, std::string ptn)
{
	int pos = (ptn != "") ? s.find(ptn, start) : -1;
	if (pos == -1)
		pos = s.length();
	std::string result = s.substr(start, pos - start);
	start = limit(pos + ptn.length(), 0, s.length());
	return result;
}

std::string scanTextEx(std::string &s, int &start, std::string ptn)
{
	int bestPos = s.length();
	if (ptn != "")
		for (int i = 0; i < ptn.length(); i++)
		{
			int pos = s.find(ptn[i], start);
			if (pos == -1)
				pos = s.length();
			if (pos < bestPos)
				bestPos = pos;
		}
	std::string result = s.substr(start, bestPos - start);
	start = limit(bestPos + 1, 0, s.length());
	return result;
}

std::string getEntry(std::string &s, std::string sepPtn, int n)
{
	int count = 0;
	int i = 0;
	while (i < s.length())
	{
		std::string token = scanText(s, i, sepPtn);
		if (count == n)
			return token;
		count++;
	}
	return "";
}

std::string getBtw(std::string &s, int &start, std::string before, std::string after)
{
	scanText(s, start, before);
	std::string result = scanText(s, start, after);
	if (start == s.length() && right(s, after.length()) != after)
		return "";
	return result;
}

std::string getPathPart(std::string path, PATH::PATH part)
{
	int slashPos = path.find("\\");
	int dotPos = findLast(path, ".");
	int slashPos2 = findLast(path, "\\");
	switch (part)
	{
		case PATH::DRIVE: return left(path, slashPos + 1);
		case PATH::DIR: return left(path, slashPos2 + 1);
		case PATH::NAME: return right(path, path.length() - (slashPos2 + 1));
		case PATH::NAME_ONLY:
			return path.substr(slashPos2 + 1, dotPos - (slashPos2 + 1));
		case PATH::EXTEN: return right(path, path.length() - (dotPos + 1));
	}
	return "";
}

std::string getLineEx(std::string &s, int &start, bool unix)
{
	std::string sepPtn = unix ? VBLF : VBCRLF;
	int begin = s.rfind(sepPtn, start);
	if (begin == -1)
		begin = -sepPtn.length();
	int end = s.find(sepPtn, start + 1);
	if (end == -1)
		end = s.length();
	return s.substr(begin + sepPtn.length(), end - begin - sepPtn.length());
}

std::string getNextTerm(std::string &s, int &start)
{
	for (int i = start; i <= s.length(); i++)
		if (i == s.length() || !isTermToken(s[i]))
		{
			std::string result = s.substr(start, max(i - start, 1));
			start += result.length();
			return result;
		}
	return "";
}

std::string getShellPtn(std::string &s, int &start, std::string before, std::string after)
{
	std::string result;
	int depth = 0;
	while (start < s.length())
	{
		std::string token = getNextTerm(s, start);
		if (token == before) depth++;
		if (token == after) depth--;
		if (depth)
			result += token;
		else
			if (token == after)
				break;
	}
	if (result != "")
		return right(result, result.length() - 1);
	return "";
}