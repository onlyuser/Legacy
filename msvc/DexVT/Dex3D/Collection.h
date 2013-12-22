#ifndef H_COLLECTION
#define H_COLLECTION

#include <memory.h> // memset()
#include <algorithm> // std::sort()
#include <vector> // std::vector
#include <map> // std::map
#include "ISortable.h"
#include "String.h"
#include "Exception.h"
#include "Util.h" // BIG_NUMBER

#define UID_FLOAT ((float) incre(mKey, BIG_NUMBER) + 1)

static int mKey = 0;

template<class T, class K = std::string>
class Collection
{
private:
	std::vector<T> mList;
	std::map<K, T> mTable;
	std::map<T, K> mTableR;
	T mNullData;
	K mNullKey;
public:
	Collection();
	~Collection();
	//=============================================================================
	void add(K key, T data);
	void remove(T data);
	void clear();
	void sort();
	//=============================================================================
	int size();
	std::vector<T>::iterator begin();
	std::vector<T>::iterator end();
	//=============================================================================
	T &operator[](int index);
	T &operator[](K key);
	K &operator[](T data);
	//=============================================================================
};

template<class T, class K>
Collection<T, K>::Collection()
{
	memset(&mNullData, 0, sizeof(T));
	memset(&mNullKey, 0, sizeof(K));
}

template<class T, class K>
Collection<T, K>::~Collection()
{
	this->clear();
}

//=============================================================================

template<class T, class K = std::string>
void listAdd(Collection<T, K> &list, T data)
{
	list.add(cstr(incre(mKey, BIG_NUMBER)), data);
}

template<class T, class K>
void Collection<T, K>::add(K key, T data)
{
	if (
		mTable.find(key) == mTable.end() &&
		mTableR.find(data) == mTableR.end()
		)
	{
		//=====================================
		mList.push_back(data);
		mTable[key] = data;
		mTableR[data] = key;
		//=====================================
	}
	else
		throw Exception("data already exists");
}

template<class T, class K>
void Collection<T, K>::remove(T data)
{
	if (mTableR.find(data) != mTableR.end())
	{
		//=====================================
		std::vector<T>::iterator p =
			std::find(mList.begin(), mList.end(), data);
		mList.erase(p);
		mTable.erase(mTableR[data]);
		mTableR.erase(data);
		//=====================================
	}
	else
		throw Exception("data not found");
}

template<class T, class K>
void Collection<T, K>::clear()
{
	//=====================================
	mList.clear();
	mTable.clear();
	mTableR.clear();
	//=====================================
}

template<class T, class K>
void Collection<T, K>::sort()
{
	std::sort(mList.begin(), mList.end(), ISortable());
}

//=============================================================================

template<class T, class K>
int Collection<T, K>::size()
{
	return mList.size();
}

template<class T, class K>
std::vector<T>::iterator Collection<T, K>::begin()
{
	return mList.begin();
}

template<class T, class K>
std::vector<T>::iterator Collection<T, K>::end()
{
	return mList.end();
}

//=============================================================================

template<class T, class K>
T &Collection<T, K>::operator[](int index)
{
	return mList[index];
}

template<class T, class K>
T &Collection<T, K>::operator[](K key)
{
	if (mTable.find(key) != mTable.end())
		return mTable[key];
	return mNullData;
}

template<class T, class K>
K &Collection<T, K>::operator[](T data)
{
	if (mTableR.find(data) != mTableR.end())
		return mTableR[data];
	return mNullKey;
}

#endif