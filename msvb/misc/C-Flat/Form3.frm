VERSION 5.00
Begin VB.Form Form3 
   Caption         =   "Grapher"
   ClientHeight    =   3600
   ClientLeft      =   3930
   ClientTop       =   4515
   ClientWidth     =   4680
   Icon            =   "Form3.frx":0000
   LinkTopic       =   "Form3"
   MDIChild        =   -1  'True
   ScaleHeight     =   3600
   ScaleWidth      =   4680
   Begin VB.PictureBox Picture3 
      BorderStyle     =   0  'None
      Height          =   3135
      Left            =   1440
      ScaleHeight     =   3135
      ScaleWidth      =   2175
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   120
      Width           =   2175
      Begin VB.Frame Frame1 
         Caption         =   "Parameters"
         Height          =   3015
         Left            =   0
         TabIndex        =   6
         Top             =   0
         Width           =   2055
         Begin VB.CommandButton Command2 
            Caption         =   "Reset"
            Height          =   375
            Left            =   120
            TabIndex        =   22
            Top             =   2520
            Width           =   1815
         End
         Begin VB.TextBox Text1 
            Height          =   285
            Index           =   7
            Left            =   720
            TabIndex        =   21
            Top             =   2160
            Width           =   615
         End
         Begin VB.TextBox Text1 
            Height          =   285
            Index           =   6
            Left            =   1320
            TabIndex        =   20
            Top             =   1800
            Width           =   615
         End
         Begin VB.TextBox Text1 
            Height          =   285
            Index           =   5
            Left            =   720
            TabIndex        =   19
            Top             =   1800
            Width           =   615
         End
         Begin VB.TextBox Text1 
            Height          =   285
            Index           =   4
            Left            =   1320
            TabIndex        =   18
            Top             =   1440
            Width           =   615
         End
         Begin VB.TextBox Text1 
            Height          =   285
            Index           =   3
            Left            =   720
            TabIndex        =   17
            Top             =   1440
            Width           =   615
         End
         Begin VB.TextBox Text1 
            Height          =   285
            Index           =   2
            Left            =   720
            TabIndex        =   16
            Top             =   1080
            Width           =   615
         End
         Begin VB.TextBox Text1 
            Height          =   285
            Index           =   1
            Left            =   1320
            TabIndex        =   15
            Top             =   720
            Width           =   615
         End
         Begin VB.TextBox Text1 
            Height          =   285
            Index           =   0
            Left            =   720
            TabIndex        =   8
            Top             =   720
            Width           =   615
         End
         Begin VB.ComboBox Combo2 
            Height          =   315
            Left            =   720
            Style           =   2  'Dropdown List
            TabIndex        =   7
            Top             =   360
            Width           =   1215
         End
         Begin VB.Label Label6 
            AutoSize        =   -1  'True
            Caption         =   "Unit"
            Height          =   195
            Left            =   120
            TabIndex        =   14
            Top             =   2160
            Width           =   285
         End
         Begin VB.Label Label5 
            AutoSize        =   -1  'True
            Caption         =   "Y-Bnd"
            Height          =   195
            Left            =   120
            TabIndex        =   13
            Top             =   1800
            Width           =   435
         End
         Begin VB.Label Label4 
            AutoSize        =   -1  'True
            Caption         =   "X-Bnd"
            Height          =   195
            Left            =   120
            TabIndex        =   12
            Top             =   1440
            Width           =   435
         End
         Begin VB.Label Label3 
            AutoSize        =   -1  'True
            Caption         =   "G-Res"
            Height          =   195
            Left            =   120
            TabIndex        =   11
            Top             =   1080
            Width           =   450
         End
         Begin VB.Label Label2 
            AutoSize        =   -1  'True
            Caption         =   "G-Bnd"
            Height          =   195
            Left            =   120
            TabIndex        =   10
            Top             =   720
            Width           =   450
         End
         Begin VB.Label Label1 
            AutoSize        =   -1  'True
            Caption         =   "Mode"
            Height          =   195
            Left            =   120
            TabIndex        =   9
            Top             =   360
            Width           =   405
         End
      End
   End
   Begin VB.PictureBox Picture2 
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   2280
      Width           =   1215
      Begin VB.Label Label7 
         AutoSize        =   -1  'True
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   120
         TabIndex        =   23
         Top             =   120
         Width           =   75
      End
   End
   Begin VB.ListBox List1 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      IntegralHeight  =   0   'False
      Left            =   120
      MultiSelect     =   2  'Extended
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   1800
      Width           =   1215
   End
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
      TabIndex        =   1
      Top             =   1320
      Width           =   1215
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
Attribute VB_Name = "Form3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Const MAX_WINDOW_DIM = 10000
Const MIN_WINDOW_DIM = 1
Const MAX_UNIT = 10000
Const MIN_UNIT = 1
Const MAX_LINES = 100
Const MIN_LINES = 20

Dim VBarPos As Integer
Dim HBarPos As Integer
Dim DragBoth As Boolean
Dim DragX As Integer
Dim DragY As Integer
Dim TempMinX As Double
Dim TempMaxX As Double
Dim TempMinY As Double
Dim TempMaxY As Double
Dim LinesDrawn As Integer
Private Sub Combo1_Change()

    Call AutoComplete(Combo1)
    
End Sub
Private Sub Combo1_KeyDown(KeyCode As Integer, Shift As Integer)

    Dim Result As String
    
    If KeyCode = 13 Then
        Call Combo1.AddItem(Combo1.Text)
        If Combo1.ListCount > 5 Then _
            Call Combo1.RemoveItem(0)
        Combo1.ListIndex = Combo1.ListCount - 1
        Result = FixExpSyntax(Combo1.Text)
        If Not IsError(Result) Then
            Call List1.AddItem(FixExpFormat(Result), 0)
            Combo1.Text = ""
        Else
            Call MsgBox(Result, vbCritical + vbOKOnly, App.Title)
            Combo1.SelStart = 0
            Combo1.SelLength = Len(Combo1.Text)
        End If
    End If
    
End Sub
Private Sub Combo2_Click()

    Const PI = 3.14159265358979
    
    Select Case Combo2.ListIndex
        Case 0
            Combo1.Text = "y=x"
            Text1(0).Text = CStr(-10)
            Text1(1).Text = CStr(10)
            Text1(2).Text = CStr(0.1)
        Case 1
            Combo1.Text = "r=a"
            Text1(0).Text = CStr(0)
            Text1(1).Text = CStr(PI * 2)
            Text1(2).Text = CStr(PI * 2 / 360)
    End Select
    Text1(3).Text = CStr(-10)
    Text1(4).Text = CStr(10)
    Text1(5).Text = CStr(-10)
    Text1(6).Text = CStr(10)
    Text1(7).Text = CStr(1)
    Call Form_Resize
    
End Sub
Private Sub Command1_Click()

    Call Unload(Me)
    
End Sub

Private Sub Command2_Click()

    Call Combo2_Click
    
End Sub
Private Sub Form_Load()

    Call Command1.Move(-Command1.Width, -Command1.Height)
    Picture3.Height = Frame1.Height
    Call Combo2.AddItem("Y = F(X)")
    Call Combo2.AddItem("R = F(A)")
    Combo2.ListIndex = 0
    Label7.BackStyle = 0
    
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
            Combo1.Height + (Me.ScaleHeight - Combo1.Height) * 0.25 _
    Then _
        HBarPos = _
            Combo1.Height + (Me.ScaleHeight - Combo1.Height) * 0.25
    If _
        HBarPos >= _
            Me.ScaleHeight - (Me.ScaleHeight - Combo1.Height) * 0.25 _
    Then _
        HBarPos = _
            Me.ScaleHeight - (Me.ScaleHeight - Combo1.Height) * 0.25
    Call _
        Combo1.Move( _
            0, _
            0, _
            VBarPos - BarWidth * 0.5 _
        )
    Call _
        List1.Move( _
            Combo1.Left, _
            Combo1.Height, _
            Combo1.Width, _
            HBarPos - Combo1.Height - BarWidth * 0.5 _
        )
    Call _
        Picture3.Move( _
            Combo1.Left, _
            HBarPos + BarWidth * 0.5, _
            Combo1.Width, _
            Me.ScaleHeight - (HBarPos + BarWidth * 0.5) _
        )
    Call _
        Picture2.Move( _
            VBarPos + BarWidth * 0.5, _
            0, _
            Me.ScaleWidth - (VBarPos + BarWidth * 0.5), _
            Me.ScaleHeight _
        )
    If LinesDrawn > MAX_LINES Then _
        Text1(7).Text = CStr(CDbl(Text1(7).Text) * 2)
    If LinesDrawn < MIN_LINES Then _
        Text1(7).Text = CStr(CDbl(Text1(7).Text) * 0.5)
    If CDbl(Text1(7).Text) > MAX_UNIT Then _
        Text1(7).Text = CStr(MAX_UNIT)
    If CDbl(Text1(7).Text) < MIN_UNIT Then _
        Text1(7).Text = CStr(MIN_UNIT)
    Call Picture2.Cls
    LinesDrawn = _
        DrawGrid( _
            Picture2, _
            Text1(3).Text, Text1(4).Text, _
            Text1(5).Text, Text1(6).Text, _
            Text1(7).Text, _
            vbButtonFace, vbHighlight _
        )
        
End Sub
Private Sub Label7_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Call _
        Picture2_MouseDown( _
            Button, _
            Shift, _
            Label7.Left + X, _
            Label7.Top + Y _
        )
        
End Sub
Private Sub Label7_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Call _
        Picture2_MouseMove( _
            Button, _
            Shift, _
            Label7.Left + X, _
            Label7.Top + Y _
        )
        
End Sub
Private Sub Label7_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Call _
        Picture2_MouseUp( _
            Button, _
            Shift, _
            Label7.Left + X, _
            Label7.Top + Y _
        )
        
End Sub
Private Sub List1_DblClick()

    Form4.Tag = "Graph"
    Call List1_MouseDown(2, 0, 0, 0)
    
End Sub
Private Sub List1_KeyDown(KeyCode As Integer, Shift As Integer)

    Select Case KeyCode
        Case 13
            Form4.Tag = "Edit"
            Call List1_MouseDown(2, 0, 0, 0)
        Case 46
            Form4.Tag = "Remove"
            Call List1_MouseDown(2, 0, 0, 0)
    End Select
    
End Sub
Private Sub List1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim i As Integer
    Dim FormObj As Form
    Dim Polar As Boolean
    
    If Button = 2 Then
        If Form4.Tag = "" Then
            Form4.mnuGrapherOption(0).Enabled = False
            Form4.mnuGrapherOption(1).Enabled = False
            Form4.mnuGrapherOption(2).Enabled = False
            If List1.ListCount <> 0 Then
                If List1.Selected(List1.ListIndex) Then
                    Form4.mnuGrapherOption(0).Enabled = True
                    Form4.mnuGrapherOption(1).Enabled = True
                    Form4.mnuGrapherOption(2).Enabled = True
                End If
            End If
            Call _
                PopupMenu( _
                    Form4.mnuGrapher, _
                    , _
                    X, _
                    Y + List1.Top, _
                    Form4.mnuGrapherOption(0) _
                )
        End If
        Select Case Form4.Tag
            Case "Graph"
                Set FormObj = New Form1
                Call Load(FormObj)
                FormObj.WindowState = 1
                Call Form_Resize
                For i = 0 To List1.ListCount - 1
                    If List1.Selected(i) Then
                        If Combo2.ListIndex = 0 Then
                            Polar = False
                        Else
                            Polar = True
                        End If
                        Call _
                            Graph( _
                                Picture2, _
                                EditDespace(List1.List(i)), _
                                FormObj.List1, _
                                FormObj.List2, _
                                FormObj.List3, _
                                FormObj.List4, _
                                FormObj.List5, _
                                Polar, _
                                Text1(0).Text, Text1(1).Text, _
                                Text1(2).Text, _
                                Text1(3).Text, Text1(4).Text, _
                                Text1(5).Text, Text1(6).Text, _
                                vbWindowText _
                            )
                    End If
                Next i
                Call Unload(FormObj)
            Case "Edit"
                Combo1.Text = _
                    Mid( _
                        List1.List(List1.ListIndex), _
                        1, _
                        Len(List1.List(List1.ListIndex)) _
                    )
                Call List1.RemoveItem(List1.ListIndex)
                Combo1.SelStart = 0
                Combo1.SelLength = Len(Combo1.Text)
                Combo1.SetFocus
            Case "Remove"
                For i = List1.ListCount - 1 To 0 Step -1
                    If List1.Selected(i) Then _
                        Call List1.RemoveItem(i)
                Next i
        End Select
        Form4.Tag = ""
    End If
    
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

Private Sub Picture2_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    TempMinX = CDbl(Text1(3).Text)
    TempMaxX = CDbl(Text1(4).Text)
    TempMinY = CDbl(Text1(5).Text)
    TempMaxY = CDbl(Text1(6).Text)
    DragX = CDbl(X)
    DragY = CDbl(Y)
    
End Sub
Private Sub Picture2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim OffsetX As Double
    Dim OffsetY As Double
    Dim DeltaX As Double
    Dim DeltaY As Double
    Dim NewX As Double
    Dim NewY As Double
    
    DeltaX = CDbl(Text1(4).Text) - CDbl(Text1(3).Text)
    DeltaY = CDbl(Text1(6).Text) - CDbl(Text1(5).Text)
    If Button <> 0 Then
        OffsetX = (CDbl(X) - DragX) / (Picture2.ScaleWidth / (TempMaxX - TempMinX))
        OffsetY = (CDbl(Y) - DragY) / (Picture2.ScaleHeight / (TempMaxY - TempMinY))
        Select Case Button
            Case 1
                Picture2.MousePointer = vbSizeAll
                Text1(3).Text = CStr(TempMinX - OffsetX)
                Text1(4).Text = CStr(TempMaxX - OffsetX)
                Text1(5).Text = CStr(TempMinY + OffsetY)
                Text1(6).Text = CStr(TempMaxY + OffsetY)
            Case 2
                Picture2.MousePointer = vbSizeNS
                Text1(3).Text = CStr(TempMinX - OffsetY)
                Text1(4).Text = CStr(TempMaxX + OffsetY)
                Text1(5).Text = CStr(TempMinY - OffsetY)
                Text1(6).Text = CStr(TempMaxY + OffsetY)
        End Select
        Text1(3).Text = Format(Text1(3).Text, "0.00")
        Text1(4).Text = Format(Text1(4).Text, "0.00")
        Text1(5).Text = Format(Text1(5).Text, "0.00")
        Text1(6).Text = Format(Text1(6).Text, "0.00")
        Text1(7).Text = Format(Text1(7).Text, "0.00")
        Call Form_Resize
    Else
        Picture2.MousePointer = vbCrosshair
    End If
    NewX = _
        CDbl(Text1(3).Text) + _
        X / Picture2.ScaleWidth * _
        (CDbl(Text1(4).Text) - CDbl(Text1(3).Text))
    NewY = _
        CDbl(Text1(5).Text) + _
        (1 - Y / Picture2.ScaleHeight) * _
        (CDbl(Text1(6).Text) - CDbl(Text1(5).Text))
    Label7.Caption = _
        "(" & _
            CStr(Format(CStr(NewX), "0.0")) & _
            ", " & _
            CStr(Format(CStr(NewY), "0.0")) & _
        ")" & vbCrLf & _
        Format(CStr(1 / CDbl(Text1(7).Text)), "0.0##") & " X"
    Call Label7.Move(X + 120, Y + 60)
    
End Sub
Private Sub Picture2_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If _
        CDbl(Text1(4).Text) - CDbl(Text1(3).Text) > MAX_WINDOW_DIM Or _
        CDbl(Text1(6).Text) - CDbl(Text1(5).Text) > MAX_WINDOW_DIM Or _
        CDbl(Text1(4).Text) - CDbl(Text1(3).Text) < MIN_WINDOW_DIM Or _
        CDbl(Text1(6).Text) - CDbl(Text1(5).Text) < MIN_WINDOW_DIM _
    Then
        Beep
        Text1(3).Text = CStr(TempMinX)
        Text1(4).Text = CStr(TempMaxX)
        Text1(5).Text = CStr(TempMinY)
        Text1(6).Text = CStr(TempMaxY)
        Call Form_Resize
    End If
    
End Sub
Private Sub Picture3_Resize()

    Call Frame1.Move(0, 0, Picture3.ScaleWidth, Picture3.ScaleHeight)
    
End Sub
Private Sub Text1_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)

    If KeyCode = 13 Then
        KeyCode = 0
        Call Form_Resize
    End If
    
End Sub
