#ifndef H_LIST
#define H_LIST

#include <stdio.h> // sprintf()

template<class T>
class List
{
public:
	T *mItem;
	int mMax;
	int mCount;

	List(int max)
	{
		mItem = new T[max];
		mMax = max;
		mCount = 0;
	}

	~List()
	{
		delete []mItem;
	}

	void add(T item)
	{
		if (mCount < mMax)
		{
			mItem[mCount] = item;
			mCount++;
		}
	}

	void print(char *string, int &byte)
	{
		int i;

		for (i = 0; i < mCount; i++)
			byte += sprintf(&string[byte], "%d, ", mItem[i]->mIndex);
	}
};

#endif
