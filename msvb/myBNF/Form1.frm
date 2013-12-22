VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
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
   Begin VB.Timer Timer1 
      Left            =   2400
      Top             =   120
   End
   Begin VB.TextBox Text3 
      BackColor       =   &H8000000F&
      Height          =   495
      Left            =   1440
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   5
      Top             =   1440
      Width           =   1215
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   1800
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox Text2 
      BackColor       =   &H8000000F&
      Height          =   495
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   4
      Top             =   1440
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Enter"
      Height          =   375
      Left            =   1440
      TabIndex        =   3
      Top             =   960
      Width           =   855
   End
   Begin MSComctlLib.StatusBar StatusBar1 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   2
      Top             =   2820
      Width           =   4680
      _ExtentX        =   8255
      _ExtentY        =   661
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   960
      Width           =   1215
   End
   Begin MSComctlLib.TreeView TreeView1 
      Height          =   735
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   1296
      _Version        =   393217
      Style           =   7
      Appearance      =   1
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuNew 
         Caption         =   "New"
      End
      Begin VB.Menu mnuBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuLoad 
         Caption         =   "Load"
      End
      Begin VB.Menu mnuSave 
         Caption         =   "Save"
      End
      Begin VB.Menu mnuBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuUseMacros 
         Caption         =   "Use Macros"
      End
      Begin VB.Menu mnuBar3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "View"
      Begin VB.Menu mnuViewList 
         Caption         =   "Rules"
         Index           =   0
      End
      Begin VB.Menu mnuViewList 
         Caption         =   "Tree"
         Index           =   1
      End
      Begin VB.Menu mnuViewList 
         Caption         =   "Parser"
         Index           =   2
      End
      Begin VB.Menu mnuViewList 
         Caption         =   "Items"
         Index           =   3
      End
   End
   Begin VB.Menu mnuParser 
      Caption         =   "Parser"
      Begin VB.Menu mnuGenerate 
         Caption         =   "Generate"
      End
      Begin VB.Menu mnuCompress 
         Caption         =   "Compress"
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

Dim mTable As String
Sub LockMenu(Value As Boolean)

    If Value Then
        mnuFile.Enabled = False
        mnuView.Enabled = False
        mnuParser.Enabled = False
        Text1.BackColor = vbButtonFace
        Text1.Locked = True
        Command1.Enabled = False
    Else
        mnuFile.Enabled = True
        mnuView.Enabled = True
        mnuParser.Enabled = True
        Text1.BackColor = vbWhite
        Text1.Locked = False
        Command1.Enabled = True
    End If
    
End Sub
Private Sub Form_Load()

    Form1.Caption = App.Title
    Text2.Locked = True
    Text3.Locked = True
    Timer1.Interval = 500
    Call mnuNew_Click
    mnuUseMacros.Checked = True
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    Call mnuExit_Click
    
End Sub
Private Sub Form_Resize()

    On Error Resume Next
    Call Text1.Move(0, 0, Form1.ScaleWidth - Command1.Width)
    Call Command1.Move(Text1.Width, 0)
    Call TreeView1.Move( _
        0, _
        Text1.Height, _
        Form1.ScaleWidth * 0.75, _
        Form1.ScaleHeight - Text1.Height - StatusBar1.Height _
    )
    Call Text2.Move(TreeView1.Width, Text1.Height, Form1.ScaleWidth * 0.25, TreeView1.Height)
    Call Text3.Move(TreeView1.Left, TreeView1.Top, TreeView1.Width, TreeView1.Height)
    
End Sub
Private Sub Command1_Click()

    If Command1.Enabled Then
        Text2.Text = SmartParse(Text1.Text)
        If Left(Text2.Text, 3) <> "err" Then
            Call BuildTree(Text1.Text, Text2.Text, TreeView1)
            '========================
            Call mnuViewList_Click(1)
            '========================
        Else
            Call TreeView1.Nodes.Clear
            '========================
            Call mnuViewList_Click(2)
            '========================
        End If
    End If
    
End Sub
Private Sub Text1_KeyPress(KeyAscii As Integer)

    If KeyAscii = 13 Then
        Call Command1_Click
        KeyAscii = 0
    End If
    
End Sub
Private Sub Text1_KeyUp(KeyCode As Integer, Shift As Integer)

    Call Command1_Click
    
End Sub
Private Sub mnuNew_Click()

    StatusBar1.Panels.Item(1) = "Resetting.."
    Call LockMenu(True)
    '=========================
    Call TreeView1.Nodes.Clear
    Text1.Text = ""
    Text2.Text = ""
    mTable = ""
    Call ListClear(mRuleList)
    Call ListClear(mItemList)
    '=========================
    Call LockMenu(False)
    '=============================
    mnuSave.Enabled = False
    mnuGenerate.Enabled = False
    mnuCompress.Enabled = False
    Text1.BackColor = vbButtonFace
    Text1.Locked = True
    Command1.Enabled = False
    Call mnuViewList_Click(0)
    '=============================
    StatusBar1.Panels.Item(1) = "Ready"
    
End Sub
Private Sub mnuLoad_Click()

    On Error Resume Next
    '================================
    CommonDialog1.CancelError = True
    CommonDialog1.Filename = ""
    CommonDialog1.Filter = _
        "Grammars (*.cfg)|*.cfg|" & _
        "Parsers (*.par)|*.par|" & _
        "All Files (*.*)|*.*"
    CommonDialog1.FilterIndex = 0
    '================================
    CommonDialog1.Action = 1
    If Err = 0 Then
        '================
        Call mnuNew_Click
        '================
        Select Case Right(CommonDialog1.Filename, 3)
            Case "cfg"
                Call LoadCFG(CommonDialog1.Filename, Not mnuUseMacros.Checked)
                '=============================
                mnuSave.Enabled = False
                mnuGenerate.Enabled = True
                mnuCompress.Enabled = False
                Text1.BackColor = vbButtonFace
                Text1.Locked = True
                Command1.Enabled = False
                Call mnuViewList_Click(0)
                '=============================
                StatusBar1.Panels.Item(1) = GetFilename(CommonDialog1.Filename)
            Case "par"
                Call LoadParser(CommonDialog1.Filename)
                mTable = LoadText(CommonDialog1.Filename)
                '==========================
                mnuSave.Enabled = True
                mnuGenerate.Enabled = False
                mnuCompress.Enabled = False
                Text1.BackColor = vbWhite
                Text1.Locked = False
                Command1.Enabled = True
                Call mnuViewList_Click(2)
                '==========================
                StatusBar1.Panels.Item(1) = GetFilename(CommonDialog1.Filename)
        End Select
    End If
    
End Sub
Private Sub mnuSave_Click()

    On Error Resume Next
    '===============================
    CommonDialog1.CancelError = True
    CommonDialog1.Filename = ""
    CommonDialog1.Filter = _
        "Parsers (*.par)|*.par|" & _
        "Items (*.itm)|*.itm|" & _
        "All Files (*.*)|*.*"
    CommonDialog1.FilterIndex = 0
    '===============================
    CommonDialog1.Action = 2
    If Err = 0 Then
        Select Case Right(CommonDialog1.Filename, 3)
            Case "par"
                Call SaveText(CommonDialog1.Filename, mTable)
            Case "itm"
                Call SaveText(CommonDialog1.Filename, ListPrint(mItemList, vbCrLf & vbCrLf, True, "(", ")" & vbCrLf))
        End Select
    End If
    
End Sub
Private Sub mnuExit_Click()

    If Dir(GetLocalPath("temp.txt")) <> "" Then _
        Call Kill(GetLocalPath("temp.txt"))
    End
    
End Sub
Private Sub mnuViewList_Click(Index As Integer)

    Dim i As Long
    
    For i = 0 To mnuViewList.Count - 1
        mnuViewList.Item(i).Checked = False
    Next i
    Select Case Index
        Case 0
            Text3.Visible = True
            Text3.Text = ListPrint(mRuleList, vbCrLf)
        Case 1
            Text3.Visible = False
        Case 2
            Text3.Visible = True
            Text3.Text = mTable
        Case 3
            Text3.Visible = True
            Text3.Text = ListPrint(mItemList, vbCrLf & vbCrLf, True, "(", ")" & vbCrLf)
    End Select
    mnuViewList.Item(Index).Checked = True
    
End Sub
Private Sub mnuGenerate_Click()

    StatusBar1.Panels.Item(1) = "Generating parser.."
    Call LockMenu(True)
    '========================================================
    mTable = GetTable
    Call SaveParser(GetLocalPath("temp.txt"), mTable)
    Call LoadParser(GetLocalPath("temp.txt"))
    mTable = LoadText(GetLocalPath("temp.txt"))
    Call MsgBox("Done!", vbInformation + vbOKOnly, App.Title)
    '========================================================
    Call LockMenu(False)
    '==========================
    mnuSave.Enabled = True
    mnuGenerate.Enabled = False
    mnuCompress.Enabled = True
    Text1.BackColor = vbWhite
    Text1.Locked = False
    Command1.Enabled = True
    Call mnuViewList_Click(2)
    '==========================
    StatusBar1.Panels.Item(1) = "Ready"
    
End Sub
Private Sub mnuCompress_Click()

    Dim i As Long
    
    StatusBar1.Panels.Item(1) = "Compressing parser.."
    Call LockMenu(True)
    '========================================================
    i = 1
    Call ScanText(mTable, i, vbCrLf & vbCrLf)
    Call ScanText(mTable, i, vbCrLf & vbCrLf)
    mTable = ScanText(mTable, i, Chr(0))
    mTable = CompressTable(mTable)
    Call SaveParser(GetLocalPath("temp.txt"), mTable)
    Call LoadParser(GetLocalPath("temp.txt"))
    mTable = LoadText(GetLocalPath("temp.txt"))
    Call MsgBox("Done!", vbInformation + vbOKOnly, App.Title)
    '========================================================
    Call LockMenu(False)
    '==========================
    mnuSave.Enabled = True
    mnuGenerate.Enabled = False
    mnuCompress.Enabled = False
    Text1.BackColor = vbWhite
    Text1.Locked = False
    Command1.Enabled = True
    Call mnuViewList_Click(2)
    '==========================
    StatusBar1.Panels.Item(1) = "Ready"
    
End Sub
Private Sub mnuUseMacros_Click()

    mnuUseMacros.Checked = Not mnuUseMacros.Checked
    
End Sub
Private Sub mnuAbout_Click()

    Call ShowAbout
    
End Sub
Private Sub Timer1_Timer()

    If mStatus <> "" Then
        Form1.Caption = App.Title & " - " & mStatus
    Else
        Form1.Caption = App.Title
    End If
    
End Sub
