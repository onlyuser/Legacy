VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Little Fishies"
   ClientHeight    =   3195
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   1
      Left            =   0
      Top             =   0
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
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuReset 
         Caption         =   "Reset"
         Shortcut        =   ^R
      End
      Begin VB.Menu mnuExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "About"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()

    If Form1.Visible = False Then
        Form1.Width = Screen.Width / 2
        Form1.Height = Screen.Height / 2
    End If
    'Call Init(100, 100, 6, 12)
    Call Init(100, 100, 6, 4)
    Picture1.AutoRedraw = True
    Picture1.BackColor = vbBlack
    Picture1.ForeColor = vbWhite
    Picture1.MousePointer = vbCrosshair
    
End Sub
Private Sub Form_Resize()

    Call Picture1.Move(0, 0, Form1.ScaleWidth, Form1.ScaleHeight)
    
End Sub
Private Sub mnuReset_Click()

    Call Form_Load
    
End Sub
Private Sub mnuExit_Click()

    End
    
End Sub
Private Sub mnuAbout_Click()

    Call ShowAbout
    
End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim OldDim As Vector
    
    OldDim.X = Picture1.ScaleWidth
    OldDim.Y = Picture1.ScaleHeight
    GoalPos.X = X
    GoalPos.Y = Y
    GoalPos = VectorMap(GoalPos, OldDim, WorldDim)
    
End Sub
Private Sub Timer1_Timer()

    Call Picture1.Cls
    Call Draw(Picture1, True, True)
    Call Update
    DoEvents
    
End Sub
