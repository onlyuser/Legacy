#ifndef H_SHARED
#define H_SHARED

// function declarator for VB DLL calling convention compatability
#define VB_CALL __stdcall

// function pointer type for VB callback functions
typedef (VB_CALL *VB_FUNC)();

#endif
