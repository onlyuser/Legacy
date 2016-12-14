#ifndef H_LIST
#define H_LIST

#include "list_node.h"

template <class T>
class List
{
	private:
		ListNode<T> *mHead;
		ListNode<T> *mItem;
		long mCnt;

	public:
		List();
		~List();
		void moveFirst();
		bool eof();
		bool moveNext();
		void moveEnd();
		long find(T);
		void add(T);
		T remove();
		void clear();
		long getIndex();
		void moveTo(long index);
		T getData();
		long count();
};

template<class T>
List<T>::List()
{
	mHead = new ListNode<T>(NULL, NULL, NULL);
	moveFirst(); // reset
	mCnt = 0;
}

template<class T>
List<T>::~List()
{
	delete mHead; // set off chain reaction
}

template<class T>
void List<T>::moveFirst()
{
	mItem = mHead->mNext; // move to first usable node
}

template<class T>
bool List<T>::eof()
{
	return (mItem == NULL);
}

template<class T>
bool List<T>::moveNext()
{
	if (!eof())
	{
		mItem = mItem->mNext;
		return true;
	}
	return false;
}

template<class T>
void List<T>::moveEnd()
{
	while (moveNext());
}

template<class T>
long List<T>::find(T data)
{
	for (moveFirst(); !eof(); moveNext())
		if (getData() == data)
			return getIndex();
	return -1;
}

template<class T>
void List<T>::add(T data)
{
	new ListNode<T>(data, mHead, mHead->mNext); // bridge outward
	mCnt++;
}

template<class T>
T List<T>::remove()
{
	T result;
	ListNode<T> *temp;

	result = NULL;
	if (!eof())
	{
		result = mItem->release();
		temp = mItem->mNext;
		delete mItem->unhinge(false);
		if (temp != NULL)
			moveTo((long) temp);
		else
			moveFirst(); // reset
		mCnt--;
	}
	return result;
}

template<class T>
void List<T>::clear()
{
	moveFirst(); // reset
	if (!eof())
	{
		delete mItem->unhinge(true); // set off chain reaction
		moveFirst(); // reset
		mCnt = 0;
	}
}

template<class T>
long List<T>::getIndex()
{
	return (long) mItem;
}

template<class T>
void List<T>::moveTo(long index)
{
	mItem = (ListNode<T> *) index;
}

template<class T>
T List<T>::getData()
{
	return (!eof()) ? mItem->getData() : NULL;
}

template<class T>
long List<T>::count()
{
	return mCnt;
}

#endif