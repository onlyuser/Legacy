#include "Dex3D.h"

Dex3D::Dex3D()
{
	mScene = new Scene();
	this->regDrwFnc(
		NULL,
		NULL,
		NULL, NULL,
		NULL, NULL, NULL,
		NULL, NULL, NULL,
		NULL, NULL,
		NULL, NULL, NULL,
		NULL
		);
}

Dex3D::~Dex3D()
{
	this->clear();
	delete mScene;
	if (mInstLib)
		FreeLibrary(mInstLib);
}

//=============================================================================
// EXTERNAL API

void Dex3D::regDrwFnc(
	char *library,
	char *entryTri,
	char *entryListGen, char *entryListKill,
	char *entryTexGen, char *entryTexKill, char *entryTexBind,
	char *entryFontGen, char *entryFontKill, char *entryFontPrint,
	char *entryView, char *entryModel,
	char *entryLight, char *entryBrush, char *entryBlend,
	char *entryMode
	)
{
	if (mInstLib = LoadLibrary(library))
		this->regDrwFnc(
			(DEXGL_TRI) GetProcAddress(mInstLib, entryTri),
			(DEXGL_LISTGEN) GetProcAddress(mInstLib, entryListGen),
			(DEXGL_LISTKILL) GetProcAddress(mInstLib, entryListKill),
			(DEXGL_TEXGEN) GetProcAddress(mInstLib, entryTexGen),
			(DEXGL_TEXKILL) GetProcAddress(mInstLib, entryTexKill),
			(DEXGL_TEXBIND) GetProcAddress(mInstLib, entryTexBind),
			(DEXGL_FONTGEN) GetProcAddress(mInstLib, entryFontGen),
			(DEXGL_FONTKILL) GetProcAddress(mInstLib, entryFontKill),
			(DEXGL_FONTPRINT) GetProcAddress(mInstLib, entryFontPrint),
			(DEXGL_VIEW) GetProcAddress(mInstLib, entryView),
			(DEXGL_MODEL) GetProcAddress(mInstLib, entryModel),
			(DEXGL_LIGHT) GetProcAddress(mInstLib, entryLight),
			(DEXGL_BRUSH) GetProcAddress(mInstLib, entryBrush),
			(DEXGL_BLEND) GetProcAddress(mInstLib, entryBlend),
			(DEXGL_MODE) GetProcAddress(mInstLib, entryMode)
			);
	else
		this->regDrwFnc(
			NULL,
			NULL, NULL,
			NULL, NULL, NULL,
			NULL, NULL, NULL,
			NULL, NULL,
			NULL, NULL, NULL,
			NULL
			);
}

void Dex3D::regDrwFnc(
	DEXGL_TRI funcTri,
	DEXGL_LISTGEN funcListGen, DEXGL_LISTKILL funcListKill,
	DEXGL_TEXGEN funcTexGen, DEXGL_TEXKILL funcTexKill, DEXGL_TEXBIND funcTexBind,
	DEXGL_FONTGEN funcFontGen, DEXGL_FONTKILL funcFontKill, DEXGL_FONTPRINT funcFontPrint,
	DEXGL_VIEW funcView, DEXGL_MODEL funcModel,
	DEXGL_LIGHT funcLight, DEXGL_BRUSH funcBrush, DEXGL_BLEND funcBlend,
	DEXGL_MODE funcMode
	)
{
	mFuncTri = funcTri;
	mFuncListGen = funcListGen;
	mFuncListKill = funcListKill;
	mFuncTexGen = funcTexGen;
	mFuncTexKill = funcTexKill;
	mFuncTexBind = funcTexBind;
	mFuncFontGen = funcFontGen;
	mFuncFontKill = funcFontKill;
	mFuncFontPrint = funcFontPrint;
	mFuncView = funcView;
	mFuncModel = funcModel;
	mFuncLight = funcLight;
	mFuncBrush = funcBrush;
	mFuncBlend = funcBlend;
	mFuncMode = funcMode;
}

//=============================================================================
// SCENE CONFIG

void Dex3D::setCamera(float pNear, float pFar, float fov)
{
	mScene->mCamera->set(pNear, pFar, fov);
}

void Dex3D::setLight(long ambient, long diffuse, long specular)
{
	mScene->mLight->setAttrib(ambient, diffuse, specular);
}

void Dex3D::resize(float width, float height)
{
	mScene->mCamera->resize(width, height);
}

//=============================================================================
// CAMERA MANAGEMENT

void Dex3D::moveTo(Vector &v)
{
	mScene->mCamera->modify(TRANS::ORIGIN, v);
}

void Dex3D::lookAt(Vector &v)
{
	mScene->mCamera->setTarget(v);
}

void Dex3D::lookFrom(Vector &v)
{
	mScene->mCamera->setSource(v);
}

void Dex3D::orbit(Vector &v, float radius, float lngAngle, float latAngle)
{
	mScene->mCamera->orbit(v, radius, lngAngle, latAngle);
}

//=============================================================================
// SCENE MANAGEMENT

void Dex3D::addMesh(std::string id, Mesh *mesh)
{
	mScene->mGroupMgr.add(id, mesh);
	this->setTex(id, "", "", -1, false);
	this->setFont(id, "Courier New", 16, false, false, false, false);
	//=====================================
	mesh->lock(mFuncListGen);
	//=====================================
}

void Dex3D::remMesh(Mesh *mesh)
{
	//=====================================
	mesh->unlock(mFuncListKill);
	//=====================================
	mScene->mGroupMgr.remove(mesh);
	delete mesh;
}

Mesh *Dex3D::getMesh(std::string id)
{
	Mesh *mesh = mScene->mGroupMgr[id];
	if (!mesh)
		throw Exception("mesh not found");
	return mesh;
}

void Dex3D::remMesh(std::string id)
{
	this->remMesh(this->getMesh(id));
}

void Dex3D::clear()
{
	for (int i = mScene->mGroupMgr.size() - 1; i >= 0; i--)
		this->remMesh(mScene->mGroupMgr[i]);
	for (int j = 0; j < mScene->mTexList.size(); j++)
	{
		//=========================================================
		mScene->mTexList[j]->unlock(mFuncTexKill);
		//=========================================================
		delete mScene->mTexList[j];
	}
	mScene->mTexList.clear();
	for (int k = 0; k < mScene->mFontList.size(); k++)
	{
		//=========================================================
		mScene->mFontList[k]->unlock(mFuncFontKill);
		//=========================================================
		delete mScene->mFontList[k];
	}
	mScene->mFontList.clear();
}

void Dex3D::relock()
{
	//=====================================
	mScene->unlockSAP();
	mScene->lockSAP();
	//=====================================
}

//=============================================================================
// MESH BUILD

void Dex3D::copyMesh(std::string id, std::string id2)
{
	Mesh *mesh = this->getMesh(id);
	Mesh *mesh2 = new Mesh();
	mesh->copy(mesh2);
	this->addMesh(id2, mesh2);
}

void Dex3D::load3ds(std::string id, std::string filename, int index)
{
	Mesh *mesh = new Mesh();
	File3ds::load3ds(filename, index, mesh);
	this->addMesh(id, mesh);
}

void Dex3D::addBox(std::string id, float width, float height, float length)
{
	Mesh *mesh = new Mesh();
	Polygon::makeBox(mesh);
	//=========================================================
	Vector dim = Vector(width, height, length);
	mesh->modify(TRANS::SCALE, dim);
	mesh->imprint();
	//=========================================================
	mesh->mHull = HullFactory::build(HULL::BOX);
	mesh->mMass = width * height * length;
	mesh->mInertia = 0.4f * 1 * (float) pow(dim.vec_maxDim(), 2);
	//=========================================================
	this->addMesh(id, mesh);
}

void Dex3D::addGrid(std::string id, float width, float length, int gridX, int gridZ)
{
	Mesh *mesh = new Mesh();
	Polygon::makeGrid(mesh, gridX, gridZ);
	//=========================================================
	mesh->modify(TRANS::SCALE, Vector(width, 0, length));
	mesh->imprint();
	//=========================================================
	mesh->mHull = HullFactory::build(HULL::PLANE);
	mesh->mMass = BIG_NUMBER;
	mesh->mInertia = BIG_NUMBER;
	//=========================================================
	this->addMesh(id, mesh);
}

void Dex3D::addPanel(std::string id, float width, float height)
{
	Mesh *mesh = new Mesh();
	Polygon::makeGrid(mesh, 2, 2);
	//=========================================================
	mesh->modify(TRANS::SCALE, Vector(width, 0, height));
	mesh->modify(TRANS::ANGLE, Vector(0, toRad(90), 0));
	mesh->modify(TRANS::ORIGIN, Vector(0, height, 0));
	mesh->imprint();
	//=========================================================
	this->addMesh(id, mesh);
}

void Dex3D::addSprite(std::string id, float width, float height, bool treeStyle)
{
	this->addPanel(id, width, height);
	this->setSprite(id, treeStyle);
}

void Dex3D::addHud(std::string id, float width, float height)
{
	this->addPanel(id, width, height);
	this->setOrtho(id);
}

void Dex3D::addCylndr(std::string id, float radius, float height, int step)
{
	Mesh *mesh = new Mesh();
	Polygon::makeCylinder(mesh, step);
	//=========================================================
	mesh->modify(TRANS::SCALE, Vector(radius, height, radius));
	mesh->imprint();
	//=========================================================
	this->addMesh(id, mesh);
}

void Dex3D::addCone(std::string id, float radius, float height, int step)
{
	Mesh *mesh = new Mesh();
	Polygon::makeCone(mesh, step);
	//=========================================================
	mesh->modify(TRANS::SCALE, Vector(radius, height, radius));
	mesh->imprint();
	//=========================================================
	this->addMesh(id, mesh);
}

void Dex3D::addSphere(std::string id, float radius, int stepLng, int stepLat)
{
	Mesh *mesh = new Mesh();
	Polygon::makeSphere(mesh, stepLng, stepLat);
	//=========================================================
	mesh->modify(TRANS::SCALE, Vector(radius, radius, radius));
	mesh->imprint();
	//=========================================================
	mesh->mHull = HullFactory::build(HULL::SPHERE);
	mesh->mMass = 1.33f * PI * (float) pow(radius, 3);
	mesh->mInertia = 0.4f * 1 * (float) pow(radius, 2);
	//=========================================================
	this->addMesh(id, mesh);
}

void Dex3D::addHemis(std::string id, float radius, int stepLng, int stepLat)
{
	Mesh *mesh = new Mesh();
	Polygon::makeHemis(mesh, stepLng, stepLat);
	//=========================================================
	mesh->modify(TRANS::SCALE, Vector(radius, radius, radius));
	mesh->imprint();
	//=========================================================
	this->addMesh(id, mesh);
}

void Dex3D::addCapsul(
	std::string id, float radius, float height, int stepLng, int stepLat
	)
{
	Mesh *mesh = new Mesh();
	Polygon::makeCapsule(mesh, radius, height, stepLng, stepLat);
	//=========================================================
	mesh->mHull = HullFactory::build(HULL::CAPSULE);
	mesh->mMass = 1.33f * PI * (float) pow(radius, 3);
	mesh->mInertia = 0.4f * 1 * (float) pow(radius, 2);
	//=========================================================
	this->addMesh(id, mesh);
}

void Dex3D::addTorus(
	std::string id, float radMajor, float radMinor, int stepMajor, int stepMinor
	)
{
	Mesh *mesh = new Mesh();
	Polygon::makeTorus(mesh, radMajor, radMinor, stepMajor, stepMinor);
	this->addMesh(id, mesh);
}

void Dex3D::addOcta(std::string id, float radius)
{
	Mesh *mesh = new Mesh();
	Polygon::makeOcta(mesh);
	this->addMesh(id, mesh);
	//=====================================
	mesh->spherize(radius);
	this->relockMsh(id);
	//=====================================
}

void Dex3D::addTetra(std::string id, float radius)
{
	Mesh *mesh = new Mesh();
	Polygon::makeTetra(mesh);
	this->addMesh(id, mesh);
	//=====================================
	mesh->spherize(radius);
	this->relockMsh(id);
	//=====================================
}

//=============================================================================
// OBJECT MODIFY

PhysObj *Dex3D::getObject(std::string id)
{
	return (id != "camera") ? this->getMesh(id) : (PhysObj *) mScene->mCamera;
}

void Dex3D::modify(std::string id, TRANS::TRANS trans, Vector &v)
{
	this->getObject(id)->modify(trans, v);
}

void Dex3D::query(std::string id, TRANS::TRANS trans, float &x, float &y, float &z)
{
	Vector v = this->getObject(id)->query(trans);
	x = v.x; y = v.y; z = v.z;
}

void Dex3D::pointAt(std::string id, Vector &v)
{
	this->getObject(id)->pointAt(v);
}

void Dex3D::rotArb(std::string id, Vector &pos, Vector &dir, float angle)
{
	this->getObject(id)->rotArb(pos, dir, angle);
}

void Dex3D::applyImp(std::string id, float mass, float inertia, Vector &velocity, Vector &contact, Vector &normal)
{
	this->getObject(id)->applyImpulse(mass, inertia, velocity, contact, normal);
}

void Dex3D::link(std::string id, std::string id2)
{
	this->getObject(id)->link(this->getObject(id2));
}

//=============================================================================
// MESH PICKING

std::string Dex3D::sectPoly(Vector &v1, Vector &v2, float &s)
{
	Mesh *mesh = mScene->sectPoly(v1, v2, s);
	return mesh ? mScene->mGroupMgr[mesh] : "";
}

std::string Dex3D::pick(float x, float y)
{
	Mesh *mesh = mScene->pick(x, 1 - y);
	return mesh ? mScene->mGroupMgr[mesh] : "";
}

//=============================================================================
// MESH VERTEX MODIFY

void Dex3D::setVertex(std::string id, int index, float x, float y, float z)
{
	Mesh *mesh = this->getMesh(id);
	mesh->setVertex(index, x, y, z);
}

void Dex3D::relockMsh(std::string id)
{
	Mesh *mesh = this->getMesh(id);
	//=====================================
	mesh->unlock(mFuncListKill);
	mesh->lock(mFuncListGen);
	//=====================================
}

void Dex3D::setAxis(std::string id, Vector &v)
{
	Mesh *mesh = this->getMesh(id);
	mesh->setAxis(v);
	//=====================================
	this->relockMsh(id);
	//=====================================
}

void Dex3D::alignAxis(std::string id, DIR::DIR dir)
{
	Mesh *mesh = this->getMesh(id);
	mesh->alignAxis(dir);
	//=====================================
	this->relockMsh(id);
	//=====================================
}

void Dex3D::invert(std::string id)
{
	Mesh *mesh = this->getMesh(id);
	mesh->invert();
	//=====================================
	this->relockMsh(id);
	//=====================================
}

void Dex3D::imprint(std::string id)
{
	Mesh *mesh = this->getMesh(id);
	mesh->imprint();
	//=====================================
	this->relockMsh(id);
	//=====================================
}

void Dex3D::normalize(std::string id)
{
	Mesh *mesh = this->getMesh(id);
	mesh->normalize();
	//=====================================
	this->relockMsh(id);
	//=====================================
}

void Dex3D::setHgtMap(std::string id, std::string filename, float height)
{
	Mesh *mesh = this->getMesh(id);
	Texture::setHgtMap(mesh, filename, height);
	//=====================================
	this->relockMsh(id);
	//=====================================
}

void Dex3D::setColor(std::string id, long color)
{
	Mesh *mesh = this->getMesh(id);
	mesh->mColor = color;
	//=====================================
	this->relockMsh(id);
	//=====================================
}

void Dex3D::setMap(std::string id, DIR::DIR dir)
{
	Mesh *mesh = this->getMesh(id);
	Texture::project(mesh, dir);
	//=====================================
	this->relockMsh(id);
	//=====================================
}

//=============================================================================
// MESH RESOURCE

void Dex3D::setTex(std::string id, std::string filename, std::string maskFile, long maskColor, bool mipmap)
{
	Mesh *mesh = this->getMesh(id);
	std::string texName =
		getPathPart(filename, PATH::NAME_ONLY) + "/" +
		getPathPart(maskFile, PATH::NAME_ONLY) + "/" +
		cstr(maskColor) + "/" +
		cstr(mipmap);
	Texture *texture = mScene->mTexList[texName];
	if (!texture)
	{
		texture = new Texture();
		//=========================================================
		texture->lock(filename, maskFile, maskColor, mipmap, mFuncTexGen);
		//=========================================================
		mScene->mTexList.add(texName, texture);
	}
	mesh->mTexture = texture;
}

void Dex3D::setFont(std::string id, std::string name, int size, bool bold, bool italic, bool underline, bool strikeOut)
{
	Mesh *mesh = this->getMesh(id);
	std::string fontName =
		name + "/" + cstr(size) + "/" +
		cstr(bold) + "/" + cstr(italic) + "/" +
		cstr(underline) + "/" + cstr(strikeOut);
	Font *font = mScene->mFontList[fontName];
	if (!font)
	{
		font = new Font();
		//=========================================================
		font->lock(name, size, bold, italic, underline, strikeOut, mFuncFontGen);
		//=========================================================
		mScene->mFontList.add(fontName, font);
	}
	mesh->mFont = font;
}

//=============================================================================
// MESH SHADING GROUP

void Dex3D::setSolid(std::string id)
{
	this->setAlpha(id, 1);
}

void Dex3D::setWire(std::string id)
{
	mScene->mGroupMgr.changeGroup(this->getMesh(id), GROUP::WIRE);
}

void Dex3D::setAlpha(std::string id, float alpha)
{
	Mesh *mesh = this->getMesh(id);
	mScene->mGroupMgr.changeGroup(
		mesh, ((mesh->mAlpha = alpha) != 1) ? GROUP::BLEND : GROUP::SOLID
		);
}

void Dex3D::setSprite(std::string id, bool treeStyle)
{
	mScene->mGroupMgr.changeGroup(
		this->getMesh(id), treeStyle ? GROUP::SPRITE_CYLNDR : GROUP::SPRITE_SPHERE
		);
}

void Dex3D::setOrtho(std::string id)
{
	mScene->mGroupMgr.changeGroup(this->getMesh(id), GROUP::ORTHO);
}

//=============================================================================
// MESH ATTRIBUTE

void Dex3D::setAttrib(std::string id, long ambient, long diffuse, long specular, long emission, float shininess)
{
	this->getMesh(id)->mTexture->setAttrib(
		ambient, diffuse, specular, emission, shininess
		);
}

void Dex3D::setText(std::string id, std::string text)
{
	this->getMesh(id)->mText = text;
}

void Dex3D::setVis(std::string id, bool value)
{
	this->getMesh(id)->mVisible = value;
}

void Dex3D::setNoClip(std::string id, bool value)
{
	this->getMesh(id)->mNoClip = value;
}

void Dex3D::setPhys(std::string id, float mass, float inertia, float bounce, float friction)
{
	Mesh *mesh = this->getMesh(id);
	mesh->mMass = mass;
	mesh->mInertia = inertia;
	mesh->mBounce = bounce;
	mesh->mFriction = friction;
}

//=============================================================================
// SCENE REFRESH

void Dex3D::update()
{
	mCritSection.enter();
	mScene->update();
	mCritSection.leave();
}

void Dex3D::paint()
{
	mCritSection.enter();
	mScene->paint(
		mFuncTri,
		mFuncTexBind, mFuncFontPrint,
		mFuncView, mFuncModel,
		mFuncLight, mFuncBrush, mFuncBlend,
		mFuncMode
		);
	mCritSection.leave();
}