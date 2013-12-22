#include "GroupMgr.h"

GroupMgr::GroupMgr()  {}
GroupMgr::~GroupMgr() {}

//=============================================================================

void GroupMgr::add(std::string id, Mesh *mesh)
{
	mMasterList.add(id, mesh);
	mSortList.add(id, mesh);
	(*this)[mesh->mGroup]->add(id, mesh);
}

void GroupMgr::remove(Mesh *mesh)
{
	mMasterList.remove(mesh);
	mSortList.remove(mesh);
	(*this)[mesh->mGroup]->remove(mesh);
}

void GroupMgr::clear()
{
	mMasterList.clear();
	mSortList.clear();
	mSolidList.clear();
	mWireList.clear();
	mBlendList.clear();
	mOrthoList.clear();
}

//=============================================================================

int GroupMgr::size()
{
	return mMasterList.size();
}

std::vector<Mesh *>::iterator GroupMgr::begin()
{
	return mMasterList.begin();
}

std::vector<Mesh *>::iterator GroupMgr::end()
{
	return mMasterList.end();
}

//=============================================================================

Mesh *GroupMgr::operator[](int index)
{
	return mMasterList[index];
}

Mesh *GroupMgr::operator[](std::string id)
{
	return mMasterList[id];
}

std::string GroupMgr::operator[](Mesh *item)
{
	return mMasterList[item];
}

Collection<Mesh *> *GroupMgr::operator[](GROUP::GROUP group)
{
	switch (group)
	{
		case GROUP::SORT: return &mSortList;
		case GROUP::SOLID: return &mSolidList;
		case GROUP::WIRE: return &mWireList;
		case GROUP::SPRITE_SPHERE:
		case GROUP::SPRITE_CYLNDR:
		case GROUP::BLEND:
			return &mBlendList;
		case GROUP::ORTHO: return &mOrthoList;
	}
	throw Exception("bad group");
}

//=============================================================================

void GroupMgr::changeGroup(Mesh *mesh, GROUP::GROUP group)
{
	(*this)[mesh->mGroup]->remove(mesh);
	std::string id = mMasterList[mesh];
	(*this)[mesh->mGroup = group]->add(id, mesh);
}