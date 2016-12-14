#ifndef H_NODE
#define H_NODE

template <class T>
class ListNode
{
	private:
		T mData;

	public:
		ListNode<T> *mPrev;
		ListNode<T> *mNext;

		ListNode(T data, ListNode<T> *prev, ListNode<T> *next);
		~ListNode();
		ListNode<T> *unhinge(bool clip);
		T getData();
		T release();
};

template<class T>
ListNode<T>::ListNode(T data, ListNode<T> *prev, ListNode<T> *next)
{
	mData = data;
	mPrev = prev;
	mNext = next;
	if (prev != NULL)
		prev->mNext = this; // bridge forward
	if (next != NULL)
		next->mPrev = this; // bridge backward
}

template<class T>
ListNode<T>::~ListNode()
{
	if (mData != NULL)
		delete mData;
	if (mNext != NULL)
		delete mNext;
}

template<class T>
ListNode<T> *ListNode<T>::unhinge(bool clip)
{
	if (clip)
	{
		if (mPrev != NULL)
			mPrev->mNext = NULL;
	}
	else
	{
		if (mPrev != NULL)
			mPrev->mNext = mNext; // bridge forward
		if (mNext != NULL)
			mNext->mPrev = mPrev; // bridge backward
		mNext = NULL;
	}
	mPrev = NULL;
	return this;
}

template<class T>
T ListNode<T>::getData()
{
	return mData;
}

template<class T>
T ListNode<T>::release()
{
	T result;

	result = mData;
	mData = NULL;
	return result;
}

#endif