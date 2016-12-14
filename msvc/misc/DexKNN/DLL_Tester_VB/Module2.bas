Attribute VB_Name = "Module2"
Option Explicit

Const PATH_WIDTH As Long = 2

Public Type Point2d
    x As Double
    y As Double
End Type
Public Type Edge
    a As Long
    b As Long
End Type

'delaunay
Public mVecList() As Point2d
Public mVecArr() As Double
Public mEdgeList() As Edge
Public mEdgeArr() As Long

'voronoi
Public m_vVecList() As Point2d
Public m_vVecArr() As Double
Public m_vEdgeList() As Edge
Public m_vEdgeArr() As Long

'free
Public mPathIdxCnt As Long
Public mPathIdxArr() As Long
Public mFreeIdxCnt As Long
Public mFreeIdxArr() As Long
Function ResetMap()

    'delaunay
    ReDim mVecList(0)
    ReDim mVecArr(0)
    ReDim mEdgeList(0)
    ReDim mEdgeArr(0)
    
    'voronoi
    ReDim m_vVecList(0)
    ReDim m_vVecArr(0)
    ReDim m_vEdgeList(0)
    ReDim m_vEdgeArr(0)
    
    'roadmap
    mPathIdxCnt = 0
    ReDim mPathIdxArr(0)
    mFreeIdxCnt = 0
    ReDim mFreeIdxArr(0)
    
End Function
Function AddPoint(x As Double, y As Double) As Long

    Dim idx As Long
    idx = UBound(mVecList) + 1
    ReDim Preserve mVecList(idx)
    mVecList(idx).x = x
    mVecList(idx).y = y
    AddPoint = idx
    
End Function
Function AddEdge(a As Long, b As Long) As Long

    Dim idx As Long
    idx = UBound(mEdgeList) + 1
    ReDim Preserve mEdgeList(idx)
    mEdgeList(idx).a = a
    mEdgeList(idx).b = b
    AddEdge = idx
    
End Function
Function CacheMap()

    If UBound(mVecList) > 0 Then
        ReDim mVecArr(UBound(mVecList) * 2 - 1)
    Else
        ReDim mVecArr(0)
    End If
    Dim i As Long
    For i = 1 To UBound(mVecList)
        mVecArr((i - 1) * 2 + 0) = mVecList(i).x
        mVecArr((i - 1) * 2 + 1) = mVecList(i).y
    Next i
    
End Function
Function SyncMap()

    ReDim mEdgeList((UBound(mEdgeArr) + 1) * 0.5)
    Dim i As Long
    For i = 1 To UBound(mEdgeList)
        mEdgeList(i).a = mEdgeArr((i - 1) * 2 + 0) + 1
        mEdgeList(i).b = mEdgeArr((i - 1) * 2 + 1) + 1
    Next i
    ReDim m_vVecList((UBound(m_vVecArr) + 1) * 0.5)
    Dim j As Long
    For j = 1 To UBound(m_vVecList)
        m_vVecList(j).x = m_vVecArr((j - 1) * 2 + 0)
        m_vVecList(j).y = m_vVecArr((j - 1) * 2 + 1)
    Next j
    ReDim m_vEdgeList((UBound(m_vEdgeArr) + 1) * 0.5)
    Dim k As Long
    For k = 1 To UBound(m_vEdgeList)
        m_vEdgeList(k).a = m_vEdgeArr((k - 1) * 2 + 0) + 1
        m_vEdgeList(k).b = m_vEdgeArr((k - 1) * 2 + 1) + 1
    Next k
    ReDim mVecList((UBound(mVecArr) + 1) * 0.5)
    Dim n As Long
    For n = 1 To UBound(mVecList)
        mVecList(n).x = mVecArr((n - 1) * 2 + 0)
        mVecList(n).y = mVecArr((n - 1) * 2 + 1)
    Next n
    
End Function
Function DrawMap(Pic As PictureBox, radius As Long)

    'delaunay
    Pic.ForeColor = vbBlue
    Dim i As Long
    For i = 1 To UBound(mEdgeList)
        Call DrawEdge(Pic, mVecList(mEdgeList(i).a), mVecList(mEdgeList(i).b), "")
    Next i
    Dim j As Long
    For j = 1 To UBound(mVecList)
        Call DrawPoint(Pic, mVecList(j), radius, "v" & CStr(j - 1))
    Next j
    
    'voronoi
    Pic.ForeColor = vbRed
    Dim k As Long
    For k = 1 To UBound(m_vEdgeList)
        Call DrawEdge( _
            Pic, m_vVecList(m_vEdgeList(k).a), m_vVecList(m_vEdgeList(k).b), "e" & CStr(k - 1) _
            )
    Next k
    Dim n As Long
    For n = 1 To UBound(m_vVecList)
        Call DrawPoint(Pic, m_vVecList(n), radius, "")
    Next n
    
    'roadmap
    Pic.DrawWidth = PATH_WIDTH
    Pic.ForeColor = vbYellow
    Dim s As Long
    For s = 0 To mFreeIdxCnt - 1
        Call DrawEdge( _
            Pic, _
            mVecList(mEdgeList(mFreeIdxArr(s) + 1).a), _
            mVecList(mEdgeList(mFreeIdxArr(s) + 1).b), _
            "" _
            )
    Next s
    Pic.ForeColor = vbMagenta
    Dim t As Long
    For t = 0 To mPathIdxCnt - 2
        Call DrawEdge( _
            Pic, _
            mVecList(mPathIdxArr(t) + 1), _
            mVecList(mPathIdxArr(t + 1) + 1), _
            "" _
            )
    Next t
    Pic.DrawWidth = 1
    
End Function
Function DrawEdge(Pic As PictureBox, PointA As Point2d, PointB As Point2d, Tag As String)

    Pic.Line _
        (PointA.x * Pic.ScaleWidth, PointA.y * Pic.ScaleHeight)- _
        (PointB.x * Pic.ScaleWidth, PointB.y * Pic.ScaleHeight)
    Pic.CurrentX = (PointA.x + PointB.x) * 0.5 * Pic.ScaleWidth
    Pic.CurrentY = (PointA.y + PointB.y) * 0.5 * Pic.ScaleHeight
    Pic.Print Tag
    
End Function
Function DrawPoint(Pic As PictureBox, Point As Point2d, radius As Long, Tag As String)

    Pic.Circle (Point.x * Pic.ScaleWidth, Point.y * Pic.ScaleHeight), radius
    Pic.CurrentX = Point.x * Pic.ScaleWidth + radius * 0.5
    Pic.CurrentY = Point.y * Pic.ScaleHeight + radius * 0.5
    Pic.Print Tag
    
End Function
