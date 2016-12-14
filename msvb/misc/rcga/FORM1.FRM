VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Left            =   120
      Top             =   720
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
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    
    Picture1.BackColor = vbBlack
    Picture1.AutoRedraw = True
    Picture1.DrawStyle = 0
    Timer1.Interval = 10
    Timer1.Enabled = True
    Call Form_Resize
    Call ResetEnvCtrls(Picture1)
    Call ResetUnits(Picture1)
    
End Sub

Private Sub Form_Resize()
    
    If Form1.WindowState <> 1 Then Picture1.Move 0, 0, Form1.ScaleWidth, Form1.ScaleHeight

End Sub

Private Sub Form_Unload(Cancel As Integer)

    End

End Sub

Private Sub Picture1_DblClick()

    Form2.Caption = "Optimization Status"
    Form2.Show

End Sub


Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)
    
    If KeyCode = 13 Then MsgStatus = Not MsgStatus
    If KeyCode = 17 Then Bounds = Not Bounds
    If KeyCode = 32 Then ProxyStatus = Not ProxyStatus
    
End Sub

Private Sub Timer1_Timer()
    
    Call TuneUnits
    Call UpdateUnits(Picture1)
    
    Form1.Caption = "RCGA; " & Periods & " - " & Tics & "; MsgStatus: " & MsgStatus
    
    Picture1.Cls
    Call DrawUnits(Picture1)
    
    Form2.Cls
    Form2.Print Status
    
End Sub


