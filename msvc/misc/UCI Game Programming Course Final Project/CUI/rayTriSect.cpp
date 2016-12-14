#include "rayTriSect.h"

#define SMALL_NUM 0.00000001

float segTriSect(float *origin, float *dir, float dist, float *vectA, float *vectB, float *vectC)
{
	float result;
	float r, s, t;

	if (rayTriSect(r, s, t, origin, dir, vectA, vectB, vectC))
	{
		result = r / dist;
		if (result > 1)
			result = -1;
	}
	else
		result = -1;
	return result;
}

bool rayTriSect(float &r, float &s, float &t, float *origin, float *dir, float *vectA, float *vectB, float *vectC)
{
	float sect[3];
    float u[3], v[3], n[3];             // triangle vectors
	float w0[3], w[3];         // ray vectors
    float a, b;             // params to calc ray-plane intersect
    float uu, uv, vv, wu, wv, D;

	vectorNull(sect);

    // get triangle edge vectors and plane normal
    vectorSub(u, vectB, vectA);
    vectorSub(v, vectC, vectA);
    vectorCross(n, u, v);             // cross product
    if (n[0] == 0 && n[1] == 0 && n[2] == 0)            // triangle is degenerate
        return false;                 // do not deal with this case

    vectorSub(w0, origin, vectA);
    a = -vectorDot(n,w0);
    b = vectorDot(n,dir);
    if (fabs(b) < SMALL_NUM) {     // ray is parallel to triangle plane
        if (a == 0)                // ray lies in triangle plane
            return false;
        else
			return false;             // ray disjoint from plane
    }

    // get intersect point of ray with triangle plane
    r = a / b;
    if (r < 0.0)                   // ray goes away from triangle
        return false;                  // => no intersect
    // for a segment, also test if (r > 1.0) => no intersect

	vectorScale(sect, dir, r);
	vectorAdd(sect, origin, sect); // intersect point of ray and plane

    // is I inside T?
    uu = vectorDot(u,u);
    uv = vectorDot(u,v);
    vv = vectorDot(v,v);
    vectorSub(w, sect, vectA);
    wu = vectorDot(w,u);
    wv = vectorDot(w,v);
    D = uv * uv - uu * vv;

    // get and test parametric coords
    s = (uv * wv - vv * wu) / D;
    if (s < 0.0 || s > 1.0)        // I is outside T
        return false;
    t = (uv * wu - uu * wv) / D;
    if (t < 0.0 || (s + t) > 1.0)  // I is outside T
        return false;

    return true;                      // I is in T
}