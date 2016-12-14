VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7935
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   5775
   LinkTopic       =   "Form1"
   ScaleHeight     =   7935
   ScaleWidth      =   5775
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture4 
      Height          =   375
      Left            =   120
      ScaleHeight     =   315
      ScaleWidth      =   1155
      TabIndex        =   28
      Top             =   2400
      Width           =   1215
   End
   Begin VB.Frame Frame1 
      Caption         =   "Toolbox"
      Height          =   7695
      Left            =   1440
      TabIndex        =   2
      Top             =   120
      Width           =   4215
      Begin VB.CheckBox Check4 
         Caption         =   "Yes"
         Height          =   255
         Left            =   2880
         TabIndex        =   43
         Top             =   5880
         Width           =   1215
      End
      Begin VB.CheckBox Check3 
         Caption         =   "Yes"
         Height          =   255
         Left            =   2880
         TabIndex        =   41
         Top             =   5160
         Width           =   1215
      End
      Begin VB.CheckBox Check6 
         Caption         =   "Sky"
         Height          =   255
         Left            =   2880
         TabIndex        =   39
         Top             =   7320
         Width           =   1215
      End
      Begin VB.CheckBox Check5 
         Caption         =   "Ground"
         Height          =   255
         Left            =   2880
         TabIndex        =   38
         Top             =   7080
         Width           =   1215
      End
      Begin VB.ComboBox Combo8 
         Height          =   315
         Left            =   2880
         Style           =   2  'Dropdown List
         TabIndex        =   37
         Top             =   2760
         Width           =   1215
      End
      Begin VB.ComboBox Combo7 
         Height          =   315
         Left            =   2880
         Style           =   2  'Dropdown List
         TabIndex        =   35
         Top             =   2040
         Width           =   1215
      End
      Begin VB.TextBox Text4 
         Height          =   375
         Left            =   2880
         TabIndex        =   33
         Top             =   4440
         Width           =   1215
      End
      Begin VB.TextBox Text3 
         Height          =   375
         Left            =   2880
         TabIndex        =   31
         Top             =   3720
         Width           =   1215
      End
      Begin VB.CommandButton Command2 
         Caption         =   "Preview"
         Height          =   375
         Left            =   1440
         TabIndex        =   29
         Top             =   7200
         Width           =   1215
      End
      Begin VB.ComboBox Combo6 
         Height          =   315
         Left            =   1440
         Style           =   2  'Dropdown List
         TabIndex        =   27
         Top             =   6600
         Width           =   1215
      End
      Begin VB.ComboBox Combo5 
         Height          =   315
         Left            =   1440
         Style           =   2  'Dropdown List
         TabIndex        =   26
         Top             =   5880
         Width           =   1215
      End
      Begin VB.ComboBox Combo4 
         Height          =   315
         Left            =   1440
         Style           =   2  'Dropdown List
         TabIndex        =   25
         Top             =   3720
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "60%"
         Height          =   375
         Index           =   2
         Left            =   2040
         TabIndex        =   22
         Top             =   2880
         Width           =   615
      End
      Begin VB.OptionButton Option1 
         Caption         =   "30%"
         Height          =   375
         Index           =   1
         Left            =   1080
         TabIndex        =   21
         Top             =   2880
         Width           =   615
      End
      Begin VB.OptionButton Option1 
         Caption         =   "15%"
         Height          =   375
         Index           =   0
         Left            =   120
         TabIndex        =   20
         Top             =   2880
         Width           =   615
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Apply"
         Height          =   375
         Left            =   120
         TabIndex        =   19
         Top             =   7200
         Width           =   1215
      End
      Begin VB.TextBox Text2 
         Height          =   375
         Left            =   1440
         TabIndex        =   18
         Top             =   5160
         Width           =   1215
      End
      Begin VB.TextBox Text1 
         Height          =   375
         Left            =   1440
         TabIndex        =   17
         Top             =   4440
         Width           =   1215
      End
      Begin VB.ComboBox Combo3 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   16
         Top             =   6600
         Width           =   1215
      End
      Begin VB.CheckBox Check2 
         Caption         =   "Yes"
         Height          =   255
         Left            =   120
         TabIndex        =   15
         Top             =   5880
         Width           =   1215
      End
      Begin VB.ComboBox Combo2 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   14
         Top             =   5160
         Width           =   1215
      End
      Begin VB.CheckBox Check1 
         Caption         =   "Yes"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   4440
         Width           =   1215
      End
      Begin VB.ComboBox Combo1 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   12
         Top             =   3720
         Width           =   1215
      End
      Begin VB.PictureBox Picture3 
         Height          =   2535
         Left            =   120
         MouseIcon       =   "Form1.frx":0000
         ScaleHeight     =   2475
         ScaleWidth      =   2475
         TabIndex        =   3
         Top             =   240
         Width           =   2535
      End
      Begin VB.Label Label16 
         AutoSize        =   -1  'True
         Caption         =   "Solid"
         Height          =   195
         Left            =   2880
         TabIndex        =   42
         Top             =   5640
         Width           =   345
      End
      Begin VB.Label Label15 
         AutoSize        =   -1  'True
         Caption         =   "Visible"
         Height          =   195
         Left            =   2880
         TabIndex        =   40
         Top             =   4920
         Width           =   450
      End
      Begin VB.Image Image2 
         Height          =   1215
         Left            =   2880
         Top             =   240
         Width           =   1215
      End
      Begin VB.Line Line5 
         X1              =   2880
         X2              =   4080
         Y1              =   3360
         Y2              =   3360
      End
      Begin VB.Line Line4 
         X1              =   2880
         X2              =   4080
         Y1              =   1680
         Y2              =   1680
      End
      Begin VB.Line Line3 
         X1              =   2760
         X2              =   2760
         Y1              =   240
         Y2              =   7560
      End
      Begin VB.Label Label14 
         AutoSize        =   -1  'True
         Caption         =   "Sky Map-Dir"
         Height          =   195
         Left            =   2880
         TabIndex        =   36
         Top             =   2520
         Width           =   870
      End
      Begin VB.Label Label13 
         AutoSize        =   -1  'True
         Caption         =   "Sky Texture"
         Height          =   195
         Left            =   2880
         TabIndex        =   34
         Top             =   1800
         Width           =   855
      End
      Begin VB.Label Label12 
         AutoSize        =   -1  'True
         Caption         =   "Tag"
         Height          =   195
         Left            =   2880
         TabIndex        =   32
         Top             =   4200
         Width           =   285
      End
      Begin VB.Label Label11 
         AutoSize        =   -1  'True
         Caption         =   "Name"
         Height          =   195
         Left            =   2880
         TabIndex        =   30
         Top             =   3480
         Width           =   420
      End
      Begin VB.Label Label10 
         AutoSize        =   -1  'True
         Caption         =   "Mask"
         Height          =   195
         Left            =   1440
         TabIndex        =   24
         Top             =   6360
         Width           =   390
      End
      Begin VB.Label Label9 
         AutoSize        =   -1  'True
         Caption         =   "Sprite"
         Height          =   195
         Left            =   1440
         TabIndex        =   23
         Top             =   5640
         Width           =   405
      End
      Begin VB.Line Line2 
         X1              =   120
         X2              =   2640
         Y1              =   7080
         Y2              =   7080
      End
      Begin VB.Label Label8 
         AutoSize        =   -1  'True
         Caption         =   "Base Height"
         Height          =   195
         Left            =   1440
         TabIndex        =   11
         Top             =   4920
         Width           =   870
      End
      Begin VB.Label Label7 
         AutoSize        =   -1  'True
         Caption         =   "Height"
         Height          =   195
         Left            =   1440
         TabIndex        =   10
         Top             =   4200
         Width           =   465
      End
      Begin VB.Label Label6 
         AutoSize        =   -1  'True
         Caption         =   "Orientation"
         Height          =   195
         Left            =   1440
         TabIndex        =   9
         Top             =   3480
         Width           =   765
      End
      Begin VB.Label Label5 
         AutoSize        =   -1  'True
         Caption         =   "Texture"
         Height          =   195
         Left            =   120
         TabIndex        =   8
         Top             =   6360
         Width           =   540
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "Sky-Box"
         Height          =   195
         Left            =   120
         TabIndex        =   7
         Top             =   5640
         Width           =   585
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "Map Direction"
         Height          =   195
         Left            =   120
         TabIndex        =   6
         Top             =   4920
         Width           =   990
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "Flip"
         Height          =   195
         Left            =   120
         TabIndex        =   5
         Top             =   4200
         Width           =   240
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Model"
         Height          =   195
         Left            =   120
         TabIndex        =   4
         Top             =   3480
         Width           =   435
      End
      Begin VB.Line Line1 
         X1              =   120
         X2              =   2640
         Y1              =   3360
         Y2              =   3360
      End
   End
   Begin VB.PictureBox Picture2 
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   1
      Top             =   720
      Width           =   1215
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
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   0
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Image Image1 
      Height          =   960
      Left            =   120
      Picture         =   "Form1.frx":021E
      Top             =   1320
      Width           =   960
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuNew 
         Caption         =   "New"
      End
      Begin VB.Menu mnuBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuLoad 
         Caption         =   "Load"
      End
      Begin VB.Menu mnuSave 
         Caption         =   "Save"
      End
      Begin VB.Menu mnuBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "Edit"
      Begin VB.Menu mnuInsert 
         Caption         =   "Insert"
      End
      Begin VB.Menu mnuDelete 
         Caption         =   "Delete"
      End
      Begin VB.Menu mnuBar3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuCancel 
         Caption         =   "Cancel"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "View"
      Begin VB.Menu mnuRefresh 
         Caption         =   "Refresh"
         Shortcut        =   ^R
      End
      Begin VB.Menu mnuSnap 
         Caption         =   "Snap"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "About"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim mViewX As Single
Dim mViewY As Single
Dim mSafeX As Single
Dim mSafeY As Single
Private Sub PrintStatus(Text As String)

    Picture4.Cls
    Picture4.CurrentX = 60
    Picture4.CurrentY = 60
    Picture4.Print Text
    
End Sub
Private Sub RefreshEntity(Index As Long)

    If Index <> 0 Then
        Combo1.ListIndex = ComboFind(Combo1, mEntity(Index).mModel)
        Check1.Value = CLng(mEntity(Index).mFlip And 1)
        Combo2.ListIndex = mEntity(Index).mMapDir
        Check2.Value = CLng(mEntity(Index).mSkyBox And 1)
        Combo3.ListIndex = ComboFind(Combo3, mEntity(Index).mTexture)
        Select Case mEntity(Index).mAngle(2)
            Case 0
                Combo4.ListIndex = ComboFind(Combo4, "North")
            Case 315
                Combo4.ListIndex = ComboFind(Combo4, "NE")
            Case 270
                Combo4.ListIndex = ComboFind(Combo4, "East")
            Case 225
                Combo4.ListIndex = ComboFind(Combo4, "SE")
            Case 180
                Combo4.ListIndex = ComboFind(Combo4, "South")
            Case 135
                Combo4.ListIndex = ComboFind(Combo4, "SW")
            Case 90
                Combo4.ListIndex = ComboFind(Combo4, "West")
            Case 45
                Combo4.ListIndex = ComboFind(Combo4, "NW")
        End Select
        If mEntity(Index).mBox(1) >= 1 Then
            Text1.Text = CStr(mEntity(Index).mBox(1))
        Else
            Text1.Text = "1"
        End If
        Text2.Text = CStr(mEntity(Index).mBase)
        Combo5.ListIndex = ComboFind(Combo5, mEntity(Index).mSprite)
        Combo6.ListIndex = ComboFind(Combo6, mEntity(Index).mMask)
        Text3.Text = mEntity(Index).mName
        Text4.Text = mEntity(Index).mTag
        Check3.Value = CLng(mEntity(Index).mVisible And 1)
        Check4.Value = CLng(mEntity(Index).mSolid And 1)
    End If
    Combo7.ListIndex = ComboFind(Combo7, mSkyName)
    Combo8.ListIndex = mSkyMapDir
    
End Sub
Private Sub UpdateEntity(Index As Long)

    If Index <> 0 Then
        mEntity(Index).mModel = Combo1.Text
        mEntity(Index).mFlip = CBool(Check1.Value)
        mEntity(Index).mMapDir = Combo2.ListIndex
        mEntity(Index).mSkyBox = CBool(Check2.Value)
        mEntity(Index).mTexture = Combo3.Text
        Select Case Combo4.Text
            Case "North"
                mEntity(Index).mAngle(2) = 0
            Case "NE"
                mEntity(Index).mAngle(2) = 315
            Case "East"
                mEntity(Index).mAngle(2) = 270
            Case "SE"
                mEntity(Index).mAngle(2) = 225
            Case "South"
                mEntity(Index).mAngle(2) = 180
            Case "SW"
                mEntity(Index).mAngle(2) = 135
            Case "West"
                mEntity(Index).mAngle(2) = 90
            Case "NW"
                mEntity(Index).mAngle(2) = 45
        End Select
        mEntity(Index).mBox(1) = CSng(Text1.Text)
        mEntity(Index).mBase = CSng(Text2.Text)
        mEntity(Index).mSprite = Combo5.Text
        mEntity(Index).mMask = Combo6.Text
        mEntity(Index).mAlign = True
        If mEntity(Index).mSprite <> "none" Then
            mEntity(Index).mSize = CSng(Text1.Text) / 10
        Else
            mEntity(Index).mSize = CSng(Text1.Text)
        End If
        mEntity(Index).mName = Text3.Text
        mEntity(Index).mTag = Text4.Text
        mEntity(Index).mVisible = CBool(Check3.Value)
        mEntity(Index).mSolid = CBool(Check4.Value)
    End If
    mSkyName = Combo7.List(Combo7.ListIndex)
    mSkyMapDir = Combo8.ListIndex
    
End Sub
Private Sub Form_Load()

    Dim i As Long
    
    Form1.Caption = App.Title
    Form1.Width = Screen.Width * 0.5
    Form1.Height = Screen.Height * 0.75
    Call InitMap(Picture1, Picture2, Image1, Picture3)
    Picture1.MousePointer = vbCrosshair
    Picture3.MousePointer = vbCustom
    Picture4.AutoRedraw = True
    Image2.BorderStyle = vbFixedSingle
    Image2.Stretch = True
    Call mnuRefresh_Click
    Call Combo2.AddItem("DIR_BACK")
    Call Combo2.AddItem("DIR_FRONT")
    Call Combo2.AddItem("DIR_LEFT")
    Call Combo2.AddItem("DIR_RIGHT")
    Call Combo2.AddItem("DIR_TOP")
    Call Combo2.AddItem("DIR_BOTTOM")
    Call Combo2.AddItem("DIR_RADIAL")
    Combo2.ListIndex = 0
    For i = 0 To Combo2.ListCount - 1
        Combo8.AddItem (Combo2.List(i))
    Next i
    Combo8.ListIndex = 0
    Call Combo4.AddItem("North")
    Call Combo4.AddItem("NE")
    Call Combo4.AddItem("East")
    Call Combo4.AddItem("SE")
    Call Combo4.AddItem("South")
    Call Combo4.AddItem("SW")
    Call Combo4.AddItem("West")
    Call Combo4.AddItem("NW")
    Combo4.ListIndex = 0
    Call mnuNew_Click
    Text1.Text = "1"
    Text2.Text = "0"
    mnuEdit.Visible = False
    mnuSnap.Checked = True
    Option1(0).Value = True
    Command1.Enabled = False
    Check3.Value = 1
    Check4.Value = 1
    Check5.Value = 1
    Check6.Value = 1
    mViewX = 0.5
    mViewY = 0.5
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    Call mnuExit_Click
    
End Sub
Private Sub Form_Resize()

    On Error Resume Next
    Call Picture1.Move(0, 0, Form1.ScaleWidth - Frame1.Width, Form1.ScaleHeight - Picture4.Height)
    Call Picture4.Move(0, Picture1.Height)
    Call Frame1.Move(Picture1.Width, 0, Frame1.Width, Form1.ScaleHeight)
    mAspect = Picture1.ScaleHeight / Picture1.ScaleWidth
    Call SetViewPort(mViewX - mScale / 2, mViewY - (mScale * mAspect) / 2, mScale, mAspect)
    Call DrawMap(Picture1, Picture2, Image1, Picture3)
    
End Sub
Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = 46 Then
        If mPrevSel <> 0 Then
            Call mnuDelete_Click
            Call DrawMap(Picture1, Picture2, Image1, Picture3)
        End If
    End If
    
End Sub
Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim NewX As Single
    Dim NewY As Single
    
    Call MapCoords(Picture1, X, Y, NewX, NewY)
    Select Case Button
        Case 1
            mSelected = FindEntity(NewX, NewY)
            If mSelected <> mPrevSel Then
                If mPrevSel <> 0 Then _
                    Call UpdateEntity(mPrevSel)
                mPrevSel = mSelected
                If mPrevSel <> 0 Then
                    Call RefreshEntity(mPrevSel)
                    If Shift <> 0 Then
                        mEntity(mPrevSel).mOrigin(0) = NewX
                        mEntity(mPrevSel).mOrigin(2) = NewY
                    End If
                    Command1.Enabled = True
                Else
                    Command1.Enabled = False
                End If
            End If
        Case 2
            If mPrevSel <> 0 Then
                mnuInsert.Enabled = False
                mnuDelete.Enabled = True
            Else
                mnuInsert.Enabled = True
                mnuDelete.Enabled = False
            End If
            Call PopupMenu(mnuEdit, , X, Y, mnuCancel)
            If mnuInsert.Enabled Then
                If mPrevSel <> 0 Then
                    Call UpdateEntity(mPrevSel)
                    mEntity(mPrevSel).mOrigin(0) = NewX
                    mEntity(mPrevSel).mOrigin(1) = 1
                    mEntity(mPrevSel).mOrigin(2) = NewY
                    mEntity(mPrevSel).mBox(0) = 1
                    mEntity(mPrevSel).mBox(1) = 1
                    mEntity(mPrevSel).mBox(2) = 1
                    Command1.Enabled = True
                End If
            Else
                If mPrevSel = 0 Then _
                    Command1.Enabled = False
            End If
    End Select
    Call DrawMap(Picture1, Picture2, Image1, Picture3)
    mSafeX = NewX
    mSafeY = NewY
    
End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim NewX As Single
    Dim NewY As Single
    
    Call MapCoords(Picture1, X, Y, NewX, NewY)
    If mnuSnap.Checked Then
        NewX = CInt(NewX)
        NewY = CInt(NewY)
        mSafeX = CInt(mSafeX)
        mSafeY = CInt(mSafeY)
    End If
    Call PrintStatus("(" & Format(NewX, "0.00") & ", " & Format(NewY, "0.00") & ")")
    If Button <> 0 Then
        If mSelected <> 0 Then
            If Shift = 0 Then
                mEntity(mSelected).mOrigin(0) = NewX
                mEntity(mSelected).mOrigin(2) = NewY
                mSafeX = NewX
                mSafeY = NewY
            Else
                mEntity(mSelected).mBox(0) = Abs(NewX - mSafeX) * 2
                mEntity(mSelected).mBox(2) = Abs(NewY - mSafeY) * 2
                If mEntity(mSelected).mBox(0) < 1 Then mEntity(mSelected).mBox(0) = 1
                If mEntity(mSelected).mBox(2) < 1 Then mEntity(mSelected).mBox(2) = 1
            End If
        End If
    End If
    If Button <> 0 Then _
        Call DrawMap(Picture1, Picture2, Image1, Picture3)
        
End Sub
Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    mSelected = 0
    Call DrawMap(Picture1, Picture2, Image1, Picture3)
    
End Sub
Private Sub mnuNew_Click()

    CommonDialog1.Filename = ""
    Image1.Picture = LoadPicture("")
    Image1.Width = 64
    Image1.Height = 64
    Image2.Picture = LoadPicture("")
    mGroundName = ""
    mSkyName = ""
    mSkyMapDir = 6
    ReDim mEntity(1)
    mEntity(1).mVisible = True
    mEntity(1).mSolid = True
    Call RefreshEntity(1)
    ReDim mEntity(0)
    mPrevSel = 0
    Call DrawMap(Picture1, Picture2, Image1, Picture3)
    Form1.Caption = App.Title & " - " & GetFilename(CommonDialog1.Filename)
    
End Sub
Private Sub mnuLoad_Click()

    Dim TempA As String
    Dim TempB As String
    
    On Error Resume Next
    CommonDialog1.CancelError = True
    CommonDialog1.Filter = _
        "Package Files (*.pak)|*.pak|" & _
        "Bitmap Files (*.bmp)|*.bmp|" & _
        "All Files (*.*)|*.*"
    CommonDialog1.FilterIndex = 0
    TempA = CommonDialog1.Filename
    CommonDialog1.Action = 1
    If Err = 0 Then
        Select Case Right(CommonDialog1.Filename, 3)
            Case "bmp"
                Image1.Picture = LoadPicture(CommonDialog1.Filename)
                mGroundName = GetFilename(CommonDialog1.Filename)
                CommonDialog1.Filename = TempA
            Case Else
                TempB = CommonDialog1.Filename
                Call mnuNew_Click
                CommonDialog1.Filename = TempB
                Call LoadMapEx(CommonDialog1.Filename)
                Image1.Picture = LoadPicture(GetLocalPath(mGroundName))
                Image2.Picture = LoadPicture(GetLocalPath(mSkyName))
        End Select
        Call RefreshEntity(0)
        Call DrawMap(Picture1, Picture2, Image1, Picture3)
        Form1.Caption = App.Title & " - " & GetFilename(CommonDialog1.Filename)
    End If
    
End Sub
Private Sub mnuSave_Click()

    On Error Resume Next
    CommonDialog1.CancelError = True
    CommonDialog1.Filter = _
        "Package Files (*.pak)|*.pak|" & _
        "All Files (*.*)|*.*"
    CommonDialog1.FilterIndex = 0
    CommonDialog1.Action = 2
    If Err = 0 Then
        Call Command1_Click
        Call SaveMapEx(CommonDialog1.Filename, Check5.Value, Check6.Value)
        Form1.Caption = App.Title & " - " & GetFilename(CommonDialog1.Filename)
    End If
    
End Sub
Private Sub mnuRefresh_Click()

    Dim i As Long
    Dim CurPath As String
    
    Combo1.Clear
    Combo3.Clear
    Combo5.Clear
    Combo6.Clear
    Combo7.Clear
    Call Combo1.AddItem("box")
    Call Combo1.AddItem("ramp")
    Call Combo1.AddItem("sphere")
    Call Combo3.AddItem("none")
    Call Combo5.AddItem("none")
    Call Combo6.AddItem("none")
    Call Combo7.AddItem("none")
    CurPath = Dir(GetLocalPath(""))
    Do While CurPath <> ""
        Select Case LCase(Right(CurPath, 3))
            Case "3ds"
                Call Combo1.AddItem(CurPath)
            Case "bmp"
                Call Combo3.AddItem(CurPath)
                Call Combo5.AddItem(CurPath)
                Call Combo6.AddItem(CurPath)
                Call Combo7.AddItem(CurPath)
        End Select
        CurPath = Dir
    Loop
    Combo1.ListIndex = 0
    Combo3.ListIndex = 0
    Combo5.ListIndex = 0
    Combo6.ListIndex = 0
    Combo7.ListIndex = 0
    If mPrevSel <> 0 Then _
        Call RefreshEntity(mPrevSel)
        
End Sub
Private Sub mnuExit_Click()

    Call Command1_Click
    If CommonDialog1.Filename <> "" Then _
        Call SaveMapEx(CommonDialog1.Filename, Check5.Value, Check6.Value)
    End
    
End Sub
Private Sub mnuInsert_Click()

    mPrevSel = AddEntity
    
End Sub
Private Sub mnuDelete_Click()

    Call RemEntity(mPrevSel)
    mPrevSel = 0
    
End Sub
Private Sub mnuSnap_Click()

    mnuSnap.Checked = Not mnuSnap.Checked
    
End Sub
Private Sub mnuAbout_Click()

    Call ShowAbout
    
End Sub
Private Sub Picture3_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button <> 0 Then
        mViewX = X / Picture3.ScaleWidth
        mViewY = Y / Picture3.ScaleHeight
        Call SetViewPort(mViewX - mScale / 2, mViewY - (mScale * mAspect) / 2, mScale, mAspect)
        Call DrawMap(Picture1, Picture2, Image1, Picture3)
    End If
    
End Sub
Private Sub Option1_Click(Index As Integer)

    Select Case Index
        Case 0: mScale = 0.15
        Case 1: mScale = 0.3
        Case 2: mScale = 0.6
    End Select
    Call SetViewPort(mViewX - mScale / 2, mViewY - (mScale * mAspect) / 2, mScale, mAspect)
    Call DrawMap(Picture1, Picture2, Image1, Picture3)
    
End Sub
Private Sub Command1_Click()

    Call UpdateEntity(mPrevSel)
    Call DrawMap(Picture1, Picture2, Image1, Picture3)
    
End Sub
Private Sub Command2_Click()

    On Error Resume Next
    Call Command1_Click
    If CommonDialog1.Filename <> "" Then
        Call SaveMapEx(CommonDialog1.Filename, Check5.Value, Check6.Value)
        Call Shell(GetLocalPath("viewer.bat"))
        If Err <> 0 Then _
            Call MsgBox("ERROR: viewer not found!", vbExclamation + vbOKOnly, App.Title)
    Else
        Call MsgBox("File must be saved before this operation.", vbInformation + vbOKOnly, App.Title)
    End If
    
End Sub
Private Sub Combo7_Click()

    If Combo7.Text <> "none" Then _
        Image2.Picture = LoadPicture(GetLocalPath(Combo7.Text))
        
End Sub
