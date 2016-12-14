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
   Begin VB.CommandButton Command1 
      Caption         =   "Stmt Follow"
      Height          =   495
      Index           =   7
      Left            =   1440
      TabIndex        =   7
      Top             =   1320
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Empty"
      Height          =   495
      Index           =   6
      Left            =   1440
      TabIndex        =   6
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "B + P (Math)"
      Height          =   495
      Index           =   5
      Left            =   1440
      TabIndex        =   5
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Build + Parse"
      Height          =   495
      Index           =   4
      Left            =   120
      TabIndex        =   4
      Top             =   2520
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Build"
      Height          =   495
      Index           =   3
      Left            =   120
      TabIndex        =   3
      Top             =   1920
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Build + Items"
      Height          =   495
      Index           =   2
      Left            =   120
      TabIndex        =   2
      Top             =   1320
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "First + Follow"
      Height          =   495
      Index           =   1
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Load + Parse"
      Height          =   495
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub Command1_Click(Index As Integer)

    Dim i As Integer
    Dim Buffer As String
    
    Select Case Index
        Case 0 'Load + Parse
            Call DexCC_load(App.Path & "\test_wiki.par", BNF_ROOT)
            
            Buffer = Space(4096)
            Call DexCC_toString(Buffer)
            Call MsgBox(Trim(Buffer))
            
            Buffer = Space(4096)
            Call DexCC_parse("S", "1 + 1", Buffer)
            Call MsgBox(Trim(Buffer))
            
        Case 1 'First + Follow
            Call DexCC_load(App.Path & "\test_first.cfg", BNF_ROOT)
            
            For i = 0 To 9
                Buffer = Space(4096)
                Select Case i
                    Case 0: Call DexCC_getFirst("E", Buffer)
                    Case 1: Call DexCC_getFirst("T", Buffer)
                    Case 2: Call DexCC_getFirst("F", Buffer)
                    Case 3: Call DexCC_getFirst("E2", Buffer)
                    Case 4: Call DexCC_getFirst("T2", Buffer)
                    Case 5: Call DexCC_getFollow("E", "E", Buffer)
                    Case 6: Call DexCC_getFollow("E", "E2", Buffer)
                    Case 7: Call DexCC_getFollow("E", "T", Buffer)
                    Case 8: Call DexCC_getFollow("E", "T2", Buffer)
                    Case 9: Call DexCC_getFollow("E", "F", Buffer)
                End Select
                Call MsgBox(Trim(Buffer))
            Next i
            
        Case 2 'Build + Items
            Call DexCC_load(App.Path & "\test_dragon.par", BNF_ROOT)
            Call DexCC_buildTable(BNF_ROOT)
            
            Buffer = Space(4096)
            Call DexCC_getItems(Buffer)
            Call MsgBox(Trim(Buffer))
            
        Case 3 'Build
            Call DexCC_load(App.Path & "\test_dragon.par", BNF_ROOT)
            Call DexCC_buildTable(BNF_ROOT)
            
            Buffer = Space(4096)
            Call DexCC_toString(Buffer)
            Call MsgBox(Trim(Buffer))
            
        Case 4 'Build + Parse
            Call DexCC_load(App.Path & "\test_wiki.par", BNF_ROOT)
            Call DexCC_buildTable(BNF_ROOT)
            
            Buffer = Space(4096)
            Call DexCC_toString(Buffer)
            Call MsgBox(Trim(Buffer))
            
            Buffer = Space(4096)
            Call DexCC_parse("S", "1 + 1", Buffer)
            Call MsgBox(Trim(Buffer))
            
        Case 5 'Build + Parse (Math.cfg)
            Call DexCC_load(App.Path & "\math.cfg", BNF_ROOT)
            Call DexCC_buildTable(BNF_ROOT)
            
            Buffer = Space(4096)
            Call DexCC_toString(Buffer)
            Call MsgBox(Trim(Buffer))
            
            Buffer = Space(4096)
            Call DexCC_parse("S", "( x + x ) * ( x + x )", Buffer)
            Call MsgBox(Trim(Buffer))
            
        Case 6 'Empty
            Call DexCC_load(App.Path & "\empty6.cfg", BNF_ROOT)
            
            Buffer = Space(4096)
            Call DexCC_getFirst("S", Buffer)
            Call MsgBox(Trim(Buffer))
            
            Buffer = Space(4096)
            Call DexCC_getFollow("S", "S", Buffer)
            Call MsgBox(Trim(Buffer))
            
            Buffer = Space(4096)
            Call DexCC_getFirst("A", Buffer)
            Call MsgBox(Trim(Buffer))
            
            Buffer = Space(4096)
            Call DexCC_getFollow("S", "A", Buffer)
            Call MsgBox(Trim(Buffer))
            
        Case 7 'Stmt
            Call DexCC_load(App.Path & "\stmtLst2.cfg", BNF_ROOT)
            
            Buffer = Space(4096)
            Call DexCC_getFollow("S", "S", Buffer)
            Call MsgBox(Trim(Buffer))
            
            Buffer = Space(4096)
            Call DexCC_getFollow("S", "stmt", Buffer)
            Call MsgBox(Trim(Buffer))
            
            Buffer = Space(4096)
            Call DexCC_getFollow("S", "stmtLst", Buffer)
            Call MsgBox(Trim(Buffer))
            
    End Select
    
End Sub
