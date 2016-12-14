VERSION 5.00
Begin VB.Form Form2 
   Caption         =   "Form2"
   ClientHeight    =   4464
   ClientLeft      =   48
   ClientTop       =   432
   ClientWidth     =   4572
   LinkTopic       =   "Form2"
   ScaleHeight     =   4464
   ScaleWidth      =   4572
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command4 
      Caption         =   "Command4"
      Height          =   492
      Left            =   3240
      TabIndex        =   4
      Top             =   3840
      Width           =   1212
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Command3"
      Height          =   492
      Left            =   3240
      TabIndex        =   3
      Top             =   3240
      Width           =   1212
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   492
      Left            =   120
      TabIndex        =   2
      Top             =   3840
      Width           =   1212
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   492
      Left            =   120
      TabIndex        =   1
      Top             =   3240
      Width           =   1212
   End
   Begin VB.PictureBox Picture1 
      Height          =   3012
      Left            =   120
      ScaleHeight     =   2964
      ScaleWidth      =   4284
      TabIndex        =   0
      Top             =   120
      Width           =   4332
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mData() As Single
Private Sub Form_Load()

    ReDim mData(100)
    Picture1.AutoRedraw = True
    
End Sub
Private Sub Command1_Click()

    Dim i As Long
    
    For i = 0 To UBound(mData)
        mData(i) = 0
    Next i
    Call Form_Resize
    
End Sub
Private Sub Command2_Click()

    Const PI As Single = 3.1415926
    Dim i As Long
    
    For i = 0 To UBound(mData)
        mData(i) = (Sin(PI * 8 * i / UBound(mData)) - (-1)) / 2
    Next i
    Call Form_Resize
    
End Sub
Private Sub Command3_Click()

    Call RunKohonen(Picture1, mData, 0)
    
End Sub
Private Sub Command4_Click()

    Dim pData() As Single
    
    Call MessageFunc("state: loading..")
    'pData = LoadExcelData("c:\test\test2.txt")
    pData = LoadExcelData("c:\test\mini.txt")
    Call RunKohonen(Picture1, pData, 1)
    Call MessageFunc("Done!")
    
End Sub
Private Sub Form_Resize()

    Picture1.Cls
    Call DrawArray(Picture1, mData(), vbBlack, 0, UBound(mData), 1)
    
End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)

    If Button <> 0 Then
        If Button = 1 Then _
            Call ManipArray(Picture1, mData, x, Y)
        If Button = 2 Then _
            Call ManipArray(Picture1, mData, x, Picture1.ScaleHeight)
        Call Form_Resize
    End If
    
End Sub
