Attribute VB_Name = "Module3"
Function _
    SpawnAcidMeltEx( _
        ActorList() As Actor, _
        Right As Boolean, _
        Delay As Integer, _
        TriggerIndex As Integer _
    )

    Dim Result As Integer
    Dim TriggerIndex1 As Integer
    
    TriggerIndex1 = SpawnBrickMeltEx(ActorList, Delay, TriggerIndex)
    ActorList(TriggerIndex1).GridY = 1
    Result = SpawnAcidMelt(ActorList, Right, TriggerIndex1)
    SpawnAcidMeltEx = Result
    
End Function
Function _
    SpawnAcidMelt( _
        ActorList() As Actor, _
        Right As Boolean, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    If Right Then
        ActorList(Result).SpriteSequence = "acid melt right"
    Else
        ActorList(Result).SpriteSequence = "acid melt left"
    End If
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(VoidCode)
    ActorList(Result).Suspended = True
    ActorList(Result).Solid = True
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnAcidMelt = Result
    
End Function
Function _
    SpawnBrickMeltEx( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    Dim TriggerIndex1 As Integer
    Dim TriggerIndex2 As Integer
    
    TriggerIndex1 = SpawnBrickHeal(ActorList, TriggerIndex)
    TriggerIndex2 = SpawnTimer(ActorList, Delay, TriggerIndex1)
    Result = SpawnBrickMelt(ActorList, TriggerIndex2)
    SpawnBrickMeltEx = Result
    
End Function
Function SpawnBrickHeal(ActorList() As Actor, TriggerIndex As Integer) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "brick heal"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(BrickCode)
    ActorList(Result).Suspended = True
    ActorList(Result).LeaveMark = True
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnBrickHeal = Result
    
End Function
Function SpawnBrickMelt(ActorList() As Actor, TriggerIndex As Integer) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "brick melt"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(VoidCode)
    ActorList(Result).Suspended = True
    ActorList(Result).LeaveMark = True
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnBrickMelt = Result
    
End Function
Function SpawnGold(ActorList() As Actor) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "gold"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(GoldCode)
    ActorList(Result).Solid = True
    ActorList(Result).Dormant = True
    SpawnGold = Result
    
End Function
Function SpawnGoldDrop(ActorList() As Actor, TriggerIndex As Integer) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = "gold drop"
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(GoldCode)
    ActorList(Result).Suspended = True
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnGoldDrop = Result
    
End Function
Function _
    SpawnGoldDropEx( _
        ActorList() As Actor, _
        Delay As Integer _
    ) As Integer

    Dim Result As Integer
    Dim TriggerIndex As Integer
    Dim TriggerIndex1 As Integer
    
    TriggerIndex = SpawnGold(ActorList)
    TriggerIndex1 = SpawnGoldDrop(ActorList, TriggerIndex)
    Result = SpawnTimer(ActorList, Delay, TriggerIndex1)
    SpawnGoldDropEx = Result
    
End Function
Function _
    SpawnTimer( _
        ActorList() As Actor, _
        Delay As Integer, _
        TriggerIndex As Integer _
    ) As Integer

    Dim Result As Integer
    
    Result = AddActor(ActorList)
    ActorList(Result).SpriteSequence = ""
    ActorList(Result).StaticSpriteIndex = GetSpriteIndex(VoidCode)
    ActorList(Result).Suspended = True
    ActorList(Result).Decays = True
    ActorList(Result).LifeSpan = Delay
    ActorList(Result).TriggerIndex = TriggerIndex
    ActorList(Result).Dormant = True
    SpawnTimer = Result
    
End Function
