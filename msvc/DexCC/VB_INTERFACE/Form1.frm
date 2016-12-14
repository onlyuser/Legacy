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
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   1800
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox Text3 
      BackColor       =   &H8000000F&
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
      Left            =   1440
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   4
      Top             =   2040
      Width           =   1215
   End
   Begin VB.TextBox Text2 
      BackColor       =   &H8000000F&
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
      TabIndex        =   3
      Top             =   2040
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Enter"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   1560
      Width           =   855
   End
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
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Fixedsys"
         Size            =   12
         Charset         =   136
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
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
      Begin VB.Menu mnuLiveParse 
         Caption         =   "Live Parse"
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
         Caption         =   "Table"
         Index           =   0
      End
      Begin VB.Menu mnuViewList 
         Caption         =   "Items"
         Index           =   1
      End
      Begin VB.Menu mnuViewList 
         Caption         =   "Tree"
         Index           =   2
      End
   End
   Begin VB.Menu mnuParser 
      Caption         =   "Parser"
      Begin VB.Menu mnuBuild 
         Caption         =   "Build"
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

Const VIEW_TABLE As Integer = 0
Const VIEW_ITEMS As Integer = 1
Const VIEW_TREE As Integer = 2

Dim mTable As String
Dim mItems As String
Sub ResetMode()

    Text1.Locked = True
    Text1.Text = ""
    Text1.Locked = False
    Text2.Text = ""
    Call TreeView1.Nodes.Clear
    mTable = ""
    mItems = ""
    Call SetModeCFG
    '========================
    mnuView.Enabled = False
    mnuParser.Enabled = False
    '========================
    
End Sub
Sub SetModeCFG()

    Call mnuViewList_Click(VIEW_TABLE)
    mnuSave.Enabled = False
    Text1.BackColor = vbButtonFace
    Text1.Locked = True
    Command1.Enabled = False
    '=======================
    mnuView.Enabled = True
    mnuParser.Enabled = True
    '=======================
    
End Sub
Sub SetModePAR()

    Call mnuViewList_Click(VIEW_TABLE)
    mnuSave.Enabled = True
    Text1.BackColor = vbWhite
    Text1.Locked = False
    Command1.Enabled = True
    '========================
    mnuView.Enabled = True
    mnuParser.Enabled = False
    '========================
    
End Sub
Private Sub Form_Load()

    Me.Caption = App.Title
    Text2.Locked = True
    Text3.Locked = True
    mnuLiveParse.Checked = True
    Call ResetMode
    
End Sub
Private Sub Form_Resize()

    On Error Resume Next
    Call Text1.Move(0, 0, Me.ScaleWidth - Command1.Width, Command1.Height)
    Call Command1.Move(Text1.Width, 0)
    Call TreeView1.Move( _
        0, _
        Text1.Height, _
        Me.ScaleWidth * 0.75, _
        Me.ScaleHeight - Text1.Height _
        )
    Call Text2.Move(TreeView1.Width, Text1.Height, Me.ScaleWidth * 0.25, TreeView1.Height)
    Call Text3.Move(TreeView1.Left, TreeView1.Top, TreeView1.Width, TreeView1.Height)
    
End Sub
Private Sub Text1_Change()

    If Not Text1.Locked And mnuLiveParse.Checked Then _
        Call Command1_Click
        
End Sub
Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = 13 Then _
        Call Command1_Click
        
End Sub
Private Sub Command1_Click()

    Dim Buffer As String
    
    On Error Resume Next
    '===================================
    Buffer = Space(BIG_NUMBER)
    Call DexCC_parse("S", Text1.Text, Buffer)
    Buffer = TrimEx(Buffer)
    '===================================
    If Err <> 0 Then
        If Not mnuLiveParse.Checked Then _
            Call MsgBox(Error(Err))
    End If
    If Buffer <> "" Then
        Call BuildTree(Buffer, TreeView1)
        Call mnuViewList_Click(VIEW_TREE)
    Else
        Buffer = "[error]"
        Call mnuViewList_Click(VIEW_TABLE)
    End If
    Text2.Text = Buffer
    
End Sub
Private Sub mnuNew_Click()

    Call DexCC_reset
    Call ResetMode
    
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
        Call mnuNew_Click
        Call DexCC_load(CommonDialog1.Filename, BNF_ROOT)
        mTable = LoadText(CommonDialog1.Filename)
        Select Case Right(CommonDialog1.Filename, 3)
            Case "cfg": Call SetModeCFG
            Case "par": Call SetModePAR
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
            Case "par": Call SaveText(CommonDialog1.Filename, mTable)
            Case "itm": Call SaveText(CommonDialog1.Filename, mItems)
        End Select
    End If
    
End Sub
Private Sub mnuLiveParse_Click()

    mnuLiveParse.Checked = Not mnuLiveParse.Checked
    
End Sub
Private Sub mnuExit_Click()

    End
    
End Sub
Private Sub mnuViewList_Click(Index As Integer)

    Dim i As Integer
    
    For i = 0 To mnuViewList.Count - 1
        mnuViewList(i).Checked = False
    Next i
    mnuViewList(Index).Checked = True
    Select Case mnuViewList(Index).Caption
        Case "Table", "Items"
            '========================
            TreeView1.Visible = False
            Text3.Visible = True
            '========================
            Select Case mnuViewList(Index).Caption
                Case "Table": Text3.Text = mTable
                Case "Items": Text3.Text = mItems
            End Select
        Case "Tree"
            '=======================
            TreeView1.Visible = True
            Text3.Visible = False
            '=======================
    End Select
    
End Sub
Private Sub mnuBuild_Click()

    mnuFile.Enabled = False
    Form1.Refresh
    Call DexCC_buildTable(BNF_ROOT)
    mnuFile.Enabled = True
    '====================================
    mTable = Space(BIG_NUMBER)
    Call DexCC_toString(mTable)
    mTable = TrimEx(mTable)
    '====================================
    mItems = Space(BIG_NUMBER)
    Call DexCC_getItems(mItems)
    mItems = TrimEx(mItems)
    '====================================
    Call SetModePAR
    Call mnuViewList_Click(VIEW_ITEMS)
    
End Sub
Private Sub mnuAbout_Click()

    Call MsgBox( _
        App.Title & " v" & App.Major & "." & App.Minor, _
        vbInformation + vbOKOnly, _
        "About" _
        )
        
End Sub
