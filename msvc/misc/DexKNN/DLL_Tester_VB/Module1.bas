Attribute VB_Name = "Module1"
Option Explicit

Declare Sub DexKNN_regFuncUser Lib "DexKNN" (ByVal pFuncEvent As Long, ByVal pFuncMsg As Long)
Declare Sub DexKNN_regFuncClip Lib "DexKNN" (ByVal pFuncClip As Long)
Declare Function DexKNN_sum Lib "DexKNN" (ByVal a As Long, ByVal b As Long) As Long
Declare Function DexKNN_echo Lib "DexKNN" (ByVal Text As String) As String
Declare Sub DexKNN_reset Lib "DexKNN" ()
Declare Sub DexKNN_build Lib "DexKNN" (ByVal vecArr As Long, ByVal vecCnt As Long)
Declare Function DexKNN_find Lib "DexKNN" (ByVal v As Long) As Long
Declare Sub DexKNN_genMesh2D Lib "DexKNN" ( _
    ByVal r_edgeArr As Long, r_edgeCnt As Long, _
    ByVal r_vVecArr As Long, r_vVecCnt As Long, ByVal r_vEdgeArr As Long, r_vEdgeCnt As Long, _
    ByVal vecArr As Long, ByVal vecCnt As Long _
    )
Declare Sub DexKNN_genRoadmap Lib "DexKNN" ( _
    ByVal r_vecArr As Long, r_vecCnt As Long, _
    ByVal vVecArr As Long, ByVal vVecCnt As Long, ByVal vEdgeArr As Long, ByVal vEdgeCnt As Long, _
    ByVal sampFreq As Long, ByVal rndCnt As Long, ByVal minLen As Double, _
    ByVal centCnt As Long, ByVal iters As Long, ByVal minDist As Double _
    )
Declare Function DexKNN_genPath Lib "DexKNN" ( _
    ByVal r_pathIdxArr As Long, r_pathIdxCnt As Long, _
    ByVal r_freeIdxArr As Long, r_freeIdxCnt As Long, _
    ByVal edgeArr As Long, ByVal edgeCnt As Long, ByVal vecArr As Long, ByVal vecCnt As Long, _
    ByVal srcIdx As Long, ByVal destIdx As Long, ByVal stepCnt As Long _
    ) As Boolean
Declare Sub DexKNN_cluster Lib "DexKNN" ( _
    ByVal r_centArr As Long, r_centCnt As Long, _
    ByVal vecArr As Long, ByVal vecCnt As Long, ByVal iters As Long, ByVal minDist As Double _
    )
Declare Sub DexKNN_toString Lib "DexKNN" (ByVal Buffer As String)
Sub Main()

    Call DexKNN_regFuncUser(AddressOf FuncEvent, AddressOf FuncMsg)
    Call DexKNN_regFuncClip(AddressOf FuncClip)
    Call Form1.Show
    
End Sub
Sub FuncEvent()

    DoEvents
    
End Sub
Sub FuncMsg(ByVal Text As String)

    Call Err.Raise(vbObjectError, , Text)
    
End Sub
Function FuncClip(ByVal x As Double, ByVal y As Double) As Boolean

    If Form1.Picture2.Point( _
        x * Form1.Picture2.ScaleWidth, y * Form1.Picture2.ScaleHeight _
        ) = vbBlack Then _
        FuncClip = True
        
End Function
