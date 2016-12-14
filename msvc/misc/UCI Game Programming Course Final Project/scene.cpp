#include "scene.h"

extern PFNGLLOCKARRAYSEXTPROC glLockArraysEXT;
extern PFNGLUNLOCKARRAYSEXTPROC glUnlockArraysEXT;

scene::scene(long width, long height, long maxSprCnt)
{
	long i;

	/* init EXT_CVA */
	const unsigned char *extList = glGetString(GL_EXTENSIONS);
	if (findText((char *) extList, "GL_EXT_compiled_vertex_array") != -1)
	{
		GL_EXT_CVA = true;
		init_EXT_CVA();
	}
	else
		GL_EXT_CVA = false;

	/* data */
	mNullVect = new float[3];
	mFogVect = new float[4];
	vectorNull(mNullVect);
	glViewport(0, 0, width, height);
	glEnable(GL_DEPTH_TEST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
	glHint(GL_FOG_HINT, GL_FASTEST);
	glBindTexture(GL_TEXTURE_2D, 0);
	glTexImage2D(
		GL_TEXTURE_2D, 0, 4,
		0, 0, 0,
		GL_RGBA, GL_UNSIGNED_BYTE, NULL
	);
	mDepthKey = new float[maxSprCnt];
	mDepthPtr = new mesh *[maxSprCnt];
	mPixel = new long[width * height];
	mLightArray = new bool[8];
	for (i = 0; i < 8; i++)
		mLightArray[i] = false;

	/* attributes */
	mSprCnt = 0;
	mWidth = width;
	mHeight = height;

	/* misc */
	initTriDef();
	setDrawMode(0);
}

scene::~scene()
{
	/* data */
	delete []mNullVect;
	delete []mFogVect;
	delete []mDepthKey;
	delete []mDepthPtr;
	delete []mPixel;
	delete []mLightArray;
}

long scene::getNextLight()
{
	long i;
	long result;

	result = -1;
	for (i = 0; i < 8 && result == -1; i++)
		if (!mLightArray[i])
			result = i;
	return result;
}

void scene::setDrawMode(long value)
{
	mWireframe = false;
	mDblSided = false;
	mShaded = false;
	mSmoothed = false;
	mTexMapped = false;
	mFogged = false;
	setFog(0xFFFFFF, 0.05);
	switch (value)
	{
	case 0:
		mSmoothed = true;
		mTexMapped = true;
		break;
	case 1:
		mShaded = true;
		mSmoothed = true;
		mTexMapped = true;
		break;
	case 2:
		mShaded = true;
		mSmoothed = true;
		mTexMapped = true;
		mFogged = true;
		break;
	case 3:
		mShaded = true;
		mSmoothed = true;
		break;
	case 4:
		mShaded = true;
		mSmoothed = true;
		mFogged = true;
		break;
	case 5:
		mShaded = true;
		break;
	case 6:
		mWireframe = true;
		break;
	case 7:
		mWireframe = true;
		mDblSided = true;
		break;
	case 8:
		mWireframe = true;
		mDblSided = true;
		mFogged = true;
		setFog(0x0, 0.05);
	}
	glEnable(GL_CULL_FACE);
	glDisable(GL_LIGHTING);
	glShadeModel(GL_FLAT);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_FOG);
	if (mWireframe)
	{
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
		if (mDblSided)
			glDisable(GL_CULL_FACE);
	}
	else
	{
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		if (mShaded)
			glEnable(GL_LIGHTING);
		if (mSmoothed)
			glShadeModel(GL_SMOOTH);
		if (mTexMapped)
			glEnable(GL_TEXTURE_2D);
	}
	if (mFogged)
	{
		glEnable(GL_FOG);
		glFogi(GL_FOG_MODE, GL_EXP);
		glFogfv(GL_FOG_COLOR, mFogVect);
		glFogf(GL_FOG_DENSITY, mFogRatio);
	}
}

void scene::setFog(long color, float ratio)
{
	mFogVect[0] = (float) colorElem(color, 'r') / 255;
	mFogVect[1] = (float) colorElem(color, 'g') / 255;
	mFogVect[2] = (float) colorElem(color, 'b') / 255;
	mFogVect[3] = 0;
	mFogRatio = ratio;
}

void scene::addParticles(float *origin, float *angle, long cnt, long color, float size, float speed, float spread, long ticks)
{
	long i;
	mesh *pMesh;
	float *tempA;
	float *tempB;
	float radius;

	tempA = new float[3];
	tempB = new float[3];
	radius = (float) tan(spread);
	for (i = 0; i < cnt; i++)
	{
		pMesh = (mesh *) addTetra(size);
		if (pMesh != NULL)
		{
			pMesh->move(MOV_POS, origin);
			vectorFromAngle(tempA, angle);
			vectorRandEx(tempB, radius);
			vectorAdd(tempA, tempA, tempB);
			angleFromVector(tempA, tempA);
			pMesh->move(MOV_ROT, tempA);
			pMesh->setMotion(1, false);
			moveMesh((long) pMesh, MOV_VEL, 0, 0, speed);
			pMesh->setParams(0x0, 0x0, 0x0, color, 0);
			pMesh->setLife(ticks);
		}
	}
	delete []tempA;
	delete []tempB;
}

long scene::addGeo(float radius, long iters)
{
	long i;
	long result;

	result = addOcta(radius);
	if (result != NULL)
		for (i = 0; i < iters; i++)
		{
			tessByEdge(result, 1);
			normalize(result, radius);
		}
	return result;
}

long scene::addOcta(float radius)
{
	long result;

	result = addMesh(6, 8);
	if (result != NULL)
	{
		setVertex(result, 0, 0, 0, 0);
		setVertex(result, 1, 1, 0, 0);
		setVertex(result, 2, 1, 0, 1);
		setVertex(result, 3, 0, 0, 1);
		setVertex(result, 4, 0.5, -1, 0.5);
		setVertex(result, 5, 0.5, 1, 0.5);
		setFace(result, 0, 0, 1, 4);
		setFace(result, 1, 1, 2, 4);
		setFace(result, 2, 2, 3, 4);
		setFace(result, 3, 3, 0, 4);
		setFace(result, 4, 0, 5, 1);
		setFace(result, 5, 1, 5, 2);
		setFace(result, 6, 2, 5, 3);
		setFace(result, 7, 3, 5, 0);
		lockMesh(result);
		centAxis(result);
		normalize(result, radius);
	}
	return result;
}

long scene::addTetra(float radius)
{
	long result;

	result = addMesh(4, 4);
	if (result != NULL)
	{
		setVertex(result, 0, 0, 0, 0);
		setVertex(result, 1, 1, 1, 0);
		setVertex(result, 2, 0, 1, 1);
		setVertex(result, 3, 1, 0, 1);
		setFace(result, 0, 0, 2, 1);
		setFace(result, 1, 0, 3, 2);
		setFace(result, 2, 0, 1, 3);
		setFace(result, 3, 1, 2, 3);
		lockMesh(result);
		centAxis(result);
		normalize(result, radius);
	}
	return result;
}

long scene::addRamp(float width, float height, float length)
{
	long result;

	result = addMesh(6, 8);
	if (result != NULL)
	{
		setVertex(result, 0, 0 * width, 0 * height, 0 * length);
		setVertex(result, 1, 1 * width, 0 * height, 0 * length);
		setVertex(result, 2, 1 * width, 0 * height, 1 * length);
		setVertex(result, 3, 0 * width, 0 * height, 1 * length);
		setVertex(result, 4, 1 * width, 1 * height, 1 * length);
		setVertex(result, 5, 0 * width, 1 * height, 1 * length);
		setFace(result, 0, 1, 4, 2);
		setFace(result, 1, 2, 4, 5);
		setFace(result, 2, 2, 5, 3);
		setFace(result, 3, 3, 5, 0);
		setFace(result, 4, 3, 0, 1);
		setFace(result, 5, 3, 1, 2);
		setFace(result, 6, 0, 5, 4);
		setFace(result, 7, 0, 4, 1);
		lockMesh(result);
	}
	return result;
}

long scene::addBox(float width, float height, float length)
{
	long result;

	result = addMesh(8, 12);
	if (result != NULL)
	{
		setVertex(result, 0, 0 * width, 0 * height, 0 * length);
		setVertex(result, 1, 1 * width, 0 * height, 0 * length);
		setVertex(result, 2, 1 * width, 0 * height, 1 * length);
		setVertex(result, 3, 0 * width, 0 * height, 1 * length);
		setVertex(result, 4, 0 * width, 1 * height, 0 * length);
		setVertex(result, 5, 1 * width, 1 * height, 0 * length);
		setVertex(result, 6, 1 * width, 1 * height, 1 * length);
		setVertex(result, 7, 0 * width, 1 * height, 1 * length);
		setFace(result, 0, 0, 4, 5);
		setFace(result, 1, 0, 5, 1);
		setFace(result, 2, 1, 5, 6);
		setFace(result, 3, 1, 6, 2);
		setFace(result, 4, 2, 6, 7);
		setFace(result, 5, 2, 7, 3);
		setFace(result, 6, 3, 7, 4);
		setFace(result, 7, 3, 4, 0);
		setFace(result, 8, 3, 0, 1);
		setFace(result, 9, 3, 1, 2);
		setFace(result, 10, 4, 7, 6);
		setFace(result, 11, 4, 6, 5);
		lockMesh(result);
	}
	return result;
}

void scene::lockScene()
{
	mesh *pMesh;

	mSprCnt = 0;
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		pMesh->applyTrans();
		if (pMesh->mSprite.mTexID[0] != -1)
		{
			mDepthPtr[mSprCnt] = pMesh;
			mSprCnt++;
		}
		if (pMesh->mTag != NULL)
			pMesh->mNext = (mesh *) findMesh(pMesh->mTag);
	}
}

//==========//
// RADIANCE //
//==========//

void scene::getAvgColor(float *result)
{
	long i;
	long pixelCnt;

	glReadPixels(0, 0, mWidth, mHeight, GL_RGBA, GL_UNSIGNED_BYTE, mPixel);
	pixelCnt = mWidth * mHeight;
	vectorNull(result);
	for (i = 0; i < pixelCnt; i++)
	{
		result[0] += colorElem(mPixel[i], 'r');
		result[1] += colorElem(mPixel[i], 'g');
		result[2] += colorElem(mPixel[i], 'b');
	}
	vectorScale(result, result, (float) 1 / pixelCnt);
}

//==========//
// RADIANCE //
//==========//

void scene::renderRad(long data)
{
	long i;
	mesh *pMesh;
	camera *pCamera;

	pCamera = (camera *) addCamera();
	pCamera->setParams(toRad(120), 1, 1, 10000, 50);
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		for (i = 0; i < pMesh->mVertCnt; i++)
		{
			pCamera->setVector(pMesh->mVertex[i], pMesh->mNormal[i]);
			renderEx((long) pCamera);
			getAvgColor(pMesh->mBuffer[i]);
		}
	}
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		for (i = 0; i < pMesh->mVertCnt; i++)
			vectorCopy(pMesh->mColor[i], pMesh->mBuffer[i]);
	}
	remCamera((long) pCamera);
	renderEx(data);
}

//==========//
// RADIANCE //
//==========//

void scene::shadeMesh(mesh *pMesh, light *pLight)
{
	long i;
	float *tempA;
	float scale;

	tempA = new float[3];
	for (i = 0; i < pMesh->mVertCnt; i++)
	{
		if (pLight != NULL)
		{
			vectorSub(tempA, pLight->mOrigin, pMesh->mVertex[i]);
			scale = vectorAngle(tempA, pMesh->mNormal[i]);
			if (scale < 0)
				scale = 0;
		}
		else
			scale = 1;
		vectorUnit(tempA);
		vectorScale(tempA, tempA, scale);
		vectorCopy(pMesh->mColor[i], tempA);
		/*
		if (occluded(pMesh->mOrigin, pLight->mOrigin))
			vectorNull(pMesh->mColor[i]);
		*/
		//vectorMax(pMesh->mColor[i], pMesh->mColor[i], tempA);
	}
	delete []tempA;
}

//==========//
// RADIANCE //
//==========//

long scene::renderEx(long data)
{
	long result;
	mesh *pMesh;
	light *pLight;

	mMeshList.moveFirst();
	pMesh = mMeshList.getData();
	mLightList.moveFirst();
	pLight = mLightList.getData();
	shadeMesh(pMesh, pLight);

	/* draw base image */
	setDrawMode(0);
	result = render(data, true, false);

	setDrawMode(6);
	glEnable(GL_BLEND);

	/* draw shadow mask */
	glDisable(GL_DEPTH_TEST);
	glBlendFunc(GL_DST_COLOR, GL_ZERO);
	render(data, false, true);

	/* draw emission mask */
	/*
	glDisable(GL_DEPTH_TEST);
	glBlendFunc(GL_ONE, GL_ONE);
	render(data, false, true);
	*/

	glEnable(GL_DEPTH_TEST);
	glDisable(GL_BLEND);
	return result;
}

void scene::traceHier(mesh *pMesh)
{
	if (pMesh->mParent != NULL)
		traceHier((mesh *) pMesh->mParent);
	glTranslated(pMesh->mOrigin[0], pMesh->mOrigin[1], pMesh->mOrigin[2]);
	glRotated(toDeg(pMesh->mAngle[2]), 0, 1, 0);
	glRotated(toDeg(pMesh->mAngle[1]), 1, 0, 0);
	glRotated(toDeg(pMesh->mAngle[0]), 0, 0, 1);
	glScaled(pMesh->mScale[0], pMesh->mScale[1], pMesh->mScale[2]);
}

long scene::render(long data, bool first, bool final)
{
	long result;
	camera *pCamera;
	mesh *pMesh;

	mTally = 0;
	if (first)
	{
		if (mWireframe)
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		else
			glClear(GL_DEPTH_BUFFER_BIT);
	}
	pCamera = ((camera *) data);
	if (pCamera->mChanged)
	{
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		gluPerspective(
			toDeg(pCamera->mFov),
			pCamera->mAspect,
			pCamera->mNear,
			pCamera->mFar
		);
		glMatrixMode(GL_MODELVIEW);
		pCamera->applyTrans();
		glLoadIdentity();
		glRotated(toDeg(pCamera->mAngle[0]), 0, 0, 1);
		gluLookAt(
			pCamera->mOrigin[0], pCamera->mOrigin[1], pCamera->mOrigin[2],
			pCamera->mTarget[0], pCamera->mTarget[1], pCamera->mTarget[2],
			0, 1, 0
		);
		pCamera->mChanged = false;
	}
	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		if (pMesh->mChanged)
		{
			pMesh->applyTrans();
			pMesh->applyHier();
			pMesh->mChanged = false;
		}
		if (pMesh->mVisible)
		{
			pMesh->mInFrust = false;
			if (vectorDist(pMesh->mOrigin, pCamera->mOrigin) <= pCamera->mRange)
				if (pCamera->canSee(pMesh->mBoxEx))
					pMesh->mInFrust = true;
			if (pMesh->mInFrust || pMesh->mSkyBox)
			{
				((object *) pMesh)->applyTrans(&(pMesh->mOriginEx), &mNullVect, 1, true, pCamera->mProj);
				glPushMatrix();
				traceHier(pMesh);
				if (pMesh->mSprite.mTexID[0] == -1 || mWireframe)
				{
					glMaterialfv(GL_FRONT, GL_AMBIENT, pMesh->mAttrib[0]);
					glMaterialfv(GL_FRONT, GL_DIFFUSE, pMesh->mAttrib[1]);
					glMaterialfv(GL_FRONT, GL_SPECULAR, pMesh->mAttrib[2]);
					glMaterialfv(GL_FRONT, GL_EMISSION, pMesh->mAttrib[3]);
					glMaterialf(GL_FRONT, GL_SHININESS, pMesh->mShininess);
					if (pMesh->mTexture.mTexID[0] != -1)
					{
						glBindTexture(GL_TEXTURE_2D, pMesh->mTexture.mTexID[0]);
						if (pMesh->mSkyBox)
							glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
						else
							glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
					}
					else
					{
						glBindTexture(GL_TEXTURE_2D, 0);
						glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
					}
					if (pMesh->mTreeNode != NULL)
					{
						glBegin(GL_TRIANGLES);
						drawTree(pCamera, pMesh, pMesh->mTreeNode);
						glEnd();
					}
					else
					{
						/*
						glBegin(GL_TRIANGLES);
						for (i = 0; i < pMesh->mFaceCnt; i++)
							drawFace(pMesh, &(pMesh->mFace[i]));
						glEnd();
						*/
						glEnableClientState(GL_VERTEX_ARRAY);
						glEnableClientState(GL_NORMAL_ARRAY);
						glEnableClientState(GL_TEXTURE_COORD_ARRAY);
						glTexCoordPointer(3, GL_FLOAT, 0, pMesh->mBulkAnchor);
						glNormalPointer(GL_FLOAT, 0, pMesh->mBulkNormal);
						glVertexPointer(3, GL_FLOAT, 0, pMesh->mBulkVertex);
						if (GL_EXT_CVA)
						{
							glLockArraysEXT(0, pMesh->mFaceCnt * 3);
							glDrawElements(GL_TRIANGLES, pMesh->mFaceCnt * 3, GL_UNSIGNED_INT, pMesh->mBulkFace);
							glUnlockArraysEXT();
						}
						else
							glDrawElements(GL_TRIANGLES, pMesh->mFaceCnt * 3, GL_UNSIGNED_INT, pMesh->mBulkFace);
						glDisableClientState(GL_VERTEX_ARRAY);
						glDisableClientState(GL_NORMAL_ARRAY);
						glDisableClientState(GL_TEXTURE_COORD_ARRAY);
						mTally += pMesh->mFaceCnt;
					}
				}
				glPopMatrix();
			}
		}
	}
	drawSprites(pCamera->mOrigin, pCamera->mFov);
	drawHud();
	if (final)
		glutSwapBuffers();
	result = mTally;
	return result;
}

void scene::drawTree(camera *pCamera, mesh *pMesh, treeNode *pTreeNode)
{
	long i;

	if (pTreeNode->mFaceCnt != 0)
	{
		pTreeNode->mInFrust = false;
		if (collide(pCamera->mFrustEx, pTreeNode->mBox))
			pTreeNode->mInFrust = true;
		if (!pTreeNode->mInFrust)
			if (pCamera->canSee(pTreeNode->mBox))
				pTreeNode->mInFrust = true;
		if (pTreeNode->mInFrust)
		{
			if (!pTreeNode->mLeaf)
				for (i = 0; i < 8; i++)
					drawTree(pCamera, pMesh, pTreeNode->mChild[i]);
			else
				for (i = 0; i < pTreeNode->mFaceCnt; i++)
					drawFace(pMesh, pTreeNode->mFace[i]);
		}
	}
}

inline void scene::drawFace(mesh *pMesh, face *pFace)
{
	//======================================
	glColor3fv(pMesh->mColor[pFace->a]);
	glTexCoord2fv(pMesh->mAnchor[pFace->a]);
	glNormal3fv(pMesh->mNormal[pFace->a]);
	glVertex3fv(pMesh->mVertex[pFace->a]);
	//======================================
	glColor3fv(pMesh->mColor[pFace->b]);
	glTexCoord2fv(pMesh->mAnchor[pFace->b]);
	glNormal3fv(pMesh->mNormal[pFace->b]);
	glVertex3fv(pMesh->mVertex[pFace->b]);
	//======================================
	glColor3fv(pMesh->mColor[pFace->c]);
	glTexCoord2fv(pMesh->mAnchor[pFace->c]);
	glNormal3fv(pMesh->mNormal[pFace->c]);
	glVertex3fv(pMesh->mVertex[pFace->c]);
	//======================================
	mTally++;
}

inline void scene::drawBillboard()
{
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glBegin(GL_QUADS);
	glTexCoord2f(0, 0); glVertex2f(0, 0);
	glTexCoord2f(1, 0); glVertex2f(1, 0);
	glTexCoord2f(1, 1); glVertex2f(1, 1);
	glTexCoord2f(0, 1); glVertex2f(0, 1);
	glEnd();
}

void scene::drawSprites(float *vector, float fov)
{
	long i;
	mesh *pMesh;

	for (i = 0; i < mSprCnt; i++)
	{
		pMesh = mDepthPtr[i];
		mDepthKey[i] = pMesh->mOriginEx[2];
	}
	sort(mDepthKey, mDepthPtr, 0, mSprCnt - 1);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glDepthMask(GL_FALSE);
	glDisable(GL_ALPHA_TEST);
	glEnable(GL_COLOR_LOGIC_OP);
	begin2d();
	for (i = mSprCnt - 1; i >= 0; i--)
	{
		pMesh = mDepthPtr[i];
		if (pMesh->mVisible)
			if (pMesh->mInFrust)
			{
				pMesh->mSprite.move(
					pMesh->mOriginEx[0],
					pMesh->mOriginEx[1],
					1 - pMesh->mOriginEx[2],
					1 - pMesh->mOriginEx[2],
					pMesh->mOriginEx[2]
				);
				drawImage(&(pMesh->mSprite));
			}
	}
	end2d();
	glDisable(GL_COLOR_LOGIC_OP);
	glEnable(GL_ALPHA_TEST);
	glDepthMask(GL_TRUE);
}

void scene::drawHud()
{
	image *pHud;

	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glDisable(GL_DEPTH_TEST);
	glEnable(GL_COLOR_LOGIC_OP);
	begin2d();
	for (mHudList.moveFirst(); !mHudList.eof(); mHudList.moveNext())
	{
		pHud = mHudList.getData();
		if (pHud->mVisible)
			drawImage(pHud);
	}
	end2d();
	glDisable(GL_COLOR_LOGIC_OP);
	glEnable(GL_DEPTH_TEST);
}

void scene::drawImage(image *pImage)
{
	glPushMatrix();
	glLoadIdentity();
	glTranslated(pImage->mX, pImage->mY, pImage->mDepth);
	glScaled(pImage->mScaleX * pImage->mWidth, pImage->mScaleY * pImage->mWidth, 1);
	if (pImage->mTexID[1] != -1)
	{
		glBindTexture(GL_TEXTURE_2D, pImage->mTexID[1]);
		glLogicOp(GL_AND);
		drawBillboard();
	}
	glBindTexture(GL_TEXTURE_2D, pImage->mTexID[0]);
	if (pImage->mTexID[1] != -1)
		glLogicOp(GL_OR);
	drawBillboard();
	glLogicOp(GL_COPY);
	glPopMatrix();
}

void scene::resetBrush()
{
	float *tempA;

	tempA = new float[4];
	tempA[0] = 0;
	tempA[1] = 0;
	tempA[2] = 0;
	tempA[3] = 0;
	glMaterialfv(GL_FRONT, GL_AMBIENT, tempA);
	glMaterialfv(GL_FRONT, GL_DIFFUSE, tempA);
	glMaterialfv(GL_FRONT, GL_SPECULAR, tempA);
	glMaterialfv(GL_FRONT, GL_EMISSION, tempA);
	glMaterialfv(GL_FRONT, GL_SHININESS, tempA);
	delete []tempA;
}

void scene::begin2d()
{
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	glOrtho(0, mWidth - 1, 0, mHeight - 1, 0, 1);
	glMatrixMode(GL_MODELVIEW);
}

void scene::end2d()
{
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
}

void scene::update()
{
	mesh *pMesh;
	float tempA;

	for (mMeshList.moveFirst(); !mMeshList.eof(); mMeshList.moveNext())
	{
		pMesh = mMeshList.getData();
		((object *) pMesh)->update();
		if (pMesh->mTicks == 0)
		{
			pMesh->unlinkAll();
			delete mMeshList.remove();
		}
		if (pMesh->mPartSys.mFreq != 0)
		{
			if (pMesh->mPartSys.mFreq < 1)
			{
				if (pMesh->mPartSys.mBucket < 1)
				{
					pMesh->mPartSys.mBucket += pMesh->mPartSys.mFreq;
					tempA = 0;
				}
				else
				{
					pMesh->mPartSys.mBucket = 0;
					tempA = 1;
				}
			}
			else
				tempA = pMesh->mPartSys.mFreq;
			if (tempA != 0)
				addParticles(
					pMesh->mOrigin,
					pMesh->mAngle,
					tempA,
					pMesh->mPartSys.mColor,
					pMesh->mPartSys.mSize,
					pMesh->mPartSys.mSpeed,
					pMesh->mPartSys.mSpread,
					pMesh->mPartSys.mTicks
				);
		}
	}
}

void scene::reset()
{
	mMeshList.clear();
	mCameraList.clear();
	mLightList.clear();
	mHudList.clear();
}