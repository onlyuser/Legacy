#ifndef H_NODE
#define H_NODE

template <class T>
class sNode
{
	public:
		T			mData;
		sNode<T>	*mPrev;
		sNode<T>	*mNext;

		sNode(T, sNode<T> *, sNode<T> *);
		~sNode();
};

template<class T>
sNode<T>::sNode(T data, sNode<T> *prev, sNode<T> *next)
{
	mData = data;
	mPrev = prev;
	mNext = next;
}

template<class T>
sNode<T>::~sNode()
{
	if (mData != NULL)
		delete mData;
	if (mNext != NULL)
		delete mNext;
}

#endif
