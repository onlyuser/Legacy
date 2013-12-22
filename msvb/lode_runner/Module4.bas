Attribute VB_Name = "Module4"
Function DoActorAI(ActorList() As Actor, Level() As Integer)

    Dim i As Integer
    Dim SpriteSequence As String
    Dim NearestEnemy As Integer
    Dim AbsIndex As Integer
    Dim DeltaX As Integer
    Dim DeltaY As Integer
    Dim ExitDir As Integer
    Dim DirDepth As Integer
    
    For i = 1 To UBound(ActorList)
        If _
            Not (ActorList(i).Disabled Or ActorList(i).Dormant) And _
            ActorList(i).HasAI _
        Then
            SpriteSequence = "player2 "
            NearestEnemy = GetNearestEnemy(i, ActorList)
            If NearestEnemy <> 0 Then
                AbsIndex = GetAbsoluteIndex(ActorList(i))
                DeltaX = _
                    CInt(ActorList(NearestEnemy).GridX) - CInt(ActorList(i).GridX)
                DeltaY = _
                    CInt(ActorList(NearestEnemy).GridY) - CInt(ActorList(i).GridY)
                If DeltaY = 0 Then
                    'move horizontally
                    If DeltaX > 0 Then
                        If _
                            Level(AbsIndex + 1) <> GetSpriteIndex(BrickCode) And _
                            Level(AbsIndex + 1) <> GetSpriteIndex(MetalCode) And _
                            Level(AbsIndex + 1) <> GetSpriteIndex(BrickInvisCode) _
                        Then
                            SpriteSequence = SpriteSequence & "move right"
                        Else
                            If GetPhase(ActorTime) Then
                                SpriteSequence = SpriteSequence & "move down"
                            Else
                                SpriteSequence = SpriteSequence & "move up"
                            End If
                        End If
                    End If
                    If DeltaX = 0 Then _
                        SpriteSequence = SpriteSequence & "stop"
                    If DeltaX < 0 Then
                        If _
                            Level(AbsIndex - 1) <> GetSpriteIndex(BrickCode) And _
                            Level(AbsIndex - 1) <> GetSpriteIndex(MetalCode) And _
                            Level(AbsIndex - 1) <> GetSpriteIndex(BrickInvisCode) _
                        Then
                            SpriteSequence = SpriteSequence & "move left"
                        Else
                            If GetPhase(ActorTime) Then
                                SpriteSequence = SpriteSequence & "move down"
                            Else
                                SpriteSequence = SpriteSequence & "move up"
                            End If
                        End If
                    End If
                Else
                    'move vertically
                    If DeltaY > 0 Then
                        If _
                            ( _
                                Level(AbsIndex + LevelWidth) = _
                                    GetSpriteIndex(LadderCode) And _
                                GetPhase(ActorTime) _
                            ) Or _
                            ( _
                                DeltaX = 0 And _
                                ( _
                                    Level(AbsIndex) = _
                                        GetSpriteIndex(LadderCode) Or _
                                    Level(AbsIndex) = _
                                        GetSpriteIndex(RailCode) _
                                ) And _
                                Level(AbsIndex + LevelWidth) <> _
                                    GetSpriteIndex(BrickCode) And _
                                Level(AbsIndex + LevelWidth) <> _
                                    GetSpriteIndex(MetalCode) _
                            ) _
                        Then
                            SpriteSequence = SpriteSequence & "move down"
                        Else
                            ExitDir = GetExitDir(True, AbsIndex, Level)
                            If ExitDir <> 0 Then
                                If ExitDir > 0 Then
                                    SpriteSequence = SpriteSequence & "move right"
                                Else
                                    SpriteSequence = SpriteSequence & "move left"
                                End If
                            Else
                                If DeltaX >= 0 Then
                                    SpriteSequence = SpriteSequence & "move right"
                                Else
                                    SpriteSequence = SpriteSequence & "move left"
                                End If
                            End If
                        End If
                    End If
                    If DeltaY < 0 Then
                        If _
                            Level(AbsIndex) = GetSpriteIndex(LadderCode) And _
                            Level(AbsIndex - LevelWidth) <> _
                                GetSpriteIndex(BrickCode) And _
                            Level(AbsIndex - LevelWidth) <> _
                                GetSpriteIndex(MetalCode) _
                        Then
                            SpriteSequence = SpriteSequence & "move up"
                        Else
                            ExitDir = GetExitDir(False, AbsIndex, Level)
                            If ExitDir <> 0 Then
                                If ExitDir > 0 Then
                                    SpriteSequence = SpriteSequence & "move right"
                                Else
                                    SpriteSequence = SpriteSequence & "move left"
                                End If
                            Else
                                If GetPhase(ActorTime) Then
                                    SpriteSequence = SpriteSequence & "move right"
                                Else
                                    SpriteSequence = SpriteSequence & "move left"
                                End If
                            End If
                        End If
                    End If
                End If
                'reconsider horizontal motion
                Select Case _
                    Right( _
                        SpriteSequence, _
                        Len(SpriteSequence) - Len("player2 move ") _
                    )
                    Case "left"
                        SpriteSequence = _
                            Left(SpriteSequence, Len(SpriteSequence) - 4)
                        DirDepth = GetDirDepth(False, AbsIndex, Level)
                        If _
                            DirDepth <> -1 And _
                            DirDepth <= _
                                ( _
                                    CInt(ActorList(i).GridX) - _
                                    CInt(ActorList(NearestEnemy).GridX) _
                                ) _
                        Then
                            SpriteSequence = SpriteSequence & "right"
                        Else
                            SpriteSequence = SpriteSequence & "left"
                        End If
                    Case "right"
                        SpriteSequence = _
                            Left(SpriteSequence, Len(SpriteSequence) - 5)
                        DirDepth = GetDirDepth(True, AbsIndex, Level)
                        If _
                            DirDepth <> -1 And _
                            DirDepth <= _
                                ( _
                                    CInt(ActorList(NearestEnemy).GridX) - _
                                    CInt(ActorList(i).GridX) _
                                ) _
                        Then
                            SpriteSequence = SpriteSequence & "left"
                        Else
                            SpriteSequence = SpriteSequence & "right"
                        End If
                End Select
            Else
                SpriteSequence = SpriteSequence & "stop"
            End If
            ActorList(i).SpriteSequence = SpriteSequence
        End If
    Next i
    
End Function
Function _
    GetActorDistance( _
        ArgActor1 As Actor, _
        ArgActor2 As Actor _
    ) As Integer

    Dim Result As Integer
    
    Result = _
        Sqr _
        ( _
            (CInt(ArgActor2.GridX) - CInt(ArgActor1.GridX)) ^ 2 + _
            (CInt(ArgActor2.GridY) - CInt(ArgActor1.GridY)) ^ 2 _
        )
    GetActorDistance = Result
    
End Function
Function GetNearestEnemy(ActorIndex As Integer, ActorList() As Actor) As Integer

    Dim i As Integer
    Dim Result As Integer
    Dim Distance As Integer
    Dim ShortestDistance As Integer
    
    For i = 1 To UBound(ActorList)
        If _
            Not (ActorList(i).Disabled Or ActorList(i).Dormant) And _
            i <> ActorIndex And _
            IsEnemy(ActorList(i), ActorList(ActorIndex)) And _
            ActorList(i).SpriteIndex <> GetSpriteIndex(HideCode) _
        Then
            Distance = GetActorDistance(ActorList(i), ActorList(ActorIndex))
            If ShortestDistance = 0 Then
                ShortestDistance = Distance
                Result = i
            Else
                If Distance < ShortestDistance Then
                    ShortestDistance = Distance
                    Result = i
                End If
            End If
        End If
    Next i
    GetNearestEnemy = Result
    
End Function
Function GetDirDepth( _
        Right As Boolean, _
        AbsIndex As Integer, _
        Level() As Integer _
    ) As Integer

    Dim Result As Integer
    Dim DistDown As Integer
    Dim DistUp As Integer
    
    DistDown = GetExitDistance(Right, True, AbsIndex, Level)
    DistUp = GetExitDistance(Right, False, AbsIndex, Level)
    If _
        Abs(DistDown) = Abs(DistUp) And _
        ( _
            DistDown < 0 And DistUp < 0 Or _
            DistDown > 0 And DistUp < 0 _
        ) _
    Then
        Result = Abs(DistDown)
    Else
        Result = -1
    End If
    GetDirDepth = Result
    
End Function
Function GetPhase(Interval As Integer) As Boolean

    Dim Result As Boolean
    
    If (Format(Time, "ss") Mod (Interval * 2)) >= Interval Then _
        Result = True
    GetPhase = Result
    
End Function
Function IsEnemy(ArgActor1 As Actor, ArgActor2 As Actor) As Boolean

    Dim Result As Boolean
    
    If _
        ( _
            ArgActor1.StaticSpriteIndex = GetSpriteIndex(PlayerCode) And _
            ArgActor2.StaticSpriteIndex = GetSpriteIndex(EnemyCode) _
        ) Or _
        ( _
            ArgActor1.StaticSpriteIndex = GetSpriteIndex(EnemyCode) And _
            ArgActor2.StaticSpriteIndex = GetSpriteIndex(PlayerCode) _
        ) _
    Then _
        Result = True
    IsEnemy = Result
    
End Function
Function _
    GetExitDistance( _
        Right As Boolean, _
        MoveDown As Boolean, _
        AbsIndex As Integer, _
        Level() As Integer _
    ) As Integer

    Dim i As Integer
    Dim j As Integer
    Dim Result As Integer
    Dim IncreX As Integer
    
    If Right Then
        IncreX = 1
    Else
        IncreX = -1
    End If
    i = 0
    Do
        If _
            Level(AbsIndex + i) = GetSpriteIndex(BrickCode) Or _
            Level(AbsIndex + i) = GetSpriteIndex(MetalCode) Or _
            Level(AbsIndex + i) = GetSpriteIndex(BrickInvisCode) _
        Then
            Result = -Abs(i)
            Exit Do
        End If
        If _
            Level(AbsIndex + i) <> GetSpriteIndex(LadderCode) And _
            Level(AbsIndex + i) <> GetSpriteIndex(RailCode) And _
            Level(AbsIndex + LevelWidth + i) <> GetSpriteIndex(BrickCode) And _
            Level(AbsIndex + LevelWidth + i) <> GetSpriteIndex(MetalCode) And _
            Level(AbsIndex + LevelWidth + i) <> GetSpriteIndex(LadderCode) _
        Then
            If Not MoveDown Then
                Result = -Abs(i)
                Exit Do
            End If
        End If
        If Not MoveDown Then
            If Level(AbsIndex + i) = GetSpriteIndex(LadderCode) Then
                j = 1 'at least one ladder grid
                Do
                    If _
                        Level(AbsIndex + i - j * LevelWidth) <> _
                            GetSpriteIndex(LadderCode) _
                    Then _
                        Exit Do
                    j = j + 1
                Loop
                If Abs(i) < j Then
                    Result = j - Abs(i)
                Else
                    Result = 1
                End If
                Exit Do
            End If
        End If
        If MoveDown Then
            If _
                Level(AbsIndex + LevelWidth + i) <> GetSpriteIndex(BrickCode) And _
                Level(AbsIndex + LevelWidth + i) <> GetSpriteIndex(MetalCode) _
            Then
                Result = Abs(i)
                Exit Do
            End If
        End If
        i = i + IncreX
    Loop
    GetExitDistance = Result
    
End Function
Function GetExitDir( _
        MoveDown As Boolean, _
        AbsIndex As Integer, _
        Level() As Integer _
    ) As Integer

    Dim Result As Integer
    Dim DistRight As Integer
    Dim DistLeft As Integer
    
    DistRight = GetExitDistance(True, MoveDown, AbsIndex, Level)
    DistLeft = GetExitDistance(False, MoveDown, AbsIndex, Level)
    If DistRight <> 0 And DistLeft <> 0 Then
        If DistRight > 0 And DistLeft < 0 Then _
            Result = 1 'can't go left
        If DistRight < 0 And DistLeft > 0 Then _
            Result = -1 'can't go right
        If _
            (DistRight > 0 And DistLeft > 0) Or _
            (DistRight < 0 And DistLeft < 0) _
        Then
            If DistRight <> DistLeft Then
                If DistRight < DistLeft Then
                    Result = 1
                Else
                    Result = -1
                End If
                If Not MoveDown Then _
                    Result = Result * -1
            Else
                Result = 0
            End If
        End If
    Else
        Result = 0 'don't go anywhere
    End If
    GetExitDir = Result
    
End Function
