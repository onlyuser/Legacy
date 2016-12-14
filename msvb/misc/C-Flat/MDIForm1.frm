VERSION 5.00
Begin VB.MDIForm MDIForm1 
   BackColor       =   &H8000000C&
   Caption         =   "MDIForm1"
   ClientHeight    =   3190
   ClientLeft      =   110
   ClientTop       =   570
   ClientWidth     =   4680
   Icon            =   "MDIForm1.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   WindowState     =   2  'Maximized
   Begin VB.PictureBox Picture1 
      Align           =   1  'Align Top
      BorderStyle     =   0  'None
      Height          =   735
      Left            =   0
      ScaleHeight     =   740
      ScaleWidth      =   4680
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   0
      Width           =   4680
      Begin VB.Frame Frame1 
         Height          =   735
         Left            =   1440
         TabIndex        =   1
         Top             =   0
         Width           =   2655
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   5
            Left            =   2160
            Picture         =   "MDIForm1.frx":014A
            Style           =   1  'Graphical
            TabIndex        =   8
            TabStop         =   0   'False
            ToolTipText     =   "Help"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   4
            Left            =   1680
            Picture         =   "MDIForm1.frx":0294
            Style           =   1  'Graphical
            TabIndex        =   6
            TabStop         =   0   'False
            ToolTipText     =   "Save"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   3
            Left            =   1320
            Picture         =   "MDIForm1.frx":03DE
            Style           =   1  'Graphical
            TabIndex        =   5
            TabStop         =   0   'False
            ToolTipText     =   "Open"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   2
            Left            =   840
            Picture         =   "MDIForm1.frx":0528
            Style           =   1  'Graphical
            TabIndex        =   2
            TabStop         =   0   'False
            ToolTipText     =   "Grapher"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   1
            Left            =   480
            Picture         =   "MDIForm1.frx":0672
            Style           =   1  'Graphical
            TabIndex        =   3
            TabStop         =   0   'False
            ToolTipText     =   "Evaluator"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   0
            Left            =   120
            Picture         =   "MDIForm1.frx":07BC
            Style           =   1  'Graphical
            TabIndex        =   4
            TabStop         =   0   'False
            ToolTipText     =   "Interpreter"
            Top             =   240
            Width           =   375
         End
      End
      Begin VB.CommandButton Command1 
         Cancel          =   -1  'True
         Caption         =   "Command1"
         Height          =   495
         Left            =   120
         TabIndex        =   7
         TabStop         =   0   'False
         Top             =   120
         Width           =   1215
      End
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuNew 
         Caption         =   "New"
         Begin VB.Menu mnuInterpreter 
            Caption         =   "Interpreter"
         End
         Begin VB.Menu mnuEvaluator 
            Caption         =   "Evaluator"
         End
         Begin VB.Menu mnuGrapher 
            Caption         =   "Grapher"
         End
      End
      Begin VB.Menu mnuExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "Edit"
   End
   Begin VB.Menu mnuView 
      Caption         =   "View"
   End
   Begin VB.Menu mnuWindow 
      Caption         =   "Window"
      Begin VB.Menu mnuCascade 
         Caption         =   "Cascade"
      End
      Begin VB.Menu mnuTileHorizontal 
         Caption         =   "Tile Horizontal"
      End
      Begin VB.Menu mnuTileVertical 
         Caption         =   "Tile Vertical"
      End
      Begin VB.Menu mnuArrangeIcons 
         Caption         =   "Arrange Icons"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuContents 
         Caption         =   "Contents"
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "About"
      End
   End
End
Attribute VB_Name = "MDIForm1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()

    Call mnuExit_Click
    
End Sub
Private Sub Command2_Click(Index As Integer)

    Select Case Command2(Index).ToolTipText
        Case "Interpreter"
            Call mnuInterpreter_Click
        Case "Evaluator"
            Call mnuEvaluator_Click
        Case "Grapher"
            Call mnuGrapher_Click
        Case "Open"
        Case "Save"
        Case "Help"
            Call mnuContents_Click
    End Select
    
End Sub
Private Sub Command3_Click(Index As Integer)

End Sub


Private Sub MDIForm_Load()

    MDIForm1.Caption = App.Title
    Call Command1.Move(-Command1.Width, -Command1.Height)
    
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)

    Call mnuExit_Click
    
End Sub
Private Sub mnuAbout_Click()

    Call ShowAbout
    
End Sub
Private Sub mnuArrangeIcons_Click()

    Call Me.Arrange(vbArrangeIcons)
    
End Sub
Private Sub mnuCascade_Click()

    Call Me.Arrange(vbCascade)
    
End Sub
Private Sub mnuContents_Click()

    Call ShowHelp
    
End Sub
Private Sub mnuEvaluator_Click()

    Dim FormObj As Form
    Set FormObj = New Form1
    FormObj.Show
    
End Sub
Private Sub mnuExit_Click()

    End
    
End Sub
Private Sub mnuGrapher_Click()

    Dim FormObj As Form
    Set FormObj = New Form3
    FormObj.Show
    
End Sub
Private Sub mnuInterpreter_Click()

    Dim FormObj As Form
    Set FormObj = New Form2
    FormObj.Show
    
End Sub
Private Sub mnuTileHorizontal_Click()

    Call Me.Arrange(vbTileHorizontal)
    
End Sub
Private Sub mnuTileVertical_Click()

    Call Me.Arrange(vbTileVertical)
    
End Sub
Private Sub Picture1_Resize()

    Call Frame1.Move(0, 0, Picture1.ScaleWidth, Picture1.ScaleHeight)
    
End Sub
