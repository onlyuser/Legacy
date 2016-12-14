VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form Form2 
   Caption         =   "Interpreter"
   ClientHeight    =   3195
   ClientLeft      =   4065
   ClientTop       =   3300
   ClientWidth     =   4680
   Icon            =   "Form2.frx":0000
   LinkTopic       =   "Form2"
   MDIChild        =   -1  'True
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   Begin VB.PictureBox Picture2 
      BorderStyle     =   0  'None
      Height          =   1815
      Left            =   1440
      ScaleHeight     =   1815
      ScaleWidth      =   2415
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   120
      Width           =   2415
      Begin VB.Frame Frame1 
         Height          =   1695
         Left            =   0
         TabIndex        =   6
         Top             =   0
         Width           =   2295
         Begin VB.ComboBox Combo1 
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   345
            Left            =   120
            Style           =   2  'Dropdown List
            TabIndex        =   7
            TabStop         =   0   'False
            Top             =   720
            Width           =   1215
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   4
            Left            =   1800
            Picture         =   "Form2.frx":014A
            Style           =   1  'Graphical
            TabIndex        =   12
            TabStop         =   0   'False
            ToolTipText     =   "Format"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   3
            Left            =   1320
            Picture         =   "Form2.frx":0294
            Style           =   1  'Graphical
            TabIndex        =   11
            TabStop         =   0   'False
            ToolTipText     =   "Clear"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   2
            Left            =   840
            Picture         =   "Form2.frx":03DE
            Style           =   1  'Graphical
            TabIndex        =   8
            TabStop         =   0   'False
            ToolTipText     =   "End"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   1
            Left            =   480
            Picture         =   "Form2.frx":0528
            Style           =   1  'Graphical
            TabIndex        =   9
            TabStop         =   0   'False
            ToolTipText     =   "Break"
            Top             =   240
            Width           =   375
         End
         Begin VB.CommandButton Command2 
            Height          =   375
            Index           =   0
            Left            =   120
            Picture         =   "Form2.frx":0672
            Style           =   1  'Graphical
            TabIndex        =   10
            TabStop         =   0   'False
            ToolTipText     =   "Start"
            Top             =   240
            Width           =   375
         End
         Begin VB.Label Label1 
            Alignment       =   1  'Right Justify
            AutoSize        =   -1  'True
            Caption         =   "Ln 0, Col 0"
            BeginProperty Font 
               Name            =   "Fixedsys"
               Size            =   9
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   225
            Left            =   120
            TabIndex        =   13
            Top             =   1200
            Width           =   1320
         End
      End
   End
   Begin VB.TextBox Text2 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
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
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   2520
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
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
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   1920
      Width           =   1215
   End
   Begin RichTextLib.RichTextBox RichTextBox1 
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   1320
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   873
      _Version        =   393217
      Enabled         =   -1  'True
      ScrollBars      =   3
      DisableNoScroll =   -1  'True
      RightMargin     =   10000
      AutoVerbMenu    =   -1  'True
      TextRTF         =   $"Form2.frx":07BC
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   495
      Left            =   120
      ScaleHeight     =   495
      ScaleWidth      =   1215
      TabIndex        =   3
      TabStop         =   0   'False
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Cancel          =   -1  'True
      Caption         =   "Command1"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim VBarPos As Integer
Dim HBarPos As Integer
Dim DragBoth As Boolean
Private Sub Command1_Click()

    Call Unload(Me)
    
End Sub
Private Sub Command2_Click(Index As Integer)

    Dim Result As String
    Dim FormObj As Form
    
    Select Case Command2(Index).ToolTipText
        Case "Start"
            PauseFlag = False
            StopFlag = False
            Command2(Index).Enabled = False
            Set FormObj = New Form1
            Call Load(FormObj)
            FormObj.WindowState = 1
            Result = _
                Execute( _
                    RichTextBox1.Text, _
                    FormObj.List1, _
                    FormObj.List2, _
                    FormObj.List3, _
                    FormObj.List4, _
                    FormObj.List5, _
                    FormObj.List6 _
                )
            Call Unload(FormObj)
            If Not IsError(Result) Then
                Text1.Text = Result
            Else
                Text2.Text = _
                    ParsedScr & _
                    ParsedExp & vbCrLf & _
                    Result
            End If
            Command2(Index).Enabled = True
        Case "Break"
            PauseFlag = True
        Case "End"
            StopFlag = True
        Case "Clear"
            Text1.Text = ""
            Text2.Text = ""
        Case "Format"
            Result = FixScrSyntax(RichTextBox1.Text)
            If Not IsError(Result) Then
                RichTextBox1.Text = Result
            Else
                Text2.Text = Result
                RichTextBox1.Text = _
                    ParsedScr & _
                    ParsedExp
                RichTextBox1.SelStart = Len(ParsedScr)
                RichTextBox1.SelLength = Len(ParsedExp)
                RichTextBox1.SelColor = vbRed
            End If
    End Select
    
End Sub
Private Sub Form_Load()

    Call Command1.Move(-Command1.Width, -Command1.Height)
    
End Sub
Private Sub Form_Resize()

    Const BarWidth = 60
    
    On Error Resume Next
    Call _
        Picture1.Move( _
            0, _
            0, _
            Me.ScaleWidth, _
            Me.ScaleHeight _
        )
    If VBarPos <= Me.ScaleWidth * 0.25 Then _
        VBarPos = Me.ScaleWidth * 0.25
    If VBarPos >= Me.ScaleWidth * 0.75 Then _
        VBarPos = Me.ScaleWidth * 0.75
    If _
        HBarPos <= _
            Picture2.Height + (Me.ScaleHeight - Picture2.Height) * 0.25 _
    Then _
        HBarPos = _
            Picture2.Height + (Me.ScaleHeight - Picture2.Height) * 0.25
    If _
        HBarPos >= _
            Me.ScaleHeight - (Me.ScaleHeight - Picture2.Height) * 0.25 _
    Then _
        HBarPos = _
            Me.ScaleHeight - (Me.ScaleHeight - Picture2.Height) * 0.25
    Call _
        Picture2.Move( _
            0, _
            0, _
            Me.ScaleWidth, _
            BarWidth * 4 + Command2(0).Height + BarWidth * 2 _
        )
    Call Command2(3).Move(BarWidth * 2, BarWidth * 4)
    Call _
        Text3.Move( _
            Command2(3).Left + Command2(3).Width + BarWidth, _
            Command2(3).Top, _
            VBarPos - (Command2(3).Left + Command2(3).Width + BarWidth) - BarWidth * 2 _
        )
    Call Command2(0).Move(VBarPos + BarWidth * 0.5 + BarWidth * 2, Command2(3).Top)
    Call Command2(1).Move(Command2(0).Left + Command2(0).Width, Command2(0).Top)
    Call Command2(2).Move(Command2(1).Left + Command2(1).Width, Command2(1).Top)
    Call _
        Combo1.Move( _
            Command2(2).Left + Command2(2).Width + BarWidth, _
            Command2(2).Top _
        )
    Call Command2(4).Move(Combo1.Left + Combo1.Width + BarWidth, Combo1.Top)
    Call _
        Label1.Move( _
            Command2(4).Left + Command2(4).Width + BarWidth, _
            Command2(4).Top, _
            Me.ScaleWidth - (Command2(4).Left + Command2(4).Width + BarWidth) - BarWidth * 2 _
        )
    Call _
        Text1.Move( _
            0, _
            Picture2.Height, _
            VBarPos - BarWidth * 0.5, _
            HBarPos - BarWidth * 0.5 - Picture2.Height _
        )
    Call _
        Text2.Move( _
            Text1.Left, _
            Text1.Top + Text1.Height + BarWidth, _
            Text1.Width, _
            Me.ScaleHeight - (Text1.Top + Text1.Height + BarWidth) _
        )
    Call _
        RichTextBox1.Move( _
            Text1.Left + Text1.Width + BarWidth, _
            Text1.Top, _
            Me.ScaleWidth - (Text1.Left + Text1.Width + BarWidth), _
            Me.ScaleHeight - Text1.Top _
        )
        
End Sub

Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If _
        DragBoth Or _
        Sqr((X - VBarPos) ^ 2 + (Y - HBarPos) ^ 2) < 120 _
    Then
        Picture1.MousePointer = vbSizePointer
        If Button <> 0 Then
            DragBoth = True
            VBarPos = X
            HBarPos = Y
        End If
    Else
        If _
            X > VBarPos Or _
            Abs(X - VBarPos) < Abs(Y - HBarPos) _
        Then
            Picture1.MousePointer = vbSizeWE
            If Button <> 0 Then _
                VBarPos = X
        Else
            Picture1.MousePointer = vbSizeNS
            If Button <> 0 Then _
                HBarPos = Y
        End If
    End If
    If Button <> 0 Then
        Call Form_Resize
    Else
        DragBoth = False
    End If
    
End Sub
Private Sub Picture2_Resize()

    Call Frame1.Move(0, 0, Picture2.ScaleWidth, Picture2.ScaleHeight)
    
End Sub
Private Sub RichTextBox1_SelChange()

    Dim Row As Integer
    Dim Column As Integer
    
    Row = CountText(Mid(RichTextBox1.Text, 1, RichTextBox1.SelStart), vbCrLf) + 1
    Column = RichTextBox1.SelStart - FindText(RichTextBox1.Text, vbCrLf, Row - 1)
    Label1.Caption = "Ln " & Row & ", Col " & Column
    
End Sub
