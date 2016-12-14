Attribute VB_Name = "Module1"
Option Explicit

Public Const BNF_ROOT As String = "S"

Declare Sub DexCC_regUserFunc Lib "DexCC" (ByVal pFuncEvent As Long, ByVal pFuncMsg As Long)
Declare Function DexCC_sum Lib "DexCC" (ByVal a As Long, ByVal b As Long) As Long
Declare Function DexCC_echo Lib "DexCC" (ByVal Text As String) As String
Declare Sub DexCC_setModeVB Lib "DexCC" (ByVal Value As Long)
Declare Sub DexCC_reset Lib "DexCC" ()
Declare Sub DexCC_load Lib "DexCC" (ByVal Filename As String, ByVal Root As String)
Declare Sub DexCC_toString Lib "DexCC" (ByVal Buffer As String)
Declare Sub DexCC_buildTable Lib "DexCC" (ByVal Root As String)
Declare Sub DexCC_parse Lib "DexCC" (ByVal Root As String, ByVal Expr As String, ByVal Buffer As String)
Declare Sub DexCC_getFirst Lib "DexCC" (ByVal Expr As String, ByVal Buffer As String)
Declare Sub DexCC_getFollow Lib "DexCC" (ByVal Root As String, ByVal Expr As String, ByVal Buffer As String)
Declare Sub DexCC_getItems Lib "DexCC" (ByVal Buffer As String)
Sub Main()

    Call DexCC_regUserFunc(AddressOf FuncEvent, AddressOf FuncMsg)
    Call DexCC_setModeVB(1)
    Call Form1.Show
    
End Sub
Sub FuncEvent()

    DoEvents
    
End Sub
Sub FuncMsg(ByVal Text As String)

    Call Err.Raise(vbObjectError, , Text)
    
End Sub
