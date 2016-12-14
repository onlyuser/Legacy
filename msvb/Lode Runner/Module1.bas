Attribute VB_Name = "Module1"
Type Actor

    'misc
    StaticSpriteIndex As Integer '[actor id]
    Disabled As Boolean 'destroy actor?
    Dormant As Boolean 'actor temporarily disabled?
    HasAI As Boolean 'allow computer to control?
    UserControl As Boolean 'allow user to control?
    Solid As Boolean 'blocks other actors?
    GoldCount As Integer '[ammount of gold carried]
    Relic As Integer '[type of relic carried]
    RelicCount As Integer '[number of relics carried]
    
    'appearance
    SpriteIndex As Integer
    GridX As Single
    GridY As Single
    
    'animation
    SpriteSequence As String
    PrevSpriteSequence As String
    SpriteStart As Integer
    SpriteEnd As Integer
    
    'sound
    SoundFile As String
    
    'motion
    DeltaX As Single
    DeltaY As Single
    Suspended As Boolean 'actor floats?
    UseAux As Integer '[auxiliary delta switch]
    AuxDeltaX As Single
    AuxDeltaY As Single
    NetDeltaX As Single
    NetDeltaY As Single
    
    'lifetime
    OneTimeOnly As Boolean 'play animation one time only?
    Decays As Boolean 'decay by time?
    LifeSpan As Integer '[decay time]
    
    'on unload
    SelfDestruct As Boolean 'destroy actor?
    TriggerIndex As Integer '[actor to activate]
    LeaveMark As Boolean 'embed into background?
    
End Type

Type Script

    'animation
    SpriteSequence As String
    SpriteStart As Integer
    SpriteEnd As Integer
    
    'sound
    SoundFile As String
    
    'motion
    DeltaX As Single
    DeltaY As Single
    
    'life time
    OneTimeOnly As Boolean 'play animation one time only?
    
    'on unload
    SelfDestruct As Boolean 'destroy actor?
    
End Type

Public Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long

'game data
Public MemCanvasHdc As Long
Public MemLevel() As Integer
Public MemActorList() As Actor
Public MemScriptList() As Script

'misc data
Public PlayerIndex As Integer
Public LevelGoldCount As Integer
Public EditSpriteIndex As Integer
Public CurrentLevel As String
Public GameSound As Boolean

'game settings
Public SpriteFile As String
Public ScriptFile As String
Public UnitLength As Integer
Public SpriteWidth As Integer
Public SpriteHeight As Integer
Public LevelWidth As Integer
Public LevelHeight As Integer
Public ViewWidth As Integer
Public ViewHeight As Integer
Public TickInterv As Integer
Public ActorSpeed As Single
Public ActorGravity As Single
Public BrickTime As Integer
Public GoldTime As Integer
Public ActorTime As Integer
Public BombTime As Integer
Public WinSound As String
Public LoseSound As String
Public PlotSound As String
Public ScrollSound As String
Public StartLevel As String

'grid codes
Public VoidCode As String
Public BrickCode As String
Public MetalCode As String
Public LadderCode As String
Public RailCode As String
Public BrickInvisCode As String
Public CaveCode As String
Public GoldCode As String
Public PlayerCode As String
Public EnemyCode As String
Public HideCode As String
Public RedBombCode As String
Public GreenBombCode As String
Public YellowBombCode As String
Public CyanBombCode As String
Function AddActor(ActorList() As Actor) As Integer

    Dim i As Integer
    Dim Result As Integer
    Dim Blank As Actor
    
    For i = 1 To UBound(ActorList)
        If ActorList(i).Disabled Then
            ActorList(i) = Blank
            Result = i
            Exit For
        End If
    Next i
    If Result = 0 Then
        ReDim Preserve ActorList(UBound(ActorList) + 1)
        Result = UBound(ActorList)
    End If
    AddActor = Result
    
End Function
Function AddScript(ScriptList() As Script) As Integer

    Dim Result As Integer
    
    ReDim Preserve ScriptList(UBound(ScriptList) + 1)
    Result = UBound(ScriptList)
    AddScript = Result
    
End Function
Function ApplySpriteSequence(ArgActor As Actor, ScriptList() As Script)

    Dim i As Integer
    
    For i = 1 To UBound(ScriptList)
        If ScriptList(i).SpriteSequence = ArgActor.SpriteSequence Then
            ArgActor.SpriteStart = ScriptList(i).SpriteStart
            ArgActor.SpriteEnd = ScriptList(i).SpriteEnd
            ArgActor.SoundFile = ScriptList(i).SoundFile
            ArgActor.DeltaX = ScriptList(i).DeltaX
            ArgActor.DeltaY = ScriptList(i).DeltaY
            ArgActor.OneTimeOnly = ScriptList(i).OneTimeOnly
            ArgActor.SelfDestruct = ScriptList(i).SelfDestruct
            Exit For
        End If
    Next i
    ArgActor.PrevSpriteSequence = ArgActor.SpriteSequence
    ArgActor.SpriteSequence = ""
    Call ResetActor(ArgActor)
    
End Function
Function CountActors(StaticSpriteIndex As Integer, ActorList() As Actor) As Integer

    Dim i As Integer
    Dim Result As Integer
    
    For i = 1 To UBound(ActorList)
        If Not (ActorList(i).Disabled Or ActorList(i).Dormant) Then
            If ActorList(i).StaticSpriteIndex = StaticSpriteIndex Then _
                Result = Result + 1
        End If
    Next i
    CountActors = Result
    
End Function
Function GetSpriteCode(SpriteIndex As Integer) As String

    Dim Result As String
    Dim GridX As Integer
    Dim GridY As Integer
    
    If SpriteIndex <> 0 Then
        GridX = SpriteIndex Mod SpriteWidth
        GridY = Int(SpriteIndex / SpriteWidth)
        Result = Chr(Asc("a") + GridY) & GridX
    Else
        Result = Space(2)
    End If
    GetSpriteCode = Result
    
End Function
Function SaveLevel(LevelFile As String, Level() As Integer)

    Call SaveText(LevelFile, UnbuildLevel(Level))
    
End Function
Function UnbuildLevel(Level() As Integer) As String

    Dim i As Integer
    Dim Result As String
    
    For i = 0 To UBound(Level)
        Result = Result & GetSpriteCode(Level(i))
        If Int(i / LevelWidth) <> Int((i + 1) / LevelWidth) Then _
            Result = Result & vbCrLf
    Next i
    UnbuildLevel = Result
    
End Function
Function _
    DrawIcon( _
        SpriteIndex As Integer, _
        Text As String, _
        BufferObj As PictureBox, _
        SpriteHdc As Long, _
        GridX As Single, _
        GridY As Single _
    )

    Call DrawGrid(SpriteIndex, BufferObj.hdc, SpriteHdc, GridX, GridY, vbSrcCopy)
    BufferObj.CurrentX = Int((GridX + 1) * UnitLength)
    BufferObj.CurrentY = Int(GridY * UnitLength)
    BufferObj.Print Text
    
End Function
Function _
    HandleActorContact( _
        ActorIndex As Integer, _
        ActorOverlap As Integer, _
        ActorList() As Actor _
    )

    Dim ItemRemoved As Boolean
    
    If HandleGoldContact(ActorList, ActorIndex, ActorOverlap) Then _
        ItemRemoved = True
    If HandleRedBombContact(ActorList, ActorIndex, ActorOverlap) Then _
        ItemRemoved = True
    If HandleGreenBombContact(ActorList, ActorIndex, ActorOverlap) Then _
        ItemRemoved = True
    If HandleYellowBombContact(ActorList, ActorIndex, ActorOverlap) Then _
        ItemRemoved = True
    If HandleCyanBombContact(ActorList, ActorIndex, ActorOverlap) Then _
        ItemRemoved = True
    Call HandlePlayerContact(ActorList, ActorIndex, ActorOverlap)
    If Not ItemRemoved Then
        ActorList(ActorIndex).GridX = _
            CInt( _
                ActorList(ActorIndex).GridX - _
                ActorList(ActorIndex).NetDeltaX _
            )
        ActorList(ActorIndex).GridY = _
            CInt( _
                ActorList(ActorIndex).GridY - _
                ActorList(ActorIndex).NetDeltaY _
            )
        ActorList(ActorIndex).NetDeltaX = 0
        ActorList(ActorIndex).NetDeltaY = 0
    End If
    
End Function
Function _
    HandleGoldContact( _
        ActorList() As Actor, _
        ActorIndex As Integer, _
        ActorOverlap As Integer _
    ) As Boolean

    Dim Result As Boolean
    
    If _
        ( _
            ActorList(ActorOverlap).StaticSpriteIndex = _
                GetSpriteIndex(GoldCode) And _
            ActorList(ActorIndex).StaticSpriteIndex <> _
                GetSpriteIndex(GoldCode) _
        ) Or _
        ( _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(GoldCode) And _
            ActorList(ActorOverlap).StaticSpriteIndex <> _
                GetSpriteIndex(GoldCode) _
        ) _
    Then
        If _
            ActorList(ActorIndex).StaticSpriteIndex = _
                GetSpriteIndex(GoldCode) _
        Then
            ActorList(ActorOverlap).GoldCount = _
                ActorList(ActorOverlap).GoldCount + 1
            ActorList(ActorIndex).SpriteSequence = "gold vanish"
            ActorList(ActorIndex).Solid = False
            ActorList(ActorIndex).Suspended = True
        Else
            ActorList(ActorIndex).GoldCount = _
                ActorList(ActorIndex).GoldCount + 1
            ActorList(ActorOverlap).SpriteSequence = "gold vanish"
            ActorList(ActorOverlap).Solid = False
            ActorList(ActorOverlap).Suspended = True
        End If
        Result = True
    End If
    HandleGoldContact = Result
    
End Function
Function _
    HandlePlayerContact( _
        ActorList() As Actor, _
        ActorIndex As Integer, _
        ActorOverlap As Integer _
    )

    If _
        ActorList(ActorIndex).StaticSpriteIndex = _
            GetSpriteIndex(PlayerCode) And _
        ActorList(ActorOverlap).StaticSpriteIndex = _
            GetSpriteIndex(EnemyCode) _
    Then
        If ActorList(ActorIndex).UseAux = 0 Then
            ActorList(ActorIndex).SpriteSequence = "player1 death"
            ActorList(ActorIndex).UserControl = False
        End If
    End If
    If _
        ActorList(ActorOverlap).StaticSpriteIndex = _
            GetSpriteIndex(PlayerCode) And _
        ActorList(ActorIndex).StaticSpriteIndex = _
            GetSpriteIndex(EnemyCode) _
    Then
        If ActorList(ActorOverlap).UseAux = 0 Then
            ActorList(ActorOverlap).SpriteSequence = "player1 death"
            ActorList(ActorOverlap).UserControl = False
        End If
    End If
    
End Function
Function InitEdit(LevelFile As String)

    Dim ActorIndex As Integer
    
    If LevelFile <> "" Then
        MemLevel = LoadLevel(LevelFile)
    Else
        ReDim MemLevel(LevelWidth * LevelHeight - 1)
    End If
    Call SecureLevel(MemLevel)
    ReDim MemActorList(0)
    ActorIndex = AddActor(MemActorList)
    MemActorList(ActorIndex).StaticSpriteIndex = GetSpriteIndex(PlayerCode)
    MemActorList(ActorIndex).Suspended = True
    MemActorList(ActorIndex).GridX = 1
    MemActorList(ActorIndex).GridY = 1
    MemActorList(ActorIndex).UserControl = True
    PlayerIndex = ActorIndex
    
End Function
Function ResetActor(ArgActor As Actor)

    ArgActor.SpriteIndex = ArgActor.SpriteStart
    Call PlaySoundEx(ArgActor.SoundFile)
    
End Function
Function SecureLevel(Level() As Integer)

    Dim i As Integer
    
    For i = 0 To LevelWidth - 1
        Level(i) = GetSpriteIndex(BrickCode)
        Level((LevelHeight - 1) * LevelWidth + i) = GetSpriteIndex(MetalCode)
    Next i
    For i = 1 To (LevelHeight - 1) - 1
        Level(i * LevelWidth) = GetSpriteIndex(BrickCode)
        Level(i * LevelWidth + (LevelWidth - 1)) = GetSpriteIndex(BrickCode)
    Next i
    
End Function
Function DeinitGame(FormHwnd As Long)

    Call ReleaseDC(FormHwnd, MemCanvasHdc)
    
End Function
Function GetAbsoluteIndex(ArgActor As Actor) As Integer

    Dim Result As Integer
    
    Result = _
        CInt(ArgActor.GridY) * LevelWidth + _
        CInt(ArgActor.GridX)
    GetAbsoluteIndex = Result
    
End Function
Function GetActorOverlap(ActorIndex As Integer, ActorList() As Actor) As Integer

    Dim i As Integer
    Dim Result As Integer
    
    If ActorList(ActorIndex).Solid Then
        For i = 1 To UBound(ActorList)
            If i <> ActorIndex Then
                If Not (ActorList(i).Disabled Or ActorList(i).Dormant) Then
                    If ActorList(i).Solid Then
                        If _
                            CInt(ActorList(i).GridX) = _
                                CInt(ActorList(ActorIndex).GridX) + _
                                Sgn(ActorList(ActorIndex).NetDeltaX) _
                            And _
                            CInt(ActorList(i).GridY) = _
                                CInt(ActorList(ActorIndex).GridY) + _
                                Sgn(ActorList(ActorIndex).NetDeltaY) _
                        Then
                            Result = i
                            Exit For
                        End If
                    End If
                End If
            End If
        Next i
    End If
    GetActorOverlap = Result
    
End Function
Function _
    DrawActorList( _
        BufferHdc As Long, _
        SpriteHdc As Long, _
        ActorList() As Actor, _
        MaskHdc As Long _
    )

    Dim i As Integer
    
    For i = 1 To UBound(ActorList)
        If Not (ActorList(i).Disabled Or ActorList(i).Dormant) Then
            Call _
                DrawGridEx( _
                    ActorList(i).SpriteIndex, _
                    BufferHdc, _
                    SpriteHdc, _
                    ActorList(i).GridX, _
                    ActorList(i).GridY, _
                    MaskHdc _
                )
        End If
    Next i
    
End Function
Function GetSpriteIndex(SpriteCode As String) As Integer

    Dim Result As Integer
    Dim GridX As Integer
    Dim GridY As Integer
    
    If SpriteCode <> Space(2) Then
        GridX = Int(Mid(SpriteCode, 2, 1))
        GridY = Asc(Mid(SpriteCode, 1, 1)) - Asc("a")
        Result = GridY * SpriteWidth + GridX
    Else
        Result = 0
    End If
    GetSpriteIndex = Result
    
End Function
Function _
    HandleActorMotion( _
        ActorIndex As Integer, _
        ActorList() As Actor, _
        AbsIndex As Integer, _
        Level() As Integer _
    )

    Dim ActorIndex1 As Integer
    Dim ActorOverlap As Integer
    
    If ActorList(ActorIndex).Suspended Then
        ActorList(ActorIndex).UseAux = 0
        ActorList(ActorIndex).AuxDeltaX = 0
        ActorList(ActorIndex).AuxDeltaY = 0
    Else
        If _
            Level(AbsIndex) <> GetSpriteIndex(LadderCode) And _
            Level(AbsIndex) <> GetSpriteIndex(RailCode) And _
            Level(AbsIndex + LevelWidth) <> GetSpriteIndex(BrickCode) And _
            Level(AbsIndex + LevelWidth) <> GetSpriteIndex(MetalCode) And _
            Level(AbsIndex + LevelWidth) <> GetSpriteIndex(LadderCode) _
        Then
            ActorList(ActorIndex).UseAux = 1
            ActorList(ActorIndex).AuxDeltaX = 0
            ActorList(ActorIndex).AuxDeltaY = ActorGravity
            If _
                ActorList(ActorIndex).StaticSpriteIndex = _
                    GetSpriteIndex(EnemyCode) _
            Then
                If ActorList(ActorIndex).GoldCount <> 0 Then
                    ActorList(ActorIndex).GoldCount = _
                        ActorList(ActorIndex).GoldCount - 1
                    ActorIndex1 = SpawnGoldDropEx(ActorList, GoldTime)
                    ActorList(ActorIndex1).GridX = _
                        CInt(ActorList(ActorIndex).GridX)
                    ActorList(ActorIndex1).GridY = _
                        CInt(ActorList(ActorIndex).GridY)
                    ActorList(ActorIndex1).Dormant = False
                    ActorOverlap = GetActorOverlap(ActorIndex1, ActorList)
                    If _
                        ActorList(ActorOverlap).StaticSpriteIndex = _
                            GetSpriteIndex(GoldCode) _
                    Then
                        ActorList(ActorIndex1).TriggerIndex = 0
                        ActorList(ActorIndex1).Disabled = True
                        ActorList(ActorIndex).GoldCount = _
                            ActorList(ActorIndex).GoldCount + 1
                    End If
                End If
            End If
        End If
    End If
    ActorList(ActorIndex).NetDeltaX = _
        ( _
            ActorList(ActorIndex).DeltaX * (1 - ActorList(ActorIndex).UseAux) + _
            ActorList(ActorIndex).AuxDeltaX * ActorList(ActorIndex).UseAux _
        ) * ActorSpeed
    ActorList(ActorIndex).NetDeltaY = _
        ( _
            ActorList(ActorIndex).DeltaY * (1 - ActorList(ActorIndex).UseAux) + _
            ActorList(ActorIndex).AuxDeltaY * ActorList(ActorIndex).UseAux _
        ) * ActorSpeed
    If Not ActorList(ActorIndex).Suspended Then
        If ActorList(ActorIndex).NetDeltaX > 0 Then 'right
            If _
                Level(AbsIndex + 1) = GetSpriteIndex(BrickCode) Or _
                Level(AbsIndex + 1) = GetSpriteIndex(MetalCode) Or _
                Level(AbsIndex + 1) = GetSpriteIndex(BrickInvisCode) _
            Then
                ActorList(ActorIndex).GridX = CInt(ActorList(ActorIndex).GridX)
                ActorList(ActorIndex).NetDeltaX = 0
            End If
        End If
        If ActorList(ActorIndex).NetDeltaX < 0 Then 'left
            If _
                Level(AbsIndex - 1) = GetSpriteIndex(BrickCode) Or _
                Level(AbsIndex - 1) = GetSpriteIndex(MetalCode) Or _
                Level(AbsIndex - 1) = GetSpriteIndex(BrickInvisCode) _
            Then
                ActorList(ActorIndex).GridX = CInt(ActorList(ActorIndex).GridX)
                ActorList(ActorIndex).NetDeltaX = 0
            End If
        End If
        If ActorList(ActorIndex).NetDeltaY > 0 Then 'down
            If _
                Level(AbsIndex + LevelWidth) = GetSpriteIndex(BrickCode) Or _
                Level(AbsIndex + LevelWidth) = GetSpriteIndex(MetalCode) Or _
                ( _
                    ActorList(ActorIndex).UseAux = 1 And _
                    ( _
                        Level(AbsIndex + LevelWidth) = _
                            GetSpriteIndex(LadderCode) Or _
                        Level(AbsIndex) = GetSpriteIndex(RailCode) _
                    ) _
                ) _
            Then
                If Not ActorList(ActorIndex).Suspended Then
                    ActorList(ActorIndex).UseAux = 0
                    ActorList(ActorIndex).AuxDeltaX = 0
                    ActorList(ActorIndex).AuxDeltaY = 0
                End If
                ActorList(ActorIndex).GridY = CInt(ActorList(ActorIndex).GridY)
                ActorList(ActorIndex).NetDeltaY = 0
            End If
        End If
        If ActorList(ActorIndex).NetDeltaY < 0 Then 'up
            If _
                Level(AbsIndex) <> GetSpriteIndex(LadderCode) Or _
                Level(AbsIndex - LevelWidth) = GetSpriteIndex(BrickCode) Or _
                Level(AbsIndex - LevelWidth) = GetSpriteIndex(MetalCode) _
            Then
                ActorList(ActorIndex).GridY = CInt(ActorList(ActorIndex).GridY)
                ActorList(ActorIndex).NetDeltaY = 0
            End If
        End If
    End If
    ActorOverlap = GetActorOverlap(ActorIndex, ActorList)
    ActorList(ActorIndex).GridX = _
        ActorList(ActorIndex).GridX + ActorList(ActorIndex).NetDeltaX
    ActorList(ActorIndex).GridY = _
        ActorList(ActorIndex).GridY + ActorList(ActorIndex).NetDeltaY
    If _
        Not ActorList(ActorIndex).Suspended And _
        Not ActorList(ActorOverlap).Suspended _
    Then
        If ActorOverlap <> 0 Then _
            Call HandleActorContact(ActorIndex, ActorOverlap, ActorList)
    End If
    
End Function
Function _
    HandleActorSuicide( _
        ActorIndex As Integer, _
        ActorList() As Actor, _
        AbsIndex As Integer, _
        Level() As Integer, _
        ScriptList() As Script _
    )

    Dim TriggerIndex As Integer
    
    If ActorList(ActorIndex).Disabled Then
        If ActorList(ActorIndex).TriggerIndex <> 0 Then
            TriggerIndex = ActorList(ActorIndex).TriggerIndex
            ActorList(TriggerIndex).Dormant = False
            ActorList(TriggerIndex).GridX = _
                ActorList(ActorIndex).GridX + ActorList(TriggerIndex).GridX
            ActorList(TriggerIndex).GridY = _
                ActorList(ActorIndex).GridY + ActorList(TriggerIndex).GridY
            Call ApplySpriteSequence(ActorList(TriggerIndex), ScriptList)
        End If
        If ActorList(ActorIndex).LeaveMark Then
            If _
                ActorList(ActorIndex).GridX > 0 And _
                ActorList(ActorIndex).GridY > 0 And _
                ActorList(ActorIndex).GridX < LevelWidth - 1 And _
                ActorList(ActorIndex).GridY < LevelHeight - 1 _
            Then _
                Level(AbsIndex) = ActorList(ActorIndex).StaticSpriteIndex
        End If
    End If
    
End Function
Function InitLevel(LevelFile As String)

    Dim i As Integer
    Dim ActorIndex As Integer
    
    If LevelFile <> "" Then
        MemLevel = LoadLevel(LevelFile)
        ReDim MemActorList(0)
        For i = 0 To UBound(MemLevel)
            If _
                Not _
                ( _
                    MemLevel(i) = GetSpriteIndex(VoidCode) Or _
                    MemLevel(i) = GetSpriteIndex(BrickCode) Or _
                    MemLevel(i) = GetSpriteIndex(MetalCode) Or _
                    MemLevel(i) = GetSpriteIndex(LadderCode) Or _
                    MemLevel(i) = GetSpriteIndex(RailCode) Or _
                    MemLevel(i) = GetSpriteIndex(BrickInvisCode) Or _
                    MemLevel(i) = GetSpriteIndex(CaveCode) _
                ) _
            Then
                ActorIndex = AddActor(MemActorList)
                MemActorList(ActorIndex).StaticSpriteIndex = MemLevel(i)
                MemActorList(ActorIndex).SpriteIndex = MemLevel(i)
                MemActorList(ActorIndex).GridX = i Mod LevelWidth
                MemActorList(ActorIndex).GridY = Int(i / LevelWidth)
                Select Case MemLevel(i)
                    Case _
                        GetSpriteIndex(PlayerCode), _
                        GetSpriteIndex(EnemyCode), _
                        GetSpriteIndex(GoldCode), _
                        GetSpriteIndex(RedBombCode), _
                        GetSpriteIndex(GreenBombCode), _
                        GetSpriteIndex(YellowBombCode), _
                        GetSpriteIndex(CyanBombCode)
                            MemActorList(ActorIndex).Solid = True
                End Select
                Select Case MemLevel(i)
                    Case GetSpriteIndex(PlayerCode)
                        PlayerIndex = ActorIndex
                        MemActorList(ActorIndex).UserControl = True
                    Case GetSpriteIndex(EnemyCode)
                        MemActorList(ActorIndex).HasAI = True
                End Select
                MemLevel(i) = GetSpriteIndex(VoidCode)
            End If
        Next i
        LevelGoldCount = CountActors(GetSpriteIndex(GoldCode), MemActorList)
    Else
        ReDim MemLevel(LevelWidth * LevelHeight - 1)
        ReDim MemActorList(0)
        PlayerIndex = 0
    End If
    Call SecureLevel(MemLevel)
    
End Function
Function LoadConfig(ConfigFile As String)

    Dim i As Integer
    Dim j As Integer
    Dim FileData As String
    Dim Entry As String
    Dim Setting As String
    
    FileData = LoadText(GetLocalResPath(ConfigFile))
    i = 1
    Do While i <= Len(FileData)
        Entry = ScanText(FileData, i, vbCrLf)
        If _
            Entry <> "" And _
            Left(Entry, 2) <> "//" _
        Then
            j = 1
            Setting = ScanText(Entry, j, " = ")
            Select Case Setting
            
                'game settings
                Case "SpriteFile"
                    SpriteFile = ScanText(Entry, j, " ")
                Case "ScriptFile"
                    ScriptFile = ScanText(Entry, j, " ")
                Case "UnitLength"
                    UnitLength = Int(ScanText(Entry, j, " "))
                Case "SpriteSize"
                    SpriteWidth = Int(ScanText(Entry, j, " "))
                    SpriteHeight = Int(ScanText(Entry, j, " "))
                Case "LevelSize"
                    LevelWidth = Int(ScanText(Entry, j, " "))
                    LevelHeight = Int(ScanText(Entry, j, " "))
                Case "ViewSize"
                    ViewWidth = Int(ScanText(Entry, j, " "))
                    ViewHeight = Int(ScanText(Entry, j, " "))
                Case "TickInterv"
                    TickInterv = Int(ScanText(Entry, j, " "))
                Case "ActorSpeed"
                    ActorSpeed = CSng(ScanText(Entry, j, " "))
                Case "ActorGravity"
                    ActorGravity = CSng(ScanText(Entry, j, " "))
                Case "BrickTime"
                    BrickTime = Int(ScanText(Entry, j, " "))
                Case "GoldTime"
                    GoldTime = Int(ScanText(Entry, j, " "))
                Case "ActorTime"
                    ActorTime = Int(ScanText(Entry, j, " "))
                Case "BombTime"
                    BombTime = Int(ScanText(Entry, j, " "))
                Case "WinSound"
                    WinSound = ScanText(Entry, j, " ")
                Case "LoseSound"
                    LoseSound = ScanText(Entry, j, " ")
                Case "PlotSound"
                    PlotSound = ScanText(Entry, j, " ")
                Case "ScrollSound"
                    ScrollSound = ScanText(Entry, j, " ")
                Case "StartLevel"
                    StartLevel = ScanText(Entry, j, " ")
                    
                'grid codes
                Case "Void"
                    VoidCode = ScanText(Entry, j, " ")
                Case "Metal"
                    MetalCode = ScanText(Entry, j, " ")
                Case "Brick"
                    BrickCode = ScanText(Entry, j, " ")
                Case "Ladder"
                    LadderCode = ScanText(Entry, j, " ")
                Case "Rail"
                    RailCode = ScanText(Entry, j, " ")
                Case "BrickInvis"
                    BrickInvisCode = ScanText(Entry, j, " ")
                Case "Cave"
                    CaveCode = ScanText(Entry, j, " ")
                Case "Gold"
                    GoldCode = ScanText(Entry, j, " ")
                Case "Player"
                    PlayerCode = ScanText(Entry, j, " ")
                Case "Enemy"
                    EnemyCode = ScanText(Entry, j, " ")
                Case "Hide"
                    HideCode = ScanText(Entry, j, " ")
                Case "RedBomb"
                    RedBombCode = ScanText(Entry, j, " ")
                Case "GreenBomb"
                    GreenBombCode = ScanText(Entry, j, " ")
                Case "YellowBomb"
                    YellowBombCode = ScanText(Entry, j, " ")
                Case "CyanBomb"
                    CyanBombCode = ScanText(Entry, j, " ")
                    
            End Select
        End If
    Loop
    
End Function
Function LoadLevel(LevelFile As String) As Integer()

    LoadLevel = BuildLevel(LoadText(GetLocalResPath(LevelFile)))
    
End Function
Function BuildScriptList(FileData As String) As Script()

    Dim i As Integer
    Dim j As Integer
    Dim Result() As Script
    Dim Entry As String
    
    ReDim Result(0)
    i = 1
    Do While i <= Len(FileData)
        Entry = ScanText(FileData, i, vbCrLf)
        If _
            Entry <> "" And _
            Left(Entry, 2) <> "//" _
        Then
            ScriptIndex = AddScript(Result)
            j = 1
            Result(ScriptIndex).SpriteSequence = ScanText(Entry, j, " = ")
            Result(ScriptIndex).SpriteStart = GetSpriteIndex(ScanText(Entry, j, " "))
            Result(ScriptIndex).SpriteEnd = GetSpriteIndex(ScanText(Entry, j, " "))
            Result(ScriptIndex).SoundFile = ScanText(Entry, j, " ")
            Result(ScriptIndex).DeltaX = CSng(Val(ScanText(Entry, j, " ")))
            Result(ScriptIndex).DeltaY = CSng(Val(ScanText(Entry, j, " ")))
            Result(ScriptIndex).OneTimeOnly = CBool(Val(ScanText(Entry, j, " ")))
            Result(ScriptIndex).SelfDestruct = CBool(Val(ScanText(Entry, j, " ")))
        End If
    Loop
    BuildScriptList = Result()
    
End Function
Function DrawMask(MaskObj As PictureBox, SpriteObj As PictureBox)

    Dim i As Integer
    Dim j As Integer
    
    MaskObj.BackColor = vbWhite
    MaskObj.BorderStyle = vbBSNone
    MaskObj.AutoRedraw = True
    MaskObj.ScaleMode = vbPixels
    MaskObj.Width = SpriteObj.Width
    MaskObj.Height = SpriteObj.Height
    
    For j = 0 To SpriteObj.ScaleHeight - 1
        For i = 0 To SpriteObj.ScaleWidth - 1
            If SpriteObj.Point(i, j) <> vbBlack Then _
                MaskObj.PSet (i, j), vbBlack
        Next i
    Next j
    
End Function
Function _
    DrawBuffer( _
        CanvasHdc As Long, _
        CanvasWidth As Integer, _
        CanvasHeight As Integer, _
        BufferObj As PictureBox _
    )

    Dim GridX As Single
    Dim GridY As Single
    
    GridX = MemActorList(PlayerIndex).GridX - ViewWidth
    GridY = MemActorList(PlayerIndex).GridY - ViewHeight
    If GridX < 0 Then GridX = 0
    If GridY < 0 Then GridY = 0
    If GridX > LevelWidth - (ViewWidth * 2 + 1) Then _
        GridX = LevelWidth - (ViewWidth * 2 + 1)
    If GridY > LevelHeight - (ViewHeight * 2 + 1) Then _
        GridY = LevelHeight - (ViewHeight * 2 + 1)
    Call _
        StretchBlt( _
            CanvasHdc, _
            0, _
            0, _
            CanvasWidth, _
            CanvasHeight, _
            BufferObj.hdc, _
            (GridX / LevelWidth) * BufferObj.ScaleWidth, _
            (GridY / LevelHeight) * BufferObj.ScaleHeight, _
            ((ViewWidth * 2 + 1) / LevelWidth) * BufferObj.ScaleWidth, _
            ((ViewHeight * 2 + 1) / LevelHeight) * BufferObj.ScaleHeight, _
            vbSrcCopy _
        )
        
End Function
Function _
    DrawGridEx( _
        SpriteIndex As Integer, _
        BufferHdc As Long, _
        SpriteHdc As Long, _
        GridX As Single, _
        GridY As Single, _
        MaskHdc As Long _
    )

    Call DrawGrid(SpriteIndex, BufferHdc, MaskHdc, GridX, GridY, vbSrcAnd)
    Call DrawGrid(SpriteIndex, BufferHdc, SpriteHdc, GridX, GridY, vbSrcPaint)
    
End Function
Function _
    DrawLevel( _
        BufferHdc As Long, _
        SpriteHdc As Long, _
        Level() As Integer _
    )

    Dim GridX As Integer
    Dim GridY As Integer
    
    For GridY = 0 To LevelHeight - 1
        For GridX = 0 To LevelWidth - 1
            Call _
                DrawGrid( _
                    Level(GridY * LevelWidth + GridX), _
                    BufferHdc, _
                    SpriteHdc, _
                    CSng(GridX), _
                    CSng(GridY), _
                    vbSrcCopy _
                )
        Next GridX
    Next GridY
    
End Function
Function BuildLevel(FileData As String) As Integer()

    Dim i As Integer
    Dim Result() As Integer
    Dim SpriteCode As String
    Dim SpriteIndex As Integer
    Dim GridX As Integer
    Dim GridY As Integer
    
    ReDim Result(LevelWidth * LevelHeight - 1)
    For i = 1 To Len(FileData) Step 2
        SpriteCode = Mid(FileData, i, 2)
        If SpriteCode <> vbCrLf Then
            SpriteIndex = GetSpriteIndex(SpriteCode)
            GridX = GridX + 1
            Result(GridY * LevelWidth + GridX - 1) = SpriteIndex
        Else
            GridX = 0
            GridY = GridY + 1
        End If
    Next i
    BuildLevel = Result()
    
End Function
Function _
    InitGame( _
        ConfigFile As String, _
        SpriteObj As PictureBox, _
        BufferObj As PictureBox, _
        CanvasObj As CommandButton, _
        MaskObj As PictureBox, _
        TimerObj As Timer _
    )

    Call LoadConfig(ConfigFile)
    
    SpriteObj.Picture = LoadPicture(GetLocalResPath(SpriteFile))
    SpriteObj.BorderStyle = vbBSNone
    SpriteObj.AutoRedraw = True
    SpriteObj.ScaleMode = vbPixels
    SpriteObj.Width = (SpriteWidth * UnitLength) * Screen.TwipsPerPixelX
    SpriteObj.Height = (SpriteHeight * UnitLength) * Screen.TwipsPerPixelY
    SpriteObj.Visible = False
    
    BufferObj.BackColor = vbBlack
    BufferObj.BorderStyle = vbBSNone
    BufferObj.AutoRedraw = True
    BufferObj.ScaleMode = vbPixels
    BufferObj.Width = (LevelWidth * UnitLength) * Screen.TwipsPerPixelX
    BufferObj.Height = (LevelHeight * UnitLength) * Screen.TwipsPerPixelY
    BufferObj.Visible = False
    
    CanvasObj.Caption = ""
    CanvasObj.Enabled = False
    CanvasObj.Visible = True
    
    Call DrawMask(MaskObj, SpriteObj)
    MaskObj.Visible = False
    
    TimerObj.Interval = TickInterv
    
    MemCanvasHdc = GetDC(CanvasObj.hwnd)
    MemScriptList = BuildScriptList(LoadText(GetLocalResPath(ScriptFile)))
    
End Function
Function _
    DrawGrid( _
        SpriteIndex As Integer, _
        BufferHdc As Long, _
        SpriteHdc As Long, _
        GridX As Single, _
        GridY As Single, _
        Rop As Long _
    )

    Call _
        BitBlt( _
            BufferHdc, _
            Int(GridX * UnitLength), _
            Int(GridY * UnitLength), _
            UnitLength, _
            UnitLength, _
            SpriteHdc, _
            (SpriteIndex Mod SpriteWidth) * UnitLength, _
            Int(SpriteIndex / SpriteWidth) * UnitLength, _
            Rop _
        )
        
End Function
Function PolishEdges(ActorList() As Actor, Level() As Integer)

    Dim i As Integer
    Dim SpriteSequence As String
    Dim AbsIndex As Integer
    
    For i = 1 To UBound(ActorList)
        If _
            ActorList(i).NetDeltaX = 0 And _
            ActorList(i).NetDeltaY = 0 _
        Then
            ActorList(i).GridX = CInt(ActorList(i).GridX)
            ActorList(i).GridY = CInt(ActorList(i).GridY)
        Else
            If ActorList(i).NetDeltaX <> 0 Then _
                ActorList(i).GridY = CInt(ActorList(i).GridY)
            If ActorList(i).NetDeltaY <> 0 Then _
                ActorList(i).GridX = CInt(ActorList(i).GridX)
            If ActorList(i).GridX < 0 Then
                ActorList(i).GridX = 0
                ActorList(i).NetDeltaX = 0
            End If
            If ActorList(i).GridY < 0 Then
                ActorList(i).GridY = 0
                ActorList(i).NetDeltaY = 0
            End If
            If ActorList(i).GridX > LevelWidth - 1 Then
                ActorList(i).GridX = LevelWidth - 1
                ActorList(i).NetDeltaX = 0
            End If
            If ActorList(i).GridY > LevelHeight - 1 Then
                ActorList(i).GridY = LevelHeight - 1
                ActorList(i).NetDeltaY = 0
            End If
        End If
        Select Case ActorList(i).StaticSpriteIndex
            Case GetSpriteIndex(PlayerCode)
                SpriteSequence = "player1"
            Case GetSpriteIndex(EnemyCode)
                SpriteSequence = "player2"
            Case Else
                SpriteSequence = ""
        End Select
        If _
            (SpriteSequence = "player1" And ActorList(i).UserControl) Or _
            (SpriteSequence = "player2" And ActorList(i).HasAI) _
        Then
            SpriteSequence = SpriteSequence & " "
            If ActorList(i).UseAux = 1 Then
                ActorList(i).SpriteSequence = SpriteSequence & "fall"
            Else
                If _
                    ( _
                        ActorList(i).DeltaX = 0 And _
                        ActorList(i).DeltaY = 0 _
                    ) Or _
                    ( _
                        ActorList(i).DeltaX <> 0 And _
                        ActorList(i).NetDeltaX = 0 _
                    ) Or _
                    ( _
                        ActorList(i).DeltaY <> 0 And _
                        ActorList(i).NetDeltaY = 0 _
                    ) _
                Then _
                    ActorList(i).SpriteSequence = SpriteSequence & "stop"
            End If
            AbsIndex = GetAbsoluteIndex(ActorList(i))
            If _
                ActorList(i).DeltaX = 0 And _
                ActorList(i).DeltaY = 0 And _
                Level(AbsIndex) = GetSpriteIndex(CaveCode) _
            Then _
                ActorList(i).SpriteSequence = SpriteSequence & "hide"
            If Level(AbsIndex) = GetSpriteIndex(BrickCode) Then
                If Not ActorList(i).Suspended Then
                    ActorList(i).SpriteSequence = SpriteSequence & "death"
                    If Left(SpriteSequence, Len("player1")) = "player1" Then
                        ActorList(i).UserControl = False
                    Else
                        ActorList(i).HasAI = False
                    End If
                    ActorList(i).Suspended = True
                End If
            End If
        End If
    Next i
    
End Function
Function _
    UpdateActorList( _
        ActorList() As Actor, _
        ScriptList() As Script, _
        Level() As Integer _
    )

    Dim i As Integer
    Dim AbsIndex As Integer
    
    For i = 1 To UBound(ActorList)
        If Not (ActorList(i).Disabled Or ActorList(i).Dormant) Then
            If _
                ActorList(i).SpriteSequence <> "" And _
                ActorList(i).SpriteSequence <> ActorList(i).PrevSpriteSequence _
            Then
                Call ApplySpriteSequence(ActorList(i), ScriptList)
            Else
                If ActorList(i).SpriteStart <> 0 Then
                    If ActorList(i).SpriteIndex < ActorList(i).SpriteEnd Then
                        ActorList(i).SpriteIndex = ActorList(i).SpriteIndex + 1
                    Else
                        If ActorList(i).OneTimeOnly Then
                            If ActorList(i).SelfDestruct Then _
                                ActorList(i).Disabled = True
                        Else
                            Call ResetActor(ActorList(i))
                        End If
                    End If
                End If
                If ActorList(i).Decays Then
                    If ActorList(i).LifeSpan > 0 Then
                        ActorList(i).LifeSpan = ActorList(i).LifeSpan - 1
                    Else
                        ActorList(i).Disabled = True
                    End If
                End If
            End If
            AbsIndex = GetAbsoluteIndex(ActorList(i))
            Call HandleActorSuicide(i, ActorList, AbsIndex, Level, ScriptList)
            Call HandleActorMotion(i, ActorList, AbsIndex, Level)
        End If
    Next i
    
End Function
