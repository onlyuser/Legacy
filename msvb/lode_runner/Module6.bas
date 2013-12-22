Attribute VB_Name = "Module6"
Function _
    HandleRedBombContact( _
        ActorList() As Actor, _
        ActorIndex As Integer, _
        ActorOverlap As Integer _
    ) As Boolean

    Dim Result As Integer
    
    If _
        ( _
            ActorList(ActorOverlap).StaticSpriteIndex = _
                GetSpriteIndex(RedBombCode) And _
            ActorList(ActorIndex).StaticSpriteIndex <> _
                GetSpriteIndex(RedBombCode) _
        ) Or _
        ( _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(RedBombCode) And _
            ActorList(ActorOverlap).StaticSpriteIndex <> _
                GetSpriteIndex(RedBombCode) _
        ) _
    Then
        If _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(RedBombCode) _
        Then
            If ActorList(ActorOverlap).RelicCount = 0 Then
                ActorList(ActorOverlap).Relic = _
                    ActorList(ActorIndex).StaticSpriteIndex
                ActorList(ActorOverlap).RelicCount = _
                    ActorList(ActorOverlap).RelicCount + 3
                ActorList(ActorIndex).SpriteSequence = "red bomb vanish"
            End If
        Else
            If ActorList(ActorIndex).RelicCount = 0 Then
                ActorList(ActorIndex).Relic = _
                    ActorList(ActorOverlap).StaticSpriteIndex
                ActorList(ActorIndex).RelicCount = _
                    ActorList(ActorIndex).RelicCount + 3
                ActorList(ActorOverlap).SpriteSequence = "red bomb vanish"
            End If
        End If
        Result = True
    End If
    HandleRedBombContact = Result
    
End Function
Function _
    HandleGreenBombContact( _
        ActorList() As Actor, _
        ActorIndex As Integer, _
        ActorOverlap As Integer _
    ) As Boolean

    Dim Result As Integer
    
    If _
        ( _
            ActorList(ActorOverlap).StaticSpriteIndex = _
                GetSpriteIndex(GreenBombCode) And _
            ActorList(ActorIndex).StaticSpriteIndex <> _
                GetSpriteIndex(GreenBombCode) _
        ) Or _
        ( _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(GreenBombCode) And _
            ActorList(ActorOverlap).StaticSpriteIndex <> _
                GetSpriteIndex(GreenBombCode) _
        ) _
    Then
        If _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(GreenBombCode) _
        Then
            If ActorList(ActorOverlap).RelicCount = 0 Then
                ActorList(ActorOverlap).Relic = _
                    ActorList(ActorIndex).StaticSpriteIndex
                ActorList(ActorOverlap).RelicCount = _
                    ActorList(ActorOverlap).RelicCount + 3
                ActorList(ActorIndex).SpriteSequence = "green bomb vanish"
            End If
        Else
            If ActorList(ActorIndex).RelicCount = 0 Then
                ActorList(ActorIndex).Relic = _
                    ActorList(ActorOverlap).StaticSpriteIndex
                ActorList(ActorIndex).RelicCount = _
                    ActorList(ActorIndex).RelicCount + 3
                ActorList(ActorOverlap).SpriteSequence = "green bomb vanish"
            End If
        End If
        Result = True
    End If
    HandleGreenBombContact = Result
    
End Function
Function _
    HandleYellowBombContact( _
        ActorList() As Actor, _
        ActorIndex As Integer, _
        ActorOverlap As Integer _
    ) As Boolean

    Dim Result As Integer
    
    If _
        ( _
            ActorList(ActorOverlap).StaticSpriteIndex = _
                GetSpriteIndex(YellowBombCode) And _
            ActorList(ActorIndex).StaticSpriteIndex <> _
                GetSpriteIndex(YellowBombCode) _
        ) Or _
        ( _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(YellowBombCode) And _
            ActorList(ActorOverlap).StaticSpriteIndex <> _
                GetSpriteIndex(YellowBombCode) _
        ) _
    Then
        If _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(YellowBombCode) _
        Then
            If ActorList(ActorOverlap).RelicCount = 0 Then
                ActorList(ActorOverlap).Relic = _
                    ActorList(ActorIndex).StaticSpriteIndex
                ActorList(ActorOverlap).RelicCount = _
                    ActorList(ActorOverlap).RelicCount + 3
                ActorList(ActorIndex).SpriteSequence = "yellow bomb vanish"
            End If
        Else
            If ActorList(ActorIndex).RelicCount = 0 Then
                ActorList(ActorIndex).Relic = _
                    ActorList(ActorOverlap).StaticSpriteIndex
                ActorList(ActorIndex).RelicCount = _
                    ActorList(ActorIndex).RelicCount + 3
                ActorList(ActorOverlap).SpriteSequence = "yellow bomb vanish"
            End If
        End If
        Result = True
    End If
    HandleYellowBombContact = Result
    
End Function
Function _
    HandleCyanBombContact( _
        ActorList() As Actor, _
        ActorIndex As Integer, _
        ActorOverlap As Integer _
    ) As Boolean

    Dim Result As Integer
    
    If _
        ( _
            ActorList(ActorOverlap).StaticSpriteIndex = _
                GetSpriteIndex(CyanBombCode) And _
            ActorList(ActorIndex).StaticSpriteIndex <> _
                GetSpriteIndex(CyanBombCode) _
        ) Or _
        ( _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(CyanBombCode) And _
            ActorList(ActorOverlap).StaticSpriteIndex <> _
                GetSpriteIndex(CyanBombCode) _
        ) _
    Then
        If _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(CyanBombCode) _
        Then
            If ActorList(ActorOverlap).RelicCount = 0 Then
                ActorList(ActorOverlap).Relic = _
                    ActorList(ActorIndex).StaticSpriteIndex
                ActorList(ActorOverlap).RelicCount = _
                    ActorList(ActorOverlap).RelicCount + 3
                ActorList(ActorIndex).SpriteSequence = "cyan bomb vanish"
            End If
        Else
            If ActorList(ActorIndex).RelicCount = 0 Then
                ActorList(ActorIndex).Relic = _
                    ActorList(ActorOverlap).StaticSpriteIndex
                ActorList(ActorIndex).RelicCount = _
                    ActorList(ActorIndex).RelicCount + 3
                ActorList(ActorOverlap).SpriteSequence = "cyan bomb vanish"
            End If
        End If
        Result = True
    End If
    HandleCyanBombContact = Result
    
End Function
Function _
    SpawnYellowBomb( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "yellow bomb flash"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(VoidCode)
    ActorList(Result).Decays = True
    ActorList(Result).LifeSpan = Delay
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnYellowBomb = Result
    
End Function
Function _
    SpawnGreenBomb( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "green bomb flash"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(VoidCode)
    ActorList(Result).Decays = True
    ActorList(Result).LifeSpan = Delay
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnGreenBomb = Result
    
End Function
Function _
    SpawnYellowBombEx( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    Dim TriggerIndex1 As Integer
    Dim TriggerIndex2 As Integer
    Dim TriggerIndex3 As Integer
    
    TriggerIndex1 = SpawnYellowBombExplode(ActorList, TriggerIndex)
    ActorList(TriggerIndex1).GridX = 0
    ActorList(TriggerIndex1).GridY = -1
    TriggerIndex2 = SpawnYellowBombExplode(ActorList, TriggerIndex1)
    ActorList(TriggerIndex2).GridX = 0
    ActorList(TriggerIndex2).GridY = -1
    TriggerIndex3 = SpawnYellowBombExplode(ActorList, TriggerIndex2)
    ActorList(TriggerIndex3).GridX = 0
    ActorList(TriggerIndex3).GridY = 0
    Result = SpawnYellowBomb(ActorList, Delay, TriggerIndex3)
    SpawnYellowBombEx = Result
    
End Function
Function _
    SpawnGreenBombEx( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    Dim TriggerIndex1 As Integer
    Dim TriggerIndex2 As Integer
    Dim TriggerIndex3 As Integer
    
    TriggerIndex1 = SpawnGreenBombExplode(ActorList, TriggerIndex)
    ActorList(TriggerIndex1).GridX = 0
    ActorList(TriggerIndex1).GridY = -1
    TriggerIndex2 = SpawnGreenBombExplode(ActorList, TriggerIndex1)
    ActorList(TriggerIndex2).GridX = 0
    ActorList(TriggerIndex2).GridY = -1
    TriggerIndex3 = SpawnGreenBombExplode(ActorList, TriggerIndex2)
    ActorList(TriggerIndex3).GridX = 0
    ActorList(TriggerIndex3).GridY = 0
    Result = SpawnGreenBomb(ActorList, Delay, TriggerIndex3)
    SpawnGreenBombEx = Result
    
End Function
Function _
    SpawnRedBomb( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "red bomb flash"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(VoidCode)
    ActorList(Result).Decays = True
    ActorList(Result).LifeSpan = Delay
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnRedBomb = Result
    
End Function
Function _
    SpawnCyanBomb( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "cyan bomb flash"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(VoidCode)
    ActorList(Result).Decays = True
    ActorList(Result).LifeSpan = Delay
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnCyanBomb = Result
    
End Function
Function SpawnYellowBombExplode(ActorList() As Actor, TriggerIndex As Integer) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "yellow bomb explode"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(BrickCode)
    ActorList(Result).Suspended = True
    ActorList(Result).LeaveMark = True
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnYellowBombExplode = Result
    
End Function
Function SpawnGreenBombExplode(ActorList() As Actor, TriggerIndex As Integer) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "green bomb explode"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(LadderCode)
    ActorList(Result).Suspended = True
    ActorList(Result).LeaveMark = True
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnGreenBombExplode = Result
    
End Function
Function _
    SpawnCyanBombEx( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    Dim TriggerIndex1 As Integer
    Dim TriggerIndex2 As Integer
    Dim TriggerIndex3 As Integer
    Dim TriggerIndex4 As Integer
    Dim TriggerIndex5 As Integer
    
    TriggerIndex1 = SpawnCyanBombExplode(ActorList, TriggerIndex)
    ActorList(TriggerIndex1).GridX = -4
    ActorList(TriggerIndex1).GridY = 0
    TriggerIndex2 = SpawnCyanBombExplode(ActorList, TriggerIndex1)
    ActorList(TriggerIndex2).GridX = 3
    ActorList(TriggerIndex2).GridY = 0
    TriggerIndex3 = SpawnCyanBombExplode(ActorList, TriggerIndex2)
    ActorList(TriggerIndex3).GridX = -2
    ActorList(TriggerIndex3).GridY = 0
    TriggerIndex4 = SpawnCyanBombExplode(ActorList, TriggerIndex3)
    ActorList(TriggerIndex4).GridX = 1
    ActorList(TriggerIndex4).GridY = 0
    TriggerIndex5 = SpawnCyanBombExplode(ActorList, TriggerIndex4)
    ActorList(TriggerIndex5).GridX = 0
    ActorList(TriggerIndex5).GridY = 0
    Result = SpawnCyanBomb(ActorList, Delay, TriggerIndex5)
    SpawnCyanBombEx = Result
    
End Function
Function SpawnCyanBombExplode(ActorList() As Actor, TriggerIndex As Integer) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "cyan bomb explode"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(LadderCode)
    ActorList(Result).Suspended = True
    ActorList(Result).LeaveMark = True
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnCyanBombExplode = Result
    
End Function
Function _
    SpawnRedBombEx( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    Dim TriggerIndex1 As Integer
    Dim TriggerIndex2 As Integer
    Dim TriggerIndex3 As Integer
    
    TriggerIndex1 = SpawnRedBombExplode(ActorList, TriggerIndex)
    ActorList(TriggerIndex1).GridX = 0
    ActorList(TriggerIndex1).GridY = 1
    TriggerIndex2 = SpawnRedBombExplode(ActorList, TriggerIndex1)
    ActorList(TriggerIndex2).GridX = 0
    ActorList(TriggerIndex2).GridY = 1
    TriggerIndex3 = SpawnRedBombExplode(ActorList, TriggerIndex2)
    ActorList(TriggerIndex3).GridX = 0
    ActorList(TriggerIndex3).GridY = 0
    Result = SpawnRedBomb(ActorList, Delay, TriggerIndex3)
    SpawnRedBombEx = Result
    
End Function
Function SpawnRedBombExplode(ActorList() As Actor, TriggerIndex As Integer) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "red bomb explode"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(VoidCode)
    ActorList(Result).Suspended = True
    ActorList(Result).LeaveMark = True
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnRedBombExplode = Result
    
End Function
