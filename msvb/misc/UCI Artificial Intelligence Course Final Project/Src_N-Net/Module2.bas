Attribute VB_Name = "Module2"
Option Explicit

Type Node
    tOut As Single
    tErr As Single
    tValue As Single 'target value
    tIsBias As Boolean
    tIsInput As Boolean
    tIsOutput As Boolean
    tSrcA As Long 'first incoming weight
    tSrcB As Long 'last incoming weight
End Type

Type Weight
    tValue As Single
    tSrc As Long 'source node
End Type

Public mNode() As Node
Public mWeight() As Weight
Public mInputList As New Collection
Public mOutputList As New Collection
Function TestXor() As String

    Dim i As Long
    Dim j As Long
    Dim Result As String
    Dim Vector() As Single
    
    ReDim Vector(0 To 2)
    Call BuildNet(2, 2, 1)
    For i = 1 To 5000
        For j = 1 To 4
            Select Case j
                Case 1
                    Vector(0) = 0
                    Vector(1) = 0
                    Vector(2) = 0
                Case 2
                    Vector(0) = 0
                    Vector(1) = 1
                    Vector(2) = 1
                Case 3
                    Vector(0) = 1
                    Vector(1) = 0
                    Vector(2) = 1
                Case 4
                    Vector(0) = 1
                    Vector(1) = 1
                    Vector(2) = 0
            End Select
            Call SetVector(Vector)
            Call PropFwd
            Call PropBack
        Next j
    Next i
    For j = 1 To 4
        Select Case j
            Case 1
                Vector(0) = 0
                Vector(1) = 0
            Case 2
                Vector(0) = 0
                Vector(1) = 1
            Case 3
                Vector(0) = 1
                Vector(1) = 0
            Case 4
                Vector(0) = 1
                Vector(1) = 1
        End Select
        Vector(2) = 0
        Call SetVector(Vector)
        Call PropFwd
        Call GetVector(Vector)
        Result = Result & _
            Vector(0) & "," & Vector(1) & "," & Vector(2) & vbCrLf
    Next j
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - Len(vbCrLf))
    TestXor = Result
    
End Function
Function ResetNet()

    Call ListClear(mInputList)
    Call ListClear(mOutputList)
    ReDim mNode(0)
    ReDim mWeight(0)
    
End Function
Function BuildNet(InputCnt As Long, HiddenCnt As Long, OutputCnt As Long)

    Dim i As Long
    Dim j As Long
    Dim NewInputCnt As Long
    Dim NewHiddenCnt As Long
    Dim IndexA As Long
    Dim IndexB As Long
    
    Call Randomize
    Call ListClear(mInputList)
    Call ListClear(mOutputList)
    NewInputCnt = InputCnt + 1
    NewHiddenCnt = HiddenCnt + 1
    ReDim mNode(NewInputCnt + NewHiddenCnt + OutputCnt - 1)
    ReDim mWeight(NewInputCnt * HiddenCnt + NewHiddenCnt * OutputCnt - 1)
    mNode(NewInputCnt - 1).tIsBias = True
    mNode(NewInputCnt - 1).tOut = 1
    mNode(NewInputCnt + NewHiddenCnt - 1).tIsBias = True
    mNode(NewInputCnt + NewHiddenCnt - 1).tOut = 1
    For i = 1 To NewInputCnt
        mNode(IndexA).tIsInput = True
        If i <> NewInputCnt Then _
            Call mInputList.Add(IndexA) 'register inputs
        IndexA = IndexA + 1
    Next i
    For i = 1 To NewHiddenCnt
        If Not mNode(IndexA).tIsBias Then
            mNode(IndexA).tSrcA = IndexB
            mNode(IndexA).tSrcB = IndexB + NewInputCnt - 1
            For j = 1 To NewInputCnt
                mWeight(IndexB).tSrc = j - 1
                IndexB = IndexB + 1
            Next j
        End If
        IndexA = IndexA + 1
    Next i
    For i = 1 To OutputCnt
        mNode(IndexA).tIsOutput = True
        Call mOutputList.Add(IndexA) 'register outputs
        If Not mNode(IndexA).tIsBias Then
            mNode(IndexA).tSrcA = IndexB
            mNode(IndexA).tSrcB = IndexB + NewHiddenCnt - 1
            For j = 1 To NewHiddenCnt
                mWeight(IndexB).tSrc = NewInputCnt + j - 1
                IndexB = IndexB + 1
            Next j
        End If
        IndexA = IndexA + 1
    Next i
    For i = 0 To UBound(mWeight)
        mWeight(i).tValue = -1 + 2 * Rnd
    Next i
    
End Function
Function PropFwd() As Single

    Dim i As Long
    Dim j As Long
    Dim Result As Single
    Dim IndexA As Long
    Dim IndexB As Long
    
    For i = 0 To UBound(mNode)
        If _
            Not mNode(i).tIsBias And _
            Not mNode(i).tIsInput _
        Then
            mNode(i).tOut = 0
            For j = mNode(i).tSrcA To mNode(i).tSrcB
                IndexA = mWeight(j).tSrc
                IndexB = i
                mNode(IndexB).tOut = mNode(IndexB).tOut + _
                    mNode(IndexA).tOut * mWeight(j).tValue
            Next j
            mNode(i).tOut = Sigmoid(mNode(i).tOut)
        End If
    Next i
    For i = 1 To mOutputList.Count
        Result = Result + Abs(mNode(mOutputList.Item(i)).tValue - mNode(mOutputList.Item(i)).tOut)
    Next i
    PropFwd = Result
    
End Function
Function PropBack()

    Dim i As Long
    Dim j As Long
    Dim IndexA As Long
    Dim IndexB As Long
    
    For i = 0 To UBound(mNode)
        mNode(i).tErr = 0
    Next i
    For i = UBound(mNode) To 0 Step -1
        If _
            Not mNode(i).tIsBias And _
            Not mNode(i).tIsInput _
        Then
            If mNode(i).tIsOutput Then _
                mNode(i).tErr = mNode(i).tValue - mNode(i).tOut
            mNode(i).tErr = SigmoidPri(mNode(i).tOut) * mNode(i).tErr
            For j = mNode(i).tSrcA To mNode(i).tSrcB
                IndexA = mWeight(j).tSrc
                IndexB = i
                If _
                    mNode(IndexA).tIsBias Or _
                    mNode(IndexA).tIsInput _
                Then _
                    Exit For
                mNode(IndexA).tErr = mNode(IndexA).tErr + _
                    mWeight(j).tValue * mNode(IndexB).tErr
            Next j
        End If
    Next i
    For i = 0 To UBound(mNode)
        If _
            Not mNode(i).tIsBias And _
            Not mNode(i).tIsInput _
        Then
            For j = mNode(i).tSrcA To mNode(i).tSrcB
                IndexA = mWeight(j).tSrc
                IndexB = i
                mWeight(j).tValue = mWeight(j).tValue + _
                    mNode(IndexA).tOut * mNode(IndexB).tErr
            Next j
        End If
    Next i
    
End Function
Function LoadNet(Filename As String, Optional HeaderOnly As Boolean)

    Dim i As Long
    Dim j As Long
    Dim Buffer As String
    Dim InputCnt As Long
    Dim HiddenCnt As Long
    Dim OutputCnt As Long
    
    Buffer = LoadText(Filename)
    i = 1
    Call ScanText(Buffer, i, "INPUT=")
    InputCnt = ScanText(Buffer, i, vbCrLf)
    Call ScanText(Buffer, i, "HIDDEN=")
    HiddenCnt = ScanText(Buffer, i, vbCrLf)
    Call ScanText(Buffer, i, "OUTPUT=")
    OutputCnt = ScanText(Buffer, i, vbCrLf)
    Call BuildNet(InputCnt, HiddenCnt, OutputCnt)
    If Not HeaderOnly Then
        For j = 0 To UBound(mWeight)
            mWeight(j).tValue = ScanText(Buffer, i, ",")
        Next j
    End If
    
End Function
Function SaveNet(Filename As String)

    Dim i As Long
    Dim Buffer As String
    
    Buffer = Buffer & _
        "INPUT=" & mInputList.Count & vbCrLf & _
        "HIDDEN=" & CStr(UBound(mNode) + 1 - (mInputList.Count + mOutputList.Count) - 2) & vbCrLf & _
        "OUTPUT=" & mOutputList.Count & vbCrLf
    For i = 0 To UBound(mWeight)
        Buffer = Buffer & mWeight(i).tValue & ","
    Next i
    If Buffer <> "" Then _
        Buffer = Left(Buffer, Len(Buffer) - 1)
    Call SaveText(Filename, Buffer)
    
End Function
Function LoadTraining(Filename As String, IterCnt As Long, Canvas As PictureBox, Status As TextBox) As Single

    Dim i As Long
    Dim j As Long
    Dim Result As Single
    Dim Buffer As String
    Dim Length As Long
    Dim Token As String
    Dim Record As New Collection
    Dim Vector() As Single
    Dim AvgErr As Single
    Dim NewX As Long
    Dim NewY As Long
    Dim FirstErr As Single
    
    Call LoadNet(Filename, True)
    Buffer = LoadText(Filename)
    Length = Len(Buffer)
    i = 1
    Do While i <= Length
        Call ScanText(Buffer, i, ":")
        Token = ScanText(Buffer, i, vbCrLf)
        Call Record.Add(Token)
    Loop
    For j = 1 To IterCnt
        AvgErr = 0
        For i = 1 To Record.Count
            Vector = ExtractVector(Record.Item(i))
            Call SetVector(Vector)
            AvgErr = AvgErr + PropFwd
            Call PropBack
            DoEvents
        Next i
        Result = AvgErr / Record.Count
        
        '======================
        'CUSTOM GRAPH CODE HERE
        '======================
        If FirstErr = 0 Then _
            FirstErr = Result
        NewX = j / IterCnt * Canvas.ScaleWidth
        NewY = (1 - Result / FirstErr) * Canvas.ScaleHeight
        Canvas.Line (Canvas.CurrentX, Canvas.CurrentY)-(NewX, NewY)
        Status.Text = "Err = " & Format(Result / FirstErr, "0.00%")
        
        DoEvents
    Next j
    LoadTraining = Result
    
End Function
Function ExtractVector(Text As String) As Single()

    Dim i As Long
    Dim Result() As Single
    Dim Length As Long
    Dim Index As Long
    
    ReDim Result(0)
    Length = Len(Text)
    i = 1
    Do While i <= Length
        Result(Index) = ScanText(Text, i, ",")
        Index = Index + 1
        ReDim Preserve Result(Index)
    Loop
    If Index <> 0 Then _
        ReDim Preserve Result(Index - 1)
    ExtractVector = Result
    
End Function
Function SetVector(Vector() As Single)

    Dim i As Long
    Dim Index As Long
    
    For i = 1 To mInputList.Count
        mNode(mInputList.Item(i)).tOut = Vector(Index)
        Index = Index + 1
    Next i
    For i = 1 To mOutputList.Count
        mNode(mOutputList.Item(i)).tValue = Vector(Index)
        Index = Index + 1
    Next i
    
End Function
Function GetVector(Vector() As Single)

    Dim i As Long
    Dim Index As Long
    
    For i = 1 To mInputList.Count
        Index = Index + 1
    Next i
    For i = 1 To mOutputList.Count
        Vector(Index) = mNode(mOutputList.Item(i)).tOut
        Index = Index + 1
    Next i
    
End Function
Function Sigmoid(x As Single) As Single

    Dim Result As Single
    
    Result = 1 / (1 + Exp(-x))
    Sigmoid = Result
    
End Function
Function SigmoidPri(y As Single) As Single

    Dim Result As Single
    
    Result = y * (1 - y)
    SigmoidPri = Result
    
End Function
