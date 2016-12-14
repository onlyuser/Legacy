#ifndef H_ISORTABLE
#define H_ISORTABLE

#include <list> // std::list
#include <queue> // std::priority_queue
#include <algorithm> // std::sort
#include <utility> // std::pair
#include "Util.h" // TCompare

//=============================================================================
// LOGIC FUNCTOR

template<class T> class TSortAsc : public TCompare<T>
	{public: bool operator()(T a, T b) const {return a < b;}};
template<class T> class TSortDesc : public TCompare<T>
	{public: bool operator()(T a, T b) const {return a > b;}};
template<class T> class TSortAbsAsc : public TCompare<T>
	{public: bool operator()(T a, T b) const {return fabs(a) < fabs(b);}};
template<class T> class TSortAbsDesc : public TCompare<T>
	{public: bool operator()(T a, T b) const {return fabs(a) > fabs(b);}};

//=============================================================================
// SORT MACRO

template<class T1, class T2, class T3, class T4, class T5>
static void _sort(T3 *key, T4 *data, int cnt)
{
	typedef ISortable<T1, T2 *, T5> T6;
	std::vector<T6 *> list;
	for (int i = 0; i < cnt; i++)
		list.push_back(new T6((*key)[i], &(*data)[i]));
	std::sort(list.begin(), list.end(), T6());
	//=========================================================
	T2 *tmp = new T2[cnt];
	for (int j = 0; j < cnt; j++)
	{
		(*key)[j] = (*list[j]).first;
		tmp[j] = *(*list[j]).second; // cannot do this "in-place"
	}
	for (int k = 0; k < cnt; k++)
		(*data)[k] = tmp[k];
	delete []tmp;
	//=========================================================
	std::for_each(list.begin(), list.end(), std::kill());
}
template<class T1, class T2, class T3, class T4, class T5>
static void _sortPQ(T3 *r_key, T4 *r_data, T3 *key, T4 *data, int cnt, int k)
{
	typedef ISortable<T1, T2 *, T5> T6;
	assert(k <= cnt);
	std::priority_queue<T6 *> queue(T6());
	for (int i = 0; i < cnt; i++)
		queue.push(new T6((*key)[i], &(*data)[i]));
	for (int j = 0; j < k; j++)
	{
		T6 *top = queue.top();
		(*r_key)[j] = (*top).first;
		(*r_data)[j] = *(*top).second; // new dest (not "in-place")
		delete top;
		queue.pop();
	}
}

//=============================================================================
// CLASS DEF

template<class T1, class T2, class T3 = TSortAsc<T1> >
class ISortable :
	public std::pair<T1, T2>, // has "first" and "second" just like std::pair
	public TCompare<ISortable<T1, T2, T3> *> // uses operator(), returns bool
{
private:
	typedef ISortable<T1, T2, T3> T4;
	T3 mCompare;
public:
	ISortable();
	~ISortable();
	//=========================================================
	// constructor
	ISortable(T1 key, T2 data);
	//=========================================================
	// operator overload
	bool operator()(T4 *x, T4 *y) const;
	bool operator<(const T4 &other) const;
	//=========================================================
	// static tools
	static void sort(T1 *key, T2 *data, int cnt);
	static void sort(std::vector<T1> &key, std::vector<T2> &data);
	static void sortPQ(T1 *r_key, T2 *r_data, T1 *key, T2 *data, int cnt, int k);
	static void sortPQ(
		std::vector<T1> &r_key, std::vector<T2> &r_data,
		std::vector<T1> &key, std::vector<T2> &data, int k
		);
	//=========================================================
};

template<class T1, class T2, class T3> ISortable<T1, T2, T3>::ISortable() :
	std::pair<T1, T2>(0, 0) {}
template<class T1, class T2, class T3> ISortable<T1, T2, T3>::~ISortable() {}

//=============================================================================
// CONSTRUCTOR

template<class T1, class T2, class T3>
ISortable<T1, T2, T3>::ISortable(T1 key, T2 data) :
	std::pair<T1, T2>(key, data) {}

//=============================================================================
// OPERATOR OVERLOAD

// for pointers..
// USAGE: use ISortable as predicate for std::sort
template<class T1, class T2, class T3>
bool ISortable<T1, T2, T3>::operator()(T4 *x, T4 *y) const
	{return *x < *y;}

// for values..
// USAGE: have contained class inherit from ISortable
// NOTE: do not supply predicate to std::sort!
template<class T1, class T2, class T3>
bool ISortable<T1, T2, T3>::operator<(const T4 &other) const
	{return mCompare(first, other.first);}

//=============================================================================
// STATIC TOOLS

// for lazy people..
// USAGE: make two random access arrays with paired data, specify sort order
// NOTE: T2 must implement assign!
template<class T1, class T2, class T3>
void ISortable<T1, T2, T3>::sort(T1 *key, T2 *data, int cnt)
	{_sort<T1, T2, T1 *, T2 *, T3>(&key, &data, cnt);}
template<class T1, class T2, class T3>
void ISortable<T1, T2, T3>::sort(std::vector<T1> &key, std::vector<T2> &data)
{
	assert(key.size() == data.size());
	_sort<T1, T2, std::vector<T1>, std::vector<T2>, T3>(
		&key, &data, key.size()
		);
}
template<class T1, class T2, class T3>
void ISortable<T1, T2, T3>::sortPQ(
	T1 *r_key, T2 *r_data, T1 *key, T2 *data, int cnt, int k
	)
	{_sortPQ<T1, T2, T1 *, T2 *, T3>(&r_key, &r_data, &key, &data, cnt, k);}
template<class T1, class T2, class T3>
void ISortable<T1, T2, T3>::sortPQ(
	std::vector<T1> &r_key, std::vector<T2> &r_data,
	std::vector<T1> &key, std::vector<T2> &data, int k
	)
{
	assert(key.size() == data.size());
	r_key.resize(k);
	r_data.resize(k);
	_sortPQ<T1, T2, std::vector<T1>, std::vector<T2>, T3>(
		&r_key, &r_data, &key, &data, key.size(), k
		);
}

#endif