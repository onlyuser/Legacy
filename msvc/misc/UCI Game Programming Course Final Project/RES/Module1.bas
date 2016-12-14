Attribute VB_Name = "Module1"
Option Explicit

Public Const mBigNumber As Long = 32767
Function LoadText(Filename As String) As String

    Dim Result As String
    Dim FileNumber As Long
    Dim Term As String
    
    If Dir(Filename) = "" Then _
        Exit Function
    FileNumber = FreeFile
    Open Filename For Input As FileNumber
        Do While Not EOF(FileNumber)
            Line Input #FileNumber, Term
            Result = Result & Term & vbCrLf
            DoEvents
        Loop
    Close FileNumber
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - Len(vbCrLf))
    LoadText = Result
    
End Function
Function SaveText(Filename As String, Text As String)

    Dim FileNumber As Long
    
    On Error Resume Next
    If Dir(Filename) <> "" Then _
        Call Kill(Filename)
    If Err <> 0 Then
        Err = 0
        Exit Function
    End If
    If Text <> "" Then
        FileNumber = FreeFile
        Open Filename For Binary Access Write As FileNumber
            Put #FileNumber, , Text
        Close FileNumber
    End If
    
End Function
Function CountText(Text As String, SearchText As String) As Long

    Dim i As Long
    Dim Result As Long
    Dim Length As Long
    Dim LenSearch As Long
    
    Length = Len(Text)
    LenSearch = Len(SearchText)
    i = 1
    Do While i <= Length
        If Mid(Text, i, LenSearch) = SearchText Then
            Result = Result + 1
            i = i + LenSearch
        Else
            i = i + 1
        End If
    Loop
    CountText = Result
    
End Function
Function FindText(Text As String, SearchText As String, Optional Instance As Long = 1) As Long

    Dim i As Long
    Dim j As Long
    Dim Result As Long
    Dim Length As Long
    Dim LenSearch As Long
    
    Length = Len(Text)
    LenSearch = Len(SearchText)
    i = 1
    Do While i <= Length
        If Mid(Text, i, LenSearch) = SearchText Then
            j = j + 1
            If j = Instance Then
                Result = i
                Exit Do
            End If
            i = i + LenSearch
        Else
            i = i + 1
        End If
    Loop
    FindText = Result
    
End Function
Function FindTextAdv(Text As String, SearchText As String) As Long

    Dim i As Long
    Dim j As Long
    Dim Result As Long
    Dim Length As Long
    Dim LenSearch As Long
    Dim Term As String
    Dim CurChar As String
    Dim Index As Long
    Dim Offset As Long
    
    Length = Len(Text)
    LenSearch = Len(SearchText) '4=len("eric")
    i = 1
    Do While i <= Length And Result = 0
        Term = Mid(Text, i, LenSearch) '(amer)=mid("america",1,4)
        For j = LenSearch To 1 Step -1
            CurChar = Mid(Term, j, 1) '(r)=mid("amer",4,1)
            Index = FindText(SearchText, CurChar) '2=findtext("eric","r")
            If Index <> 0 Then
                Offset = j - Index '2=4-2
                If Offset <> 0 Then
                    i = i + Offset '3=1+2
                    Exit For
                Else
                    If j = 1 Then _
                        Result = i
                End If
            Else
                i = i + LenSearch
                Exit For
            End If
        Next j
    Loop
    FindTextAdv = Result
    
End Function
Function FindLast(Text As String, SearchText As String) As Long

    Dim i As Long
    Dim Result As Long
    Dim Length As Long
    Dim LenSearch As Long
    Dim Start As Long
    
    Length = Len(Text)
    LenSearch = Len(SearchText)
    Start = Length - LenSearch + 1
    For i = Start To 1 Step -1
        If Mid(Text, i, LenSearch) = SearchText Then
            Result = i
            Exit For
        End If
    Next i
    FindLast = Result
    
End Function
Function ScanText(Text As String, Start As Long, StopTerm As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim LenStop As Long
    
    Length = Len(Text)
    LenStop = Len(StopTerm)
    For i = Start To Length
        If Mid(Text, i, LenStop) = StopTerm Then
            Result = Mid(Text, Start, i - Start)
            Start = i + LenStop
            Exit For
        End If
    Next i
    If _
        i > Length And _
        Result = "" _
    Then
        Result = Right(Text, Length - (Start - 1))
        Start = Length + 1
    End If
    ScanText = Result
    
End Function
Function GetEntity(Text As String, SepTerm As String, Optional Instance As Long = 1) As String

    Dim i As Long
    Dim j As Long
    Dim Result As String
    Dim Length As Long
    Dim Term As String
    
    Length = Len(Text)
    i = 1
    Do While i <= Length
        Term = ScanText(Text, i, SepTerm)
        j = j + 1
        If j = Instance Then
            Result = Term
            Exit Do
        End If
    Loop
    GetEntity = Result
    
End Function
Function GetCurLine(Text As String, InsPoint As Long) As String

    Dim Result As String
    Dim Count As Long
    
    Count = CountText(Left(Text, InsPoint), vbCrLf)
    Result = GetEntity(Text, vbCrLf, Count + 1)
    GetCurLine = Result
    
End Function
Function IsTermChar(pChar As String) As Boolean

    Dim Result As Boolean
    
    If pChar <> "" Then
        If _
            ( _
                Asc(pChar) >= Asc("A") And _
                Asc(pChar) <= Asc("Z") _
            ) Or _
            ( _
                Asc(pChar) >= Asc("a") And _
                Asc(pChar) <= Asc("z") _
            ) Or _
            ( _
                Asc(pChar) >= Asc("0") And _
                Asc(pChar) <= Asc("9") _
            ) Or _
            pChar = "_" Or _
            pChar = "." _
        Then _
            Result = True
    End If
    IsTermChar = Result
    
End Function
Function GetNextTerm(Text As String, Start As Long) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim CurChar As String
    
    Length = Len(Text)
    For i = Start To Length
        CurChar = Mid(Text, i, 1)
        If Not IsTermChar(CurChar) Then
            Result = Mid(Text, Start, i - Start)
            Start = i
            Exit For
        End If
    Next i
    If Result = "" Then
        If i <> Start Then
            Result = Mid(Text, Start, i - Start)
        Else
            Result = CurChar
        End If
        Start = Start + Len(Result)
    End If
    GetNextTerm = Result
    
End Function
Function GetShellPtn(Text As String, Start As Long, Before As String, After As String) As String

    Dim Result As String
    Dim Depth As Long
    Dim Length As Long
    Dim Term As String
    
    Call ScanText(Text, Start, Before)
    Depth = 1
    Length = Len(Text)
    Do While Start <= Length
        Term = GetNextTerm(Text, Start)
        If Term = Before Then _
            Depth = Depth + 1
        If Term = After Then _
            Depth = Depth - 1
        If Depth = 0 Then _
            Exit Do
        Result = Result & Term
    Loop
    If Depth <> 0 Then _
        Result = ""
    GetShellPtn = Result
    
End Function
Function EditReplaceTerm(Text As String, SearchText As String, ReplaceText As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim Term As String
    
    Length = Len(Text)
    i = 1
    Do While i <= Length
        Term = GetNextTerm(Text, i)
        If Term = SearchText Then
            Result = Result & ReplaceText
        Else
            Result = Result & Term
        End If
    Loop
    EditReplaceTerm = Result
    
End Function
Function EditReplacePtn(Text As String, Before As String, After As String, ReplaceText As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim LenBefore As Long
    Dim LenAfter As Long
    Dim CurChar As String
    Dim Ignoring As Boolean
    Dim Buffer As String
    
    Length = Len(Text)
    LenBefore = Len(Before)
    LenAfter = Len(After)
    If LenBefore <> 0 Then
        i = 1
        Do While i <= Length
            CurChar = Mid(Text, i, 1)
            If Not Ignoring Then
                If Mid(Text, i, LenBefore) = Before Then
                    Ignoring = True
                    i = i + LenBefore - 1
                Else
                    Result = Result & CurChar
                End If
            Else
                If Mid(Text, i, LenAfter) = After Then
                    Ignoring = False
                    i = i + LenAfter - 1
                    Result = Result & ReplaceText
                    Buffer = ""
                Else
                    Buffer = Buffer & CurChar
                End If
            End If
            i = i + 1
        Loop
        If Ignoring Then
            If After <> "" Then
                Result = Result & Before & Buffer 'restore ignored
            Else
                Result = Result & ReplaceText 'coerce tail replace
            End If
        End If
    End If
    EditReplacePtn = Result
    
End Function
Function EditReplace(Text As String, SearchText As String, ReplaceText As String) As String

    Dim Result As String
    
    Result = Text
    Result = EditReplacePtn(Result, SearchText, "", ReplaceText)
    EditReplace = Result
    
End Function
Function SmartReplace(Text As String, SearchText As String, ReplaceText As String) As String

    Dim Result As String
    
    Result = Text
    Result = EditReplace(Result, ReplaceText, SearchText)
    Result = EditReplace(Result, SearchText, ReplaceText)
    SmartReplace = Result
    
End Function
Function EditDespace(Text As String) As String

    Dim Result As String
    
    Result = Text
    Result = EditReplace(Result, Space(1), "")
    Result = EditReplace(Result, vbCrLf, "")
    Result = EditReplace(Result, vbTab, "")
    EditDespace = Result
    
End Function
Function EditDeRepeat(Text As String, Optional pChar As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim CurChar As String
    Dim PrevChar As String
    
    Length = Len(Text)
    For i = 1 To Length
        CurChar = Mid(Text, i, 1)
        If CurChar <> PrevChar Then
            Result = Result & CurChar
        Else
            If pChar <> "" Then
                If CurChar <> pChar Then _
                    Result = Result & CurChar
            End If
        End If
        PrevChar = CurChar
    Next i
    EditDeRepeat = Result
    
End Function
Function EditRepeat(Text As String, Number As Long) As String

    Dim i As Long
    Dim Result As String
    
    For i = 1 To Number
        Result = Result & Text
    Next i
    EditRepeat = Result
    
End Function
Function EditReverse(Text As String, SepTerm As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim Token As String
    
    Length = Len(Text)
    i = 1
    Do While i <= Length
        Token = ScanText(Text, i, SepTerm)
        Result = SepTerm & Token & Result
    Loop
    If Result <> "" Then _
        Result = Right(Result, Len(Result) - Len(SepTerm))
    EditReverse = Result
    
End Function
Function EditInsert(Text As String, InsPoint As Long, NewText As String) As String

    Dim Result As String
    
    Result = Left(Text, InsPoint - 1) & NewText & Right(Text, Len(Text) - (InsPoint - 1))
    EditInsert = Result
    
End Function
Function PatternMatch(Text As String, Pattern As String) As Boolean

    Dim i As Long
    Dim j As Long
    Dim Result As Boolean
    Dim LenPattern As Long
    Dim Length As Long
    Dim Fragment As String
    
    Result = True
    LenPattern = Len(Pattern)
    Length = Len(Text)
    i = 1
    j = 1
    Do While i <= LenPattern
        Fragment = ScanText(Pattern, i, "*")
        If Fragment <> "" Then
            Call ScanText(Text, j, Fragment)
            If _
                j > Length And _
                Right(Text, Len(Fragment)) <> Fragment _
            Then
                Result = False
                Exit Do
            End If
        End If
    Loop
    PatternMatch = Result
    
End Function
Function GetFilename(Path As String) As String

    Dim Result As String
    Dim Index As Long
    
    Index = FindLast(Path, "\")
    Result = Right(Path, Len(Path) - Index)
    GetFilename = Result
    
End Function
Function GetPath(Path As String) As String

    Dim Result As String
    Dim Index As Long
    
    Index = FindLast(Path, "\")
    Result = Left(Path, Index)
    GetPath = Result
    
End Function
Function MakePath(Path As String) As String

    Dim Result As String
    
    Result = Path
    If Right(Result, 1) <> "\" Then _
        Result = Result & "\"
    MakePath = Result
    
End Function
Function FindFile(Path As String, Filename As String) As String

    Dim i As Long
    Dim Result As String
    Dim NewPath As String
    Dim CurPath As String
    Dim DirList As New Collection
    Dim Term As String
    
    NewPath = MakePath(Path)
    CurPath = Dir(NewPath, vbNormal Or vbDirectory Or vbHidden)
    Do While CurPath <> ""
        If CurPath <> "." And CurPath <> ".." Then _
            Call DirList.Add(CurPath)
        CurPath = Dir
        DoEvents
    Loop
    For i = 1 To DirList.Count
        Term = DirList.Item(i)
        CurPath = NewPath & Term
        If PatternMatch(Term, Filename) Then
            Result = CurPath
        Else
            If (GetAttr(CurPath) And vbDirectory) <> 0 Then _
                Result = FindFile(CurPath, Filename)
        End If
        If Result <> "" Then _
            Exit For
        DoEvents
    Next i
    FindFile = Result
    
End Function
Function ListClear(List As Collection)

    Do While List.Count <> 0
        Call List.Remove(1)
    Loop
    
End Function
Function ListFind(List As Collection, Text As String) As Long

    Dim i As Long
    Dim Result As Long
    
    For i = 1 To List.Count
        If List.Item(i) = Text Then
            Result = i
            Exit For
        End If
    Next i
    ListFind = Result
    
End Function
Function ListPrint( _
    List As Collection, _
    Optional SepVar As String = ",", _
    Optional NumberItems As Boolean, _
    Optional NumPrefix As String, _
    Optional NumSuffix As String _
) As String

    Dim i As Long
    Dim Result As String
    
    If NumberItems Then
        For i = 1 To List.Count
            Result = Result & NumPrefix & CStr(i) & NumSuffix & List.Item(i) & SepVar
        Next i
    Else
        For i = 1 To List.Count
            Result = Result & List.Item(i) & SepVar
        Next i
    End If
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - Len(SepVar))
    ListPrint = Result
    
End Function
Function ListSort(List As Collection)

    Dim i As Long
    Dim TempA As New Collection
    
    For i = 1 To List.Count
        Call ListInsSorted(List.Item(i), TempA)
        DoEvents
    Next i
    Set List = TempA
    
End Function
Function ListInsSorted( _
    NewItem As String, _
    List As Collection, _
    Optional First As Long = -1, _
    Optional Last As Long, _
    Optional Depth As Long _
)

    Dim i As Long
    Dim j As Long
    Dim MidPoint As Long
    
    If List.Count = 0 Then 'empty list
        Call List.Add(NewItem)
    Else
        If First = -1 Then 'init bounds (if none specified)
            First = 1
            Last = List.Count
        End If
        If StrCmp(NewItem, List.Item(First)) = -1 Then 'less than left-most
            Call List.Add(NewItem, , First)
        Else
            If StrCmp(NewItem, List.Item(Last)) = 1 Then 'greater than right-most
                Call List.Add(NewItem, , , Last)
            Else
                If Last - First > 1 Then
                    MidPoint = (First + Last) / 2
                    Select Case StrCmp(NewItem, List.Item(MidPoint))
                        Case -1
                            Call ListInsSorted(NewItem, List, First, MidPoint, Depth + 1) 'less than mid-point
                        Case 1
                            Call ListInsSorted(NewItem, List, MidPoint, Last, Depth + 1) 'greater than mid-point
                        Case 0
                            Call List.Add(NewItem, , MidPoint) 'same as mid-point
                    End Select
                Else
                    Call List.Add(NewItem, , , First) 'no alternative
                End If
            End If
        End If
    End If
    
End Function
Function StrCmp(TextA As String, TextB As String) As Long

    Dim i As Long
    Dim Result As Long
    Dim LenTextA As Long
    Dim LenTextB As Long
    
    LenTextA = Len(TextA)
    LenTextB = Len(TextB)
    i = 1
    Do While i <= LenTextA
        If i > LenTextB Then _
            Exit Do
        Result = Sgn(Asc(Mid(TextA, i, 1)) - Asc(Mid(TextB, i, 1)))
        If Result <> 0 Then _
            Exit Do
        i = i + 1
    Loop
    If Result = 0 Then _
        Result = Sgn(LenTextA - LenTextB)
    StrCmp = Result
    
End Function
Function ArrayFind(ArrayList() As String, Text As String) As Long

    Dim i As Long
    Dim Result As Long
    
    For i = 1 To UBound(ArrayList)
        If ArrayList(i) = Text Then
            Result = i
            Exit For
        End If
    Next i
    ArrayFind = Result
    
End Function
Function AutoComplete(ComboObj As ComboBox)

    Dim i As Long
    Dim Length As Long
    
    Length = Len(ComboObj.Text)
    If _
        Length - Len(ComboObj.Tag) = 1 And _
        ComboObj.SelStart = Length _
    Then
        For i = 0 To ComboObj.ListCount - 1
            If Left(ComboObj.List(i), Length) = ComboObj.Text Then
                ComboObj.ListIndex = i
                ComboObj.SelStart = Length
                ComboObj.SelLength = Len(ComboObj.Text) - Length
                Exit For
            End If
        Next i
    End If
    ComboObj.Tag = Left(ComboObj.Text, ComboObj.SelStart)
    
End Function
Function FormatSendKeys(Keys As String) As String

    Dim Result As String
    
    Result = Keys
    Result = EditReplace(Result, "{", "{{<0>")
    Result = EditReplace(Result, "}", "<1>}}")
    Result = EditReplace(Result, "<0>", "}")
    Result = EditReplace(Result, "<1>", "{")
    Result = EditReplace(Result, "+", "{+}")
    Result = EditReplace(Result, "^", "{^}")
    Result = EditReplace(Result, "%", "{%}")
    Result = EditReplace(Result, "~", "{~}")
    Result = EditReplace(Result, "(", "{(}")
    Result = EditReplace(Result, ")", "{)}")
    Result = EditReplace(Result, "[", "{[}")
    Result = EditReplace(Result, "]", "{]}")
    Result = EditReplace(Result, vbCrLf, "{ENTER}")
    Result = EditReplace(Result, vbTab, "{TAB}")
    FormatSendKeys = Result
    
End Function
Function ShowAbout()

    Const AuthName As String = "Jerry Chen"
    
    Call _
        MsgBox( _
            App.Title & " v" & App.Major & "." & App.Minor & vbCrLf & _
            vbCrLf & _
            "by " & AuthName, _
            vbInformation + vbOKOnly, _
            "About" _
        )
        
End Function
Function GetLocalPath(Filename As String) As String

    Dim Result As String
    
    Result = MakePath(App.Path) & Filename
    GetLocalPath = Result
    
End Function
Function Swap(A As Variant, B As Variant)

    Dim C As Variant
    
    C = A
    A = B
    B = C
    
End Function
Function Sort(NameList() As String, ValList() As Long, First As Long, Last As Long)

    Dim A As Long
    Dim B As Long
    Dim C As Long
    
    If Not First < Last Then _
        Exit Function
    If Last - First = 1 Then
        If ValList(First) > ValList(Last) Then
            Call Swap(NameList(First), NameList(Last))
            Call Swap(ValList(First), ValList(Last))
        End If
        Exit Function
    End If
    C = Int(First + Rnd * (Last - First + 1))
    Call Swap(NameList(C), NameList(Last))
    Call Swap(ValList(C), ValList(Last))
    Do
        A = First
        B = Last
        Do Until A = B Or ValList(A) > ValList(Last)
            A = A + 1
        Loop
        Do Until A = B Or ValList(B) < ValList(Last)
            B = B - 1
        Loop
        If A <> B Then
            Call Swap(NameList(A), NameList(B))
            Call Swap(ValList(A), ValList(B))
        End If
    Loop Until A = B
    Call Swap(NameList(Last), NameList(A))
    Call Swap(ValList(Last), ValList(A))
    Call Sort(NameList, ValList, First, A - 1)
    Call Sort(NameList, ValList, A + 1, Last)
    
End Function
Function Crypt(Text As String, Key As String, Optional Encrypt As Boolean = True) As String

    Const MaxCode As Long = 126 '(tilde)
    Const MinCode As Long = 32 '(space)
    
    Dim i As Long
    Dim j As Long
    Dim Result As String
    Dim ShiftDir As Long
    Dim Range As Long
    Dim Length As Long
    Dim LenKey As Long
    Dim CodeA As Long
    Dim CodeB As Long
    Dim CodeC As Long
    
    If Encrypt Then
        ShiftDir = 1
    Else
        ShiftDir = -1
    End If
    Range = MaxCode - MinCode + 1
    Length = Len(Text)
    LenKey = Len(Key)
    For i = 1 To Length
        j = ((i - 1) Mod LenKey) + 1
        CodeA = Asc(Mid(Text, i, 1)) - MinCode
        CodeB = Asc(Mid(Key, j, 1)) - MinCode
        CodeC = CodeA + CodeB * ShiftDir
        CodeC = MinCode + (Range + CodeC) Mod Range
        Result = Result & Chr(CodeC)
    Next i
    Crypt = Result
    
End Function
Function ChangeBase(Number As String, Base As Long, NewBase As Long) As String

    Const CharPool As String = "0123456789abcdef"
    
    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim CurChar As String
    Dim Coef As Long
    Dim Expo As Long
    Dim Sum As Long
    Dim Start As Long
    
    Length = Len(Number)
    For i = 1 To Length
        CurChar = Mid(Number, i, 1)
        Coef = FindText(CharPool, CurChar) - 1
        Expo = Base ^ (Length - i) '100=10^(3-1)
        Sum = Sum + Coef * Expo
    Next i
    If Sum <> 0 Then
        Start = Int(Log(Sum) / Log(NewBase))
        For i = Start To 0 Step -1
            Expo = NewBase ^ i
            Coef = Int(Sum / Expo) '2=int(255/(10^2))
            CurChar = Mid(CharPool, Coef + 1, 1)
            Result = Result & CurChar
            Sum = Sum - Coef * Expo
        Next i
    Else
        Result = "0"
    End If
    ChangeBase = Result
    
End Function
'test[X,Y,Z] + (X)=john;(Y)=mary; => test[john,mary,Z]
Function BindVars(Text As String, VarBinds As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim TermA As String
    Dim TermB As String
    
    Result = Text
    Length = Len(VarBinds)
    i = 1
    Do While i <= Length
        TermA = GetShellPtn(VarBinds, i, "(", ")")
        If TermA <> "" Then
            TermB = GetShellPtn(VarBinds, i, "=", ";")
            Result = EditReplace(Result, TermA, TermB)
        End If
    Loop
    BindVars = Result
    
End Function
'test[X,Y,Z] + test[%1,%2,%3] + test[%3,%2,%1] => test[Z,Y,X]
Function SmartFormat(Text As String, Pattern As String, NewPattern As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim TermA As String
    Dim TermB As String
    Dim TermC As String
    Dim VarBinds As String
    
    Length = Len(Pattern)
    i = 1
    Do While i <= Length
        TermC = TermC & ScanText(Pattern, i, "%")
        If i <= Length Then
            TermA = GetNextTerm(Pattern, i)
            TermB = GetShellPtn(Text, 0 + 1, TermC, Mid(Pattern, i, 1))
            VarBinds = VarBinds & "(%" & TermA & ")=" & TermB & ";"
            TermC = TermC & TermB
        End If
    Loop
    Result = BindVars(NewPattern, VarBinds)
    SmartFormat = Result
    
End Function
