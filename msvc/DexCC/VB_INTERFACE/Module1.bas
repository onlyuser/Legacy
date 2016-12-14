Attribute VB_Name = "Module1"
Option Explicit

Public Const BNF_ROOT As String = "S"

Declare Sub DexCC_regUserFunc Lib "DexCC" (ByVal pFuncEvent As Long, ByVal pFuncMsg As Long)
Declare Function DexCC_sum Lib "DexCC" (ByVal A As Long, ByVal B As Long) As Long
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
Function BuildTree(Text As String, TreeObj As TreeView)

    Dim i As Integer
    Dim Length As Integer
    Dim Token As String
    Dim LHS As String
    Dim RHS As String
    Dim Temp As String
    
    On Error Resume Next
    Call TreeObj.Nodes.Clear
    If Text <> "" Then
        '=================================== // TAG ROOT
        Call TreeObj.Nodes.Add(, , "S", "S")
        '===================================
        Length = Len(Text)
        i = 1
        Do While i <= Length
            Token = ScanText(Text, i, vbCrLf)
            '=============================== // PARSE T
            LHS = GetEntry(Token, " -> ", 1)
            RHS = GetEntry(Token, " -> ", 2)
            Temp = RHS
            If Left(RHS, 1) = "[" Then _
                RHS = GetEntry(RHS, "]_", 2)
            '===============================
            Call TreeObj.Nodes.Add(LHS, tvwChild, RHS, Temp)
        Loop
        For i = 1 To TreeObj.Nodes.Count
            Call TreeObj.Nodes.Item(i).EnsureVisible
            TreeObj.Nodes.Item(i).Sorted = True
            If TreeObj.Nodes.Item(i).Text <> "S" Then _
                TreeObj.Nodes.Item(i).Text = GetEntry(TreeObj.Nodes.Item(i).Text, "::", 2)
        Next i
        TreeObj.Nodes.Item(1).Selected = True
    End If
    
End Function
