#include "Scene.h"

SAPEdge::SAPEdge(float *pos, int owner)
{
	//=====================================
	mPos = pos;
	mOwner = owner;
	//=====================================
	this->refresh();
}

SAPEdge::~SAPEdge()
{
}

void SAPEdge::refresh()
{
	mSortKey = *mPos;
}

//=============================================================================

Scene::Scene()
{
	mCamera = new Camera();
	mLight = new Light(0);
	mLight->link(mCamera);
	mCamera->orbit(NULL_VECTOR, 100, 0, 0);
}

Scene::~Scene()
{
	this->unlockSAP();
	delete mCamera;
	delete mLight;
}

//=============================================================================

void Scene::sortObjects()
{
	Collection<Mesh *> &sortList = *(mGroupMgr[GROUP::SORT]);
	for (int i = 0; i < sortList.size(); i++)
	{
		Mesh *mesh = sortList[i];
		mesh->mSortKey = -mesh->query(TRANS::ABS_ORIGIN).dist(
			mCamera->query(TRANS::ABS_ORIGIN)
			);
	}
	sortList.sort();
}

//=============================================================================

Mesh *Scene::sectPoly(Vector &p1, Vector &p2, float &s)
{
	float bestDepth = BIG_NUMBER;
	Mesh *bestMesh = NULL;
	for (int i = 0; i < mGroupMgr.size(); i++)
	{
		Mesh *mesh = mGroupMgr[i];
		if (mesh->mVisible && mesh->mGroup == GROUP::SOLID)
		{
			Vector origin = mesh->query(TRANS::ABS_ORIGIN);
			if ((p2 - p1).angle(origin - p1) >= 0)
			{
				float curDepth = mesh->sectRay(p1, p2);
				if (curDepth < bestDepth)
				{
					bestDepth = curDepth;
					bestMesh = mesh;
				}
			}
		}
	}
	s = bestDepth;
	return bestMesh;
}

Mesh *Scene::pick(float x, float y)
{
	this->sortObjects();
	Collection<Mesh *> &sortList = *(mGroupMgr[GROUP::SORT]);
	for (int i = sortList.size() - 1; i >= 0; i--)
	{
		Mesh *mesh = sortList[i];
		if (
			mesh->mVisible && mesh->mGroup == GROUP::SOLID &&
			mesh->pick(*mCamera, x, y) != -1
			)
			return mesh;
	}
	return NULL;
}

//=============================================================================

void Scene::lockSAP()
{
	for (int i = 0; i < mGroupMgr.size(); i++)
	{
		Mesh *mesh = mGroupMgr[i];
		if (mesh->mMass)
		{
			listAdd(mEdgeList[AXIS::X], new SAPEdge(&(mesh->mAbsMin.x), i));
			listAdd(mEdgeList[AXIS::X], new SAPEdge(&(mesh->mAbsMax.x), i));
			listAdd(mEdgeList[AXIS::Y], new SAPEdge(&(mesh->mAbsMin.y), i));
			listAdd(mEdgeList[AXIS::Y], new SAPEdge(&(mesh->mAbsMax.y), i));
			listAdd(mEdgeList[AXIS::Z], new SAPEdge(&(mesh->mAbsMin.z), i));
			listAdd(mEdgeList[AXIS::Z], new SAPEdge(&(mesh->mAbsMax.z), i));
		}
	}
	//=====================================
	// quick-sort speedup
	mEdgeList[AXIS::X].sort();
	mEdgeList[AXIS::Y].sort();
	mEdgeList[AXIS::Z].sort();
	//=====================================
}

void Scene::unlockSAP()
{
	for (int i = 0; i < mEdgeList[AXIS::X].size(); i++)
	{
		delete mEdgeList[AXIS::X][i];
		delete mEdgeList[AXIS::Y][i];
		delete mEdgeList[AXIS::Z][i];
	}
	mEdgeList[AXIS::X].clear();
	mEdgeList[AXIS::Y].clear();
	mEdgeList[AXIS::Z].clear();
}

void Scene::runSAP(AXIS::AXIS axis, bool init)
{
	//=========================================================
	// build prunable list from master list
	if (init)
	{
		mPruneList[AXIS::X].clear();
		mPruneList[AXIS::Y].clear();
		mPruneList[AXIS::Z].clear();
		for (int i = 0; i < mEdgeList[AXIS::X].size(); i++)
		{
			mPruneList[AXIS::X].add(UID_FLOAT, mEdgeList[AXIS::X][i]);
			mPruneList[AXIS::Y].add(UID_FLOAT, mEdgeList[AXIS::Y][i]);
			mPruneList[AXIS::Z].add(UID_FLOAT, mEdgeList[AXIS::Z][i]);
			SAPEdge &edge = *(mPruneList[AXIS::X][i]);
			// unmark collision
			mGroupMgr[edge.mOwner]->mCollide = false;
		}
	}
	//=========================================================
	// prune non-critical indices
	else
		for (int i = mPruneList[axis].size() - 1; i >= 0; i--)
		{
			SAPEdge &edge = *(mPruneList[axis][i]);
			if (!mGroupMgr[edge.mOwner]->mCollide)
				mPruneList[axis].remove(mPruneList[axis][i]);
		}
	//=========================================================
	// bubble-sort edges
	bool change;
	do
	{
		change = false;
		for (int i = 0; i < mPruneList[axis].size() - 1; i++)
		{
			SAPEdge &edge1 = *(mPruneList[axis][i]);
			SAPEdge &edge2 = *(mPruneList[axis][i + 1]);
			edge1.refresh();
			edge2.refresh();
			if (edge1.mSortKey > edge2.mSortKey) // is swap needed?
			{
				std::swap(edge1, edge2); // bubble swap
				change = true;
			}
		}
	} while (change); // repeat until sorted
	//=========================================================
	// detect collisions
	Collection<long, float> mEdgeStack;
	for (int i = 0; i < mPruneList[axis].size(); i++)
	{
		SAPEdge &edge = *(mPruneList[axis][i]);
		int data1 = edge.mOwner;
		if (!mEdgeStack[(long) data1]) // if index not flagged..
		{
			mGroupMgr[data1]->mCollide = (mEdgeStack.size() != 0); // mark collision
			// enum flagged indices
			for (int j = 0; j < mEdgeStack.size(); j++)
			{
				int data2 = mEdgeStack[j];
				// encode collision pair
				long pairData = (data2 > data1) ?
					MAKELONG(data1, data2) : MAKELONG(data2, data1);
				if (!mPairTable[axis][pairData])
					mPairTable[axis].add(UID_FLOAT, pairData);
				mGroupMgr[data2]->mCollide = true; // mark collision
			}
			mEdgeStack.add(UID_FLOAT, (long) data1); // flag index
		}
		else
			mEdgeStack.remove((long) data1); // unflag index
	}
}

void Scene::runSAP()
{
	//=========================================================
	// find collision pairs using "sweep & prune"
	this->runSAP(AXIS::X, true);
	this->runSAP(AXIS::Z, false);
	this->runSAP(AXIS::Y, false); // prune y-axis last
	//=========================================================
	// verify collisions and perform collision response accordingly
	for (int i = 0; i < mPairTable[AXIS::X].size(); i++)
	{
		long pairData = mPairTable[AXIS::X][i];
		if (mPairTable[AXIS::Z][pairData] && mPairTable[AXIS::Y][pairData])
		{
			// decode collision pair
			Mesh *mesh1 = mGroupMgr[LOWORD(pairData)];
			Mesh *mesh2 = mGroupMgr[HIWORD(pairData)];
			Vector normal;
			Vector contact = mesh1->collide(mesh2, normal);
			if (contact != NULL_VECTOR) // test for precise collision
			{
				// undo collision
				mesh1->update(-1);
				mesh2->update(-1);
				// apply collision response
				Vector v1 = mesh1->query(TRANS::VEL_ORIGIN);
				Vector v2 = mesh2->query(TRANS::VEL_ORIGIN);
				Vector t1 = mesh1->calcVelTangent(contact);
				Vector t2 = mesh2->calcVelTangent(contact);
				float r1 = (contact - mesh1->query(TRANS::ABS_ORIGIN)).mod();
				float r2 = (contact - mesh2->query(TRANS::ABS_ORIGIN)).mod();
				mesh1->applyImpulse(
					mesh2->mMass, mesh2->mInertia, mesh2->mBounce, mesh2->mFriction,
					v1, v2, t1, t2, r1, r2, contact, normal
					);
				mesh2->applyImpulse(
					mesh1->mMass, mesh1->mInertia, mesh1->mBounce, mesh1->mFriction,
					v2, v1, t2, t1, r2, r1, contact, -normal
					);
			}
		}
	}
	//=========================================================
	// clean-up
	mPairTable[AXIS::X].clear();
	mPairTable[AXIS::Y].clear();
	mPairTable[AXIS::Z].clear();
	//=========================================================
}

//=============================================================================

void Scene::update()
{
	this->runSAP();
	for (int i = 0; i < mGroupMgr.size(); i++)
	{
		Mesh *mesh = mGroupMgr[i];
		if (mesh->mMass)
			mesh->update(1);
	}
}

void Scene::paint(
	DEXGL_TRI funcTri,
	DEXGL_TEXBIND funcTexBind, DEXGL_FONTPRINT funcFontPrint,
	DEXGL_VIEW funcView, DEXGL_MODEL funcModel,
	DEXGL_LIGHT funcLight, DEXGL_BRUSH funcBrush, DEXGL_BLEND funcBlend,
	DEXGL_MODE funcMode
	)
{
	#ifndef OGL_CVA
		this->sortObjects();
		Collection<Mesh *> &sortList = *(mGroupMgr[GROUP::SORT]);
		for (int i = 0; i < sortList.size(); i++)
		{
			Mesh *mesh = sortList[i];
			if (
				mesh->mVisible && (
					mesh->mNoClip ||
					!mCamera->clipFrust(mesh->query(TRANS::ABS_ORIGIN))
					)
				)
			{
				if (mesh->mGroup == GROUP::WIRE)
					funcMode(DRAW_MODE::WIRE);
				mesh->paint(*mCamera, funcTri);
				if (mesh->mGroup == GROUP::WIRE)
					funcMode(DRAW_MODE::TEXTURED);
			}
		}
	#else
		//=========================================================
		Matrix viewTrans = mCamera->getPerspectView();
		float temp[16];
		viewTrans.toArray(temp);
		mCamera->apply(temp, funcView);
		mLight->apply(funcLight);
		//=========================================================
		Collection<Mesh *> &solidList = *(mGroupMgr[GROUP::SOLID]);
		for (int i = 0; i < solidList.size(); i++)
		{
			Mesh *mesh = solidList[i];
			if (
				mesh->mVisible && (
					mesh->mNoClip ||
					!mCamera->clipFrust(mesh->query(TRANS::ABS_ORIGIN))
					)
				)
			{
				(mesh->mTrans * viewTrans).toArray(temp);
				mesh->apply(
					temp, funcBrush, funcTexBind, funcModel, funcFontPrint
					);
			}
		}
		Collection<Mesh *> &wireList = *(mGroupMgr[GROUP::WIRE]);
		if (wireList.size())
		{
			//=========================================================
			funcMode(DRAW_MODE::WIRE);
			//=========================================================
			for (int j = 0; j < wireList.size(); j++)
			{
				Mesh *mesh = wireList[j];
				if (
					mesh->mVisible && (
						mesh->mNoClip ||
						!mCamera->clipFrust(mesh->query(TRANS::ABS_ORIGIN))
						)
					)
				{
					(mesh->mTrans * viewTrans).toArray(temp);
					mesh->apply(
						temp, funcBrush, funcTexBind, funcModel, funcFontPrint
						);
				}
			}
			//=========================================================
			funcMode(DRAW_MODE::TEXTURED);
			//=========================================================
		}
		Collection<Mesh *> &blendList = *(mGroupMgr[GROUP::BLEND]);
		if (blendList.size())
		{
			for (int k = 0; k < blendList.size(); k++)
			{
				Mesh *mesh = blendList[k];
				if (
					mesh->mVisible && (
						mesh->mNoClip ||
						!mCamera->clipFrust(mesh->query(TRANS::ABS_ORIGIN))
						)
					)
					mesh->mSortKey = -mesh->query(TRANS::ABS_ORIGIN).dist(
						mCamera->query(TRANS::ABS_ORIGIN)
						);
			}
			blendList.sort();
			for (int p = 0; p < blendList.size(); p++)
			{
				Mesh *mesh = blendList[p];
				if (
					mesh->mVisible && (
						mesh->mNoClip ||
						!mCamera->clipFrust(mesh->query(TRANS::ABS_ORIGIN))
						)
					)
				{
					bool sprite =
						mesh->mGroup == GROUP::SPRITE_SPHERE ||
						mesh->mGroup == GROUP::SPRITE_CYLNDR;
					//=========================================================
					if (mesh->mAlpha >= 0 && !sprite)
						funcBlend(BLEND_OP::ALPHA_SET, mesh->mAlpha);
					else
						if (mesh->mTexture->mGlow)
							funcBlend(BLEND_OP::ALPHA_TEX_GLOW, 0);
						else
							funcBlend(BLEND_OP::ALPHA_TEX_MASK, 0);
					//=========================================================
					if (sprite)
					{
						Vector camAngle = mCamera->query(TRANS::ANGLE);
						mesh->modify(
							TRANS::ANGLE,
							Vector(
								mesh->query(TRANS::ANGLE).roll,
								(mesh->mGroup == GROUP::SPRITE_CYLNDR) ?
									0 : -camAngle.pitch,
								wrap(camAngle.yaw + toRad(180), toRad(-180), toRad(180))
								)
							);
					}
					(mesh->mTrans * viewTrans).toArray(temp);
					mesh->apply(
						temp, funcBrush, funcTexBind, funcModel, funcFontPrint
						);
				}
			}
			//=========================================================
			funcBlend(BLEND_OP::NONE, 0);
			//=========================================================
		}
		Collection<Mesh *> &orthoList = *(mGroupMgr[GROUP::ORTHO]);
		if (orthoList.size())
		{
			//=========================================================
			mCamera->apply(NULL, funcView);
			//=========================================================
			for (int q = 0; q < orthoList.size(); q++)
			{
				Mesh *mesh = orthoList[q];
				//=========================================================
				if (mesh->mTexture->mGlow)
					funcBlend(BLEND_OP::ALPHA_TEX_GLOW, 0);
				else
					funcBlend(BLEND_OP::ALPHA_TEX_MASK, 0);
				//=========================================================
				if (mesh->mVisible)
				{
					(mesh->mTrans * ORTHO_VIEW).toArray(temp);
					mesh->apply(
						temp, funcBrush, funcTexBind, funcModel, funcFontPrint
						);
				}
			}
			//=========================================================
			funcBlend(BLEND_OP::NONE, 0);
			//=========================================================
		}
	#endif
}