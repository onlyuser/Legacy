VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Evaluator"
   ClientHeight    =   3200
   ClientLeft      =   200
   ClientTop       =   3840
   ClientWidth     =   4680
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   3200
   ScaleWidth      =   4680
   Begin VB.ListBox List6 
      Height          =   465
      IntegralHeight  =   0   'False
      Left            =   2760
      TabIndex        =   7
      Top             =   2640
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.ListBox List5 
      Height          =   465
      IntegralHeight  =   0   'False
      Left            =   1440
      TabIndex        =   6
      Top             =   2640
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.ListBox List4 
      Height          =   465
      IntegralHeight  =   0   'False
      Left            =   120
      TabIndex        =   5
      Top             =   2640
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.ListBox List3 
      Height          =   465
      IntegralHeight  =   0   'False
      Left            =   2760
      TabIndex        =   4
      Top             =   2040
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.ListBox List2 
      Height          =   465
      IntegralHeight  =   0   'False
      Left            =   1440
      TabIndex        =   3
      Top             =   2040
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.ListBox List1 
      Height          =   465
      IntegralHeight  =   0   'False
      Left            =   120
      TabIndex        =   2
      Top             =   2040
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   10
         Charset         =   136
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   1200
      Width           =   1215
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   10
         Charset         =   136
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   280
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Cancel          =   -1  'True
      Caption         =   "Command1"
      Height          =   495
      Left            =   120
      TabIndex        =   8
      TabStop         =   0   'False
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Combo1_Change()

    Call AutoComplete(Combo1)
    
End Sub
Private Sub Combo1_KeyDown(KeyCode As Integer, Shift As Integer)

    Dim Buffer1 As String
    Dim Buffer2 As String
    
    If KeyCode = 13 Then
        Call Combo1.AddItem(Combo1.Text)
        If Combo1.ListCount > 5 Then _
            Call Combo1.RemoveItem(0)
        Combo1.ListIndex = Combo1.ListCount - 1
        Buffer1 = FixExpSyntax(Combo1.Text)
        Text1.Text = vbCrLf & Text1.Text
        If Not IsError(Buffer1) Then
            Buffer2 = Evaluate(Buffer1, List1, List2, List3, List4, List5, False)
            Call LogText(Text1, "CPU", FixExpFormat(Buffer1) & " => " & Buffer2)
        Else
            Call LogText(Text1, "CPU", Combo1.Text & " => " & Buffer1)
        End If
        Call LogText(Text1, "USER", Chr(34) & Combo1.Text & Chr(34))
        Combo1.Text = ""
    End If
    
End Sub
Private Sub Command1_Click()

    Call Unload(Me)
    
End Sub
Private Sub Form_Load()

    Call Command1.Move(-Command1.Width, -Command1.Height)
    
End Sub
Private Sub Form_Resize()

    On Error Resume Next
    Call Combo1.Move(0, 0, Me.ScaleWidth)
    Call Text1.Move(0, Combo1.Height, Combo1.Width, Me.ScaleHeight - Combo1.Height)
    
End Sub
Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)

    If (Shift And vbCtrlMask) <> 0 And KeyCode = Asc("C") Then _
        Call Clipboard.SetText(Mid(Text1.Text, Text1.SelStart + 1, Text1.SelLength))
        
End Sub
