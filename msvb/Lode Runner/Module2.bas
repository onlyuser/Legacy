Attribute VB_Name = "Module2"
Function ScanText(Text As String, Start As Integer, StopSymbol As String) As String

    Dim i As Integer
    Dim Result As String
    Dim LenScan As Integer
    Dim LenStop As Integer
    
    LenScan = Len(Text) - Len(StopSymbol) + 1
    LenStop = Len(StopSymbol)
    If Start <= LenScan Then
        For i = Start To LenScan
            If Mid(Text, i, LenStop) = StopSymbol Then
                Result = Mid(Text, Start, (i - 1) - (Start - 1))
                Start = i + LenStop
                Exit For
            End If
        Next i
        If i > LenScan Then
            Result = Mid(Text, Start, LenScan - (Start - 1))
            Start = LenScan + 1
        End If
    End If
    ScanText = Result
    
End Function
Function GetFilename(FullPath As String) As String

    Dim i As Integer
    Dim Result As String
    
    i = Len(FullPath)
    Do
        If Mid(FullPath, i, 1) = "\" Then
            Result = Right(FullPath, Len(FullPath) - i)
            Exit Do
        End If
        i = i - 1
    Loop
    GetFilename = Result
    
End Function
Function SaveText(Filename As String, Text As String)

    Dim FileNumber As Integer
    
    If Dir(Filename) <> "" Then _
        Call Kill(Filename)
    If Len(Text) <> 0 Then
        FileNumber = FreeFile
        Open Filename For Output As FileNumber
            Print #FileNumber, Text
        Close FileNumber
    End If
    
End Function
Function LoadText(Filename As String) As String

    Dim Result As String
    Dim FileNumber As Integer
    Dim CurByte As Byte
    
    If Dir(Filename) <> "" Then
        FileNumber = FreeFile
        Open Filename For Binary Access Read As FileNumber
            Do
                Get FileNumber, , CurByte
                If _
                    Not EOF(FileNumber) And _
                    CurByte <> 0 _
                Then
                    Result = Result & Chr(CurByte)
                Else
                    Exit Do
                End If
            Loop
        Close FileNumber
    End If
    LoadText = Result
    
End Function
Function GetLocalPath(Filename As String) As String

    Dim Result As String
    
    Result = App.Path
    If Right(Result, 1) <> "\" Then _
        Result = Result & "\"
    Result = Result & Filename
    GetLocalPath = Result
    
End Function
Function GetLocalResPath(Filename As String) As String

    Dim Result As String
    
    Result = App.Path
    If Right(Result, 1) <> "\" Then _
        Result = Result & "\"
    Result = Result & "Res\" & Filename
    GetLocalPath = Result
    
End Function
