#ifndef H_SEQ_UTIL
#define H_SEQ_UTIL

#include <stack>
#include <list>
#include "String.h"

template<class T>
void writeSeq(std::stack<T> &pStack, std::string s)
{
	flushStack(pStack);
	int i = 0;
	while (i < s.length())
		pStack.push(scanText(s, i, " "));
}

template<class T>
void writeSeq(std::list<T> &pList, std::string s)
{
	pList.clear();
	int i = 0;
	while (i < s.length())
	{
		std::string token = scanText(s, i, " ");
		pList.push_back(token);
	}
}

template<class T>
std::string readSeq(std::stack<T> &pStack)
{
	std::string result;
	while (!pStack.empty())
		result = " " + popStack(pStack) + result; // build in reverse
	result = trim(result);
	writeSeq(pStack, result);
	return result;
}

template<class T>
std::string readSeq(std::list<T> &pList)
{
	std::string result;
	std::list<T>::iterator p;
	for (p = pList.begin(); p != pList.end(); p++)
		result += *p + " ";
	return trim(result);
}

#endif