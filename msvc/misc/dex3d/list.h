#ifndef H_LIST
#define H_LIST

#include "node.h"

template <class T>
class sList
{
	private:
		sNode<T> *mHead;
		sNode<T> *mItem;
		long mCount;

	public:
		sList();
		~sList();
		void add(T);
		void remove();
		void clear();
		void moveFirst();
		void moveNext();
		T getData();
		bool find(T);
		long count();
		bool eof();
		long index();
		void toIndex(long);
};

template<class T>
sList<T>::sList()
{
	mHead = new sNode<T>(NULL, NULL, NULL);
	moveFirst(); // reset
	mCount = 0;
}

template<class T>
sList<T>::~sList()
{
	delete mHead; // set off chain reaction
}

template<class T>
void sList<T>::add(T data)
{
	sNode<T> *a;

	a = new sNode<T>(data, mHead, mHead->mNext); // bridge outward
	if (mHead->mNext != NULL) // if next node exists
		mHead->mNext->mPrev = a; // bridge backward
	mHead->mNext = a; // bridge forward
	moveFirst(); // reset
	mCount++;
}

template<class T>
void sList<T>::remove()
{
	if (mItem != NULL)
	{
		mItem->mPrev->mNext = mItem->mNext; // bridge forward
		if (mItem->mNext != NULL) // if next node exists
		{
			mItem->mNext->mPrev = mItem->mPrev; // bridge backward
			mItem->mNext = NULL; // unhinge
		}
		delete mItem; // delete
		moveFirst(); // reset
		mCount--;
	}
}

template<class T>
void sList<T>::clear()
{
	moveFirst(); // reset
	delete mItem; // set off chain reaction
	mCount = 0;
}

template<class T>
void sList<T>::moveFirst()
{
	mItem = mHead->mNext; // move to first usable node
}

template<class T>
void sList<T>::moveNext()
{
	if (mItem != NULL)
		mItem = mItem->mNext;
}

template<class T>
T sList<T>::getData()
{
	if (mItem != NULL)
		return mItem->mData;
	return NULL;
}

template<class T>
bool sList<T>::find(T data)
{
	for (moveFirst(); getData() != NULL; moveNext())
		if (getData() == data)
			return true;
	return false;
}

template<class T>
long sList<T>::count()
{
	return mCount;
}


template<class T>
bool sList<T>::eof()
{
	if (mItem == NULL)
		return true;
	return false;
}

template<class T>
long sList<T>::index()
{
	long result;
	sNode<T> *a;

	result = 0;
	for (a = mHead->mNext; a != NULL; a = a->mNext)
	{
		if (a == mItem)
			return ((mCount - 1) - result);
		result++;
	}
	return -1;
}

template<class T>
void sList<T>::toIndex(long index)
{
	int i;

	i = 0;
	for (moveFirst(); getData() != NULL; moveNext())
	{
		if (i == ((mCount - 1) - index))
			return;
		i++;
	}
}

#endif
