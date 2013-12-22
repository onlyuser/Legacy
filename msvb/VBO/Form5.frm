VERSION 5.00
Begin VB.Form Form5 
   Caption         =   "Form5"
   ClientHeight    =   2910
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   Icon            =   "Form5.frx":0000
   LinkTopic       =   "Form6"
   ScaleHeight     =   2910
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuRefresh 
         Caption         =   "&Refresh"
      End
      Begin VB.Menu mnuSmooth 
         Caption         =   "&Smooth"
      End
   End
   Begin VB.Menu mnuDraw 
      Caption         =   "&Draw"
      Begin VB.Menu mnuPlayerMobility 
         Caption         =   "&Player Mobility"
      End
      Begin VB.Menu mnuPlayerEvaluation 
         Caption         =   "P&layer Evaluation"
      End
      Begin VB.Menu mnuBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuBoardMobility 
         Caption         =   "&Board Mobility"
      End
      Begin VB.Menu mnuBoardEvaluation 
         Caption         =   "B&oard Evaluation"
      End
   End
End
Attribute VB_Name = "Form5"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Form_Resize()

    Picture1.Move 0, 0, Form5.ScaleWidth, Form5.ScaleHeight
    Call DrawAnalysis(Picture1)

End Sub

Private Sub Form_Unload(Cancel As Integer)

    Form1.mnuBoardAnalysis.Checked = False

End Sub
Private Sub mnuBoardEvaluation_Click()

    Dim A%
    Dim UnitX%
    Dim UnitY%
    Dim NewX%
    Dim NewY%
    Dim BufferA$
    Dim BufferB%
    
    Call DrawAnalysis(Picture1)
    
    UnitX = Picture1.ScaleWidth / 60
    UnitY = Picture1.ScaleHeight / 64

    Picture1.DrawWidth = 2

    Picture1.CurrentX = 0
    Picture1.CurrentY = Picture1.ScaleHeight
    For A = 4 To 64
        NewX = UnitX * (CntStr(Log(A).Situation, "1") + CntStr(Log(A).Situation, "2") - 4)
        BufferA = GetPosArray(1)
        BufferB = Turn
        Call SetPosArray(1, Log(A).Situation)
        Turn = Log(A).Turn
        NewY = Picture1.ScaleHeight - UnitY * SumPosEval
        Call SetPosArray(1, BufferA)
        Turn = BufferB
        If NewY <> Picture1.ScaleHeight Then Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(NewX, NewY), vbGreen
    Next A
    
    Picture1.DrawWidth = 1
    
End Sub

Private Sub mnuBoardMobility_Click()

    Dim A%
    Dim UnitX%
    Dim UnitY%
    Dim NewX%
    Dim NewY%
    Dim BufferA$
    Dim BufferB%
    
    Call DrawAnalysis(Picture1)
    
    UnitX = Picture1.ScaleWidth / 60
    UnitY = Picture1.ScaleHeight / 64

    Picture1.DrawWidth = 2

    Picture1.CurrentX = 0
    Picture1.CurrentY = Picture1.ScaleHeight
    For A = 4 To 64
        NewX = UnitX * (CntStr(Log(A).Situation, "1") + CntStr(Log(A).Situation, "2") - 4)
        BufferA = GetPosArray(1)
        BufferB = Turn
        Call SetPosArray(1, Log(A).Situation)
        Turn = Log(A).Turn
        NewY = Picture1.ScaleHeight - UnitY * EnumValidPos
        Call SetPosArray(1, BufferA)
        Turn = BufferB
        If NewY <> Picture1.ScaleHeight Then Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(NewX, NewY), vbGreen
    Next A
    
    Picture1.DrawWidth = 1
    
End Sub

Private Sub mnuPlayerEvaluation_Click()

    Dim A%
    Dim UnitX%
    Dim UnitY%
    Dim NewX%
    Dim NewY%
    Dim BufferA$
    Dim BufferB%
    
    Call DrawAnalysis(Picture1)
    
    UnitX = Picture1.ScaleWidth / 60
    UnitY = Picture1.ScaleHeight / 64
    
    Picture1.DrawWidth = 2
    
    Picture1.CurrentX = 0
    Picture1.CurrentY = Picture1.ScaleHeight
    For A = 4 To 64
        If Log(A).Turn = 1 Then
            NewX = UnitX * (CntStr(Log(A).Situation, "1") + CntStr(Log(A).Situation, "2") - 4)
            BufferA = GetPosArray(1)
            BufferB = Turn
            Call SetPosArray(1, Log(A).Situation)
            Turn = Log(A).Turn
            NewY = Picture1.ScaleHeight - UnitY * SumPosEval
            Call SetPosArray(1, BufferA)
            Turn = BufferB
            If NewY <> Picture1.ScaleHeight Then Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(NewX, NewY), vbBlack
        End If
    Next A
    
    Picture1.CurrentX = 0
    Picture1.CurrentY = Picture1.ScaleHeight
    For A = 4 To 64
        If Log(A).Turn = 2 Then
            NewX = UnitX * (CntStr(Log(A).Situation, "1") + CntStr(Log(A).Situation, "2") - 4)
            BufferA = GetPosArray(1)
            BufferB = Turn
            Call SetPosArray(1, Log(A).Situation)
            Turn = Log(A).Turn
            NewY = Picture1.ScaleHeight - UnitY * SumPosEval
            Call SetPosArray(1, BufferA)
            Turn = BufferB
            If NewY <> Picture1.ScaleHeight Then Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(NewX, NewY), vbWhite
        End If
    Next A
    
    Picture1.DrawWidth = 1

End Sub

Private Sub mnuPlayerMobility_Click()

    Dim A%
    Dim UnitX%
    Dim UnitY%
    Dim NewX%
    Dim NewY%
    Dim BufferA$
    Dim BufferB%
    
    Call DrawAnalysis(Picture1)
    
    UnitX = Picture1.ScaleWidth / 60
    UnitY = Picture1.ScaleHeight / 64
    
    Picture1.DrawWidth = 2
    
    Picture1.CurrentX = 0
    Picture1.CurrentY = Picture1.ScaleHeight
    For A = 4 To 64
        If Log(A).Turn = 1 Then
            NewX = UnitX * (CntStr(Log(A).Situation, "1") + CntStr(Log(A).Situation, "2") - 4)
            BufferA = GetPosArray(1)
            BufferB = Turn
            Call SetPosArray(1, Log(A).Situation)
            Turn = Log(A).Turn
            NewY = Picture1.ScaleHeight - UnitY * EnumValidPos
            Call SetPosArray(1, BufferA)
            Turn = BufferB
            If NewY <> Picture1.ScaleHeight Then Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(NewX, NewY), vbBlack
        End If
    Next A
    
    Picture1.CurrentX = 0
    Picture1.CurrentY = Picture1.ScaleHeight
    For A = 4 To 64
        If Log(A).Turn = 2 Then
            NewX = UnitX * (CntStr(Log(A).Situation, "1") + CntStr(Log(A).Situation, "2") - 4)
            BufferA = GetPosArray(1)
            BufferB = Turn
            Call SetPosArray(1, Log(A).Situation)
            Turn = Log(A).Turn
            NewY = Picture1.ScaleHeight - UnitY * EnumValidPos
            Call SetPosArray(1, BufferA)
            Turn = BufferB
            If NewY <> Picture1.ScaleHeight Then Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(NewX, NewY), vbWhite
        End If
    Next A
    
    Picture1.DrawWidth = 1

End Sub

Private Sub mnuRefresh_Click()

    RefBoard = True

End Sub

Private Sub mnuSmooth_Click()

    If mnuSmooth.Checked = False Then
        mnuSmooth.Checked = True
    Else
        mnuSmooth.Checked = False
    End If
    Smooth = mnuSmooth.Checked
    RefBoard = True
    
End Sub
Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)

    If Form2.Visible = True Then
        If _
            (Form2.mnuBlackPlayer.Caption <> Form1.Winsock1.Tag) And _
            (Form2.mnuWhitePlayer.Caption <> Form1.Winsock1.Tag) _
                Then
                    Call MsgBox("You are not in control", 64, "Control")
                    Exit Sub
        End If
    End If
    If KeyCode = 38 Then
        Do While EnumChips(3) > 1
            If Log(EnumChips(3) - 1).Situation = "" Then Exit Do
            Call Picture1_KeyDown(37, Shift)
        Loop
        RefBoard = True
    End If
    If KeyCode = 37 Then
        If EnumChips(3) > 1 Then
            If Log(EnumChips(3) - 1).Situation <> "" Then
                Call GetLog(EnumChips(3) - 1)
            End If
        End If
        RefBoard = True
    End If
    If KeyCode = 39 Then
        If EnumChips(3) < 64 Then
            If Log(EnumChips(3) + 1).Situation <> "" Then
                Call GetLog(EnumChips(3) + 1)
            End If
        End If
        RefBoard = True
    End If
    If KeyCode = 40 Then
        Do While EnumChips(3) < 64
            If Log(EnumChips(3) + 1).Situation = "" Then Exit Do
            Call Picture1_KeyDown(39, Shift)
        Loop
        RefBoard = True
    End If

End Sub
Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Call Picture1_MouseMove(Button, Shift, X, Y)

End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim UnitX%
    Dim MoveNum%
   
    UnitX = Picture1.ScaleWidth / 60
    MoveNum = X / UnitX + 4
    If MoveNum = EnumChips(3) Then
        Picture1.MousePointer = 9
    Else
        Picture1.MousePointer = 0
    End If
    If Button <> 0 Then
        If Form2.Visible = True Then
            If _
                (Form2.mnuBlackPlayer.Caption <> Form1.Winsock1.Tag) And _
                (Form2.mnuWhitePlayer.Caption <> Form1.Winsock1.Tag) _
                    Then
                        Call MsgBox("You are not in control", 64, "Control")
                        Exit Sub
            End If
        End If
        If MoveNum >= 1 And MoveNum <= 64 Then
            If Log(MoveNum).Situation <> "" Then
                Call GetLog(MoveNum)
            Else
                Do While EnumChips(3) < 64
                    If Log(EnumChips(3) + 1).Situation = "" Then Exit Do
                    Call GetLog(EnumChips(3) + 1)
                Loop
            End If
            RefBoard = True
        End If
    End If

End Sub


