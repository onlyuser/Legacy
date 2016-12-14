VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6795
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   9480
   LinkTopic       =   "Form1"
   ScaleHeight     =   6795
   ScaleWidth      =   9480
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "Controls"
      Height          =   1215
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   9255
      Begin VB.CommandButton Command1 
         Caption         =   "Stop"
         Height          =   375
         Index           =   2
         Left            =   1440
         TabIndex        =   4
         Top             =   240
         Width           =   1215
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Reset"
         Height          =   375
         Index           =   1
         Left            =   120
         TabIndex        =   3
         Top             =   720
         Width           =   1215
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Connect"
         Height          =   375
         Index           =   0
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   1215
      End
   End
   Begin VB.PictureBox Picture1 
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Timer Timer1 
      Left            =   1440
      Top             =   120
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
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

Private Const WM_USER = &H400
Private Const WM_KEYDOWN = &H100
Private Const VK_ESCAPE = &H1B
Private Const SW_SHOWNORMAL = 1

Private Const CLASS_NAME = "DexView"
Private Const WINDOW_NAME = "DexBase"

Private Const GUI_INIT = &H0
Private Const GUI_CONNECT = &H1
Private Const GUI_DISCONNECT = &H2
Private Const GUI_RESET = &H3
Private Const GUI_STOP = &H4
Private Const GUI_GO = &H5

Private Type POINTAPI
        x As Long
        y As Long
End Type

Private Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type

Private Type WINDOWPLACEMENT
        Length As Long
        flags As Long
        showCmd As Long
        ptMinPosition As POINTAPI
        ptMaxPosition As POINTAPI
        rcNormalPosition As RECT
End Type

Private mHandle As Long

Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function GetParent Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function SetParent Lib "user32" (ByVal hWndChild As Long, ByVal hWndNewParent As Long) As Long
Private Declare Function MoveWindow Lib "user32" (ByVal hwnd As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Private Declare Function SetWindowPlacement Lib "user32" (ByVal hwnd As Long, lpwndpl As WINDOWPLACEMENT) As Long
Function RestoreWindow(hwnd As Long)

    Dim wp As WINDOWPLACEMENT
    
    wp.Length = Len(wp)
    wp.flags = 0&
    wp.showCmd = SW_SHOWNORMAL
    Call SetWindowPlacement(hwnd, wp)
    
End Function
Private Sub Form_Load()

    Dim Path As String
    
    Timer1.Interval = 1
    Timer1.Enabled = True
    Path = App.Path & "\DexBase.exe"
    If Dir(Path) <> "" Then _
        Call Shell(Path)
    Me.Caption = "DexBase GUI V" & App.Major & "." & App.Minor
    
End Sub
Private Sub Form_Resize()

    On Error Resume Next
    Call Picture1.Move(0, 0, Me.ScaleWidth, Me.ScaleHeight - Frame1.Height)
    Call Frame1.Move(0, Picture1.Height, Me.ScaleWidth)
    If mHandle <> 0 Then _
        Call MoveWindow( _
            mHandle, _
            Picture1.Left / Screen.TwipsPerPixelX, _
            Picture1.Top / Screen.TwipsPerPixelY, _
            Picture1.Height / Screen.TwipsPerPixelY, _
            Picture1.Height / Screen.TwipsPerPixelY, _
            True _
            )
            
End Sub
Private Sub Form_Unload(Cancel As Integer)

    If mHandle <> 0 Then
        Call SetParent(mHandle, 0)
        Call SendMessage(mHandle, WM_KEYDOWN, VK_ESCAPE, 0)
    End If
    
End Sub
Private Sub mnuExit_Click()

    Call Unload(Me)
    
End Sub
Private Sub mnuAbout_Click()

    Call MsgBox(Me.Caption)
    
End Sub
Private Sub Command1_Click(Index As Integer)

    Select Case Command1(Index).Caption
        Case "Connect"
            Command1(Index).Caption = "Disconnect"
            Call SendMessage(mHandle, WM_USER, GUI_CONNECT, 0)
        Case "Disconnect"
            Command1(Index).Caption = "Connect"
            Call SendMessage(mHandle, WM_USER, GUI_DISCONNECT, 0)
        Case "Reset"
            Call SendMessage(mHandle, WM_USER, GUI_RESET, 0)
        Case "Stop"
            Command1(Index).Caption = "Go"
            Call SendMessage(mHandle, WM_USER, GUI_STOP, 0)
        Case "Go"
            Command1(Index).Caption = "Stop"
            Call SendMessage(mHandle, WM_USER, GUI_GO, 0)
    End Select
    
End Sub
Private Sub Timer1_Timer()

    Dim Handle As Long
    Dim Buffer As String
    
    If mHandle = 0 Then
        mHandle = FindWindow(CLASS_NAME, WINDOW_NAME)
        If GetParent(mHandle) <> Me.hwnd Then
            Call SetParent(mHandle, Me.hwnd)
            Call SendMessage(mHandle, WM_USER, GUI_INIT, 0)
            Call RestoreWindow(mHandle)
            Call Form_Resize
        End If
    Else
        Buffer = Space(Len(WINDOW_NAME) + 1)
        Call GetWindowText(mHandle, Buffer, Len(WINDOW_NAME) + 1)
        If Left(Buffer, Len(WINDOW_NAME)) <> WINDOW_NAME Then _
            End
    End If
    
End Sub
