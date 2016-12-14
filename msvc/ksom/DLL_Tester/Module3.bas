Attribute VB_Name = "Module3"
Option Explicit
Function DrawArray(Canvas As PictureBox, data() As Single, Color As Long, First As Long, Last As Long, pError As Single)

    Dim i As Long
    Dim NewX As Single
    Dim NewY As Single
    Dim index As Long
    Dim Offset As Long
    
    On Error Resume Next
    If Color <> vbBlack Then
        index = 1 / 1 'float inexact result work-around
        index = CLng(CSng(First + Last) / 2)
        NewX = index / UBound(data) * Canvas.ScaleWidth
        NewY = (1 - data(index)) * Canvas.ScaleHeight
        Offset = (Last - First) / 2 / UBound(data) * Canvas.ScaleWidth
        Canvas.FillColor = Color
        'Canvas.FillStyle = 0
        Canvas.Circle (NewX, NewY), Offset * (1 - pError), Color
        Canvas.Line (NewX - Offset, NewY)-(NewX + Offset, NewY), Color
    End If
    For i = 0 To UBound(data)
        If i >= First And i <= Last Then
            NewX = i / UBound(data) * Canvas.ScaleWidth
            NewY = (1 - data(i)) * Canvas.ScaleHeight
            If i = First Then
                Canvas.CurrentX = NewX
                Canvas.CurrentY = NewY
            End If
            Canvas.Line (Canvas.CurrentX, Canvas.CurrentY)-(NewX, NewY), Color
        End If
    Next i
    
End Function
Function ManipArray(Canvas As PictureBox, data() As Single, x As Single, Y As Single)

    Dim index As Long
    
    On Error Resume Next
    index = CInt(x / Canvas.ScaleWidth * UBound(data))
    data(index) = 1 - Y / Canvas.ScaleHeight
    
End Function
Function RunKohonen(Canvas As PictureBox, pData() As Single, Mode As Long)

    Dim i As Long
    Dim j As Long
    
    Dim pGroupCnt As Long
    Dim pLength As Long
    Dim pWindowSize As Long
    Dim pWindowStep As Long
    Dim pRowSize As Long
    Dim pColSize As Long
    Dim pTallySize As Long
    Dim pIters As Long
    
    Dim GroupCnt As Long
    Dim GroupSize As Long
    Dim Color As Long
    Dim StartIndex As Long
    Dim MaxError As Single
    Dim CurError As Single
    
    pLength = UBound(pData)
    Select Case Mode
        Case 0
            pGroupCnt = 6
            pWindowSize = 5
            pWindowStep = 1
            Call ksom_load(pGroupCnt, pData(0), pLength, pWindowSize, pWindowStep, 0, 1, False)
            pIters = 10
        Case 1
            pGroupCnt = 24
            pWindowSize = 2
            pRowSize = 5
            pColSize = pLength / pRowSize
            Call ksom_loadMatrix(pGroupCnt, pData(0), pRowSize, pColSize, pWindowSize)
            pIters = 1000
            pTallySize = 1
    End Select
    Call ksom_execBatch(pIters, 1, 0.5)
    Call ksom_simplify(0.25)
    MaxError = ksom_exec(False, False, True)
    Call MsgBox("max error = " & Sqr(MaxError))
    GroupCnt = ksom_getGroupCnt()
    Call MsgBox("group count = " & GroupCnt)
    For i = 1 To GroupCnt
        Select Case i
            Case 1: Color = vbRed
            Case 2: Color = vbYellow
            Case 3: Color = vbGreen
            Case 4: Color = vbCyan
            Case 5: Color = vbBlue
            Case 6: Color = vbMagenta
        End Select
        GroupSize = ksom_getGroupSize(i - 1)
        If Mode = 0 Then
            For j = 1 To GroupSize
                StartIndex = ksom_getGroupMember(i - 1, j - 1) * pWindowStep
                CurError = ksom_getGroupMemberError(i - 1, j - 1)
                If MaxError <> 0 Then _
                    Call DrawArray(Canvas, pData(), Color, StartIndex, StartIndex + pWindowSize - 1, Sqr(CurError / MaxError))
            Next j
        End If
        If GroupSize <> 0 Then _
            Call ksom_getGroupInfo(i - 1)
    Next i
    If Mode = 1 Then
        Call ksom_tallyMatrix(pTallySize)
        Call MsgBox("verify = " & ksom_verify(pWindowSize, pTallySize))
    End If
    Call ksom_unload
    
End Function
Function LoadExcelData(Filename As String) As Single()

    Dim i As Long
    Dim j As Long
    Dim Result() As Single
    Dim Text As String
    Dim pLenA As Long
    Dim pLenB As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim Row As Long
    Dim Col As Long
    
    ReDim Result(0)
    Text = LoadText(Filename)
    pLenA = Len(Text)
    i = 1
    Do While i <= pLenA
        TokenA = ScanText(Text, i, vbCrLf)
        Col = 0
        pLenB = Len(TokenA)
        j = 1
        Do While j <= pLenB
            TokenB = ScanText(TokenA, j, vbTab)
            If Row <> 0 And Col <> 0 Then
                Result(UBound(Result)) = Val(TokenB)
                ReDim Preserve Result(UBound(Result) + 1)
            End If
            Col = Col + 1
        Loop
        Row = Row + 1
        DoEvents
    Loop
    ReDim Preserve Result(UBound(Result) - 1)
    LoadExcelData = Result()
    
End Function
