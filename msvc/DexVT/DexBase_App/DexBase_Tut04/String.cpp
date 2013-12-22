#include "String.h"

//=============================================================================
// TYPE CONVERSION
//=============================================================================

std::string cstr(bool v)  {sprintf(mBuf, "%d", (int) v); return cstr((char *) mBuf);}
std::string cstr(int v)   {sprintf(mBuf, "%d", v); return cstr((char *) mBuf);}
std::string cstr(float v) {sprintf(mBuf, "%f", v); return cstr((char *) mBuf);}
std::string cstr(char c)  {sprintf(mBuf, "%c", c); return cstr((char *) mBuf);}
std::string cstr(char *c) {return std::string((c != NULL) ? c : "");}

//=============================================================================
// CONTENT CREATION
//=============================================================================

std::string repeat(std::string s, int n)
{
	std::string result;
	for (int i = 0; i < n; i++)
		result.append(s);
	return result;
}

std::string changeBase(std::string expr, int base, int newBase)
{
	std::string result;
	std::string temp = cstr((char *) mHexPool);
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
		result.append(cstr(temp[coef]));
		sum -= coef * expo;
	}
	return result;
}

//=============================================================================
// FILE ACCESS
//=============================================================================

std::string loadText(std::string &filename)
{
	if (FILE *stream = fopen(filename.c_str(), "rb"))
	{
		fseek(stream, 0, SEEK_END);
		int size = ftell(stream);
		rewind(stream);
		char *buffer = new char[size + 1];
		fread(buffer, sizeof(char), size, stream);
		buffer[size] = 0;
		std::string result = cstr((char *) buffer);
		delete []buffer;
		fclose(stream);
		return result;
	}
	throw Exception("cannot read from file");
}

void saveText(std::string &filename, std::string s)
{
	if (FILE *stream = fopen(filename.c_str(), "wb"))
	{
		fwrite(s.c_str(), sizeof(char), s.length(), stream);
		fclose(stream);
		return;
	}
	throw Exception("cannot write to file");
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
	int start = (s[0] == '-') ? 1 : 0;
	if (start == s.length())
		return false;
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
	int i = 0, j = 0;
	std::string term, term2;
	do
	{
		term = scanText(ptn, i, "*");
		term2 = (term == "") ? "" : scanText(s, j, term);
		if (j == s.length() && i < ptn.length())
			return false;
	}
	while (i < ptn.length());
	if (right(s, term.length()) != term && right(ptn, 1) != "*")
		return false;
	return true;
}

bool isVowel(char c)
{
	for (int i = 0; i < strlen(mVowelPool); i++)
		if (mVowelPool[i] == c)
			return true;
	return false;
}

//=============================================================================
// CONTENT MANIPULATION
//=============================================================================

std::string ucase(std::string &s)
{
	for (int i = 0; i < s.length(); i++)
		mBuf[i] = toupper(s[i]);
	mBuf[i] = 0;
	return cstr((char *) mBuf);
}

std::string lcase(std::string &s)
{
	for (int i = 0; i < s.length(); i++)
		mBuf[i] = tolower(s[i]);
	mBuf[i] = 0;
	return cstr((char *) mBuf);
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
			result.insert(0, cstr(c) + result);
		else
			result.append(cstr(c));
	return result;
}

std::string replacePtn(std::string &s, std::string before, std::string after, std::string repPtn)
{
	std::string result;
	std::string buffer;
	bool ignore = false;
	for (int i = 0; i < s.length(); i++)
	{
		char c = s[i];
		if (!ignore)
		{
			if (before != "" && s.substr(i, before.length()) == before)
			{
				ignore = true;
				i += before.length() - 1;
			}
			else
				result.append(cstr(c));
		}
		else
			if (s.substr(i, after.length()) == after)
			{
				ignore = false;
				i += after.length() - 1;
				result.append(repPtn);
				buffer = "";
			}
			else
				buffer.append(cstr(c));
	}
	if (ignore)
		if (after != "")
			result.append(before).append(buffer); // restore ignored
		else
			result.append(repPtn); // coerce tail replace
	return result;
}

std::string replaceEx(std::string &s, std::string ptn, std::string repPtn)
{
	std::string result = s;
	result = replace(result, repPtn, ptn);
	result = replace(result, ptn, repPtn);
	return result;
}

std::string despace(std::string &s)
{
	std::string result = s;
	result = replace(result, " ", "");
	result = replace(result, VBCRLF, "");
	result = replace(result, "\t", "");
	return result;
}

std::string despaceUnix(std::string &s)
{
	std::string result = s;
	result = replace(result, " ", "");
	result = replace(result, VBLF, "");
	result = replace(result, "\t", "");
	return result;
}

std::string deRepeat(std::string &s, char c)
{
	std::string result;
	char prevChar = 0;
	for (int i = 0; i < s.length(); i++)
	{
		if (prevChar == 0 || s[i] != prevChar || s[i] != c)
			result.append(cstr(s[i]));
		prevChar = s[i];
	}
	return result;
}

std::string reverse(std::string &s, std::string sepTerm)
{
	std::string result;
	int i = 0;
	while (i < s.length())
		result.insert(0, sepTerm + scanText(s, i, sepTerm));
	if (result != "")
		return right(result, result.length() - 1);
	return result;
}

//=============================================================================
// CONTENT EXTRACTION
//=============================================================================

std::string scanText(std::string &s, int &start, std::string ptn)
{
	int pos = (ptn == "") ? -1 : s.find(ptn, start);
	if (pos == -1)
		pos = s.length();
	std::string result = s.substr(start, pos - start);
	start = limit(pos + ptn.length(), 0, s.length());
	return result;
}

std::string getEntry(std::string &s, std::string sepTerm, int n)
{
	int count = 0;
	int i = 0;
	while (i < s.length())
	{
		std::string term = scanText(s, i, sepTerm);
		if (count == n)
			return term;
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
			return path.substr(slashPos2 + 1, dotPos - slashPos2 - 1);
		case PATH::EXTEN: return right(path, path.length() - (dotPos + 1));
	}
	return "";
}

std::string getNextTerm(std::string &s, int &start)
{
	std::string result;
	for (int i = start; i < s.length(); i++)
		if (!isTerm(s[i]))
		{
			result = s.substr(start, i - start);
			start = i;
			break;
		}
	if (result == "") // nothing found
	{
		if (i == s.length())
			result = right(s, s.length() - start); // return rest
		else
			result = s.substr(start, 1); // return one char
		start += result.length();
	}
	return result;
}

std::string getShellPtn(std::string &s, int &start, std::string before, std::string after)
{
	std::string result;
	int depth = 0;
	while (start < s.length())
	{
		std::string term = getNextTerm(s, start);
		depth += (term == before) ? 1 : 0;
		depth += (term == after) ? -1 : 0;
		if (depth)
		{
			if (depth > 0)
				result.append(term);
			else
				break;
		}
		else
			if (term == after)
				break;
	}
	if (depth)
		return "";
	return result;
}