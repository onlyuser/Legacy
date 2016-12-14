#ifndef H_DEXKNN
#define H_DEXKNN

#include <vector> // std::vector
#include <set> // std::set
#include <queue> // std::queue
#include <algorithm> // std::copy(), std::random_shuffle()
#include "Windows.h" // MAKELONG, LOWORD, HIWORD
#include "Vector.h"
#include "Transform.h" // _isInTri2D(), _calcArcCent()
#include "ISortable.h" // ISortable::sort()

#define MAX_DEPTH 3
#define DIM_CNT 2

//=============================================================================

template<class T>
class Node;

template<class T>
class Tri;

template<class T> // vc6 bug
class DexKNN
{
private:
	std::vector<Vector<T> *> mVecList;
	Node<T> *mRoot;

	//=========================================================
	void mergeTriMap(
		std::set<Tri<T> *> &r_triSet,
		const std::vector<std::set<Tri<T> *> *> &triMap
		) const;
	void killTriMap(
		const std::vector<std::set<Tri<T> *> *> &triMap
		) const;
	//=========================================================
	void edgeFromTri(
		std::vector<std::pair<int, int> *> &r_edgeList,
		const std::vector<std::set<Tri<T> *> *> &triMap,
		const Tri<T> &ignoreTri
		) const;
	void voroFromTri(
		std::vector<Vector<T> *> &r_vecList,
		std::vector<std::pair<int, int> *> &r_edgeList,
		const std::vector<std::set<Tri<T> *> *> &triMap
		) const;
	//=========================================================
	void findTriBelong(
		std::vector<Tri<T> *> &r_triList,
		const std::vector<std::set<Tri<T> *> *> &triMap,
		const Vector<T> &v, Tri<T> &startTri
		) const;
	//=========================================================
public:
	DexKNN();
	~DexKNN();
	//=========================================================
	void reset();
	//=========================================================
	void build(const std::vector<Vector<T> *> &vecList);
	int find(const Vector<T> &v) const;
	//=========================================================
	void genMesh2D(
		std::vector<std::pair<int, int> *> &r_edgeList,
		std::vector<Vector<T> *> &r_vVecList,
		std::vector<std::pair<int, int> *> &r_vEdgeList,
		const std::vector<Vector<T> *> &vecList
		) const;
	void genRoadMap(
		std::vector<Vector<T> *> &r_vecList,
		const std::vector<Vector<T> *> &vVecList,
		const std::vector<std::pair<int, int> *> &vEdgeList,
		int sampFreq, int rndCnt, T minLen, int centCnt, int iters, T minDist
		) const;
	bool genPath(
		std::vector<int> &r_pathIdxList,
		std::vector<int> &r_freeIdxList,
		const std::vector<std::pair<int, int> *> &edgeList,
		const std::vector<Vector<T> *> &vecList,
		int srcIdx, int destIdx, int stepCnt
		) const;
	void cluster(
		std::vector<Vector<T> *> &r_centList,
		const std::vector<Vector<T> *> &vecList,
		int centCnt, int iters, T minDist
		) const;
	//=========================================================
	void toString(char *buffer);
	//=========================================================
};

template<class T> DexKNN<T>::DexKNN() {mRoot = NULL;}
template<class T> DexKNN<T>::~DexKNN() {this->reset();}

//=============================================================================

template<class T = double>
class Node
{
private:
	const std::vector<Vector<T> *> *mVecList;
	int mPivDim, mPivIdx;
	Node<T> *mParent, *mChild_LT, *mChild_GT, *mSibling;
	bool mLeaf, mVisited;

	//=========================================================
	void resetVisState()
	{
		mVisited = false;
		if (mChild_LT)
			mChild_LT->resetVisState();
		if (mChild_GT)
			mChild_GT->resetVisState();
	}
	//=========================================================
public:
	std::vector<int> mIdxList;

	Node(const std::vector<Vector<T> *> &vecList, Node<T> *parent)
	{
		mVecList = &vecList;
		mPivDim = -1; mPivIdx = -1;
		mParent = parent; mChild_LT = NULL; mChild_GT = NULL; mSibling = NULL;
		mLeaf = true; mVisited = false;
	}
	~Node()
		{delete mChild_LT; delete mChild_GT;}
	//=========================================================
	void build(int depth, int maxDepth)
	{
		//=========================================================
		// bail conditions
		if (mIdxList.size() == 1 || depth + 1 >= maxDepth)
			return; // leaf criterion
		//=========================================================
		// divide & conquer (housekeeping)
		mPivDim = mParent ? (mParent->mPivDim + 1) % DIM_CNT : 0;
		std::vector<T> posList;
		for (int i = 0; i < mIdxList.size(); i++)
			posList.push_back((*(*mVecList)[mIdxList[i]])[mPivDim]);
		ISortable<T, int>::sort(posList, mIdxList); // sort by mPivDim
		mPivIdx = mIdxList.size() * 0.5; // locate mPivIdx
		std::vector<int>::iterator begin, end;
		//=========================================================
		// assign less-than
		begin = mIdxList.begin() + 0;
		end = mIdxList.begin() + (mPivIdx - 1) + 1;
		if (begin != end)
		{
			mChild_LT = new Node<T>(*mVecList, this);
			std::copy(begin, end, std::back_inserter(mChild_LT->mIdxList));
			mChild_LT->build(depth + 1, maxDepth);
		}
		//=========================================================
		// assign greater-than
		begin = mIdxList.begin() + (mPivIdx + 0); // (include mPivIdx)
		end = mIdxList.begin() + (mIdxList.size() - 1) + 1;
		if (begin != end)
		{
			mChild_GT = new Node<T>(*mVecList, this);
			std::copy(begin, end, std::back_inserter(mChild_GT->mIdxList));
			mChild_GT->build(depth + 1, maxDepth);
		}
		//=========================================================
		// appoint siblings
		if (mChild_LT && mChild_GT)
		{
			mChild_LT->mSibling = mChild_GT;
			mChild_GT->mSibling = mChild_LT;
		}
		//=========================================================
	}
	void find(const Vector<T> &v, int &r_bestIdx, T &r_bestDist)
	{
		if (!mParent)
			this->resetVisState(); // mark all nodes unvisited
		if (!mLeaf)
		{
			if (v[mPivDim] < (*(*mVecList)[mIdxList[mPivIdx]])[mPivDim])
			{
				if (mChild_LT)
					mChild_LT->find(v, r_bestIdx, r_bestDist);
			}
			else
				if (mChild_GT)
					mChild_GT->find(v, r_bestIdx, r_bestDist);
		}
		else
			for (int i = 0; i < mIdxList.size(); i++)
			{
				T curDist = v.dist(*(*mVecList)[mIdxList[i]]);
				if (curDist < r_bestDist)
					{r_bestDist = curDist; r_bestIdx = mIdxList[i];}
			}
		if (mSibling && !mSibling->mVisited)
		{
			mVisited = true;
			if (fabs(
				v[mParent->mPivDim] -
					(*(*mVecList)[mParent->mIdxList[mParent->mPivIdx]]
					)[mParent->mPivDim]
				) <= r_bestDist)
				mSibling->find(v, r_bestIdx, r_bestDist);
		}
	}
	//=========================================================
};

//=============================================================================

template<class T> void DexKNN<T>::reset()
{
	//=========================================================
	// clean up
	std::for_each(mVecList.begin(), mVecList.end(), std::kill());
	mVecList.clear();
	if (mRoot)
	{
		delete mRoot;
		mRoot = NULL;
	}
	//=========================================================
}

//=============================================================================

template<class T>
void DexKNN<T>::build(const std::vector<Vector<T> *> &vecList)
{
	this->reset();
	//=========================================================
	// init input, run
	for (int i = 0; i < vecList.size(); i++)
		mVecList.push_back(new Vector<T>(*vecList[i]));
	mRoot = new Node<T>(mVecList, NULL);
	mRoot->mIdxList.resize(mVecList.size());
	std::iota(mRoot->mIdxList.begin(), mRoot->mIdxList.end(), 0);
	mRoot->build(0, MAX_DEPTH);
	//=========================================================
}
template<class T>
int DexKNN<T>::find(const Vector<T> &v) const
{
	int r_bestIdx = -1;
	T bestDist = (T) BIG_NUMBER;
	if (mRoot)
		mRoot->find(v, r_bestIdx, bestDist);
	return r_bestIdx;
}

//=============================================================================

template<class T = double>
class Tri
{
private:
	const std::vector<Vector<T> *> *mVecList;
public:
	int mVecIdx[3];
	int mCentIdx;

	Tri(const std::vector<Vector<T> *> &vecList, int a, int b, int c)
	{
		mVecList = &vecList; mVecIdx[0] = a; mVecIdx[1] = b; mVecIdx[2] = c;
		mCentIdx = -1;
	}
	~Tri() {}
	//=========================================================
	Tri(const Tri<T> &tri)
	{
		mVecList = tri.mVecList;
		for (int i = 0; i < 3; i++)
			mVecIdx[i] = tri.mVecIdx[i];
		mCentIdx = tri.mCentIdx;
	}
	//=========================================================
	void reg(std::vector<std::set<Tri<T> *> *> &triMap)
	{
		for (int i = 0; i < 3; i++)
			triMap[mVecIdx[i]]->insert(this);
	}
	Tri<T> *unreg(std::vector<std::set<Tri<T> *> *> &triMap)
	{
		for (int i = 0; i < 3; i++)
			triMap[mVecIdx[i]]->erase(this);
		return this;
	}
	//=========================================================
	bool isInTri(const Vector<T> &v) const
	{
		return _isInTri2D(
			v,
			*(*mVecList)[mVecIdx[0]],
			*(*mVecList)[mVecIdx[1]],
			*(*mVecList)[mVecIdx[2]]
			);
	}
	bool isInArc(const Vector<T> &v) const
	{
		return _isInArc2D(
			v,
			*(*mVecList)[mVecIdx[0]],
			*(*mVecList)[mVecIdx[1]],
			*(*mVecList)[mVecIdx[2]]
			);
	}
	//=========================================================
	bool isAdjacent(const Tri<T> &tri) const
	{
		std::set<int> idxSet;
		for (int i = 0; i < 3; i++)
		{
			idxSet.insert(mVecIdx[i]);
			idxSet.insert(tri.mVecIdx[i]);
		}
		return idxSet.size() == 4;
	}
	void getAdjacent(
		std::set<Tri<T> *> &r_triSet,
		const std::vector<std::set<Tri<T> *> *> &triMap
		) const
	{
		for (int i = 0; i < 3; i++)
		{
			std::set<Tri<T> *> *triSet = triMap[mVecIdx[i]];
			std::set<Tri<T> *>::iterator p;
			for (p = triSet->begin(); p != triSet->end(); p++)
				if (*p != this && this->isAdjacent(*(*p)))
					r_triSet.insert(*p);
		}
	}
	bool hasVecIdx(int idx) const
	{
		for (int i = 0; i < 3; i++)
			if (mVecIdx[i] == idx)
				return true;
		return false;
	}
	//=========================================================
	Vector<T> calcCent()
	{
		return _calcArcCent(
			*(*mVecList)[mVecIdx[0]],
			*(*mVecList)[mVecIdx[1]],
			*(*mVecList)[mVecIdx[2]]
			);
	}
	//=========================================================
};

//=============================================================================

template<class T>
void DexKNN<T>::mergeTriMap(
	std::set<Tri<T> *> &r_triSet,
	const std::vector<std::set<Tri<T> *> *> &triMap
	) const
{
	for (int i = 0; i < triMap.size(); i++)
	{
		std::set<Tri<T> *>::iterator p;
		for (p = triMap[i]->begin(); p != triMap[i]->end(); p++)
			r_triSet.insert(*p);
	}
}
template<class T>
void DexKNN<T>::killTriMap(
	const std::vector<std::set<Tri<T> *> *> &triMap
	) const
{
	// merge triMaps, filter duplicate Tris
	std::set<Tri<T> *> triSet;
	this->mergeTriMap(triSet, triMap);
	// delete unique Tris
	std::set<Tri<T> *>::iterator p;
	for (p = triSet.begin(); p != triSet.end(); p++)
		delete *p;
}

//=============================================================================

template<class T>
void DexKNN<T>::edgeFromTri(
	std::vector<std::pair<int, int> *> &r_edgeList,
	const std::vector<std::set<Tri<T> *> *> &triMap, const Tri<T> &ignoreTri
	) const
{
	// merge triMaps, filter duplicate Tris
	std::set<Tri<T> *> triSet;
	this->mergeTriMap(triSet, triMap);
	// merge Tris, filter duplicate edges
	std::set<long> edgeSet;
	std::set<Tri<T> *>::iterator p;
	for (p = triSet.begin(); p != triSet.end(); p++)
	{
		edgeSet.insert(MAKELONG(
			min((*p)->mVecIdx[0], (*p)->mVecIdx[1]),
			max((*p)->mVecIdx[1], (*p)->mVecIdx[0])
			));
		edgeSet.insert(MAKELONG(
			min((*p)->mVecIdx[1], (*p)->mVecIdx[2]),
			max((*p)->mVecIdx[2], (*p)->mVecIdx[1])
			));
		edgeSet.insert(MAKELONG(
			min((*p)->mVecIdx[2], (*p)->mVecIdx[0]),
			max((*p)->mVecIdx[0], (*p)->mVecIdx[2])
			));
	}
	// extract endpoints (cull large Tri)
	std::set<long>::iterator q;
	for (q = edgeSet.begin(); q != edgeSet.end(); q++)
	{
		int idx1 = LOWORD(*q);
		int idx2 = HIWORD(*q);
		if (!ignoreTri.hasVecIdx(idx1) && !ignoreTri.hasVecIdx(idx2))
			r_edgeList.push_back(new std::pair<int, int>(idx1, idx2));
	}
}
template<class T>
void DexKNN<T>::voroFromTri(
	std::vector<Vector<T> *> &r_vecList,
	std::vector<std::pair<int, int> *> &r_edgeList,
	const std::vector<std::set<Tri<T> *> *> &triMap
	) const
{
	// merge triMaps, filter duplicate Tris
	std::set<Tri<T> *> triSet;
	this->mergeTriMap(triSet, triMap);
	// calculate Tri arc centers
	std::set<Tri<T> *>::iterator p;
	for (p = triSet.begin(); p != triSet.end(); p++)
	{
		r_vecList.push_back(new Vector<T>((*p)->calcCent()));
		(*p)->mCentIdx = r_vecList.size() - 1;
	}
	// connect Tri arc centers, filter duplicate edges
	std::set<long> edgeSet;
	std::set<Tri<T> *>::iterator q;
	for (q = triSet.begin(); q != triSet.end(); q++)
	{
		std::set<Tri<T> *> triSet2;
		(*q)->getAdjacent(triSet2, triMap);
		if (triSet2.size() > 2) // ignore boundary Tris
		{
			std::set<Tri<T> *>::iterator s;
			for (s = triSet2.begin(); s != triSet2.end(); s++)
				edgeSet.insert(MAKELONG(
					min((*q)->mCentIdx, (*s)->mCentIdx),
					max((*q)->mCentIdx, (*s)->mCentIdx)
					));
		}
	}
	// extract endpoints (then cull and clip, add vertices as needed)
	Vector<T> pMin = Vector<T>(0.0, 0.0), pMax = Vector<T>(1.0, 1.0);
	std::set<long>::iterator t;
	for (t = edgeSet.begin(); t != edgeSet.end(); t++)
	{
		int idx1 = LOWORD(*t);
		int idx2 = HIWORD(*t);
		if (!r_vecList[idx1]->vec_inRange(0.0, 1.0))
		{
			r_vecList.push_back(new Vector<T>(*r_vecList[idx1]));
			idx1 = r_vecList.size() - 1;
		}
		if (!r_vecList[idx2]->vec_inRange(0.0, 1.0))
		{
			r_vecList.push_back(new Vector<T>(*r_vecList[idx2]));
			idx2 = r_vecList.size() - 1;
		}
		_clip2D(*r_vecList[idx1], *r_vecList[idx2], pMin, pMax);
		if (
			r_vecList[idx1]->vec_inRange(0.0, 1.0) ||
			r_vecList[idx2]->vec_inRange(0.0, 1.0)
			)
			r_edgeList.push_back(new std::pair<int, int>(idx1, idx2));
	}
	// sort voronoi segments by density
	std::vector<Vector<T> *> midList;
	for (int i = 0; i < r_edgeList.size(); i++)
	{
		Vector<T> *v1 = r_vecList[r_edgeList[i]->first];
		Vector<T> *v2 = r_vecList[r_edgeList[i]->second];
		midList.push_back(new Vector<T>((*v1 + *v2) * 0.5));
	}
	std::vector<T> radList;
	for (int j = 0; j < midList.size(); j++)
	{
		T bestDist = BIG_NUMBER;
		for (int k = 0; k < midList.size(); k++)
			if (k != j)
			{
				T curDist = midList[k]->dist(*midList[j]);
				if (curDist < bestDist)
					bestDist = curDist;
			}
		radList.push_back(bestDist);
	}
	ISortable<T, std::pair<int, int> *, TSortDesc<T> >::sort(
		radList, r_edgeList
		);
	//=========================================================
	// clean up
	std::for_each(midList.begin(), midList.end(), std::kill());
	//=========================================================
}

//=============================================================================

template<class T>
void DexKNN<T>::findTriBelong(
	std::vector<Tri<T> *> &r_triList,
	const std::vector<std::set<Tri<T> *> *> &triMap,
	const Vector<T> &v, Tri<T> &startTri
	) const
{
	Tri<T> *seedTri = NULL;
	for (int i = 0; i < 2; i++) // two phases
	{
		Tri<T> *firstTri = !i ? &startTri : seedTri;
		//=========================================================
		std::set<Tri<T> *> visited; std::queue<Tri<T> *> queue;
		visited.insert(firstTri); queue.push(firstTri); // enqueue first Tri
		//=========================================================
		while (!queue.empty()) // while queue not empty
		{
			bool changed = false;
			int cnt = queue.size();
			for (int j = 0; j < cnt; j++) // process queue (in this snapshot)
			{
				Tri<T> *nextTri = std::pop(queue); // get next Tri
				//=========================================================
				// evaluate ownership
				if (!i)
				{
					if (nextTri->isInTri(v))
						{seedTri = nextTri; std::flush(queue); break;}
				}
				else
					if (nextTri->isInArc(v))
						{r_triList.push_back(nextTri); changed = true;}
				//=========================================================
				// enqueue neighbors
				std::set<Tri<T> *> triSet;
				nextTri->getAdjacent(triSet, triMap);
				std::set<Tri<T> *>::iterator p;
				for (p = triSet.begin(); p != triSet.end(); p++)
					if (visited.find(*p) == visited.end())
						{visited.insert(*p); queue.push(*p);}
				//=========================================================
			}
			if (i && !changed)
				std::flush(queue); // 2nd phase, no progress -> bail
		}
		if (!i && !seedTri) // 1st phase, no seed -> bail
			break;
	}
}

//=============================================================================

template<class T>
void DexKNN<T>::genMesh2D(
	std::vector<std::pair<int, int> *> &r_edgeList,
	std::vector<Vector<T> *> &r_vVecList,
	std::vector<std::pair<int, int> *> &r_vEdgeList,
	const std::vector<Vector<T> *> &vecList
	) const
{
	//=========================================================
	// build geometry
	std::vector<Vector<T> *> vecList2;
	std::copy(
		vecList.begin(), vecList.end(), std::back_inserter(vecList2)
		); // add existing sites
	for (int i = 0; i < 3; i++)
		vecList2.push_back(new Vector<T>(
			BIG_NUMBER * cos(toRad(-90 + i * 120)),
			BIG_NUMBER * sin(toRad(-90 + i * 120))
			)); // add additional large Tri
	//=========================================================
	// register geometry
	std::vector<std::set<Tri<T> *> *> triMap;
	for (int j = 0; j < vecList2.size(); j++)
		triMap.push_back(new std::set<Tri<T> *>()); // one triMap per site
	Tri<T> *startTri, *bigTri;
	(startTri = new Tri<T>(
		vecList2, vecList2.size() - 3, vecList2.size() - 2, vecList2.size() - 1
		))->reg(triMap); // register large Tri
	bigTri = new Tri<T>(*startTri); // backup large Tri
	//=========================================================
	// trim and remesh
	std::vector<int> perm = std::gen_permute<int>(vecList.size());
	for (int k = 0; k < vecList.size(); k++) // randomly add new sites
	{
		std::vector<Tri<T> *> cutList;
		this->findTriBelong(
			cutList, triMap, *vecList[perm[k]], *startTri
			); // get circum-circle Tris (near recently added)
		std::set<int> idxSet;
		std::vector<int> idxList;
		std::vector<T> angList;
		for (int n = 0; n < cutList.size(); n++)
		{
			for (int s = 0; s < 3; s++)
			{
				int idx = cutList[n]->mVecIdx[s];
				if (idxSet.find(idx) == idxSet.end())
				{
					idxSet.insert(idx); // cut-boundary
					idxList.push_back(idx); // ordered cut-boundary
					Vector<T> delta = *vecList2[idx] - *vecList2[perm[k]];
					angList.push_back(toAng(delta[0], delta[1]));
				}
			}
			delete cutList[n]->unreg(triMap); // remove patch
		}
		ISortable<T, int>::sort(angList, idxList);
		for (int t = 0; t < idxList.size(); t++)
			(startTri = new Tri<T>(
				vecList2,
				perm[k], idxList[t], idxList[(t + 1) % idxList.size()]
				))->reg(triMap); // add new triangulation
	}
	//=========================================================
	// extract delaunay edges & voronoi boundaries
	this->edgeFromTri(r_edgeList, triMap, *bigTri);
	this->voroFromTri(r_vVecList, r_vEdgeList, triMap);
	//=========================================================
	// clean up
	for (int u = 0; u < 3; u++)
		delete std::pop(vecList2); // kill large Tri
	this->killTriMap(triMap); // kill triMap Tris
	std::for_each(triMap.begin(), triMap.end(), std::kill()); // kill triMap
	delete bigTri; // kill large Tri backup
	//=========================================================
}
template<class T>
void DexKNN<T>::genRoadMap(
	std::vector<Vector<T> *> &r_vecList,
	const std::vector<Vector<T> *> &vVecList,
	const std::vector<std::pair<int, int> *> &vEdgeList,
	int sampFreq, int rndCnt, T minLen, int centCnt, int iters, T minDist
	) const
{
	int cnt = max(vEdgeList.size() * 0.5, 1); // hack
	for (int i = 0; i < cnt; i++)
	{
		Vector<T> *v1 = vVecList[vEdgeList[i]->first];
		Vector<T> *v2 = vVecList[vEdgeList[i]->second];
		T dist = v1->dist(*v2);
		if (dist > minLen) // if segment length acceptable
		{
			//=========================================================
			// generate random samples
			T scale = 1 - (T) i / cnt; // hack
			int pSampCnt = map_linear(dist, 0, sqrt(2), 1, sampFreq) * scale;
			int pRndCnt = map_linear(dist, 0, sqrt(2), rndCnt, 1);
			std::vector<Vector<T> *> sampVecList =
				_sampLine(*v1, *v2, pSampCnt, pRndCnt);
			//=========================================================
			std::vector<Vector<T> *> freeVecList;
			for (int j = 0; j < sampVecList.size(); j++)
				if (mFuncClip((*sampVecList[j])[0], (*sampVecList[j])[1]))
				{
					freeVecList.push_back(
						new Vector<T>(*sampVecList[j])
						); // clip samples
					if (freeVecList.size() > max(pSampCnt * 0.5, 1))
						break; // hack
				}
			this->cluster(
				r_vecList, freeVecList, centCnt, iters, minDist
				); // cluster samples
			//=========================================================
			// clean up
			std::for_each(sampVecList.begin(), sampVecList.end(), std::kill());
			std::for_each(freeVecList.begin(), freeVecList.end(), std::kill());
			//=========================================================
		}
	}
}
template<class T>
bool DexKNN<T>::genPath(
	std::vector<int> &r_pathIdxList,
	std::vector<int> &r_freeIdxList,
	const std::vector<std::pair<int, int> *> &edgeList,
	const std::vector<Vector<T> *> &vecList,
	int srcIdx, int destIdx, int stepCnt
	) const
{
	//=========================================================
	// build free roadmap
	for (int i = 0; i < edgeList.size(); i++)
	{
		Vector<T> *v1 = vecList[edgeList[i]->first];
		Vector<T> *v2 = vecList[edgeList[i]->second];
		for (int j = 0; j < stepCnt; j++)
		{
			Vector<T> tmp = v1->vec_interp(*v2, (T) j / stepCnt);
			if (!mFuncClip(tmp[0], tmp[1]))
				break;
		}
		if (j == stepCnt)
			r_freeIdxList.push_back(i);
	}
	//=========================================================
	// prepare dijkstra
	std::vector<std::set<int> *> mapList;
	std::vector<int> prevIdxList;
	std::vector<int> costList;
	for (int k = 0; k < vecList.size(); k++)
	{
		mapList.push_back(new std::set<int>());
		prevIdxList.push_back(0);
		costList.push_back(BIG_NUMBER);
	}
	prevIdxList[srcIdx] = -1;
	costList[srcIdx] = 0;
	for (int n = 0; n < r_freeIdxList.size(); n++)
	{
		int a = edgeList[r_freeIdxList[n]]->first;
		int b = edgeList[r_freeIdxList[n]]->second;
		mapList[a]->insert(b);
		mapList[b]->insert(a);
	}
	//=========================================================
	std::queue<int> queue;
	queue.push(srcIdx); // enqueue first
	//=========================================================
	while (!queue.empty()) // while queue not empty
	{
		int cnt = queue.size();
		for (int s = 0; s < cnt; s++) // process queue (in this snapshot)
		{
			int nextIdx = std::pop(queue); // get next idx
			//=========================================================
			// check destination
			if (nextIdx == destIdx)
			{
				for (int t = destIdx; prevIdxList[t] != -1; t = prevIdxList[t])
					r_pathIdxList.insert(r_pathIdxList.begin(), t);
				r_pathIdxList.insert(r_pathIdxList.begin(), srcIdx);
				std::flush(queue);
				break;
			}
			//=========================================================
			// enqueue neighbors
			std::set<int> *mapSet = mapList[nextIdx];
			std::set<int>::iterator p;
			for (p = mapSet->begin(); p != mapSet->end(); p++)
				if (*p != nextIdx)
					if (costList[*p] > costList[nextIdx] + 1)
					{
						costList[*p] = costList[nextIdx] + 1;
						prevIdxList[*p] = nextIdx;
						queue.push(*p);
					}
			//=========================================================
		}
	}
	//=========================================================
	// clean up
	std::for_each(mapList.begin(), mapList.end(), std::kill());
	//=========================================================
	return !r_pathIdxList.empty();
}

//=============================================================================

template<class T = double>
class Cluster
{
private:
	const std::vector<Vector<T> *> *mVecList;
	std::vector<int> mIdxList;
public:
	Vector<T> mMean;

	Cluster(const std::vector<Vector<T> *> *vecList)
		{mVecList = vecList; mMean.resize(DIM_CNT);}
	~Cluster() {}
	void randomize()
		{mMean.randomize();}
	T dist(int idx) const
		{return mMean.dist(*(*mVecList)[idx]);}
	void clear()
		{mIdxList.clear();}
	void insert(int idx)
		{mIdxList.push_back(idx);}
	bool empty()
		{return mIdxList.empty();}
	bool update()
	{
		Vector<T> prevMean = mMean;
		mMean = 0;
		for (int i = 0; i < mIdxList.size(); i++)
			mMean += *(*mVecList)[mIdxList[i]];
		if (mIdxList.size())
			mMean /= mIdxList.size();
		return mMean != prevMean;
	}
};

//=============================================================================

template<class T>
void DexKNN<T>::cluster(
	std::vector<Vector<T> *> &r_centList,
	const std::vector<Vector<T> *> &vecList, int centCnt, int iters, T minDist
	) const
{
	std::vector<Cluster<T> *> clustList;
	for (int i = 0; i < centCnt; i++)
	{
		clustList.push_back(new Cluster<T>(&vecList));
		clustList[i]->randomize(); // randomize cluster centers
	}
	for (int j = 0; j < iters; j++)
	{
		for (int k = 0; k < clustList.size(); k++)
			clustList[k]->clear(); // reset cluster membership
		for (int n = 0; n < vecList.size(); n++) // for each sample
		{
			//=========================================================
			// find nearest cluster
			T bestDist = (T) BIG_NUMBER; int bestIdx = -1;
			for (int s = 0; s < clustList.size(); s++)
			{
				T curDist = clustList[s]->dist(n);
				if (curDist < bestDist)
					{bestDist = curDist; bestIdx = s;}
			}
			//=========================================================
			clustList[bestIdx]->insert(n); // assign sample membership
		}
		bool change = false;
		for (int t = 0; t < clustList.size(); t++)
			change |= clustList[t]->update(); // update cluster center
		if (!change)
			break; // convergence
	}
	//=========================================================
	// ensure cluster separation, filter empty
	std::vector<Cluster<T> *> farList;
	for (int p = 0; p < clustList.size(); p++)
	{
		for (int q = 0; q < farList.size(); q++)
			if (clustList[q]->mMean.dist(clustList[p]->mMean) < minDist)
				break;
		if (q == farList.size())
			if (!clustList[p]->empty())
			{
				farList.push_back(clustList[p]);
				r_centList.push_back(
					new Vector<T>(clustList[p]->mMean)
					); // extract cluster centers
			}
	}
	//=========================================================
	// clean up
	std::for_each(clustList.begin(), clustList.end(), std::kill());
	//=========================================================
}

//=============================================================================

template<class T> void DexKNN<T>::toString(char *buffer) {}

#endif