Attribute VB_Name = "Module4"
Option Explicit
Function GetMatches() As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim Index As Long
    Dim NewList As New Collection
    Dim TempA As Long
    Dim TempB As Long
    Dim NewItem As String
    
    On Error Resume Next
    Length = mItemList.Count
    i = 1
    Do While i <= Length
        TokenA = mItemList.Item(i)
        Index = FindItem(TokenA, i)
        If Index <> 0 Then
            TokenB = mItemList.Item(Index)
            Call NewList.Item(TokenA & vbCrLf & TokenB): TempA = Err: Err = 0
            Call NewList.Item(TokenB & vbCrLf & TokenA): TempB = Err: Err = 0
            If _
                TempA <> 0 And _
                TempB <> 0 _
            Then
                If _
                    FindText(TokenA, TokenB) = 0 And _
                    FindText(TokenB, TokenA) = 0 _
                Then
                    NewItem = TokenA & vbCrLf & TokenB
                    Call NewList.Add(NewItem, NewItem)
                    Result = Result & CStr(i) & "+" & CStr(Index) & vbCrLf
                Else
                    Call NewList.Add(TokenA, TokenA)
                End If
            End If
        Else
            Call NewList.Add(TokenA, TokenA)
        End If
        mStatus = "Searching for Like-States [1 / 3] :: " & Format(i / Length, "00%")
        DoEvents
        i = i + 1
    Loop
    Call ListClear(mItemList)
    For i = 1 To NewList.Count
        Call mItemList.Add(NewList.Item(i))
    Next i
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - Len(vbCrLf))
    GetMatches = Result
    
End Function
Function CompressTable(Table As String) As String

    Dim i As Long
    Dim Result As String
    Dim Matches As String
    Dim NewTable As String
    Dim Length As Long
    Dim Token As String
    Dim IndexA As Long
    Dim IndexB As Long
    Dim NewItem As String
    Dim Tag As String
    
    Matches = GetMatches
    If Matches <> "" Then
        NewTable = SwapMatches(Table, Matches)
        Length = Len(NewTable)
        i = 1
        Do While i <= Length
            Token = ScanText(NewTable, i, vbCrLf)
            Tag = GetEntry(Token, vbTab, 1)
            If FindText(Tag, "+") = 0 Then _
                Result = Result & Token & vbCrLf
        Loop
        Length = Len(Matches)
        i = 1
        Do While i <= Length
            Token = ScanText(Matches, i, vbCrLf)
            IndexA = GetEntry(Token, "+", 1)
            IndexB = GetEntry(Token, "+", 2)
            NewItem = MergeRows(NewTable, IndexA, IndexB)
            Result = Result & NewItem & vbCrLf
        Loop
        If Result <> "" Then _
            Result = Left(Result, Len(Result) - Len(vbCrLf))
        Result = FixStates(Result)
    Else
        Result = Table
    End If
    CompressTable = Result
    
End Function
Function SwapMatches(Table As String, Matches As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim Token As String
    Dim IndexA As Long
    Dim IndexB As Long
    
    Result = Table
    '===========================================================
    Result = EditReplace(Result, vbCrLf, vbTab & vbCrLf & vbTab)
    Result = vbTab & Result & vbTab
    Result = EditReplace(Result, "s", "s" & vbTab)
    '===========================================================
    Length = Len(Matches)
    i = 1
    Do While i <= Length
        Token = ScanText(Matches, i, vbCrLf)
        IndexA = GetEntry(Token, "+", 1)
        IndexB = GetEntry(Token, "+", 2)
        Result = EditReplace(Result, vbTab & CStr(IndexA) & vbTab, vbTab & CStr(IndexA) & "+" & CStr(IndexB) & vbTab)
        Result = EditReplace(Result, vbTab & CStr(IndexB) & vbTab, vbTab & CStr(IndexA) & "+" & CStr(IndexB) & vbTab)
        mStatus = "Merging Like-States [2 / 3] :: " & Format(i / Length, "00%")
        DoEvents
    Loop
    '===========================================================
    Result = EditReplace(Result, vbTab & vbCrLf & vbTab, vbCrLf)
    Result = Mid(Result, 2, Len(Result) - 2)
    Result = EditReplace(Result, "s" & vbTab, "s")
    '===========================================================
    SwapMatches = Result
    
End Function
Function FixStates(Table As String) As String

    Dim i As Long
    Dim Result As String
    Dim Length As Long
    Dim Token As String
    Dim Tag As String
    Dim Temp As Boolean
    Dim Count As Long
    
    Result = Table
    '===========================================================
    Result = EditReplace(Result, vbCrLf, vbTab & vbCrLf & vbTab)
    Result = vbTab & Result & vbTab
    Result = EditReplace(Result, "s", "s" & vbTab)
    '===========================================================
    Length = Len(Table)
    i = 1
    Do While i <= Length
        Token = ScanText(Table, i, vbCrLf)
        Tag = GetEntry(Token, vbTab, 1)
        If Tag <> "" Then
            Temp = False
            If FindText(Tag, "+") <> 0 Then
                Temp = True
            Else
                If CLng(Tag) <> Count Then _
                    Temp = True
            End If
            If Temp Then _
                Result = EditReplace(Result, vbTab & Tag & vbTab, vbTab & CStr(Count) & vbTab)
        End If
        mStatus = "Finalizing [3 / 3] :: " & Format(i / Length, "00%")
        DoEvents
        Count = Count + 1
    Loop
    '===========================================================
    Result = EditReplace(Result, vbTab & vbCrLf & vbTab, vbCrLf)
    Result = Mid(Result, 2, Len(Result) - 2)
    Result = EditReplace(Result, "s" & vbTab, "s")
    '===========================================================
    FixStates = Result
    
End Function
Function MergeRows(Table As String, IndexA As Long, IndexB As Long) As String

    Dim i As Long
    Dim j As Long
    Dim Result As String
    Dim ItemA As String
    Dim ItemB As String
    Dim Length As Long
    Dim TokenA As String
    Dim TokenB As String
    
    ItemA = GetEntry(Table, vbCrLf, IndexA + 1) & vbTab
    ItemB = GetEntry(Table, vbCrLf, IndexB + 1) & vbTab
    Length = Len(ItemA)
    i = 1
    j = 1
    Do While i <= Length
        TokenA = ScanText(ItemA, i, vbTab)
        TokenB = ScanText(ItemB, j, vbTab)
        If TokenA = "" Then _
            TokenA = TokenB
        Result = Result & TokenA & vbTab
    Loop
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - 1)
    MergeRows = Result
    
End Function
