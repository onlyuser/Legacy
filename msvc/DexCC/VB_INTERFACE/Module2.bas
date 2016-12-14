Attribute VB_Name = "Module2"
Option Explicit

Public Const BIG_NUMBER As Integer = 4096 * 4
Function LoadText(Filename As String) As String

    Dim Result As String
    Dim FileNumber As Integer
    Dim Token As String
    
    On Error Resume Next
    FileNumber = FreeFile
    Open Filename For Input As FileNumber
        Do While Not EOF(FileNumber)
            Line Input #FileNumber, Token
            Result = Result & Token & vbCrLf
            DoEvents
        Loop
    Close FileNumber
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - Len(vbCrLf))
    LoadText = Result
    
End Function
Function SaveText(Filename As String, Text As String)

    Dim FileNumber As Integer
    
    On Error Resume Next
    If Dir(Filename) <> "" Then _
        Call Kill(Filename)
    FileNumber = FreeFile
    Open Filename For Binary Access Write As FileNumber
        Put #FileNumber, , Text
    Close FileNumber
    
End Function
Function TrimEx(Expr As String) As String

    Dim Temp As String
    
    Temp = Trim(Expr)
    If Asc(Mid(Temp, Len(Temp), 1)) = 0 Then _
        Temp = Left(Temp, Len(Temp) - 1)
    TrimEx = Temp
    
End Function
Function Max(A As Variant, B As Variant)

    If A > B Then
        Max = A
    Else
        Max = B
    End If
    
End Function
Function Min(A As Variant, B As Variant)

    If A < B Then
        Min = A
    Else
        Min = B
    End If
    
End Function
Function Limit(X As Variant, pMin As Variant, pMax As Variant)

    Limit = Min(Max(X, pMin), pMax)
    
End Function
Function ScanText(S As String, Start As Integer, Ptn As String) As String

    Dim Pos As Integer
    
    If Ptn <> "" Then
        Pos = InStr(Start, S, Ptn)
    Else
        Pos = 0
    End If
    If Pos = 0 Then _
        Pos = Len(S) + 1
    ScanText = Mid(S, Start, Pos - Start)
    Start = Limit(Pos + Len(Ptn), 1, Len(S) + 1)
    
End Function
Function GetEntry(S As String, SepTerm As String, N As Integer) As String

    Dim i As Integer
    Dim Count As Integer
    Dim Token As String
    
    Count = 0
    i = 1
    Do While i <= Len(S)
        Token = ScanText(S, i, SepTerm)
        Count = Count + 1
        If Count = N Then
            GetEntry = Token
            Exit Function
        End If
    Loop
    
End Function
