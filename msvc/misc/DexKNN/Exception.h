#ifndef H_EXCEPTION
#define H_EXCEPTION

template<class T = const char *>
class Exception
{
private:
	T mData;
public:
	Exception(Exception &e);
	Exception(T data);
	~Exception();
	T getData();
};

template<class T> Exception<T>::Exception(Exception &e) {mData = e.getData();}
template<class T> Exception<T>::Exception(T data) {mData = data;}
template<class T> Exception<T>::~Exception() {}
template<class T> T Exception<T>::getData() {return mData;}

#endif