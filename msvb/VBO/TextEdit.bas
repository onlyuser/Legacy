Attribute VB_Name = "Module2"
Public Const CharPoolCmn$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
Public Const CharPoolExt$ = "~!@#$%^&*()_+|`1234567890-=\{}[]:;<>?,./ "
Function MidC$(Text$, Start%)

    'returns a cycling mid

    Dim A%
    Dim CharPos%
    Dim Step%
    
    A = 1
    CharPos = 1
    If Start <> 0 Then
        Step = Abs(Start) / Start
    Else
        Step = -1
    End If
    Do While A <> Start
        A = A + Step
        CharPos = CharPos + Step
        If CharPos > Len(Text) Then CharPos = 1
        If CharPos < 1 Then CharPos = Len(Text)
    Loop
    MidC = Mid(Text, CharPos, 1)
    
End Function
Function CleanText$(RawText$, FilterText$, LimitChar$)

    'Cleans unwanted characters from text

    Dim A%
    Dim Charpool$
    Dim CurChar$
    Dim LastChar$
    Dim TotChar$
    
    Charpool = CharPoolCmn & CharPoolExt
    For A = 1 To Len(RawText)
        CurChar = Mid(RawText, A, 1)
        If LocStr(Charpool, CurChar, 1) <> 0 And LocStr(FilterText, CurChar, 1) = 0 Then
            If Not (CurChar = LastChar And LocStr(LimitChar, LastChar, 1) <> 0) Then
                TotChar = TotChar & CurChar
            End If
            LastChar = CurChar
        End If
    Next A
    CleanText = TotChar

End Function
Function CryptText$(RawText$, KeyText$, Layers%)

    'encrypts/decrypts text

    Dim A%
    Dim B%
    Dim CurRawText$
    Dim CurCryptText$
    Dim Mode%
    Dim Charpool$
    Dim RawNum%
    Dim KeyNum%
    Dim CryptNum%
    
    Charpool = CharPoolCmn & CharPoolExt
    If Layers <> 0 Then
        Mode = Abs(Layers) / Layers
    Else
        Mode = 0
    End If
    CurCryptText = RawText
    For A = 1 To Abs(Layers)
        CurRawText = CurCryptText
        CurCryptText = ""
        If Mode = 1 Then
            For B = 1 To Len(CurRawText)
                RawNum = LocStr(Charpool, Mid(CurRawText, B, 1), 1)
                KeyNum = LocStr(Charpool, MidC(KeyText, B), 1)
                CryptNum = RawNum + KeyNum
                If RawNum <> 0 And KeyNum <> 0 Then
                    CurCryptText = CurCryptText & MidC(Charpool, CryptNum)
                Else
                    CurCryptText = CurCryptText & Mid(CurRawText, B, 1)
                End If
            Next B
        End If
        If Mode = 0 Then CurCryptText = CurRawText
        If Mode = -1 Then
            For B = 1 To Len(CurRawText)
                RawNum = LocStr(Charpool, Mid(CurRawText, B, 1), 1)
                KeyNum = LocStr(Charpool, MidC(KeyText, B), 1)
                CryptNum = RawNum - KeyNum
                If RawNum <> 0 And KeyNum <> 0 Then
                    CurCryptText = CurCryptText & MidC(Charpool, CryptNum)
                Else
                    CurCryptText = CurCryptText & Mid(CurRawText, B, 1)
                End If
            Next B
        End If
    Next A
    CryptText = CurCryptText

End Function
Function StrToBool(Text$) As Boolean
    
    'Returns boolean True if given string True
    
    If Text = "True" Then StrToBool = True
    
End Function
Function GetPart$(Text$, InsPoint%, StrBefore$, StrAfter$)

    'Gets the line where the insert point is in Text
    
    'Use chr(10) and chr(13) for lines
    
    Dim A%
    Dim BufferA$
    Dim MarkA%
    Dim MarkB%
    
    BufferA = StrBefore & Text & StrAfter
    For A = InsPoint To 1 Step -1
        If Mid(BufferA, A, 1) = StrBefore Then
            MarkA = A + 1
            Exit For
        End If
    Next A
    For A = InsPoint To Len(BufferA) Step 1
        If Mid(BufferA, A, 1) = StrAfter Then
            MarkB = A - 1
            Exit For
        End If
    Next A
    GetPart = Mid(BufferA, MarkA, MarkB - MarkA + 1)
    
End Function
Function GetIndex%(ComboObj As ComboBox, Text$)

    'Gets the index of a matching item in a combobox

    Dim A%
    
    If ComboObj.ListCount > 0 Then
        For A = 1 To ComboObj.ListCount - 1
            If ComboObj.List(A) = Text Then
                GetIndex = A
                Exit For
            End If
        Next A
        If GetIndex = 0 Then GetIndex = -1
    Else
        GetIndex = -1
    End If
    
End Function

Function RepStr$(Text$, OldStr$, NewStr$)

    'Replaces certain string in Text
    
    Dim A%
    Dim BufferA$
    
    For A = 1 To Len(Text)
        If Mid(Text, A, Len(OldStr)) = OldStr Then
             BufferA = BufferA + NewStr
            A = A + Len(OldStr) - 1
        Else
            BufferA = BufferA + Mid(Text, A, 1)
        End If
    Next A
    RepStr = BufferA

End Function

Function GetSeg$(Text$, SepStr$, SegNum%)
    
    'Gets segments divided by the same string in Text
    
    Dim A%
    Dim B%
    Dim MarkA%
    Dim BufferA$
    
    BufferA = SepStr + Text + SepStr
    For A = 1 To Len(BufferA)
        If Mid(BufferA, A, Len(SepStr)) = SepStr Then MarkA = MarkA + 1
        If MarkA = SegNum Then
            For B = 1 To Len(BufferA) - A
                If Mid(BufferA, A + B, Len(SepStr)) = SepStr Then
                    GetSeg = Mid(BufferA, A + Len(SepStr), B - Len(SepStr))
                    Exit Function
                End If
            Next B
        End If
    Next A
    
End Function
Function CntStr%(Text$, Str$)
    
    'Counts certain string in Text
    
    Dim A%
    Dim MarkA%
    
    For A = 1 To Len(Text)
        If Mid(Text, A, Len(Str)) = Str Then MarkA = MarkA + 1
    Next A
    CntStr = MarkA
    
End Function
Function Edit$(Action$, TextObj As Object)
    
    'Performs basic Edit Menu functions (submit action type as Action)
    
    Dim BufferA$
    
    BufferA = TextObj.SelStart
    If Action = "Cut" Then
        If TextObj.SelLength <> 0 Then Clipboard.SetText (Mid(TextObj.Text, TextObj.SelStart + 1, TextObj.SelLength))
        TextObj.Text = Mid(TextObj.Text, 1, TextObj.SelStart) _
        + Mid(TextObj.Text, TextObj.SelStart + TextObj.SelLength + 1, Len(TextObj.Text) - (TextObj.SelStart + TextObj.SelLength))
        TextObj.SelStart = BufferA
        TextObj.SelLength = 0
    End If
    If Action = "Copy" Then
        If TextObj.SelLength <> 0 Then Clipboard.SetText (Mid(TextObj.Text, TextObj.SelStart + 1, TextObj.SelLength))
    End If
    If Action = "Paste" Then
        TextObj.Text = Mid(TextObj.Text, 1, TextObj.SelStart) _
        + Clipboard.GetText _
        + Mid(TextObj.Text, TextObj.SelStart + TextObj.SelLength + 1, Len(TextObj.Text) - (TextObj.SelStart + TextObj.SelLength))
        TextObj.SelStart = BufferA + Len(Clipboard.GetText)
        TextObj.SelLength = 0
    End If
    If Action = "Delete" Then
        TextObj.Text = Mid(TextObj.Text, 1, TextObj.SelStart) _
        + Mid(TextObj.Text, TextObj.SelStart + TextObj.SelLength + 1, Len(TextObj.Text) - (TextObj.SelStart + TextObj.SelLength))
        TextObj.SelStart = BufferA
        TextObj.SelLength = 0
    End If
    If Action = "Select All" Then
        TextObj.SelStart = 0
        TextObj.SelLength = Len(TextObj.Text)
    End If
    TextObj.SetFocus
    
End Function
Function GetBtw$(Text$, StrBefore$, StrAfter$, BtwNum%)
    
    'Gets charactors between two known strings in Text
    
    Dim A%
    Dim B%
    Dim MarkA%
    
    If StrBefore = "" And StrAfter = "" Then
        GetBtw = Text
    ElseIf StrBefore = "" Then
        GetBtw = Mid(Text, 1, LocStr(Text, StrAfter, BtwNum) - 1)
    ElseIf StrAfter = "" Then
        GetBtw = Mid(Text, LocStr(Text, StrBefore, BtwNum) + Len(StrBefore), Len(Text) - LocStr(Text, StrBefore, BtwNum) + 1)
    Else
        For A = 1 To Len(Text)
            If Mid(Text, A, Len(StrBefore)) = StrBefore Then
                MarkA = MarkA + 1
                For B = 1 To Len(Text) - A
                    If Mid(Text, A + B, Len(StrAfter)) = StrAfter Then
                        If MarkA = BtwNum Then
                            GetBtw = Mid(Text, A + Len(StrBefore), B - Len(StrBefore))
                            Exit Function
                        End If
                    End If
                Next B
            End If
        Next A
    End If
    
End Function
Function LocStr%(Text$, Str$, StrNum%)
    
    'Locates certain string in Text
    
    Dim A%
    Dim MarkA%
    
    For A = 1 To Len(Text)
        If Mid(Text, A, Len(Str)) = Str Then
            MarkA = MarkA + 1
            If MarkA = StrNum Then
                LocStr = A
                Exit Function
            End If
        End If
    Next A
    
End Function
Function Access%(Action$, FileName$, Text$, Filter$, CmnDlgObj As Object)
    
    'Accesses Text files (prompt displayed when "Prompt" is submitted as FileName)
    
    Dim FilNum As Variant
    Dim SinChar$
    Dim AllData$
    
    Access = 0
    FilNum = FreeFile
    CmnDlgObj.CancelError = True
    CmnDlgObj.Filter = Filter
    If Action = "Open" Then
        If FileName = "Prompt" Then
            On Error Resume Next
                CmnDlgObj.Action = 1
            If Err = 0 Then
                Open CmnDlgObj.FileName For Input As FilNum
                    Do Until EOF(FilNum)
                        SinChar = Input(1, #FilNum)
                        AllData = AllData + SinChar
                    Loop
                    If Right(AllData, 2) = vbCrLf Then
                        AllData = Left(AllData, Len(AllData) - 2)
                    End If
                Close FilNum
            Else
                Access = -1
            End If
        End If
        If FileName <> "Prompt" Then
            Open FileName For Input As FilNum
                Do Until EOF(FilNum)
                    SinChar = Input(1, #FilNum)
                    AllData = AllData + SinChar
                Loop
                If Right(AllData, 2) = vbCrLf Then
                    AllData = Left(AllData, Len(AllData) - 2)
                End If
            Close FilNum
        End If
        Text = AllData
    End If
    If Action = "Save" Then
        If FileName = "Prompt" Then
            On Error Resume Next
                CmnDlgObj.Action = 2
            If Err = 0 Then
                Open CmnDlgObj.FileName For Output As FilNum
                    Print #FilNum, Text
                Close FilNum
            Else
                Access = -1
            End If
        End If
        If FileName <> "Prompt" Then
            Open FileName For Output As FilNum
                Print #FilNum, Text
            Close FilNum
        End If
    End If
    Err = 0
    
End Function
Function GetPath$(FullPath$, Part$)
    
    'Gets certain parts of a FullPath
    
    Dim A%
    
    If Part = "Drive" Then
        For A = 1 To Len(FullPath)
            If Mid(FullPath, A, 1) = "\" Then
                GetPath = Mid(FullPath, 1, A - 2)
                Exit Function
            End If
        Next A
    End If
    If Part = "Path" Then
        For A = 1 To Len(FullPath)
            If Mid(FullPath, A, 1) = "\" Then
                GetPath = Mid(FullPath, 1, A)
            End If
        Next A
    End If
    If Part = "File" Then
        For A = 1 To Len(FullPath)
            If Mid(FullPath, A, 1) = "\" Then
                GetPath = Mid(FullPath, A + 1, Len(FullPath) - A)
            End If
        Next A
    End If
    If Part = "Filename" Then
        For A = 1 To Len(FullPath)
            If Mid(FullPath, A, 1) = "\" Then
                GetPath = Mid(FullPath, A + 1, Len(FullPath) - A)
            End If
        Next A
        For A = 1 To Len(GetPath)
            If Mid(GetPath, A, 1) = "." Then GetPath = Mid(GetPath, 1, A - 1)
        Next A
    End If
    If Part = "Extension" Then
        For A = 1 To Len(FullPath)
            If Mid(FullPath, A, 1) = "\" Then
                GetPath = Mid(FullPath, A + 1, Len(FullPath) - A)
            End If
        Next A
        For A = 1 To Len(GetPath)
            If Mid(GetPath, A, 1) = "." Then GetPath = Mid(GetPath, A + 1, Len(GetPath) - A)
        Next A
    End If
    
End Function
Function ScrollTxt$(Text$, CharNum%)
    
    'Returns Text scRolled CharNum of characters (+ as right, - as left)
    
    Dim MarkA%
    
    If Text <> "" Then
        MarkA = Abs(CharNum) Mod Len(Text)
        If CharNum > 0 Then ScrollTxt = Mid(Text, Len(Text) - MarkA + 1, MarkA) + _
            Mid(Text, 1, Len(Text) - MarkA)
        If CharNum = 0 Then ScrollTxt = Text
        If CharNum < 0 Then ScrollTxt = Mid(Text, MarkA + 1, Len(Text) - MarkA) + _
            Mid(Text, 1, MarkA)
    End If
    
End Function
Function AppendText(TextboxObj As TextBox, Text$, LenLimit%)

    'Enters text to a textbox

    TextboxObj.Text = Right(TextboxObj.Text & vbCrLf & Text, LenLimit)
    TextboxObj.SelStart = Len(TextboxObj.Text)

End Function
Function GetIRCMsg$(Name$, Message$)

    'Makes a message in IRC format

    Dim BufferA$
    Dim BufferB$
    
    BufferA = GetSeg(Message, " ", 1)
    If BufferA = "/me" Then
        BufferB = "* " & RepStr(Message, "/me", Name)
    Else
        BufferB = "<" & Name & "> " & Message
    End If
    GetIRCMsg = Format$(Time, "hh:mm") & " " & BufferB

End Function
