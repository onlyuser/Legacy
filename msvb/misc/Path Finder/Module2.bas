Attribute VB_Name = "Module2"
Option Explicit

Const BigNumber As Integer = 32767
Const pi As Single = 3.14159
Const DefSize As Single = 80
Const SpikeScale As Single = 5
Const DefSpeed As Single = 0.5
Const DefSpin As Single = 5 * pi / 180
Const CollRadius As Single = 5
Const FearRadius As Single = 15
Const Margin As Single = 5
Const MaxLineLen = 50
Const MaxWayPoints = 25

Public Type Vector
    X As Single
    Y As Single
End Type

Type Entity
    Auto As Boolean
    Pos As Vector
    Angle As Single
    Speed As Single
    Spin As Single
    DestAngle As Single
    Target As Vector
    Towards As Boolean
    LockPos As Boolean
    ForeColor As Long
    BackColor As Long
    WayPoint As Integer
    CurWayPoint As Integer
    CurGoalPos As Vector
End Type

Type WayPoint
    Pos As Vector
    NextIndex As New Collection
    PrevIndex As Integer
End Type

Type Wall
    A As Integer
    B As Integer
End Type

Type Color
    R As Integer
    G As Integer
    B As Integer
End Type

Dim mEntityList() As Entity
Dim mWayPointList() As WayPoint
Dim mWallList() As Wall
Public WorldDim As Vector
Public GoalPos As Vector
Function VectorInput(X As Single, Y As Single) As Vector

    Dim Result As Vector
    
    Result.X = X
    Result.Y = Y
    VectorInput = Result
    
End Function
Function VtoA(Pos As Vector) As Single

    Dim Result As Single
    Dim LeftHalf As Integer
    Dim BtmHalf As Integer
    Dim UnitAngle As Single
    
    LeftHalf = Sgn(1 - Sgn(Pos.X))
    BtmHalf = Sgn(1 - Sgn(Pos.Y))
    If Pos.X <> 0 Then
        UnitAngle = Atn(Pos.Y / Pos.X)
        Result = _
            (0 * pi + UnitAngle) * (1 - LeftHalf) * (1 - BtmHalf) + _
            (1 * pi + UnitAngle) * LeftHalf + _
            (2 * pi + UnitAngle) * (1 - LeftHalf) * BtmHalf
        Result = Result * 180 / pi
        Result = (Result + 360) Mod 360
        Result = Result * pi / 180
    Else
        If Pos.Y > 0 Then
            Result = pi * 0.5
        Else
            Result = pi * 1.5
        End If
    End If
    VtoA = Result
    
End Function
Function AtoV(Angle As Single, Optional Length As Single = 1) As Vector

    Dim Result As Vector
    
    Result.X = Cos(Angle) * Length
    Result.Y = Sin(Angle) * Length
    AtoV = Result
    
End Function
Function Init(Width As Single, Height As Single, WallCount As Integer, EntityCount As Integer)

    Dim i As Integer
    Dim PosA As Vector
    Dim PosB As Vector
    Dim Index As Integer
    Dim Alpha As Single
    
    Call Randomize
    ReDim mEntityList(0)
    ReDim mWayPointList(0)
    ReDim mWallList(WallCount + 4)
    For i = 1 To WallCount
        Do
            PosA = VectorInput(Rnd * Width, Rnd * Height)
            PosB = VectorInput(Rnd * Width, Rnd * Height)
        Loop Until VectorDistance(PosA, PosB) < MaxLineLen
        mWallList(i).A = AddEntity(PosA)
        mWallList(i).B = AddEntity(PosB)
    Next i
    mWallList(WallCount + 1).A = AddEntity(VectorInput(0 * Width + Margin, 0 * Height + Margin))
    mWallList(WallCount + 2).A = AddEntity(VectorInput(1 * Width - Margin, 0 * Height + Margin))
    mWallList(WallCount + 3).A = AddEntity(VectorInput(1 * Width - Margin, 1 * Height - Margin))
    mWallList(WallCount + 4).A = AddEntity(VectorInput(0 * Width + Margin, 1 * Height - Margin))
    mWallList(WallCount + 1).B = mWallList(WallCount + 2).A
    mWallList(WallCount + 2).B = mWallList(WallCount + 3).A
    mWallList(WallCount + 3).B = mWallList(WallCount + 4).A
    mWallList(WallCount + 4).B = mWallList(WallCount + 1).A
    WorldDim.X = Width
    WorldDim.Y = Height
    For i = 1 To EntityCount
        Index = AddEntity(VectorInput(Rnd * Width, Rnd * Height))
        mEntityList(Index).Auto = True
        mEntityList(Index).Angle = Rnd * 2 * pi
        'mEntityList(Index).Speed = Rnd * DefSpeed
        mEntityList(Index).Speed = DefSpeed * 0.25
        Alpha = mEntityList(Index).Speed / DefSpeed
        mEntityList(Index).ForeColor = _
            LongByColor(ColorInterp(ColorByLong(vbCyan), ColorByLong(vbRed), Alpha))
        mEntityList(Index).BackColor = vbBlue
    Next i
    
End Function
Function AddEntity(Pos As Vector) As Integer

    Dim Result As Integer
    
    Result = UBound(mEntityList) + 1
    ReDim Preserve mEntityList(Result)
    mEntityList(Result).Pos.X = Pos.X
    mEntityList(Result).Pos.Y = Pos.Y
    AddEntity = Result
    
End Function
Function AddWayPoint(Pos As Vector) As Integer

    Dim Result As Integer
    
    Result = UBound(mWayPointList) + 1
    ReDim Preserve mWayPointList(Result)
    mWayPointList(Result).Pos.X = Pos.X
    mWayPointList(Result).Pos.Y = Pos.Y
    AddWayPoint = Result
    
End Function
Function Draw(Canvas As PictureBox, Optional DrawWalls As Boolean, Optional DrawWayPoints As Boolean)

    Dim i As Integer
    Dim Item As Variant
    Dim NewDim As Vector
    Dim PosA As Vector
    Dim PosB As Vector
    Dim Distance As Single
    Dim CurItem As Integer
    
    NewDim.X = Canvas.ScaleWidth
    NewDim.Y = Canvas.ScaleHeight
    If DrawWalls Then
        Canvas.DrawWidth = 2
        For i = 1 To UBound(mWallList)
            PosA = mEntityList(mWallList(i).A).Pos
            PosB = mEntityList(mWallList(i).B).Pos
            PosA = VectorMap(PosA, WorldDim, NewDim)
            PosB = VectorMap(PosB, WorldDim, NewDim)
            Canvas.Line (PosA.X, PosA.Y)-(PosB.X, PosB.Y), vbWhite
        Next i
        Canvas.DrawWidth = 1
    End If
    For i = 1 To UBound(mEntityList)
        If mEntityList(i).Auto Then
            PosA = mEntityList(i).Pos
            Distance = VectorDistance(mEntityList(i).Pos, mEntityList(i).Target)
            'PosB = VectorUpdate(mEntityList(i).Pos, mEntityList(i).Angle, mEntityList(i).Speed * SpikeScale)
            PosB = VectorUpdate(mEntityList(i).Pos, mEntityList(i).Angle, Distance)
            PosA = VectorMap(PosA, WorldDim, NewDim)
            PosB = VectorMap(PosB, WorldDim, NewDim)
            
            Canvas.Circle (PosA.X, PosA.Y), DefSize, mEntityList(i).BackColor
            Canvas.Line (PosA.X, PosA.Y)-(PosB.X, PosB.Y), mEntityList(i).ForeColor
        End If
    Next i
    If DrawWayPoints Then
        For i = 1 To UBound(mWayPointList)
            PosA = mWayPointList(i).Pos
            PosA = VectorMap(PosA, WorldDim, NewDim)
            Canvas.Circle (PosA.X, PosA.Y), DefSize, vbRed
            Canvas.Print i
            For Each Item In mWayPointList(i).NextIndex
                CurItem = CInt(Item)
                PosB = mWayPointList(CurItem).Pos
                PosB = VectorMap(PosB, WorldDim, NewDim)
                Canvas.Line (PosA.X, PosA.Y)-(PosB.X, PosB.Y), vbRed
            Next Item
        Next i
        For i = 1 To UBound(mEntityList)
            If mEntityList(i).Auto Then
                PosA = mEntityList(i).Pos
                PosB = mWayPointList(mEntityList(i).CurWayPoint).Pos
                PosA = VectorMap(PosA, WorldDim, NewDim)
                PosB = VectorMap(PosB, WorldDim, NewDim)
                Canvas.DrawStyle = vbDot
                Canvas.Line (PosA.X, PosA.Y)-(PosB.X, PosB.Y), vbMagenta
                Canvas.DrawStyle = vbSolid
                Canvas.Circle (PosB.X, PosB.Y), DefSize, vbYellow
            End If
        Next i
    End If
    
End Function
Function VectorMap(Pos As Vector, MaxA As Vector, MaxB As Vector) As Vector

    Dim Result As Vector
    
    Result.X = MaxB.X * Pos.X / MaxA.X
    Result.Y = MaxB.Y * Pos.Y / MaxA.Y
    VectorMap = Result
    
End Function
Function Update()

    Dim i As Integer
    Dim Distance As Single
    Dim PrepLock As Boolean
    Dim Index As Integer
    Dim Index2 As Integer
    Dim Index3 As Integer
    
    For i = 1 To UBound(mEntityList)
        If mEntityList(i).Auto Then
            Distance = CastRay(mEntityList(i).Pos, GoalPos)
            If Distance = -1 Then
                mEntityList(i).CurGoalPos = GoalPos
            Else
                Index = CheckWayPoints(mEntityList(i).WayPoint, GoalPos)
                If Index = 0 Then
                    mEntityList(i).CurGoalPos = GoalPos
                Else
                    Index2 = CheckWayPoints(mEntityList(i).WayPoint, mEntityList(i).Pos)
                    If Index2 = Index Then
                        Index3 = Index2
                    Else
                        Index3 = IsChild(Index, Index2)
                        If Index3 <> 0 Then
                            Index3 = mWayPointList(Index2).NextIndex.Item(Index3)
                        Else
                            Index3 = mWayPointList(Index2).PrevIndex
                        End If
                        Distance = CastRay(mEntityList(i).Pos, mWayPointList(Index3).Pos)
                        If Distance <> -1 Then _
                            Index3 = Index2
                    End If
                    mEntityList(i).CurGoalPos = mWayPointList(Index3).Pos
                End If
            End If
            
            Distance = CastRay(mEntityList(i).Pos, mEntityList(i).CurGoalPos)
            If Distance = -1 Then
                mEntityList(i).Target = mEntityList(i).CurGoalPos
                mEntityList(i).LockPos = False
                mEntityList(i).Towards = True
            Else
                If Not mEntityList(i).LockPos Then
                    mEntityList(i).Target = _
                        GetTarget( _
                            mEntityList(i).Pos, _
                            mEntityList(i).Angle - pi / 2, _
                            mEntityList(i).Angle + pi / 2 _
                        )
                    Distance = VectorDistance(mEntityList(i).Pos, mEntityList(i).Target)
                    If Distance > FearRadius Then
                        mEntityList(i).Target = _
                            GetTarget( _
                                mEntityList(i).Pos, _
                                mEntityList(i).Angle - pi / 6, _
                                mEntityList(i).Angle + pi / 6, _
                                False _
                            )
                        mEntityList(i).Towards = True
                    Else
                        If Distance < CollRadius Then _
                            PrepLock = True
                        mEntityList(i).Towards = False
                    End If
                End If
            End If
            
            If UBound(mWayPointList) > MaxWayPoints Then
                Call ResetWayPoints
            Else
                Index = CheckWayPoints(mEntityList(i).WayPoint, mEntityList(i).Pos)
                If Index = 0 Then
                    Index = AddWayPoint(mEntityList(i).Pos)
                    If mEntityList(i).CurWayPoint <> 0 Then
                        Call mWayPointList(mEntityList(i).CurWayPoint).NextIndex.Add(Index)
                        mWayPointList(Index).PrevIndex = mEntityList(i).CurWayPoint
                    Else
                        mEntityList(i).WayPoint = Index
                    End If
                End If
                mEntityList(i).CurWayPoint = Index
            End If
            
            If Not mEntityList(i).LockPos Then
                mEntityList(i).Pos = VectorUpdate(mEntityList(i).Pos, mEntityList(i).Angle, mEntityList(i).Speed)
                mEntityList(i).Pos = VectorBound(mEntityList(i).Pos, WorldDim)
                
                mEntityList(i).DestAngle = _
                    VectorAngle(mEntityList(i).Pos, mEntityList(i).Target)
                If PrepLock Then
                    PrepLock = False
                    mEntityList(i).LockPos = True
                End If
            End If
            mEntityList(i).Spin = _
                GetDir(mEntityList(i).Angle, mEntityList(i).DestAngle, mEntityList(i).Towards) * DefSpin
            If mEntityList(i).LockPos Then
                If AngleDiff(mEntityList(i).Angle, mEntityList(i).DestAngle) > (pi - DefSpin / 2) Then _
                    mEntityList(i).LockPos = False
            End If
            mEntityList(i).Angle = mEntityList(i).Angle + mEntityList(i).Spin
            If mEntityList(i).Angle > 2 * pi Then _
                mEntityList(i).Angle = mEntityList(i).Angle - 2 * pi
            If mEntityList(i).Angle < 0 Then _
                mEntityList(i).Angle = mEntityList(i).Angle + 2 * pi
        End If
    Next i
    
End Function
Function ResetWayPoints()

    Dim i As Integer
    
    ReDim mWayPointList(0)
    For i = 1 To UBound(mEntityList)
        If mEntityList(i).Auto Then
            mEntityList(i).WayPoint = 0
            mEntityList(i).CurWayPoint = 0
        End If
    Next i
    
End Function
Function IsChild(IndexA As Integer, IndexB As Integer) As Integer

    Dim i As Integer
    Dim Result As Integer
    
    For i = 1 To mWayPointList(IndexB).NextIndex.Count
        If mWayPointList(IndexB).NextIndex.Item(i) = IndexA Then
            Result = -1
        Else
            Result = IsChild(IndexA, mWayPointList(IndexB).NextIndex.Item(i))
        End If
        If Result <> 0 Then
            Result = i
            Exit For
        End If
    Next i
    IsChild = Result
    
End Function
Function CheckWayPoints(Index As Integer, Pos As Vector) As Integer

    Dim Item As Variant
    Dim Result As Integer
    Dim Distance As Single
    Dim CurItem As Integer
    
    If Index <> 0 Then
        Distance = CastRay(mWayPointList(Index).Pos, Pos)
        If Distance = -1 Then
            Result = Index
        Else
            For Each Item In mWayPointList(Index).NextIndex
                CurItem = CInt(Item)
                Result = CheckWayPoints(CurItem, Pos)
                If Result <> 0 Then _
                    Exit For
            Next Item
        End If
    End If
    CheckWayPoints = Result
    
End Function
Function AngleDiff(AngleA As Single, AngleB As Single) As Single

    Dim Result As Single
    
    Result = Abs(AngleA - AngleB)
    If Result > pi Then _
        Result = 2 * pi - Result
    AngleDiff = Result
    
End Function
Function GetDir(Angle As Single, DestAngle As Single, Optional Towards As Boolean = True) As Integer

    Dim Result As Integer
    
    If AngleDiff(Angle, DestAngle) < DefSpin Then
        Result = 1 - CInt(Rnd * 2)
    Else
        If DestAngle > Angle Then
            Result = 1
        Else
            Result = -1
        End If
        If Abs(DestAngle - Angle) > pi Then _
            Result = Result * -1
        If Not Towards Then _
            Result = Result * -1
    End If
    GetDir = Result
    
End Function
Function VectorAdd(PosA As Vector, PosB As Vector) As Vector

    Dim Result As Vector
    
    Result.X = PosA.X + PosB.X
    Result.Y = PosA.Y + PosB.Y
    VectorAdd = Result
    
End Function
Function VectorSubtract(PosA As Vector, PosB As Vector) As Vector

    Dim Result As Vector
    
    Result = VectorAdd(PosA, VectorScale(PosB, -1))
    VectorSubtract = Result
    
End Function
Function VectorScale(Pos As Vector, Alpha As Single) As Vector

    Dim Result As Vector
    
    Result.X = Pos.X * Alpha
    Result.Y = Pos.Y * Alpha
    VectorScale = Result
    
End Function
Function VectorUpdate(Pos As Vector, Angle As Single, Distance As Single) As Vector

    Dim Result As Vector
    
    Result = VectorAdd(Pos, AtoV(Angle, Distance))
    VectorUpdate = Result
    
End Function
Function VectorBound(Pos As Vector, HiBound As Vector) As Vector

    Dim Result As Vector
    Dim LoBound As Vector
    
    Result = Pos
    If Result.X > HiBound.X Then Result.X = HiBound.X
    If Result.X < LoBound.X Then Result.X = LoBound.X
    If Result.Y > HiBound.Y Then Result.Y = HiBound.Y
    If Result.Y < LoBound.Y Then Result.Y = LoBound.Y
    VectorBound = Result
    
End Function
Function VectorLength(Pos As Vector) As Single

    Dim Result As Single
    
    Result = Sqr(Pos.X ^ 2 + Pos.Y ^ 2)
    VectorLength = Result
    
End Function
Function VectorDistance(PosA As Vector, PosB As Vector) As Single

    Dim Result As Single
    
    Result = VectorLength(VectorSubtract(PosA, PosB))
    VectorDistance = Result
    
End Function
Function VectorAngle(PosA As Vector, PosB As Vector) As Single

    Dim Result As Single
    
    Result = VtoA(VectorSubtract(PosB, PosA))
    VectorAngle = Result
    
End Function
Function VectorPrint(Pos As Vector) As String

    Dim Result As String
    
    Result = "(" & Pos.X & ", " & Pos.Y & ")"
    VectorPrint = Result
    
End Function
Function ColorInterp(A As Color, B As Color, Alpha As Single) As Color

    Dim Result As Color
    
    Result.R = A.R + Alpha * (B.R - A.R)
    Result.G = A.G + Alpha * (B.G - A.G)
    Result.B = A.B + Alpha * (B.B - A.B)
    ColorInterp = Result
    
End Function
Function ColorByLong(A As Long) As Color

    Dim Result As Color
    
    Result.R = (A And &HFF&)
    Result.G = (A And &HFF00&) / &H100&
    Result.B = (A And &HFF0000) / &H10000
    ColorByLong = Result
    
End Function
Function LongByColor(A As Color) As Long

    Dim Result As Long
    
    Result = RGB(A.R, A.G, A.B)
    LongByColor = Result
    
End Function
Function GetSlope(PosA As Vector, PosB As Vector) As Single

    Dim Result As Single
    
    If PosA.X <> PosB.X Then _
        Result = (PosB.Y - PosA.Y) / (PosB.X - PosA.X)
    GetSlope = Result
    
End Function
Function GetSectEx(PosA As Vector, PosB As Vector, PosC As Vector, PosD As Vector) As Vector

    Dim Result As Vector
    Dim SlopeAB As Single
    Dim ConstAB As Single
    Dim SlopeCD As Single
    Dim ConstCD As Single
    
    SlopeAB = GetSlope(PosA, PosB) 'm=(y2-y1)/(x2-x1)
    SlopeCD = GetSlope(PosC, PosD)
    If VectorIsNull(Result) Then
        ConstAB = PosA.Y - SlopeAB * PosA.X 'b=y-mx
        ConstCD = PosC.Y - SlopeCD * PosC.X
        If CLng(PosA.X) = CLng(PosB.X) Then 'if line AB is vertical
            Result.X = PosA.X
            Result.Y = SlopeCD * Result.X + ConstCD 'y=mx+b
        End If
        If CLng(PosC.X) = CLng(PosD.X) Then
            Result.X = PosC.X
            Result.Y = SlopeAB * Result.X + ConstAB
        End If
        If VectorIsNull(Result) Then
            If SlopeAB <> SlopeCD Then
                '(y-y)=(m1-m2)x+(b1-b2)
                '(b2-b1)=(m1-m2)x
                Result.X = (ConstCD - ConstAB) / (SlopeAB - SlopeCD) 'x=(b2-b1)/(m1-m2)
                Result.Y = SlopeAB * Result.X + ConstAB 'y=mx+b
            End If
        End If
    End If
    GetSectEx = Result
    
End Function
Function GetSect(PosA As Vector, PosB As Vector, PosC As Vector, PosD As Vector) As Vector

    Dim i As Integer
    Dim Result As Vector
    Dim PosP As Vector
    Dim PosQ As Vector
    Dim Temp As Vector
    
    Result = GetSectEx(PosA, PosB, PosC, PosD)
    If Not VectorIsNull(Result) Then
        For i = 1 To 2
            Select Case i
                Case 1
                    PosP = VectorSubtract(Result, PosA)
                    PosQ = VectorSubtract(PosB, Result)
                Case 2
                    PosP = VectorSubtract(Result, PosC)
                    PosQ = VectorSubtract(PosD, Result)
            End Select
            If _
                Abs(Sgn(CLng(PosP.X)) - Sgn(CLng(PosQ.X))) = 2 Or _
                Abs(Sgn(CLng(PosP.Y)) - Sgn(CLng(PosQ.Y))) = 2 _
            Then
                Result = Temp
                Exit For
            End If
        Next i
    End If
    GetSect = Result
    
End Function
Function CastRayEx(Pos As Vector, Angle As Single, Distance As Single) As Single

    Dim i As Integer
    Dim Result As Single
    Dim Target As Vector
    Dim PosA As Vector
    Dim PosB As Vector
    Dim Sect As Vector
    Dim CurDist As Single
    Dim BestDist As Single
    Dim BestSect As Vector
    
    Target = VectorUpdate(Pos, Angle, Distance)
    BestDist = BigNumber
    For i = 1 To UBound(mWallList)
        PosA = mEntityList(mWallList(i).A).Pos
        PosB = mEntityList(mWallList(i).B).Pos
        Sect = GetSect(Pos, Target, PosA, PosB)
        If Not VectorIsNull(Sect) Then
            CurDist = VectorDistance(Pos, Sect)
            If CurDist < BestDist Then
                BestDist = CurDist
                BestSect = Sect
            End If
        End If
    Next i
    If Not VectorIsNull(BestSect) Then
        Result = VectorDistance(Pos, BestSect)
    Else
        Result = Distance
    End If
    CastRayEx = Result
    
End Function
Function CastRay(PosA As Vector, PosB As Vector) As Single

    Dim Result As Single
    Dim Angle As Single
    Dim Range As Single
    
    Angle = VectorAngle(PosA, PosB)
    Range = VectorDistance(PosA, PosB)
    Result = CastRayEx(PosA, Angle, Range)
    If Result = Range Then _
        Result = -1
    CastRay = Result
    
End Function
Function _
    GetTarget( _
        Pos As Vector, _
        AngleA As Single, _
        AngleB As Single, _
        Optional Near As Boolean = True _
    ) As Vector

    Dim i As Single
    Dim Result As Vector
    Dim CurAngle As Single
    Dim CurDist As Single
    Dim BestDist As Single
    Dim BestAngle As Single
    
    If Near Then _
        BestDist = BigNumber
    For i = AngleA To AngleB Step DefSpin
        CurAngle = i
        CurAngle = CurAngle * 180 / pi
        CurAngle = (CurAngle + 360) Mod 360
        CurAngle = CurAngle * pi / 180
        CurDist = CastRayEx(Pos, CurAngle, BigNumber)
        If _
            ((CurDist < BestDist) And Near) Or _
            ((CurDist > BestDist) And (Not Near)) _
        Then
            BestDist = CurDist
            BestAngle = CurAngle
        End If
    Next i
    Result = VectorUpdate(Pos, BestAngle, BestDist)
    GetTarget = Result
    
End Function
Function VectorIsNull(Pos As Vector) As Boolean

    Dim Result As Boolean
    
    If Pos.X = 0 And Pos.Y = 0 Then _
        Result = True
    VectorIsNull = Result
    
End Function
