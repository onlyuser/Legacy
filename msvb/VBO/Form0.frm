VERSION 5.00
Begin VB.Form Form0 
   BorderStyle     =   0  'None
   Caption         =   "Form6"
   ClientHeight    =   3195
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4680
   LinkTopic       =   "Form5"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   2175
      Left            =   120
      Picture         =   "Form0.frx":0000
      ScaleHeight     =   2175
      ScaleWidth      =   3465
      TabIndex        =   0
      Top             =   120
      Width           =   3465
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   2400
      Width           =   1215
   End
End
Attribute VB_Name = "Form0"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()

    Const BufferA% = 60
    
    Picture1.AutoSize = True
    Picture1.Move BufferA, BufferA
    
    Label1.BackColor = vbWhite
    Label1.Alignment = 2
    Label1.AutoSize = True
    Label1.Caption = "Version " & App.Major & "." & App.Minor & "." & App.Revision '& " by Jerry Chen (Dextre)"
    Label1.Move Picture1.Left, Picture1.Top + Picture1.Height, Picture1.Width, Label1.Height
    
    Form0.BackColor = vbBlack
    Form0.Width = Picture1.Width + BufferA * 2
    Form0.Height = Picture1.Height + Label1.Height + BufferA * 2
    Form0.Move (Screen.Width - Form0.Width) / 2, (Screen.Height - Form0.Height) / 2

    Exit Sub 'causes overflow error 6
    Call WinPos(Form0.hwnd, 1)

End Sub
