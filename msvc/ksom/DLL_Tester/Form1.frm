VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4392
   ClientLeft      =   60
   ClientTop       =   348
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   4392
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command3 
      Caption         =   "Command3"
      Height          =   372
      Left            =   3360
      TabIndex        =   4
      Top             =   3960
      Width           =   1215
   End
   Begin VB.PictureBox Picture1 
      Height          =   3015
      Left            =   120
      ScaleHeight     =   2964
      ScaleWidth      =   4404
      TabIndex        =   3
      Top             =   120
      Width           =   4455
   End
   Begin VB.TextBox Text1 
      Height          =   1095
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   2
      Top             =   3240
      Width           =   3135
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   372
      Left            =   3360
      TabIndex        =   1
      Top             =   3600
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   372
      Left            =   3360
      TabIndex        =   0
      Top             =   3240
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mCount As Long
Private Sub Form_Load()

    Picture1.AutoRedraw = True
    
End Sub
Private Sub Command1_Click()

    Call MsgBox(ksom_sum(2, 3))
    Call MsgBox(ksom_echo("test"))
    
End Sub
Private Sub Command2_Click()

    Dim i As Long
    Dim j As Long
    Dim Length As Long
    Dim Token As String
    Dim Token2 As String
    Dim pError As Single
    
    On Error Resume Next
    Call ksom_test(Text1.Text)
    If Err = 0 Then
        Call MsgBox("Done!")
        Length = Len(mResult)
        i = 1
        Do While i < Length
            Token = ScanText(mResult, i, Chr(10))
            j = 1
            Token2 = GetShellPtn(Token, j, "(", ")")
            Picture1.CurrentX = Val(GetEntry(Token2, ",", 1))
            Picture1.CurrentY = Val(GetEntry(Token2, ",", 2))
            Token2 = GetShellPtn(Token, j, "(", ")")
            pError = Val(GetEntry(Token2, "=", 2))
            If pError < 120 Then _
                pError = 120
            Picture1.Circle (Picture1.CurrentX, Picture1.CurrentY), CInt(pError)
        Loop
    Else
        Call MsgBox(Error(Err), vbExclamation + vbOKOnly, "Error")
    End If
    
End Sub
Private Sub Command3_Click()

    Form2.Show 1
    
End Sub
Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)

    If Button = 1 Then
        Picture1.Circle (x, Y), 30, vbRed
        Picture1.CurrentX = x - 160
        Picture1.CurrentY = Y - 200
        Picture1.Print CStr(mCount)
        If Text1.Text = "" Then
            Text1.Text = Text1.Text & CStr(x) & ", " & CStr(Y)
        Else
            Text1.Text = Text1.Text & ", " & CStr(x) & ", " & CStr(Y)
        End If
        mCount = mCount + 1
    Else
        Picture1.Cls
        Text1.Text = ""
        mCount = 0
    End If
    
End Sub
