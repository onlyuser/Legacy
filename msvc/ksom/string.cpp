#include "string.h"

//=============================================================================
// TYPE CONVERSION
//=============================================================================

string cstr(bool v){sprintf(mBuf, "%d", (int) v); return string(mBuf);}
string cstr(int v){sprintf(mBuf, "%d", v); return string(mBuf);}
string cstr(float v){sprintf(mBuf, "%f", v); return string(mBuf);}
string cstr(char c){sprintf(mBuf, "%c", c); return string(mBuf);}
string cstr(char *c){return string(c != NULL ? c : "");}
char *c_str(string s){memcpy(mBuf, s.c_str(), s.length() + 1); return mBuf;}

//=============================================================================
// FILE ACCESS
//=============================================================================

string loadText(string filename)
{
	string result;
	FILE *stream;
	int length;
	char *buffer = NULL;

	if (stream = fopen(filename.c_str(), "rb"))
	{
		fseek(stream, 0, SEEK_END); length = ftell(stream);
		fseek(stream, 0, SEEK_SET); length -= ftell(stream);
		buffer = new char[length + 1];
		fread(buffer, sizeof(char), length, stream);
		buffer[length] = 0;
		fclose(stream);
	}
	return string(buffer);
}

void saveText(string filename, string s)
{
	FILE *stream;

	if (stream = fopen(filename.c_str(), "wb"))
	{
		fwrite(s.c_str(), sizeof(char), s.length(), stream);
		fclose(stream);
	}
}

void saveArray(string filename, float *array, int length)
{
	int i;
	FILE *stream;
	string token;

	if (stream = fopen(filename.c_str(), "wb"))
	{
		for (i = 0; i < length; i++)
		{
			token = cstr(array[i]) + "\r\n";
			fwrite(token.c_str(), sizeof(char), token.length(), stream);
		}
		fclose(stream);
	}
}

//=============================================================================
// CONTENT ANALYSIS
//=============================================================================

int findLast(string s, string ptn)
{
	int i;
	int result = -1;

	for (i = s.length() - ptn.length(); i >= 0; i--)
		if (s.substr(i, ptn.length()) == ptn)
		{
			result = i;
			break;
		}
	return result;
}

int countText(string s, string ptn)
{
	int i;
	int result = 0;

	for (i = 0; (i = s.find(ptn, i)) != -1; i += ptn.length())
		result++;
	return result;
}

bool isNumeric(string s)
{
	int i;
	int start;
	bool initZero;
	bool pointMet = false;

	start = (s[0] == '-') ? 1 : 0;
	if (start < s.length())
		initZero = (s[start] == '0');
	else
		return false;
	for (i = start; i < s.length(); i++)
		if (isdigit(s[i]))
		{
			if (!pointMet && i != start && initZero)
				return false;
		}
		else if (s[i] == '.')
			if (i == start || pointMet || i == s.length() - 1)
				return false;
			else
				pointMet = true;
		else
			return false;
	return true;
}

bool patternMatch(string s, string ptn)
{
	int i = 0;
	int j = 0;
	bool result = true;
	string term;
	string term2;

	term = scanText(ptn, i, "*");
	term2 = scanText(s, j, term);
	if (term2 != "")
		result = false;
	while (i < ptn.length())
	{
		term = scanText(ptn, i, "*");
		term2 = scanText(s, j, term);
		if (j >= s.length() && i < ptn.length())
			result = false;
	}
	if (right(s, term.length()) != term && right(ptn, 1) != "*")
		result = false;
	return result;
}

//=============================================================================
// CONTENT MANIPULATION
//=============================================================================

string ucase(string s)
{
	int i;

	for (i = 0; i < s.length(); i++)
		mBuf[i] = toupper(s[i]);
	mBuf[i] = 0;
	return string(mBuf);
}

string lcase(string s)
{
	int i;

	for (i = 0; i < s.length(); i++)
		mBuf[i] = tolower(s[i]);
	mBuf[i] = 0;
	return string(mBuf);
}

string trim(string s)
{
	int i, j;

	for (i = 0; i < s.length() && s[i] == ' '; i++);
	for (j = s.length() - 1; j >= 0 && s[j] == ' '; j--);
	return s.substr(i, j - i + 1);
}

string editReplacePtn(string s, string before, string after, string repPtn)
{
	int i;
	string result;
	char c;
	bool ignore = false;
	string buffer;

	if (before.length() != 0)
	{
		for (i = 0; i < s.length(); i++)
		{
			c = s[i];
			if (!ignore)
			{
				if (s.substr(i, before.length()) == before)
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
	}
	return result;
}

string editSmartReplace(string s, string ptn, string repPtn)
{
	string result;

	result = s;
	result = editReplace(result, repPtn, ptn);
	result = editReplace(result, ptn, repPtn);
	return result;
}

string editDespace(string s)
{
	string result;

	result = s;
	result = editReplace(result, " ", "");
	result = editReplace(result, "\n", "");
	result = editReplace(result, "\r", "");
	result = editReplace(result, "\t", "");
	return result;
}

string editDeRepeat(string s, char c)
{
	int i;
	string result;
	char curChar, prevChar;

	for (i = 0; i < s.length(); i++)
	{
		curChar = s[i];
		if (curChar != prevChar)
			result.append(cstr(curChar));
		else
			if (curChar != c)
				result.append(cstr(curChar));
		prevChar = curChar;
	}
	return result;
}

string editRepeat(string s, int n)
{
	int i;
	string result;

	for (i = 0; i < n; i++)
		result.append(s);
	return result;
}

string editReverse(string s, string sepTerm)
{
	int i = 0;
	string result;

	while (i < s.length())
		result.insert(0, scanText(s, i, sepTerm)).insert(0, sepTerm);
	if (result != "")
		result = result.substr(1, result.length() - 1);
	return result;
}

//=============================================================================
// CONTENT EXTRACTION
//=============================================================================

string scanText(string s, int &start, string ptn)
{
	string result;
	int pos;

	pos = s.find(ptn, start);
	if (pos == -1)
		pos = s.length();
	result = s.substr(start, pos - start);
	start = (pos != s.length()) ? pos + ptn.length() : pos;
	return result;
}

string getEntry(string s, string sepTerm, int n)
{
	int i = 0;
	string result;
	string term;
	int cnt = 0;

	while (i < s.length())
	{
		term = scanText(s, i, sepTerm);
		if (cnt == n)
		{
			result = term;
			break;
		}
		cnt++;
	}
	return result;
}

string getBtw(string s, int &start, string before, string after)
{
	string result;

	scanText(s, start, before);
	result = scanText(s, start, after);
	if (start == s.length() && right(s, after.length()) != after)
		result = "";
	return result;
}

string getNextTerm(string s, int &start)
{
	int i;
	string result;

	if (start < s.length())
	{
		for (i = start; i < s.length(); i++)
			if (!isTerm(s[i]))
			{
				result = s.substr(start, i - start);
				start = i;
				break;
			}
		if (result == "")
		{
			if (i != start)
				result = s.substr(start, i - start);
			else
				result = s.substr(i, 1);
			start += result.length();
		}
	}
	return result;
}

string getShellPtn(string s, int &start, string before, string after)
{
	string result;
	int depth = 1;
	string term;

	scanText(s, start, before);
	while (start < s.length())
	{
		term = getNextTerm(s, start);
		depth += (term == before) ? 1 : 0;
		depth -= (term == after) ? 1 : 0;
		if (depth != 0)
			result.append(term);
		else
			break;
	}
	if (depth != 0)
		result = "";
	return result;
}