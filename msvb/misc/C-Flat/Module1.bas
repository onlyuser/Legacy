Attribute VB_Name = "Module1"
Option Explicit
Function _
    CountText( _
        Text As String, _
        SearchText As String _
    ) As Integer

    Dim i As Integer
    Dim Result As Integer
    Dim Length As Integer
    Dim LenSearch As Integer
    
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
Function _
    FindText( _
        Text As String, _
        SearchText As String, _
        Instance As Integer _
    ) As Integer

    Dim i As Integer
    Dim j As Integer
    Dim Result As Integer
    Dim Length As Integer
    Dim LenSearch As Integer
    
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
Function _
    EditReplacePtn( _
        Text As String, _
        Before As String, _
        After As String, _
        ReplaceText As String _
    ) As String

    Dim i As Integer
    Dim Result As String
    Dim Length As Integer
    Dim LenBefore As Integer
    Dim LenAfter As Integer
    Dim Ignoring As Boolean
    
    Length = Len(Text)
    LenBefore = Len(Before)
    LenAfter = Len(After)
    If LenBefore <> 0 Then
        i = 1
        Do While i <= Length
            If Mid(Text, i, LenBefore) = Before Then
                Ignoring = True
                i = i + LenBefore - 1
            Else
                If Not Ignoring Then
                    Result = Result & Mid(Text, i, 1)
                Else
                    If Mid(Text, i, LenAfter) = After Then
                        Result = Result & ReplaceText
                        Ignoring = False
                        i = i + LenAfter - 1
                    End If
                End If
            End If
            i = i + 1
        Loop
    End If
    EditReplacePtn = Result
    
End Function
Function EditDespace(Text As String) As String

    Dim Result As String
    
    Result = Text
    Result = EditReplace(Result, " ", "")
    Result = EditReplace(Result, vbTab, "")
    Result = EditReplace(Result, vbCrLf, "")
    EditDespace = Result
    
End Function
Function _
    EditReplace( _
        Text As String, _
        SearchText As String, _
        ReplaceText As String _
    ) As String

    Dim Result As String
    
    Result = EditReplacePtn(Text, SearchText, "", ReplaceText)
    EditReplace = Result
    
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
Function AutoComplete(ComboObj As ComboBox)

    Dim i As Integer
    Dim Length As Integer
    
    Length = Len(ComboObj.Text)
    If _
        Length - Len(ComboObj.Tag) = 1 And _
        ComboObj.SelStart = Length _
    Then
        If ComboObj.ListCount > 0 Then
            For i = 0 To ComboObj.ListCount - 1
                If Left(ComboObj.List(i), Length) = ComboObj.Text Then
                    ComboObj.ListIndex = i
                    ComboObj.SelStart = Length
                    ComboObj.SelLength = Len(ComboObj.Text) - Length
                    Exit For
                End If
            Next i
        End If
    End If
    ComboObj.Tag = Left(ComboObj.Text, ComboObj.SelStart)
    
End Function
Sub _
    LogText( _
        TextObj As TextBox, _
        Prompt As String, _
        Text As String _
    )

    TextObj.Text = _
        Left(Prompt & ">" & vbTab & Text & vbCrLf & TextObj.Text, 10000)
    TextObj.SelStart = 0
    
End Sub
Sub ShowAbout()

    Call _
        MsgBox( _
            App.Title & " v" & App.Major & "." & App.Minor & vbCrLf & _
            vbCrLf & _
            "by Jerry Chen", _
            vbInformation, _
            "About" _
        )
        
End Sub
Sub ShowHelp()

    Call _
        MsgBox( _
            "Binary Operators" & vbCrLf & _
            "Syntax: <param1><operator><param2>" & vbCrLf & _
            "! @ ^ * / % + - < > [ ] ? $ & | # ~ \ =" & vbCrLf & _
            vbCrLf & _
            "Extended Binary Operators" & vbCrLf & _
            "Syntax: <param1><operator><param2>" & vbCrLf & _
            "<= >= == != && || << >>" & vbCrLf & _
            "<> and xor or" & vbCrLf & _
            vbCrLf & _
            "Unary Operators" & vbCrLf & _
            "Syntax: <operator>(<param>)" & vbCrLf & _
            "sin cos tan csc sec cot asin acos atan" & vbCrLf & _
            "log ln abs sgn not inv int round rand" & vbCrLf & _
            "sqrt fact reset count" & vbCrLf & _
            vbCrLf & _
            "Special Operators" & vbCrLf & _
            "Syntax: <(><param><)>" & vbCrLf & _
            "( )", _
            vbInformation + vbOKOnly, _
            App.Title _
        )
        
End Sub
Function _
    Swap( _
        A As Variant, _
        B As Variant _
    )

    Dim C As Variant
    
    C = A
    A = B
    B = C
    
End Function
Function _
    ScanText( _
        Text As String, _
        Start As Integer, _
        StopSymbol As String _
    ) As String

    Dim i As Integer
    Dim Result As String
    Dim Length As Integer
    Dim LenStop As Integer
    
    Length = Len(Text)
    LenStop = Len(StopSymbol)
    For i = Start To Length
        If Mid(Text, i, LenStop) = StopSymbol Then
            Result = Mid(Text, Start, (i - 1) - (Start - 1))
            Start = i + LenStop
            Exit For
        End If
    Next i
    If Result = "" Then
        Result = Mid(Text, Start, Length - (Start - 1))
        Start = Length + 1
    End If
    ScanText = Result
    
End Function
