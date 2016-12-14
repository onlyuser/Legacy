Attribute VB_Name = "Module3"
Option Explicit

Public PauseFlag As Boolean
Public StopFlag As Boolean
Public ByteNumber As Integer
Public ParsedScr As String
Public ParsedExp As String
Function CheckScrFormat(Script As String) As String 'FIXME

    'counters
    Dim i As Integer
    Dim k As Integer
    
    'parse vars
    Dim Text As String
    Dim Length As Integer
    Dim Statement As String
    Dim Symbol As String
    Dim Result As String
    
    Length = Len(Text)
    i = 1
    Do
        Statement = ScanText(Text, i, vbCrLf)
        If Statement <> "" Then
            k = 1
            Symbol = GetNextSymbol(Statement, k, True)
            Select Case Symbol
                Case "{", "}"
                Case Else
            End Select
        End If
    Loop
    
End Function
Function FixScrLanguage(Script As String) As String

    Dim Result As String
    
    Result = Script
    Result = EditReplace(Result, ";", vbCrLf)
    Result = EditReplace(Result, "{", "{" & vbCrLf)
    Result = EditReplace(Result, "}", "}" & vbCrLf)
    Result = EditReplace(Result, "){", ")" & vbCrLf & "{")
    Result = EditReplace(Result, "do{", "do" & vbCrLf & "{")
    Result = EditReplace(Result, "else{", "else" & vbCrLf & "{")
    Result = EditReplace(Result, "default{", "default" & vbCrLf & "{")
    FixScrLanguage = Result
    
End Function
Function _
    Execute( _
        Script As String, _
        ParamStack As ListBox, _
        OpStack As ListBox, _
        BufStack As ListBox, _
        NameList As ListBox, _
        ValList As ListBox, _
        FuncStack As ListBox _
    ) As String

    'counters
    Dim i As Integer
    Dim k As Integer
    
    'parse vars
    Dim Text As String
    Dim Length As Integer
    Dim Statement As String
    Dim Symbol As String
    Dim Parameter As String
    Dim Result As String
    Dim RealDepth As Integer
    Dim ResumeDepth As Integer
    
    'parse flags
    Dim Ignoring As Boolean
    Dim Breaking As Boolean
    
    'block vars
    Dim BlockName As String
    Dim BlockDepth As Integer
    Dim BlockStart As Integer
    Dim EnterCondition As String
    Dim ExitCondition As String
    Dim Incrementation As String
    Dim Branchable As Boolean
    Dim HasExtraData As Boolean
    Dim Branched As Boolean
    Dim ExtraData As String
    
    'general purpose
    Dim Flag1 As Boolean
    Dim Flag2 As Boolean
    Dim Flag3 As Boolean
    
    '============================================================
    'search for sub main
    '============================================================
    Text = FixScrStructure(Script) 'check script syntax
    If IsError(Text) Then
        ParsedScr = ""
        ByteNumber = 0
        Execute = Text
        Exit Function
    End If
    Text = EditDespace(Text)
    Length = Len(Text)
    i = 1 'start from script start
    Do While i < Length
        Statement = ScanText(Text, i, vbCrLf) 'for each line
        If Statement <> "" Then
            k = 1
            Symbol = GetNextSymbol(Statement, k, True) 'for first symbol
            If Symbol = "sub" Then
                Parameter = Mid(Statement, k + 1, Len(Statement) - k - 1)
                Call VarAdd(NameList, ValList, Parameter, CDbl(i)) 'save block start
            End If
        End If
    Loop
    If VarGet(NameList, ValList, "main") = 0 Then
        ParsedScr = ""
        ByteNumber = 0
        Execute = MakeError("SUB MAIN NOT FOUND")
        Exit Function
    End If
    '============================================================
    'call sub main
    '============================================================
    i = Len(Text) + Len(vbCrLf) + 1 'start from script end
    'call sub main at script end
    Text = _
        Text & vbCrLf & _
        "call(main)" & vbCrLf
    Length = Len(Text)
    Do While i < Length
        Statement = ScanText(Text, i, vbCrLf) 'for each line
        If Statement <> "" Then
            k = 1
            Symbol = GetNextSymbol(Statement, k, True) 'for first symbol
            Select Case Symbol
                Case "{"
                    If Not Ignoring Then
                        'check enter condition
                        Result = _
                            Evaluate( _
                                EnterCondition, _
                                ParamStack, OpStack, BufStack, NameList, ValList, _
                                False _
                            )
                        If Result = "1" Then 'if enter condition met
                            If Branchable Then 'if block branchable
                                'update branched flag
                                Call StackPop(FuncStack)
                                Branched = True
                                Call StackPush(FuncStack, CStr(Branched And 1))
                            End If
                            'save block vars
                            Call _
                                BlockPush( _
                                    FuncStack, _
                                    BlockStart, _
                                    EnterCondition, ExitCondition, Incrementation, _
                                    Branchable, HasExtraData _
                                )
                            BlockDepth = RealDepth + 1 'use new depth
                        Else
                            Ignoring = True 'ignore all statements
                            ResumeDepth = RealDepth 'set resume depth
                            BlockDepth = RealDepth 'retain old depth
                        End If
                    Else
                        BlockDepth = RealDepth 'retain old depth
                    End If
                    '==============================
                    'save required block vars
                    Call StackPush(FuncStack, CStr(BlockDepth))
                    Call StackPush(FuncStack, BlockName)
                    '==============================
                    RealDepth = RealDepth + 1 'increment real depth
                Case "}"
                    '==============================
                    'load required block vars
                    BlockName = StackPop(FuncStack)
                    BlockDepth = CInt(StackPop(FuncStack))
                    '==============================
                    If BlockDepth = RealDepth Then 'if enter condition met
                        'do built-in incrementation
                        Call _
                            Evaluate( _
                                Incrementation, _
                                ParamStack, OpStack, BufStack, NameList, ValList, _
                                False _
                            )
                        'check exit condition
                        Result = _
                            Evaluate( _
                                ExitCondition, _
                                ParamStack, OpStack, BufStack, NameList, ValList, _
                                False _
                            )
                        'if exit condition not met
                        If Result = "0" Then _
                            i = CInt(StackTop(FuncStack)) 'return to block start
                        'load block vars
                        Call _
                            BlockPop( _
                                FuncStack, _
                                BlockStart, _
                                EnterCondition, ExitCondition, Incrementation, _
                                Branchable, HasExtraData _
                            )
                    Else
                        Result = "0" 'assume exit condition not met
                    End If
                    RealDepth = RealDepth - 1 'decrement real depth
                    If _
                        Not _
                        ( _
                            BlockName = "do" Or _
                            ( _
                                BlockName = "sub" And _
                                Not Breaking _
                            ) _
                        ) _
                    Then
                        Flag3 = True
                        'if necessary
                        Call _
                            HandleBreak( _
                                Breaking, _
                                RealDepth, _
                                ResumeDepth, _
                                BlockName _
                            ) 'break block
                    Else
                        Flag3 = False
                    End If
                    If Result = "1" Then 'if exiting block
                        If RealDepth <> 0 Then 'if not base block
                            'restore next-up block vars
                            Flag1 = Branchable
                            Flag2 = HasExtraData
                            If Flag1 Then _
                                Branched = CBool(StackPop(FuncStack))
                            If Flag2 Then _
                                ExtraData = StackPop(FuncStack)
                            Call _
                                BlockRefresh( _
                                    FuncStack, _
                                    BlockName, BlockDepth, BlockStart, _
                                    EnterCondition, ExitCondition, Incrementation, _
                                    Branchable, HasExtraData _
                                )
                            If Flag2 Then _
                                Call StackPush(FuncStack, ExtraData)
                            If Flag1 Then _
                                Call StackPush(FuncStack, CStr(Branched And 1))
                        End If
                    End If
                    'if necessary
                    If Flag3 Then _
                        Call _
                            HandleIgnore( _
                                Ignoring, _
                                RealDepth, _
                                ResumeDepth, _
                                ExitCondition, _
                                Branched _
                            ) 'stop ignoring
                'for blocks
                Case "for", "while", "if", "switch", "elseif", "case", "sub", "call", "do", "else", "default", "return"
                    BlockName = Symbol
                    BlockDepth = 0
                    If Not Ignoring Then
                        'set default block vars
                        BlockStart = i
                        EnterCondition = "1"
                        ExitCondition = "1"
                        Incrementation = ""
                        Branchable = False
                        HasExtraData = False
                        Branched = False
                        ExtraData = ""
                        Select Case Symbol
                            'for blocks with parameters
                            Case "for", "while", "if", "switch", "elseif", "case", "sub", "call"
                                If Right(Statement, 1) <> ";" Then
                                    Parameter = Mid(Statement, k + 1, Len(Statement) - k - 1)
                                Else
                                    Parameter = Mid(Statement, k + 1, Len(Statement) - k - 2)
                                End If
                                If Symbol = "for" Then
                                    Call ScanText(Statement, k, "(")
                                    Call _
                                        Evaluate( _
                                            ScanText(Statement, k, ";"), _
                                            ParamStack, OpStack, BufStack, NameList, ValList, _
                                            False _
                                        )
                                    EnterCondition = ScanText(Statement, k, ";")
                                    Incrementation = ScanText(Statement, k, ")")
                                    ExitCondition = "not(" & EnterCondition & ")"
                                Else
                                    Select Case Symbol
                                        Case "while"
                                            If Right(Statement, 1) <> ";" Then
                                                EnterCondition = Parameter
                                                ExitCondition = "not(" & Parameter & ")"
                                            Else
                                                ExitCondition = "not(" & Parameter & ")"
                                                Result = _
                                                    Evaluate( _
                                                        ExitCondition, _
                                                        ParamStack, OpStack, BufStack, NameList, ValList, _
                                                        False _
                                                    )
                                                If Result = "0" Then
                                                    BlockName = "do" 'reset block name
                                                    BlockStart = CInt(StackTop(FuncStack))
                                                    EnterCondition = Parameter
                                                    HasExtraData = True
                                                    i = BlockStart 'return to "do" block start
                                                Else
                                                    '==============================
                                                    Call StackPop(FuncStack)
                                                    '==============================
                                                    'if not base block
                                                    If RealDepth <> 0 Then _
                                                        Call _
                                                            BlockRefresh( _
                                                                FuncStack, _
                                                                BlockName, BlockDepth, BlockStart, _
                                                                EnterCondition, ExitCondition, Incrementation, _
                                                                Branchable, HasExtraData _
                                                            ) 'restore next-up block vars
                                                End If
                                            End If
                                        Case "if"
                                            EnterCondition = Parameter
                                            '==============================
                                            Branchable = True
                                            Branched = False
                                            Call StackPush(FuncStack, CStr(Branched And 1))
                                            '==============================
                                        Case "switch"
                                            EnterCondition = "0" 'ignore this block
                                            '==============================
                                            HasExtraData = True
                                            ExtraData = Parameter
                                            Call StackPush(FuncStack, ExtraData)
                                            Branchable = True
                                            Branched = False
                                            Call StackPush(FuncStack, CStr(Branched And 1))
                                            '==============================
                                        Case "elseif", "case"
                                            Branchable = True
                                            Branched = CBool(StackPop(FuncStack))
                                            If Symbol = "case" Then
                                                HasExtraData = True
                                                ExtraData = StackTop(FuncStack)
                                            End If
                                            Call StackPush(FuncStack, CStr(Branched And 1))
                                            If Branched Then
                                                EnterCondition = "0"
                                            Else
                                                If Symbol = "case" Then
                                                    EnterCondition = _
                                                        "(" & Parameter & ")" & _
                                                        "==" & _
                                                        "(" & ExtraData & ")"
                                                Else
                                                    EnterCondition = Parameter
                                                End If
                                            End If
                                        Case "sub"
                                            EnterCondition = "0" 'ignore this block
                                            '==============================
                                            HasExtraData = True
                                            ExtraData = ""
                                            Call StackPush(FuncStack, ExtraData)
                                            '==============================
                                        Case "call"
                                            BlockName = "sub" 'reset block name
                                            '==============================
                                            HasExtraData = True
                                            ExtraData = CStr(BlockStart)
                                            Call StackPush(FuncStack, ExtraData)
                                            '==============================
                                            BlockStart = CInt(VarGet(NameList, ValList, Parameter))
                                            i = BlockStart
                                    End Select
                                End If
                            Case "do"
                                '==============================
                                HasExtraData = True
                                ExtraData = CStr(BlockStart)
                                Call StackPush(FuncStack, ExtraData)
                                '==============================
                            Case "else", "default"
                                '==============================
                                Branched = CBool(StackPop(FuncStack))
                                If Symbol = "default" Then _
                                    ExtraData = StackPop(FuncStack)
                                '==============================
                                If Branched Then _
                                    EnterCondition = "0"
                            Case "return"
                                '==============================
                                BlockStart = CInt(StackPop(FuncStack))
                                '==============================
                                i = BlockStart
                                'if not base block
                                If RealDepth <> 0 Then _
                                    Call _
                                        BlockRefresh( _
                                            FuncStack, _
                                            BlockName, BlockDepth, BlockStart, _
                                            EnterCondition, ExitCondition, Incrementation, _
                                            Branchable, HasExtraData _
                                        ) 'restore next-up block vars
                        End Select
                    Else
                        'push and pop dummy vars
                        Select Case Symbol
                            Case "while", "return"
                                If _
                                    ( _
                                        Symbol = "while" And _
                                        Right(Statement, 1) = ";" _
                                    ) Or _
                                    Symbol = "return" _
                                Then
                                    '==============================
                                    Call StackPop(FuncStack)
                                    '==============================
                                    'reset block name
                                    If Symbol = "while" Then
                                        BlockName = "do"
                                    Else
                                        BlockName = "sub"
                                    End If
                                    'if necessary
                                    Call _
                                        HandleBreak( _
                                            Breaking, _
                                            RealDepth, _
                                            ResumeDepth, _
                                            BlockName _
                                        ) 'break block
                                    'if necessary
                                    Call _
                                        HandleIgnore( _
                                            Ignoring, _
                                            RealDepth, _
                                            ResumeDepth, _
                                            ExitCondition, _
                                            Branched _
                                        ) 'stop ignoring
                                    'if not base block
                                    If _
                                        BlockDepth = RealDepth And _
                                        RealDepth <> 0 _
                                    Then _
                                        Call _
                                            BlockRefresh( _
                                                FuncStack, _
                                                BlockName, BlockDepth, BlockStart, _
                                                EnterCondition, ExitCondition, Incrementation, _
                                                Branchable, HasExtraData _
                                            ) 'restore next-up block vars
                                End If
                            Case "if", "switch", "do"
                                '==============================
                                Call StackPush(FuncStack, "")
                                If Symbol = "switch" Then _
                                    Call StackPush(FuncStack, "")
                                '==============================
                            Case "else", "default"
                                '==============================
                                Call StackPop(FuncStack)
                                If Symbol = "default" Then _
                                    Call StackPop(FuncStack)
                                '==============================
                        End Select
                    End If
                Case Else
                    If Not Ignoring Then
                        Select Case Symbol
                            Case "break"
                                Ignoring = True 'ignore all statements
                                Breaking = True 'break nearest loop
                                ResumeDepth = RealDepth - 1 'resume on next-up block
                                Call SetExitState(ExitCondition, Branched) 'exit current block
                            Case "pause"
                                PauseFlag = True
                            Case Else
                                'process statement
                                Result = _
                                    Evaluate( _
                                        Statement, _
                                        ParamStack, OpStack, BufStack, NameList, ValList, _
                                        False _
                                    )
                                If Not IsError(Result) Then
                                    Execute = _
                                        Execute & _
                                        Statement & " => " & Result & vbCrLf
                                Else
                                    ParsedScr = Execute
                                    ByteNumber = i
                                    Execute = Result
                                    Exit Function
                                End If
                        End Select
                    End If
            End Select
        End If
        DoEvents 'process user events
        'process user pause
        Do While PauseFlag
            ByteNumber = i
            DoEvents
        Loop
        'process user stop
        If StopFlag Then
            ParsedScr = Execute
            ByteNumber = i
            Execute = MakeError("STOPPED BY USER")
            Exit Function
        End If
    Loop
    
End Function
Function FixScrSyntax(Script As String) As String

    Dim Result As String
    
    Result = Script
    Result = EditReplacePtn(Result, "/*", "*/", "") 'remove block comments
    Result = EditReplacePtn(Result, "//", vbCrLf, "") 'remove line comments
    Result = EditDespace(Result) 'format input
    Result = LCase(Result)
    Result = FixScrLanguage(Result)
    Result = FixScrStructure(Result)
    FixScrSyntax = Result
    
End Function
Function _
    HandleBreak( _
        Breaking As Boolean, _
        RealDepth As Integer, _
        ResumeDepth As Integer, _
        BlockName As String _
    )

    If Breaking Then
        If RealDepth = ResumeDepth Then
            If _
                BlockName = "for" Or _
                BlockName = "while" Or _
                BlockName = "do" Or _
                BlockName = "sub" Or _
                RealDepth = 0 _
            Then
                Breaking = False
            Else
                ResumeDepth = RealDepth - 1 'resume on next-up block
            End If
        End If
    End If
    
End Function
Function _
    HandleIgnore( _
        Ignoring As Boolean, _
        RealDepth As Integer, _
        ResumeDepth As Integer, _
        ExitCondition As String, _
        Branched As Boolean _
    )

    If Ignoring Then
        If RealDepth = ResumeDepth Then
            Ignoring = False
        Else
            Call SetExitState(ExitCondition, Branched) 'exit current block
        End If
    End If
    
End Function
Function FixScrStructure(Script As String) As String

    'counters
    Dim i As Integer
    Dim j As Integer
    
    'parse vars
    Dim Result As String
    Dim Length As Integer
    Dim Statement As String
    Dim Symbol As String
    Dim Buffer As String
    Dim Depth As Integer
    
    '============================================================
    'check script syntax
    '============================================================
    Length = Len(Script)
    i = 1 'start from script start
    Do While i <= Length
        Statement = ScanText(Script, i, vbCrLf) 'for each line
        If Statement <> "" Then
            j = 1
            Symbol = GetNextSymbol(Statement, j, True) 'for first symbol
            Select Case Symbol
                'adjust depth as cued by content brackets
                Case "{"
                    Depth = Depth + 1
                Case "}"
                    Depth = Depth - 1
                'for blocks with parameters
                Case "for", "while", "if", "switch", "elseif", "case", "sub", "call"
                    'check against condition bracket omission
                    If GetNextSymbol(Statement, j, True) <> "(" Then
                        ParsedScr = Result
                        ParsedExp = Statement
                        ByteNumber = i
                        Result = MakeError("EXPECTED SYMBOL NOT FOUND")
                        FixScrStructure = Result
                        Exit Function
                    End If
                    If Symbol = "for" Then
                        '==============================
                        'check initialization
                        '==============================
                        Buffer = _
                            FixExpSyntax( _
                                Right( _
                                    Statement, _
                                    Len(Statement) - (Len(Symbol) + 1) _
                                ) _
                            )
                        If IsError(Buffer) Then
                            ParsedScr = Result
                            ParsedExp = Statement
                            ByteNumber = i
                            Result = Buffer
                            FixScrStructure = Result
                            Exit Function
                        End If
                        Statement = FixExpFormat(Buffer)
                        '==============================
                        'check loop condition
                        '==============================
                        Buffer = FixExpSyntax(ScanText(Script, i, vbCrLf))
                        If IsError(Buffer) Then
                            ParsedScr = Result
                            ParsedExp = Statement
                            ByteNumber = i
                            Result = Buffer
                            FixScrStructure = Result
                            Exit Function
                        End If
                        Statement = Statement & "; " & FixExpFormat(Buffer)
                        '==============================
                        'check incrementation
                        '==============================
                        Buffer = FixExpSyntax(ScanText(Script, i, vbCrLf))
                        If IsError(Buffer) Then
                            ParsedScr = Result
                            ParsedExp = Statement
                            ByteNumber = i
                            Result = Buffer
                            FixScrStructure = Result
                            Exit Function
                        End If
                        If Right(Buffer, 1) <> ")" Then
                            ParsedScr = Result
                            ParsedExp = Statement
                            ByteNumber = i
                            Result = MakeError("EXPECTED SYMBOL NOT FOUND")
                            FixScrStructure = Result
                            Exit Function
                        End If
                        Buffer = Left(Buffer, Len(Buffer) - 1)
                        Statement = Statement & "; " & FixExpFormat(Buffer)
                        Buffer = Statement 'save piece parameter
                        Call ScanText(Script, i, vbCrLf) 'seek next line
                    Else
                        '==============================
                        'check parameter
                        '==============================
                        Buffer = _
                            FixExpSyntax( _
                                Mid( _
                                    Statement, _
                                    j, _
                                    Len(Statement) - j _
                                ) _
                            )
                        If IsError(Buffer) Then
                            ParsedScr = Result
                            ParsedExp = Statement
                            ByteNumber = i
                            Result = Buffer
                            FixScrStructure = Result
                            Exit Function
                        End If
                        Statement = FixExpFormat(Buffer)
                        Buffer = Statement 'save parameter
                    End If
                    'build block header
                    Statement = _
                        Symbol & "(" & Buffer & ")"
                    'determine which "while" form to use
                    If _
                        Symbol = "while" And _
                        Mid(Script, i, 1) <> "{" _
                    Then _
                        Statement = Statement & ";"
                Case "do", "else", "default", "return", "break", "pause"
                Case Else
                    '==============================
                    'check statement
                    '==============================
                    Buffer = FixExpSyntax(Statement)
                    If Not IsError(Buffer) Then
                        Statement = FixExpFormat(Buffer)
                    Else
                        ParsedScr = Result
                        ParsedExp = Statement
                        ByteNumber = i
                        Result = Buffer
                        FixScrStructure = Result
                        Exit Function
                    End If
            End Select
            'check against content bracket abuse
            If Depth < 0 Then
                ParsedScr = Result
                ParsedExp = Statement
                ByteNumber = i
                Result = MakeError("TOO MANY CLOSED BRACKETS")
                FixScrStructure = Result
                Exit Function
            End If
            'set correct indentation
            For j = 1 To Depth
                Result = _
                    Result & vbTab
            Next j
            'remove extra tab if necessary
            If Symbol = "{" Then _
                Result = Left(Result, Len(Result) - 1)
            'append statement
            Result = _
                Result & Statement & vbCrLf
        End If
    Loop
    '============================================================
    'close open content brackets with correct indentation
    '============================================================
    For i = Depth To 1 Step -1
        For j = 1 To i - 1
            Result = _
                Result & vbTab
        Next j
        Result = _
            Result & "}" & vbCrLf
    Next i
    FixScrStructure = Result
    
End Function
Function _
    BlockRefresh( _
        FuncStack As ListBox, _
        BlockName As String, _
        BlockDepth As Integer, _
        BlockStart As Integer, _
        EnterCondition As String, _
        ExitCondition As String, _
        Incrementation As String, _
        Branchable As Boolean, _
        HasExtraData As Boolean _
    )

    BlockName = StackPop(FuncStack)
    BlockDepth = CInt(StackPop(FuncStack))
    Call _
        BlockPop( _
            FuncStack, _
            BlockStart, _
            EnterCondition, _
            ExitCondition, _
            Incrementation, _
            Branchable, _
            HasExtraData _
        )
    Call _
        BlockPush( _
            FuncStack, _
            BlockStart, _
            EnterCondition, _
            ExitCondition, _
            Incrementation, _
            Branchable, _
            HasExtraData _
        )
    Call StackPush(FuncStack, CStr(BlockDepth))
    Call StackPush(FuncStack, BlockName)
    
End Function
Function _
    BlockPop( _
        FuncStack As ListBox, _
        BlockStart As Integer, _
        EnterCondition As String, _
        ExitCondition As String, _
        Incrementation As String, _
        Branchable As Boolean, _
        HasExtraData As Boolean _
    )

    BlockStart = CInt(StackPop(FuncStack))
    EnterCondition = StackPop(FuncStack)
    ExitCondition = StackPop(FuncStack)
    Incrementation = StackPop(FuncStack)
    Branchable = CBool(StackPop(FuncStack))
    HasExtraData = CBool(StackPop(FuncStack))
    
End Function
Function _
    BlockPush( _
        FuncStack As ListBox, _
        BlockStart As Integer, _
        EnterCondition As String, _
        ExitCondition As String, _
        Incrementation As String, _
        Branchable As Boolean, _
        HasExtraData As Boolean _
    )

    Call StackPush(FuncStack, CStr(HasExtraData And 1))
    Call StackPush(FuncStack, CStr(Branchable And 1))
    Call StackPush(FuncStack, Incrementation)
    Call StackPush(FuncStack, ExitCondition)
    Call StackPush(FuncStack, EnterCondition)
    Call StackPush(FuncStack, CStr(BlockStart))
    
End Function
Function SetExitState(ExitCondition As String, Branched As Boolean)

    ExitCondition = "1" 'disable loops
    Branched = True 'disable combo-blocks
    
End Function
