VERSION 5.00
Begin VB.Form Form2 
   Caption         =   "Form2"
   ClientHeight    =   2910
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   Icon            =   "Form2.frx":0000
   LinkTopic       =   "Form2"
   ScaleHeight     =   2910
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox Combo1 
      Height          =   315
      Left            =   120
      TabIndex        =   2
      Text            =   "Combo1"
      Top             =   720
      Width           =   1215
   End
   Begin VB.ListBox List1 
      Height          =   300
      IntegralHeight  =   0   'False
      ItemData        =   "Form2.frx":0442
      Left            =   1440
      List            =   "Form2.frx":0449
      MultiSelect     =   2  'Extended
      Sorted          =   -1  'True
      TabIndex        =   1
      Top             =   120
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Text            =   "Form2.frx":0454
      Top             =   120
      Width           =   1215
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuClear 
         Caption         =   "&Clear"
      End
      Begin VB.Menu mnuSave 
         Caption         =   "&Save"
      End
   End
   Begin VB.Menu mnuSelected 
      Caption         =   "&Selected"
      Begin VB.Menu mnuMessage 
         Caption         =   "&Message"
      End
      Begin VB.Menu mnuKick 
         Caption         =   "&Kick"
      End
   End
   Begin VB.Menu mnuPlayer 
      Caption         =   "&Player"
      Begin VB.Menu mnuNick 
         Caption         =   "&Nick"
      End
   End
   Begin VB.Menu mnuControl 
      Caption         =   "&Control"
      Begin VB.Menu mnuBlack 
         Caption         =   "&Black"
         Begin VB.Menu mnuBlackPlayer 
            Caption         =   ""
         End
      End
      Begin VB.Menu mnuWhite 
         Caption         =   "&White"
         Begin VB.Menu mnuWhitePlayer 
            Caption         =   ""
         End
      End
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Combo1_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = 13 Then
        
        Combo1.Text = CleanText(Combo1.Text, ":", "")
        If Combo1.Text = "" Then Exit Sub
        
        Call SendToAll(Form1.Winsock1, ">SAY:(" & Form1.Winsock1.Tag & ":" & Combo1.Text & ")")
        
        Call AppendText(Text1, GetIRCMsg(Form1.Winsock1.Tag, Combo1.Text), 10000)
        
        Call ComboAdd(Combo1, True)
        If Combo1.ListCount > 8 Then Combo1.RemoveItem 0
        
    End If

End Sub
Private Sub Form_Load()

    Form2.Caption = "Chat"
    mnuBlackPlayer.Caption = ""
    mnuWhitePlayer.Caption = ""
    Text1.Text = "* Joined at " & Date & " - " & Time
    Combo1.Clear
    Call AddContact(Form1.Winsock1.Tag & ":" & Form1.Winsock1.LocalIP & ":" & Form1.Winsock1.LocalPort)
    Call ListContact(List1)

End Sub
Private Sub Form_Resize()

    On Error Resume Next

    Text1.Move 0, 0, Form2.ScaleWidth - List1.Width, Form2.ScaleHeight - Combo1.Height
    List1.Move Form2.ScaleWidth - List1.Width, 0, List1.Width, Form2.ScaleHeight - Combo1.Height
    Combo1.Move 0, Form2.ScaleHeight - Combo1.Height, Form2.ScaleWidth
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    Dim BufferA%
    
    Call AppendText(Text1, "* Parted at " & Date & " - " & Time, 10000)
    
    Call SendToAll(Form1.Winsock1, ">DISCONNECT:(" & Form1.Winsock1.Tag & ")")
    Call ClearContact
    
    If Form2.Visible = True Then
        BufferA = MsgBox("Save log for chat?", 64 + 4, "Log")
        If BufferA = 6 Then Call mnuSave_Click
    End If

End Sub
Private Sub List1_DblClick()

    Call mnuMessage_Click

End Sub

Private Sub List1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button = 2 Then Call PopupMenu(mnuSelected)

End Sub
Private Sub List1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Combo1.SetFocus

End Sub

Private Sub mnuWhitePlayer_Click()

    If mnuWhitePlayer.Caption = "" Then
        mnuWhitePlayer.Caption = Form1.Winsock1.Tag
        If mnuBlackPlayer.Caption = Form1.Winsock1.Tag Then
            mnuBlackPlayer.Caption = ""
        End If
    Else
        If mnuWhitePlayer.Caption = Form1.Winsock1.Tag Then
            mnuWhitePlayer.Caption = ""
        Else
            Call MsgBox("Color already in use!", 64, "Control")
        End If
    End If
    Call SendToAll(Form1.Winsock1, ">CONTROL:(" & mnuBlackPlayer.Caption & ":" & mnuWhitePlayer.Caption & ")")
    
End Sub
Private Sub mnuClear_Click()

    Text1.Text = ""

End Sub

Private Sub mnuKick_Click()

    Dim A%
    Dim BufferA$
    
    If _
        (mnuBlackPlayer.Caption = Form1.Winsock1.Tag) Or _
        (mnuWhitePlayer.Caption = Form1.Winsock1.Tag) _
            Then
                BufferA = InputBox("Kick selected players", "Kick")
                If Trim(BufferA) <> "" Then
                    For A = 0 To List1.ListCount - 1
                        If List1.Selected(A) = True Then
                            Call UseContact(Form1.Winsock1, List1.List(A))
                            Form1.Winsock1.SendData ">KICK:(" & Form1.Winsock1.Tag & ":" & BufferA & ")"
                        End If
                    Next A
                End If
    Else
        Call MsgBox("You are not in control", 64, "Control")
    End If
    
End Sub
Private Sub mnuMessage_Click()

    Dim A%
    Dim BufferA$
    
    BufferA = InputBox("Message selected players", "Message")
    If Trim(BufferA) <> "" Then
        For A = 0 To List1.ListCount - 1
            If List1.Selected(A) = True Then
                Call UseContact(Form1.Winsock1, List1.List(A))
                Form1.Winsock1.SendData ">MESSAGE:(" & Form1.Winsock1.Tag & ":" & BufferA & ")"
            End If
        Next A
    End If

End Sub
Private Sub mnuNick_Click()
    
    Dim BufferA$
    
    BufferA = InputBox("Enter new nick for " & Form1.Winsock1.Tag & ":", "Nick", Form1.Winsock1.Tag)
    If Trim(BufferA) <> "" Then
        BufferA = UCase(Left(CleanText(Trim(BufferA), ":", " "), 12))
        If GetContact(BufferA) = 0 Then
            Call SendToAll(Form1.Winsock1, ">RENAME:(" & Form1.Winsock1.Tag & ":" & BufferA & ")")
            Player(GetContact(Form1.Winsock1.Tag)).Name = BufferA
            Call ListContact(List1)
            If mnuBlackPlayer.Caption = Form1.Winsock1.Tag Then mnuBlackPlayer.Caption = BufferA
            If mnuWhitePlayer.Caption = Form1.Winsock1.Tag Then mnuWhitePlayer.Caption = BufferA
            Form1.Winsock1.Tag = BufferA
        Else
            Call MsgBox("Nick " & Trim(BufferA) & " already in use!", 64, "Rename")
        End If
    End If
    
End Sub
Private Sub mnuSave_Click()

    Call Access("Save", "Prompt", Text1.Text, "Text Files (*.Txt)|*.txt", Form1.CommonDialog1)

End Sub
Private Sub mnuBlackPlayer_Click()
    
    If mnuBlackPlayer.Caption = "" Then
        mnuBlackPlayer.Caption = Form1.Winsock1.Tag
        If mnuWhitePlayer.Caption = Form1.Winsock1.Tag Then
            mnuWhitePlayer.Caption = ""
        End If
    Else
        If mnuBlackPlayer.Caption = Form1.Winsock1.Tag Then
            mnuBlackPlayer.Caption = ""
        Else
            Call MsgBox("Color already in use!", 64, "Control")
        End If
    End If
    Call SendToAll(Form1.Winsock1, ">CONTROL:(" & mnuBlackPlayer.Caption & ":" & mnuWhitePlayer.Caption & ")")
    
End Sub
Private Sub Text1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim BufferA$

    BufferA = Mid(Text1.Text, Text1.SelStart + 1, Text1.SelLength)
    Clipboard.SetText BufferA
    Combo1.SetFocus

End Sub
