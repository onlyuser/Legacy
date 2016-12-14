VERSION 5.00
Begin VB.Form Form4 
   Caption         =   "Form4"
   ClientHeight    =   3190
   ClientLeft      =   110
   ClientTop       =   570
   ClientWidth     =   4680
   LinkTopic       =   "Form4"
   ScaleHeight     =   3190
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.Menu mnuGrapher 
      Caption         =   "Grapher"
      Begin VB.Menu mnuGrapherOption 
         Caption         =   "Graph"
         Index           =   0
      End
      Begin VB.Menu mnuGrapherOption 
         Caption         =   "Edit"
         Index           =   1
      End
      Begin VB.Menu mnuGrapherOption 
         Caption         =   "Remove"
         Index           =   2
      End
   End
End
Attribute VB_Name = "Form4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub mnuClear_Click()

    Me.Tag = mnuClear.Caption
    
End Sub
Private Sub mnuGrapherOption_Click(Index As Integer)

    Me.Tag = mnuGrapherOption(Index).Caption
    
End Sub
