VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command2 
      Caption         =   "Quick Send"
      Height          =   495
      Left            =   120
      TabIndex        =   4
      Top             =   1320
      Width           =   1215
   End
   Begin VB.TextBox Text3 
      Height          =   495
      Left            =   120
      TabIndex        =   3
      Top             =   720
      Width           =   4455
   End
   Begin VB.TextBox Text2 
      Height          =   495
      Left            =   2760
      TabIndex        =   2
      Text            =   "LOOK"
      Top             =   120
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   1440
      TabIndex        =   1
      Text            =   "668"
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Connect"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Timer Timer1 
      Interval        =   100
      Left            =   0
      Top             =   0
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim hSocket As Long
Private Sub Command1_Click()

    Dim Buffer As String
    
    If Command1.Caption = "Connect" Then
        hSocket = DexSocket_open("127.0.0.1", Val(Text1.Text))
        Command1.Caption = "Disconnect"
    Else
        Call DexSocket_close(hSocket)
        Command1.Caption = "Connect"
    End If
    
End Sub
Private Sub Command2_Click()

    Dim Buffer As String
    
    hSocket = DexSocket_open("127.0.0.1", Val(Text1.Text))
    If hSocket <> 0 Then
        Call DexSocket_send(hSocket, Text2.Text)
        Buffer = Space(80)
        Call DexSocket_recv(hSocket, Buffer)
        Text3.Text = Buffer
    End If
    Call DexSocket_close(hSocket)
    
End Sub
Private Sub Timer1_Timer()

    Dim Buffer As String
    
    If hSocket <> 0 Then
        Call DexSocket_send(hSocket, Text2.Text)
        Buffer = Space(80)
        Call DexSocket_recv(hSocket, Buffer)
        Text3.Text = Buffer
    End If
    
End Sub
