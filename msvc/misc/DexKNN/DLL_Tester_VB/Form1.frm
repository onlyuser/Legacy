VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4395
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   293
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   312
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture2 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      Height          =   495
      Left            =   0
      ScaleHeight     =   29
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   77
      TabIndex        =   5
      Top             =   0
      Width           =   1215
   End
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      Height          =   2895
      Left            =   120
      ScaleHeight     =   189
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   189
      TabIndex        =   0
      Top             =   120
      Width           =   2895
   End
   Begin VB.Frame Frame1 
      Caption         =   "Controls"
      Height          =   4095
      Left            =   3120
      TabIndex        =   1
      Top             =   120
      Width           =   1455
      Begin VB.CommandButton Command5 
         Caption         =   "Cluster"
         Height          =   375
         Left            =   120
         TabIndex        =   9
         Top             =   2880
         Width           =   1215
      End
      Begin VB.TextBox Text2 
         Height          =   375
         Left            =   120
         TabIndex        =   8
         Text            =   "5"
         Top             =   2400
         Width           =   615
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Path"
         Height          =   375
         Left            =   120
         TabIndex        =   7
         Top             =   1920
         Width           =   1215
      End
      Begin VB.CommandButton Command3 
         Caption         =   "Roadmap"
         Height          =   375
         Left            =   120
         TabIndex        =   6
         Top             =   1560
         Width           =   1215
      End
      Begin VB.TextBox Text1 
         Height          =   375
         Left            =   120
         TabIndex        =   4
         Text            =   "10"
         Top             =   1080
         Width           =   615
      End
      Begin VB.CommandButton Command2 
         Caption         =   "Mesh"
         Height          =   375
         Left            =   120
         TabIndex        =   3
         Top             =   600
         Width           =   1215
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Clear"
         Height          =   375
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   1215
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const MAX_BUF As Long = 500
Const DRAW_WIDTH As Long = 20
Const MARK_RAD As Long = 2

Dim mClearLock As Boolean
Dim mResetLock As Boolean
Dim mSrcPos As Point2d
Dim mDestPos As Point2d

Private Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
Private Sub Picture1_Paint()

    '//=====================================
    Call Picture1.Cls 'init surface
    Call StretchBlt( _
        Picture1.hdc, 0, 0, Picture1.ScaleWidth, Picture1.ScaleHeight, _
        Picture2.hdc, 0, 0, Picture2.ScaleWidth, Picture2.ScaleHeight, vbSrcCopy _
        ) 'load double-buffer
    Call DrawMap(Picture1, 2)
    '//=====================================
    Picture1.FillStyle = vbFSSolid
    Picture1.FillColor = vbRed
    Picture1.ForeColor = vbRed
    Picture1.Circle ( _
        mSrcPos.x * Picture1.ScaleWidth, mSrcPos.y * Picture1.ScaleHeight _
        ), MARK_RAD
    Picture1.FillColor = vbGreen
    Picture1.ForeColor = vbGreen
    Picture1.Circle ( _
        mDestPos.x * Picture1.ScaleWidth, mDestPos.y * Picture1.ScaleHeight _
        ), MARK_RAD
    Picture1.FillColor = vbBlack
    Picture1.ForeColor = vbBlack
    Picture1.FillStyle = vbFSTransparent
    
End Sub
Private Sub Form_Resize()

    Call Picture1.Move(0, 0, Me.ScaleHeight, Me.ScaleHeight)
    Call Frame1.Move(Picture1.Width, 0)
    Call Picture1_Paint 'refresh
    
End Sub
Private Sub Form_Load()

    Picture2.Visible = False 'hide double-buffer
    Call Picture2.Move(0, 0, 200, 200) 'resize double-buffer
    Call Command1_Click 'clear
    Me.Width = Me.Height + Frame1.Width * Screen.TwipsPerPixelX 'hack
    
End Sub
Private Sub Command1_Click() 'clear

    '//=====================================
    'clear geometry
    Call DexKNN_reset 'reset dll
    Call ResetMap 'reset vb
    '//=====================================
    If Not mClearLock Then
        '//=====================================
        'clear picture
        Call Picture2.Cls 'clear double-buffer
        '//=====================================
        'reset path endpoints
        mSrcPos.x = -1
        mSrcPos.y = -1
        mDestPos.x = -1
        mDestPos.y = -1
        '//=====================================
        'disable path options
        Command3.Enabled = False
        Command4.Enabled = False
        '//=====================================
    End If
    Call Picture1_Paint 'refresh
    
End Sub
Private Sub Command2_Click() 'mesh

    On Error Resume Next
    If Not mResetLock Then
        '//=====================================
        'clear geometry without clearing picture
        mClearLock = True
        Call Command1_Click 'clear
        mClearLock = False
        '//=====================================
        ' generate random geometry
        Call GenRandomVec(CInt(Text1.Text))
        '//=====================================
    End If
    '//=====================================
    'build mesh
    Call CacheMap 'vb -> dll
    Call DexKNN_build(VarPtr(mVecArr(0)), UBound(mVecList))
    ReDim mEdgeArr(MAX_BUF)
    ReDim m_vVecArr(MAX_BUF)
    ReDim m_vEdgeArr(MAX_BUF)
    Dim edgeCnt As Long
    Dim vVecCnt As Long
    Dim vEdgeCnt As Long
    Call DexKNN_genMesh2D( _
        VarPtr(mEdgeArr(0)), edgeCnt, _
        VarPtr(m_vVecArr(0)), vVecCnt, VarPtr(m_vEdgeArr(0)), vEdgeCnt, _
        VarPtr(mVecArr(0)), UBound(mVecList) _
        )
    ReDim Preserve mEdgeArr(Max(edgeCnt * 2 - 1, 0))
    ReDim Preserve m_vVecArr(Max(vVecCnt * 2 - 1, 0))
    ReDim Preserve m_vEdgeArr(Max(vEdgeCnt * 2 - 1, 0))
    Call SyncMap 'dll -> vb
    '//=====================================
    'hide path
    mPathIdxCnt = 0
    mFreeIdxCnt = 0
    '//=====================================
    Call Picture1_Paint 'refresh
    
End Sub
Private Sub Command3_Click() 'roadmap

    '//=====================================
    'add seed geometry
    If UBound(mVecList) = 0 Then
        Call AddPoint(mSrcPos.x, mSrcPos.y)
        Call AddPoint(mDestPos.x, mDestPos.y)
    End If
    '//=====================================
    'build mesh without clearing geometry
    mResetLock = True
    Call Command2_Click 'mesh
    mResetLock = False
    '//=====================================
    'build mesh on picture
    Call CacheMap 'vb -> dll
    ReDim Preserve mVecArr(MAX_BUF)
    Dim vecCnt As Long
    vecCnt = UBound(mVecList)
    Const SAMP_FREQ As Long = 40
    Const RND_CNT As Long = 20
    Const MIN_LEN As Double = 0.1
    Const CENT_CNT As Long = 5
    Const CLUST_ITERS As Long = 100
    Const MIN_DIST As Double = 0.1
    Call DexKNN_genRoadmap( _
        VarPtr(mVecArr(0)), vecCnt, _
        VarPtr(m_vVecArr(0)), UBound(m_vVecArr), VarPtr(m_vEdgeArr(0)), UBound(m_vEdgeArr), _
        SAMP_FREQ, RND_CNT, MIN_LEN, CENT_CNT, CLUST_ITERS, MIN_DIST _
        )
    ReDim Preserve mVecArr(Max(vecCnt * 2 - 1, 0))
    Call DexKNN_build(VarPtr(mVecArr(0)), UBound(mVecList))
    Call SyncMap 'dll -> vb
    '//=====================================
    Call Picture1_Paint 'refresh
    
End Sub
Private Sub Command4_Click() 'path

    '//=====================================
    'find path on geometry
    Call CacheMap 'vb -> dll
    ReDim mPathIdxArr(MAX_BUF)
    ReDim mFreeIdxArr(MAX_BUF)
    Const SRC_IDX As Long = 0
    Const DEST_IDX As Long = 1
    Const STEP_CNT As Long = 5
    Call DexKNN_genPath( _
        VarPtr(mPathIdxArr(0)), mPathIdxCnt, VarPtr(mFreeIdxArr(0)), mFreeIdxCnt, _
        VarPtr(mEdgeArr(0)), UBound(mEdgeList), VarPtr(mVecArr(0)), UBound(mVecList), _
        SRC_IDX, DEST_IDX, STEP_CNT _
        )
    ReDim Preserve mPathIdxArr(Max(mPathIdxCnt - 1, 0))
    ReDim Preserve mFreeIdxArr(Max(mFreeIdxCnt - 1, 0))
    Call SyncMap 'dll -> vb
    '//=====================================
    Call Picture1_Paint 'refresh
    
End Sub
Private Sub Command5_Click() 'cluster

    Call Command1_Click 'clear
    '//=====================================
    ' generate random geometry
    Call GenRandomVec(CInt(Text1.Text))
    '//=====================================
    'cluster geometry
    Call CacheMap 'vb -> dll
    Call DexKNN_build(VarPtr(mVecArr(0)), UBound(mVecList))
    ReDim m_vVecArr(MAX_BUF)
    Dim vVecCnt As Long
    vVecCnt = CInt(Text2.Text)
    Const CLUST_ITERS As Long = 100
    Const MIN_DIST As Double = 0.1
    Call DexKNN_cluster( _
        VarPtr(m_vVecArr(0)), vVecCnt, _
        VarPtr(mVecArr(0)), UBound(mVecList), CLUST_ITERS, MIN_DIST _
        )
    ReDim Preserve m_vVecArr(Max(vVecCnt * 2 - 1, 0))
    Call SyncMap 'dll -> vb
    '//=====================================
    Call Picture1_Paint 'refresh
    
End Sub
Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)

    Picture1.CurrentX = x
    Picture1.CurrentY = y
    If Button = vbLeftButton Then
        '//=====================================
        'save src
        mSrcPos.x = x / Picture1.ScaleWidth
        mSrcPos.y = y / Picture1.ScaleHeight
        '//=====================================
    End If
    
End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)

    If Button Then
        Picture1.DrawWidth = DRAW_WIDTH
        Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(x, y), vbBlack
        Picture1.DrawWidth = 1
        Me.Caption = "Drawing.."
    Else
        Dim v(2) As Double
        v(0) = x / Picture1.ScaleWidth
        v(1) = y / Picture1.ScaleHeight
        Me.Caption = CStr(DexKNN_find(VarPtr(v(0)))) & "_" & CStr(FuncClip(v(0), v(1)))
    End If
    
End Sub
Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)

    Call StretchBlt( _
        Picture2.hdc, 0, 0, Picture2.ScaleWidth, Picture2.ScaleHeight, _
        Picture1.hdc, 0, 0, Picture1.ScaleWidth, Picture1.ScaleHeight, vbSrcCopy _
        ) 'save double-buffer
    If Button = vbLeftButton Then
        '//=====================================
        'save dest
        mDestPos.x = x / Picture1.ScaleWidth
        mDestPos.y = y / Picture1.ScaleHeight
        '//=====================================
        'enable path options
        Command3.Enabled = True
        Command4.Enabled = True
        '//=====================================
        Call Picture1_Paint 'refresh
    End If
    
End Sub
