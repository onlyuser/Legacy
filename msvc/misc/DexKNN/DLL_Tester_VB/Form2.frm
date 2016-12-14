VERSION 5.00
Begin VB.Form Form2 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   Caption         =   "Form2"
   ClientHeight    =   8160
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7080
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8160
   ScaleWidth      =   7080
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   735
      Index           =   2
      Left            =   2520
      ScaleHeight     =   735
      ScaleWidth      =   855
      TabIndex        =   31
      Top             =   5640
      Width           =   855
      Begin VB.Line Line7 
         Index           =   2
         X1              =   120
         X2              =   480
         Y1              =   240
         Y2              =   240
      End
      Begin VB.Line Line6 
         Index           =   2
         X1              =   480
         X2              =   480
         Y1              =   240
         Y2              =   120
      End
      Begin VB.Line Line5 
         Index           =   2
         X1              =   480
         X2              =   720
         Y1              =   120
         Y2              =   360
      End
      Begin VB.Line Line4 
         Index           =   2
         X1              =   720
         X2              =   480
         Y1              =   360
         Y2              =   600
      End
      Begin VB.Line Line3 
         Index           =   2
         X1              =   480
         X2              =   480
         Y1              =   600
         Y2              =   480
      End
      Begin VB.Line Line2 
         Index           =   2
         X1              =   480
         X2              =   120
         Y1              =   480
         Y2              =   480
      End
      Begin VB.Line Line1 
         Index           =   2
         X1              =   120
         X2              =   120
         Y1              =   480
         Y2              =   240
      End
   End
   Begin VB.PictureBox Picture3 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   1335
      Index           =   3
      Left            =   3480
      ScaleHeight     =   1305
      ScaleWidth      =   1905
      TabIndex        =   27
      Top             =   5280
      Width           =   1935
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   9
         Left            =   240
         ScaleHeight     =   465
         ScaleWidth      =   1305
         TabIndex        =   28
         Top             =   480
         Width           =   1335
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Shortest Path"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   9
            Left            =   120
            TabIndex        =   29
            Top             =   120
            Width           =   960
         End
      End
      Begin VB.Label Label3 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
         Caption         =   "OUTPUT"
         ForeColor       =   &H80000008&
         Height          =   195
         Index           =   3
         Left            =   120
         TabIndex        =   30
         Top             =   120
         Width           =   675
      End
   End
   Begin VB.PictureBox Picture3 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   2535
      Index           =   2
      Left            =   240
      ScaleHeight     =   2505
      ScaleWidth      =   2145
      TabIndex        =   19
      Top             =   5280
      Width           =   2175
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   7
         Left            =   240
         ScaleHeight     =   465
         ScaleWidth      =   1545
         TabIndex        =   24
         Top             =   480
         Width           =   1575
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Roadmap Graph"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   7
            Left            =   120
            TabIndex        =   25
            Top             =   120
            Width           =   1170
         End
      End
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   6
         Left            =   360
         ScaleHeight     =   465
         ScaleWidth      =   1305
         TabIndex        =   22
         Top             =   1080
         Width           =   1335
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Start Location"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   6
            Left            =   120
            TabIndex        =   23
            Top             =   120
            Width           =   990
         End
      End
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   5
         Left            =   480
         ScaleHeight     =   465
         ScaleWidth      =   1065
         TabIndex        =   20
         Top             =   1680
         Width           =   1095
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Destination"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   5
            Left            =   120
            TabIndex        =   21
            Top             =   120
            Width           =   795
         End
      End
      Begin VB.Label Label3 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
         Caption         =   "INPUT"
         ForeColor       =   &H80000008&
         Height          =   195
         Index           =   2
         Left            =   120
         TabIndex        =   26
         Top             =   120
         Width           =   495
      End
   End
   Begin VB.PictureBox Picture3 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   1935
      Index           =   1
      Left            =   4200
      ScaleHeight     =   1905
      ScaleWidth      =   2385
      TabIndex        =   5
      Top             =   1680
      Width           =   2415
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   4
         Left            =   360
         ScaleHeight     =   465
         ScaleWidth      =   1545
         TabIndex        =   15
         Top             =   1080
         Width           =   1575
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Roadmap Edges"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   4
            Left            =   120
            TabIndex        =   16
            Top             =   120
            Width           =   1185
         End
      End
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   3
         Left            =   240
         ScaleHeight     =   465
         ScaleWidth      =   1785
         TabIndex        =   13
         Top             =   480
         Width           =   1815
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Roadmap Milestones"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   3
            Left            =   120
            TabIndex        =   14
            Top             =   120
            Width           =   1485
         End
      End
      Begin VB.Label Label3 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
         Caption         =   "OUTPUT"
         ForeColor       =   &H80000008&
         Height          =   195
         Index           =   1
         Left            =   120
         TabIndex        =   6
         Top             =   120
         Width           =   675
      End
   End
   Begin VB.PictureBox Picture3 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   2535
      Index           =   0
      Left            =   240
      ScaleHeight     =   2505
      ScaleWidth      =   2865
      TabIndex        =   3
      Top             =   1680
      Width           =   2895
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   2
         Left            =   720
         ScaleHeight     =   465
         ScaleWidth      =   1305
         TabIndex        =   11
         Top             =   1680
         Width           =   1335
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Timeout Time"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   2
            Left            =   120
            TabIndex        =   12
            Top             =   120
            Width           =   960
         End
      End
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   1
         Left            =   600
         ScaleHeight     =   465
         ScaleWidth      =   1545
         TabIndex        =   9
         Top             =   1080
         Width           =   1575
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Target Resolution"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   1
            Left            =   120
            TabIndex        =   10
            Top             =   120
            Width           =   1260
         End
      End
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   0
         Left            =   240
         ScaleHeight     =   465
         ScaleWidth      =   2265
         TabIndex        =   7
         Top             =   480
         Width           =   2295
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Workspace Query Interface"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   0
            Left            =   120
            TabIndex        =   8
            Top             =   120
            Width           =   1965
         End
      End
      Begin VB.Label Label3 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
         Caption         =   "INPUT"
         ForeColor       =   &H80000008&
         Height          =   195
         Index           =   0
         Left            =   120
         TabIndex        =   4
         Top             =   120
         Width           =   495
      End
   End
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   735
      Index           =   1
      Left            =   3240
      ScaleHeight     =   735
      ScaleWidth      =   855
      TabIndex        =   1
      Top             =   2280
      Width           =   855
      Begin VB.Line Line1 
         Index           =   1
         X1              =   120
         X2              =   120
         Y1              =   480
         Y2              =   240
      End
      Begin VB.Line Line2 
         Index           =   1
         X1              =   480
         X2              =   120
         Y1              =   480
         Y2              =   480
      End
      Begin VB.Line Line3 
         Index           =   1
         X1              =   480
         X2              =   480
         Y1              =   600
         Y2              =   480
      End
      Begin VB.Line Line4 
         Index           =   1
         X1              =   720
         X2              =   480
         Y1              =   360
         Y2              =   600
      End
      Begin VB.Line Line5 
         Index           =   1
         X1              =   480
         X2              =   720
         Y1              =   120
         Y2              =   360
      End
      Begin VB.Line Line6 
         Index           =   1
         X1              =   480
         X2              =   480
         Y1              =   240
         Y2              =   120
      End
      Begin VB.Line Line7 
         Index           =   1
         X1              =   120
         X2              =   480
         Y1              =   240
         Y2              =   240
      End
   End
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   855
      Index           =   0
      Left            =   5640
      ScaleHeight     =   855
      ScaleWidth      =   735
      TabIndex        =   0
      Top             =   5280
      Visible         =   0   'False
      Width           =   735
      Begin VB.Line Line7 
         Index           =   0
         X1              =   480
         X2              =   480
         Y1              =   120
         Y2              =   480
      End
      Begin VB.Line Line6 
         Index           =   0
         X1              =   480
         X2              =   600
         Y1              =   480
         Y2              =   480
      End
      Begin VB.Line Line5 
         Index           =   0
         X1              =   600
         X2              =   360
         Y1              =   480
         Y2              =   720
      End
      Begin VB.Line Line4 
         Index           =   0
         X1              =   360
         X2              =   120
         Y1              =   720
         Y2              =   480
      End
      Begin VB.Line Line3 
         Index           =   0
         X1              =   120
         X2              =   240
         Y1              =   480
         Y2              =   480
      End
      Begin VB.Line Line2 
         Index           =   0
         X1              =   240
         X2              =   240
         Y1              =   480
         Y2              =   120
      End
      Begin VB.Line Line1 
         Index           =   0
         X1              =   240
         X2              =   480
         Y1              =   120
         Y2              =   120
      End
   End
   Begin VB.Label Label2 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      Caption         =   "Query Processing"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   300
      Index           =   2
      Left            =   240
      TabIndex        =   18
      Top             =   4800
      Width           =   1860
   End
   Begin VB.Label Label2 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      Caption         =   "Roadmap Construction"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   300
      Index           =   1
      Left            =   240
      TabIndex        =   17
      Top             =   1200
      Width           =   2460
   End
   Begin VB.Line Line9 
      X1              =   240
      X2              =   6720
      Y1              =   4560
      Y2              =   4560
   End
   Begin VB.Label Label2 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      Caption         =   "Probabilistic Roadmap Search"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   24
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   555
      Index           =   0
      Left            =   240
      TabIndex        =   2
      Top             =   240
      Width           =   6465
   End
   Begin VB.Line Line8 
      X1              =   240
      X2              =   6720
      Y1              =   960
      Y2              =   960
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
