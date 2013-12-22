#include "ISortable.h"

ISortable::ISortable() {mSortKey = 0;}
ISortable::~ISortable() {}

// for pointers..
// USAGE: use ISortable as predicate for std::sort
bool ISortable::operator()(ISortable *x, ISortable *y)
{
	return *x < *y;
}

// for values..
// USAGE: have contained class inherit from ISortable
bool ISortable::operator<(ISortable &other)
{
	return mSortKey < other.mSortKey;
}