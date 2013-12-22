#ifndef H_GROUPMGR
#define H_GROUPMGR

#include <vector>
#include "Collection.h"
#include "Mesh.h"
#include "String.h"
#include "Exception.h"

class GroupMgr
{
private:
	Collection<Mesh *> mMasterList;
	Collection<Mesh *> mSortList;
	Collection<Mesh *> mSolidList;
	Collection<Mesh *> mWireList;
	Collection<Mesh *> mBlendList;
	Collection<Mesh *> mOrthoList;
public:
	GroupMgr();
	~GroupMgr();
	//=============================================================================
	void add(std::string id, Mesh *mesh);
	void remove(Mesh *mesh);
	void clear();
	//=============================================================================
	int size();
	std::vector<Mesh *>::iterator begin();
	std::vector<Mesh *>::iterator end();
	//=============================================================================
	Mesh *operator[](int index);
	Mesh *operator[](std::string id);
	std::string operator[](Mesh *item);
	Collection<Mesh *> *GroupMgr::operator[](GROUP::GROUP group);
	//=============================================================================
	void changeGroup(Mesh *mesh, GROUP::GROUP group);
	//=============================================================================
};

#endif