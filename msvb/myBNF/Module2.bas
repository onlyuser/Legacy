Attribute VB_Name = "Module2"
Option Explicit

Public mRuleList As New Collection
Public mItemList As New Collection
Public mTermList As New Collection
Public mReduceList As New Collection
Public mGotoList As New Collection
Public mMacroList As New Collection
Public mSwapList As New Collection

Public mStatus As String
Function IsMacro(Text As String) As Boolean

    Dim i As Long
    Dim j As Long
    Dim Result As Boolean
    Dim LHS As String
    Dim RHS As String
    Dim pLenA As Long
    Dim pLenB As Long
    Dim TokenA As String
    Dim TokenB As String
    
    Result = True
    '============================
    LHS = GetEntry(Text, ":=", 1)
    LHS = Trim(LHS)
    RHS = GetEntry(Text, ":=", 2)
    RHS = Trim(RHS)
    '============================
    pLenA = Len(RHS)
    i = 1
    Do While i <= pLenA
        TokenA = ScanText(RHS, i, "|")
        TokenA = Trim(TokenA)
        pLenB = Len(TokenA)
        j = 1
        Do While j <= pLenB
            TokenB = ScanText(TokenA, j, " ")
            If Left(TokenB, 1) <> "'" Then
                Result = False
                i = pLenA + 1
                Exit Do
            End If
        Loop
    Loop
    IsMacro = Result
    
End Function
Function LoadCFG(Filename As String, Optional NoSwap As Boolean)

    Dim i As Long
    Dim Buffer As String
    Dim Length As Long
    Dim Token As String
    Dim LHS As String
    Dim RHS As String
    Dim Link As String
    
    Call ListClear(mSwapList)
    Call ListClear(mMacroList)
    Call ListClear(mRuleList)
    Call mRuleList.Add("S2 := S", "S2")
    Buffer = LoadText(Filename)
    '====================================================
    Buffer = Buffer & vbCrLf
    Buffer = EditReplacePtn(Buffer, "//", vbCrLf, vbCrLf)
    Buffer = Left(Buffer, Len(Buffer) - Len(vbCrLf))
    '====================================================
    Length = Len(Buffer)
    i = 1
    Do While i <= Length
        Token = ScanText(Buffer, i, vbCrLf)
        If Token <> "" Then
            '=======================================
            Token = EditReplace(Token, ":=", " := ")
            Token = EditReplace(Token, "|", " | ")
            Token = EditDeRepeat(Token, " ")
            Token = Trim(Token)
            '=======================================
            Select Case Left(Token, 1)
                Case "("
                    Token = Mid(Token, 2, Len(Token) - 2)
                    '=================================
                    LHS = GetEntry(Token, ") -> (", 1)
                    LHS = Trim(LHS)
                    RHS = GetEntry(Token, ") -> (", 2)
                    RHS = Trim(RHS)
                    '=================================
                    LHS = Chr(34) & LHS & Chr(34)
                    RHS = Chr(34) & RHS & Chr(34)
                    Call mSwapList.Add(LHS & " -> " & RHS)
                Case Else
                    '=============================
                    LHS = GetEntry(Token, ":=", 1)
                    LHS = Trim(LHS)
                    '=============================
                    If IsMacro(Token) And Not NoSwap Then
                        '=============================
                        RHS = GetEntry(Token, ":=", 2)
                        RHS = Trim(RHS)
                        '=============================
                        Link = "'_" & LHS & "'"
                        Call mMacroList.Add(Link & " := " & RHS)
                        Call mRuleList.Add(LHS & " := " & Link, LHS)
                    Else
                        Call mRuleList.Add(Token, LHS)
                    End If
            End Select
        End If
    Loop
    
End Function
Function GetFirst( _
    Name As String, _
    Optional Parent As String, _
    Optional FirstList As Collection _
) As String

    Dim i As Long
    Dim Result As String
    Dim pFirstList As Collection
    Dim Core As String
    Dim RHS As String
    Dim Length As Long
    Dim Token As String
    Dim Head As String
    
    On Error Resume Next
    If Parent = "" Then
        Set pFirstList = New Collection
        Call GetFirst(Name, "_", pFirstList)
        Result = ListPrint(pFirstList, " ")
    Else
        If FindText(Name, " ") = 0 Then
            Core = mRuleList.Item(Name)
            If Err <> 0 Then
                Call FirstList.Add(Name, Name)
            Else
                '============================
                RHS = GetEntry(Core, ":=", 2)
                RHS = Trim(RHS)
                '============================
                Length = Len(RHS)
                i = 1
                Do While i <= Length
                    Token = ScanText(RHS, i, "|")
                    Token = Trim(Token)
                    Call GetFirst(Token, Name, FirstList)
                Loop
            End If
        Else
            Head = ScanText(Name, 0 + 1, " ")
            If Head <> Parent Then _
                Call GetFirst(Head, Parent, FirstList)
        End If
    End If
    GetFirst = Result
    
End Function
Function GetCurSym(Text As String, Optional GetNext As Boolean, Optional NextSym As String) As String

    Dim i As Long
    Dim Result As String
    
    If Right(Text, 1) <> "." Then
        i = 1
        Call ScanText(Text, i, ".")
        Result = ScanText(Text, i, " ")
        If GetNext Then _
            NextSym = ScanText(Text, i, " ")
    End If
    GetCurSym = Result
    
End Function
Function GetClosure(Text As String) As String

    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim p As Long
    Dim Result As String
    Dim pLenA As Long
    Dim pLenB As Long
    Dim pLenC As Long
    Dim pLenD As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim TokenC As String
    Dim TokenD As String
    Dim Core As String
    Dim Lookahead As String
    Dim CurSym As String
    Dim NextSym As String
    Dim First As String
    Dim LHS As String
    Dim RHS As String
    Dim NewItem As String
    Dim ClipEnd As Boolean
    
    Result = Text
    pLenA = Len(Result)
    i = 1
    Do While i <= pLenA
        TokenA = ScanText(Result, i, vbCrLf)
        If i > pLenA Then
            ClipEnd = True
        Else
            ClipEnd = False
        End If
        '====================================
        Core = GetEntry(TokenA, "::", 1)
        Core = Trim(Core)
        Lookahead = GetEntry(TokenA, "::", 2)
        Lookahead = Trim(Lookahead)
        '====================================
        CurSym = GetCurSym(Core, True, NextSym)
        If Not (NextSym <> "" And Lookahead = "$") Then _
            NextSym = Trim(NextSym & " " & Lookahead)
        First = GetFirst(NextSym)
        pLenB = mRuleList.Count
        j = 1
        Do While j <= pLenB
            TokenB = mRuleList.Item(j)
            '==============================
            LHS = GetEntry(TokenB, ":=", 1)
            LHS = Trim(LHS)
            '==============================
            If LHS = CurSym Then
                '==============================
                RHS = GetEntry(TokenB, ":=", 2)
                RHS = Trim(RHS)
                '==============================
                pLenC = Len(RHS)
                k = 1
                Do While k <= pLenC
                    TokenC = ScanText(RHS, k, "|")
                    TokenC = Trim(TokenC)
                    pLenD = Len(First)
                    p = 1
                    Do While p <= pLenD
                        TokenD = ScanText(First, p, " ")
                        NewItem = LHS & " := " & "." & TokenC & " :: " & TokenD
                        If FindText(Result, NewItem) = 0 Then
                            Result = Result & vbCrLf & NewItem
                            pLenA = Len(Result)
                        End If
                    Loop
                Loop
            End If
            j = j + 1
        Loop
        If ClipEnd Then _
            Call ScanText(Result, i, vbCrLf)
        DoEvents
    Loop
    GetClosure = Result
    
End Function
Function GetAdvance(Text As String) As String

    Dim i As Long
    Dim j As Long
    Dim Result As String
    Dim pLenA As Long
    Dim pLenB As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim Core As String
    Dim Lookahead As String
    Dim LHS As String
    Dim RHS As String
    Dim Buffer As String
    
    pLenA = Len(Text)
    i = 1
    Do While i <= pLenA
        TokenA = ScanText(Text, i, vbCrLf)
        '====================================
        Core = GetEntry(TokenA, "::", 1)
        Core = Trim(Core)
        Lookahead = GetEntry(TokenA, "::", 2)
        Lookahead = Trim(Lookahead)
        '====================================
        LHS = GetEntry(Core, ":=", 1)
        LHS = Trim(LHS)
        RHS = GetEntry(Core, ":=", 2)
        RHS = Trim(RHS)
        '====================================
        If Right(RHS, 1) = "." Then
            Buffer = RHS
            Buffer = EditReplace(Buffer, " .", ". ")
            Buffer = Trim(Buffer)
        Else
            Buffer = ""
            pLenB = Len(RHS)
            j = 1
            Do While j <= pLenB
                TokenB = ScanText(RHS, j, " ")
                If Left(TokenB, 1) = "." Then _
                    TokenB = Right(TokenB, Len(TokenB) - 1) & "."
                Buffer = Buffer & TokenB & " "
            Loop
            If Buffer <> "" Then _
                Buffer = Left(Buffer, Len(Buffer) - 1)
        End If
        Buffer = Buffer & " :: " & Lookahead
        Buffer = EditReplace(Buffer, ". ", " .")
        Buffer = Trim(Buffer)
        Result = Result & LHS & " := " & Buffer & vbCrLf
    Loop
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - Len(vbCrLf))
    GetAdvance = Result
    
End Function
Function GetGoto(Text As String, Name As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim Token As String
    
    On Error Resume Next
    Result = mGotoList.Item(Text & "_" & Name)
    If Err <> 0 Then
        Length = Len(Text)
        i = 1
        Do While i <= Length
            Token = ScanText(Text, i, vbCrLf)
            If GetCurSym(Token) = Name Then _
                Result = Result & Token & vbCrLf
        Loop
        If Result <> "" Then _
            Result = Left(Result, Len(Result) - Len(vbCrLf))
        Result = GetAdvance(Result)
        Result = GetClosure(Result)
        Call mGotoList.Add(Result, Text & "_" & Name)
    End If
    GetGoto = Result
    
End Function
Function GetGotoEx(Index As Long, Name As String) As Long

    Dim Result As Long
    Dim Buffer As String
    Dim NewItem As String
    
    Buffer = mItemList.Item(Index)
    NewItem = GetGoto(Buffer, Name)
    If NewItem <> "" Then
        Result = FindItem(NewItem, 0, True)
        If Result = 0 Then _
            Call mItemList.Add(NewItem)
    End If
    GetGotoEx = Result
    
End Function
Function BuildItems()

    Dim i As Long
    Dim j As Long
    Dim NewItem As String
    Dim pLenA As Long
    Dim pLenB As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim CurSym As String
    
    Call ListClear(mItemList)
    NewItem = GetClosure("S2 := .S :: $")
    Call mItemList.Add(NewItem)
    pLenA = mItemList.Count
    i = 1
    Do While i <= pLenA
        TokenA = mItemList.Item(i)
        pLenB = Len(TokenA)
        j = 1
        Do While j <= pLenB
            TokenB = ScanText(TokenA, j, vbCrLf)
            CurSym = GetCurSym(TokenB)
            If CurSym <> "" Then _
                Call GetGotoEx(i, CurSym)
            pLenA = mItemList.Count
        Loop
        mStatus = "Generating LR(1) Items [1 / 2] :: " & Format(i / pLenA, "00%")
        DoEvents
        i = i + 1
    Loop
    
End Function
Function GetAction(Index As Long, Name As String) As String

    Dim i As Long
    Dim Result As String
    Dim Buffer As String
    Dim Length As Long
    Dim Token As String
    Dim Core As String
    Dim Lookahead As String
    Dim LHS As String
    Dim pIndex As Long
    
    If Left(Name, 1) = "'" Or Name = "$" Then
        Buffer = mItemList.Item(Index)
        i = 1
        Length = Len(Buffer)
        Do While i <= Length
            Token = ScanText(Buffer, i, vbCrLf)
            '===================================
            Core = GetEntry(Token, "::", 1)
            Core = Trim(Core)
            Lookahead = GetEntry(Token, "::", 2)
            Lookahead = Trim(Lookahead)
            '===================================
            LHS = GetEntry(Core, ":=", 1)
            LHS = Trim(LHS)
            '===================================
            If GetCurSym(Core) = Name Then
                pIndex = GetGotoEx(Index, Name)
                If FindText("/" & Result & "/", "/" & "s" & CStr(pIndex) & "/") = 0 Then
                    If Result <> "" Then _
                        Result = Result & "/"
                    Result = Result & "s" & CStr(pIndex)
                End If
            End If
            If Right(Core, 1) = "." And Lookahead = Name Then
                If LHS <> "S2" Then
                    Core = Left(Core, Len(Core) - 1)
                    Core = Trim(Core)
                    pIndex = ListFind(mReduceList, Core)
                    If pIndex = 0 Then
                        Call mReduceList.Add(Core)
                        pIndex = mReduceList.Count
                    End If
                    If FindText("/" & Result & "/", "/" & "r" & CStr(pIndex) & "/") = 0 Then
                        If Result <> "" Then _
                            Result = Result & "/"
                        Result = Result & "r" & CStr(pIndex)
                    End If
                Else
                    Result = "acc"
                End If
            End If
        Loop
    Else
        Result = GetGotoEx(Index, Name)
        If Result = "0" Then _
            Result = ""
    End If
    GetAction = Result
    
End Function
Function BuildTerms()

    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim pLenA As Long
    Dim pLenB As Long
    Dim pLenC As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim TokenC As String
    Dim LHS As String
    Dim RHS As String
    
    On Error Resume Next
    Call ListClear(mTermList)
    Call mTermList.Add("$")
    pLenA = mRuleList.Count
    i = 1
    Do While i <= pLenA
        TokenA = mRuleList.Item(i)
        '==============================
        LHS = GetEntry(TokenA, ":=", 1)
        LHS = Trim(LHS)
        RHS = GetEntry(TokenA, ":=", 2)
        RHS = Trim(RHS)
        '==============================
        If LHS <> "S2" Then
            Call mTermList.Item(LHS)
            If Err <> 0 Then _
                Call mTermList.Add(LHS, LHS)
        End If
        pLenB = Len(RHS)
        j = 1
        Do While j <= pLenB
            TokenB = ScanText(RHS, j, "|")
            TokenB = Trim(TokenB)
            pLenC = Len(TokenB)
            k = 1
            Do While k <= pLenC
                TokenC = ScanText(TokenB, k, " ")
                Call mTermList.Item(TokenC)
                If Err <> 0 Then _
                    Call mTermList.Add(TokenC, TokenC)
            Loop
        Loop
        i = i + 1
    Loop
    
End Function
Function GetTable() As String

    Dim i As Long
    Dim j As Long
    Dim Result As String
    Dim Buffer As String
    Dim Length As Long
    Dim Token As String
    
    Call ListClear(mGotoList)
    Call ListClear(mReduceList)
    Call BuildItems
    Call BuildTerms
    Result = vbTab & ListPrint(mTermList, vbTab) & vbCrLf
    For i = 1 To mItemList.Count
        Buffer = ""
        Length = mTermList.Count
        j = 1
        Do While j <= Length
            Token = mTermList.Item(j)
            Buffer = Buffer & GetAction(i, Token) & vbTab
            mStatus = _
                "Generating Parse Table [2 / 2] :: " & _
                Format((i - 1) / mItemList.Count + j / Length / mItemList.Count, "00%")
            DoEvents
            j = j + 1
        Loop
        If Buffer <> "" Then _
            Buffer = Left(Buffer, Len(Buffer) - 1)
        Result = Result & CStr(i) & vbTab & Buffer & vbCrLf
    Next i
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - Len(vbCrLf))
    GetTable = Result
    
End Function
Function SaveParser(Filename As String, Table As String)

    Dim Buffer As String
    
    If mSwapList.Count <> 0 Then
        Buffer = ListPrint(mSwapList, vbCrLf) & vbCrLf & vbCrLf
    Else
        Buffer = "_" & vbCrLf & vbCrLf
    End If
    If mMacroList.Count <> 0 Then
        Buffer = Buffer & ListPrint(mMacroList, vbCrLf) & vbCrLf & vbCrLf
    Else
        Buffer = Buffer & "_" & vbCrLf & vbCrLf
    End If
    Buffer = Buffer & ListPrint(mReduceList, vbCrLf, True, "", vbTab) & vbCrLf & vbCrLf & Table
    Call SaveText(Filename, Buffer)
    
End Function
