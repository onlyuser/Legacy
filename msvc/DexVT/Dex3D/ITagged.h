#ifndef H_TAGGED
#define H_TAGGED

class ITagged
{
public:
	long mNumID;
	bool mVisible;

	ITagged();
	~ITagged();
};

#endif