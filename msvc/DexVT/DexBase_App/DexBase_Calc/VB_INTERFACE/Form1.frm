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
      Caption         =   "Parameters"
      Height          =   2055
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   9255
      Begin VB.CheckBox Check1 
         Caption         =   "Radial"
         Height          =   375
         Left            =   6000
         TabIndex        =   22
         Top             =   1560
         Width           =   1215
      End
      Begin VB.TextBox Text2 
         BeginProperty Font 
            Name            =   "Fixedsys"
            Size            =   12
            Charset         =   136
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   1560
         TabIndex        =   21
         Top             =   1560
         Width           =   4335
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   8
         Left            =   5160
         TabIndex        =   20
         Text            =   "10"
         Top             =   960
         Width           =   735
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   7
         Left            =   5160
         TabIndex        =   18
         Text            =   "50"
         Top             =   600
         Width           =   735
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   6
         Left            =   5160
         TabIndex        =   16
         Text            =   "50"
         Top             =   240
         Width           =   735
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   5
         Left            =   3480
         TabIndex        =   14
         Text            =   "21"
         Top             =   840
         Width           =   735
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   4
         Left            =   3480
         TabIndex        =   12
         Text            =   "21"
         Top             =   360
         Width           =   735
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   3
         Left            =   2040
         TabIndex        =   10
         Text            =   "10"
         Top             =   840
         Width           =   735
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   2
         Left            =   600
         TabIndex        =   8
         Text            =   "-10"
         Top             =   840
         Width           =   735
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   1
         Left            =   2040
         TabIndex        =   6
         Text            =   "10"
         Top             =   360
         Width           =   735
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   0
         Left            =   600
         TabIndex        =   4
         Text            =   "-10"
         Top             =   360
         Width           =   735
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Plot"
         Height          =   375
         Index           =   0
         Left            =   120
         TabIndex        =   2
         Top             =   1560
         Width           =   1215
      End
      Begin VB.Line Line2 
         X1              =   120
         X2              =   5880
         Y1              =   1440
         Y2              =   1440
      End
      Begin VB.Label Label1 
         Caption         =   "Y"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   8
         Left            =   4680
         TabIndex        =   19
         Top             =   1080
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "Z"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   7
         Left            =   4680
         TabIndex        =   17
         Top             =   720
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "X"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   6
         Left            =   4680
         TabIndex        =   15
         Top             =   360
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "SZ"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   5
         Left            =   3000
         TabIndex        =   13
         Top             =   960
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "SX"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   4
         Left            =   3000
         TabIndex        =   11
         Top             =   480
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "Z2"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   3
         Left            =   1560
         TabIndex        =   9
         Top             =   960
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "Z1"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   7
         Top             =   960
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "X2"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   1
         Left            =   1560
         TabIndex        =   5
         Top             =   480
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "X1"
         BeginProperty Font 
            Name            =   "System"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   3
         Top             =   480
         Width           =   375
      End
      Begin VB.Line Line1 
         X1              =   4560
         X2              =   4560
         Y1              =   240
         Y2              =   1320
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

Private Const PI = 3.14159265358979

Private Const WM_USER = &H400
Private Const WM_KEYDOWN = &H100
Private Const VK_ESCAPE = &H1B
Private Const SW_SHOWNORMAL = 1

Private Const CLASS_NAME = "DexView"
Private Const WINDOW_NAME = "DexBase"

Private Const GUI_INIT = &H0
Private Const GUI_RESET = &H1
Private Const GUI_SEND_CHAR = &H2
Private Const GUI_SET_RADIAL = &H3
Private Const GUI_SET_MIN_X = &H4
Private Const GUI_SET_MAX_X = &H5
Private Const GUI_SET_MIN_Z = &H6
Private Const GUI_SET_MAX_Z = &H7
Private Const GUI_SET_STEP_X = &H8
Private Const GUI_SET_STEP_Z = &H9
Private Const GUI_SET_WIDTH = &HA
Private Const GUI_SET_LENGTH = &HB
Private Const GUI_SET_HEIGHT = &HC
Private Const GUI_PLOT = &HD

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
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
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
    Call Check1_Click
    
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
Function FloatToLong(Value As Single) As Long

    Call CopyMemory(FloatToLong, Value, Len(Value))
    
End Function
Function LongToFloat(Value As Long) As Single

    Call CopyMemory(LongToFloat, Value, Len(Value))
    
End Function
Function MakeLong(ByVal LoWord As Long, ByVal HiWord As Long) As Long

    MakeLong = ((HiWord * &H10000) + LoWord)
    
End Function
Private Sub Command1_Click(Index As Integer)

    Dim i As Integer
    Dim GUI_PARAM As Long
    Dim c As Integer
    
    Select Case Command1(Index).Caption
        Case "Plot"
            Call SendMessage(mHandle, WM_USER, GUI_SET_RADIAL, Check1.Value)
            For i = 0 To 8
                Select Case i
                    Case 0: GUI_PARAM = GUI_SET_MIN_X
                    Case 1: GUI_PARAM = GUI_SET_MAX_X
                    Case 2: GUI_PARAM = GUI_SET_MIN_Z
                    Case 3: GUI_PARAM = GUI_SET_MAX_Z
                    Case 4: GUI_PARAM = GUI_SET_STEP_X
                    Case 5: GUI_PARAM = GUI_SET_STEP_Z
                    Case 6: GUI_PARAM = GUI_SET_WIDTH
                    Case 7: GUI_PARAM = GUI_SET_LENGTH
                    Case 8: GUI_PARAM = GUI_SET_HEIGHT
                End Select
                Call SendMessage(mHandle, WM_USER, GUI_PARAM, FloatToLong(Val(Text1(i).Text)))
            Next i
            Call SendMessage(mHandle, WM_USER, GUI_RESET, 0)
            For i = 1 To Len(Text2.Text)
                c = Asc(Mid(Text2.Text, i, 1))
                Call SendMessage(mHandle, WM_USER, GUI_SEND_CHAR, MakeLong(i - 1, c))
            Next i
            Call SendMessage(mHandle, WM_USER, GUI_SEND_CHAR, MakeLong(i - 1, 0))
            Call SendMessage(mHandle, WM_USER, GUI_PLOT, 0)
    End Select
    Call RestoreWindow(mHandle)
    Call Form_Resize
    
End Sub
Private Sub Text1_GotFocus(Index As Integer)

    Text1(Index).SelStart = 0
    Text1(Index).SelLength = Len(Text1(Index).Text)
    
End Sub
Private Sub Text2_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = 13 Then _
        Call Command1_Click(0)
        
End Sub
Private Sub Check1_Click()

    Const Precision = 5
    
    If Check1.Value = 1 Then
        Text1(0).Text = CStr(0)
        Text1(1).Text = CStr(Val(Left(CStr(PI * 2), Precision)) + 0.001)
        Text1(2).Text = CStr(0)
        Text1(3).Text = CStr(Val(Left(CStr(PI), Precision)) + 0.001)
        Text1(4).Text = CStr(21)
        Text1(5).Text = CStr(21)
        Text1(6).Text = CStr(50)
        Text1(7).Text = CStr(50)
        Text1(8).Text = CStr(50)
        Label1(0).Caption = "Y1"
        Label1(1).Caption = "Y2"
        Label1(2).Caption = "P1"
        Label1(3).Caption = "P2"
        Label1(4).Caption = "SY"
        Label1(5).Caption = "SP"
        Text2.Text = "r=p+y"
    Else
        Text1(0).Text = CStr(-10)
        Text1(1).Text = CStr(10)
        Text1(2).Text = CStr(-10)
        Text1(3).Text = CStr(10)
        Text1(4).Text = CStr(21)
        Text1(5).Text = CStr(21)
        Text1(6).Text = CStr(50)
        Text1(7).Text = CStr(50)
        Text1(8).Text = CStr(10)
        Label1(0).Caption = "X1"
        Label1(1).Caption = "X2"
        Label1(2).Caption = "Z1"
        Label1(3).Caption = "Z2"
        Label1(4).Caption = "SX"
        Label1(5).Caption = "SZ"
        Text2.Text = "y=sin(sqrt(x^2+z^2))"
    End If
    
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
