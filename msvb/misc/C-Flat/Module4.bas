Attribute VB_Name = "Module4"
Option Explicit
Function _
    DrawArrow( _
        Canvas As PictureBox, _
        X As Integer, _
        Y As Integer, _
        ArrowDir As String, _
        ArrowSize As Integer _
    )

    Select Case LCase(ArrowDir)
        Case "n"
            Canvas.Line (X, Y)-(X - ArrowSize, Y + ArrowSize)
            Canvas.Line (X, Y)-(X + ArrowSize, Y + ArrowSize)
        Case "s"
            Canvas.Line (X, Y)-(X - ArrowSize, Y - ArrowSize)
            Canvas.Line (X, Y)-(X + ArrowSize, Y - ArrowSize)
        Case "e"
            Canvas.Line (X, Y)-(X - ArrowSize, Y - ArrowSize)
            Canvas.Line (X, Y)-(X - ArrowSize, Y + ArrowSize)
        Case "w"
            Canvas.Line (X, Y)-(X + ArrowSize, Y - ArrowSize)
            Canvas.Line (X, Y)-(X + ArrowSize, Y + ArrowSize)
    End Select
    
End Function
Function _
    DrawGrid( _
        Canvas As PictureBox, _
        MinX As Double, _
        MaxX As Double, _
        MinY As Double, _
        MaxY As Double, _
        GridSize As Double, _
        GridColor As Long, _
        AxisColor As Long _
    ) As Integer

    Dim Result As Integer
    Dim DeltaX As Double
    Dim DeltaY As Double
    Dim StartX As Double
    Dim StartY As Double
    Dim NewX As Double
    Dim NewY As Double
    Dim Color As Long
    Dim StartIndex As Integer
    
    'draw vertical lines
    If MaxX > MinX Then
        DeltaX = MaxX - MinX
        StartIndex = Int(MinX / GridSize) + 1 'round up
        StartX = CDbl(StartIndex) * GridSize
        If StartIndex > 0 Then
            Canvas.DrawWidth = 2
            Call DrawArrow(Canvas, 0, Canvas.ScaleHeight / 2, "W", 120)
            Canvas.DrawWidth = 1
        End If
        Do While StartX < MaxX
            NewX = Canvas.ScaleWidth * (StartX - MinX) / DeltaX
            If StartIndex <> 0 Then
                Color = GridColor
                Canvas.DrawWidth = 1
            Else
                Color = AxisColor
                Canvas.DrawWidth = 2
            End If
            Canvas.Line _
                (NewX, Canvas.ScaleHeight)- _
                (NewX, 0), _
                Color
            If StartIndex Mod 5 = 0 Then _
                Canvas.Print Format(CDbl(StartIndex) * GridSize, "0.0")
            StartIndex = StartIndex + 1
            StartX = StartX + GridSize
            Result = Result + 1
        Loop
        If StartIndex - 1 < 0 Then
            Canvas.DrawWidth = 2
            Call _
                DrawArrow( _
                    Canvas, _
                    Canvas.ScaleWidth, _
                    Canvas.ScaleHeight / 2, _
                    "E", _
                    120 _
                )
            Canvas.DrawWidth = 1
        End If
    End If
    
    'draw horizontal lines
    If MaxY > MinY Then
        DeltaY = MaxY - MinY
        StartIndex = Int(MinY / GridSize) + 1 'round up
        StartY = CDbl(StartIndex) * GridSize
        If StartIndex > 0 Then
            Canvas.DrawWidth = 2
            Call _
                DrawArrow( _
                    Canvas, _
                    Canvas.ScaleWidth / 2, _
                    Canvas.ScaleHeight, _
                    "S", _
                    120 _
                )
            Canvas.DrawWidth = 1
        End If
        Do While StartY < MaxY
            NewY = Canvas.ScaleHeight * (1 - (StartY - MinY) / DeltaY)
            If StartIndex <> 0 Then
                Color = GridColor
                Canvas.DrawWidth = 1
            Else
                Color = AxisColor
                Canvas.DrawWidth = 2
            End If
            Canvas.Line _
                (Canvas.ScaleWidth, NewY)- _
                (0, NewY), _
                Color
            If StartIndex Mod 5 = 0 Then _
                Canvas.Print Format(CDbl(StartIndex) * GridSize, "0.0")
            StartIndex = StartIndex + 1
            StartY = StartY + GridSize
            Result = Result + 1
        Loop
        If StartIndex - 1 < 0 Then
            Canvas.DrawWidth = 2
            Call DrawArrow(Canvas, Canvas.ScaleWidth / 2, 0, "N", 120)
            Canvas.DrawWidth = 1
        End If
    End If
    
    DrawGrid = Result
    
End Function
Function _
    Graph( _
        Canvas As PictureBox, _
        Expression As String, _
        ParamStack As ListBox, _
        OpStack As ListBox, _
        BufStack As ListBox, _
        NameList As ListBox, _
        ValList As ListBox, _
        Polar As Boolean, _
        MinG As Double, _
        MaxG As Double, _
        ResG As Double, _
        MinX As Double, _
        MaxX As Double, _
        MinY As Double, _
        MaxY As Double, _
        Color As Long _
    )

    Dim i As Double
    Dim DeltaX As Double
    Dim DeltaY As Double
    Dim InVar As String
    Dim OutVar As String
    Dim InVal As Double
    Dim OutVal As Double
    Dim Result As String
    Dim NewX As Double
    Dim NewY As Double
    Dim DrawNext As Boolean
    
    DeltaX = CDbl(MaxX) - CDbl(MinX)
    DeltaY = CDbl(MaxY) - CDbl(MinY)
    If Not Polar Then
        InVar = "x"
        OutVar = "y"
    Else
        InVar = "a"
        OutVar = "r"
    End If
    For i = CDbl(MinG) To CDbl(MaxG) Step CDbl(ResG)
        InVal = i
        Call VarSet(NameList, ValList, InVar, InVal)
        Result = _
            Evaluate( _
                Expression, _
                ParamStack, _
                OpStack, _
                BufStack, _
                NameList, _
                ValList, _
                False _
            )
        If Not IsError(Result) Then
            OutVal = VarGet(NameList, ValList, OutVar)
            If Not Polar Then
                NewX = InVal
                NewY = OutVal
            Else
                NewX = OutVal * Cos(InVal)
                NewY = OutVal * Sin(InVal)
            End If
            If _
                NewX >= MinX And _
                NewX <= MaxX And _
                NewY >= MinY And _
                NewY <= MaxY _
            Then
                NewX = Canvas.ScaleWidth * (NewX - MinX) / DeltaX
                NewY = Canvas.ScaleHeight * (1 - (NewY - MinY) / DeltaY)
                If DrawNext Then _
                    Canvas.Line _
                        (Canvas.CurrentX, Canvas.CurrentY)- _
                        (NewX, NewY), _
                        Color
                Canvas.CurrentX = NewX
                Canvas.CurrentY = NewY
                DrawNext = True
            Else
                DrawNext = False 'out of bounds
            End If
        Else
            DrawNext = False 'error
        End If
        DoEvents
    Next i
    
End Function
