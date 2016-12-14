VERSION 5.00
Begin VB.Form Form3 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   Caption         =   "Form3"
   ClientHeight    =   8640
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   11760
   LinkTopic       =   "Form3"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8640
   ScaleWidth      =   11760
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   735
      Index           =   2
      Left            =   3240
      ScaleHeight     =   735
      ScaleWidth      =   855
      TabIndex        =   25
      Top             =   7200
      Width           =   855
      Begin VB.Line Line7 
         Index           =   2
         X1              =   720
         X2              =   360
         Y1              =   480
         Y2              =   480
      End
      Begin VB.Line Line6 
         Index           =   2
         X1              =   360
         X2              =   360
         Y1              =   480
         Y2              =   600
      End
      Begin VB.Line Line5 
         Index           =   2
         X1              =   360
         X2              =   120
         Y1              =   600
         Y2              =   360
      End
      Begin VB.Line Line4 
         Index           =   2
         X1              =   120
         X2              =   360
         Y1              =   360
         Y2              =   120
      End
      Begin VB.Line Line3 
         Index           =   2
         X1              =   360
         X2              =   360
         Y1              =   120
         Y2              =   240
      End
      Begin VB.Line Line2 
         Index           =   2
         X1              =   360
         X2              =   720
         Y1              =   240
         Y2              =   240
      End
      Begin VB.Line Line1 
         Index           =   2
         X1              =   720
         X2              =   720
         Y1              =   240
         Y2              =   480
      End
   End
   Begin VB.PictureBox Picture3 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      ForeColor       =   &H80000008&
      Height          =   6615
      Index           =   2
      Left            =   4200
      ScaleHeight     =   6585
      ScaleWidth      =   7185
      TabIndex        =   17
      Top             =   1680
      Width           =   7215
      Begin VB.PictureBox Picture2 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   735
         Index           =   9
         Left            =   2760
         ScaleHeight     =   735
         ScaleWidth      =   855
         TabIndex        =   47
         Top             =   5520
         Width           =   855
         Begin VB.Line Line1 
            Index           =   9
            X1              =   720
            X2              =   720
            Y1              =   240
            Y2              =   480
         End
         Begin VB.Line Line2 
            Index           =   9
            X1              =   360
            X2              =   720
            Y1              =   240
            Y2              =   240
         End
         Begin VB.Line Line3 
            Index           =   9
            X1              =   360
            X2              =   360
            Y1              =   120
            Y2              =   240
         End
         Begin VB.Line Line4 
            Index           =   9
            X1              =   120
            X2              =   360
            Y1              =   360
            Y2              =   120
         End
         Begin VB.Line Line5 
            Index           =   9
            X1              =   360
            X2              =   120
            Y1              =   600
            Y2              =   360
         End
         Begin VB.Line Line6 
            Index           =   9
            X1              =   360
            X2              =   360
            Y1              =   480
            Y2              =   600
         End
         Begin VB.Line Line7 
            Index           =   9
            X1              =   720
            X2              =   360
            Y1              =   480
            Y2              =   480
         End
      End
      Begin VB.PictureBox Picture2 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   735
         Index           =   5
         Left            =   2760
         ScaleHeight     =   735
         ScaleWidth      =   855
         TabIndex        =   39
         Top             =   3720
         Width           =   855
         Begin VB.Line Line1 
            Index           =   5
            X1              =   120
            X2              =   120
            Y1              =   480
            Y2              =   240
         End
         Begin VB.Line Line2 
            Index           =   5
            X1              =   480
            X2              =   120
            Y1              =   480
            Y2              =   480
         End
         Begin VB.Line Line3 
            Index           =   5
            X1              =   480
            X2              =   480
            Y1              =   600
            Y2              =   480
         End
         Begin VB.Line Line4 
            Index           =   5
            X1              =   720
            X2              =   480
            Y1              =   360
            Y2              =   600
         End
         Begin VB.Line Line5 
            Index           =   5
            X1              =   480
            X2              =   720
            Y1              =   120
            Y2              =   360
         End
         Begin VB.Line Line6 
            Index           =   5
            X1              =   480
            X2              =   480
            Y1              =   240
            Y2              =   120
         End
         Begin VB.Line Line7 
            Index           =   5
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
         Index           =   4
         Left            =   1200
         ScaleHeight     =   855
         ScaleWidth      =   735
         TabIndex        =   38
         Top             =   4680
         Width           =   735
         Begin VB.Line Line7 
            Index           =   4
            X1              =   480
            X2              =   480
            Y1              =   120
            Y2              =   480
         End
         Begin VB.Line Line6 
            Index           =   4
            X1              =   480
            X2              =   600
            Y1              =   480
            Y2              =   480
         End
         Begin VB.Line Line5 
            Index           =   4
            X1              =   600
            X2              =   360
            Y1              =   480
            Y2              =   720
         End
         Begin VB.Line Line4 
            Index           =   4
            X1              =   360
            X2              =   120
            Y1              =   720
            Y2              =   480
         End
         Begin VB.Line Line3 
            Index           =   4
            X1              =   120
            X2              =   240
            Y1              =   480
            Y2              =   480
         End
         Begin VB.Line Line2 
            Index           =   4
            X1              =   240
            X2              =   240
            Y1              =   480
            Y2              =   120
         End
         Begin VB.Line Line1 
            Index           =   4
            X1              =   240
            X2              =   480
            Y1              =   120
            Y2              =   120
         End
      End
      Begin VB.PictureBox Picture3 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   6015
         Index           =   3
         Left            =   3720
         ScaleHeight     =   5985
         ScaleWidth      =   3225
         TabIndex        =   32
         Top             =   240
         Width           =   3255
         Begin VB.PictureBox Picture2 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            BorderStyle     =   0  'None
            ForeColor       =   &H80000008&
            Height          =   855
            Index           =   10
            Left            =   360
            ScaleHeight     =   855
            ScaleWidth      =   735
            TabIndex        =   48
            Top             =   4200
            Width           =   735
            Begin VB.Line Line7 
               Index           =   10
               X1              =   240
               X2              =   240
               Y1              =   720
               Y2              =   360
            End
            Begin VB.Line Line6 
               Index           =   10
               X1              =   240
               X2              =   120
               Y1              =   360
               Y2              =   360
            End
            Begin VB.Line Line5 
               Index           =   10
               X1              =   120
               X2              =   360
               Y1              =   360
               Y2              =   120
            End
            Begin VB.Line Line4 
               Index           =   10
               X1              =   360
               X2              =   600
               Y1              =   120
               Y2              =   360
            End
            Begin VB.Line Line3 
               Index           =   10
               X1              =   600
               X2              =   480
               Y1              =   360
               Y2              =   360
            End
            Begin VB.Line Line2 
               Index           =   10
               X1              =   480
               X2              =   480
               Y1              =   360
               Y2              =   720
            End
            Begin VB.Line Line1 
               Index           =   10
               X1              =   480
               X2              =   240
               Y1              =   720
               Y2              =   720
            End
         End
         Begin VB.PictureBox Picture1 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            ForeColor       =   &H80000008&
            Height          =   495
            Index           =   11
            Left            =   240
            ScaleHeight     =   465
            ScaleWidth      =   2625
            TabIndex        =   45
            Top             =   5160
            Width           =   2655
            Begin VB.Label Label1 
               Appearance      =   0  'Flat
               AutoSize        =   -1  'True
               BackColor       =   &H80000005&
               Caption         =   "Generate New Milestone Voronoi"
               ForeColor       =   &H80000008&
               Height          =   195
               Index           =   11
               Left            =   120
               TabIndex        =   46
               Top             =   120
               Width           =   2340
            End
         End
         Begin VB.PictureBox Picture2 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            BorderStyle     =   0  'None
            ForeColor       =   &H80000008&
            Height          =   855
            Index           =   8
            Left            =   2040
            ScaleHeight     =   855
            ScaleWidth      =   735
            TabIndex        =   44
            Top             =   4200
            Width           =   735
            Begin VB.Line Line1 
               Index           =   8
               X1              =   240
               X2              =   480
               Y1              =   120
               Y2              =   120
            End
            Begin VB.Line Line2 
               Index           =   8
               X1              =   240
               X2              =   240
               Y1              =   480
               Y2              =   120
            End
            Begin VB.Line Line3 
               Index           =   8
               X1              =   120
               X2              =   240
               Y1              =   480
               Y2              =   480
            End
            Begin VB.Line Line4 
               Index           =   8
               X1              =   360
               X2              =   120
               Y1              =   720
               Y2              =   480
            End
            Begin VB.Line Line5 
               Index           =   8
               X1              =   600
               X2              =   360
               Y1              =   480
               Y2              =   720
            End
            Begin VB.Line Line6 
               Index           =   8
               X1              =   480
               X2              =   600
               Y1              =   480
               Y2              =   480
            End
            Begin VB.Line Line7 
               Index           =   8
               X1              =   480
               X2              =   480
               Y1              =   120
               Y2              =   480
            End
         End
         Begin VB.PictureBox Picture1 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            ForeColor       =   &H80000008&
            Height          =   495
            Index           =   10
            Left            =   360
            ScaleHeight     =   465
            ScaleWidth      =   2505
            TabIndex        =   42
            Top             =   3600
            Width           =   2535
            Begin VB.Label Label1 
               Appearance      =   0  'Flat
               AutoSize        =   -1  'True
               BackColor       =   &H80000005&
               Caption         =   "Sample Workspace on Voronoi"
               ForeColor       =   &H80000008&
               Height          =   195
               Index           =   10
               Left            =   120
               TabIndex        =   43
               Top             =   120
               Width           =   2205
            End
         End
         Begin VB.PictureBox Picture2 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            BorderStyle     =   0  'None
            ForeColor       =   &H80000008&
            Height          =   855
            Index           =   7
            Left            =   1200
            ScaleHeight     =   855
            ScaleWidth      =   735
            TabIndex        =   41
            Top             =   2640
            Width           =   735
            Begin VB.Line Line7 
               Index           =   7
               X1              =   480
               X2              =   480
               Y1              =   120
               Y2              =   480
            End
            Begin VB.Line Line6 
               Index           =   7
               X1              =   480
               X2              =   600
               Y1              =   480
               Y2              =   480
            End
            Begin VB.Line Line5 
               Index           =   7
               X1              =   600
               X2              =   360
               Y1              =   480
               Y2              =   720
            End
            Begin VB.Line Line4 
               Index           =   7
               X1              =   360
               X2              =   120
               Y1              =   720
               Y2              =   480
            End
            Begin VB.Line Line3 
               Index           =   7
               X1              =   120
               X2              =   240
               Y1              =   480
               Y2              =   480
            End
            Begin VB.Line Line2 
               Index           =   7
               X1              =   240
               X2              =   240
               Y1              =   480
               Y2              =   120
            End
            Begin VB.Line Line1 
               Index           =   7
               X1              =   240
               X2              =   480
               Y1              =   120
               Y2              =   120
            End
         End
         Begin VB.PictureBox Picture2 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            BorderStyle     =   0  'None
            ForeColor       =   &H80000008&
            Height          =   855
            Index           =   6
            Left            =   1200
            ScaleHeight     =   855
            ScaleWidth      =   735
            TabIndex        =   40
            Top             =   1080
            Width           =   735
            Begin VB.Line Line1 
               Index           =   6
               X1              =   240
               X2              =   480
               Y1              =   120
               Y2              =   120
            End
            Begin VB.Line Line2 
               Index           =   6
               X1              =   240
               X2              =   240
               Y1              =   480
               Y2              =   120
            End
            Begin VB.Line Line3 
               Index           =   6
               X1              =   120
               X2              =   240
               Y1              =   480
               Y2              =   480
            End
            Begin VB.Line Line4 
               Index           =   6
               X1              =   360
               X2              =   120
               Y1              =   720
               Y2              =   480
            End
            Begin VB.Line Line5 
               Index           =   6
               X1              =   600
               X2              =   360
               Y1              =   480
               Y2              =   720
            End
            Begin VB.Line Line6 
               Index           =   6
               X1              =   480
               X2              =   600
               Y1              =   480
               Y2              =   480
            End
            Begin VB.Line Line7 
               Index           =   6
               X1              =   480
               X2              =   480
               Y1              =   120
               Y2              =   480
            End
         End
         Begin VB.PictureBox Picture1 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            ForeColor       =   &H80000008&
            Height          =   495
            Index           =   9
            Left            =   480
            ScaleHeight     =   465
            ScaleWidth      =   2025
            TabIndex        =   35
            Top             =   480
            Width           =   2055
            Begin VB.Label Label1 
               Appearance      =   0  'Flat
               AutoSize        =   -1  'True
               BackColor       =   &H80000005&
               Caption         =   "Cluster Local Milestones"
               ForeColor       =   &H80000008&
               Height          =   195
               Index           =   9
               Left            =   120
               TabIndex        =   36
               Top             =   120
               Width           =   1710
            End
         End
         Begin VB.PictureBox Picture1 
            Appearance      =   0  'Flat
            BackColor       =   &H80000005&
            ForeColor       =   &H80000008&
            Height          =   495
            Index           =   8
            Left            =   480
            ScaleHeight     =   465
            ScaleWidth      =   2145
            TabIndex        =   33
            Top             =   2040
            Width           =   2175
            Begin VB.Label Label1 
               Appearance      =   0  'Flat
               AutoSize        =   -1  'True
               BackColor       =   &H80000005&
               Caption         =   "Generate Cluster Voronoi"
               ForeColor       =   &H80000008&
               Height          =   195
               Index           =   8
               Left            =   120
               TabIndex        =   34
               Top             =   120
               Width           =   1770
            End
         End
         Begin VB.Label Label3 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "ANALYSIS"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   3
            Left            =   120
            TabIndex        =   37
            Top             =   120
            Width           =   780
         End
      End
      Begin VB.PictureBox Picture4 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   975
         Left            =   480
         ScaleHeight     =   975
         ScaleWidth      =   2175
         TabIndex        =   28
         Top             =   3600
         Width           =   2175
         Begin VB.Line Line9 
            X1              =   1080
            X2              =   0
            Y1              =   0
            Y2              =   480
         End
         Begin VB.Line Line10 
            X1              =   1080
            X2              =   0
            Y1              =   960
            Y2              =   480
         End
         Begin VB.Line Line11 
            X1              =   2160
            X2              =   1080
            Y1              =   480
            Y2              =   960
         End
         Begin VB.Line Line12 
            X1              =   1080
            X2              =   2160
            Y1              =   0
            Y2              =   480
         End
         Begin VB.Label Label4 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "roadmap disjoint?"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   0
            Left            =   480
            TabIndex        =   29
            Top             =   360
            Width           =   1230
         End
      End
      Begin VB.PictureBox Picture2 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   855
         Index           =   3
         Left            =   1200
         ScaleHeight     =   855
         ScaleWidth      =   735
         TabIndex        =   27
         Top             =   2640
         Width           =   735
         Begin VB.Line Line1 
            Index           =   3
            X1              =   240
            X2              =   480
            Y1              =   120
            Y2              =   120
         End
         Begin VB.Line Line2 
            Index           =   3
            X1              =   240
            X2              =   240
            Y1              =   480
            Y2              =   120
         End
         Begin VB.Line Line3 
            Index           =   3
            X1              =   120
            X2              =   240
            Y1              =   480
            Y2              =   480
         End
         Begin VB.Line Line4 
            Index           =   3
            X1              =   360
            X2              =   120
            Y1              =   720
            Y2              =   480
         End
         Begin VB.Line Line5 
            Index           =   3
            X1              =   600
            X2              =   360
            Y1              =   480
            Y2              =   720
         End
         Begin VB.Line Line6 
            Index           =   3
            X1              =   480
            X2              =   600
            Y1              =   480
            Y2              =   480
         End
         Begin VB.Line Line7 
            Index           =   3
            X1              =   480
            X2              =   480
            Y1              =   120
            Y2              =   480
         End
      End
      Begin VB.PictureBox Picture2 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   855
         Index           =   0
         Left            =   1200
         ScaleHeight     =   855
         ScaleWidth      =   735
         TabIndex        =   26
         Top             =   1080
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
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   7
         Left            =   480
         ScaleHeight     =   465
         ScaleWidth      =   2145
         TabIndex        =   22
         Top             =   5640
         Width           =   2175
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Generate Roadmap Edges"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   7
            Left            =   120
            TabIndex        =   23
            Top             =   120
            Width           =   1890
         End
      End
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   6
         Left            =   600
         ScaleHeight     =   465
         ScaleWidth      =   1905
         TabIndex        =   20
         Top             =   2040
         Width           =   1935
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Grow Local Roadmaps"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   6
            Left            =   120
            TabIndex        =   21
            Top             =   120
            Width           =   1620
         End
      End
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   5
         Left            =   240
         ScaleHeight     =   465
         ScaleWidth      =   2625
         TabIndex        =   18
         Top             =   480
         Width           =   2655
         Begin VB.Label Label1 
            Appearance      =   0  'Flat
            AutoSize        =   -1  'True
            BackColor       =   &H80000005&
            Caption         =   "Uniform Sampling on Workspace"
            ForeColor       =   &H80000008&
            Height          =   195
            Index           =   5
            Left            =   120
            TabIndex        =   19
            Top             =   120
            Width           =   2325
         End
      End
      Begin VB.Label Label4 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
         Caption         =   "NO"
         ForeColor       =   &H80000008&
         Height          =   195
         Index           =   2
         Left            =   2040
         TabIndex        =   31
         Top             =   4920
         Width           =   240
      End
      Begin VB.Label Label4 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
         Caption         =   "YES"
         ForeColor       =   &H80000008&
         Height          =   195
         Index           =   1
         Left            =   3000
         TabIndex        =   30
         Top             =   3480
         Width           =   315
      End
      Begin VB.Label Label3 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
         Caption         =   "PROCESSING"
         ForeColor       =   &H80000008&
         Height          =   195
         Index           =   2
         Left            =   120
         TabIndex        =   24
         Top             =   120
         Width           =   1050
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
      TabIndex        =   10
      Top             =   2040
      Width           =   855
      Begin VB.Line Line7 
         Index           =   1
         X1              =   120
         X2              =   480
         Y1              =   240
         Y2              =   240
      End
      Begin VB.Line Line6 
         Index           =   1
         X1              =   480
         X2              =   480
         Y1              =   240
         Y2              =   120
      End
      Begin VB.Line Line5 
         Index           =   1
         X1              =   480
         X2              =   720
         Y1              =   120
         Y2              =   360
      End
      Begin VB.Line Line4 
         Index           =   1
         X1              =   720
         X2              =   480
         Y1              =   360
         Y2              =   600
      End
      Begin VB.Line Line3 
         Index           =   1
         X1              =   480
         X2              =   480
         Y1              =   600
         Y2              =   480
      End
      Begin VB.Line Line2 
         Index           =   1
         X1              =   480
         X2              =   120
         Y1              =   480
         Y2              =   480
      End
      Begin VB.Line Line1 
         Index           =   1
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
      Height          =   2535
      Index           =   0
      Left            =   240
      ScaleHeight     =   2505
      ScaleWidth      =   2865
      TabIndex        =   2
      Top             =   1680
      Width           =   2895
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
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   1
         Left            =   600
         ScaleHeight     =   465
         ScaleWidth      =   1545
         TabIndex        =   5
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
            TabIndex        =   6
            Top             =   120
            Width           =   1260
         End
      End
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   495
         Index           =   2
         Left            =   720
         ScaleHeight     =   465
         ScaleWidth      =   1305
         TabIndex        =   3
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
            TabIndex        =   4
            Top             =   120
            Width           =   960
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
         TabIndex        =   9
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
      Left            =   720
      ScaleHeight     =   1905
      ScaleWidth      =   2385
      TabIndex        =   0
      Top             =   6360
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
         TabIndex        =   1
         Top             =   120
         Width           =   675
      End
   End
   Begin VB.Line Line8 
      X1              =   240
      X2              =   11400
      Y1              =   960
      Y2              =   960
   End
   Begin VB.Label Label2 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      Caption         =   "Path Planning: Hybrid Sampling Approach"
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
      TabIndex        =   12
      Top             =   240
      Width           =   9015
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
      TabIndex        =   11
      Top             =   1200
      Width           =   2460
   End
End
Attribute VB_Name = "Form3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Label5_Click()

End Sub

