VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.1#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   1935
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   5175
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   1935
   ScaleWidth      =   5175
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   720
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   327680
   End
   Begin VB.Timer Timer1 
      Left            =   120
      Top             =   120
   End
   Begin VB.PictureBox Picture1 
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   8
      TabStop         =   0   'False
      Top             =   720
      Width           =   1215
   End
   Begin VB.Frame Frame1 
      Height          =   495
      Left            =   1440
      TabIndex        =   0
      Top             =   0
      Width           =   3615
      Begin VB.CommandButton Command4 
         Height          =   375
         Left            =   2520
         Picture         =   "Form1.frx":0442
         Style           =   1  'Graphical
         TabIndex        =   5
         Top             =   120
         Width           =   375
      End
      Begin VB.ComboBox Combo1 
         Height          =   315
         Left            =   1200
         Style           =   2  'Dropdown List
         TabIndex        =   4
         Top             =   120
         Width           =   1215
      End
      Begin VB.CommandButton Command3 
         Height          =   375
         Left            =   720
         Picture         =   "Form1.frx":0544
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   120
         Width           =   375
      End
      Begin VB.CommandButton Command2 
         Height          =   375
         Left            =   360
         Picture         =   "Form1.frx":0646
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   120
         Width           =   375
      End
      Begin VB.CommandButton Command1 
         Height          =   375
         Left            =   0
         Picture         =   "Form1.frx":0748
         Style           =   1  'Graphical
         TabIndex        =   1
         Top             =   120
         Width           =   375
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Label1"
         Height          =   195
         Left            =   3000
         TabIndex        =   6
         Top             =   120
         Width           =   480
      End
   End
   Begin VB.Shape Shape1 
      Height          =   495
      Left            =   120
      Top             =   1320
      Width           =   1215
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Label2"
      Height          =   195
      Left            =   1440
      TabIndex        =   7
      Top             =   600
      Width           =   480
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuNew 
         Caption         =   "New"
      End
      Begin VB.Menu mnuRandom 
         Caption         =   "Random"
      End
      Begin VB.Menu mnuBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuOpen 
         Caption         =   "Open"
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
      Begin VB.Menu mnuAttributes 
         Caption         =   "Attributes"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "View"
      Begin VB.Menu mnuBoundingBox 
         Caption         =   "Bounding Box"
      End
      Begin VB.Menu mnuVectorAxis 
         Caption         =   "Vector Axis"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "Tools"
      Begin VB.Menu mnuAutoFix 
         Caption         =   "Auto-fix"
      End
      Begin VB.Menu mnuBar3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuRotate 
         Caption         =   "Rotate"
      End
      Begin VB.Menu mnuMove 
         Caption         =   "Move"
      End
      Begin VB.Menu mnuScale 
         Caption         =   "Scale"
      End
   End
   Begin VB.Menu mnuScript 
      Caption         =   "Script"
      Begin VB.Menu mnuLoad 
         Caption         =   "Load"
      End
      Begin VB.Menu mnuUnload 
         Caption         =   "Unload"
      End
      Begin VB.Menu mnBar4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuReverse 
         Caption         =   "Reverse"
      End
      Begin VB.Menu mnuStop 
         Caption         =   "Stop"
      End
      Begin VB.Menu mnuForward 
         Caption         =   "Forward"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuControls 
         Caption         =   "Controls"
      End
      Begin VB.Menu mnuBar5 
         Caption         =   "-"
      End
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

Private Sub Combo1_Click()

    CurColor.R = GetPalColor(Combo1.Text).R
    CurColor.G = GetPalColor(Combo1.Text).G
    CurColor.B = GetPalColor(Combo1.Text).B
    If SelElem = "Point" Then
        FPoint(SelIndex).Color.R = CurColor.R
        FPoint(SelIndex).Color.G = CurColor.G
        FPoint(SelIndex).Color.B = CurColor.B
    End If
    If SelElem = "Line" Then
        FLine(SelIndex).Color.R = CurColor.R
        FLine(SelIndex).Color.G = CurColor.G
        FLine(SelIndex).Color.B = CurColor.B
    End If
    Update = True
    
End Sub


Private Sub Command1_Click()

    Call mnuNew_Click

End Sub

Private Sub Command2_Click()
    
    Call mnuOpen_Click

End Sub


Private Sub Command3_Click()
    
    Call mnuSave_Click

End Sub

Private Sub Command4_Click()

    Call mnuAbout_Click
    
End Sub

Private Sub Form_Load()
    
    Dim A%
    
    Call FillPal
    For A = 0 To 7
        Combo1.AddItem Pal(A).Name
    Next A
    Combo1.ListIndex = Combo1.ListCount - 1
    Label1.FontSize = 12
    Label2.FontBold = True
    Picture1.ScaleMode = 3
    Picture1.Width = 200 * Screen.TwipsPerPixelX
    Picture1.Height = 200 * Screen.TwipsPerPixelY
    Picture1.AutoRedraw = True
    Picture1.BorderStyle = 0
    Picture1.BackColor = RGB(0, 0, 0)
    Shape1.BorderWidth = 2
    Shape1.BorderColor = vbRed
    Form1.Width = Picture1.Width * 2
    Timer1.Interval = 10
    Call SetDefCfg
    
    If Command <> "" Then
        If GetPath(Command, "Extension") = "rce" Then Call OpenWorld(Command, False)
        If GetPath(Command, "Extension") = "hdr" Then Call LoadHeader(Command)
        Update = True
    End If
    
End Sub
Private Sub Form_Resize()
    
    If Form1.WindowState = 0 Then
        Form1.Height = _
            Frame1.Height + Label2.Height + _
            Form1.ScaleWidth * (Picture1.Height / Picture1.Width) + _
            (Form1.Height - Form1.ScaleHeight)
        Frame1.Move _
            0, _
            0, _
            Form1.ScaleWidth, _
            Frame1.Height
        Label2.Move _
            0, _
            Frame1.Top + Frame1.Height, _
            Form1.ScaleWidth, _
            Label2.Height
        Picture1.Move _
            0 + 120, _
            Label2.Top + Label2.Height + 120, _
            Form1.ScaleWidth - 120 * 2, _
            Form1.ScaleHeight - (Frame1.Height + Label2.Height + 120 * 2)
        Shape1.Move _
            0 + 60, _
            Label2.Top + Label2.Height + 60, _
            Form1.ScaleWidth - 60 * 2, _
            Form1.ScaleHeight - (Frame1.Height + Label2.Height + 60 * 2)
        Update = True
    End If

End Sub

Private Sub mnuAbout_Click()

    MsgBox _
        App.Title & " Version " & App.Major & "." & App.Minor & "." & App.Revision & vbCrLf & _
        "Programmed by Ray C. (Dextre)" & vbCrLf & _
        vbCrLf & _
        "Code Language" & vbTab & vbTab & "Visual Basic" & vbCrLf & _
        "Additional Controls" & vbTab & vbTab & "Microsoft Common Dialog Control 5.0" _
        , 64, "About"

End Sub

Private Sub mnuAttributes_Click()
   
    Dim BufferB%
    Dim BufferC%
    Dim BufferA$
    
    BufferA = FMesh(CurMesh).Tag
    BufferB = FMesh(CurMesh).PointRng.Fin - FMesh(CurMesh).PointRng.Bgn + 1
    BufferC = FMesh(CurMesh).LineRng.Fin - FMesh(CurMesh).LineRng.Bgn + 1
    BufferA = InputBox("Enter name for mesh:", "Attributes", BufferA)
    BufferB = Val(InputBox("Enter number of points:", "Attributes", BufferB))
    BufferC = Val(InputBox("Enter number of lines:", "Attributes", BufferC))
    If BufferB <> 0 And BufferC <> 0 And BufferA <> "" Then
        FMesh(CurMesh).PointRng.Fin = FMesh(CurMesh).PointRng.Bgn + BufferB - 1
        FMesh(CurMesh).LineRng.Fin = FMesh(CurMesh).LineRng.Bgn + BufferC - 1
        FMesh(CurMesh).Tag = BufferA
        Call DefragMeshes
    End If
    Update = True
    
End Sub

Private Sub mnuAutoFix_Click()

    AutoFix = Not AutoFix
    Update = True

End Sub

Private Sub mnuBoundingBox_Click()

    FMesh(FMesh(CurMesh).BoundBox).Vis = Not FMesh(FMesh(CurMesh).BoundBox).Vis
    Update = True

End Sub

Private Sub mnuControls_Click()

    Dim BufferA$
    Dim BufferB$

    BufferA = _
        "Esc" + vbTab + "Exit" + vbCrLf + _
        "`" + vbTab + "New" + vbCrLf + _
        "T" + vbTab + "Top" + vbCrLf + _
        "K" + vbTab + "Back" + vbCrLf + _
        "R" + vbTab + "Right" + vbCrLf + _
        "B" + vbTab + "Bottom" + vbCrLf + _
        "F" + vbTab + "Front" + vbCrLf + _
        "L" + vbTab + "Left" + vbCrLf + _
        "Q" + vbTab + "Linear Camera" + vbCrLf + _
        "A" + vbTab + "Perceptive Camera (Flat)" + vbCrLf + _
        "Z" + vbTab + "Perceptive Camera (Ang)" + vbCrLf + _
        "Bckspc" + vbTab + "Random" + vbCrLf + _
        "Enter" + vbTab + "Atmosphere toggle" + vbCrLf + _
        "Shift" + vbTab + "Draw mode toggle" + vbCrLf + _
        "Ctrl" + vbTab + "Reset object vector" + vbCrLf + _
        "Space" + vbTab + "Reset camera vector" + vbCrLf
    BufferB = _
        "[" + vbTab + "Orbit camera clockwise" + vbCrLf + _
        "'" + vbTab + "Stop Orbit" + vbCrLf + _
        "]" + vbTab + "Orbit camera counter-clockwise" + vbCrLf + _
        ";" + vbTab + "Red filter toggle" + vbCrLf + _
        "." + vbTab + "Green filter toggle" + vbCrLf + _
        "/" + vbTab + "Blue filter toggle" + vbCrLf + _
        "Pg Up" + vbTab + "View previous mesh" + vbCrLf + _
        "Pg Dn" + vbTab + "View next mesh" + vbCrLf + _
        "Up Arw" + vbTab + "Widen FOV" + vbCrLf + _
        "Dn Arw" + vbTab + "Narrow FOV" + vbCrLf + _
        "+" + vbTab + "Zoom-in" + vbCrLf + _
        "-" + vbTab + "Zoom-out" + vbCrLf + _
        "Lt Pad" + vbTab + "Scan Left" + vbCrLf + _
        "Rt Pad" + vbTab + "Scan Right" + vbCrLf + _
        "Up Pad" + vbTab + "Scan Up" + vbCrLf + _
        "Dn Pad" + vbTab + "Scan Down" + vbCrLf + _
        "Ins" + vbTab + "Insert element" + vbCrLf + _
        "Del" + vbTab + "Delete element" + vbCrLf + _
        "Lt Mouse" + vbTab + "Select element / Modify Object / Orbit camera" + vbCrLf + _
        "Rt Mouse" + vbTab + "Unselect element / Dolly camera"
    Call MsgBox(BufferA + BufferB, 64, "Controls")

End Sub


Private Sub mnuExit_Click()

    End

End Sub

Private Sub mnuForward_Click()

    PlayDir = 1

End Sub

Private Sub mnuLoad_Click()

    On Error Resume Next
    CommonDialog1.Filter = "Script Files (*.hdr)|*.hdr|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    CommonDialog1.CancelError = True
    CommonDialog1.Action = 1
    If Err = 0 Then Call LoadHeader(CommonDialog1.FileName)
    
End Sub

Private Sub mnuMove_Click()

    Dim A%
    Dim BufferA$
    Dim BufferB!
    
    BufferA = InputBox("Enter axis for operation", "Move")
    BufferB = Val(InputBox("Enter value for operation", "Move"))
    If BufferA <> "" Then
        If BufferA = "X" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    FPoint(A).Pos.X = FPoint(A).Pos.X + BufferB
                End If
            Next A
        ElseIf BufferA = "Y" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    FPoint(A).Pos.Y = FPoint(A).Pos.Y + BufferB
                End If
            Next A
        ElseIf BufferA = "Z" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    FPoint(A).Pos.Z = FPoint(A).Pos.Z + BufferB
                End If
            Next A
        Else
            Call MsgBox("Invalid value(s)! Operation aborted!", 16, "Error")
        End If
    End If
    Update = True
    
End Sub

Private Sub mnuNew_Click()

    Call UnloadHeader
    Call SetBlkMesh(CurMesh)
    Update = True
    
End Sub
Private Sub mnuOpen_Click()

    On Error Resume Next
    Call UnloadHeader
    CommonDialog1.Filter = "Model Files (*.rce)|*.rce|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    CommonDialog1.CancelError = True
    CommonDialog1.Action = 1
    If Err = 0 Then
        Call OpenWorld(CommonDialog1.FileName, False)
        Update = True
    End If
    
End Sub
Private Sub mnuRandom_Click()

    Call UnloadHeader
    Call SetRndMesh(CurMesh, 100)
    Update = True
    
End Sub

Private Sub mnuReverse_Click()

    PlayDir = -1

End Sub

Private Sub mnuRotate_Click()

    Dim A%
    Dim BufferA$
    Dim BufferB!
    Dim BufferC!
    Dim BufferD!
    
    BufferA = InputBox("Enter axis for operation", "Rotate")
    BufferB = Val(InputBox("Enter value for operation", "Rotate"))
    If BufferA <> "" Then
        If BufferA = "X" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    BufferC = _
                        GetAng( _
                            FPoint(A).Pos.Y, _
                            FPoint(A).Pos.Z, _
                            0, _
                            0 _
                        )
                    BufferD = _
                        GetDist( _
                            FPoint(A).Pos.Y - 0, _
                            FPoint(A).Pos.Z - 0, _
                            0 _
                        )
                    FPoint(A).Pos.Y = GetCoord("Opp", 0, 0, BufferC + BufferB, BufferD)
                    FPoint(A).Pos.Z = GetCoord("Adj", 0, 0, BufferC + BufferB, BufferD)
                End If
            Next A
        ElseIf BufferA = "Y" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    BufferC = _
                        GetAng( _
                            FPoint(A).Pos.Z, _
                            FPoint(A).Pos.X, _
                            0, _
                            0 _
                        )
                    BufferD = _
                        GetDist( _
                            FPoint(A).Pos.Z - 0, _
                            FPoint(A).Pos.X - 0, _
                            0 _
                        )
                    FPoint(A).Pos.Z = GetCoord("Opp", 0, 0, BufferC + BufferB, BufferD)
                    FPoint(A).Pos.X = GetCoord("Adj", 0, 0, BufferC + BufferB, BufferD)
                End If
            Next A
        ElseIf BufferA = "Z" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    BufferC = _
                        GetAng( _
                            FPoint(A).Pos.X, _
                            FPoint(A).Pos.Y, _
                            0, _
                            0 _
                        )
                    BufferD = _
                        GetDist( _
                            FPoint(A).Pos.X - 0, _
                            FPoint(A).Pos.Y - 0, _
                            0 _
                        )
                    FPoint(A).Pos.X = GetCoord("Opp", 0, 0, BufferC + BufferB, BufferD)
                    FPoint(A).Pos.Y = GetCoord("Adj", 0, 0, BufferC + BufferB, BufferD)
                End If
            Next A
        Else
            Call MsgBox("Invalid value(s)! Operation aborted!", 16, "Error")
        End If
    End If
    Update = True
    
End Sub

Private Sub mnuSave_Click()

    On Error Resume Next
    Call UnloadHeader
    CommonDialog1.Filter = "Model Files (*.rce)|*.rce|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    CommonDialog1.CancelError = True
    CommonDialog1.Action = 2
    If Err = 0 Then
        Call SaveWorld(CommonDialog1.FileName)
        Update = True
    End If
    
End Sub

Private Sub mnuScale_Click()

    Dim A%
    Dim BufferA$
    Dim BufferB!
    
    BufferA = InputBox("Enter axis for operation", "Scale")
    BufferB = Val(InputBox("Enter value for operation", "Scale"))
    If BufferA <> "" Then
        If BufferA = "X" Or BufferA = "A" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    FPoint(A).Pos.X = FPoint(A).Pos.X * BufferB
                End If
            Next A
        ElseIf BufferA = "Y" Or BufferA = "A" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    FPoint(A).Pos.Y = FPoint(A).Pos.Y * BufferB
                End If
            Next A
        ElseIf BufferA = "Z" Or BufferA = "A" Then
            For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                If FPoint(A).Exist = True Then
                    FPoint(A).Pos.Z = FPoint(A).Pos.Z * BufferB
                End If
            Next A
        Else
            Call MsgBox("Invalid value(s)! Operation aborted!", 16, "Error")
        End If
    End If
    Update = True
    
End Sub

Private Sub mnuStop_Click()

    PlayDir = 0

End Sub

Private Sub mnuUnload_Click()

    Call UnloadHeader

End Sub

Private Sub mnuVectorAxis_Click()

    FMesh(FMesh(CurMesh).VectAxis).Vis = Not FMesh(FMesh(CurMesh).VectAxis).Vis
    Update = True

End Sub

Private Sub Picture1_GotFocus()

    Shape1.BorderColor = vbGreen

End Sub

Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)
    
    Call KeyCommand(KeyCode, CurMesh, CurCamera)
    If Chr(KeyCode) = "O" Then Call mnuOpen_Click
    If Chr(KeyCode) = "S" Then Call mnuSave_Click
    If KeyCode = 45 Then AddElem = True
    If KeyCode = 46 Then RemElem = True
    Update = True

End Sub


Private Sub Picture1_KeyUp(KeyCode As Integer, Shift As Integer)

    Dim TempLine%

    If KeyCode = 45 Then
        AddElem = False
        TempLine = GetNextElem("Line", CurMesh)
        FLine(TempLine).Struct.A = 0
        Call Picture1_MouseUp(1, 0, 0, 0)
    End If
    If KeyCode = 46 Then
        RemElem = False
    End If
    
End Sub

Private Sub Picture1_LostFocus()

    Shape1.BorderColor = vbRed

End Sub

Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    Dim A%
    Dim B%
    Dim DetSelElem$
    Dim DetSelIndex%
    Dim TempPoint%
    Dim TempLine%
    
    MDBtn = Button
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True And FMesh(A).Edit = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist = True Then
                    If _
                        GetDist( _
                            X - SPoint(B).X, _
                            Y - SPoint(B).Y, _
                            0 _
                        ) < _
                        Unit / 2 _
                            Then
                                DetSelElem = "Point"
                                DetSelIndex = B
                    End If
                End If
            Next B
        End If
    Next A
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True And FMesh(A).Edit = True Then
            For B = FMesh(A).LineRng.Bgn To FMesh(A).LineRng.Fin
                If FLine(B).Exist = True Then
                    If _
                        GetDist( _
                            X - (SPoint(FLine(B).Struct.A).X + SPoint(FLine(B).Struct.B).X) / 2, _
                            Y - (SPoint(FLine(B).Struct.A).Y + SPoint(FLine(B).Struct.B).Y) / 2, _
                            0 _
                        ) < _
                        Unit / 2 _
                            Then
                                DetSelElem = "Line"
                                DetSelIndex = B
                    End If
                End If
            Next B
        End If
    Next A
    If MDBtn = 1 Then
        If DetSelElem <> "" Then
            SelElem = DetSelElem
            SelIndex = DetSelIndex
        End If
    End If
    If MDBtn = 2 Then
        SelElem = ""
        SelIndex = 0
    End If
    If MDBtn = 1 Then
        If AddElem = True Then
            TempLine = GetNextElem("Line", CurMesh)
            If TempLine <> 0 Then 'found available line
                If FLine(TempLine).Struct.A = 0 Then
                    If DetSelElem = "Point" Then 'clicked on existing point
                        TempPoint = DetSelIndex
                    Else 'clicked on nothing
                        TempPoint = GetNextElem("Point", CurMesh)
                        If TempPoint <> 0 Then 'found available point
                            Call SetPointPos(TempPoint, Picture1, View, X, Y, Unit)
                            Call InsElem("Point", TempPoint, "", CurColor)
                        Else 'no points available
                            Exit Sub
                        End If
                    End If
                    SelElem = "Point"
                    SelIndex = TempPoint
                    FLine(TempLine).Struct.A = TempPoint
                ElseIf FLine(TempLine).Struct.B = 0 Then
                    If DetSelElem = "Point" Then 'clicked on existing point
                        TempPoint = DetSelIndex
                    Else 'clicked on nothing
                        TempPoint = GetNextElem("Point", CurMesh)
                        If TempPoint <> 0 Then 'found available point
                            Call SetPointPos(TempPoint, Picture1, View, X, Y, Unit)
                            Call InsElem("Point", TempPoint, "", CurColor)
                        Else 'no points available
                            Exit Sub
                        End If
                    End If
                    SelElem = "Point"
                    SelIndex = TempPoint
                    FLine(TempLine).Struct.B = TempPoint
                    Call InsElem("Line", TempLine, "", CurColor)
                End If
            Else 'no lines available
                Exit Sub
            End If
        ElseIf RemElem = True Then
            If DetSelElem <> "" Then
                If DetSelElem = "Point" Then
                    For A = FMesh(CurMesh).LineRng.Bgn To FMesh(CurMesh).LineRng.Fin
                        If FLine(A).Struct.A = DetSelIndex Or FLine(A).Struct.B = DetSelIndex Then
                            Call DelElem("Line", A)
                        End If
                    Next A
                    Call DelElem("Point", DetSelIndex)
                End If
                If DetSelElem = "Line" Then
                    Call DelElem("Line", DetSelIndex)
                End If
            End If
            If _
                ( _
                    DetSelElem = "Point" And _
                    FPoint(DetSelIndex).Exist = False _
                ) Or _
                ( _
                    DetSelElem = "Line" And _
                    FLine(DetSelIndex).Exist = False _
                ) _
                    Then
                        SelElem = ""
                        SelIndex = 0
            End If
        End If
    End If
    If SelElem = "Point" Then
        Combo1.Text = _
            GetPalName( _
                FPoint(SelIndex).Color.R, _
                FPoint(SelIndex).Color.G, _
                FPoint(SelIndex).Color.B _
            )
    End If
    If SelElem = "Line" Then
        Combo1.Text = _
            GetPalName( _
                FLine(SelIndex).Color.R, _
                FLine(SelIndex).Color.G, _
                FLine(SelIndex).Color.B _
            )
    End If
    Update = True

End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    Dim NewX!
    Dim NewY!
    
    If MDBtn = 1 Then
        If Left(View, 1) = "P" Then
            Longitude = Int(Longitude - (X - MDPos.X) * OrbitSns)
            Latitude = Int(Latitude + (Y - MDPos.Y) * OrbitSns)
        Else
            If SelElem = "" Then
                OffsetX = OffsetX + (X - MDPos.X)
                OffsetY = OffsetY - (Y - MDPos.Y)
            Else
                NewX = _
                    ResetMDPos("Opp", Picture1, X, Y, Zoom, OffsetX, OffsetY, Unit) - _
                    ResetMDPos("Opp", Picture1, MDPos.X, MDPos.Y, Zoom, OffsetX, OffsetY, Unit)
                NewY = _
                    ResetMDPos("Adj", Picture1, X, Y, Zoom, OffsetX, OffsetY, Unit) - _
                    ResetMDPos("Adj", Picture1, MDPos.X, MDPos.Y, Zoom, OffsetX, OffsetY, Unit)
                If View = "Top" Then Call TransElem(SelElem, SelIndex, NewX, NewY, 0)
                If View = "Back" Then Call TransElem(SelElem, SelIndex, NewX, 0, NewY)
                If View = "Right" Then Call TransElem(SelElem, SelIndex, 0, NewX, NewY)
                If View = "Bottom" Then Call TransElem(SelElem, SelIndex, -NewX, NewY, 0)
                If View = "Front" Then Call TransElem(SelElem, SelIndex, -NewX, 0, NewY)
                If View = "Left" Then Call TransElem(SelElem, SelIndex, 0, -NewX, NewY)
            End If
        End If
    End If
    If MDBtn = 2 Then
        If Left(View, 1) = "P" Then
            Radius = Int(Radius + (Y - MDPos.Y) * DollySns)
            If Radius < 0 Then Radius = 0
        Else
            If SelElem = "" Then
                Zoom = Zoom - (Y - MDPos.Y) * ZoomSns
                If Zoom < 0.01 Then Zoom = 0.01
            End If
        End If
    End If
    If MDBtn <> 0 Then Update = True
    MDPos.X = X
    MDPos.Y = Y
    
End Sub
Private Sub Picture1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim A%
    Dim B%
    Dim C%
    Dim Tracer As Point3D
    Dim TracerRad!
    Dim TempLine%
    
    MDBtn = 0
    If AutoFix = True Then
FoundError:
        For A = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin 'check for duplicate point
            If FPoint(A).Exist = True Then
                For B = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                    If FPoint(B).Exist = True Then
                        If B <> A Then
                            If _
                                GetDist( _
                                    FPoint(B).Pos.X - FPoint(A).Pos.X, _
                                    FPoint(B).Pos.Y - FPoint(A).Pos.Y, _
                                    FPoint(B).Pos.Z - FPoint(A).Pos.Z _
                                ) < _
                                Unit / 2 _
                                    Then
                                        For C = FMesh(CurMesh).LineRng.Bgn To FMesh(CurMesh).LineRng.Fin
                                            If FLine(C).Exist = True Then
                                                If FLine(C).Struct.A = B Then FLine(C).Struct.A = A
                                                If FLine(C).Struct.B = B Then FLine(C).Struct.B = A
                                            End If
                                        Next C
                                        If SelElem = "Point" And SelIndex = B Then SelIndex = A
                                        Call DelElem("Point", B)
                                        GoTo FoundError
                            End If
                        End If
                    End If
                Next B
            End If
        Next A
        For A = FMesh(CurMesh).LineRng.Bgn To FMesh(CurMesh).LineRng.Fin 'check for duplicate line
            If FLine(A).Exist = True Then
                For B = FMesh(CurMesh).LineRng.Bgn To FMesh(CurMesh).LineRng.Fin
                    If FLine(B).Exist = True Then
                        If _
                            B <> A And _
                            ( _
                                (FLine(B).Struct.A = FLine(A).Struct.A And FLine(B).Struct.B = FLine(A).Struct.B) Or _
                                (FLine(B).Struct.A = FLine(A).Struct.B And FLine(B).Struct.B = FLine(A).Struct.A) _
                            ) _
                                Then
                                    If SelElem = "Line" And SelIndex = B Then SelIndex = A
                                    Call DelElem("Line", B)
                                    GoTo FoundError
                        End If
                    End If
                Next B
            End If
        Next A
        For A = FMesh(CurMesh).LineRng.Bgn To FMesh(CurMesh).LineRng.Fin 'check for single end line
            If FLine(A).Exist = True Then
                If FLine(A).Struct.A = FLine(A).Struct.B Then
                    If SelElem = "Line" And SelIndex = A Then
                        SelElem = "Point"
                        SelIndex = FLine(A).Struct.A
                    End If
                    Call DelElem("Line", A)
                    GoTo FoundError
                End If
            End If
        Next A
        For A = FMesh(CurMesh).LineRng.Bgn To FMesh(CurMesh).LineRng.Fin 'check for point line intersect
            If FLine(A).Exist = True Then
                For B = FMesh(CurMesh).PointRng.Bgn To FMesh(CurMesh).PointRng.Fin
                    If FPoint(B).Exist = True Then
                        If B <> FLine(A).Struct.A And B <> FLine(A).Struct.B Then
                            For C = 1 To Unit
                                Tracer.X = FPoint(FLine(A).Struct.A).Pos.X + C / Unit * (FPoint(FLine(A).Struct.B).Pos.X - FPoint(FLine(A).Struct.A).Pos.X)
                                Tracer.Y = FPoint(FLine(A).Struct.A).Pos.Y + C / Unit * (FPoint(FLine(A).Struct.B).Pos.Y - FPoint(FLine(A).Struct.A).Pos.Y)
                                Tracer.Z = FPoint(FLine(A).Struct.A).Pos.Z + C / Unit * (FPoint(FLine(A).Struct.B).Pos.Z - FPoint(FLine(A).Struct.A).Pos.Z)
                                TracerRad = GetDist(Tracer.X - FPoint(B).Pos.X, Tracer.Y - FPoint(B).Pos.Y, Tracer.Z - FPoint(B).Pos.Z)
                                If TracerRad < Unit / 2 Then
                                    TempLine = GetNextElem("Line", CurMesh)
                                    If TempLine <> 0 Then
                                        If FLine(TempLine).Struct.A = 0 Then
                                            If TempLine <> A Then
                                                FLine(TempLine).Struct.A = B
                                                FLine(TempLine).Struct.B = FLine(A).Struct.B
                                                Call InsElem("Line", TempLine, "", FLine(A).Color)
                                                FLine(A).Struct.B = B
                                                GoTo FoundError
                                            End If
                                        End If
                                    End If
                                End If
                            Next C
                        End If
                    End If
                Next B
            End If
        Next A
    End If
    Update = True
    
End Sub
Private Sub Timer1_Timer()
    
    If AddElem = True Then
        Form1.MousePointer = 2
    ElseIf RemElem = True Then
        Form1.MousePointer = 12
    ElseIf MDBtn = 1 Then
        Form1.MousePointer = 15
    ElseIf MDBtn = 2 Then
        Form1.MousePointer = 7
    Else
        Form1.MousePointer = 1
    End If
    If OrbitDir <> 0 Then
        Longitude = Int(Longitude - OrbitDir * OrbitIncre)
        Update = True
    End If
    If PlayDir <> 0 Then
        Call RunScript(PlayDir)
        Update = True
    End If
    If Longitude > 180 Then Longitude = Longitude - 360
    If Longitude < -180 Then Longitude = Longitude + 360
    If Latitude > 90 Then Latitude = 90
    If Latitude < -90 Then Latitude = -90
    If Update = True Then
        Update = False
        Form1.Caption = App.Title + " - " + FMesh(CurMesh).Tag
        Label1.Caption = _
            "Pts: " + _
                Format$(EnumElem("Point", CurMesh)) + _
                "/" + _
                Format$(FMesh(CurMesh).PointRng.Fin - (FMesh(CurMesh).PointRng.Bgn - 1)) + _
            "; " + _
            "Lns: " + _
                Format$(EnumElem("Line", CurMesh)) + _
                "/" + _
                Format$(FMesh(CurMesh).LineRng.Fin - (FMesh(CurMesh).LineRng.Bgn - 1))
        Label2.Caption = ViewInfo
        mnuBoundingBox.Checked = FMesh(FMesh(CurMesh).BoundBox).Vis
        mnuVectorAxis.Checked = FMesh(FMesh(CurMesh).VectAxis).Vis
        mnuAutoFix.Checked = AutoFix
        If PlayDir = -1 Then
            mnuReverse.Checked = True
            mnuStop.Checked = False
            mnuForward.Checked = False
        End If
        If PlayDir = 0 Then
            mnuReverse.Checked = False
            mnuStop.Checked = True
            mnuForward.Checked = False
        End If
        If PlayDir = 1 Then
            mnuReverse.Checked = False
            mnuStop.Checked = False
            mnuForward.Checked = True
        End If
        If FCamera(CurCamera).Exist = True Then
            Call ObserveMesh(CurCamera, CurMesh, Radius, Longitude, Latitude)
            If Left(View, 1) = "P" Then
                Call ProjView3D(CurCamera, Picture1)
            Else
                Call ProjView2D(CurCamera, Picture1, View, Zoom, OffsetX, OffsetY)
            End If
            Picture1.Cls
            If Left(View, 1) <> "P" Then Call DrawGrid(Picture1, View, Zoom, OffsetX, OffsetY, Unit)
            Call DrawView(CurCamera, Picture1)
        End If
    End If
    
End Sub
