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
      Caption         =   "&File"
      Begin VB.Menu mnuReset 
         Caption         =   "&Reset"
         Shortcut        =   ^R
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuInsert 
      Caption         =   "&Insert"
      Begin VB.Menu mnuInsertList 
         Caption         =   "He&x"
         Index           =   0
      End
      Begin VB.Menu mnuInsertList 
         Caption         =   "&Oct"
         Index           =   1
      End
      Begin VB.Menu mnuInsertList 
         Caption         =   "&Bin"
         Index           =   2
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Tools"
      Begin VB.Menu mnuGraph 
         Caption         =   "&Graph"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const BIG_NUMBER As Integer = 4096
Dim mShiftRun As Boolean
Private Sub Form_Load()

    Me.Caption = App.Title & " (press SHIFT+ENTER to evaluate)"
    
End Sub
Private Sub Form_Resize()

    Call Text1.Move(0, 0, Me.ScaleWidth, Me.ScaleHeight)
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    Call mnuExit_Click
    
End Sub
Private Sub mnuReset_Click()

    Call DexCalc_reset
    Text1.Text = ""
    
End Sub
Private Sub mnuExit_Click()

    End
    
End Sub
Private Sub mnuInsertList_Click(Index As Integer)

    Dim Caption As String
    Dim Expr As String
    Dim Buffer As String
    
    Caption = Replace(mnuInsertList(Index).Caption, "&", "")
    Expr = InputBox("Enter value:", Caption)
    If Expr <> "" Then
        Buffer = Space(BIG_NUMBER)
        Select Case Caption
            Case "Hex": Call DexCalc_changeBse(Expr, 10, 16, Buffer)
            Case "Oct": Call DexCalc_changeBse(Expr, 10, 8, Buffer)
            Case "Bin": Call DexCalc_changeBse(Expr, 10, 2, Buffer)
        End Select
        Buffer = Trim(Buffer)
        Select Case Caption
            Case "Hex": Call SendKeys("0x" & Buffer)
            Case "Oct": Call SendKeys("0o" & Buffer)
            Case "Bin": Call SendKeys("0b" & Buffer)
        End Select
    End If
    
End Sub
Private Sub mnuGraph_Click()

    Dim Path As String
    
    Path = App.Path & "\VB_INTERFACE.exe"
    If Dir(Path) <> "" Then
        Call Shell(Path)
    Else
        Call MsgBox("Plugin not found!", vbExclamation + vbOKOnly, "Error")
    End If
    
End Sub
Private Sub mnuAbout_Click()

    Call MsgBox( _
        App.Title & " v" & App.Major & "." & App.Minor, _
        vbInformation + vbOKOnly, _
        "About" _
        )
        
End Sub
Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)

    Dim i As Integer
    Dim ShiftDown As Boolean
    Dim InsPoint As Integer
    Dim LineStart As Integer
    Dim LineEnd As Integer
    Dim CurLine As String
    Dim NewLine As String
    Dim First As String
    Dim Rest As String
    
    On Error Resume Next
    ShiftDown = (Shift And vbShiftMask) > 0
    If KeyCode = 27 Then _
        Call mnuExit_Click
    If KeyCode = 33 Then
        InsPoint = Text1.SelStart
        Text1.SelStart = 0
        If ShiftDown Then _
            Text1.SelLength = InsPoint
    End If
    If KeyCode = 34 Then
        If ShiftDown Then
            Text1.SelLength = Len(Text1.Text) - Text1.SelStart
        Else
            Text1.SelStart = Len(Text1.Text)
        End If
    End If
    If KeyCode = 13 Then
        If ShiftDown Then
            For i = Text1.SelStart To 0 Step -1
                LineStart = i + 1
                If Mid(Text1.Text, i + 1, Len(vbCrLf)) = vbCrLf And i <> Text1.SelStart Then
                    LineStart = LineStart + Len(vbCrLf)
                    Exit For
                End If
            Next i
            For i = Text1.SelStart To Len(Text1.Text)
                LineEnd = i + 1
                If Mid(Text1.Text, i + 1, Len(vbCrLf)) = vbCrLf Then _
                    Exit For
            Next i
            CurLine = Mid(Text1.Text, LineStart, LineEnd - LineStart)
            NewLine = " " & DexCalc_eval(CurLine) & vbCrLf
            If Err <> 0 Then
                Call MsgBox(Error(Err), vbExclamation + vbOKOnly, "Error")
                Exit Sub
            End If
            First = Left(Text1.Text, LineEnd - 1) & vbCrLf
            If Len(Text1.Text) > Len(First) Then _
                Rest = Right(Text1.Text, Len(Text1.Text) - Len(First))
            Text1.Text = First & NewLine & Rest
            Text1.SelStart = Len(First & NewLine)
            mShiftRun = True
        End If
    End If
    
End Sub
Private Sub Text1_KeyPress(KeyAscii As Integer)

    If mShiftRun Then
        KeyAscii = 0
        mShiftRun = False
    End If
    
End Sub
