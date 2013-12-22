Attribute VB_Name = "Module2"
Option Explicit

Public mRuleList As New Collection
Public mVarBinds As String
Public mBaseQuery As String
Public mBaseCount As Integer
Function Init()

    Call ListClear(mRuleList)
    Call ListClear(mStateList)
    Call SetState("T", True)
    
End Function
Function PrintScript() As String

    Dim Result As String
    
    Result = _
        "<RULES>" & vbCrLf & _
        vbCrLf & _
        ListPrint(mRuleList, "." & vbCrLf) & "." & vbCrLf & _
        vbCrLf & _
        "<STATES>" & vbCrLf & _
        vbCrLf & _
        ListPrint(mStateList, "." & vbCrLf) & "." & vbCrLf
    PrintScript = Result
    
End Function
Function FixScript(Text As String) As String

    Dim i As Integer
    Dim Result As String
    Dim NewText As String
    Dim Length As String
    Dim Token As String
    
    NewText = Text
    NewText = RemoveComments(NewText)
    NewText = EditDespace(NewText)
    NewText = EditReplace(NewText, "_", "")
    Length = Len(NewText)
    i = 1
    Do While i <= Length
        Token = ScanText(NewText, i, "[")
        Result = Result & Token
        If Right(Token, 1) <> "." Then
            Result = Result & "["
            Token = ScanText(NewText, i, "]")
            Token = EditReplace(Token, "+", "_plus_")
            Token = EditReplace(Token, "*", "_times_")
            Token = EditReplace(Token, "(", "{")
            Token = EditReplace(Token, ")", "}")
            Result = Result & Token & "]"
        End If
    Loop
    FixScript = Result
    
End Function
Function FixMath(Text As String) As String

    Dim Result As String
    
    Result = Text
    Result = EditReplace(Result, "_plus_", "+")
    Result = EditReplace(Result, "_times_", "*")
    Result = EditReplace(Result, "{", "(")
    Result = EditReplace(Result, "}", ")")
    FixMath = Result
    
End Function
Function LoadScript(Script As String)

    Dim i As Integer
    Dim NewScript As String
    Dim Length As Integer
    Dim Token As String
    
    NewScript = FixScript(Script)
    Length = Len(NewScript)
    i = 1
    Do While i <= Length
        Token = ScanText(NewScript, i, ".")
        Call AddRule(Token)
    Loop
    
End Function
Function AddRule(Rule As String)

    Dim i As Integer
    Dim Conseq As String
    Dim Factors As String
    Dim Length As Integer
    Dim Token As String
    
    i = 1
    Conseq = ScanText(Rule, i, ":-")
    Factors = ScanText(Rule, i, Chr(0))
    If FindText(Factors, "+") <> 0 Then
        Factors = FoilLogic(Factors)
        Factors = Mid(Factors, 2, Len(Factors) - 2)
        Length = Len(Factors)
        i = 1
        Do While i <= Length
            Token = ScanText(Factors, i, ")+(")
            Call AddRule(Conseq & ":-" & Token)
        Loop
    Else
        If Factors <> "" Then
            Token = Rule
            Token = EditReplace(Token, "(", "")
            Token = EditReplace(Token, ")", "")
            Call mRuleList.Add(Token)
        Else
            Call SetState(Conseq, True)
        End If
    End If
    
End Function
Function _
    Resolve( _
        Query As String, _
        Optional pTail As String, _
        Optional VarBinds As String = "null" _
    ) As Boolean

    Dim i As Integer
    Dim Result As Boolean
    Dim NewQuery As String
    Dim Head As String
    Dim Tail As String
    Dim StartA As Integer
    Dim StartB As Integer
    Dim NewHead As String
    Dim NewTail As String
    Dim NewBinds As String
    Dim Name As String
    Dim Param As String
    Dim PrevBinds As String
    Dim IndexA As Integer
    Dim IndexB As Integer
    Dim Visited As Boolean
    Dim NewState As String
    Dim Temp As String
    
    NewQuery = Query
    If VarBinds = "null" Then
        NewQuery = FixScript(NewQuery) 'correct syntax
        NewQuery = SubVars(NewQuery) 'sub-out custom vars
        VarBinds = "" 'initialize bindings
        mVarBinds = ""
        mBaseQuery = NewQuery 'backup initial query
        mBaseCount = mStateList.Count 'backup initial state count
    End If
    i = 1
    Head = ScanText(NewQuery, i, "*")
    Tail = ScanText(NewQuery, i, Chr(0))
    If Tail <> "" And pTail <> "" Then 'collapse tail nodes
        Temp = Tail & "*" & pTail
    Else
        Temp = Tail & pTail
    End If
    StartA = 1
    StartB = 1
    Do While StartA <= mBaseCount Or StartB <= mRuleList.Count
        NewHead = Head
        NewTail = Temp
        NewBinds = VarBinds
        If Left(Head, 1) = "~" Then _
            NewHead = Right(NewHead, Len(NewHead) - 1) 'remove negation symbol
        Name = ScanText(NewHead, 0 + 1, "[")
        If Name = "eval" Then
            Param = GetShellPtn(NewHead, 0 + 1, "[", "]")
            Param = FixMath(Param)
            mVarBase = NewBinds 'load new bindings into evaluator
            If Eval(Param) = "1" Then _
                Result = True
            StartA = BigNumber 'mark bail flag
            StartB = BigNumber
        Else
            PrevBinds = mVarBinds 'backup perm bindings
            IndexA = mStateList.Count + 1
            Result = ResolveEx(NewHead, StartA, StartB, NewTail, NewBinds) 'probe head node
            IndexB = mStateList.Count
            If Left(Head, 1) = "~" Then
                'NEGATED STATES DO NOT BIND VARIABLES!!
                If IndexB >= IndexA Then
                    For i = IndexB To IndexA Step -1
                        Call SetState(mStateList.Item(i), False) 'remove new states
                    Next i
                    mVarBinds = PrevBinds 'restore backup
                    Result = True
                End If
            End If
            If Result Then _
                Visited = True
        End If
        If Left(Head, 1) = "~" Then
            'NEVER FLIP ON BAIL!! NEVER FLIP TWICE!!
            If StartB <> BigNumber Or Not Visited Then _
                Result = Not Result 'flip polarity on negated states
        End If
        If Result Then
            If NewTail <> "" Then
                NewTail = BindVars(NewTail, NewBinds)
                Result = Resolve(NewTail, "", NewBinds) 'probe tail nodes
            Else
                NewState = BindVars(mBaseQuery, NewBinds)
                If FindText(NewState, "_") = 0 Then
                    NewState = EditReplace(NewState, "[]", "")
                    Call SetState("_" & NewState, True) 'set temporary state
                    If NewBinds <> "" Then
                        If FindText(mVarBinds, NewBinds) = 0 Then _
                            mVarBinds = mVarBinds & NewBinds & "|" 'log new bindings
                    End If
                End If
            End If
        End If
        DoEvents
    Loop
    If NewQuery = mBaseQuery Then _
        Result = ResetQuery 'validate temporary states
    Form1.Text2.Text = PrintScript 'refresh gui
    Resolve = Result
    
End Function
Function _
    ResolveEx( _
        Query As String, _
        StartA As Integer, _
        StartB As Integer, _
        Tail As String, _
        VarBinds As String _
    ) As Boolean

    Dim Result As Boolean
    Dim Conseq As String
    Dim Factors As String
    
    Result = GetRule(Query, "", "", StartA, False, VarBinds) 'match state
    If Not Result Then
        Result = GetRule(Query, Conseq, Factors, StartB) 'match rule
        If Result Then
            Factors = ApplyQuery(Query, Conseq, Factors)
            Result = Resolve(Factors, Tail, VarBinds)
        End If
    End If
    ResolveEx = Result
    
End Function
Function _
    GetRule( _
        Query As String, _
        Conseq As String, _
        Factors As String, _
        Start As Integer, _
        Optional TopDown As Boolean = True, _
        Optional VarBinds As String _
    ) As Boolean

    Dim i As Integer
    Dim Result As Boolean
    Dim Name As String
    Dim Scope As Collection
    Dim Token As String
    Dim pConseq As String
    Dim pName As String
    Dim PrevBinds As String
    
    Name = ScanText(Query, 0 + 1, "[")
    If TopDown Then
        Set Scope = mRuleList
    Else
        Set Scope = mStateList
    End If
    For i = Start To Scope.Count
        Token = Scope.Item(i)
        pConseq = ScanText(Token, 0 + 1, ":-")
        pName = ScanText(pConseq, 0 + 1, "[")
        If pName = Name Then
            If TopDown Then
                Result = True
                Exit For
            Else
                PrevBinds = VarBinds
                If ApplyQuery(pConseq, Query, "", VarBinds) <> "fail" Then
                    Result = True
                    Exit For
                Else
                    VarBinds = PrevBinds
                End If
            End If
        End If
    Next i
    If Result Then
        Start = i + 1 'set to next
        If TopDown Then
            i = 1
            Conseq = ScanText(Token, i, ":-")
            Factors = ScanText(Token, i, Chr(0))
        End If
    Else
        Start = BigNumber 'set to EOF
    End If
    GetRule = Result
    
End Function
'test[john,mary] + conseq[X,Y]    + factor[X,Y,Z] => factor[john,mary,Z] + null
'test[john,mary] + conseq[X,Y]    + null          => null                + (X)=john;(Y)=mary;
'test[john,mary] + conseq[X,mark] + null          => fail                + null
Function _
    ApplyQuery( _
        Query As String, _
        Conseq As String, _
        Factors As String, _
        Optional VarBinds As String _
    ) As String

    Dim i As Integer
    Dim j As Integer
    Dim Result As String
    Dim ParamA As String
    Dim ParamB As String
    Dim LengthA As Integer
    Dim LengthB As Integer
    Dim TokenA As String
    Dim TokenB As String
    
    Result = Factors
    ParamA = GetShellPtn(Query, 0 + 1, "[", "]")
    ParamB = GetShellPtn(Conseq, 0 + 1, "[", "]")
    LengthA = Len(ParamA)
    LengthB = Len(ParamB)
    i = 1
    j = 1
    Do While i <= LengthA And j <= LengthB
        TokenA = ScanText(ParamA, i, ",")
        TokenB = ScanText(ParamB, j, ",")
        If Result = "" Then
            If TokenA <> TokenB Then
                If IsVar(TokenB) Then
                    VarBinds = VarBinds & "(" & TokenB & ")=" & TokenA & ";"
                Else
                    Result = "fail"
                    Exit Do
                End If
            End If
        Else
            Result = EditReplace(Result, TokenB, TokenA)
        End If
    Loop
    ApplyQuery = Result
    
End Function
'_test[X] => test[X]
Function ResetQuery() As Boolean

    Dim i As Integer
    Dim Result As Boolean
    Dim Token As String
    
    i = mStateList.Count
    Do While i >= 1
        Token = mStateList.Item(i)
        If Left(Token, 1) = "_" Then
            Call SetState(Token, False)
            Token = Right(Token, Len(Token) - 1)
            Call SetState(Token, True)
            Result = True
        End If
        i = i - 1
    Loop
    ResetQuery = Result
    
End Function
Function Infer(Optional State As String) As Boolean

    Dim i As Integer
    Dim j As Integer
    Dim Item As Variant
    Dim Result As Boolean
    Dim NameA As String
    Dim NameB As String
    Dim TokenA As String
    Dim TokenB As String
    Dim Conseq As String
    Dim Factors As String
    Dim Length As Integer
    Dim NewState As String
    Dim IndexA As Integer
    Dim IndexB As Integer
    
    If State <> "" Then
        NameA = ScanText(State, 0 + 1, "[")
        For Each Item In mRuleList
            TokenA = CStr(Item)
            i = 1
            Conseq = ScanText(TokenA, i, ":-")
            Factors = ScanText(TokenA, i, Chr(0))
            Length = Len(Factors)
            i = 1
            Do While i <= Length
                TokenB = ScanText(Factors, i, "*")
                NameB = ScanText(TokenB, 0 + 1, "[")
                If Left(NameB, 1) = "~" Then _
                    NameB = Right(NameB, Len(NameB) - 1)
                If NameB = NameA Then
                    NewState = ApplyQuery(State, TokenB, Conseq)
                    IndexA = mStateList.Count + 1
                    Result = Resolve(NewState)
                    IndexB = mStateList.Count
                    If Result Then
                        For j = IndexA To IndexB
                            NewState = mStateList.Item(j)
                            Call Infer(NewState)
                        Next j
                    End If
                End If
            Loop
        Next Item
    Else
        IndexA = mStateList.Count
        For i = 1 To IndexA
            NewState = mStateList.Item(i)
            Call Infer(NewState)
        Next i
    End If
    Infer = Result
    
End Function
'test[X,Y,john,3] => test[_A,_B,john,3]
Function SubVars(Query As String) As String

    Dim i As Integer
    Dim j As Integer
    Dim Result As String
    Dim Length As Integer
    Dim LenParam As Integer
    Dim TokenA As String
    Dim TokenB As String
    Dim Name As String
    Dim Param As String
    Dim NewToken As String
    Dim Index As Integer
    Dim PrevStart As Integer
    
    Result = Query
    Result = EditReplace(Result, "[", "[(")
    Result = EditReplace(Result, ",", "),(")
    Result = EditReplace(Result, "]", ")]")
    PrevStart = 1
    Length = Len(Query)
    i = 1
    Do While i <= Length
        TokenA = ScanText(Query, i, "*")
        Name = ScanText(TokenA, 0 + 1, "[")
        If Left(Name, 1) = "~" Then _
            Name = Right(Name, Len(Name) - 1)
        If Name <> "eval" Then
            Param = GetShellPtn(TokenA, 0 + 1, "[", "]")
            LenParam = Len(Param)
            j = 1
            Do While j <= LenParam
                TokenB = ScanText(Param, j, ",")
                If IsVar(TokenB) Then
                    If FindText(Query, TokenB) >= PrevStart Then 'if first occurence
                        NewToken = "_" & Chr(Asc("A") + Index)
                        Result = EditReplace(Result, "(" & TokenB & ")", "(" & NewToken & ")")
                        Index = Index + 1
                    End If
                End If
            Loop
        End If
        PrevStart = i
    Loop
    Result = EditReplace(Result, "(", "")
    Result = EditReplace(Result, ")", "")
    SubVars = Result
    
End Function
Function IsVar(Name As String) As Boolean

    Dim Result As Boolean
    
    If Name = UCase(Name) And Not IsNumeric(Name) Then _
        Result = True
    IsVar = Result
    
End Function
