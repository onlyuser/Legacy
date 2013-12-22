Attribute VB_Name = "Module1"
Const Pi! = 3.14159265358979

Public Type Node
    Situation As String
    Turn As Integer
    LastColumn As Integer
    LastRow As Integer
End Type

Public Type Tree
    Log As Node
    CurBranch As Integer
End Type

Public Type Stats
    Max As Long
    Min As Long
    Total As Long
    Number As Long
    Average As Long
    Eval As Long
End Type

Public RefBoard As Boolean
Public RefLog As Boolean
Public board%(1 To 64)
Public Map%(1 To 64)
Public PassedTurn As Boolean
Public Turn%
Public AssignVal%
Public Log(1 To 64) As Node

Public BoardShading As Boolean
Public ChipFading As Boolean
Public ChipShading As Boolean
Public GridMarks As Boolean
Public LastMove As Boolean
Public MapValues As Boolean
Public SearchSteps As Boolean

Public Depth%
Public Mode%

Public LastColumn%
Public LastRow%

Public Smooth As Boolean
Function IsOnEdge(Column%, Row%) As Boolean

    If _
        Column = 1 Or _
        Column = 8 Or _
        Row = 1 Or _
        Row = 8 _
            Then _
                IsOnEdge = True

End Function
Function IsInCorner(Column%, Row%) As Boolean

    If _
        (Column = 1 And Row = 1) Or _
        (Column = 1 And Row = 8) Or _
        (Column = 8 And Row = 1) Or _
        (Column = 8 And Row = 8) _
            Then _
                IsInCorner = True

End Function
Function LoadGame(FileName$, CmnDlgObj As CommonDialog)

    Dim A%
    Dim BufferA$
    Dim BufferB$
    Dim BufferC$
    
    If Access("Open", FileName, BufferA, "Board Files (*.Brd)|*.brd|Log Files (*.Log)|*.log|VBO Files (*.Brd;*.Log)|*.Brd;*.Log", CmnDlgObj) <> -1 Then
        If UCase(FileName) = "PROMPT" Then FileName = CmnDlgObj.FileName
        If UCase(GetPath(FileName, "Extension")) = "BRD" Then
            BufferB = GetBtw(BufferA, ">", ":", 1)
            BufferC = GetBtw(BufferA, "(", ")", 1)
            If BufferB = "BOARD" Then
                Call ClearLog
                Call SetBoard(BufferC)
                Call SetLog
            End If
        End If
        If UCase(GetPath(FileName, "Extension")) = "LOG" Then
            Call ClearLog
            For A = 1 To 64
                DoEvents
                BufferB = GetBtw(BufferA, ">", ":", 1)
                BufferC = GetBtw(BufferA, "(", ")", 1)
                If BufferB = "BOARD" Then
                    Call SetBoard(BufferC)
                    Call SetLog
                End If
                BufferA = Right(BufferA, Len(BufferA) - LocStr(BufferA, ">", 2) + 1)
            Next A
        End If
    End If

End Function
Function PosToNum%(Column%, Row%)

    PosToNum = (Row - 1) * 8 + Column

End Function
Function SaveGame(CmnDlgObj As CommonDialog)

    Dim A%
    Dim B%
    Dim BufferA$

    On Error Resume Next

    CmnDlgObj.CancelError = True
    CmnDlgObj.Filter = "Board Files (*.Brd)|*.brd|Log Files (*.Log)|*.log"
    CmnDlgObj.Action = 2
    If Err = 0 Then
        If UCase(GetPath(CmnDlgObj.FileName, "Extension")) = "BRD" Then
            BufferA = ">BOARD:(" & GetBoard & ")"
        End If
        If UCase(GetPath(CmnDlgObj.FileName, "Extension")) = "LOG" Then
            A = EnumChips(3)
            For B = 1 To 64
                If Log(B).Situation <> "" Then
                    Call GetLog(B)
                    BufferA = BufferA & ">BOARD:(" & GetBoard & ")" & vbCrLf
                End If
            Next B
            Call GetLog(A)
        End If
        Call Access("Save", CmnDlgObj.FileName, BufferA, CmnDlgObj.Filter, CmnDlgObj)
    End If

End Function
Function DrawAnalysis(Scr As PictureBox)

    Dim A%
    Dim UnitX%
    Dim UnitY%
    Dim NewX%
    Dim NewY%
    Dim BufferA$
    Dim BufferB%

    On Error Resume Next

    UnitX = Scr.ScaleWidth / 60
    UnitY = Scr.ScaleHeight / 64
    
    Scr.Cls
    
    NewX = UnitX * (EnumChips(3) - 4)
    Scr.CurrentX = NewX
    Scr.CurrentY = 0
    Scr.ForeColor = vbRed
    Scr.Print EnumChips(3)
    Scr.Line (NewX, 0)-(NewX, Scr.ScaleHeight), vbRed
    
    Scr.CurrentX = 0
    Scr.CurrentY = Scr.ScaleHeight
    For A = 4 To 64
        If Log(A).Turn = 1 Or Smooth = False Then
            NewX = UnitX * (CntStr(Log(A).Situation, "1") + CntStr(Log(A).Situation, "2") - 4)
            NewY = Scr.ScaleHeight - UnitY * CntStr(Log(A).Situation, "1")
            If NewY <> Scr.ScaleHeight Then Scr.Line (Scr.CurrentX, Scr.CurrentY)-(NewX, NewY), vbBlack
        End If
    Next A
    
    Scr.CurrentX = 0
    Scr.CurrentY = Scr.ScaleHeight
    For A = 4 To 64
        If Log(A).Turn = 2 Or Smooth = False Then
            NewX = UnitX * (CntStr(Log(A).Situation, "1") + CntStr(Log(A).Situation, "2") - 4)
            NewY = Scr.ScaleHeight - UnitY * CntStr(Log(A).Situation, "2")
            If NewY <> Scr.ScaleHeight Then Scr.Line (Scr.CurrentX, Scr.CurrentY)-(NewX, NewY), vbWhite
        End If
    Next A
    
    NewX = UnitX * (EnumChips(3) - 4)
    
    NewY = Scr.ScaleHeight - UnitY * EnumChips(1)
    Scr.CurrentX = 0
    Scr.CurrentY = NewY
    Scr.ForeColor = vbBlack
    Scr.Print EnumChips(1)
    Scr.DrawStyle = 2
    Scr.Line (0, NewY)-(Scr.ScaleWidth, NewY), vbBlack
    Scr.DrawStyle = 0
    
    Scr.FillColor = vbBlack
    Scr.FillStyle = 0
    Scr.Circle (NewX, NewY), UnitX / 2, vbBlack
    Scr.FillStyle = 1
    Scr.FillColor = vbBlack
    
    If Turn = 1 Then Scr.Circle (NewX, NewY), UnitX / 2, vbRed
    
    NewY = Scr.ScaleHeight - UnitY * EnumChips(2)
    Scr.CurrentX = 0
    Scr.CurrentY = NewY
    Scr.ForeColor = vbWhite
    Scr.Print EnumChips(2)
    Scr.DrawStyle = 2
    Scr.Line (0, NewY)-(Scr.ScaleWidth, NewY), vbWhite
    Scr.DrawStyle = 0
    
    Scr.FillColor = vbWhite
    Scr.FillStyle = 0
    Scr.Circle (NewX, NewY), UnitX / 2, vbWhite
    Scr.FillStyle = 1
    Scr.FillColor = vbBlack
    
    If Turn = 2 Then Scr.Circle (NewX, NewY), UnitX / 2, vbRed
    
End Function
Function EnumLog%()

    Dim A%
    Dim LogNum%
    
    For A = 1 To 64
        If Log(A).Situation <> "" Then LogNum = LogNum + 1
    Next A
    EnumLog = LogNum
    
End Function
Function GetValidPos%(RtnColumn%, RtnRow%, PosNum%)
        
    Dim A%
    Dim B%
    Dim MatchNum%
    
    For A = 1 To 8
        For B = 1 To 8
            If IsValidPos(B, A) = True Then
                MatchNum = MatchNum + 1
                If MatchNum = PosNum Then
                    RtnColumn = B
                    RtnRow = A
                    Exit Function
                End If
            End If
        Next B
    Next A

End Function
Function CutLog()

    Dim A%
    Dim Index%

    Index = EnumChips(3)
    If Index > 0 Then
        For A = Index To 64 'clears the log array from the cut index on
            Log(A).Situation = ""
            Log(A).Turn = 0
            Log(A).LastColumn = 0
            Log(A).LastRow = 0
        Next A
        Call SetLog 'saves the log for the cut index
    End If

End Function
Function ClearLog()

    Dim A%

    For A = 1 To 64
        Log(A).Situation = ""
        Log(A).Turn = 0
        Log(A).LastColumn = 0
        Log(A).LastRow = 0
    Next A
    LastColumn = 0
    LastRow = 0

End Function
Function GetBoard$()

    GetBoard = _
        GetPosArray(1) & ":" & _
        Turn & ":" & _
        Format$(PassedTurn) & ":" & _
        LastColumn & ":" & _
        LastRow

End Function
Function SetBoard(Text$)

    Dim BufferA$
    Dim BufferB$
    Dim BufferC$

    BufferA = GetSeg(Text, ":", 1)
    BufferB = GetSeg(Text, ":", 2)
    BufferC = GetSeg(Text, ":", 3)
    LastColumn = Val(GetSeg(Text, ":", 4))
    LastRow = Val(GetSeg(Text, ":", 5))
    Call SetPosArray(1, BufferA)
    Turn = Val(BufferB)
    PassedTurn = StrToBool(BufferC)
    RefBoard = True
    
End Function
Function SetLog()

    Dim A%
    Dim Index%
    
    Index = EnumChips(3)
    Log(Index).Situation = ""
    For A = 1 To 64
        Log(Index).Situation = Log(Index).Situation & board(A)
    Next A
    Log(Index).Turn = Turn
    Log(Index).LastColumn = LastColumn
    Log(Index).LastRow = LastRow

End Function
Function GetLog(Index%)

    Dim A%
    
    For A = 1 To 64
        board(A) = Val(Mid(Log(Index).Situation, A, 1))
    Next A
    Turn = Log(Index).Turn
    LastColumn = Log(Index).LastColumn
    LastRow = Log(Index).LastRow
    PassedTurn = False

End Function
Function SetPosArray(ArrayNum%, Data$)

    Dim A%

    If ArrayNum = 1 Then
        For A = 1 To 64
            board(A) = Val(Mid(Data, A, 1))
        Next A
    End If
    If ArrayNum = 2 Then
        For A = 1 To 64
            Map(A) = Val(Mid(Data, A, 1))
        Next A
    End If

End Function
Function GetPosArray$(ArrayNum%)

    Dim A%

    If ArrayNum = 1 Then
        For A = 1 To 64
            GetPosArray = GetPosArray & Format$(board(A))
        Next A
    End If
    If ArrayNum = 2 Then
        For A = 1 To 64
            GetPosArray = GetPosArray & Format$(Map(A))
        Next A
    End If
    
End Function
Function SumPosEval%()

    Dim A%
    Dim B%
    Dim Sum%

    For A = 1 To 8
        For B = 1 To 8
            Sum = Sum + GetPosEval(B, A)
        Next B
    Next A
    
    SumPosEval = Sum

End Function
Function TreeSearch(RtnColumn%, RtnRow%, FormObj As Form, TextObj As TextBox)

    Dim A%
    Dim BufferA%
    Dim BufferB$
    Dim Begin!
    Dim Finish!
    Dim CurLayer%
    Dim FTree(1 To 60) As Tree
    Dim IniStats(1 To 60) As Stats
    Dim TotSeq&
    Dim TempColumn%
    Dim TempRow%
    Dim CurVal%
    Dim BestVal%
    Dim WorstVal%
    Dim CurIniPos%
    Dim TotIniPos%
    Dim Prune As Boolean
    Dim TotPruneNum%
    
    If Depth > 0 Then 'NOTE >> minimal search depth must be greater than 0
    
        Begin = Timer 'begin timing
        
        TotIniPos = EnumValidPos
        
        FormObj.Caption = "Search Report: 0% completed"
        If TextObj.Parent.Visible = True Then TextObj.Text = ">1:(" & SumPosEval & ")"
        
        Do
        
            CurLayer = CurLayer + 1 'go to next layer
            FTree(CurLayer).CurBranch = 1 'use first branch in new layer
                        
            If CurLayer > Depth Or Prune = True Then 'if current layer is beyond last layer or current branch is pruned
            
                TotSeq = TotSeq + 1 'increment sequence count
                
                Prune = False
                
                Do
                
                    CurLayer = CurLayer - 1 'return to previous layer
                    
                    If CurLayer > 0 Then 'if still more layers
                        If CurLayer = 1 Then
                            CurIniPos = CurIniPos + 1
                            If TotIniPos <> 0 Then FormObj.Caption = "Search Report: " & Format$(Int(CurIniPos / TotIniPos * 100)) & "% completed"
                        End If
                        For A = 1 To 64 'read branch node log from buffer
                            board(A) = Val(Mid(FTree(CurLayer).Log.Situation, A, 1))
                        Next A
                        Turn = FTree(CurLayer).Log.Turn
                        If SearchSteps = True Then 'redraw board
                            Form1.Picture1.Cls
                            Call RefreshBoard(Form1.Picture1, False)
                            DoEvents
                        End If
                    Else 'if no more layers
                        GoTo Decide: 'end search
                    End If
                    
                Loop Until FTree(CurLayer).CurBranch < EnumValidPos 'back trace layers to a node with unsearched branches
                
                FTree(CurLayer).CurBranch = FTree(CurLayer).CurBranch + 1 'go to next branch
                
            End If

            FTree(CurLayer).Log.Situation = "" 'save branch's node log to buffer
            For A = 1 To 64
                FTree(CurLayer).Log.Situation = FTree(CurLayer).Log.Situation + Format$(board(A))
            Next A
            FTree(CurLayer).Log.Turn = Turn
            
            If EnumValidPos > 0 Then 'make move
                Call GetValidPos(TempColumn, TempRow, FTree(CurLayer).CurBranch)
                Call MakeMove(TempColumn, TempRow)
            End If
            
            If SearchSteps = True Then 'redraw board
                Form1.Picture1.Cls
                Call RefreshBoard(Form1.Picture1, False)
                DoEvents
            End If
            
            If Turn = FTree(1).Log.Turn Then 'update current evaluation
                BufferA = SumPosEval
            Else
                BufferA = -SumPosEval
            End If
            If CurLayer = 1 Then 'update stats
                IniStats(FTree(1).CurBranch).Max = BufferA
                IniStats(FTree(1).CurBranch).Min = BufferA
            Else
                If BufferA > IniStats(FTree(1).CurBranch).Max Then IniStats(FTree(1).CurBranch).Max = BufferA
                If BufferA < IniStats(FTree(1).CurBranch).Min Then IniStats(FTree(1).CurBranch).Min = BufferA
            End If
            
            IniStats(FTree(1).CurBranch).Total = IniStats(FTree(1).CurBranch).Total + BufferA
            IniStats(FTree(1).CurBranch).Number = IniStats(FTree(1).CurBranch).Number + 1
            IniStats(FTree(1).CurBranch).Average = IniStats(FTree(1).CurBranch).Total / IniStats(FTree(1).CurBranch).Number
            
            If TextObj.Parent.Visible = True Then 'print search data
                If CurLayer = 1 Then
                    TextObj.Text = TextObj.Text & vbCrLf & _
                        "#" & FTree(CurLayer).CurBranch & ":" & _
                        String(CurLayer, vbTab) & _
                        ">" & FTree(CurLayer).CurBranch & ":(" & BufferA & ")"
                Else
                    TextObj.Text = TextObj.Text & vbCrLf & _
                        String(CurLayer, vbTab) & _
                        ">" & FTree(CurLayer).CurBranch & ":(" & BufferA & ")"
                End If
                TextObj.SelStart = Len(TextObj.Text)
            End If
            
            If IniStats(FTree(1).CurBranch).Number <> 0 Then 'if not new stem
                If 1 = 2 Then
                    Prune = True
                    TotPruneNum = TotPruneNum + 1
                End If
            End If
            
        Loop
        
Decide:

        Finish = Timer 'finish timing
        
        For A = 1 To EnumValidPos 'get best score
            If Mode = 1 Then IniStats(A).Eval = IniStats(A).Min
            If Mode = 2 Then IniStats(A).Eval = IniStats(A).Average
            If Mode = 3 Then IniStats(A).Eval = IniStats(A).Max
            If A = 1 Then
                BestVal = IniStats(A).Eval
                WorstVal = IniStats(A).Eval
            Else
                CurVal = IniStats(A).Eval
                If CurVal > BestVal Then BestVal = CurVal
                If CurVal < WorstVal Then WorstVal = CurVal
            End If
        Next A
        
        If TextObj.Parent.Visible = True Then 'print search results
            TextObj.Text = TextObj.Text & vbCrLf
            TextObj.Text = TextObj.Text & vbCrLf & _
                "Depth: " & Depth & vbCrLf & _
                "Mode: " & Mode & vbCrLf & _
                "Stems grown: " & Format$(TotSeq) & vbCrLf & _
                "Stems pruned: " & TotPruneNum & vbCrLf & _
                "Time elapsed: " & Format$(Finish - Begin, "0.00") & " seconds" & vbCrLf & _
                "Best result: " & BestVal & vbCrLf & _
                "Worst result: " & WorstVal
            TextObj.SelStart = Len(TextObj.Text)
        End If
        
        For A = 1 To EnumValidPos 'get move with top score
            CurVal = IniStats(A).Eval
            If CurVal = BestVal Then
                Call GetValidPos(TempColumn, TempRow, A)
                RtnColumn = TempColumn
                RtnRow = TempRow
                If TextObj.Parent.Visible = True Then
                    BufferA = LocStr(TextObj.Text, ":" & String(1, vbTab) & ">", A)
                    BufferB = GetPart(TextObj.Text, BufferA, Chr(10), Chr(13))
                    TextObj.Text = RepStr(TextObj.Text, BufferB, BufferB & " @")
                    TextObj.Text = TextObj.Text & vbCrLf
                    TextObj.Text = TextObj.Text & vbCrLf & _
                        "Selected move: #" & Format$(A) & _
                        " - " & Mid(ColumnMarks, RtnColumn, 1) & Mid(RowMarks, RtnRow, 1)
                    TextObj.SelStart = Len(TextObj.Text)
                End If
                Exit Function
            End If
        Next A
        
    End If

End Function
Function GetPosEval%(Column%, Row%)

    Dim BufferA%

    BufferA = EnumPosElim(Column, Row, False)
    If GetPosState(1, Column, Row) = 0 Then
        If BufferA > 0 Then
            BufferA = BufferA + GetPosState(2, Column, Row)
        End If
    End If
    GetPosEval = BufferA

End Function
Function CheckPass()

    Dim Black%
    Dim White%

    Black = EnumChips(1)
    White = EnumChips(2)

    If ExistValidPos = False Then
        If PassedTurn = False And EnumChips(3) < 64 Then
            Call MsgBox("No move possible! Passing turn!", 64, "State")
            Turn = InvertTurn(Turn)
            PassedTurn = True
        End If
        Call CheckGame
        RefBoard = True
        RefLog = True
    End If

End Function
Function CheckGame()

    Dim Black%
    Dim White%

    Black = EnumChips(1)
    White = EnumChips(2)

    If ExistValidPos = False Then
        If PassedTurn = True Or EnumChips(3) = 64 Then
            If Black > White Then _
                Call MsgBox("Black wins by " & Format$(Black - White) & "!", 64, "State")
            If White > Black Then _
                Call MsgBox("White wins by " & Format$(White - Black) & "!", 64, "State")
            If Black = White Then _
                Call MsgBox("Tie game!", 64, "State")
            Turn = 3
        End If
        RefBoard = True
    End If

End Function
Function DrawChip(Scr As PictureBox, Column%, Row%, State%, Tag$, TagColor&, GridColor&, FlagColor&, ChipColor&)

    Dim UnitLen!
    Dim ChipRadius!
    Dim DrawMode%
    Dim DrawStyle%
    Dim FillColor&
    Dim FillStyle%
    Dim ForeColor&
    Dim FrameStyle%
    
    UnitLen = Scr.ScaleWidth / 8
    ChipRadius = UnitLen / 3
    If State = 0 Then
        DrawMode = 11
        DrawStyle = 0
        FillColor = vbBlack
        FillStyle = 0
        ForeColor = vbBlack
        FrameStyle = 3
    ElseIf State = 1 Then
        DrawMode = 13
        DrawStyle = 0
        FillColor = vbBlack
        FillStyle = 0
        ForeColor = vbBlack
        FrameStyle = 1
    ElseIf State = 2 Then
        DrawMode = 13
        DrawStyle = 0
        FillColor = vbWhite
        FillStyle = 0
        ForeColor = vbBlack
        FrameStyle = 1
    ElseIf State = 3 Then
        DrawMode = 13
        DrawStyle = 2
        FillColor = vbBlack
        FillStyle = 1
        ForeColor = vbBlack
        FrameStyle = 2
    End If
    If ChipColor <> -1 Then FillColor = ChipColor
    If GridColor <> -1 Then
        Scr.Line _
            (Column * UnitLen - UnitLen, Row * UnitLen - UnitLen)- _
            (Column * UnitLen, Row * UnitLen), _
            GridColor, _
            BF
    End If
    If BoardShading = True Then
        Call _
            DrawFrame( _
                Scr.hDC, _
                Column * UnitLen - UnitLen, _
                Row * UnitLen - UnitLen, _
                UnitLen, _
                UnitLen, _
                FrameStyle, _
                0 _
            )
    End If
    Scr.DrawMode = DrawMode
    Scr.DrawStyle = DrawStyle
    Scr.FillColor = FillColor
    Scr.FillStyle = FillStyle
    Scr.ForeColor = ForeColor
    Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius
    Scr.DrawMode = 13
    Scr.DrawStyle = 0
    Scr.FillColor = vbBlack
    Scr.FillStyle = 1
    Scr.ForeColor = vbBlack
    If ChipShading = True Then
        If State = 1 Or State = 2 Then
            Scr.DrawWidth = 2
            Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius, RGB(150, 150, 150), 0 * Pi, 0.25 * Pi
            Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius, RGB(175, 175, 175), 0.25 * Pi, 0.5 * Pi
            Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius, RGB(200, 200, 200), 0.5 * Pi, 0.75 * Pi
            Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius, RGB(175, 175, 175), 0.75 * Pi, 1 * Pi
            Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius, RGB(150, 150, 150), 1 * Pi, 1.25 * Pi
            Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius, RGB(125, 125, 125), 1.25 * Pi, 1.5 * Pi
            Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius, RGB(100, 100, 100), 1.5 * Pi, 1.75 * Pi
            Scr.Circle (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2), ChipRadius, RGB(125, 125, 125), 1.75 * Pi, 2 * Pi
            Scr.DrawWidth = 1
        End If
    End If
    If FlagColor <> -1 Then
        Scr.ForeColor = vbRed
        Scr.Line _
            (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2)- _
            (Column * UnitLen - UnitLen / 2 + UnitLen / 6, Row * UnitLen - UnitLen / 2)
        Scr.Line _
            (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2)- _
            (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2 + UnitLen / 6)
        Scr.Line _
            (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2)- _
            (Column * UnitLen - UnitLen / 2 - UnitLen / 6, Row * UnitLen - UnitLen / 2)
        Scr.Line _
            (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2)- _
            (Column * UnitLen - UnitLen / 2, Row * UnitLen - UnitLen / 2 - UnitLen / 6)
        Scr.ForeColor = vbBlack
    End If
    If TagColor <> -1 Then
        Scr.ForeColor = TagColor
        Scr.Print Tag
        Scr.ForeColor = vbBlack
    End If
    
End Function
Function ExistValidPos() As Boolean

    Dim A%
    Dim B%

    For A = 1 To 8
        For B = 1 To 8
            If IsValidPos(B, A) = True Then ExistValidPos = True
        Next B
    Next A

End Function
Function EnumValidPos%()

    Dim A%
    Dim B%
    Dim ValidPosNum%
    
    For A = 1 To 8
        For B = 1 To 8
            If IsValidPos(B, A) = True Then ValidPosNum = ValidPosNum + 1
        Next B
    Next A
    EnumValidPos = ValidPosNum

End Function
Function GetBestPos%(RtnColumn%, RtnRow%)

    Dim A%
    Dim B%
    Dim CurVal
    Dim BestVal
    
    For A = 1 To 8
        For B = 1 To 8
            If IsValidPos(B, A) = True Then
                CurVal = GetPosEval(B, A)
                If CurVal > BestVal Then BestVal = CurVal
            End If
        Next B
    Next A
    For A = 1 To 8
        For B = 1 To 8
            If IsValidPos(B, A) = True Then
                CurVal = GetPosEval(B, A)
                If CurVal = BestVal Then
                    RtnColumn = B
                    RtnRow = A
                    Exit Function
                End If
            End If
        Next B
    Next A
    
End Function
Function IsValidPos(Column%, Row%) As Boolean

    If IsOnBoard(Column, Row) = True Then
        If GetPosState(1, Column, Row) = 0 Then
            If EnumPosElim(Column, Row, False) > 0 Then IsValidPos = True
        End If
    End If
    
End Function
Function SnapPos%(Scr As PictureBox, Pos!)

    Dim UnitLen!
    
    UnitLen = Scr.ScaleWidth / 8
    SnapPos = 1 + Int(Pos / UnitLen)

End Function
Function MakeMove(Column%, Row%)
    
    If IsValidPos(Column, Row) = True Then
        Call EnumPosElim(Column, Row, True)
        Call SetPosState(1, Column, Row, Turn)
        Turn = InvertTurn(Turn)
        LastColumn = Column
        LastRow = Row
        PassedTurn = False
        RefBoard = True
        RefLog = True
    Else
        Beep
        Call CheckPass
    End If

End Function
Function EnumChips%(State%)

    Dim A%
    Dim ChipNum%
    
    If State = 3 Then
        For A = 1 To 64
            If board(A) <> 0 Then ChipNum = ChipNum + 1
        Next A
    Else
        For A = 1 To 64
            If board(A) = State Then ChipNum = ChipNum + 1
        Next A
    End If
    EnumChips = ChipNum

End Function
Function InvertTurn%(Turn%)
    
    If Turn = 1 Then
        InvertTurn = 2
    Else
        InvertTurn = 1
    End If
    
End Function

Function IsOnBoard(Column%, Row%) As Boolean

    If _
        Column >= 1 And _
        Column <= 8 And _
        Row >= 1 And _
        Row <= 8 _
            Then _
                IsOnBoard = True

End Function
Function NewBoard()
    
    Dim A%
    Dim B%
    
    For A = 1 To 8
        For B = 1 To 8
            Call SetPosState(1, B, A, 0)
        Next B
    Next A
    Randomize
    Turn = 1
    Call SetPosState(1, 5, 4, Turn)
    Turn = InvertTurn(Turn)
    Call SetPosState(1, 5, 5, Turn)
    Turn = InvertTurn(Turn)
    Call SetPosState(1, 4, 5, Turn)
    Turn = InvertTurn(Turn)
    Call SetPosState(1, 4, 4, Turn)
    Turn = InvertTurn(Turn)
    PassedTurn = False
    AssignVal = -1
    Call ClearLog
    Call SetLog
    RefBoard = True
    
End Function
Function SetPosState(ArrayNum%, Column%, Row%, State%)

    If ArrayNum = 1 Then
        board(PosToNum(Column, Row)) = State
    End If
    If ArrayNum = 2 Then
        Map(PosToNum(Column, Row)) = State
    End If

End Function
Function GetPosState%(ArrayNum%, Column%, Row%)

    If ArrayNum = 1 Then
        GetPosState = board(PosToNum(Column, Row))
    End If
    If ArrayNum = 2 Then
        GetPosState = Map(PosToNum(Column, Row))
    End If
    
End Function
Function RefreshBoard(Scr As PictureBox, Effects As Boolean)

    Dim A%
    Dim B%
    Dim UnitLen!
    Dim CurPos!
    Dim MapVal$
    Dim GridColor&
    Dim FlagColor&
    Dim ColorOld%
    Dim ColorNew%
    Dim Begin!
    Dim Now!
    Const FadeTime! = 0.5
    Dim InsPos!
    
    UnitLen = Scr.ScaleWidth / 8
    For A = 1 To 8
        For B = 1 To 8
            If GetPosState(1, B, A) = 0 Then
                GridColor = -1
                FlagColor = -1
            Else
                If GridMarks = True Then
                    If EnumPosElim(B, A, False) > 0 Then
                        If Abs(EnumPosElim(B, A, False)) = GetPosState(2, B, A) Then
                            GridColor = vbCyan
                        Else
                            GridColor = vbGreen
                        End If
                    Else
                        If Abs(EnumPosElim(B, A, False)) = GetPosState(2, B, A) Then
                            GridColor = vbMagenta
                        Else
                            GridColor = vbRed
                        End If
                    End If
                Else
                    GridColor = -1
                End If
                If LastMove = True Then
                    If B = LastColumn And A = LastRow Then
                        FlagColor = vbRed
                    Else
                        FlagColor = -1
                    End If
                Else
                    FlagColor = -1
                End If
            End If
            If MapValues = True Then MapVal = Format$(GetPosState(2, B, A))
            If IsValidPos(B, A) = True Then
                Call DrawChip(Scr, B, A, 3, MapVal, vbGreen, GridColor, FlagColor, -1)
            Else
                If GetPosState(1, B, A) <> 0 Then
                    Call DrawChip(Scr, B, A, GetPosState(1, B, A), MapVal, vbRed, GridColor, FlagColor, -1)
                Else
                    Call DrawChip(Scr, B, A, GetPosState(1, B, A), MapVal, vbBlack, GridColor, FlagColor, -1)
                End If
            End If
        Next B
    Next A
    If BoardShading = False Then
        For A = 1 To 8
            CurPos = A * UnitLen
            Scr.Line (CurPos, 0)-(CurPos, Scr.ScaleHeight)
            Scr.Line (0, CurPos)-(Scr.ScaleWidth, CurPos)
        Next A
    End If
    Scr.ForeColor = vbCyan
    For A = 1 To 8
        Scr.CurrentX = UnitLen / 2 + (A - 1) * UnitLen + 60
        Scr.CurrentY = (1 - 1) * UnitLen + 60
        Scr.Print Mid(ColumnMarks, A, 1)
    Next A
    For A = 1 To 8
        Scr.CurrentX = (1 - 1) * UnitLen + 60
        Scr.CurrentY = UnitLen / 2 + (A - 1) * UnitLen + 60
        Scr.Print Mid(RowMarks, A, 1)
    Next A
    Scr.ForeColor = vbBlack
    If ChipFading = True Then
        If Effects = True Then
            Begin = Timer
            Do
                Now = Timer
                InsPos = (Now - Begin) / FadeTime
                If InsPos > 1 Then Exit Do
                For A = 1 To 8
                    For B = 1 To 8
                        If EnumChips(3) > 1 Then
                            ColorOld = Val(Mid(Log(EnumChips(3) - 1).Situation, PosToNum(B, A), 1))
                            ColorNew = board(PosToNum(B, A))
                            If ColorOld <> ColorNew Then
                                If ColorOld = 0 Then
                                    If ColorNew = 1 Then Call DrawChip(Scr, B, A, 1, 0, -1, -1, -1, GetColorLong(GetColorInterp(Hex(Scr.Point(1, 1)), Hex(vbBlack), InsPos)))
                                    If ColorNew = 2 Then Call DrawChip(Scr, B, A, 2, 0, -1, -1, -1, GetColorLong(GetColorInterp(Hex(Scr.Point(1, 1)), Hex(vbWhite), InsPos)))
                                Else
                                    If ColorNew = 1 Then Call DrawChip(Scr, B, A, 1, 0, -1, -1, -1, GetColorLong(GetColorInterp(Hex(vbWhite), Hex(vbBlack), InsPos)))
                                    If ColorNew = 2 Then Call DrawChip(Scr, B, A, 2, 0, -1, -1, -1, GetColorLong(GetColorInterp(Hex(vbBlack), Hex(vbWhite), InsPos)))
                                End If
                            End If
                        End If
                    Next B
                Next A
                DoEvents
            Loop
            Call RefreshBoard(Scr, False)
        End If
    End If
    
End Function
Function ShowInfo(Scr As Form)

    Dim BufferA$
    Dim BufferB$
    
    If Turn = 1 Then BufferA = "Black"
    If Turn = 2 Then BufferA = "White"
    If Turn = 3 Then BufferA = "Game"
    If PassedTurn = True Then BufferB = "; [Passed]"
    Scr.Caption = _
        "VBO; " & _
        "Black: " & EnumChips(1) & ", " & _
        "White: " & EnumChips(2) & "; " & _
        "Turn: " & BufferA & _
        BufferB

End Function
Function EnumPosElim%(Column%, Row%, SetElim As Boolean)

    Dim A%
    Dim State%
    Dim OwnTurn%
    Dim ScanTurn%
    Dim ScanColumn%
    Dim ScanRow%
    Dim ScanDir%
    Dim ColumnIncre%
    Dim RowIncre%
    Dim ElimNum%
    
    State = GetPosState(1, Column, Row)
    If State = 0 Then
        OwnTurn = Turn 'swap own color
    Else
        OwnTurn = State 'swap turn of chip occupying position
    End If
    For A = 1 To 8
        ScanDir = 1 'initialize scan direction
        ScanColumn = Column 'initialize scan position
        ScanRow = Row
        If A = 1 Then 'sequentially set scan directions
            ColumnIncre = 1
            RowIncre = 1
        End If
        If A = 2 Then
            ColumnIncre = 1
            RowIncre = 0
        End If
        If A = 3 Then
            ColumnIncre = 1
            RowIncre = -1
        End If
        If A = 4 Then
            ColumnIncre = 0
            RowIncre = -1
        End If
        If A = 5 Then
            ColumnIncre = -1
            RowIncre = -1
        End If
        If A = 6 Then
            ColumnIncre = -1
            RowIncre = 0
        End If
        If A = 7 Then
            ColumnIncre = -1
            RowIncre = 1
        End If
        If A = 8 Then
            ColumnIncre = 0
            RowIncre = 1
        End If
        If State = 0 Then 'if position is vacant
            Do 'enter loop
                ScanColumn = ScanColumn + ScanDir * ColumnIncre 'scan deeper
                ScanRow = ScanRow + ScanDir * RowIncre
                If IsOnBoard(ScanColumn, ScanRow) = True Then 'if new position is still on board
                    ScanTurn = GetPosState(1, ScanColumn, ScanRow) 'swap color in new position
                    If ScanDir = 1 Then 'if scanning forward
                        If ScanTurn = 0 Then Exit Do 'exit loop if found vacant position
                        If ScanTurn = OwnTurn Then ScanDir = -1 'invert scan direction
                    Else 'if scanning backward
                        If (ScanColumn = Column And ScanRow = Row) Then Exit Do 'exit loop if not at starting point
                        If ScanTurn = InvertTurn(OwnTurn) Then 'if found opponent chip
                            ElimNum = ElimNum + GetPosState(2, ScanColumn, ScanRow) 'add position map value to elim-count
                            If SetElim = True Then Call SetPosState(1, ScanColumn, ScanRow, OwnTurn) 'flip chip
                        End If
                    End If
                Else 'if scan exits board
                    Exit Do 'exit loop
                End If
            Loop
        Else 'if position is occupied
            Do 'enter loop
                ScanColumn = ScanColumn + ScanDir * ColumnIncre 'scan deeper
                ScanRow = ScanRow + ScanDir * RowIncre
                If IsOnBoard(ScanColumn, ScanRow) = True Then 'if new position is still on board
                    ScanTurn = GetPosState(1, ScanColumn, ScanRow) 'swap color in new position
                    If ScanDir = 1 Then 'if scanning forward
                        If ScanTurn = 0 Then Exit Do 'exit loop if found vacant position
                        If ScanTurn = InvertTurn(OwnTurn) Then 'if found opponent chip
                            ScanDir = -1 'invert scan direction
                            ElimNum = 0 'set position map value to 0
                        End If
                    Else 'if scanning backward
                        If ScanTurn = 0 Then
                            If _
                                ( _
                                    Turn = InvertTurn(OwnTurn) And _
                                    IsValidPos(ScanColumn, ScanRow) = True _
                                ) Or _
                                IsOnEdge(Column, Row) = False _
                                    Then 'if found valid vacant position or not initially on edge
                                        ElimNum = GetPosState(2, Column, Row) 'set position map value to elim-num
                            Else 'if found vacant position and initially on edge
                                ElimNum = 0 'set position map value to 0
                            End If
                            Exit For 'exit loop
                        End If
                        If ScanTurn = InvertTurn(OwnTurn) Then 'if found opponent chip
                            ElimNum = 0 'reset elim-count
                            Exit Do 'exit loop
                        End If
                    End If
                Else 'if scan exits board
                    Exit Do 'exit loop
                End If
            Loop
        End If
    Next A
    If State <> 0 Then 'if on chip
        If ElimNum = 0 Then 'if protected
            If IsOnEdge(Column, Row) = True Then 'if on edge
                If IsInCorner(Column, Row) = True Then 'if in corner
                    ElimNum = GetPosState(2, Column, Row) * 100 'bonus
                Else
                    ElimNum = GetPosState(2, Column, Row) * 10 'bonus
                End If
            Else
                ElimNum = GetPosState(2, Column, Row) * 2 'bonus
            End If
        Else
            If IsOnEdge(Column, Row) = True Then 'if on edge
                'ElimNum = GetPosState(2, Column, Row) * 10 'bonus << BUG
                'ElimNum = -ElimNum
            End If
        End If
        If Turn = InvertTurn(OwnTurn) Then ElimNum = -ElimNum 'make enemy elim-count negative
    End If
    EnumPosElim = ElimNum 'return elim-count
    
End Function
