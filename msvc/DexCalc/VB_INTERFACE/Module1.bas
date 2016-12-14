Attribute VB_Name = "Module1"
Option Explicit

Declare Sub DexCalc_regUserFunc Lib "DexCalc" (ByVal pFuncEvent As Long, ByVal pFuncMsg As Long)
Declare Function DexCalc_sum Lib "DexCalc" (ByVal a As Long, ByVal b As Long) As Long
Declare Function DexCalc_echo Lib "DexCalc" (ByVal Text As String) As String
Declare Sub DexCalc_setModeVB Lib "DexCalc" (ByVal Value As Long)
Declare Sub DexCalc_changeBse Lib "DexCalc" (ByVal Expr As String, ByVal Base As Integer, ByVal NewBase As Integer, ByVal Buffer As String)
Declare Function DexCalc_eval Lib "DexCalc" (ByVal Expr As String) As Single
Declare Sub DexCalc_defVar Lib "DexCalc" (ByVal Var As String)
Declare Sub DexCalc_undefVar Lib "DexCalc" (ByVal Var As String)
Declare Sub DexCalc_enterScope Lib "DexCalc" ()
Declare Function DexCalc_exitScope Lib "DexCalc" () As Long
Declare Sub DexCalc_reset Lib "DexCalc" ()
Sub Main()

    Call DexCalc_regUserFunc(AddressOf FuncEvent, AddressOf FuncMsg)
    Call DexCalc_setModeVB(1)
    Call Form1.Show
    
End Sub
Sub FuncEvent()

    DoEvents
    
End Sub
Sub FuncMsg(ByVal Text As String)

    Call Err.Raise(vbObjectError, , Text)
    
End Sub
