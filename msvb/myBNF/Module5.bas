Attribute VB_Name = "Module5"
Option Explicit
Function IsSameItem(ItemA As String, ItemB As String) As Boolean

    Dim i As Long
    Dim j As Long
    Dim Result As Boolean
    Dim Length As Long
    Dim Token As String
    Dim Core As String
    
    Result = True
    Length = Len(ItemA)
    i = 1
    Do While i <= Length
        Token = ScanText(ItemA, i, vbCrLf)
        '==============================
        Core = GetEntry(Token, "::", 1)
        '==============================
        If FindText(ItemB, Core & "::") = 0 Then
            Result = False
            Exit Do
        End If
    Loop
    If Result Then
        Length = Len(ItemB)
        i = 1
        Do While i <= Length
            Token = ScanText(ItemB, i, vbCrLf)
            '==============================
            Core = GetEntry(Token, "::", 1)
            '==============================
            If FindText(ItemA, Core & "::") = 0 Then
                Result = False
                Exit Do
            End If
        Loop
    End If
    IsSameItem = Result
    
End Function
Function FindItem(Target As String, Optional Ignore As Long, Optional Exact As Boolean) As Long

    Dim i As Long
    Dim Result As Long
    Dim Length As Long
    Dim Token As String
    
    Length = mItemList.Count
    i = 1
    Do While i <= Length
        Token = mItemList.Item(i)
        If i <> Ignore Then
            If Exact Then
                If Token = Target Then
                    Result = i
                    Exit Do
                End If
            Else
                If IsSameItem(Token, Target) Then
                    Result = i
                    Exit Do
                End If
            End If
        End If
        i = i + 1
    Loop
    FindItem = Result
    
End Function
