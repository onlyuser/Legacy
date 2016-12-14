VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox Combo1 
      Height          =   315
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   1680
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Exit"
      Height          =   375
      Index           =   2
      Left            =   120
      TabIndex        =   5
      Top             =   960
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      Height          =   405
      Left            =   1440
      TabIndex        =   4
      Top             =   2640
      Width           =   1815
   End
   Begin VB.ListBox List1 
      Height          =   2700
      IntegralHeight  =   0   'False
      ItemData        =   "Form1.frx":0000
      Left            =   3360
      List            =   "Form1.frx":0002
      Sorted          =   -1  'True
      TabIndex        =   3
      Top             =   360
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Apply"
      Height          =   375
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Learn"
      Height          =   375
      Index           =   0
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   1215
   End
   Begin VB.PictureBox Picture1 
      Height          =   2175
      Left            =   1440
      ScaleHeight     =   2115
      ScaleWidth      =   1755
      TabIndex        =   0
      Top             =   360
      Width           =   1815
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "Classification"
      Height          =   195
      Left            =   3360
      TabIndex        =   9
      Top             =   120
      Width           =   915
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Error Graph"
      Height          =   195
      Left            =   1440
      TabIndex        =   8
      Top             =   120
      Width           =   810
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Iterations"
      Height          =   195
      Left            =   120
      TabIndex        =   7
      Top             =   1440
      Width           =   645
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const mNetFile As String = "n-net.txt"
Private Sub Form_Load()

    Form1.Caption = App.Title
    Picture1.BackColor = vbBlack
    Picture1.ForeColor = vbWhite
    Picture1.AutoRedraw = True
    Call Combo1.AddItem("100")
    Call Combo1.AddItem("200")
    Call Combo1.AddItem("400")
    Call Combo1.AddItem("800")
    Combo1.ListIndex = 0
    Text1.Locked = True
    If Command <> "" Then
        If FindText(Command, "\") <> 0 Then
            Command1(1).Enabled = False
        Else
            Command1(0).Enabled = False
            Combo1.Enabled = False
        End If
    Else
        Call MsgBox("ERROR: Command required!", vbCritical + vbOKOnly, "Error")
        End
    End If
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    End
    
End Sub
Private Sub Command1_Click(Index As Integer)

    Dim i As Long
    Dim Vector() As Single
    Dim IndexA As Long
    Dim IndexB As Long
    
    Select Case Index
        Case 0
            Call LoadTraining(Command, CLng(Combo1.Text), Picture1, Text1)
            Call SaveNet(GetLocalPath(mNetFile))
            Call MsgBox("Done!", vbInformation + vbOKOnly, "Learn")
            Command1(0).Enabled = False
        Case 1
            If Dir(GetLocalPath(mNetFile)) = "" Then
                Call MsgBox("ERROR: Network state not found!", vbCritical + vbOKOnly, "Error")
            Else
                Call LoadNet(GetLocalPath(mNetFile))
                If CountText(Command, ",") + 1 = mInputList.Count + mOutputList.Count Then
                    Vector = ExtractVector(Command)
                    Call SetVector(Vector)
                    Call PropFwd
                    Call GetVector(Vector)
                    IndexA = UBound(Vector)
                    IndexB = UBound(Vector) - 26 + 1
                    List1.Clear
                    For i = IndexA To IndexB Step -1
                        Call List1.AddItem(Format(Vector(i), "0.00") & " - " & Chr(Asc("A") + i - IndexB))
                    Next i
                    List1.ListIndex = List1.ListCount - 1
                Else
                    Call MsgBox("ERROR: Network state mismatch!", vbCritical + vbOKOnly, "Error")
                End If
            End If
            Command1(1).Enabled = False
        Case 2
            End
    End Select
    
End Sub
