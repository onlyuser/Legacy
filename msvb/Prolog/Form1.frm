VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command3 
      Caption         =   "Resolve"
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   2280
      Width           =   1215
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Infer"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   1800
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Load"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   1320
      Width           =   1215
   End
   Begin VB.TextBox Text2 
      BackColor       =   &H8000000F&
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   12
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
      TabIndex        =   1
      Top             =   720
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   12
         Charset         =   136
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
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
Option Explicit

Dim mShiftRun As Boolean
Dim mBuffer As String
Private Sub Form_Load()

    Form1.Caption = App.Title
    Form1.Width = Screen.Width / 2
    Form1.Height = Screen.Height / 2
    Call Command1_Click
    
End Sub
Private Sub Form_Resize()

    On Error Resume Next
    
    Call Command1.Move(0, 0, Form1.ScaleWidth / 2)
    Call Command2.Move(Command1.Width, 0, Command1.Width / 2)
    Call Command3.Move(Command2.Left + Command2.Width, 0, Command2.Width)
    Call Text1.Move(0, Command1.Height, Command1.Width, Form1.ScaleHeight - Command1.Height)
    Call Text2.Move(Text1.Width, Text1.Top, Text1.Width, Text1.Height)
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    End
    
End Sub
Private Sub Command1_Click()

    Call Init
    If Text1.Text <> "" Then _
        Call LoadScript(Text1.Text)
    Text2.Text = PrintScript
    
End Sub
Private Sub Command2_Click()

    If Text2.Text <> "" Then
        mnuFile.Enabled = False
        Command1.Enabled = False
        Command2.Enabled = False
        Command3.Enabled = False
        Call Infer
        Text2.Text = PrintScript
        mnuFile.Enabled = True
        Command1.Enabled = True
        Command2.Enabled = True
        Command3.Enabled = True
    End If
    
End Sub
Private Sub Command3_Click()

    Dim Buffer As String
    Dim Message As String
    
    If Text2.Text <> "" Then
        Buffer = InputBox("Enter expression to resolve:", "Resolve", mBuffer)
        If Buffer <> "" Then
            Message = _
                "Expression " & Chr(34) & SubVars(Buffer) & Chr(34) & " resolves to " & _
                    Resolve(Buffer) & vbCrLf & _
                vbCrLf & _
                CountText(mVarBinds, "|") & " binding(s) found:" & vbCrLf & _
                vbCrLf & _
                EditReplace(mVarBinds, "|", vbCrLf)
            Message = EditReplace(Message, "_", "")
            Call MsgBox(Message, vbInformation + vbOKOnly, "Resolve")
            Text2.Text = PrintScript
        End If
        mBuffer = Buffer
    End If
    
End Sub
Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)

    If _
        KeyCode = 13 And _
        Shift = 1 _
    Then _
        mShiftRun = True
        
End Sub
Private Sub Text1_KeyPress(KeyAscii As Integer)

    If mShiftRun Then
        Call Command1_Click
        KeyAscii = 0
        mShiftRun = False
    End If
    
End Sub
Private Sub mnuReset_Click()

    Text1.Text = ""
    Call Command1_Click
    
End Sub
Private Sub mnuExit_Click()

    Call Unload(Form1)
    
End Sub
Private Sub mnuAbout_Click()

    Call ShowAbout
    
End Sub
