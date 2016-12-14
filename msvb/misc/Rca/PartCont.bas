Attribute VB_Name = "Module3"
'Information:
'This function emulates the behavior of organisms in terms of 2d motion
'with entities pertaining preset and random generated properties
'The SetEARMax value controls the state of the equarium (active, inactive)
'The EMC and ERC values together control the degree of interest
'of the entity towards the target (fanatic, apathetic)

'Examples:
'Default: (EMax% = 10; SetEARMax% = 10; EMC% = 1; ERC% = 10; VMax% = 2; SetVMax% = 2)
'Narcotic fish: (''ERC% = 100'')
'Numb fish: (''ERC% = 1'')
'Mosquito: (''SetEARMax% = 100'')

'Constants:
Const EMax% = "10" 'entity valid population
Const SetEARMax% = "10" 'acceleration setting maximum
Const EMC% = "1" 'entity moving constant (shows energy)
Const ERC% = "10" 'entity rotating constant (shows excitement)
Const VMax% = "2" 'velocity valid maximum
Const SetVMax% = "2" 'velocity setting maximum

'Variables:
Const FrBnd% = "8" 'fear boundary
Const TcBnd% = "4" 'touch boundary
Global TargetX! 'target x
Global TargetY! 'target y
Global EX!(EMax) 'x
Global EY!(EMax) 'y
Global ED!(EMax) 'direction
Global EV!(EMax) 'velocity
Global EP!(EMax) 'static pull trigger
Global EA!(EMax) 'avoidance trigger
Global EAR!(EMax) 'acceleration rate
Global A% 'counter a
Global B% 'counter b
Function RotateAng()
For A = 1 To EMax
    If Abs(ED(A) - GetAng(TargetX, TargetY, EX(A), EY(A))) < 180 Then
        If ED(A) < GetAng(TargetX, TargetY, EX(A), EY(A)) Then ED(A) = ED(A) + EV(A) * 10 * EP(A) * EA(A)
        If ED(A) > GetAng(TargetX, TargetY, EX(A), EY(A)) Then ED(A) = ED(A) - EV(A) * 10 * EP(A) * EA(A)
    End If
    If Abs(ED(A) - GetAng(TargetX, TargetY, EX(A), EY(A))) > 180 Then
        If ED(A) < GetAng(TargetX, TargetY, EX(A), EY(A)) Then
            If ED(A) < 0 Then ED(A) = 360 + ED(A)
            ED(A) = ED(A) - EV(A) * ERC * EP(A) * EA(A)
        End If
        If ED(A) > GetAng(TargetX, TargetY, EX(A), EY(A)) Then
            If ED(A) >= 360 Then ED(A) = ED(A) - 360
            ED(A) = ED(A) + EV(A) * ERC * EP(A) * EA(A)
        End If
    End If
Next A

End Function
Function ChangeVel()
For A = 1 To EMax
    EV(A) = EAR(A) / GetDist(EX(A) - TargetX, EY(A) - TargetY, 0)
    If EV(A) > VMax Then EV(A) = VMax
Next A

End Function

Function MovePos(FormObj As Object)
For A = 1 To EMax
    EX(A) = GetCoord("Opp", EX(A), EY(A), ED(A), EV(A) * EMC)
    EY(A) = GetCoord("Adj", EX(A), EY(A), ED(A), EV(A) * EMC)
    If GetDist(EX(A) - TargetX, EY(A) - TargetY, 0) < FrBnd Then EA(A) = -1
    If GetDist(EX(A) - TargetX, EY(A) - TargetY, 0) > FrBnd Then EA(A) = 1
    If GetDist(EX(A) - TargetX, EY(A) - TargetY, 0) < TcBnd Then EP(A) = -1
    If (EX(A) < 0 Or EY(A) < 0 Or EX(A) > FormObj.ScaleWidth Or EY(A) > FormObj.ScaleHeight) Then EP(A) = 1
    If EX(A) < 0 Then EX(A) = 0
    If EY(A) < 0 Then EY(A) = 0
    If EX(A) > FormObj.ScaleWidth Then EX(A) = FormObj.ScaleWidth
    If EY(A) > FormObj.ScaleHeight Then EY(A) = FormObj.ScaleHeight
Next A

End Function
Function DrawEnt(FormObj As Object)
If FormObj.WindowState = 1 Then Exit Function
FormObj.Cls
For A = 1 To EMax
    FormObj.Circle (EX(A), EY(A)), 1, RGB(0, 0, 255)
    If EP(A) > 0 Then
        FormObj.Line (EX(A), EY(A))-(GetCoord("Opp", EX(A), EY(A), ED(A), 2), GetCoord("Adj", EX(A), EY(A), ED(A), 2)), RGB(0, 255, 0)
    End If
    If EP(A) < 0 Then
        FormObj.Line (EX(A), EY(A))-(GetCoord("Opp", EX(A), EY(A), ED(A), 2), GetCoord("Adj", EX(A), EY(A), ED(A), 2)), RGB(255, 0, 0)
    End If
Next A
FormObj.Circle (TargetX, TargetY), 1, RGB(255, 255, 0)
Call RotateAng
Call ChangeVel
Call MovePos(Form1)

End Function
Function ResetProp(FormObj As Object)
Randomize
For A = 1 To EMax
    EX(A) = Int((FormObj.ScaleWidth - 0 + 1) * Rnd + 0)
    EY(A) = Int((FormObj.ScaleHeight - 0 + 1) * Rnd + 0)
    ED(A) = Int(Rnd * 360)
    EV(A) = Int(Rnd * SetVMax)
    EP(A) = Int((1 - 0 + 1) * Rnd + 0) * 2 - 1
    EA(A) = 1
    Do Until EAR(A) <> 0
        EAR(A) = Int((SetEARMax - 0 + 1) * Rnd + 0)
    Loop
Next A

End Function
