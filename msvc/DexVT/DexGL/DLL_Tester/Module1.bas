Attribute VB_Name = "Module1"
Option Explicit

Declare Sub DexGL_regUserFunc Lib "DexGL" (ByVal pEventFunc As Long, ByVal pMessageFunc As Long)
Declare Function DexGL_sum Lib "DexGL" (ByVal a As Long, ByVal b As Long) As Long
Declare Function DexGL_echo Lib "DexGL" (ByVal Text As String) As String
Declare Sub DexGL_load Lib "DexGL" (ByVal hWnd As Long)
Declare Sub DexGL_unload Lib "DexGL" ()
Declare Sub DexGL_resize Lib "DexGL" (ByVal Width As Long, ByVal Height As Long)
Declare Sub DexGL_clear Lib "DexGL" ()
Declare Sub DexGL_tri Lib "DexGL" ( _
    ByVal c1 As Long, ByVal c2 As Long, ByVal c3 As Long, _
    ByVal x1 As Single, ByVal y1 As Single, _
    ByVal x2 As Single, ByVal y2 As Single, _
    ByVal x3 As Single, ByVal y3 As Single _
    )
Declare Sub DexGL_paint Lib "DexGL" ()
Sub Main()

    Call DexGL_regUserFunc(AddressOf EventFunc, AddressOf MessageFunc)
    Call Load(Form1)
    Call DexGL_load(Form1.hWnd)
    Call Form1.Show(1)
    Call DexGL_unload
    
End Sub
Sub EventFunc()

    DoEvents
    
End Sub
Sub MessageFunc(ByVal Message As String)

    Call Err.Raise(vbObjectError, , Message)
    
End Sub
