Attribute VB_Name = "Module6"
Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Declare Function DrawEdge Lib "user32" (ByVal hDC As Long, qrc As RECT, ByVal Edge As Long, ByVal grfFlags As Long) As Long

Public Const BDR_INNER = &HC
Public Const BDR_OUTER = &H3
Public Const BDR_RAISED = &H5
Public Const BDR_RAISEDINNER = &H4
Public Const BDR_RAISEDOUTER = &H1
Public Const BDR_SUNKEN = &HA
Public Const BDR_SUNKENINNER = &H8
Public Const BDR_SUNKENOUTER = &H2

Public Const BF_ADJUST = &H2000   ' Calculate the space left over.
Public Const BF_BOTTOM = &H8
Public Const BF_DIAGONAL = &H10
Public Const BF_FLAT = &H4000     ' For flat rather than 3-D borders.
Public Const BF_LEFT = &H1
Public Const BF_MIDDLE = &H800    ' Fill in the middle.
Public Const BF_MONO = &H8000     ' For monochrome borders.
Public Const BF_RIGHT = &H4
Public Const BF_SOFT = &H1000     ' Use for softer buttons.
Public Const BF_TOP = &H2

Public Const BF_BOTTOMLEFT = (BF_BOTTOM Or BF_LEFT)
Public Const BF_BOTTOMRIGHT = (BF_BOTTOM Or BF_RIGHT)
Public Const BF_DIAGONAL_ENDBOTTOMLEFT = (BF_DIAGONAL Or BF_BOTTOM Or BF_LEFT)
Public Const BF_DIAGONAL_ENDBOTTOMRIGHT = (BF_DIAGONAL Or BF_BOTTOM Or BF_RIGHT)
Public Const BF_DIAGONAL_ENDTOPLEFT = (BF_DIAGONAL Or BF_TOP Or BF_LEFT)
Public Const BF_DIAGONAL_ENDTOPRIGHT = (BF_DIAGONAL Or BF_TOP Or BF_RIGHT)
Public Const BF_RECT = (BF_LEFT Or BF_TOP Or BF_RIGHT Or BF_BOTTOM)
Public Const BF_TOPLEFT = (BF_TOP Or BF_LEFT)
Public Const BF_TOPRIGHT = (BF_TOP Or BF_RIGHT)

Public Const EDGE_BUMP = (BDR_RAISEDOUTER Or BDR_SUNKENINNER)
Public Const EDGE_ETCHED = (BDR_SUNKENOUTER Or BDR_RAISEDINNER)
Public Const EDGE_RAISED = (BDR_RAISEDOUTER Or BDR_RAISEDINNER)
Public Const EDGE_SUNKEN = (BDR_SUNKENOUTER Or BDR_SUNKENINNER)
Function DrawFrame(hDC&, Left!, Top!, Width!, Height!, Style%, Margin%)

    Dim Frame As RECT
    Dim Edge&
    
    Frame.Left = (Left + Margin) / Screen.TwipsPerPixelX
    Frame.Top = (Top + Margin) / Screen.TwipsPerPixelY
    Frame.Right = ((Left + Width) - Margin) / Screen.TwipsPerPixelX
    Frame.Bottom = ((Top + Height) - Margin) / Screen.TwipsPerPixelY

    If Style = 1 Then Edge = EDGE_RAISED
    If Style = 2 Then Edge = EDGE_SUNKEN
    If Style = 3 Then Edge = EDGE_ETCHED
    If Style = 4 Then Edge = EDGE_BUMP
    
    Call DrawEdge(hDC, Frame, Edge, BF_RECT)

End Function
