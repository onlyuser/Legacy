#ifndef H_SORTABLE
#define H_SORTABLE

#include <functional> // std::binary_function

class ISortable : public std::binary_function<ISortable *, ISortable *, bool>
{
public:
	float mSortKey;

	ISortable();
	~ISortable();
	bool operator()(ISortable *x, ISortable *y);
	bool operator<(ISortable &other);
};

#endif