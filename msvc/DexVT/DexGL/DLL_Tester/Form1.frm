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
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   120
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
Option Explicit
Private Sub Command1_Click()

    Call MsgBox(DexGL_sum(2, 3))
    Call MsgBox(DexGL_echo("test"))
    
End Sub
Private Sub Form_Paint()

    Call DexGL_clear
    Call DexGL_tri(vbRed, vbGreen, vbBlue, 0.5, 1, 0, 0, 1, 0)
    Call DexGL_paint
    
End Sub
Private Sub Form_Resize()

    Call DexGL_resize( _
        Form1.ScaleWidth / Screen.TwipsPerPixelX, _
        Form1.ScaleHeight / Screen.TwipsPerPixelY _
        )
    Call Form_Paint
    
End Sub
