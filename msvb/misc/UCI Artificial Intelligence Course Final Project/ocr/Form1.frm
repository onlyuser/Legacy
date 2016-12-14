VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   3615
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4935
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3615
   ScaleWidth      =   4935
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture3 
      Height          =   2895
      Left            =   360
      ScaleHeight     =   2835
      ScaleWidth      =   2835
      TabIndex        =   5
      Top             =   360
      Width           =   2895
   End
   Begin VB.CommandButton Command1 
      Caption         =   "L"
      Height          =   375
      Index           =   8
      Left            =   3120
      TabIndex        =   12
      Top             =   3120
      Width           =   375
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   0
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Exit"
      Height          =   375
      Index           =   7
      Left            =   3600
      TabIndex        =   11
      Top             =   3120
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Apply"
      Height          =   375
      Index           =   6
      Left            =   3600
      TabIndex        =   10
      Top             =   2640
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Learn"
      Height          =   375
      Index           =   5
      Left            =   3600
      TabIndex        =   9
      Top             =   2280
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Run Script"
      Height          =   375
      Index           =   4
      Left            =   3600
      TabIndex        =   8
      Top             =   1800
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Print"
      Height          =   375
      Index           =   3
      Left            =   3600
      TabIndex        =   7
      Top             =   1320
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Scan"
      Height          =   375
      Index           =   2
      Left            =   3600
      TabIndex        =   6
      Top             =   960
      Width           =   1215
   End
   Begin VB.PictureBox Picture2 
      Height          =   375
      Index           =   1
      Left            =   120
      ScaleHeight     =   315
      ScaleWidth      =   2835
      TabIndex        =   4
      Top             =   3120
      Width           =   2895
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Rescale"
      Height          =   375
      Index           =   1
      Left            =   3600
      TabIndex        =   3
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Clear"
      Height          =   375
      Index           =   0
      Left            =   3600
      TabIndex        =   2
      Top             =   120
      Width           =   1215
   End
   Begin VB.PictureBox Picture2 
      Height          =   2895
      Index           =   0
      Left            =   3120
      ScaleHeight     =   2835
      ScaleWidth      =   315
      TabIndex        =   1
      Top             =   120
      Width           =   375
   End
   Begin VB.PictureBox Picture1 
      Height          =   2895
      Left            =   120
      ScaleHeight     =   2835
      ScaleWidth      =   2835
      TabIndex        =   0
      Top             =   120
      Width           =   2895
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const mDrawWidth As Long = 10
Const mLogFile As String = "temp.txt"
Const mNetApp As String = "n-net.exe"
Const mNetFile As String = "n-net.txt"

Dim mDivCount As Long
Dim mStopFlag As Boolean
Dim mBuffer As String
Private Sub Form_Load()

    Form1.Caption = App.Title
    Call SetAlwaysOnTop(Form1.hwnd, True)
    
    Picture1.BackColor = vbBlack
    Picture1.ForeColor = vbRed
    Picture1.ScaleMode = vbPixels
    
    Picture2(0).BackColor = vbBlack
    Picture2(1).BackColor = vbBlack
    Picture2(0).ForeColor = vbWhite
    Picture2(1).ForeColor = vbWhite
    Picture2(0).ScaleMode = vbPixels
    Picture2(1).ScaleMode = vbPixels
    
    Picture3.BackColor = vbBlack
    Picture3.ForeColor = vbWhite
    Picture3.ScaleMode = vbPixels
    
    Picture3.Visible = False
    Call Picture3.Move(Picture1.Left, Picture1.Top)
    Picture3.AutoRedraw = True
    
    mDivCount = 20
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    End
    
End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button <> 0 Then
        If Button = 1 Then
            Picture1.DrawWidth = mDrawWidth
            If Picture1.CurrentX = 0 And Picture1.CurrentY = 0 Then _
                Picture1.PSet (X, Y)
            Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(X, Y)
        Else
            Picture1.DrawWidth = mDrawWidth * 2
            If Picture1.CurrentX = 0 And Picture1.CurrentY = 0 Then _
                Picture1.PSet (X, Y), vbBlack
            Picture1.Line (Picture1.CurrentX, Picture1.CurrentY)-(X, Y), vbBlack
        End If
        Picture1.DrawWidth = 1
    Else
        Picture1.CurrentX = 0
        Picture1.CurrentY = 0
    End If
    
End Sub
Private Sub Command1_Click(Index As Integer)

    Dim i As Long
    Dim j As Long
    Dim Filename As String
    Dim Temp As String
    
    Call Picture2(0).Cls
    Call Picture2(1).Cls
    Select Case Index
        Case 0 'CLEAR
            Call Picture1.Cls
        Case 1 'RESCALE
            Call MaxImage(Picture1, vbRed, vbWhite)
        Case 2 'SCAN
        Case 3 'PRINT
            Call MaxImage(Picture1, vbRed, vbWhite)
            Call TallyImage(Picture1, mDivCount, Picture2(0), Picture2(1))
            Call MsgBox(BuildData, vbOKOnly + vbInformation, "Image Profile")
            Exit Sub
        Case 4 'RUN SCRIPT
            If Command1(Index).Caption <> "Stop Script" Then
                mStopFlag = False
                Command1(Index).Caption = "Stop Script"
                Call Form2.Move(Form1.Left + Form1.Width, Form1.Top)
                Form2.Show
                Form2.Text1.Text = ""
                mBuffer = _
                    "INPUT=" & CStr(mDivCount * 4) & vbCrLf & _
                    "HIDDEN=" & CStr(mDivCount * 4) & vbCrLf & _
                    "OUTPUT=" & CStr(26) & vbCrLf
                For i = Asc("a") To Asc("z")
                    Form2.Caption = Format((i - Asc("a")) / 26, "0.00%")
                    j = 1
                    Do
                        If mStopFlag Then _
                            Exit For
                        Filename = GetLocalPath(UCase(Chr(i)) & CStr(j) & ".bmp")
                        Temp = GetLocalPath(UCase(Chr(i)) & CStr(j + 1) & ".bmp")
                        If Dir(Filename) <> "" Then
                            Picture1.Picture = LoadPicture(Filename)
                            Call CopyImage(Picture1, Picture1, vbBlack, vbRed)
                            Call CopyImage(Picture1, Picture1, vbWhite, vbBlack)
                            Call MaxImage(Picture1, vbRed, vbWhite)
                            Call Picture2(0).Cls
                            Call Picture2(1).Cls
                            Call TallyImage(Picture1, mDivCount, Picture2(0), Picture2(1))
                            mBuffer = mBuffer & _
                                AugData(GetFilename(Filename) & ":" & BuildData) & vbCrLf
                            Form2.Text1.Text = Right(mBuffer, mBigNumber)
                            Form2.Text1.SelStart = Len(Form2.Text1.Text)
                            Picture1.Picture = LoadPicture("")
                        End If
                        Form1.Caption = App.Title & " - [" & CStr(i - Asc("a") + 1) & " of 26]"
                        j = j + 1
                        DoEvents
                    Loop While Dir(Temp) <> ""
                Next i
                If Not mStopFlag Then
                    If Dir(GetLocalPath(mNetFile)) <> "" Then _
                        Call Kill(GetLocalPath(mNetFile))
                    Call SaveText(GetLocalPath(mLogFile), mBuffer)
                    Call MsgBox("Data saved!", vbInformation + vbOKOnly, "Run Script")
                End If
                Call Picture2(0).Cls
                Call Picture2(1).Cls
                Command1(Index).Caption = "Run Script"
                Command1(Index).Enabled = True
            Else
                mStopFlag = True
                Command1(Index).Enabled = False
            End If
        Case 5 'LEARN
            Filename = GetLocalPath(mLogFile)
            If Dir(Filename) = "" Then
                Call MsgBox("No data to learn!", vbExclamation + vbOKOnly, "Learn")
            Else
                Filename = GetLocalPath(mNetApp)
                If Dir(Filename) <> "" Then _
                    Call Shell(Filename & " " & GetLocalPath(mLogFile))
            End If
        Case 6 'APPLY
            Call MaxImage(Picture1, vbRed, vbWhite)
            Call TallyImage(Picture1, mDivCount, Picture2(0), Picture2(1))
            Filename = GetLocalPath(mNetApp)
            If Dir(Filename) <> "" Then _
                Call Shell(Filename & " " & AugData(":" & BuildData), vbNormalFocus)
            Exit Sub
        Case 7 'EXIT
            End
        Case 8
            CommonDialog1.Filter = "Bitmaps (*.bmp)|*.bmp"
            CommonDialog1.Filename = ""
            CommonDialog1.Action = 1
            If CommonDialog1.Filename <> "" Then
                Picture1.Picture = LoadPicture(CommonDialog1.Filename)
                Call Picture3.Cls
                Call CopyImage(Picture1, Picture3, vbBlack, vbRed)
                Picture1.Picture = LoadPicture("")
                Call StretchBlt( _
                    Picture1.hdc, 0, 0, Picture1.ScaleWidth, Picture1.ScaleHeight, _
                    Picture3.hdc, 0, 0, Picture1.ScaleWidth, Picture1.ScaleHeight, _
                    vbSrcCopy _
                )
            End If
    End Select
    Call TallyImage(Picture1, mDivCount, Picture2(0), Picture2(1))
    
End Sub
Private Sub Picture2_MouseDown(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)

    Call Picture2(0).Cls
    Call Picture2(1).Cls
    Call CopyImage(Picture1, Picture3, vbRed, vbRed)
    Picture3.Picture = Picture3.Image 'buffer persistent image
    Picture3.Visible = True
    
End Sub
Private Sub Picture2_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim Ratio As Single
    
    If Button <> 0 Then
        Select Case Index
            Case 0
                Ratio = Y / Picture2(Index).ScaleHeight
            Case 1
                Ratio = X / Picture2(Index).ScaleWidth
        End Select
        If Ratio > 0.5 Then _
            Ratio = 1 - Ratio
        If Ratio <> 0 Then
            mDivCount = CInt(1 / Ratio)
            If mDivCount > 20 Then mDivCount = 20
            If mDivCount < 2 Then mDivCount = 2
            Picture3.Cls
            Call DrawGrids(Picture3, mDivCount)
            Form1.Caption = App.Title & " - [" & mDivCount & "x" & mDivCount & "]"
        End If
    End If
    
End Sub
Private Sub Picture2_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)

    Picture3.Visible = False
    DoEvents
    Picture3.Cls 'clear grid
    Call StretchBlt( _
        Picture1.hdc, 0, 0, Picture1.ScaleWidth, Picture1.ScaleHeight, _
        Picture3.hdc, 0, 0, Picture1.ScaleWidth, Picture1.ScaleHeight, _
        vbSrcCopy _
    )
    Picture3.Picture = LoadPicture("") 'clear persistent image
    Call TallyImage(Picture1, mDivCount, Picture2(0), Picture2(1))
    
End Sub
