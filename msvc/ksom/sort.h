#ifndef H_SORT
#define H_SORT

#include "util.h"

template<class T1, class T2, class T3>
inline void swapEx(T1 *key, T2 *ptr, T3 a, T3 b)
{
	swap(key[a], key[b]);
	swap(ptr[a], ptr[b]);
}

template<class T1, class T2, class T3>
void sort(T1 *key, T2 *ptr, T3 first, T3 last)
{
	T3 a, b;

	if (first >= last)
		return;
	if (last - first == 1)
	{
		if (key[first] > key[last])
			swapEx(key, ptr, first, last);
		return;
	}
	swapEx(key, ptr, (T3) randEx(first, last), last);
	do
	{
		a = first;
		b = last;
		for (; a < b && key[a] <= key[last]; a++);
		for (; b > a && key[b] >= key[last]; b--);
		if (a < b)
			swapEx(key, ptr, a, b);
	}
	while (a != b);
	swapEx(key, ptr, a, last);
	sort(key, ptr, first, a - 1); sort(key, ptr, a + 1, last);
}

#endif