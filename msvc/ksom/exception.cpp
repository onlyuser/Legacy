#include "exception.h"

Exception::Exception()
{
}

Exception::Exception(string data)
{
	setData(data);
}

Exception::~Exception()
{
}

void Exception::setData(string data)
{
	mData = data;
}

string Exception::getData()
{
	return mData;
}