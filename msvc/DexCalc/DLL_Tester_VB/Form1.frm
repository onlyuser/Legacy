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
   Begin VB.TextBox Text1 
      Height          =   2295
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   1
      Top             =   120
      Width           =   4455
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Evaluate"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   2520
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

    Dim Result As String
    
    On Error Resume Next
    Result = DexCalc_eval(Text1.Text)
    If Err = 0 Then
        Call MsgBox(Result)
    Else
        Call MsgBox(Error(Err))
    End If
    
End Sub
