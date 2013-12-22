VERSION 5.00
Begin VB.Form Form3 
   Caption         =   "Form3"
   ClientHeight    =   2910
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   Icon            =   "Form3.frx":0000
   LinkTopic       =   "Form3"
   ScaleHeight     =   2910
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox List1 
      Height          =   300
      IntegralHeight  =   0   'False
      ItemData        =   "Form3.frx":0442
      Left            =   120
      List            =   "Form3.frx":0449
      Sorted          =   -1  'True
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuRefresh 
         Caption         =   "&Refresh"
      End
   End
   Begin VB.Menu mnuSelected 
      Caption         =   "&Selected"
      Begin VB.Menu mnuConnect 
         Caption         =   "&Connect"
      End
      Begin VB.Menu mnuMessage 
         Caption         =   "&Message"
      End
      Begin VB.Menu mnuBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuInquire 
         Caption         =   "&Inquire"
      End
   End
   Begin VB.Menu mnuInfo 
      Caption         =   "&Info"
      Begin VB.Menu mnuPost 
         Caption         =   "&Post"
      End
   End
End
Attribute VB_Name = "Form3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Form_Load()

    Form3.Caption = "Players"
    Call mnuRefresh_Click

End Sub
Private Sub Form_Resize()

    On Error Resume Next

    List1.Move 0, 0, Form3.ScaleWidth, Form3.ScaleHeight
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    Dim BufferA$

    On Error Resume Next
    
    If mnuPost.Checked = True Then Call mnuPost_Click
    
    BufferA = Dir(LocPath)
    Do Until BufferA = ""
        If BufferA <> CfgFile Then
            Call Kill(LocPath & BufferA)
        End If
        BufferA = Dir
    Loop
    
End Sub
Private Sub List1_DblClick()

    Call mnuConnect_Click

End Sub

Private Sub List1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button = 2 Then Call PopupMenu(mnuSelected)

End Sub
Private Sub mnuConnect_Click()
    
    Dim BufferA$
    Dim BufferB$
    
    On Error Resume Next
    
    If Form2.Visible = True Then
        If MsgBox("This will part the current game. Continue?", 64 + 4, "Part") = 7 Then
            Exit Sub
        Else
            Call Unload(Form2)
        End If
    End If
    BufferA = List1.List(List1.ListIndex)
    BufferB = Form1.Inet1.OpenURL(URL & RemPath & "PLAYERS/" & BufferA)
    Form1.Winsock1.RemoteHost = GetSeg(BufferB, ":", 1)
    Form1.Winsock1.RemotePort = Val(GetSeg(BufferB, ":", 2))
    Form1.Winsock1.SendData ">CONNECT:(" & Form1.Winsock1.Tag & ":" & Form1.Winsock1.LocalIP & ":" & Form1.Winsock1.LocalPort & ")"
    If Err <> 0 Then Call MsgBox("Cannot resolve host!", 16, "Error")

End Sub
Private Sub mnuInquire_Click()

    Dim BufferA$
    Dim BufferB$
    
    On Error Resume Next
    
    BufferA = List1.List(List1.ListIndex)
    BufferB = Form1.Inet1.OpenURL(URL & RemPath & "PLAYERS/" & BufferA)
    Form1.Winsock1.RemoteHost = GetSeg(BufferB, ":", 1)
    Form1.Winsock1.RemotePort = GetSeg(BufferB, ":", 2)
    Form1.Winsock1.SendData ">INQREQ:(" & Form1.Winsock1.Tag & ":" & Form1.Winsock1.LocalIP & ":" & Form1.Winsock1.LocalPort & ")"
    
End Sub
Private Sub mnuMessage_Click()

    Dim BufferA$
    Dim BufferB$
    Dim BufferC$
    
    On Error Resume Next
    
    BufferA = InputBox("Message player", "Message")
    If Trim(BufferA) <> "" Then
        BufferB = List1.List(List1.ListIndex)
        BufferC = Form1.Inet1.OpenURL(URL & RemPath & "PLAYERS/" & BufferB)
        Form1.Winsock1.RemoteHost = GetSeg(BufferC, ":", 1)
        Form1.Winsock1.RemotePort = GetSeg(BufferC, ":", 2)
        Form1.Winsock1.SendData ">MESSAGE:(" & Form1.Winsock1.Tag & ":" & BufferA & ")"
    End If

End Sub
Private Sub mnuPost_Click()

    Dim A%
    Dim BufferA$
    Dim BufferB$
    Dim BufferC$
    
    On Error Resume Next

    If mnuPost.Checked = False Then
        BufferA = Form1.Winsock1.LocalIP & ":" & Form1.Winsock1.LocalPort
        Call Access("Save", LocPath & Form1.Winsock1.Tag, BufferA, "", Form1.CommonDialog1)
        Call FTP("SEND " & LocPath & Form1.Winsock1.Tag & " " & RemPath & "PLAYERS/" & Form1.Winsock1.Tag)
    Else
        Call FTP("DELETE " & RemPath & "PLAYERS/" & Form1.Winsock1.Tag)
    End If
    Call mnuRefresh_Click
    
End Sub
Private Sub mnuRefresh_Click()

    Dim A%
    Dim BufferA$
    Dim BufferB$

    On Error Resume Next

    mnuPost.Checked = False
    List1.Clear
    BufferA = Form1.Inet1.OpenURL(URL & RemPath & "PLAYERS/")
    BufferA = CleanText(BufferA, "", " ")
    For A = 1 To CntStr(BufferA, "<LI>")
        BufferB = GetBtw(BufferA, "<A HREF=", ">", A)
        If Left(BufferB, 1) <> "/" Then
            List1.AddItem BufferB
            If BufferB = Form1.Winsock1.Tag Then mnuPost.Checked = True
        End If
    Next A

End Sub
