VERSION 5.00
Begin VB.Form Form6 
   Caption         =   "Form6"
   ClientHeight    =   3195
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   Icon            =   "Form6.frx":0000
   LinkTopic       =   "Form7"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Text            =   "Form6.frx":0442
      Top             =   120
      Width           =   1215
   End
   Begin VB.Menu mnuView 
      Caption         =   "View"
      Begin VB.Menu mnuClear 
         Caption         =   "Clear"
      End
      Begin VB.Menu mnuSave 
         Caption         =   "Save"
      End
   End
End
Attribute VB_Name = "Form6"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()

    Text1.Text = ""

End Sub

Private Sub Form_Resize()

    Text1.Move 0, 0, Form6.ScaleWidth, Form6.ScaleHeight

End Sub

Private Sub Form_Unload(Cancel As Integer)

    Form1.mnuSearchReport.Checked = False

End Sub


Private Sub mnuClear_Click()

    Text1.Text = ""

End Sub


Private Sub mnuSave_Click()

    Call Access("Save", "Prompt", Text1.Text, "Text Files (*.Txt)|*.txt", Form1.CommonDialog1)

End Sub

Private Sub Text1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim BufferA$
    Dim BufferB%
    
    On Error Resume Next
        
    BufferA = GetPart(Text1.Text, Text1.SelStart, Chr(10), Chr(13))
    BufferB = LocStr(Text1.Text, BufferA, 1) - 1
    If BufferA <> "" Then
        Text1.SelStart = BufferB
        Text1.SelLength = Len(BufferA)
    End If

End Sub


