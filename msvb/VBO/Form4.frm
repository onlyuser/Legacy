VERSION 5.00
Begin VB.Form Form4 
   Caption         =   "Form4"
   ClientHeight    =   2910
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   Icon            =   "Form4.frx":0000
   LinkTopic       =   "Form4"
   ScaleHeight     =   2910
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox List1 
      Height          =   300
      IntegralHeight  =   0   'False
      ItemData        =   "Form4.frx":0442
      Left            =   120
      List            =   "Form4.frx":0449
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
      Begin VB.Menu mnuRecord 
         Caption         =   "&Record"
      End
   End
End
Attribute VB_Name = "Form4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Form_Load()
    
    Form4.Caption = "Scores"
    Call mnuRefresh_Click

End Sub
Private Sub Form_Resize()

    On Error Resume Next

    List1.Move 0, 0, Form4.ScaleWidth, Form4.ScaleHeight
    
End Sub
Private Sub List1_DblClick()

    Call mnuRecord_Click

End Sub
Private Sub List1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button = 2 Then Call PopupMenu(mnuSelected)

End Sub

Private Sub mnuRecord_Click()

    Dim BufferA$
    Dim BufferB$
    
    On Error Resume Next
    
    BufferA = List1.List(List1.ListIndex)
    BufferB = Form1.Inet1.OpenURL(URL & RemPath & "SCORES/" & BufferA)
    Call _
        MsgBox( _
            "Name: " & BufferA & vbCrLf & _
             vbCrLf & _
            "Victories: " & Val(GetSeg(BufferB, ":", 1)) & vbCrLf & _
             vbCrLf & _
            "Defeats: " & Val(GetSeg(BufferB, ":", 2)) & vbCrLf & _
             vbCrLf & _
            "Ties: " & Val(GetSeg(BufferB, ":", 3)), _
            64, _
            "Record" _
        )

End Sub

Private Sub mnuRefresh_Click()

    Dim A%
    Dim BufferA$
    Dim BufferB$

    On Error Resume Next

    List1.Clear
    BufferA = Form1.Inet1.OpenURL(URL & RemPath & "SCORES/")
    BufferA = CleanText(BufferA, "", " ")
    For A = 1 To CntStr(BufferA, "<LI>")
        BufferB = GetBtw(BufferA, "<A HREF=", ">", A)
        If Left(BufferB, 1) <> "/" Then
            List1.AddItem BufferB
        End If
    Next A

End Sub
