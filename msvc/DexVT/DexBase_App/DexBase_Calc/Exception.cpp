#include "Exception.h"

Exception::Exception(Exception &e)
{
	mData = e.getData();
}

Exception::Exception(char *data)
{
	mData = data;
}

Exception::~Exception()
{
}

char *Exception::getData()
{
	return mData;
}