#include "exports.h"

KMapEx *mMap;
Profiler *mProfiler = NULL;

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved)
{
	switch (fdwReason) 
	{ 
		case DLL_PROCESS_ATTACH:
			ksom_init();
			break;
		case DLL_PROCESS_DETACH:
			ksom_destroy();
	}
	return TRUE;
}

void ksom_init()
{
}

void ksom_destroy()
{
}

int VB_CALL ksom_sum(int a, int b)
{
	return a + b;
}

char *VB_CALL ksom_echo(char *text)
{
	return text;
}

void VB_CALL ksom_echo2(float *data)
{
	data[1] *= 2;
}

void VB_CALL ksom_test(char *data)
{
//=========================================================
// http://www.cs.wisc.edu/~tlabonne/memleak.html
//=========================================================

#ifdef CHECK_LEAK
	// put these close to WinMain (or main) entrance
	#ifndef NDEBUG
		// get current dbg flag (report it)
		int flag = _CrtSetDbgFlag(_CRTDBG_REPORT_FLAG);
		// logically OR leak check bit
		flag |= _CRTDBG_LEAK_CHECK_DF;
		// set the flags again
		_CrtSetDbgFlag(flag); 
	#endif
	// put this right after the flag settings from above
	#ifdef _DEBUG
		#define new new(_NORMAL_BLOCK, __FILE__, __LINE__)
	#endif
#endif

//=========================================================
// block-end
//=========================================================

	try
	{
		mMap = new KMapEx(8, 2, 0, 0);
		mMap->load(cstr(data), 2, 2, false);
		mMap->exec(1000, 10, 0.5f);
		mMap->simplify(0.25f);
		output(mMap->print());
		delete mMap;
	}
	catch (Exception e)
	{
		output("error: " + e.getData());
	}
}

void VB_CALL ksom_load(int groupCnt, float *data, int length, int windowSize, int stepSize, float min, float max, bool kernel)
{
	mMap = new KMapEx(groupCnt, windowSize, min, max);
	mMap->load(data, length, windowSize, stepSize, kernel);
}

void VB_CALL ksom_loadMatrix(int groupCnt, float *data, int rowSize, int colSize, int windowSize)
{
	mMap = new KMapEx(groupCnt, windowSize * rowSize, 0, 1);
	mProfiler = new Profiler(mMap, data, rowSize, colSize);
	mProfiler->load(windowSize);
}

void VB_CALL ksom_tallyMatrix(int tallySize)
{
	if (mProfiler != NULL)
		mProfiler->exec(tallySize);
}

float VB_CALL ksom_verify(int windowSize, int tallySize)
{
	if (mProfiler != NULL)
		return mProfiler->verify(windowSize, tallySize);
	return 0;
}

void VB_CALL ksom_unload()
{
	delete mMap;
	if (mProfiler != NULL)
	{
		delete mProfiler;
		mProfiler = NULL;
	}
}

void VB_CALL ksom_clear()
{
	mMap->clear();
}

void VB_CALL ksom_reset()
{
	mMap->reset();
}

int VB_CALL ksom_getGroupCnt()
{
	return mMap->getGroupCnt();
}

int VB_CALL ksom_getGroupSize(int index)
{
	return mMap->getGroupSize(index);
}

int VB_CALL ksom_getGroupMember(int groupIndex, int index)
{
	return mMap->getGroupMember(groupIndex, index);
}

void VB_CALL ksom_getGroupKernel(int groupIndex, float *data)
{
	mMap->getGroupKernel(groupIndex, data);
}

void VB_CALL ksom_getGroupInfo(int groupIndex)
{
	output(mMap->getGroupInfo(groupIndex));
}

float VB_CALL ksom_getGroupError(int groupIndex)
{
	return mMap->getGroupError(groupIndex);
}

float VB_CALL ksom_getGroupMemberError(int groupIndex, int index)
{
	return mMap->getGroupMemberError(groupIndex, index);
}

float VB_CALL ksom_exec(bool init, bool train, bool eval)
{
	return mMap->exec(init, train, eval);
}

void VB_CALL ksom_execBatch(int iters, int maxEpochs, float maxEntropy)
{
	mMap->exec(iters, maxEpochs, maxEntropy);
}

void VB_CALL ksom_simplify(float nearThresh)
{
	mMap->simplify(nearThresh);
}

void VB_CALL ksom_print()
{
	output(mMap->print());
}