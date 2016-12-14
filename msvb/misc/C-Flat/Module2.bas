Attribute VB_Name = "Module2"
Option Explicit
Function FixExpLanguage(Expression As String) As String

    Dim Result As String
    
    Result = Expression
    Result = EditReplace(Result, "++", "+")
    Result = EditReplace(Result, "--", "+")
    Result = EditReplace(Result, "+-", "-")
    Result = EditReplace(Result, "-+", "-")
    Result = EditReplace(Result, "<=", "[")
    Result = EditReplace(Result, ">=", "]")
    Result = EditReplace(Result, "==", "?")
    Result = EditReplace(Result, "!=", "$")
    Result = EditReplace(Result, "&&", "&")
    Result = EditReplace(Result, "||", "|")
    Result = EditReplace(Result, "<<", "\")
    Result = EditReplace(Result, ">>", "\-")
    Result = EditReplace(Result, "true", "1")
    Result = EditReplace(Result, "false", "0")
    Result = EditReplace(Result, "<>", "$") '(VB)
    Result = EditReplace(Result, "and", "&") '(VB)
    Result = EditReplace(Result, "xor", "#") '(VB)
    Result = EditReplace(Result, "or", "|") '(VB)
    FixExpLanguage = Result
    
End Function
Function CheckExpStructure(Expression As String) As String

    Dim i As Integer
    Dim Result As String
    Dim Length As Integer
    Dim Symbol As String
    Dim PrevSymbol As String
    Dim Depth As Integer
    
    Length = Len(Expression)
    i = 1
    Do While i <= Length
        'backup last two symbols
        PrevSymbol = Symbol
        Symbol = GetNextSymbol(Expression, i, True)
        'adjust depth as cued by parens
        If Symbol = "(" Then _
            Depth = Depth + 1
        If Symbol = ")" Then _
            Depth = Depth - 1
        'check against paren abuse
        If Depth < 0 Then
            Result = MakeError("TOO MANY CLOSED PARENS")
            Exit Do
        End If
        'check against operator repetition
        If _
            IsOperator(PrevSymbol) And _
            IsOperator(Symbol) _
        Then
            If IsOperator(GetNextSymbol(Expression, i + 0, True)) Then
                Result = MakeError("TOO MANY OPERATORS")
                Exit Do
            End If
        End If
        'check against abrupt expression termination
        If _
            ( _
                PrevSymbol = "" Or _
                PrevSymbol = "(" Or _
                IsOperator(PrevSymbol) _
            ) And _
            Symbol = ")" _
        Then
            Result = MakeError("UNEXPECTED END OF STATEMENT")
            Exit Do
        End If
        'check against unexpected operators
        If _
            ( _
                PrevSymbol = "" Or _
                PrevSymbol = "(" Or _
                IsOperator(PrevSymbol) _
            ) And _
            IsOperator(Symbol) _
        Then
            If Not IsSign(Symbol) Then
                Result = MakeError("UNEXPECTED OPERATOR")
                Exit Do
            End If
        End If
    Loop
    CheckExpStructure = Result
    
End Function
Function FixExpNegation(Expression As String) As String

    Dim i As Integer
    Dim Result As String
    Dim Buffer As String
    Dim Length As Integer
    Dim Symbol As String
    Dim PrevSymbol As String
    Dim Depth As Integer
    Dim PrevDepth As Integer
    Dim PrepareToWait As Boolean
    Dim Waiting As Boolean
    Dim Incomplete As Boolean
    
    Buffer = Expression
    Do
        'prepare expression
        If Result <> "" Then
            Buffer = Result 'pick up where previously left off
            'reset vars
            Result = ""
            Symbol = ""
            Depth = 0
            Incomplete = False
        End If
        'check expression syntax
        Length = Len(Buffer)
        i = 1
        Do While i <= Length
            'backup last two symbols
            PrevSymbol = Symbol
            Symbol = GetNextSymbol(Buffer, i, True)
            'adjust depth as cued by parens
            If Symbol = "(" Then _
                Depth = Depth + 1
            If Symbol = ")" Then _
                Depth = Depth - 1
            'determine whether "implicit-zero" is needed
            If _
                ( _
                    PrevSymbol = "" Or _
                    PrevSymbol = "(" Or _
                    IsOperator(PrevSymbol) _
                ) And _
                IsSign(Symbol) _
            Then
                If Not Waiting Then
                    If IsOperator(PrevSymbol) Then
                        PrevDepth = Depth
                        PrepareToWait = True
                        Result = Result & "("
                    End If
                    Result = Result & "0"
                Else
                    Incomplete = True
                End If
            End If
            Result = Result & Symbol 'append symbol
            'determine whether open paren should be closed
            If _
                Waiting And _
                Depth = PrevDepth And _
                Not IsFunction(Symbol) And _
                Not IsOperator(Symbol) _
            Then
                Waiting = False
                Result = Result & ")"
            End If
            If PrepareToWait Then
                PrepareToWait = False
                Waiting = True
            End If
        Loop
    Loop While Incomplete
    For i = 1 To Depth
        Result = Result & ")"
    Next i
    FixExpNegation = Result
    
End Function
Function FixExpConjugation(Expression As String) As String

    Dim i As Integer
    Dim j As Integer
    Dim Result As String
    Dim Length As Integer
    Dim Symbol As String
    Dim PrevSymbol As String
    
    Length = Len(Expression)
    i = 1
    Do While i <= Length
        'backup last two symbols
        PrevSymbol = Symbol
        Symbol = GetNextSymbol(Expression, i, True)
        'determine whether coefficient conjugation is needed
        If _
            IsNumeric(Left(Symbol, 1)) And _
            Not IsNumeric(Symbol) _
        Then
            For j = 1 To Len(Symbol)
                If Not IsNumeric(Mid(Symbol, j, 1)) Then _
                    Exit For
            Next j
            Result = Result & Left(Symbol, j - 1) & "*"
            Symbol = Right(Symbol, Len(Symbol) - (j - 1))
        End If
        'determine whether inter-symbol conjugation is needed
        If _
            ( _
                PrevSymbol = ")" And _
                Symbol = "(" _
            ) Or _
            ( _
                IsParam(PrevSymbol) And _
                Symbol = "(" _
            ) Or _
            ( _
                PrevSymbol = ")" And _
                IsParam(Symbol) _
            ) _
        Then
            If IsFunction(PrevSymbol) Then
                Result = Result & "@" 'insert function operator
            Else
                Result = Result & "*"
            End If
        End If
        Result = Result & Symbol 'append symbol
    Loop
    FixExpConjugation = Result
    
End Function
Function IsOperator(Symbol As String) As Boolean

    Dim Result As Boolean
    
    If RankSymbol(Symbol) >= RankSymbol("=") Then _
        Result = True
    IsOperator = Result
    
End Function
Function IsSign(Symbol As String) As Boolean

    Dim Result As Boolean
    
    If RankSymbol(Symbol) = RankSymbol("+") Then _
        Result = True
    IsSign = Result
    
End Function
Function IsParam(Symbol As String) As Boolean

    Dim Result As Boolean
    
    If RankSymbol(Symbol) = 0 Then _
        Result = True
    IsParam = Result
    
End Function
Function MakeError(Message As String) As String

    Dim Result As String
    
    Result = "ERROR: " & UCase(Message)
    MakeError = Result
    
End Function
Function IsError(Expression As String) As Boolean

    Dim Result As Boolean
    
    If Left(Expression, 5) = "ERROR" Then _
        Result = True
    IsError = Result
    
End Function
Function _
    MergeUnary( _
        Operator As String, _
        Param As Double _
    ) As Double

    Dim Result As Double
    Dim B As Double
    Dim C As Double
    
    B = Param
    Select Case Operator
        Case "sin"
            C = Sin(B)
        Case "cos"
            C = Cos(B)
        Case "tan"
            C = Tan(B)
        Case "csc"
            C = 1 / Sin(B)
        Case "sec"
            C = 1 / Cos(B)
        Case "cot"
            C = 1 / Tan(B)
        Case "asin"
            C = Atn(B / Sqr(-B * B + 1))
        Case "acos"
            C = Atn(-B / Sqr(-B * B + 1)) + 2 * Atn(1)
        Case "atan"
            C = Atn(B)
        Case "log"
            C = Log(B) / Log(10)
        Case "ln"
            C = Log(B)
        Case "abs"
            C = Abs(B)
        Case "sgn"
            C = Sgn(B)
        Case "not"
            C = (Not B) And 1
        Case "inv"
            C = Not B
        Case "int"
            C = Int(B)
        Case "round"
            C = CInt(B)
        Case "rand"
            C = Rnd * B
        Case "sqrt"
            C = Sqr(B)
        Case "fact"
            C = GetFactorial(Int(B))
    End Select
    Result = C
    MergeUnary = Result
    
End Function
Function _
    MergeBinary( _
        Param1 As Double, _
        Operator As String, _
        Param2 As Double _
    ) As Double

    Dim Result As Double
    Dim A As Double
    Dim B As Double
    Dim C As Double
    
    A = Param1
    B = Param2
    Select Case Operator
        Case "^"
            C = A ^ B
        Case "*"
            C = A * B
        Case "/"
            C = A / B
        Case "%"
            C = A Mod B
        Case "+"
            C = A + B
        Case "-"
            C = A - B
        Case "<"
            C = (A < B) And 1
        Case ">"
            C = (A > B) And 1
        Case "["
            C = (A <= B) And 1
        Case "]"
            C = (A >= B) And 1
        Case "?"
            C = (A = B) And 1
        Case "$"
            C = (A <> B) And 1
        Case "&"
            C = A And B
        Case "|"
            C = A Or B
        Case "#"
            C = A Xor B
        Case "~"
            C = ((Not (A And 1)) And 1) Or (B And 1)
        Case "\"
            C = A * (2 ^ B)
    End Select
    Result = C
    MergeBinary = Result
    
End Function
Function StackFlip(StackObj As ListBox)

    Dim i As Integer
    Dim Count As Integer
    
    Count = StackObj.ListCount - 1
    For i = Count To 0 Step -1
        Call StackObj.AddItem(StackPop(StackObj), i)
    Next i
    
End Function
Function _
    VarAdd( _
        NameList As ListBox, _
        ValList As ListBox, _
        Name As String, _
        Value As Double _
    )

    Dim Index As Integer
    
    Index = VarFind(NameList, Name)
    If Index = -1 Then
        Call NameList.AddItem(Name)
        Call ValList.AddItem(Value)
    Else
        ValList.List(Index) = CStr(Value)
    End If
    
End Function
Function _
    MergeLogic( _
        Param1 As String, _
        Operator As String, _
        Param2 As String, _
        NameList As ListBox, _
        ValList As ListBox _
    ) As String

    Dim Result As String
    Dim A As Double
    Dim B As Double
    Dim C As Double
    
    On Error Resume Next
    If Operator = "!" Then
        Result = Param1 & Param2
    Else
        B = VarGet(NameList, ValList, Param2)
        If Operator <> "=" Then
            A = VarGet(NameList, ValList, Param1)
            If Operator = "@" Then
                Select Case Param1
                    Case "reset"
                        Call NameList.Clear
                        Call ValList.Clear
                        C = 1
                    Case "count"
                        C = NameList.ListCount
                    Case Else
                        C = MergeUnary(Param1, B)
                End Select
            Else
                C = MergeBinary(A, Operator, B)
            End If
        Else
            If Not IsNumeric(Param1) Then
                If B <> 0 Then
                    Call VarSet(NameList, ValList, Param1, B)
                Else
                    Call VarRem(NameList, ValList, Param1)
                End If
                C = B
            Else
                C = CDbl(Param1)
            End If
        End If
        If Err = 0 Then
            Result = CStr(C)
        Else
            Result = MakeError(Error(Err))
            Err = 0
        End If
    End If
    MergeLogic = Result
    
End Function
Function FixExpSyntax(Expression As String) As String

    Dim Result As String
    Dim Buffer As String
    
    Result = Expression
    Result = EditDespace(Result)
    Result = LCase(Result)
    Result = FixExpLanguage(Result)
    Buffer = CheckExpStructure(Result)
    If Not IsError(Buffer) Then
        Result = FixExpConjugation(Result)
        Result = FixExpNegation(Result)
    End If
    FixExpSyntax = Result
    
End Function
Function FixExpFormat(Expression As String) As String

    Dim i As Integer
    Dim Result As String
    Dim Buffer As String
    Dim Length As Integer
    Dim Char As String
    
    Buffer = Expression
    Buffer = EditDespace(Buffer)
    Length = Len(Buffer)
    For i = 1 To Length
        Char = Mid(Buffer, i, 1)
        If IsOperator(Char) Then
            If Right(Result, 1) <> " " Then _
                Result = Result & " "
            Result = Result & Char & " "
        Else
            Result = Result & Char
        End If
    Next i
    FixExpFormat = Result
    
End Function
Function _
    VarFind( _
        NameList As ListBox, _
        Name As String _
    ) As Integer

    Dim i As Integer
    Dim Result As Integer
    
    For i = 0 To NameList.ListCount - 1
        If NameList.List(i) = Name Then
            Result = i
            VarFind = Result
            Exit Function
        End If
    Next i
    Result = -1 'default to -1
    VarFind = Result
    
End Function
Function GetFactorial(Number As Integer) As Long

    Dim i As Integer
    Dim Result As Long
    
    Result = 1
    For i = Number To 2 Step -1
        Result = Result * i
    Next i
    GetFactorial = Result
    
End Function
Function IsFunction(Symbol As String) As Boolean

    Dim Result As Boolean
    
    If _
        Symbol = "sin" Or _
        Symbol = "cos" Or _
        Symbol = "tan" Or _
        Symbol = "csc" Or _
        Symbol = "sec" Or _
        Symbol = "cot" Or _
        Symbol = "asin" Or _
        Symbol = "acos" Or _
        Symbol = "atan" Or _
        Symbol = "log" Or _
        Symbol = "ln" Or _
        Symbol = "abs" Or _
        Symbol = "sgn" Or _
        Symbol = "not" Or _
        Symbol = "inv" Or _
        Symbol = "int" Or _
        Symbol = "round" Or _
        Symbol = "rnd" Or _
        Symbol = "sqrt" Or _
        Symbol = "fact" Or _
        Symbol = "reset" Or _
        Symbol = "count" _
    Then _
        Result = True
    IsFunction = Result
    
End Function
Function StackPop(StackObj As ListBox) As String

    Dim Result As String
    
    Result = StackObj.List(0)
    Call StackObj.RemoveItem(0)
    StackPop = Result
    
End Function
Function _
    StackPush( _
        StackObj As ListBox, _
        Text As String _
    )

    Call StackObj.AddItem(Text, 0)
    
End Function
Function RankSymbol(Symbol As String) As Integer

    Dim Result As Integer
    
    If Symbol <> "" Then
        Select Case Symbol
            Case "!"
                Result = 8
            Case "@"
                Result = 7
            Case "^"
                Result = 6
            Case "*", "/", "%"
                Result = 5
            Case "+", "-"
                Result = 4
            Case "<", ">", "[", "]", "?", "$", "&", "|", "#", "~", "\"
                Result = 3
            Case "="
                Result = 2
            Case "(", ")"
                Result = 1
            Case Else
                Result = 0
        End Select
    Else
        Result = -1 'default to -1
    End If
    RankSymbol = Result
    
End Function
Function _
    Evaluate( _
        Statement As String, _
        ParamStack As ListBox, _
        OpStack As ListBox, _
        BufStack As ListBox, _
        NameList As ListBox, _
        ValList As ListBox, _
        CheckSyntax As Boolean _
    ) As String

    Dim i As Integer
    Dim Result As String
    Dim Buffer As String
    Dim Length As Integer
    Dim Symbol As String
    Dim Param1 As String
    Dim Operator As String
    Dim Param2 As String
    Dim ReverseOrder As Boolean
    
    If CheckSyntax Then
        Buffer = FixExpSyntax(Statement)
        If IsError(Buffer) Then
            Result = Buffer
            Evaluate = Result
            Exit Function
        End If
    Else
        Buffer = Statement
    End If
    Buffer = "(" & Buffer & ")"
    Length = Len(Buffer)
    i = 1
    Do While i <= Length
        Symbol = GetNextSymbol(Buffer, i, True)
        If Symbol <> ")" Then
            If IsParam(Symbol) Then
                Call StackPush(ParamStack, Symbol)
            Else
                Call StackPush(OpStack, Symbol)
            End If
        Else
            Do Until StackTop(OpStack) = "("
                Do
                    Call StackPush(BufStack, StackPop(ParamStack))
                    Call StackPush(BufStack, StackPop(OpStack))
                Loop While _
                    RankSymbol(StackTop(OpStack)) >= RankSymbol(StackTop(BufStack))
                Call StackPush(BufStack, StackPop(ParamStack))
                ReverseOrder = False
                Do
                    If Not ReverseOrder Then
                        Param1 = StackPop(BufStack)
                        If RankSymbol(StackTop(BufStack)) = RankSymbol("=") Then _
                            ReverseOrder = True
                        Call StackPush(BufStack, Param1)
                        If ReverseOrder Then _
                            Call StackFlip(BufStack)
                    End If
                    Param1 = StackPop(BufStack)
                    Operator = StackPop(BufStack)
                    Param2 = StackPop(BufStack)
                    If ReverseOrder Then _
                        Call Swap(Param1, Param2)
                    Param1 = MergeLogic(Param1, Operator, Param2, NameList, ValList)
                    If IsError(Param1) Then
                        Call OpStack.Clear
                        Call ParamStack.Clear
                        Call BufStack.Clear
                        Result = Param1
                        Evaluate = Result
                        Exit Function
                    End If
                    Call StackPush(BufStack, Param1)
                Loop Until BufStack.ListCount = 1
                Call StackPush(ParamStack, StackPop(BufStack))
            Loop
            Call StackPop(OpStack)
        End If
    Loop
    Result = VarGet(NameList, ValList, StackPop(ParamStack))
    Evaluate = Result
    
End Function
Function _
    GetNextSymbol( _
        Text As String, _
        Start As Integer, _
        ScanRight As Boolean _
    ) As String

    Dim i As Integer
    Dim Result As String
    Dim Incre As Integer
    Dim Char As String
    Dim FirstRank As Integer
    Dim Finish As Integer
    
    If ScanRight Then
        Incre = 1
    Else
        Incre = -1
    End If
    Char = Mid(Text, Start, 1)
    Start = Start + Incre
    Result = Char
    FirstRank = RankSymbol(Char)
    If FirstRank = 0 Then
        If ScanRight Then
            Finish = Len(Text)
        Else
            Finish = 1
        End If
        For i = Start To Finish Step Incre
            Char = Mid(Text, i, 1)
            If RankSymbol(Char) = FirstRank Then
                Start = Start + Incre
                If ScanRight Then
                    Result = Result & Char
                Else
                    Result = Char & Result
                End If
            Else
                Exit For
            End If
        Next i
    End If
    GetNextSymbol = Result
    
End Function
Function _
    VarRem( _
        NameList As ListBox, _
        ValList As ListBox, _
        Name As String _
    )

    Dim Index As Integer
    
    Index = VarFind(NameList, Name)
    If Index <> -1 Then
        Call NameList.RemoveItem(Index)
        Call ValList.RemoveItem(Index)
    End If
    
End Function
Function StackTop(StackObj As ListBox) As String

    Dim Result As String
    
    Result = StackObj.List(0)
    StackTop = Result
    
End Function
Function _
    VarGet( _
        NameList As ListBox, _
        ValList As ListBox, _
        Name As String _
    ) As Double

    Dim Result As Double
    Dim Index As Integer
    
    If Not IsNumeric(Name) Then
        Index = VarFind(NameList, Name)
        If Index <> -1 Then
            Result = CDbl(ValList.List(Index))
        Else
            Result = 0 'default to 0
        End If
    Else
        Result = CDbl(Name)
    End If
    VarGet = Result
    
End Function
Function _
    VarSet( _
        NameList As ListBox, _
        ValList As ListBox, _
        Name As String, _
        Value As Double _
    )

    Dim Index As Integer
    
    Index = VarFind(NameList, Name)
    If Index <> -1 Then
        ValList.List(Index) = CStr(Value)
    Else
        Call VarAdd(NameList, ValList, Name, Value)
    End If
    
End Function
