#ifndef H_TRANSFORM
#define H_TRANSFORM

#include <math.h> // sin(), cos()
#include "Vector.h"
#include "Matrix.h"
#include "Exception.h"

#define ORTHO_VIEW mOrthoView

class ScaleTrans     : public Matrix {public: ScaleTrans(Vector &v);};
class TranslateTrans : public Matrix {public: TranslateTrans(Vector &v);};
class RotateTrans    : public Matrix
{
public:
	RotateTrans(AXIS::AXIS axis, float angle);
	RotateTrans(Vector &angle);
};

class ComboTrans : public Matrix
{
public:
	ComboTrans(
		Vector &origin,
		Vector &angle,
		Vector &scale
		);
};

class ProjectTrans : public Matrix
{
protected:
	float cx;
	float cy;
public:
	ProjectTrans(
		float sw, float sh, float n, float f
		);
};

class PerspectTrans : public ProjectTrans
{
public:
	PerspectTrans(
		float sw, float sh, float aspect, float n, float f,
		float tanHalf
		);
};

class OrthoTrans : public ProjectTrans
{
public:
	OrthoTrans(
		float sw, float sh, float aspect, float n, float f,
		float zoom
		);
};

static TranslateTrans mOrthoView(Vector(0.5f, 0.5f, 0));

#endif