Attribute VB_Name = "Module1"
Public Type Point2d
    X As Single
    Y As Single
End Type

Public Type Organism
    State As String
    Color As Long
    Target As Integer
    Pos As Point2d
    Dir As Single
    Flag As Integer
    Rad As Single
    FearRad As Single
    AggresRad As Single
    MoveVel As Single
    TurnVel As Single
End Type

Public Unit(1 To 20) As Organism

Public Tics%
Public TicCheck%
Public Periods%
Public GenCheck%
Public Bounds As Boolean
Public Status$
Public MsgStatus As Boolean
Public ProxyStatus As Boolean
Function NearestTarget%(Subject%)
    
    Dim A%
    Dim CurVal%
    Dim BestVal%
    
    For A = LBound(Unit) To UBound(Unit)
        If A <> Subject And Unit(A).Target <> Subject Then
            CurVal = _
                GetDist( _
                    Unit(Subject).Pos.X - Unit(A).Pos.X, _
                    Unit(Subject).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If CurVal > BestVal Then BestVal = CurVal
        End If
    Next A
    For A = LBound(Unit) To UBound(Unit)
        If A <> Subject And Unit(A).Target <> Subject Then
            CurVal = _
                GetDist( _
                    Unit(Subject).Pos.X - Unit(A).Pos.X, _
                    Unit(Subject).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If CurVal < BestVal Then BestVal = CurVal
        End If
    Next A
    For A = LBound(Unit) To UBound(Unit)
        If A <> Subject And Unit(A).Target <> Subject Then
            CurVal = _
                GetDist( _
                    Unit(Subject).Pos.X - Unit(A).Pos.X, _
                    Unit(Subject).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If CurVal = BestVal Then
                NearestTarget = A
                Exit Function
            End If
        End If
    Next A

End Function


Function BestUnit%(Optional Exclusion%)
    
    Dim A%
    Dim CurVal%
    Dim BestVal%

    For A = LBound(Unit) To UBound(Unit)
        If A <> Exclusion Then
            CurVal = Unit(A).Flag
            If CurVal > BestVal Then BestVal = CurVal
        End If
    Next A
    For A = LBound(Unit) To UBound(Unit)
        If A <> Exclusion Then
            If Unit(A).Flag = BestVal Then
                BestUnit = A
                Exit Function
            End If
        End If
    Next A

End Function
Function WorstUnit%(Optional Exclusion%)
    
    Dim A%
    Dim CurVal%
    Dim BestVal%

    For A = LBound(Unit) To UBound(Unit)
        If A <> Exclusion Then
            CurVal = Unit(A).Flag
            If CurVal > BestVal Then BestVal = CurVal
        End If
    Next A
    For A = LBound(Unit) To UBound(Unit)
        If A <> Exclusion Then
            CurVal = Unit(A).Flag
            If CurVal < BestVal Then BestVal = CurVal
        End If
    Next A
    For A = LBound(Unit) To UBound(Unit)
        If A <> Exclusion Then
            If Unit(A).Flag = BestVal Then
                WorstUnit = A
                Exit Function
            End If
        End If
    Next A

End Function

Function NearestThreat%(Subject%)
    
    Dim A%
    Dim CurVal%
    Dim BestVal%
    
    For A = LBound(Unit) To UBound(Unit)
        If A <> Subject And Unit(A).Target = Subject Then
            CurVal = _
                GetDist( _
                    Unit(Subject).Pos.X - Unit(A).Pos.X, _
                    Unit(Subject).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If CurVal > BestVal Then BestVal = CurVal
        End If
    Next A
    For A = LBound(Unit) To UBound(Unit)
        If A <> Subject And Unit(A).Target = Subject Then
            CurVal = _
                GetDist( _
                    Unit(Subject).Pos.X - Unit(A).Pos.X, _
                    Unit(Subject).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If CurVal < BestVal Then BestVal = CurVal
        End If
    Next A
    For A = LBound(Unit) To UBound(Unit)
        If A <> Subject And Unit(A).Target = Subject Then
            CurVal = _
                GetDist( _
                    Unit(Subject).Pos.X - Unit(A).Pos.X, _
                    Unit(Subject).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If CurVal = BestVal Then
                NearestThreat = A
                Exit Function
            End If
        End If
    Next A

End Function

Function DrawUnits(Scr As PictureBox)

    Dim A%
    Dim BufferA!
    
    For A = LBound(Unit) To UBound(Unit)
        Scr.Circle (Unit(A).Pos.X, Unit(A).Pos.Y), Unit(A).Rad, Unit(A).Color
        If A = BestUnit Then
            Scr.FillColor = vbGreen
            Scr.FillStyle = 0
            Scr.Circle (Unit(A).Pos.X, Unit(A).Pos.Y), Unit(A).Rad * 3 / 4, vbGreen
            Scr.FillStyle = 1
            Scr.FillColor = vbBlack
            Scr.DrawStyle = 2
            Scr.Circle (Unit(A).Pos.X, Unit(A).Pos.Y), Unit(A).FearRad, vbYellow
            Scr.Circle (Unit(A).Pos.X, Unit(A).Pos.Y), Unit(A).AggresRad, vbRed
            Scr.DrawStyle = 0
        End If
        If A = NearestThreat(BestUnit) Then
            Scr.FillColor = vbRed
            Scr.FillStyle = 0
            Scr.Circle (Unit(A).Pos.X, Unit(A).Pos.Y), Unit(A).Rad * 3 / 4, vbRed
            Scr.FillStyle = 1
            Scr.FillColor = vbBlack
        End If
        If A = Unit(BestUnit).Target Then
            Scr.FillColor = vbYellow
            Scr.FillStyle = 0
            Scr.Circle (Unit(A).Pos.X, Unit(A).Pos.Y), Unit(A).Rad * 3 / 4, vbYellow
            Scr.FillStyle = 1
            Scr.FillColor = vbBlack
        End If
        Scr.Line _
            ( _
                Unit(A).Pos.X, _
                Unit(A).Pos.Y _
            )- _
            ( _
                GetCoord( _
                    "Opp", _
                    Unit(A).Pos.X, _
                    Unit(A).Pos.Y, _
                    Unit(A).Dir, _
                    Unit(A).MoveVel _
                ), _
                GetCoord( _
                    "Adj", _
                    Unit(A).Pos.X, _
                    Unit(A).Pos.Y, _
                    Unit(A).Dir, _
                    Unit(A).MoveVel _
                ) _
            ), _
            vbWhite
        If ProxyStatus = True Then
            BufferA = _
                GetDist( _
                    Unit(Unit(A).Target).Pos.X - Unit(A).Pos.X, _
                    Unit(Unit(A).Target).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If BufferA < Unit(A).AggresRad Then
                Scr.Circle (Unit(A).Pos.X, Unit(A).Pos.Y), Unit(A).Rad * 3 / 4, vbRed
                Scr.DrawStyle = 2
                Scr.Line _
                    ( _
                        Unit(A).Pos.X, _
                        Unit(A).Pos.Y _
                    )- _
                    ( _
                        Unit(Unit(A).Target).Pos.X, _
                        Unit(Unit(A).Target).Pos.Y _
                    ), _
                    vbRed
                Scr.DrawStyle = 0
                Scr.ForeColor = vbRed
                Scr.Print Unit(Unit(A).Target).Flag
                Scr.ForeColor = vbWhite
            End If
            If NearestThreat(A) <> 0 Then
                BufferA = _
                    GetDist( _
                        Unit(NearestThreat(A)).Pos.X - Unit(A).Pos.X, _
                        Unit(NearestThreat(A)).Pos.Y - Unit(A).Pos.Y, _
                        0 _
                    )
                If BufferA < Unit(A).FearRad Then
                    Scr.Circle (Unit(A).Pos.X, Unit(A).Pos.Y), Unit(A).Rad * 3 / 4, vbYellow
                    Scr.DrawStyle = 2
                    Scr.Line _
                        ( _
                            Unit(A).Pos.X, _
                            Unit(A).Pos.Y _
                        )- _
                        ( _
                            Unit(NearestThreat(A)).Pos.X, _
                            Unit(NearestThreat(A)).Pos.Y _
                        ), _
                        vbYellow
                    Scr.DrawStyle = 0
                    Scr.ForeColor = vbYellow
                    Scr.Print Unit(NearestThreat(A)).Flag
                    Scr.ForeColor = vbWhite
                End If
            End If
        End If
    Next A
    If Bounds = True Then
        Scr.DrawWidth = 2
        Scr.Line (0, 0)-(Scr.ScaleWidth, Scr.ScaleHeight), vbRed, B
        Scr.DrawWidth = 1
    End If
    
End Function
Function ResetDirPos%(Subject%, Scr As PictureBox)

    Unit(Subject).Pos.X = Rnd * Scr.ScaleWidth
    Unit(Subject).Pos.Y = Rnd * Scr.ScaleHeight
    Unit(Subject).Dir = Rnd * 360

End Function

Function ResetEnvCtrls(Scr As PictureBox)
    
    Scr.ForeColor = vbWhite
    
    Tics = 0
    TicCheck = 100
    Periods = 0
    GenCheck = 1
    Bounds = False
    MsgStatus = False
    ProxyStatus = True
    
End Function
Function ResetTraits(Subject%)

    Unit(Subject).Rad = Rnd * 100
    Unit(Subject).FearRad = Rnd * 2500
    Unit(Subject).AggresRad = Rnd * 2500
    Unit(Subject).MoveVel = Rnd * 100
    Unit(Subject).TurnVel = Rnd * 180 - 90

End Function

Function ResetUnits(Scr As PictureBox)

    Dim A%

    Randomize

    For A = LBound(Unit) To UBound(Unit)
        Unit(A).Flag = 1
        Unit(A).State = ""
        Unit(A).Color = vbBlack
        Unit(A).Target = NearestTarget(A)
        Call ResetDirPos(A, Scr)
        Call ResetTraits(A)
    Next A

End Function

Function TuneUnits()

    Dim A%
    Dim BufferA!
    Dim BufferB!
    Dim BufferC!
    Dim BufferD!
    
    For A = LBound(Unit) To UBound(Unit)
        BufferA = Unit(A).Dir
        BufferB = Unit(A).TurnVel
        If NearestThreat(A) = 0 Then 'if threat doesn't exist
            BufferC = _
                GetDist( _
                    Unit(Unit(A).Target).Pos.X - Unit(A).Pos.X, _
                    Unit(Unit(A).Target).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If BufferC < Unit(A).AggresRad Then 'if target exists in unit's aggression range
                Unit(A).State = "Engaging target"
                BufferD = _
                    GetAng( _
                        Unit(Unit(A).Target).Pos.X, _
                        Unit(Unit(A).Target).Pos.Y, _
                        Unit(A).Pos.X, _
                        Unit(A).Pos.Y _
                    )
                If Abs(BufferD - BufferA) < 180 Then
                    If BufferD > BufferA Then BufferB = Abs(BufferB)
                    If BufferD < BufferA Then BufferB = -Abs(BufferB)
                End If
                If Abs(BufferD - BufferA) > 180 Then
                    If BufferD > BufferA Then BufferB = -Abs(BufferB)
                    If BufferD < BufferA Then BufferB = Abs(BufferB)
                End If
            Else 'if target exists beyond unit's aggression range
                Unit(A).State = "Searching for target"
                If Int(Rnd * 2) = 1 Then
                    BufferB = Abs(BufferB)
                Else
                    BufferB = -Abs(BufferB)
                End If
            End If
        Else 'if threat exists
            BufferC = _
                GetDist( _
                    Unit(NearestThreat(A)).Pos.X - Unit(A).Pos.X, _
                    Unit(NearestThreat(A)).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If BufferC < Unit(A).FearRad Then 'if threat exists in unit's fear range
                Unit(A).State = "Evading threat"
                BufferD = _
                    GetAng( _
                        Unit(NearestThreat(A)).Pos.X, _
                        Unit(NearestThreat(A)).Pos.Y, _
                        Unit(A).Pos.X, _
                        Unit(A).Pos.Y _
                    )
                If Abs(BufferD - BufferA) < 180 Then
                    If BufferD > BufferA Then BufferB = -Abs(BufferB)
                    If BufferD < BufferA Then BufferB = Abs(BufferB)
                End If
                If Abs(BufferD - BufferA) > 180 Then
                    If BufferD > BufferA Then BufferB = Abs(BufferB)
                    If BufferD < BufferA Then BufferB = -Abs(BufferB)
                End If
            Else 'if threat exists beyond unit's fear range
                BufferC = _
                    GetDist( _
                        Unit(Unit(A).Target).Pos.X - Unit(A).Pos.X, _
                        Unit(Unit(A).Target).Pos.Y - Unit(A).Pos.Y, _
                        0 _
                    )
                If BufferC < Unit(A).AggresRad Then 'if target exists in unit's aggression range
                    Unit(A).State = "Engaging target"
                    BufferD = _
                        GetAng( _
                            Unit(Unit(A).Target).Pos.X, _
                            Unit(Unit(A).Target).Pos.Y, _
                            Unit(A).Pos.X, _
                            Unit(A).Pos.Y _
                        )
                    If Abs(BufferD - BufferA) < 180 Then
                        If BufferD > BufferA Then BufferB = Abs(BufferB)
                        If BufferD < BufferA Then BufferB = -Abs(BufferB)
                    End If
                    If Abs(BufferD - BufferA) > 180 Then
                        If BufferD > BufferA Then BufferB = -Abs(BufferB)
                        If BufferD < BufferA Then BufferB = Abs(BufferB)
                    End If
                Else 'if target exists beyond unit's aggression range
                    Unit(A).State = "Searching for target"
                    If Int(Rnd * 2) = 1 Then
                        BufferB = Abs(BufferB)
                    Else
                        BufferB = -Abs(BufferB)
                    End If
                End If
            End If
        End If
        Unit(A).TurnVel = BufferB
    Next A

End Function
Function UpdateUnits(Scr As PictureBox)

    Dim A%
    Dim B%
    Dim BufferA!
    Dim BufferB!
    Dim BufferC$
    Dim BufferD$
    Dim Button%
    
    For A = LBound(Unit) To UBound(Unit)
        Unit(A).Dir = Unit(A).Dir + Unit(A).TurnVel
        If Unit(A).Dir < 0 Then Unit(A).Dir = 360 + Unit(A).Dir
        If Unit(A).Dir >= 360 Then Unit(A).Dir = Unit(A).Dir - 360
        Unit(A).Pos.X = _
            GetCoord( _
                "Opp", _
                Unit(A).Pos.X, _
                Unit(A).Pos.Y, _
                Unit(A).Dir, _
                Unit(A).MoveVel _
            )
        Unit(A).Pos.Y = _
            GetCoord( _
                "Adj", _
                Unit(A).Pos.X, _
                Unit(A).Pos.Y, _
                Unit(A).Dir, _
                Unit(A).MoveVel _
            )
        If Bounds = True Then
            If Unit(A).Pos.X < 0 Then Unit(A).Pos.X = 0
            If Unit(A).Pos.X > Scr.ScaleWidth Then Unit(A).Pos.X = Scr.ScaleWidth
            If Unit(A).Pos.Y < 0 Then Unit(A).Pos.Y = 0
            If Unit(A).Pos.Y > Scr.ScaleHeight Then Unit(A).Pos.Y = Scr.ScaleHeight
        Else
            If Unit(A).Pos.X < 0 Then Unit(A).Pos.X = Scr.ScaleWidth
            If Unit(A).Pos.X > Scr.ScaleWidth Then Unit(A).Pos.X = 0
            If Unit(A).Pos.Y < 0 Then Unit(A).Pos.Y = Scr.ScaleHeight
            If Unit(A).Pos.Y > Scr.ScaleHeight Then Unit(A).Pos.Y = 0
        End If
        BufferA = _
            GetDist( _
                Unit(Unit(A).Target).Pos.X - Unit(A).Pos.X, _
                Unit(Unit(A).Target).Pos.Y - Unit(A).Pos.Y, _
                0 _
            )
        If BufferA < (Unit(A).Rad + Unit(Unit(A).Target).Rad) Then
            Unit(A).Flag = Unit(A).Flag + 1 'increase predator's evaluation
            Unit(Unit(A).Target).Flag = Unit(Unit(A).Target).Flag - 1 'decrease target's evaluation
            If Int(Rnd * 2) = 1 Then Unit(Unit(A).Target).Rad = Unit(A).Rad
            If Int(Rnd * 2) = 1 Then Unit(Unit(A).Target).MoveVel = Unit(A).MoveVel
            If Int(Rnd * 2) = 1 Then Unit(Unit(A).Target).TurnVel = Unit(A).TurnVel
            If Int(Rnd * 2) = 1 Then Unit(Unit(A).Target).FearRad = Unit(A).FearRad
            If Int(Rnd * 2) = 1 Then Unit(Unit(A).Target).AggresRad = Unit(A).AggresRad
            Call ResetDirPos(Unit(A).Target, Scr)
            If Unit(A).Target = WorstUnit Or Unit(Unit(A).Target).Flag = 0 Then
                Unit(Unit(A).Target).Flag = 1
                Call ResetTraits(Unit(A).Target)
            End If
        Else
            BufferA = _
                GetDist( _
                    Unit(NearestTarget(A)).Pos.X - Unit(A).Pos.X, _
                    Unit(NearestTarget(A)).Pos.Y - Unit(A).Pos.Y, _
                    0 _
                )
            If BufferA < Unit(A).AggresRad Then Unit(A).Target = NearestTarget(A)
        End If
        If Unit(A).Flag >= 0 Then Unit(A).Color = vbBlue
        If Unit(A).Flag >= 2 Then Unit(A).Color = vbCyan
        If Unit(A).Flag >= 4 Then Unit(A).Color = vbGreen
        If Unit(A).Flag >= 6 Then Unit(A).Color = vbYellow
        If Unit(A).Flag >= 8 Then Unit(A).Color = vbRed
        If Unit(A).Flag >= 10 Then Unit(A).Color = vbMagenta
    Next A
    If NearestThreat(BestUnit) <> 0 Then
        BufferC = NearestThreat(BestUnit)
        BufferD = Unit(NearestThreat(BestUnit)).Flag
    Else
        BufferC = "[None]"
        BufferD = "[N/A]"
    End If
    Status = _
        Periods & " period(s) completed" & vbCrLf & _
        "with a best record of " & vbCrLf & _
        Unit(BestUnit).Flag & " generation(s) by Unit " & BestUnit & vbCrLf & _
        vbCrLf & _
        "Unit:" & vbTab & BestUnit & vbTab & _
        "Generations:" & vbTab & Unit(BestUnit).Flag & vbCrLf & _
        "Threat:" & vbTab & BufferC & vbTab & _
        "Generations:" & vbTab & BufferD & vbCrLf & _
        "Target:" & vbTab & Unit(BestUnit).Target & vbTab & _
        "Generations:" & vbTab & Unit(Unit(BestUnit).Target).Flag & vbCrLf & _
        vbCrLf & _
        "State:" & vbTab & Unit(BestUnit).State & vbCrLf & _
        vbCrLf & _
        "Fear Radius:" & vbTab & Format(Unit(BestUnit).FearRad, "0.00") & vbTab & " twips" & vbCrLf & _
        "Aggres. Radius:" & vbTab & Format(Unit(BestUnit).AggresRad, "0.00") & vbTab & " twips" & vbCrLf & _
        "Unit Radius:" & vbTab & Format(Unit(BestUnit).Rad, "0.00") & vbTab & " twips" & vbCrLf & _
        "Move Velocity:" & vbTab & Format(Abs(Unit(BestUnit).MoveVel), "0.00") & vbTab & " twips/tic" & vbCrLf & _
        "Turn Velocity:" & vbTab & Format(Abs(Unit(BestUnit).TurnVel), "0.00") & vbTab & " degrees/tic"
    If MsgStatus = True And Periods <> 0 And Tics = 0 And Periods Mod GenCheck = 0 Then
        Button = _
            MsgBox( _
                Status & vbCrLf & _
                vbCrLf & _
                "Would you like to reset the population?", _
                vbYesNo, _
                "Optimization Status" _
            )
        If Button = vbYes Then Call ResetUnits(Scr)
    End If
    Tics = Tics + 1
    If Tics = TicCheck Then
        Tics = 0
        Periods = Periods + 1
    End If
    
End Function
