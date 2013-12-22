#include "Transform.h"

ScaleTrans::ScaleTrans(Vector &v)
{
	*((Matrix *) this) = IDENT_MATRIX;
	(*this)[0][0] = v.x;
	(*this)[1][1] = v.y;
	(*this)[2][2] = v.z;
}

TranslateTrans::TranslateTrans(Vector &v)
{
	*((Matrix *) this) = IDENT_MATRIX;
	(*this)[3][0] = v.x;
	(*this)[3][1] = v.y;
	(*this)[3][2] = v.z;
}

RotateTrans::RotateTrans(AXIS::AXIS axis, float angle)
{
	*((Matrix *) this) = IDENT_MATRIX;
	float pSin = (float) sin(angle);
	float pCos = (float) cos(angle);
	switch (axis)
	{
		case AXIS::X:
			(*this)[1][1] = pCos;  (*this)[1][2] = pSin;
			(*this)[2][1] = -pSin; (*this)[2][2] = pCos;
			break;
		case AXIS::Y:
			(*this)[0][0] = pCos; (*this)[0][2] = -pSin;
			(*this)[2][0] = pSin; (*this)[2][2] = pCos;
			break;
		case AXIS::Z:
			(*this)[0][0] = pCos;  (*this)[0][1] = pSin;
			(*this)[1][0] = -pSin; (*this)[1][1] = pCos;
	}
}

RotateTrans::RotateTrans(Vector &angle)
{
	*((Matrix *) this) = IDENT_MATRIX;
	(*this) *= RotateTrans(AXIS::Z, angle.roll);
	(*this) *= RotateTrans(AXIS::X, angle.pitch);
	(*this) *= RotateTrans(AXIS::Y, angle.yaw);
}

ComboTrans::ComboTrans(Vector &origin, Vector &angle, Vector &scale)
{
	*((Matrix *) this) = IDENT_MATRIX;
	(*this) *= ScaleTrans((Vector &) scale);
	(*this) *= RotateTrans((Vector &) angle);
	(*this) *= TranslateTrans((Vector &) origin);
}

ProjectTrans::ProjectTrans(float sw, float sh, float n, float f)
{
	if (!inRange(n, 1, f))
		throw Exception("invalid clipping planes");
	*((Matrix *) this) = ZERO_MATRIX;
	cx = sw * 0.5f;
	cy = sh * 0.5f;
}

PerspectTrans::PerspectTrans(float sw, float sh, float aspect, float n, float f, float tanHalf)
	: ProjectTrans(sw, sh, n, f)
{
	float h = tanHalf * n;
	float tempA = -h / n;
	float tempB = -f / (n - f);
	(*this)[0][0] = cx / aspect;
	(*this)[1][1] = -cy;
	(*this)[2][0] = cx * tempA;
	(*this)[2][1] = cy * tempA;
	(*this)[2][2] = tempA * tempB;
	(*this)[2][3] = tempA;
	(*this)[3][2] = h * tempB;
}

OrthoTrans::OrthoTrans(float sw, float sh, float aspect, float n, float f, float zoom)
	: ProjectTrans(sw, sh, n, f)
{
	float tempA = 1 / (n - f);
	(*this)[0][0] = zoom / aspect;
	(*this)[1][1] = -zoom;
	(*this)[2][2] = -tempA;
	(*this)[3][0] = cx;
	(*this)[3][1] = cy;
	(*this)[3][2] = n * tempA;
	(*this)[3][3] = 1;
}