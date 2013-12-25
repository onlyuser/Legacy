#ifndef H_EXCEPTION
#define H_EXCEPTION

#include "string.h"

class Exception
{
private:
	string mData;

public:
	Exception();
	Exception(string data);
	~Exception();
	void setData(string data);
	string getData();
};

#endif