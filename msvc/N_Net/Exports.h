#ifndef H_EXPORTS
#define H_EXPORTS

#include "Shared.h" // VB_CALL
#include "N_Net.h"

N_Net *mN_Net;

void VB_CALL Net_Load(int, int, int, int);
void VB_CALL Net_Unload();
void VB_CALL Net_Config(float, float, float);
void VB_CALL Net_Randomize();
float VB_CALL Net_Run(bool);
void VB_CALL Net_SetVector(float *);
void VB_CALL Net_GetVector(float *);
void VB_CALL Net_Print(char *);

/* extra */
void VB_CALL Net_RegEventFunc(VB_FUNC);
int VB_CALL Net_GetWeightCount();
void VB_CALL Net_SetWeight(int, float);
float VB_CALL Net_GetWeight(int);

/* basic */
float VB_CALL Net_ApplyMatrix(float *, int, bool, int);
float VB_CALL Net_ExtrapArray(float *, int, bool, int);
float VB_CALL Net_ApplyImage(float *, bool, int);

/* advanced */
float VB_CALL Net_ExtrapMatrix(float *, int, int, int, int);

#endif
