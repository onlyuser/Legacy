VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Left            =   120
      Top             =   720
   End
   Begin VB.PictureBox Picture1 
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public mDrawSolid As Boolean

Const PI As Single = 3.14159
Const mOrbitSpeed As Single = 0.01
Const mDollySpeed As Single = 1

Public mAngle As Single
Public mPrevX As Single
Public mPrevY As Single
Public mLongitude As Single
Public mLatitude As Single
Public mRadius As Single
Public mDrawMode As Long
Public mDblSided As Boolean
Public mCamIndex As Long
Private Sub Form_Load()

    mDrawSolid = True
    
    Form1.Caption = App.Title
    Picture1.AutoRedraw = True
    Picture1.BackColor = vbBlack
    Picture1.ScaleMode = vbPixels
    If mDrawSolid Then
        Picture1.FillStyle = vbFSSolid
    Else
        Picture1.FillStyle = vbFSTransparent
    End If
    Call Dex3D_RegUserFunc( _
        AddressOf EventFunc, _
        AddressOf ClearFunc, _
        AddressOf PrintFunc, _
        AddressOf TriFunc, _
        AddressOf GradFunc, _
        AddressOf PixFunc _
    )
    Timer1.Interval = 1
    mRadius = 100
    'mDblSided = True
    
    mCamIndex = Dex3D_AddCamera
    Call Dex3D_SetCamera(mCamIndex, 60 * 3.14159 / 180, 1, 1200, 1, 1, 1, 1)
    Call Dex3D_OrbitCamera(mCamIndex, 0, 0, 0, mRadius, 0, 20 * 3.14159 / 180)
    mDrawMode = 1
    Call Dex3D_SetScene(mCamIndex, Picture1.ScaleWidth, Picture1.ScaleHeight, mDrawMode, mDblSided)
    'mDrawMode = 0
    
    GoTo Skip3:
    'Call Dex3D_AddPoly(10, 48, 24)
    'Call Dex3D_AddPoly(10, 24, 12)
    'Call Dex3D_AddPoly(10, 18, 9)
    Call Dex3D_Load3ds("c:\F16.3DS", -1)
    'Call Dex3D_Load3ds("c:\STEALTH.3DS", 0)
    'MsgBox Dex3D_Load3ds("c:\LUNAR.3DS", -1)
    'MsgBox Dex3D_Load3ds("c:\B1.3DS", -1)
    'Call Dex3D_Load3ds("c:\dc10.3ds", 0)
    'Call Dex3D_Load3ds("c:\body.3ds", 0)
    'Call Dex3D_Load3ds("c:\rotor.3ds", 0)
    'Call Dex3D_Load3ds("c:\Spring.3DS", 0)
    'Call Dex3D_Load3ds("c:\Gear.3DS", 0)
    'Call Dex3D_Load3ds("c:\box.3ds", 0)
    Call Dex3D_FlipFaces(0)
    Call Dex3D_CenterAxis(0)
    Call Dex3D_MoveMesh(0, 0, 0, 0, 0)
Skip3:
    
    'GoTo Skip:
    Call Dex3D_AddPoly(10, 12, 6)
    Call AddBox(0, 0, 0, 10, 10, 10)
    Call AddBox(0, 0, 0, 10, 10, 10)
    Call Dex3D_SetColor(0, -1, vbWhite, 3)
    Call Dex3D_SetColor(1, -1, vbWhite, 3)
    Call Dex3D_SetColor(2, -1, vbWhite, 3)
    Call Dex3D_MoveMesh(0, 0, 0, 0, 0)
    Call Dex3D_MoveMesh(1, 0, 0, 0, 20)
    Call Dex3D_MoveMesh(2, 0, 0, 0, 20)
    Call Dex3D_LinkMesh(1, 0)
    Call Dex3D_LinkMesh(2, 1)
    Call Dex3D_CenterAxis(0)
Skip:
    
    'Call Dex3D_MoveMesh(0, 1, 0, 30 * 3.14159 / 180, 0)
    'Call Dex3D_Load("c:\test.dex", 0)
    'Call Dex3D_Load("c:\test.dex", 1)
    'Call Dex3D_Load("c:\test.dex", 2)
    'Call Dex3D_Save("c:\test.dex", -1)
    
    If Not mDrawSolid Then _
        GoTo Skip2:
    Call Dex3D_AddLight
    Call Dex3D_AddLight
    Call Dex3D_AddLight
    Call Dex3D_SetLight(0, vbRed, 1, 600)
    Call Dex3D_SetLight(1, vbBlue, 1, 600)
    Call Dex3D_SetLight(2, vbGreen, 1, 600)
    Call Dex3D_MoveLight(0, -50, 50, -50)
    Call Dex3D_MoveLight(1, 50, 50, 50)
    Call Dex3D_MoveLight(2, -100, -100, -100)
Skip2:
    
End Sub
Private Sub Form_Resize()

    Call Picture1.Move(0, 0, Form1.ScaleWidth, Form1.ScaleHeight)
    Call Dex3D_SetScene(mCamIndex, Picture1.ScaleWidth, Picture1.ScaleHeight, mDrawMode + 1, mDblSided)
    
End Sub
Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)

    mDrawMode = (mDrawMode + 1) Mod 2
    Call Dex3D_SetScene(mCamIndex, Picture1.ScaleWidth, Picture1.ScaleHeight, mDrawMode + 1, mDblSided)
    
End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)

    Select Case Button
        Case 1 'orbit
            Picture1.MousePointer = 15
            mLongitude = mLongitude - (x - mPrevX) * mOrbitSpeed
            mLatitude = mLatitude + (y - mPrevY) * mOrbitSpeed
            If mLongitude > PI Then mLongitude = mLongitude - (2 * PI)
            If mLongitude < -PI Then mLongitude = mLongitude + (2 * PI)
            If mLatitude > (PI / 2) Then mLatitude = (PI / 2)
            If mLatitude < -(PI / 2) Then mLatitude = -(PI / 2)
        Case 2 'dolly
            Picture1.MousePointer = 7
            mRadius = mRadius + (y - mPrevY) * mDollySpeed
            If mRadius < 0 Then mRadius = 0
        Case Else
            Picture1.MousePointer = 0
    End Select
    mPrevX = x
    mPrevY = y
    
End Sub
Private Sub Timer1_Timer()

    If mAngle < 360 Then
        mAngle = mAngle + 1
    Else
        mAngle = 0
    End If
    'Call Dex3D_MoveMesh(0, 1, 0, 0, mAngle * 3.14159 / 180)
    'Call Dex3D_MoveMesh(1, 1, 0, mAngle * 3.14159 / 180, 0)
    'Call Dex3D_MoveMesh(2, 1, mAngle * 3.14159 / 180, 0, 0)
    Call Dex3D_OrbitCamera(mCamIndex, 0, 0, 0, mRadius, mLongitude, mLatitude)
    Form1.Caption = _
        Dex3D_Render(mCamIndex) & _
        " (" & _
            CInt(mLongitude * 180 / 3.14159) & ", " & _
            CInt(mLatitude * 180 / 3.14159) & _
        ") " & _
        mDrawMode + 1
        
End Sub
