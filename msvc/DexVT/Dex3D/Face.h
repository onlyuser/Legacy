#ifndef H_FACE
#define H_FACE

#include <algorithm> // std::swap()
#include "ISortable.h"
#include "Vector.h"
#include "TDexGL.h" // DEXGL_TRI

class Face : public ISortable
{
public:
	union
	{
		long v[3];
		struct
		{
			long a, b, c;
		};
	};
	bool mDraw;

	Face(int a, int b, int c);
	~Face();
	//=============================================================================
	void set(int a, int b, int c);
	void flip();
	//=============================================================================
	void toArray(long *v);
	//=============================================================================
	Vector center(Vector *v);
	float depth(Vector *v);
	Vector normal(Vector *v);
	float shade(Vector *v, Vector &p);
	//=============================================================================
	bool sectPoint(Vector *v, Vector &p);
	float sectRay(Vector *v, Vector &p1, Vector &p2);
	//=============================================================================
	void paint(Vector *v, long color, DEXGL_TRI funcTri);
	//=============================================================================
};

#endif