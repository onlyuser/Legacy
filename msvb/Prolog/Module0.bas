Attribute VB_Name = "Module0"
Option Explicit

Public mVarBase As String
Function ShieldOps(Text As String, Operator As String, Count As Integer) As String

    Dim Result As String
    
    Result = EditReplace(Text, Operator, EditRepeat(")", Count) & Operator & EditRepeat("(", Count))
    ShieldOps = Result
    
End Function
Function SwapStrings(Text As String, Buffer As String) As String

    Dim i As Integer
    Dim j As Integer
    Dim Result As String
    Dim SwapOut As Boolean
    Dim Length As Integer
    Dim TermA As String
    Dim TermB As String
    Dim Count As Integer
    
    If Buffer = "" Then _
        SwapOut = True
    Length = Len(Text)
    i = 1
    j = 1
    Do While i <= Length
        TermA = ScanText(Text, i, Chr(34))
        If Not SwapOut Then _
            TermB = ScanText(Buffer, j, Chr(34))
        If Count Mod 2 = 1 Then
            If SwapOut Then
                Buffer = Buffer & MakeString(TermA)
                Result = Result & MakeString("")
            Else
                Result = Result & MakeString(TermB)
            End If
        Else
            Result = Result & TermA
        End If
        Count = Count + 1
    Loop
    If Not SwapOut Then _
        Buffer = ""
    SwapStrings = Result
    
End Function
Function RemoveComments(Text As String) As String

    Dim Result As String
    
    Result = Text
    Result = EditReplacePtn(Result, "/*", "*/", "")
    Result = EditReplacePtn(Result, "//", vbCrLf, "")
    Result = ScanText(Result, 0 + 1, "//")
    RemoveComments = Result
    
End Function
Function FixParens(Text As String) As String

    Dim Result As String
    Dim Buffer As String
    Dim Temp As Integer
    
    Result = Text
    Result = SwapStrings(Result, Buffer)
    Result = EditReplace(Result, "E", "*10^")
    Result = LCase(Result)
    Result = EditReplace(Result, " and ", "&&")
    Result = EditReplace(Result, " or ", "||")
    Result = EditReplace(Result, " xor ", "#")
    Result = EditReplace(Result, " mod ", "%")
    Result = RemoveComments(Result)
    Result = EditDespace(Result)
    Result = EditReplace(Result, "seed;", "seed();")
    Result = EditReplace(Result, "reset;", "reset();")
    Result = EditReplace(Result, "true", "1")
    Result = EditReplace(Result, "false", "0")
    Result = EditReplace(Result, "!(", "not(")
    Result = EditReplace(Result, "[", "?(")
    Result = EditReplace(Result, "]", ")")
    Result = EditReplace(Result, "={", "=array(")
    Result = EditReplace(Result, "}", ")")
    Result = EditReplace(Result, "++", "@incre")
    Result = EditReplace(Result, "--", "@decre")
    Result = EditReplace(Result, "&&", "{0}")
    Result = EditReplace(Result, "||", "|")
    Result = EditReplace(Result, "==", "{1}")
    Result = EditReplace(Result, "!=", "$")
    Result = EditReplace(Result, "<=", "[")
    Result = EditReplace(Result, ">=", "]")
    Result = EditReplace(Result, "->", "~")
    Result = EditReplace(Result, "<<", "\")
    Result = EditReplace(Result, ">>", "\-")
    Result = EditReplace(Result, "&", "`")
    Result = EditReplace(Result, "=", ":")
    Result = EditReplace(Result, "{0}", "&")
    Result = EditReplace(Result, "{1}", "=")
    Result = EditReplace(Result, "sin(", "_sin@(")
    Result = EditReplace(Result, "cos(", "_cos@(")
    Result = EditReplace(Result, "tan(", "_tan@(")
    Result = EditReplace(Result, "csc(", "_csc@(")
    Result = EditReplace(Result, "sec(", "_sec@(")
    Result = EditReplace(Result, "cot(", "_cot@(")
    Result = EditReplace(Result, "asin(", "_asin@(")
    Result = EditReplace(Result, "acos(", "_acos@(")
    Result = EditReplace(Result, "atan(", "_atan@(")
    Result = EditReplace(Result, "log(", "_log@(")
    Result = EditReplace(Result, "ln(", "_ln@(")
    Result = EditReplace(Result, "exp(", "_exp@(")
    Result = EditReplace(Result, "abs(", "_abs@(")
    Result = EditReplace(Result, "sgn(", "_sgn@(")
    Result = EditReplace(Result, "not(", "_not@(")
    Result = EditReplace(Result, "inv(", "_inv@(")
    Result = EditReplace(Result, "int(", "_int@(")
    Result = EditReplace(Result, "round(", "_round@(")
    Result = EditReplace(Result, "rnd(", "_rnd@(")
    Result = EditReplace(Result, "seed(", "_seed@(")
    Result = EditReplace(Result, "sqrt(", "_sqrt@(")
    Result = EditReplace(Result, "fact(", "_fact@(")
    Result = EditReplace(Result, "base(", "_base@(")
    Result = EditReplace(Result, "mid(", "_mid@(")
    Result = EditReplace(Result, "left(", "_left@(")
    Result = EditReplace(Result, "right(", "_right@(")
    Result = EditReplace(Result, "len(", "_len@(")
    Result = EditReplace(Result, "asc(", "_asc@(")
    Result = EditReplace(Result, "chr(", "_chr@(")
    Result = EditReplace(Result, "trim(", "_trim@(")
    Result = EditReplace(Result, "ltrim(", "_ltrim@(")
    Result = EditReplace(Result, "rtrim(", "_rtrim@(")
    Result = EditReplace(Result, "lcase(", "_lcase@(")
    Result = EditReplace(Result, "ucase(", "_ucase@(")
    Result = EditReplace(Result, "array(", "_array@(")
    Result = EditReplace(Result, "reset(", "_reset@(")
    Result = EditReplace(Result, "-_", "-1*")
    Result = EditReplace(Result, "_", "")
    Result = FixNegation(Result)
    Result = "(" & Result & ")"
    Result = EditReplace(Result, "(", EditRepeat("(", 9))
    Result = EditReplace(Result, ")", EditRepeat(")", 9))
    Result = ShieldOps(Result, ";", 9)
    Result = ShieldOps(Result, ",", 8)
    Result = ShieldOps(Result, ":", 7)
    Result = ShieldOps(Result, "`", 6)
    Result = ShieldOps(Result, "&", 6)
    Result = ShieldOps(Result, "|", 6)
    Result = ShieldOps(Result, "#", 6)
    Result = ShieldOps(Result, "=", 6)
    Result = ShieldOps(Result, "$", 6)
    Result = ShieldOps(Result, "<", 6)
    Result = ShieldOps(Result, ">", 6)
    Result = ShieldOps(Result, "[", 6)
    Result = ShieldOps(Result, "]", 6)
    Result = ShieldOps(Result, "~", 6)
    Result = ShieldOps(Result, "+", 5)
    Result = ShieldOps(Result, "-", 5)
    Result = ShieldOps(Result, "*", 4)
    Result = ShieldOps(Result, "/", 4)
    Result = ShieldOps(Result, "%", 4)
    Result = ShieldOps(Result, "^", 3)
    Result = ShieldOps(Result, "\", 3)
    Result = ShieldOps(Result, "@", 2)
    Result = ShieldOps(Result, "?", 1)
    Temp = CountText(Result, "(") - CountText(Result, ")")
    Do While Temp > 0
        Result = Result & ")"
        Temp = Temp - 1
    Loop
    Do While Temp < 0
        Result = "(" & Result
        Temp = Temp + 1
    Loop
    Result = FixParensEx(Result)
    Result = EditReplace(Result, "()", "(0)")
    Result = EditReplace(Result, ")(", ")*(")
    Result = SwapStrings(Result, Buffer)
    FixParens = Result
    
End Function
Function FixParensEx(Text As String) As String

    Dim i As Integer
    Dim Result As String
    Dim Length As Integer
    Dim Term As String
    Dim Count As Integer
    
    Length = Len(Text)
    i = 1
    Do While i <= Length
        Term = GetShellPtn(Text, i, "(", ")")
        If FindText(Term, "(") <> 0 Then
            Term = FixParensEx(Term)
        Else
            If Left(Term, 1) = "!" Then _
                Term = "(not)@(" & Right(Term, Len(Term) - 1) & ")"
            If Left(Term, 2) = "0x" Then _
                Term = ChangeBase(Right(Term, Len(Term) - 2), 16, 10)
            If Right(Term, 1) = "!" Then _
                Term = "(fact)@(" & Left(Term, Len(Term) - 1) & ")"
            Term = "(" & Term & ")"
        End If
        Result = Result & Term
        If i <= Length Then _
            Result = Result & Mid(Text, i, 1)
        Count = Count + 1
    Loop
    If Count <> 1 Then _
        Result = "(" & Result & ")"
    FixParensEx = Result
    
End Function
Function Eval(Text As String, Optional Recurse As Boolean) As String

    Dim i As Integer
    Dim Result As String
    Dim NewText As String
    Dim Length As Integer
    Dim TermA As String
    Dim TermB As String
    Dim Temp As String
    
    NewText = Text
    If Not Recurse Then
        NewText = FixParens(NewText)
        NewText = GetShellPtn(NewText, 0 + 1, "(", ")")
    End If
    If FindText(NewText, "(") = 0 Then
        Result = GetVar(mVarBase, NewText)
    Else
        Length = Len(NewText)
        i = 1
        Result = GetShellPtn(NewText, i, "(", ")")
        Do While i <= Length
            TermA = Mid(NewText, i, 1)
            TermB = GetShellPtn(NewText, i, "(", ")")
            If TermA = "@" Then
                Select Case TermB
                    Case "incre"
                        Temp = Eval(Result)
                        Call Eval(Result & "=" & Result & "+1")
                        Result = Temp: TermA = "+": TermB = "0"
                    Case "decre"
                        Temp = Eval(Result)
                        Call Eval(Result & "=" & Result & "-1")
                        Result = Temp: TermA = "+": TermB = "0"
                End Select
            End If
            If FindText(Result, "(") <> 0 Then _
                Result = Eval(Result, True)
            If FindText(TermB, "(") <> 0 Then _
                TermB = Eval(TermB, True)
            Result = MergeLogic(Result, TermA, TermB)
            If Not Recurse And TermA = "?" Then _
                Result = Eval(Result)
        Loop
    End If
    Eval = Result
    
End Function
Function MergeLogic(ParamA As String, Operator As String, ParamB As String) As String

    Dim Result As String
    Dim NewParamA As String
    Dim NewParamB As String
    Dim A As Single
    Dim B As Single
    Dim C As Single
    
    NewParamA = GetVar(mVarBase, ParamA)
    NewParamB = GetVar(mVarBase, ParamB)
    A = Val(NewParamA)
    B = Val(NewParamB)
    Select Case Operator
        Case "?": Result = ParamA & "." & NewParamB
        Case ";": Result = ParamB
        Case ",": Result = ParamA & Operator & ParamB
        Case ":": Result = SetVar(mVarBase, ParamA, ParamB)
        Case "`": Result = MakeString(NewParamA & NewParamB)
        Case "&": C = (A And B) And 1
        Case "|": C = (A Or B) And 1
        Case "#": C = (A Xor B) And 1
        Case "=": C = (NewParamA = NewParamB) And 1
        Case "$": C = (NewParamA <> NewParamB) And 1
        Case "<": C = (A < B) And 1
        Case ">": C = (A > B) And 1
        Case "[": C = (A <= B) And 1
        Case "]": C = (A >= B) And 1
        Case "~": C = ((Not A) Or B) And 1
        Case "+": C = A + B
        Case "-": C = A - B
        Case "*": C = A * B
        Case "/": C = A / B
        Case "%": C = A Mod B
        Case "^": C = A ^ B
        Case "\": C = A * (2 ^ B)
        Case "@"
            Select Case ParamA
                Case "sin": C = Sin(B)
                Case "cos": C = Cos(B)
                Case "tan": C = Tan(B)
                Case "csc": C = 1 / Sin(B)
                Case "sec": C = 1 / Cos(B)
                Case "cot": C = 1 / Tan(B)
                Case "asin": C = Atn(B / Sqr(-(B ^ 2) + 1))
                Case "acos": C = Atn(-B / Sqr(-(B ^ 2) + 1)) + 2 * Atn(1)
                Case "atan": C = Atn(B)
                Case "log": C = Log(B) / Log(10)
                Case "ln": C = Log(B)
                Case "exp": C = Exp(B)
                Case "abs": C = Abs(B)
                Case "sgn": C = Sgn(B)
                Case "not": C = (Not B) And 1
                Case "inv": C = Not B
                Case "int": C = Int(B)
                Case "round": C = CInt(B)
                Case "rnd": C = Rnd * B
                Case "seed": Randomize
                Case "sqrt": C = Sqr(B)
                Case "fact": C = GetFactorial(Int(B))
                Case "base"
                    Result = _
                        ChangeBase( _
                            Eval(GetEntry(ParamB, ",", 1), True), _
                            Eval(GetEntry(ParamB, ",", 2), True), _
                            Eval(GetEntry(ParamB, ",", 3), True) _
                        )
                    Select Case Eval(GetEntry(ParamB, ",", 3), True)
                        Case 16: Result = MakeString("0x" & Result)
                        Case 10
                        Case Else: Result = MakeString("0n" & Result)
                    End Select
                Case "mid"
                    Result = _
                        Mid( _
                            Eval(GetEntry(ParamB, ",", 1), True), _
                            Eval(GetEntry(ParamB, ",", 2), True), _
                            Eval(GetEntry(ParamB, ",", 3), True) _
                        )
                    Result = MakeString(Result)
                Case "left"
                    Result = Left(Eval(GetEntry(ParamB, ",", 1), True), Eval(GetEntry(ParamB, ",", 2), True))
                    Result = MakeString(Result)
                Case "right"
                    Result = Right(Eval(GetEntry(ParamB, ",", 1), True), Eval(GetEntry(ParamB, ",", 2), True))
                    Result = MakeString(Result)
                Case "len": C = Len(Eval(ParamB, True))
                Case "asc": C = Asc(Eval(ParamB, True))
                Case "chr": Result = MakeString(Chr(Eval(ParamB, True)))
                Case "trim": Result = MakeString(Trim(Eval(ParamB, True)))
                Case "ltrim": Result = MakeString(LTrim(Eval(ParamB, True)))
                Case "rtrim": Result = MakeString(RTrim(Eval(ParamB, True)))
                Case "lcase": Result = MakeString(LCase(Eval(ParamB, True)))
                Case "ucase": Result = MakeString(UCase(Eval(ParamB, True)))
                Case "array": Result = MakeString(";" & Eval(ParamB))
                Case "reset": mVarBase = ""
            End Select
        Case "("
        Case Else: Result = "fail"
    End Select
    If Result = "" Then _
        Result = CStr(C)
    MergeLogic = Result
    
End Function
Function FixNegation(Text As String) As String

    Dim i As Integer
    Dim Result As String
    Dim Length As Integer
    Dim Term As String
    Dim PrevTerm As String
    Dim ParenOpen As Boolean
    
    Length = Len(Text)
    i = 1
    Do While i <= Length
        Term = Mid(Text, i, 1)
        If (MergeLogic("0", PrevTerm, "1") <> "fail" Or i = 1) And Term = "-" Then
            Result = Result & "("
            ParenOpen = True
        Else
            If ParenOpen And MergeLogic("0", Term, "1") <> "fail" Then
                Result = Result & ")"
                ParenOpen = False
            End If
        End If
        Result = Result & Term
        PrevTerm = Term
        i = i + 1
    Loop
    If ParenOpen Then _
        Result = Result & ")"
    FixNegation = Result
    
End Function
Function GetVar(VarBase As String, Name As String) As String

    Dim Result As String
    
    If Name <> "" Then
        If Not IsNumeric(Name) Then
            If Not IsString(Name) Then
                Result = GetShellPtn(VarBase, 0 + 1, "(" & Name & ")=", ";")
                If Result <> "" Then
                    Result = GetVar(VarBase, Result)
                Else
                    Result = "0"
                End If
            Else
                Result = Mid(Name, 2, Len(Name) - 2)
            End If
        Else
            Result = Name
        End If
    End If
    GetVar = Result
    
End Function
Function SetVar(VarBase As String, Name As String, Value As String) As String

    Dim Result As String
    
    If FindText(Value, ";") <> 0 Then
        Call BuildArray(Name, Eval(Value))
        Exit Function
    End If
    Result = Value
    If Not IsString(Result) Then _
        Result = GetVar(VarBase, Result)
    If Name <> "" Then
        If Not IsNumeric(Name) Then
            If Result <> "0" Then
                If GetVar(VarBase, Name) = "0" Then
                    Call SetVar(VarBase, Name, "0")
                    VarBase = VarBase & "(" & Name & ")=" & Result & ";"
                Else
                    VarBase = EditReplacePtn(VarBase, "(" & Name & ")=", ";", "(" & Name & ")=" & Result & ";")
                End If
            Else
                VarBase = EditReplacePtn(VarBase, "(" & Name & ")=", ";", "")
            End If
        End If
    End If
    If IsString(Result) Then _
        Result = GetVar(VarBase, Result)
    SetVar = Result
    
End Function
Function BuildArray(Name As String, Value As String)

    Dim i As Integer
    Dim Length As Integer
    Dim Term As String
    Dim Count As Integer
    
    Length = Len(Value)
    i = 1
    Call ScanText(Value, i, ";")
    Do While i <= Length
        Term = ScanText(Value, i, ",")
        Call Eval(Name & "[" & Count & "]=" & Term)
        Count = Count + 1
    Loop
    
End Function
Function GetFactorial(Number As Integer) As Long

    Dim i As Integer
    Dim Result As Long
    
    If Number >= 0 Then
        Result = 1
        For i = Number To 2 Step -1
            Result = Result * i
        Next i
    End If
    GetFactorial = Result
    
End Function
Function IsString(Text As String) As Boolean

    Dim Result As Boolean
    
    If Left(Text, 1) = Chr(34) And Right(Text, 1) = Chr(34) Then _
        Result = True
    IsString = Result
    
End Function
Function MakeString(Text As String) As String

    Dim Result As String
    
    Result = Chr(34) & Text & Chr(34)
    MakeString = Result
    
End Function
