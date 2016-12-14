VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Lode Runner"
   ClientHeight    =   3195
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   1440
      Top             =   600
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox Picture4 
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   4
      Top             =   2520
      Width           =   1215
   End
   Begin VB.PictureBox Picture3 
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   3
      Top             =   1920
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   1320
      Width           =   1215
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
   Begin VB.Timer Timer1 
      Interval        =   1
      Left            =   1440
      Top             =   120
   End
   Begin VB.Menu mnuGame 
      Caption         =   "&Game"
      Begin VB.Menu mnuNew 
         Caption         =   "&New"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuReset 
         Caption         =   "&Reset"
      End
      Begin VB.Menu mnuBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuLoad 
         Caption         =   "&Load"
         Shortcut        =   ^L
      End
      Begin VB.Menu mnuSave 
         Caption         =   "&Save"
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditor 
         Caption         =   "&Editor"
      End
      Begin VB.Menu mnuSound 
         Caption         =   "S&ound"
      End
      Begin VB.Menu mnuBar3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
         Shortcut        =   ^X
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuControls 
         Caption         =   "&Controls"
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()

    Call _
        InitGame( _
            "config01.txt", _
            Picture1, _
            Picture2, _
            Command1, _
            Picture3, _
            Timer1 _
        )
    Command1.TabStop = False
    Picture4.BackColor = vbBlack
    Picture4.ForeColor = vbWhite
    Picture4.BorderStyle = vbBSNone
    Picture4.AutoRedraw = True
    Picture4.ScaleMode = vbPixels
    CurrentLevel = StartLevel
    Call mnuEditor_Click
    Call mnuEditor_Click
    Call mnuSound_Click
    Call mnuNew_Click
    
End Sub
Private Sub Form_Resize()

    Dim MinDimX As Integer
    Dim MinDimY As Integer
    
    On Error Resume Next
    
    If (Form1.ScaleWidth / Form1.ScaleHeight) < (ViewWidth / ViewHeight) Then
        MinDimX = Form1.ScaleWidth
        MinDimY = Form1.ScaleWidth * (ViewHeight / ViewWidth)
        Call Picture4.Move(0, MinDimY, MinDimX, Form1.ScaleHeight - MinDimY)
    Else
        MinDimX = Form1.ScaleHeight * (ViewWidth / ViewHeight)
        MinDimY = Form1.ScaleHeight
        Call Picture4.Move(MinDimX, 0, Form1.ScaleWidth - MinDimX, MinDimY)
    End If
    Call Command1.Move(0, 0, MinDimX, MinDimY)
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    Call DeinitGame(Form1.hwnd)
    Call ResetSound
    End
    
End Sub
Private Sub mnuAbout_Click()

    Call ShowAbout
    
End Sub

Private Sub mnuControls_Click()

    Call _
        MsgBox( _
            "ARROW KEYS: move" & vbCrLf & _
                vbCrLf & _
                "SPACE BAR: stop" & vbCrLf & _
                vbCrLf & _
                "CTRL: melt left" & vbCrLf & _
                vbCrLf & _
                "INS: melt right" & vbCrLf & _
                vbCrLf & _
                "END: plant bomb / plot grid" & vbCrLf & _
                vbCrLf & _
                "PAGE UP: scroll up" & vbCrLf & _
                vbCrLf & _
                "PAGE DOWN: scroll down", _
            vbInformation, _
            App.Title _
        )
        
End Sub
Private Sub mnuEditor_Click()

    mnuEditor.Checked = Not mnuEditor.Checked
    mnuReset.Enabled = mnuEditor.Checked
    mnuSave.Enabled = mnuEditor.Checked
    Call mnuReset_Click
    
End Sub
Private Sub mnuExit_Click()

    Call Unload(Form1)
    
End Sub
Private Sub mnuLoad_Click()

    On Error Resume Next
    
    CommonDialog1.CancelError = True
    CommonDialog1.Filter = _
        "Level Files (*.lev)|*.lev|" & _
        "Text Files (*.txt)|*.txt|" & _
        "All Files (*.*)|*.*"
    CommonDialog1.InitDir = App.Path
    CommonDialog1.Action = 1
    If Err = 0 Then
        If _
            LCase( _
                Left( _
                    CommonDialog1.Filename, _
                    Len(CommonDialog1.Filename) - _
                        Len(GetFilename(CommonDialog1.Filename)) _
                ) _
            ) = _
                LCase(App.Path & "\") _
        Then
            CurrentLevel = GetFilename(CommonDialog1.Filename)
            Call mnuReset_Click
        Else
            Call _
                MsgBox( _
                    "ERROR: file not in game directory!", _
                    vbCritical, _
                    App.Title _
                )
        End If
    End If
    
End Sub
Private Sub mnuNew_Click()

    If Not mnuEditor.Checked Then
        If CurrentLevel <> "" Then
            Call InitLevel(CurrentLevel)
        Else
            Call _
                MsgBox( _
                    "ERROR: blank map not playable!", _
                    vbCritical, _
                    App.Title _
                )
            Call mnuLoad_Click
        End If
    Else
        CurrentLevel = ""
        Call mnuReset_Click
    End If
    
End Sub
Private Sub mnuReset_Click()

    If Not mnuEditor.Checked Then
        Call mnuNew_Click
    Else
        Call InitEdit(CurrentLevel)
    End If
    
End Sub
Private Sub mnuSave_Click()

    On Error Resume Next
    
    CommonDialog1.CancelError = True
    CommonDialog1.Filter = _
        "Level Files (*.lev)|*.lev|" & _
        "Text Files (*.txt)|*.txt|" & _
        "All Files (*.*)|*.*"
    CommonDialog1.Action = 2
    If Err = 0 Then
        Call SaveLevel(CommonDialog1.Filename, MemLevel)
        Call MsgBox("Map saved!", vbInformation, App.Title)
    End If
    
End Sub

Private Sub mnuSound_Click()

    mnuSound.Checked = Not mnuSound.Checked
    GameSound = mnuSound.Checked
    
End Sub

Private Sub Picture4_KeyDown(KeyCode As Integer, Shift As Integer)

    Dim ActorIndex As Integer
    Dim AbsIndex As Integer
    
    If KeyCode = 27 Then
        Call Unload(Form1)
        Exit Sub
    End If
    If MemActorList(PlayerIndex).UserControl Then
        AbsIndex = GetAbsoluteIndex(MemActorList(PlayerIndex))
        Select Case KeyCode
            Case 37
                MemActorList(PlayerIndex).SpriteSequence = "player1 move left"
            Case 38
                MemActorList(PlayerIndex).SpriteSequence = "player1 move up"
            Case 39
                MemActorList(PlayerIndex).SpriteSequence = "player1 move right"
            Case 40
                MemActorList(PlayerIndex).SpriteSequence = "player1 move down"
            Case 32
                MemActorList(PlayerIndex).SpriteSequence = "player1 stop"
            Case 17
                If Not mnuEditor.Checked Then
                    If _
                        MemLevel(AbsIndex - 1) = GetSpriteIndex(VoidCode) And _
                        MemLevel(AbsIndex + LevelWidth - 1) = _
                            GetSpriteIndex(BrickCode) _
                    Then
                        MemActorList(PlayerIndex).SpriteSequence = "player1 melt left"
                        ActorIndex = SpawnAcidMeltEx(MemActorList, False, BrickTime, 0)
                        MemActorList(ActorIndex).GridX = _
                            CInt(MemActorList(PlayerIndex).GridX) - 1
                        MemActorList(ActorIndex).GridY = _
                            CInt(MemActorList(PlayerIndex).GridY)
                        MemActorList(ActorIndex).Dormant = False
                    End If
                End If
            Case 96
                If Not mnuEditor.Checked Then
                    If _
                        MemLevel(AbsIndex + 1) = GetSpriteIndex(VoidCode) And _
                        MemLevel(AbsIndex + LevelWidth + 1) = _
                            GetSpriteIndex(BrickCode) _
                    Then
                        MemActorList(PlayerIndex).SpriteSequence = "player1 melt right"
                        ActorIndex = SpawnAcidMeltEx(MemActorList, True, BrickTime, 0)
                        MemActorList(ActorIndex).GridX = _
                            CInt(MemActorList(PlayerIndex).GridX) + 1
                        MemActorList(ActorIndex).GridY = _
                            CInt(MemActorList(PlayerIndex).GridY)
                        MemActorList(ActorIndex).Dormant = False
                    End If
                End If
            Case 35
                If Not mnuEditor.Checked Then
                    If MemActorList(PlayerIndex).RelicCount <> 0 Then
                        MemActorList(PlayerIndex).SpriteSequence = _
                            "player1 plant"
                        Select Case MemActorList(PlayerIndex).Relic
                            Case GetSpriteIndex(RedBombCode)
                                ActorIndex = SpawnRedBombEx(MemActorList, BombTime, 0)
                            Case GetSpriteIndex(GreenBombCode)
                                ActorIndex = SpawnGreenBombEx(MemActorList, BombTime, 0)
                            Case GetSpriteIndex(YellowBombCode)
                                ActorIndex = SpawnYellowBombEx(MemActorList, BombTime, 0)
                            Case GetSpriteIndex(CyanBombCode)
                                ActorIndex = SpawnCyanBombEx(MemActorList, BombTime, 0)
                        End Select
                        MemActorList(ActorIndex).GridX = _
                            CInt(MemActorList(PlayerIndex).GridX)
                        MemActorList(ActorIndex).GridY = _
                            CInt(MemActorList(PlayerIndex).GridY)
                        MemActorList(ActorIndex).Dormant = _
                            False
                        MemActorList(PlayerIndex).RelicCount = _
                            MemActorList(PlayerIndex).RelicCount - 1
                    End If
                Else
                    MemActorList(PlayerIndex).SpriteSequence = _
                        "player1 plant"
                    MemLevel(AbsIndex) = EditSpriteIndex
                End If
            Case 33
                If mnuEditor.Checked Then
                    EditSpriteIndex = EditSpriteIndex - 1
                    If EditSpriteIndex < 0 Then _
                        EditSpriteIndex = SpriteWidth * SpriteHeight - 1
                    Call PlaySoundEx(ScrollSound)
                End If
            Case 34
                If mnuEditor.Checked Then
                    EditSpriteIndex = _
                        (EditSpriteIndex + 1) Mod (SpriteWidth * SpriteHeight)
                    Call PlaySoundEx(ScrollSound)
                End If
        End Select
    End If
    
End Sub
Private Sub Timer1_Timer()

    Dim i As Integer
    Dim SpriteIndex As Integer
    Dim SpriteCode As String
    Dim Text As String
    
    Call DoActorAI(MemActorList, MemLevel)
    Call UpdateActorList(MemActorList, MemScriptList, MemLevel)
    Call PolishEdges(MemActorList, MemLevel)
    Call DrawLevel(Picture2.hdc, Picture1.hdc, MemLevel)
    Call DrawActorList(Picture2.hdc, Picture1.hdc, MemActorList, Picture3.hdc)
    Call _
        DrawBuffer( _
            MemCanvasHdc, _
            Command1.Width / Screen.TwipsPerPixelX, _
            Command1.Height / Screen.TwipsPerPixelY, _
            Picture2 _
        )
    Picture4.Cls
    If mnuEditor.Checked Then
        i = 0
        Do
            SpriteIndex = (EditSpriteIndex + i) Mod (SpriteWidth * SpriteHeight)
            SpriteCode = GetSpriteCode(SpriteIndex)
            Text = vbTab & SpriteIndex
            Select Case SpriteCode
                Case _
                    Space(2), _
                    VoidCode, _
                    BrickCode, _
                    MetalCode, _
                    LadderCode, _
                    RailCode, _
                    BrickInvisCode, _
                    CaveCode, _
                    GoldCode, _
                    PlayerCode, _
                    EnemyCode, _
                    RedBombCode, _
                    GreenBombCode, _
                    YellowBombCode, _
                    CyanBombCode
                        Text = Text & " *"
            End Select
            If i = 0 Then _
                Text = Text & " <-"
            Call _
                DrawIcon( _
                    SpriteIndex, _
                    Text, _
                    Picture4, _
                    Picture1.hdc, _
                    1, _
                    1 + i _
                )
            i = i + 1
        Loop Until (1 + i + 2) * UnitLength > Picture4.ScaleHeight
    Else
        If CurrentLevel <> "" Then
            Call _
                DrawIcon( _
                    GetSpriteIndex(GoldCode), _
                    vbTab & _
                        MemActorList(PlayerIndex).GoldCount & " out of " & _
                        LevelGoldCount & " collected", _
                    Picture4, _
                    Picture1.hdc, _
                    1, _
                    1 _
                )
            Call _
                DrawIcon( _
                    GetSpriteIndex(EnemyCode), _
                    vbTab & _
                        CountActors(GetSpriteIndex(EnemyCode), MemActorList) & _
                        " remain", _
                    Picture4, _
                    Picture1.hdc, _
                    1, _
                    2 _
                )
            If MemActorList(PlayerIndex).RelicCount = 0 Then _
                MemActorList(PlayerIndex).Relic = 0
            Call _
                DrawIcon( _
                    MemActorList(PlayerIndex).Relic, _
                    vbTab & _
                        MemActorList(PlayerIndex).RelicCount & " remain", _
                    Picture4, _
                    Picture1.hdc, _
                    1, _
                    3 _
                )
            If CountActors(GetSpriteIndex(GoldCode), MemActorList) = 0 Then
                Call PlaySoundEx(WinSound)
                Call MsgBox("You Win!", vbInformation, App.Title)
                Call mnuNew_Click
            End If
            If MemActorList(PlayerIndex).Disabled Then
                Call PlaySoundEx(LoseSound)
                Call MsgBox("Game Over!", vbInformation, App.Title)
                Call mnuNew_Click
            End If
        Else
            Call mnuEditor_Click
        End If
    End If
    
End Sub
