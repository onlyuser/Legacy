Attribute VB_Name = "Module2"
Option Explicit

Public Const mFoldMax As Single = 5

Public Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long

Public TallyV As New Collection
Public TallyH As New Collection
Public TallyV2 As New Collection
Public TallyH2 As New Collection
Function DrawGrids(Canvas As PictureBox, DivCount As Long)

    Dim i As Long
    Dim GridX As Long
    Dim GridY As Long
    Dim X As Long
    Dim Y As Long
    
    GridX = Canvas.ScaleWidth / DivCount
    GridY = Canvas.ScaleHeight / DivCount
    Canvas.DrawStyle = vbDot
    For i = 1 To DivCount
        X = i * GridX
        Y = i * GridY
        Canvas.Line (X, 0)-(X, Canvas.ScaleHeight)
        Canvas.Line (0, Y)-(Canvas.ScaleWidth, Y)
    Next i
    Canvas.DrawStyle = vbSolid
    
End Function
Function MaxImage(Canvas As PictureBox, ColorA As Long, ColorB As Long)

    Dim i As Long
    Dim j As Long
    Dim X As Long
    Dim Y As Long
    Dim Width As Long
    Dim Height As Long
    
    'approach from TOP
    For i = 0 To Canvas.ScaleHeight - 1
        For j = 0 To Canvas.ScaleWidth - 1
            If Canvas.Point(j, i) = ColorA Then
                Y = i
                i = mBigNumber
                j = mBigNumber
            Else
                Canvas.PSet (j, i), ColorB
            End If
            DoEvents
        Next j
    Next i
    If i <> mBigNumber + 1 Then
        Call Canvas.Cls
        Exit Function
    End If
    'approach from BOTTOM
    For i = Canvas.ScaleHeight - 1 To 0 Step -1
        For j = 0 To Canvas.ScaleWidth - 1
            If Canvas.Point(j, i) = ColorA Then
                Height = i - Y + 1
                i = -1
                j = mBigNumber
            Else
                Canvas.PSet (j, i), ColorB
            End If
            DoEvents
        Next j
    Next i
    'approach from LEFT
    For i = 0 To Canvas.ScaleWidth - 1
        For j = 0 To Canvas.ScaleHeight - 1
            If Canvas.Point(i, j) = ColorA Then
                X = i
                i = mBigNumber
                j = mBigNumber
            Else
                Canvas.PSet (i, j), ColorB
            End If
            DoEvents
        Next j
    Next i
    'approach from RIGHT
    For i = Canvas.ScaleWidth - 1 To 0 Step -1
        For j = 0 To Canvas.ScaleHeight - 1
            If Canvas.Point(i, j) = ColorA Then
                Width = i - X + 1
                i = -1
                j = mBigNumber
            Else
                Canvas.PSet (i, j), ColorB
            End If
            DoEvents
        Next j
    Next i
    Call StretchBlt( _
        Canvas.hdc, 0, 0, Canvas.ScaleWidth, Canvas.ScaleHeight, _
        Canvas.hdc, X, Y, Width, Height, _
        vbSrcCopy _
    )
    Call CopyImage(Canvas, Canvas, ColorB, vbBlack)
    
End Function
Function CopyImage(CanvasA As PictureBox, CanvasB As PictureBox, ColorA As Long, ColorB As Long)

    Dim i As Long
    Dim j As Long
    
    For i = 0 To CanvasA.ScaleHeight - 1
        For j = 0 To CanvasA.ScaleWidth - 1
            If CanvasA.Point(j, i) = ColorA Then _
                CanvasB.PSet (j, i), ColorB
        Next j
    Next i
    
End Function
Function TallyImage(Canvas As PictureBox, DivCount As Long, EdgeV As PictureBox, EdgeH As PictureBox)

    Dim i As Long
    Dim j As Long
    Dim GridX As Long
    Dim GridY As Long
    Dim X As Long
    Dim Y As Long
    Dim Count As Long
    Dim Count2 As Long
    
    Call ListClear(TallyV)
    Call ListClear(TallyH)
    Call ListClear(TallyV2)
    Call ListClear(TallyH2)
    If DivCount <> 0 Then
        GridX = Canvas.ScaleWidth / DivCount
        GridY = Canvas.ScaleHeight / DivCount
    End If
    For i = 0 To DivCount - 1
        X = i * GridX
        Y = i * GridY
        'perform horizontal scan
        Count = 0
        Count2 = 0
        For j = 0 To Canvas.ScaleWidth - 1
            If Canvas.Point(j, Y) <> vbBlack Then _
                Count = Count + 1
            If j = 0 Then
                Count2 = Count
            Else
                If _
                    Canvas.Point(j - 1, Y) = vbBlack And _
                    Canvas.Point(j, Y) <> vbBlack _
                Then _
                    Count2 = Count2 + 1
            End If
        Next j
        Call TallyH.Add(Count)
        Call TallyH2.Add(Count2)
        EdgeV.CurrentX = 0
        EdgeV.CurrentY = Y
        EdgeV.Print Count2
        'perform vertical scan
        Count = 0
        Count2 = 0
        For j = 0 To Canvas.ScaleHeight - 1
            If Canvas.Point(X, j) <> vbBlack Then _
                Count = Count + 1
            If j = 0 Then
                Count2 = Count
            Else
                If _
                    Canvas.Point(X, j - 1) = vbBlack And _
                    Canvas.Point(X, j) <> vbBlack _
                Then _
                    Count2 = Count2 + 1
            End If
        Next j
        Call TallyV.Add(Count)
        Call TallyV2.Add(Count2)
        EdgeH.CurrentX = X
        EdgeH.CurrentY = 0
        EdgeH.Print Count2
    Next i
    Call VectorNormalize(TallyV)
    Call VectorNormalize(TallyH)
    Call VectorScale(TallyV2, 1 / mFoldMax)
    Call VectorScale(TallyH2, 1 / mFoldMax)
    
End Function
Function VectorNormalize(Vector As Collection)

    Dim i As Long
    Dim Max As Single
    Dim Min As Single
    Dim Diff As Single
    
    Max = 0
    Min = mBigNumber
    For i = 1 To Vector.Count
        If Vector.Item(i) > Max Then _
            Max = Vector.Item(i)
        If Vector.Item(i) < Min Then _
            Min = Vector.Item(i)
    Next i
    Diff = Max - Min
    For i = 1 To Vector.Count
        If Diff <> 0 Then
            Call Vector.Add((CSng(Vector.Item(1)) - Min) / Diff)
        Else
            Call Vector.Add(0)
        End If
        Call Vector.Remove(1)
    Next i
    
End Function
Function VectorScale(Vector As Collection, Ratio As Single)

    Dim i As Long
    
    For i = 1 To Vector.Count
        Call Vector.Add(CSng(Vector.Item(1)) * Ratio)
        Call Vector.Remove(1)
    Next i
    
End Function
Function BuildData() As String

    Dim Result As String
    
    Result = _
        ListPrint(TallyV) & "," & _
        ListPrint(TallyH) & "," & _
        ListPrint(TallyV2) & "," & _
        ListPrint(TallyH2)
    BuildData = Result
    
End Function
Function AugData(Text As String) As String

    Dim Result As String
    Dim Count As Long
    
    If Left(Text, 1) <> ":" Then
        Count = Asc(Left(Text, 1)) - Asc("A")
        Result = Text & "," & EditRepeat("0,", Count) & "1," & EditRepeat("0,", 26 - Count - 1)
    Else
        Result = Text & "," & EditRepeat("0,", 26)
        Result = Right(Result, Len(Result) - 1)
    End If
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - 1)
    AugData = Result
    
End Function
