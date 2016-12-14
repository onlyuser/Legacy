Attribute VB_Name = "Module1"
Option Explicit

Declare Sub DexView_regUserFunc Lib "DexView" (ByVal pEventFunc As Long, ByVal pMessageFunc As Long)
Declare Function DexView_sum Lib "DexView" (ByVal a As Long, ByVal b As Long) As Long
Declare Function DexView_echo Lib "DexView" (ByVal Text As String) As String
Declare Sub DexView_launchEx Lib "DexView" (ByVal LibName As String, ByVal EntryWndProc As String, ByVal Text As String, ByVal Width As Long, ByVal Height As Long, ByVal ThreadCnt As Long, ThreadProc As Long, ThreadInt As Long)
Sub Main()

    Call DexView_regUserFunc(AddressOf EventFunc, AddressOf MessageFunc)
    Call DexView_launchEx("", "", "DexView", 480, 320, 0, 0, 0)
    
End Sub
Sub EventFunc()

    DoEvents
    
End Sub
Sub MessageFunc(ByVal Message As String)

    Call Err.Raise(vbObjectError, , Message)
    
End Sub
