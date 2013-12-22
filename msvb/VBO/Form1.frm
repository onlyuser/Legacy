VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   2910
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   2910
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   120
      Top             =   1800
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   120
      Top             =   1320
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.PictureBox Picture1 
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   0
      Top             =   720
      Width           =   1215
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   720
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Timer Timer1 
      Left            =   120
      Top             =   120
   End
   Begin VB.Menu mnuBoard 
      Caption         =   "&Board"
      Begin VB.Menu mnuNew 
         Caption         =   "&New"
      End
      Begin VB.Menu mnuBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuLoad 
         Caption         =   "&Load"
      End
      Begin VB.Menu mnuSave 
         Caption         =   "&Save"
      End
      Begin VB.Menu mnuBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSetup 
         Caption         =   "S&etup"
      End
      Begin VB.Menu mnuInfo 
         Caption         =   "&Info"
      End
      Begin VB.Menu mnuConnect 
         Caption         =   "&Connect"
      End
      Begin VB.Menu mnuBar3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuClose 
         Caption         =   "C&lose"
      End
   End
   Begin VB.Menu mnuMove 
      Caption         =   "&Move"
      Begin VB.Menu mnuFirst 
         Caption         =   "&First"
      End
      Begin VB.Menu mnuBar4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuUndo 
         Caption         =   "&Undo"
      End
      Begin VB.Menu mnuRedo 
         Caption         =   "&Redo"
      End
      Begin VB.Menu mnuBar5 
         Caption         =   "-"
      End
      Begin VB.Menu mnuLast 
         Caption         =   "&Last"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuAlwaysOnTop 
         Caption         =   "&Always On Top"
      End
      Begin VB.Menu mnuBoardAnalysis 
         Caption         =   "&Board Analysis"
      End
      Begin VB.Menu mnuBoardShading 
         Caption         =   "B&oard Shading"
      End
      Begin VB.Menu mnuChipFading 
         Caption         =   "&Chip Fading"
      End
      Begin VB.Menu mnuChipShading 
         Caption         =   "C&hip Shading"
      End
      Begin VB.Menu mnuGridMarks 
         Caption         =   "&Grid Marks"
      End
      Begin VB.Menu mnuLastMove 
         Caption         =   "&Last Move"
      End
      Begin VB.Menu mnuMapValues 
         Caption         =   "&Map Values"
      End
      Begin VB.Menu mnuSearchReport 
         Caption         =   "&Search Report"
      End
      Begin VB.Menu mnuSearchSteps 
         Caption         =   "S&earch Steps"
      End
   End
   Begin VB.Menu mnuMap 
      Caption         =   "M&ap"
      Begin VB.Menu mnuDefault 
         Caption         =   "&Default"
      End
      Begin VB.Menu mnuBar6 
         Caption         =   "-"
      End
      Begin VB.Menu mnuCopy 
         Caption         =   "&Copy"
      End
      Begin VB.Menu mnuPaste 
         Caption         =   "&Paste"
      End
   End
   Begin VB.Menu mnuSearch 
      Caption         =   "&Search"
      Begin VB.Menu mnuDepth 
         Caption         =   "&Depth"
      End
      Begin VB.Menu mnuMode 
         Caption         =   "&Mode"
      End
   End
   Begin VB.Menu mnuInternet 
      Caption         =   "&Internet"
      Begin VB.Menu mnuPlayers 
         Caption         =   "&Players"
      End
      Begin VB.Menu mnuScores 
         Caption         =   "&Scores"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
      End
      Begin VB.Menu mnuBar7 
         Caption         =   "-"
      End
      Begin VB.Menu mnuNews 
         Caption         =   "&News"
      End
      Begin VB.Menu mnuDownloads 
         Caption         =   "&Downloads"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Form_Load()

    Dim BufferA$
    Dim BufferB$
    Dim BufferC$
    
    On Error Resume Next
    
    Timer1.Enabled = True
    Timer1.Interval = 100
    
    Picture1.AutoRedraw = True
    Picture1.FillStyle = 0
    
    If Dir(LocPath, vbDirectory) = "" Then Call MkDir(LocPath)
    Winsock1.Protocol = 1
    If Dir(LocPath & CfgFile) <> "" Then
        If Access("Open", LocPath & CfgFile, BufferA, "", CommonDialog1) <> -1 Then
            Winsock1.Tag = GetSeg(BufferA, ":", 1)
            Winsock1.LocalPort = Val(GetSeg(BufferA, ":", 2))
        End If
    Else
        Winsock1.Tag = "PLAYER"
    End If
    Winsock1.Bind
    If Err <> 0 Then
        Call MsgBox("Address already in use!", 16, "Error")
        Call mnuClose_Click
    End If
    
    Call mnuDefault_Click
    Call mnuNew_Click
    
    If Command <> "" Then Call LoadGame(Command, Form1.CommonDialog1)
    
End Sub
Private Sub Form_Resize()

    Dim BufferA%
    
    If Form1.WindowState = 0 Then
        Form1.Height = Form1.ScaleWidth + (Form1.Height - Form1.ScaleHeight)
        Picture1.Move 0, 0, Form1.ScaleWidth, Form1.ScaleHeight
        RefBoard = True
    End If
    If Form1.WindowState = 2 Then
        BufferA = Form1.Height
        Form1.WindowState = 0
        Form1.Move 0, 0, BufferA - (Form1.Height - Form1.ScaleHeight)
    End If

End Sub
Private Sub Form_Unload(Cancel As Integer)

    Dim BufferA$
    
    On Error Resume Next
    
    BufferA = _
        Winsock1.Tag & ":" & _
        Winsock1.LocalPort
    Call Access("Save", LocPath & CfgFile, BufferA, "", CommonDialog1)
    
    Call Unload(Form2)
    Call Unload(Form3)
    
    End
    
End Sub
Private Sub Inet1_StateChanged(ByVal State As Integer)

    Inet1.Tag = State

End Sub
Private Sub mnuAbout_Click()

    Form0.Visible = True
    Call Wait(1)
    Call Unload(Form0)

    If _
        MsgBox( _
            "Proceed to VB Othello HQ?", _
            64 + 4, _
            "About" _
        ) = 6 _
            Then _
                Call Navigate(Form1, URL)

End Sub
Private Sub mnuAlwaysOnTop_Click()

    If mnuAlwaysOnTop.Checked = False Then
        mnuAlwaysOnTop.Checked = True
        Call WinPos(Form1.hwnd, 1)
    Else
        mnuAlwaysOnTop.Checked = False
        Call WinPos(Form1.hwnd, 0)
    End If

End Sub

Private Sub mnuBoardShading_Click()

    If mnuBoardShading.Checked = False Then
        mnuBoardShading.Checked = True
    Else
        mnuBoardShading.Checked = False
    End If
    BoardShading = mnuBoardShading.Checked
    RefBoard = True

End Sub

Private Sub mnuChipFading_Click()

    If mnuChipFading.Checked = False Then
        mnuChipFading.Checked = True
    Else
        mnuChipFading.Checked = False
    End If
    ChipFading = mnuChipFading.Checked
    RefBoard = True

End Sub
Private Sub mnuChipShading_Click()

    If mnuChipShading.Checked = False Then
        mnuChipShading.Checked = True
    Else
        mnuChipShading.Checked = False
    End If
    ChipShading = mnuChipShading.Checked
    RefBoard = True

End Sub

Private Sub mnuClose_Click()

    Call Unload(Form1)

End Sub

Private Sub mnuConnect_Click()

    Dim BufferA$
    
    If Form2.Visible = True Then
        If MsgBox("This will part the current game. Continue?", 64 + 4, "Part") = 7 Then Exit Sub
    End If
    
Retry:
    On Error Resume Next

    BufferA = _
        InputBox( _
            "Enter remote host IP and remote port:" & vbCrLf & _
            vbCrLf & _
            "(Format: IP:PORT)", _
            "Connect", _
            "" _
        )
    If Trim(BufferA) <> "" Then
        If _
            Trim(GetSeg(BufferA, ":", 1)) <> "" And _
            Trim(GetSeg(BufferA, ":", 2)) <> "" _
                Then
                    Call Unload(Form2)
                    Winsock1.RemoteHost = GetSeg(BufferA, ":", 1)
                    Winsock1.RemotePort = Val(GetSeg(BufferA, ":", 2))
                    Winsock1.SendData ">CONNECT:(" & Winsock1.Tag & ":" & Winsock1.LocalIP & ":" & Winsock1.LocalPort & ")"
                    If Err <> 0 Then
                        Call MsgBox("Cannot resolve host!", 16, "Error")
                        GoTo Retry
                    End If
        Else
            Call MsgBox("Invalid connect data!", 64, "Connect")
            GoTo Retry
        End If
    End If
    
End Sub

Private Sub mnuCopy_Click()

    Clipboard.SetText GetPosArray(2)
    
End Sub
Private Sub mnuDefault_Click()

    Call SetPosArray(2, String(64, "1"))
    RefBoard = True
    
End Sub
Private Sub mnuDepth_Click()
    
    Dim BufferA$
    
    On Error Resume Next
    
Retry:
    BufferA = InputBox("Enter AI search depth:", "Depth", Depth)
    If Trim(BufferA) <> "" Then
        If Val(BufferA) < 1 Then
            Call _
                MsgBox( _
                    "Depth must be at least 1", _
                    64, _
                    "Depth" _
                )
            GoTo Retry
        End If
        Depth = Val(BufferA)
        If Err <> 0 Then
            Call _
                MsgBox( _
                    "Invalid depth", _
                    64, _
                    "Depth" _
                )
            GoTo Retry
        End If
    End If
    
End Sub
Private Sub mnuDownloads_Click()

    Dim A%
    Dim BufferA$
    Dim BufferB$
    Dim BufferC$
    Dim BufferD$
    
    On Error Resume Next

    BufferA = Inet1.OpenURL(URL & RemPath & "downloads.htm")
    BufferA = CleanText(BufferA, "", " ")
    For A = 1 To CntStr(BufferA, "<li>")
        BufferB = GetBtw(BufferA, "<li>", " - <a", A)
        BufferC = GetBtw(BufferA, "a> - ", "</li>", A)
        BufferD = GetBtw(BufferA, "<a href=", ">", A)
        If BufferB = Date Then
            If _
                MsgBox( _
                    CleanText(BufferC, "", " ") & vbCrLf & _
                    vbCrLf & _
                    "Acquire file?", _
                    64 + 4, _
                    "Downloads for " & BufferB _
                ) = 6 _
                    Then _
                        Call Navigate(Form1, URL & BufferD)
            Exit Sub
        End If
    Next A
    Call MsgBox("Nothing new!", 64, "Downloads for " & Date)

End Sub
Private Sub mnuFirst_Click()

    If Form2.Visible = True Then
        If _
            (Form2.mnuBlackPlayer.Caption <> Winsock1.Tag) And _
            (Form2.mnuWhitePlayer.Caption <> Winsock1.Tag) _
                Then
                    Call MsgBox("You are not in control", 64, "Control")
                    Exit Sub
        End If
    End If
    Do While EnumChips(3) > 1
        If Log(EnumChips(3) - 1).Situation = "" Then Exit Do
        Call mnuUndo_Click
    Loop
    
End Sub

Private Sub mnuInfo_Click()

    Clipboard.SetText Winsock1.LocalIP & ":" & Winsock1.LocalPort

    Call MsgBox( _
        "Nick: " & Winsock1.Tag & vbCrLf & _
        vbCrLf & _
        "Local IP: " & Winsock1.LocalIP & vbCrLf & _
        vbCrLf & _
        "Local port: " & Winsock1.LocalPort & vbCrLf & _
        vbCrLf & _
        "(Local IP and local port copied to clipboard)", _
        64, _
        "Info" _
    )

End Sub
Private Sub mnuLast_Click()

    If Form2.Visible = True Then
        If _
            (Form2.mnuBlackPlayer.Caption <> Winsock1.Tag) And _
            (Form2.mnuWhitePlayer.Caption <> Winsock1.Tag) _
                Then
                    Call MsgBox("You are not in control", 64, "Control")
                    Exit Sub
        End If
    End If
    Do While EnumChips(3) < 64
        If Log(EnumChips(3) + 1).Situation = "" Then Exit Do
        Call mnuRedo_Click
    Loop
    
End Sub
Private Sub mnuLastMove_Click()

    If mnuLastMove.Checked = False Then
        mnuLastMove.Checked = True
    Else
        mnuLastMove.Checked = False
    End If
    LastMove = mnuLastMove.Checked
    RefBoard = True

End Sub
Private Sub mnuLoad_Click()
    
    If Form2.Visible = True Then
        If _
            (Form2.mnuBlackPlayer.Caption <> Winsock1.Tag) And _
            (Form2.mnuWhitePlayer.Caption <> Winsock1.Tag) _
                Then
                    Call MsgBox("You are not in control", 64, "Control")
                    Exit Sub
        End If
    End If
    Call LoadGame("Prompt", Form1.CommonDialog1)

End Sub
Private Sub mnuGridMarks_Click()

    If mnuGridMarks.Checked = False Then
        mnuGridMarks.Checked = True
    Else
        mnuGridMarks.Checked = False
    End If
    GridMarks = mnuGridMarks.Checked
    RefBoard = True

End Sub
Private Sub mnuBoardAnalysis_Click()

    If mnuBoardAnalysis.Checked = False Then
        mnuBoardAnalysis.Checked = True
    Else
        mnuBoardAnalysis.Checked = False
    End If
    Form5.Visible = mnuBoardAnalysis.Checked
    RefBoard = True

End Sub

Private Sub mnuMode_Click()
    
    Dim BufferA$
    
Retry:
    BufferA = InputBox("Enter AI search mode: (1 = Min, 2 = Avg, 3 = Max)", "Mode", Mode)
    If Trim(BufferA) <> "" Then
        If _
            Val(BufferA) <> 1 And _
            Val(BufferA) <> 2 And _
            Val(BufferA) <> 3 _
                Then
                    Call _
                        MsgBox( _
                            "Mode must be either 1, 2, or 3", _
                            64, _
                            "Mode" _
                        )
                    GoTo Retry
        End If
        Mode = Val(BufferA)
    End If
    
End Sub
Private Sub mnuNew_Click()

    If Form2.Visible = True Then
        If _
            (Form2.mnuBlackPlayer.Caption <> Winsock1.Tag) And _
            (Form2.mnuWhitePlayer.Caption <> Winsock1.Tag) _
                Then
                    Call MsgBox("You are not in control", 64, "Control")
                    Exit Sub
        End If
    End If
    Call NewBoard

End Sub
Private Sub mnuNews_Click()

    Dim A%
    Dim BufferA$
    Dim BufferB$
    
    On Error Resume Next

    BufferA = Inet1.OpenURL(URL & RemPath & "news.htm")
    For A = 1 To CntStr(BufferA, "<li>")
        BufferB = GetBtw(BufferA, "<li>", "</li>", A)
        If GetSeg(BufferB, " - ", 1) = Date Then
            If _
                MsgBox( _
                    GetSeg(BufferB, " - ", 2) & vbCrLf & _
                    vbCrLf & _
                    "Visit site?", _
                    64 + 4, _
                    "News for " & GetSeg(BufferB, " - ", 1) _
                ) = 6 _
                    Then _
                        Call Navigate(Form1, URL & RemPath & "news.htm")
            Exit Sub
        End If
    Next A
    Call MsgBox("Nothing new!", 64, "News for " & Date)

End Sub
Private Sub mnuPaste_Click()

    Call SetPosArray(2, Clipboard.GetText)
    RefBoard = True
    
End Sub

Private Sub mnuPlayers_Click()

    Form3.Visible = True

End Sub
Private Sub mnuRedo_Click()

    If Form2.Visible = True Then
        If _
            (Form2.mnuBlackPlayer.Caption <> Winsock1.Tag) And _
            (Form2.mnuWhitePlayer.Caption <> Winsock1.Tag) _
                Then
                    Call MsgBox("You are not in control", 64, "Control")
                    Exit Sub
        End If
    End If
    If EnumChips(3) < 64 Then
        If Log(EnumChips(3) + 1).Situation <> "" Then
            Call GetLog(EnumChips(3) + 1)
        End If
    End If
    RefBoard = True
    
End Sub

Private Sub mnuScores_Click()

    Form4.Visible = True

End Sub
Private Sub mnuSearchReport_Click()

    If mnuSearchReport.Checked = False Then
        mnuSearchReport.Checked = True
    Else
        mnuSearchReport.Checked = False
    End If
    Form6.Visible = mnuSearchReport.Checked
    RefBoard = True

End Sub
Private Sub mnuSave_Click()

    Call SaveGame(Form1.CommonDialog1)

End Sub
Private Sub mnuSearchSteps_Click()

    If mnuSearchSteps.Checked = False Then
        mnuSearchSteps.Checked = True
    Else
        mnuSearchSteps.Checked = False
    End If
    SearchSteps = mnuSearchSteps.Checked

End Sub
Private Sub mnuSetup_Click()

    Dim BufferA$

    If Form2.Visible = True Then
        If MsgBox("This will part the current game. Continue?", 64 + 4, "Part") = 7 Then Exit Sub
    End If

Retry:
    On Error Resume Next

    BufferA = _
        InputBox( _
            "Enter player nick and local port:" & vbCrLf & _
            vbCrLf & _
            "(Format: NICK:PORT)", _
            "Setup", _
            Winsock1.Tag & ":" & Winsock1.LocalPort _
        )
    If Trim(BufferA) <> "" Then
        BufferA = UCase(Left(CleanText(Trim(BufferA), "", " "), 12))
        If _
            Trim(GetSeg(BufferA, ":", 1)) <> "" And _
            Trim(GetSeg(BufferA, ":", 2)) <> "" _
                Then
                    Call Unload(Form2)
                    Winsock1.Close
                    Winsock1.Tag = GetSeg(BufferA, ":", 1)
                    Winsock1.LocalPort = Val(GetSeg(BufferA, ":", 2))
                    Winsock1.Bind
                    If Err <> 0 Then
                        Call MsgBox("Address already in use!", 16, "Error")
                        GoTo Retry
                    End If
        Else
            Call MsgBox("Invalid setup data!", 64, "Setup")
            GoTo Retry
        End If
    End If
    
End Sub
Private Sub mnuUndo_Click()

    If Form2.Visible = True Then
        If _
            (Form2.mnuBlackPlayer.Caption <> Winsock1.Tag) And _
            (Form2.mnuWhitePlayer.Caption <> Winsock1.Tag) _
                Then
                    Call MsgBox("You are not in control", 64, "Control")
                    Exit Sub
        End If
    End If
    If EnumChips(3) > 1 Then
        If Log(EnumChips(3) - 1).Situation <> "" Then
            Call GetLog(EnumChips(3) - 1)
        End If
    End If
    RefBoard = True
    
End Sub
Private Sub mnuMapValues_Click()

    If mnuMapValues.Checked = False Then
        mnuMapValues.Checked = True
    Else
        mnuMapValues.Checked = False
    End If
    MapValues = mnuMapValues.Checked
    RefBoard = True

End Sub

Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)

    AssignVal = Val(Chr(KeyCode))
    If Shift = 2 And KeyCode = 192 Then
        If Form2.Visible = True Then
            Call MsgBox("This action is not allowed in multiplayer games", 64, "Control")
            Exit Sub
        End If
        PassedTurn = Not PassedTurn
    End If
    If Shift = 2 And KeyCode = 9 Then
        If Form2.Visible = True Then
            Call MsgBox("This action is not allowed in multiplayer games", 64, "Control")
            Exit Sub
        End If
        If Turn = 1 Then
            Turn = 2
        ElseIf Turn = 2 Then
            Turn = 3
        ElseIf Turn = 3 Then
            Turn = 1
        End If
    End If
    If KeyCode = 78 Then Call mnuNew_Click
    If KeyCode = 76 Then Call mnuLoad_Click
    If KeyCode = 83 Then Call mnuSave_Click
    If KeyCode = 27 Then Call mnuClose_Click
    If KeyCode = 36 Then mnuFirst_Click
    If KeyCode = 33 Then mnuUndo_Click
    If KeyCode = 34 Then mnuRedo_Click
    If KeyCode = 35 Then mnuLast_Click
    If Shift = 2 Then
        If KeyCode = 88 Then Call mnuDefault_Click
        If KeyCode = 67 Then Call mnuCopy_Click
        If KeyCode = 86 Then Call mnuPaste_Click
    End If

End Sub
Private Sub Picture1_KeyUp(KeyCode As Integer, Shift As Integer)

    AssignVal = -1

End Sub

Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    Dim TempColumn%
    Dim TempRow%
    Dim BufferA%
    
    If AssignVal = -1 Then
        If Form2.Visible = True Then
            If _
                Form2.mnuBlackPlayer.Caption <> Winsock1.Tag And _
                Form2.mnuWhitePlayer.Caption <> Winsock1.Tag _
                    Then
                        Call MsgBox("You are not in control", 64, "Control")
                        Exit Sub
            End If
            If _
                (Turn = 1 And Form2.mnuBlackPlayer.Caption <> Winsock1.Tag) Or _
                (Turn = 2 And Form2.mnuWhitePlayer.Caption <> Winsock1.Tag) _
                    Then
                        Call MsgBox("It is not your turn", 64, "Control")
                        Exit Sub
            End If
        End If
        If Turn = 3 Then
            Call MsgBox("The game is over", 64, "Control")
            Exit Sub
        End If
        If LocStr(GetPosArray(2), "0", 1) <> 0 Then
            Call MsgBox("Invalid map! Using default!", 64, "Map")
            Call mnuDefault_Click
        End If
        If Button = 1 Then
            Call MakeMove(SnapPos(Picture1, X), SnapPos(Picture1, Y))
        Else
            Call TreeSearch(TempColumn, TempRow, Form6, Form6.Text1) 'DEBUG
            Call MakeMove(TempColumn, TempRow)
        End If
    Else
        If Shift = 2 Then
            If Form2.Visible = True Then
                Call MsgBox("This action is not allowed in multiplayer games", 64, "Control")
                Exit Sub
            End If
            If _
                AssignVal = 0 Or _
                AssignVal = 1 Or _
                AssignVal = 2 _
                    Then _
                        Call SetPosState(1, SnapPos(Picture1, X), SnapPos(Picture1, Y), AssignVal)
        End If
        If Shift = 1 Then Call SetPosState(2, SnapPos(Picture1, X), SnapPos(Picture1, Y), AssignVal)
        RefBoard = True
    End If
    
End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    If IsValidPos(SnapPos(Picture1, X), SnapPos(Picture1, Y)) = True Then
        Picture1.MousePointer = 2
    Else
        Picture1.MousePointer = 0
    End If

End Sub
Private Sub Timer1_Timer()

    Dim A%
    Dim BufferA$
    Dim BufferB$
    Dim BufferC$

    If RefBoard = True Then
        RefBoard = False
        Call ShowInfo(Form1)
        Picture1.Cls
        Call RefreshBoard(Picture1, True)
        If RefLog = True Then
            RefLog = False
            Call CutLog
            If PeerRef = True Then
                PeerRef = False
            Else
                Call SendToAll(Winsock1, ">LOG:(" & GetBoard & ")")
            End If
            If Turn = 3 Then
                If _
                    (EnumChips(1) > EnumChips(2) And Form2.mnuBlackPlayer.Caption = Winsock1.Tag) Or _
                    (EnumChips(2) > EnumChips(1) And Form2.mnuWhitePlayer.Caption = Winsock1.Tag) _
                        Then
                            Winsock1.SendData ">GAMEREQ:(" & Winsock1.Tag & ":IWON)"
                End If
                If _
                    (EnumChips(1) < EnumChips(2) And Form2.mnuBlackPlayer.Caption = Winsock1.Tag) Or _
                    (EnumChips(2) < EnumChips(1) And Form2.mnuWhitePlayer.Caption = Winsock1.Tag) _
                        Then
                            Winsock1.SendData ">GAMEREQ:(" & Winsock1.Tag & ":ILOST)"
                End If
                If _
                    EnumChips(1) = EnumChips(2) And _
                    (Form2.mnuBlackPlayer.Caption = Winsock1.Tag Or Form2.mnuWhitePlayer.Caption = Winsock1.Tag) _
                        Then
                            Winsock1.SendData ">GAMEREQ:(" & Winsock1.Tag & ":WETIED)"
                End If
            End If
        Else
            If PeerRef = True Then
                PeerRef = False
            Else
                Call SendToAll(Winsock1, ">BOARD:(" & GetBoard & ")")
            End If
        End If
        If EnumChips(3) > 1 Then
            If Log(EnumChips(3) - 1).Situation = "" Then
                mnuFirst.Enabled = False
                mnuUndo.Enabled = False
            Else
                mnuFirst.Enabled = True
                mnuUndo.Enabled = True
            End If
        End If
        If EnumChips(3) < 64 Then
            If Log(EnumChips(3) + 1).Situation = "" Then
                mnuRedo.Enabled = False
                mnuLast.Enabled = False
            Else
                mnuRedo.Enabled = True
                mnuLast.Enabled = True
            End If
        End If
        If Form5.Visible = True Then
            Call DrawAnalysis(Form5.Picture1)
            Form5.Caption = "Board Analysis: " & Format$(Int(EnumLog / 61 * 100)) & "% completed"
        End If
        If Form6.Visible = True Then
            Form6.Caption = "Search Report"
        End If
    End If

End Sub
Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)

    Dim BufferA$
    Dim BufferB$
    Dim BufferC$
    Dim BufferD$
    
    On Error Resume Next
    
    Winsock1.GetData BufferA
    BufferB = GetBtw(BufferA, ">", ":", 1)
    BufferC = GetBtw(BufferA, "(", ")", 1)
    If BufferB = "CONNECT" Then
        Call Load(Form2)
        If EnumContact < (UBound(Player) - LBound(Player) + 1) Then
            If GetContact(GetSeg(BufferC, ":", 1)) = 0 Then
                Call AddContact(BufferC)
                Call ListContact(Form2.List1)
                Call UseContact(Winsock1, GetSeg(BufferC, ":", 1))
                Winsock1.SendData ">ADDME:(" & Winsock1.Tag & ":" & Winsock1.LocalIP & ":" & Winsock1.LocalPort & ")"
                Winsock1.SendData ">VERREQ:(" & Winsock1.Tag & ")"
            Else
                Winsock1.RemoteHost = GetSeg(BufferC, ":", 2)
                Winsock1.RemotePort = GetSeg(BufferC, ":", 3)
                Winsock1.SendData ">REJECT:(Nick " & GetSeg(BufferC, ":", 1) & " already in use!)"
            End If
        Else
            Winsock1.RemoteHost = GetSeg(BufferC, ":", 2)
            Winsock1.RemotePort = GetSeg(BufferC, ":", 3)
            Winsock1.SendData ">REJECT:(Game already full!)"
        End If
    End If
    If BufferB = "VERREQ" Then
        Call UseContact(Winsock1, BufferC)
        Winsock1.SendData ">VERREP:(" & Winsock1.Tag & ":" & App.Major & ":" & App.Minor & ":" & App.Revision & ")"
    End If
    If BufferB = "VERREP" Then
        If _
            GetSeg(BufferC, ":", 2) = App.Major And _
            GetSeg(BufferC, ":", 3) = App.Minor And _
            GetSeg(BufferC, ":", 4) = App.Revision _
                Then
                    Call UseContact(Winsock1, GetSeg(BufferC, ":", 1))
                    If MsgBox("Connect request from " & GetSeg(BufferC, ":", 1) & " recieved. Accept?", 64 + 4, "Connect") = 6 Then
                        Winsock1.SendData ">ACCEPT:(" & Winsock1.Tag & ")"
                        Call SendToAll( _
                            Winsock1, _
                            ">MEETHIM:(" & _
                                GetSeg(BufferC, ":", 1) & ":" & _
                                Player(GetContact(GetSeg(BufferC, ":", 1))).Host & ":" & _
                                Player(GetContact(GetSeg(BufferC, ":", 1))).Port & _
                            ")" _
                        )
                        Form2.Visible = True
                    Else
                        Winsock1.SendData ">REJECT:(Connect request denied!)"
                    End If
        Else
            Call UseContact(Winsock1, GetSeg(BufferC, ":", 1))
            Winsock1.SendData ">REJECT:(Version must be " & App.Major & "." & App.Minor & "." & App.Revision & " to connect to peer)"
        End If
    End If
    If BufferB = "ACCEPT" Then
        Form2.Visible = True
        Call UseContact(Winsock1, GetSeg(BufferC, ":", 1))
        Winsock1.SendData ">REFREQ:(" & Winsock1.Tag & ")"
    End If
    If BufferB = "REFREQ" Then
        Call UseContact(Winsock1, GetSeg(BufferC, ":", 1))
        Winsock1.SendData ">BOARD:(" & GetBoard & ")"
        Winsock1.SendData ">CONTROL:(" & Form2.mnuBlackPlayer.Caption & ":" & Form2.mnuWhitePlayer.Caption & ")"
    End If
    If BufferB = "ADDME" Then
        Call AddContact(BufferC)
        Call ListContact(Form2.List1)
    End If
    If BufferB = "MEETHIM" Then
        Call AddContact(BufferC)
        Call ListContact(Form2.List1)
        Call UseContact(Winsock1, GetSeg(BufferC, ":", 1))
        Winsock1.SendData ">ADDME:(" & Winsock1.Tag & ":" & Winsock1.LocalIP & ":" & Winsock1.LocalPort & ")"
    End If
    If BufferB = "BOARD" Then
        Call SetBoard(BufferC)
        PeerRef = True
    End If
    If BufferB = "LOG" Then
        Call SetBoard(BufferC)
        RefLog = True
        PeerRef = True
    End If
    If BufferB = "CONTROL" Then
        Form2.mnuBlackPlayer.Caption = GetSeg(BufferC, ":", 1)
        Form2.mnuWhitePlayer.Caption = GetSeg(BufferC, ":", 2)
    End If
    If BufferB = "RENAME" Then
        Player(GetContact(GetSeg(BufferC, ":", 1))).Name = GetSeg(BufferC, ":", 2)
        Call ListContact(Form2.List1)
        If Form2.mnuBlackPlayer.Caption = GetSeg(BufferC, ":", 1) Then Form2.mnuBlackPlayer.Caption = GetSeg(BufferC, ":", 2)
        If Form2.mnuWhitePlayer.Caption = GetSeg(BufferC, ":", 1) Then Form2.mnuWhitePlayer.Caption = GetSeg(BufferC, ":", 2)
    End If
    If BufferB = "GAMEREQ" Then
        Call UseContact(Winsock1, GetSeg(BufferC, ":", 1))
        Winsock1.SendData ">GAMEREP:(" & Winsock1.Tag & ":" & GetSeg(BufferC, ":", 2) & ")"
    End If
    If BufferB = "GAMEREP" Then
        If GetSeg(BufferC, ":", 2) = "IWON" Then
            If MsgBox("You have defeated " & GetSeg(BufferC, ":", 1) & ". Update scores?", 64 + 4, "Scores") = 6 Then
                BufferD = Inet1.OpenURL(URL & RemPath & "SCORES/" & GetSeg(BufferC, ":", 1))
                BufferD = CleanText(BufferD, "", "")
                If Not (CntStr(BufferD, "Index") = 0 And CntStr(BufferD, "Not Found") = 0) Then BufferD = ""
                BufferD = _
                    GetSeg(BufferD, ":", 1) & ":" & _
                    (Val(GetSeg(BufferD, ":", 2)) + 1) & ":" & _
                    GetSeg(BufferD, ":", 3)
                Call Access("Save", LocPath & GetSeg(BufferC, ":", 1), BufferD, "", CommonDialog1)
                Call FTP("SEND " & LocPath & GetSeg(BufferC, ":", 1) & " " & RemPath & "SCORES/" & GetSeg(BufferC, ":", 1))
                BufferD = Inet1.OpenURL(URL & RemPath & "SCORES/" & Winsock1.Tag)
                BufferD = CleanText(BufferD, "", "")
                If Not (CntStr(BufferD, "Index") = 0 And CntStr(BufferD, "Not Found") = 0) Then BufferD = ""
                BufferD = _
                    (Val(GetSeg(BufferD, ":", 1)) + 1) & ":" & _
                    GetSeg(BufferD, ":", 2) & ":" & _
                    GetSeg(BufferD, ":", 3)
                Call Access("Save", LocPath & Winsock1.Tag, BufferD, "", CommonDialog1)
                Call FTP("SEND " & LocPath & Winsock1.Tag & " " & RemPath & "SCORES/" & Winsock1.Tag)
                Call MsgBox("Scores successfully updated!", 64, "Scores")
            End If
        End If
        If GetSeg(BufferC, ":", 2) = "ILOST" Then
            Call MsgBox("You were defeated by " & GetSeg(BufferC, ":", 1), 64, "Scores")
        End If
        If GetSeg(BufferC, ":", 2) = "WETIED" Then
            If MsgBox("You tied with " & GetSeg(BufferC, ":", 1) & ". Update scores?", 64 + 4, "Scores") = 6 Then
                BufferD = Inet1.OpenURL(URL & RemPath & "SCORES/" & GetSeg(BufferC, ":", 1))
                BufferD = CleanText(BufferD, "", "")
                If CntStr(BufferD, "Index") <> 0 Or CntStr(BufferD, "Not Found") <> 0 Then BufferD = ""
                BufferD = _
                    GetSeg(BufferD, ":", 1) & ":" & _
                    GetSeg(BufferD, ":", 2) & ":" & _
                    (Val(GetSeg(BufferD, ":", 3)) + 1)
                Call Access("Save", LocPath & GetSeg(BufferC, ":", 1), BufferD, "", CommonDialog1)
                Call FTP("SEND " & LocPath & GetSeg(BufferC, ":", 1) & " " & RemPath & "SCORES/" & GetSeg(BufferC, ":", 1))
                Call MsgBox("Scores successfully updated!", 64, "Scores")
            End If
        End If
    End If
    If BufferB = "INQREQ" Then
        Winsock1.RemoteHost = GetSeg(BufferC, ":", 2)
        Winsock1.RemotePort = GetSeg(BufferC, ":", 3)
        Winsock1.SendData ">INQREP:(" & Winsock1.Tag & ":" & EnumContact & ":" & Form2.Tag & ")"
    End If
    If BufferB = "INQREP" Then
        Call _
            MsgBox( _
                "Name: " & GetSeg(BufferC, ":", 1) & vbCrLf & _
                vbCrLf & _
                "Players: " & GetSeg(BufferC, ":", 2) & vbCrLf & _
                vbCrLf & _
                "Title: " & GetSeg(BufferC, ":", 3), _
                64, _
                "Inquire" _
            )
    End If
    If BufferB = "SAY" Then
        Call AppendText(Form2.Text1, GetIRCMsg(GetSeg(BufferC, ":", 1), GetSeg(BufferC, ":", 2)), 10000)
    End If
    If BufferB = "MESSAGE" Then
        Call MsgBox(GetIRCMsg(GetSeg(BufferC, ":", 1), GetSeg(BufferC, ":", 2)), 64, "You recieved a message")
    End If
    If BufferB = "KICK" Then
        Call MsgBox(GetIRCMsg(GetSeg(BufferC, ":", 1), GetSeg(BufferC, ":", 2)), 64, "You were kicked")
        Call Unload(Form2)
    End If
    If BufferB = "REJECT" Then
        Call MsgBox(BufferC, 64, "You were rejected")
        Call Unload(Form2)
    End If
    If BufferB = "DISCONNECT" Then
        Call RemContact(BufferC)
        Call ListContact(Form2.List1)
        If Form2.mnuBlackPlayer.Caption = BufferC Then Form2.mnuBlackPlayer.Caption = ""
        If Form2.mnuWhitePlayer.Caption = BufferC Then Form2.mnuWhitePlayer.Caption = ""
        If EnumContact = 1 Then Call Unload(Form2)
    End If
    If Err <> 0 Then Call MsgBox("Cannot contact peer(s)!", 16, "Error")
    
End Sub
