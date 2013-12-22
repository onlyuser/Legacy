Attribute VB_Name = "Module3"
Option Explicit

Public pReduceList As New Collection
Public pTermList As New Collection
Public pTable As New Collection
Public pMacroList As New Collection
Public pSwapList As New Collection

Public mIndex As Long
Public mSplit As Long
Function SmartParse(Text As String, Optional Iter As Long = 10) As String

    Dim i As Long
    Dim Result As String
    
    For i = 1 To Iter
        mSplit = 0
        Result = GetParse(Text)
        If mSplit = 0 Then
            Exit For
        Else
            If Left(Result, 3) <> "err" Then _
                Exit For
        End If
    Next i
    If Left(Result, 3) = "err" Then _
        Result = Result & vbCrLf & mSplit & " conflict(s)"
    SmartParse = Result
    
End Function
Function ApplySwap(Text As String)

    Dim i As Long
    Dim Length As Long
    Dim Token As String
    Dim LHS As String
    Dim RHS As String
    
    Length = pSwapList.Count
    i = 1
    Do While i <= Length
        Token = pSwapList.Item(i)
        '===============================
        LHS = GetEntry(Token, " -> ", 1)
        LHS = Trim(LHS)
        RHS = GetEntry(Token, " -> ", 2)
        RHS = Trim(RHS)
        '===============================
        LHS = Mid(LHS, 2, Len(LHS) - 2)
        RHS = Mid(RHS, 2, Len(RHS) - 2)
        Text = " " & Text & " "
        Text = EditReplace(Text, LHS, RHS)
        Text = Mid(Text, 2, Len(Text) - 2)
        i = i + 1
    Loop
    
End Function
Function ApplyMacro(Text As String, Optional SwapOnly As Boolean)

    Dim i As Long
    Dim j As Long
    Dim pLenA As Long
    Dim pLenB As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim LHS As String
    Dim RHS As String
    
    pLenA = pMacroList.Count
    i = 1
    Do While i <= pLenA
        TokenA = pMacroList.Item(i)
        '==============================
        LHS = GetEntry(TokenA, ":=", 1)
        LHS = Trim(LHS)
        RHS = GetEntry(TokenA, ":=", 2)
        RHS = Trim(RHS)
        '==============================
        pLenB = Len(RHS)
        j = 1
        Do While j <= pLenB
            TokenB = ScanText(RHS, j, "|")
            TokenB = Trim(TokenB)
            If Not SwapOnly Or Left(LHS, 2) <> "'_" Then
                Text = " " & Text & " "
                Text = EditReplace(Text, " " & TokenB & " ", " " & LHS & " ")
                Text = Mid(Text, 2, Len(Text) - 2)
            End If
        Loop
        i = i + 1
    Loop
    
End Function
Function LoadParser(Filename As String)

    Dim i As Long
    Dim j As Long
    Dim Buffer As String
    Dim pLenA As Long
    Dim pLenB As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim Mode As Long
    
    Call ListClear(pSwapList)
    Call ListClear(pMacroList)
    Call ListClear(pReduceList)
    Call ListClear(pTermList)
    Call ListClear(pTable)
    Buffer = LoadText(Filename)
    pLenA = Len(Buffer)
    i = 1
    Do While i <= pLenA
        TokenA = ScanText(Buffer, i, vbCrLf)
        If TokenA <> "" Then
            Select Case Mode
                Case 0
                    If TokenA <> "_" Then _
                        Call pSwapList.Add(TokenA)
                Case 1
                    If TokenA <> "_" Then _
                        Call pMacroList.Add(TokenA)
                Case 2
                    '============================== // TRIM ROW LABEL
                    j = 1
                    Call ScanText(TokenA, j, vbTab)
                    '==============================
                    TokenA = ScanText(TokenA, j, Chr(0))
                    Call pReduceList.Add(TokenA)
                Case 3
                    '====================== // ADD LINE-STOPPER
                    TokenA = TokenA & vbTab
                    '======================
                    pLenB = Len(TokenA)
                    j = 1
                    Do While j <= pLenB
                        TokenB = ScanText(TokenA, j, vbTab)
                        If Left(TokenA, 1) = vbTab Then
                            Call pTermList.Add(TokenB)
                        Else
                            Call pTable.Add(TokenB)
                        End If
                    Loop
            End Select
        Else
            Mode = Mode + 1
        End If
    Loop
    
End Function
Function GetNextState(Stack As Collection, Name As String) As String

    Dim Result As String
    Dim State As Long
    Dim Index As Long
    Dim Count As Long
    
    '============================================================== // LET S BE STACK TOP
    State = Stack.Item(Stack.Count)
    '============================================================== // LET GOTO[S,N] BE A->B
    Index = ListFind(pTermList, Name)
    If Index <> 0 Then
        Result = pTable.Item((State - 1) * pTermList.Count + Index)
        Count = CountText(Result, "/")
        If Count = 0 Then
            Result = ScanText(Result, 0 + 1, "/")
        Else
            Index = Int(Rnd * (Count + 1)) + 1
            Result = GetEntry(Result, "/", Index)
            mSplit = mSplit + 1
        End If
    Else
        Result = "e"
    End If
    '==============================================================
    GetNextState = Result
    
End Function
Function GetParse(Text As String) As String

    Dim i As Long
    Dim j As Long
    Dim Result As String
    Dim Stack As New Collection
    Dim NewText As String
    Dim Length As Long
    Dim Token As String
    Dim Action As String
    Dim LHS As String
    Dim RHS As String
    Dim Count As Long
    
    NewText = Text
    NewText = EditDeRepeat(NewText, " ")
    NewText = Trim(NewText)
    Call ApplySwap(NewText)
    NewText = "'" & EditReplace(NewText, " ", "' '") & "'"
    Call ApplyMacro(NewText)
    Call Stack.Add("1")
    NewText = NewText & " " & "$"
    Length = Len(NewText)
    i = 1
    '================================ // LET T BE FIRST INPUT
    Token = ScanText(NewText, i, " ")
    '================================
    Do While i <= Length Or Token = "$"
        '================================== // GET GOTO[T]
        Action = GetNextState(Stack, Token)
        '==================================
        Select Case Left(Action, 1)
            Case "s" '// SHIFT
                Action = Right(Action, Len(Action) - 1)
                '================================ // PUSH T THEN GOTO[T] ONTO STACK
                Call Stack.Add(Token)
                Call Stack.Add(Action)
                '================================ // LET T BE NEXT INPUT
                Token = ScanText(NewText, i, " ")
                '================================
            Case "r" '// REDUCE
                Action = Right(Action, Len(Action) - 1)
                Action = pReduceList.Item(CLng(Action))
                '============================================ // LET GOTO[T] BE A->B
                LHS = GetEntry(Action, ":=", 1)
                LHS = Trim(LHS)
                RHS = GetEntry(Action, ":=", 2)
                RHS = Trim(RHS)
                '============================================ // POP 2*|B| ITEMS FROM STACK
                Count = (CountText(RHS, " ") + 1) * 2
                For j = 1 To Count
                    Call Stack.Remove(Stack.Count)
                Next j
                '============================================ // GET GOTO[A]
                Action = GetNextState(Stack, LHS)
                '============================================ // PUSH A THEN GOTO[A] ONTO STACK
                Call Stack.Add(LHS)
                Call Stack.Add(Action)
                '============================================ // REPORT A->B
                Result = Result & LHS & " := " & RHS & vbCrLf
                '============================================
            Case "a" '// ACCEPT
                Exit Do
            Case Else '// ERROR
                Result = "err: " & ListPrint(Stack)
                Exit Do
        End Select
    Loop
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - Len(vbCrLf))
    GetParse = Result
    
End Function
Function BuildTree(Text As String, Parse As String, TreeObj As TreeView)

    Dim Buffer As String
    
    Buffer = GetLinkData("", Parse)
    Call BuildTreeEx(Buffer, TreeObj)
    Call FixTree(Text, TreeObj)
    
End Function
Function GetLinkData(Head As String, Tail As String) As String

    Dim i As Long
    Dim j As Long
    Dim Result As String
    Dim LHS As String
    Dim RHS As String
    Dim Length As Long
    Dim Token As String
    Dim NewHead As String
    
    If Head <> "" Then
        '=============================================== // LET H BE A->B
        LHS = GetEntry(Head, ":=", 1)
        LHS = Trim(LHS)
        RHS = GetEntry(Head, ":=", 2)
        RHS = Trim(RHS)
        '=============================================== // TAG A
        LHS = "[" & Hex(mBigNumber - mIndex) & "]" & LHS
        '=============================================== // REVERSE B
        RHS = EditReverse(RHS, " ")
        '===============================================
        Length = Len(RHS)
        i = 1
        Do While i <= Length
            mIndex = mIndex + 1
            '=================================================== // LET T BE NEXT B
            Token = ScanText(RHS, i, " ")
            '=================================================== // TAG T
            Token = "[" & Hex(mBigNumber - mIndex) & "]" & Token
            '=================================================== // REPORT A->T
            Result = Result & LHS & " -> " & Token & vbCrLf
            '===================================================
            If _
                Not ( _
                    Right(Token, 1) = "'" Or _
                    Right(Token, 1) = "@" _
                ) _
            Then
                '==================================================== // RESUME TAIL RECURSION
                j = 1
                NewHead = ScanText(Tail, j, vbCrLf)
                Tail = ScanText(Tail, j, Chr(0))
                Result = Result & GetLinkData(NewHead, Tail) & vbCrLf
                '====================================================
            End If
        Loop
        If Result <> "" Then _
            Result = Left(Result, Len(Result) - Len(vbCrLf))
    Else
        mIndex = 0
        '================================== // REVERSE TAIL
        Tail = EditReverse(Tail, vbCrLf)
        '================================== // INIT TAIL RECURSION
        i = 1
        NewHead = ScanText(Tail, i, vbCrLf)
        Tail = ScanText(Tail, i, Chr(0))
        Result = GetLinkData(NewHead, Tail)
        '==================================
    End If
    GetLinkData = Result
    
End Function
Function BuildTreeEx(Text As String, TreeObj As TreeView)

    Dim i As Long
    Dim Length As Long
    Dim Token As String
    Dim Parent As String
    Dim Child As String
    
    Call TreeObj.Nodes.Clear
    If Text <> "" Then
        '============================================================ // TAG SYMBOL
        Call TreeObj.Nodes.Add(, , "[" & Hex(mBigNumber) & "]S", "S")
        '============================================================
        Length = Len(Text)
        i = 1
        Do While i <= Length
            Token = ScanText(Text, i, vbCrLf)
            '================================== // PARSE T
            Parent = GetEntry(Token, " -> ", 1)
            Child = GetEntry(Token, " -> ", 2)
            '==================================
            Call TreeObj.Nodes.Add(Parent, tvwChild, Child, Child)
        Loop
        For i = 1 To TreeObj.Nodes.Count
            Call TreeObj.Nodes.Item(i).EnsureVisible
            TreeObj.Nodes.Item(i).Sorted = True
            TreeObj.Nodes.Item(i).Sorted = False
            TreeObj.Nodes.Item(i).Text = EditReplacePtn(TreeObj.Nodes.Item(i).Text, "[", "]", "")
        Next i
        TreeObj.Nodes.Item(1).Selected = True
    End If
    
End Function
Function FixTree(Text As String, TreeObj As TreeView)

    Dim NewText As String
    
    NewText = Text
    NewText = EditDeRepeat(NewText, " ")
    NewText = Trim(NewText)
    Call ApplySwap(NewText)
    NewText = "'" & EditReplace(NewText, " ", "' '") & "'"
    Call ApplyMacro(NewText, True)
    Call FixTreeEx(NewText, TreeObj.Nodes.Item(1))
    
End Function
Function FixTreeEx(Text As String, pNode As Node)

    Dim i As Long
    Dim Token As Node
    
    If pNode.Children <> 0 Then
        Set Token = pNode.Child
        Do While Not Token Is Nothing
            Call FixTreeEx(Text, Token)
            Set Token = Token.Next
        Loop
    Else
        i = 1
        pNode.Text = ScanText(Text, i, " ")
        Text = ScanText(Text, i, Chr(0))
    End If
    
End Function
