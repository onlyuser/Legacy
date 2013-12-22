#ifndef H_EXCEPTION
#define H_EXCEPTION

class Exception
{
private:
	char *mData;
public:
	Exception(Exception &e);
	Exception(char *data);
	~Exception();
	char *getData();
};

#endif