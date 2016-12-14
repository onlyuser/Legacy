Attribute VB_Name = "Module3"
Option Explicit

Public Const PI As Double = 3.14159265358979
Function Min(a As Variant, b As Variant) As Variant

    If a < b Then
        Min = a
    Else
        Min = b
    End If
    
End Function
Function Max(a As Variant, b As Variant) As Variant

    If a > b Then
        Max = a
    Else
        Max = b
    End If
    
End Function
Function toRad(angle As Double) As Double

    toRad = angle * PI / 180
    
End Function
Function GenRandomVec(cnt As Long)

    Randomize
    Dim i As Long
    For i = 1 To cnt
        Call AddPoint(Rnd, Rnd)
    Next i
    
End Function
Function GenRandomEdge(cnt As Long)

    Randomize
    Dim i As Long
    For i = 1 To cnt
        Call AddEdge(AddPoint(Rnd, Rnd), AddPoint(Rnd, Rnd))
    Next i
    
End Function
Function AddTri(p1 As Point2d, p2 As Point2d, p3 As Point2d)

    Dim idx(2) As Long
    idx(0) = AddPoint(p1.x, p1.y)
    idx(1) = AddPoint(p2.x, p2.y)
    idx(2) = AddPoint(p3.x, p3.y)
    Dim i As Integer
    For i = 0 To UBound(idx)
        Call AddEdge(idx(i), idx((i + 1) Mod (UBound(idx) + 1)))
    Next i
    
End Function
Function AddQuad(p1 As Point2d, p2 As Point2d)

    Dim idx(3) As Long
    idx(0) = AddPoint(p1.x, p1.y)
    idx(1) = AddPoint(p2.x, p1.y)
    idx(2) = AddPoint(p2.x, p2.y)
    idx(3) = AddPoint(p1.x, p2.y)
    Dim i As Integer
    For i = 0 To UBound(idx)
        Call AddEdge(idx(i), idx((i + 1) Mod (UBound(idx) + 1)))
    Next i
    
End Function
Function AddCircle(p As Point2d, radius As Double, pStep As Integer, phase As Double)

    Dim idx() As Long
    ReDim idx(pStep - 1)
    Dim i As Integer
    For i = 0 To UBound(idx)
        Dim angle As Double
        angle = toRad(CSng(360) * i / (UBound(idx) + 1)) + phase
        idx(i) = AddPoint(p.x + radius * Cos(angle), p.y + radius * Sin(angle))
    Next i
    Dim j As Integer
    For j = 0 To UBound(idx)
        Call AddEdge(idx(j), idx((j + 1) Mod (UBound(idx) + 1)))
    Next j
    
End Function
