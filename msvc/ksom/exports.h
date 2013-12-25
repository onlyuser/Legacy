#ifndef H_EXPORTS
#define H_EXPORTS

#include <windows.h> /* DllMain types */
#include <math.h>
#include "exception.h"
#include "kmapex.h"
#include "profiler.h"
#include "vbcall.h"
#include "crtdbg.h" /* mem-leak tester */

#define CHECK_LEAK

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved);
void ksom_init();
void ksom_destroy();

void VB_CALL ksom_regUserFunc(VB_FUNC eventFunc, VB_FUNC2 messageFunc);
int VB_CALL ksom_sum(int a, int b);
char *VB_CALL ksom_echo(char *text);
void VB_CALL ksom_echo2(float *data);
void VB_CALL ksom_test(char *data);
void VB_CALL ksom_load(int groupCnt, float *data, int length, int windowSize, int stepSize, float min, float max, bool kernel);
void VB_CALL ksom_loadMatrix(int groupCnt, float *data, int rowSize, int colSize, int windowSize);
void VB_CALL ksom_tallyMatrix(int tallySize);
float VB_CALL ksom_verify(int windowSize, int tallySize);
void VB_CALL ksom_unload();
void VB_CALL ksom_clear();
void VB_CALL ksom_reset();
int VB_CALL ksom_getGroupCnt();
int VB_CALL ksom_getGroupSize(int index);
int VB_CALL ksom_getGroupMember(int groupIndex, int index);
void VB_CALL ksom_getGroupKernel(int groupIndex, float *data);
void VB_CALL ksom_getGroupInfo(int groupIndex);
float VB_CALL ksom_getGroupError(int groupIndex);
float VB_CALL ksom_getGroupMemberError(int groupIndex, int index);
float VB_CALL ksom_exec(bool init, bool train, bool eval);
void VB_CALL ksom_execBatch(int iters, int maxEpochs, float maxEntropy);
void VB_CALL ksom_simplify(float nearThresh);
void VB_CALL ksom_print();

#endif