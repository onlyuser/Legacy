#include "Mesh.h"

Mesh::Mesh()
{
	mNumID = 0;
	//=====================================
	mVertexObj = NULL;
	mColor = rgb(255, 255, 255);
	mTexture = NULL;
	mAlpha = 1;
	mGroup = GROUP::SOLID;
	mNoClip = false;
	mHull = NULL;
	mCollide = false;
	//=====================================
	this->resize(0, 0);
}

Mesh::~Mesh()
{
	this->resize(0, 0);
	if (mHull)
		delete mHull;
}

//=============================================================================

void Mesh::resize(int vertCnt, int faceCnt)
{
	//=========================================================
	if (mVertexObj)
	{
		delete []mVertexObj;
		delete []mVertexWrl;
		delete []mVertexCam;
		delete []mVertexMap;
	}
	if (mVertCnt = vertCnt)
	{
		mVertexObj = new Vector[vertCnt];
		mVertexWrl = new Vector[vertCnt];
		mVertexCam = new Vector[vertCnt];
		mVertexMap = new Vector[vertCnt];
	}
	else
		mVertexObj = NULL;
	//=========================================================
	for (int i = 0; i < mFaceList.size(); i++)
		delete mFaceList[i];
	mFaceList.clear();
	mFaceCnt = faceCnt;
	for (int j = 0; j < mFaceCnt; j++)
		listAdd(mFaceList, new Face(0, 0, 0));
	//=========================================================
}

void Mesh::copy(IMesh *mesh)
{
	mesh->resize(mVertCnt, mFaceCnt);
	for (int i = 0; i < mVertCnt; i++)
		mesh->setVertex(i, mVertexObj[i].x, mVertexObj[i].y, mVertexObj[i].z);
	for (int j = 0; j < mFaceCnt; j++)
		mesh->setFace(j, mFaceList[j]->a, mFaceList[j]->b, mFaceList[j]->c);
}

//=============================================================================

Vector *Mesh::getVertices()
{
	return mVertexObj;
}

//=============================================================================

void Mesh::setVertex(int index, float x, float y, float z)
{
	mVertexObj[index] = Vector(x, y, z);
}

void Mesh::setFace(int index, int a, int b, int c)
{
	mFaceList[index]->set(a, b, c);
}

void Mesh::setAnchor(int index, float x, float y)
{
	mVertexMap[index] = Vector(x, y, 0);
}

//=============================================================================

void Mesh::setAxis(Vector &v)
{
	Vector t = v - mAbsOrigin;
	for (int i = 0; i < mVertCnt; i++)
		mVertexObj[i] -= t;
	this->modify(TRANS::ORIGIN, v);
}

void Mesh::alignAxis(DIR::DIR dir)
{
	switch (dir)
	{
		case DIR::CENTER: this->setAxis(Vector(mAbsMid.x, mAbsMid.y, mAbsMid.z)); break;
		case DIR::LEFT: this->setAxis(Vector(mAbsMax.x, mAbsMid.y, mAbsMid.z)); break;
		case DIR::RIGHT: this->setAxis(Vector(mAbsMin.x, mAbsMid.y, mAbsMid.z)); break;
		case DIR::TOP: this->setAxis(Vector(mAbsMid.x, mAbsMax.y, mAbsMid.z)); break;
		case DIR::BOTTOM: this->setAxis(Vector(mAbsMid.x, mAbsMin.y, mAbsMid.z)); break;
		case DIR::FRONT: this->setAxis(Vector(mAbsMid.x, mAbsMid.y, mAbsMax.z)); break;
		case DIR::BACK: this->setAxis(Vector(mAbsMid.x, mAbsMid.y, mAbsMin.z));
	}
}

void Mesh::invert()
{
	for (int i = 0; i < mFaceCnt; i++)
		mFaceList[i]->flip();
}

void Mesh::imprint()
{
	this->applyTrans(mVertexObj, mVertexObj, mVertCnt);
	this->reset();
}

void Mesh::normalize()
{
	float r = safeDiv((float) 1, mRadius * 2, BIG_NUMBER);
	for (int i = 0; i < mVertCnt; i++)
		mVertexObj[i] *= r;
}

void Mesh::spherize(float radius)
{
	this->alignAxis(DIR::CENTER);
	for (int i = 0; i < mVertCnt; i++)
		mVertexObj[i].normalize() *= radius;
}

//=============================================================================

Vector Mesh::collide(Mesh *mesh, Vector &normal)
{
	if (mHull && mesh->mHull)
		return mHull->collide(mesh->mHull, normal);
	return NULL_VECTOR;
}

//=============================================================================

void Mesh::buildTrans()
{
	Object::buildTrans();
	this->applyTrans(mBoxWrl, mBoxObj, 8);
	mAbsMin = UNIT_VECTOR * BIG_NUMBER;
	mAbsMax = UNIT_VECTOR * -BIG_NUMBER;
	for (int i = 0; i < 8; i++)
	{
		mAbsMin = mAbsMin.vec_min(mBoxWrl[i]);
		mAbsMax = mAbsMax.vec_max(mBoxWrl[i]);
	}
	mAbsMid = (mAbsMax + mAbsMin) * 0.5f;
	mMin = mAbsMin - mAbsOrigin;
	mMax = mAbsMax - mAbsOrigin;
	mDim = mAbsMax - mAbsMin;
	mRadius = max(mMin.vec_abs().vec_maxDim(), mMax.vec_maxDim());
	//=========================================================
	if (mHull)
		mHull->update(mAbsOrigin, mTrans, mDim, mBoxWrl);
	//=========================================================
}

void Mesh::updateClient(Camera &camera)
{
	this->applyTrans(mVertexWrl, mVertexObj, mVertCnt);
	camera.applyProj(mVertexCam, mVertexWrl, mVertCnt);
	for (int i = 0; i < mFaceCnt; i++)
		mFaceList[i]->mSortKey = -mFaceList[i]->depth(mVertexCam);
	mFaceList.sort();
	for (int j = 0; j < mFaceCnt; j++)
	{
		Face *face = mFaceList[j];
		face->mDraw =
			face->normal(mVertexCam).z > 0 && !camera.clipRect(*face, mVertexCam);
	}
}

//=============================================================================

float Mesh::sectRay(Vector &p1, Vector &p2)
{
	float bestDepth = BIG_NUMBER;
	for (int i = 0; i < mFaceCnt; i++)
	{
		float curDepth = mFaceList[i]->sectRay(mVertexWrl, p1, p2);
		if (curDepth >= 0)
			bestDepth = min(bestDepth, curDepth);
	}
	return bestDepth;
}

int Mesh::pick(Camera &camera, float x, float y)
{
	this->updateClient(camera);
	Vector p1 = Vector(x, y, BIG_NUMBER);
	Vector p2 = Vector(x, y, -BIG_NUMBER);
	for (int i = mFaceCnt - 1; i >= 0; i--)
	{
		Face *face = mFaceList[i];
		float s = face->sectRay(mVertexCam, p1, p2);
		Vector p3 = p1.vec_interp(p2, s);
		if (face->mDraw && face->sectPoint(mVertexCam, p3))
			return i;
	}
	return -1;
}

//=============================================================================

void Mesh::paint(Camera &camera, DEXGL_TRI funcTri)
{
	this->updateClient(camera);
	for (int i = 0; i < mFaceCnt; i++)
	{
		Face *face = mFaceList[i];
		if (face->mDraw)
		{
			float a = face->shade(mVertexWrl, camera.query(TRANS::ABS_ORIGIN));
			float b = camera.shade(face->center(mVertexWrl));
			long color = Color::rgb_interp(
				0,
				mColor,
				mGroup != GROUP::WIRE ? (float) pow(a * b, 0.5f) : 1
				);
			face->paint(mVertexCam, color, funcTri);
		}
	}
}

//=============================================================================

void Mesh::lock(DEXGL_LISTGEN funcListGen)
{
	//=========================================================
	Vector v[2];
	v[0] = UNIT_VECTOR * BIG_NUMBER;
	v[1] = UNIT_VECTOR * -BIG_NUMBER;
	for (int p = 0; p < mVertCnt; p++)
	{
		v[0] = v[0].vec_min(mVertexObj[p]);
		v[1] = v[1].vec_max(mVertexObj[p]);
	}
	mBoxObj[0] = Vector(v[0].x, v[0].y, v[0].z);
	mBoxObj[1] = Vector(v[1].x, v[0].y, v[0].z);
	mBoxObj[2] = Vector(v[1].x, v[0].y, v[1].z);
	mBoxObj[3] = Vector(v[0].x, v[0].y, v[1].z);
	mBoxObj[4] = Vector(v[0].x, v[1].y, v[0].z);
	mBoxObj[5] = Vector(v[1].x, v[1].y, v[0].z);
	mBoxObj[6] = Vector(v[1].x, v[1].y, v[1].z);
	mBoxObj[7] = Vector(v[0].x, v[1].y, v[1].z);
	//=========================================================
	long *bulkFace = new long[mFaceCnt * 3];
	float *bulkVertex = new float[mVertCnt * 3];
	float *bulkColor = new float[mVertCnt * 3];
	float *bulkNormal = new float[mVertCnt * 3];
	float *bulkAnchor = new float[mVertCnt * 2];
	Vector *vertNormal = new Vector[mVertCnt];
	float r = (float) 1 / 255;
	for (int i = 0; i < mVertCnt; i++)
	{
		mVertexObj[i].toArray(&bulkVertex[i * 3]);
		(Color::toVector(mColor) * r).toArray(&bulkColor[i * 3]);
		bulkAnchor[i * 2 + 0] = mVertexMap[i].x;
		bulkAnchor[i * 2 + 1] = mVertexMap[i].y;
		//=========================================================
		vertNormal[i] = NULL_VECTOR;
		//=========================================================
	}
	for (int j = 0; j < mFaceCnt; j++)
	{
		Face *face = mFaceList[j];
		face->toArray(&bulkFace[j * 3]);
		//=========================================================
		Vector n = face->normal(mVertexObj);
		vertNormal[face->a] += n;
		vertNormal[face->b] += n;
		vertNormal[face->c] += n;
		//=========================================================
	}
	for (int k = 0; k < mVertCnt; k++)
	{
		//=========================================================
		vertNormal[k].normal().toArray(&bulkNormal[k * 3]);
		//=========================================================
	}
	mNumID = funcListGen(
		mVertCnt, mFaceCnt, bulkFace, bulkVertex, bulkColor, bulkNormal, bulkAnchor
		);
	delete []bulkFace;
	delete []bulkVertex;
	delete []bulkColor;
	delete []bulkNormal;
	delete []bulkAnchor;
	delete []vertNormal;
	this->buildTrans();
}

void Mesh::unlock(DEXGL_LISTKILL funcListKill)
{
	if (mNumID)
	{
		funcListKill(mNumID);
		mNumID = 0;
	}
}

//=============================================================================

void Mesh::apply(float *trans, DEXGL_BRUSH funcBrush, DEXGL_TEXBIND funcTexBind, DEXGL_MODEL funcModel, DEXGL_FONTPRINT funcFontPrint)
{
	if (mTexture)
		mTexture->apply(funcBrush, funcTexBind);
	funcModel(trans, mNumID);
	if (mText != "")
		mFont->apply(
			mText,
			(mGroup == GROUP::ORTHO) ? mAbsOrigin * ORTHO_VIEW : mAbsOrigin,
			mColor,
			funcFontPrint
			);
}