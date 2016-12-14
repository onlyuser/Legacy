Attribute VB_Name = "Module1"
Public Const Pi! = 3.14159265358979
Function GetAng!(CoordOpp!, CoordAdj!, AxisOpp!, AxisAdj!)
    
    'gets the 2d Ang of a point in it's relation to its axis (or dependent point)
    
    If CoordOpp > AxisOpp And CoordAdj > AxisAdj Then GetAng = 0 + Atn((CoordAdj - AxisAdj) / (CoordOpp - AxisOpp)) * 180 / Pi
    If CoordOpp < AxisOpp And CoordAdj > AxisAdj Then GetAng = 180 + Atn((CoordAdj - AxisAdj) / (CoordOpp - AxisOpp)) * 180 / Pi
    If CoordOpp < AxisOpp And CoordAdj < AxisAdj Then GetAng = 180 + Atn((CoordAdj - AxisAdj) / (CoordOpp - AxisOpp)) * 180 / Pi
    If CoordOpp > AxisOpp And CoordAdj < AxisAdj Then GetAng = 360 + Atn((CoordAdj - AxisAdj) / (CoordOpp - AxisOpp)) * 180 / Pi
    If CoordOpp = AxisOpp Then
        If CoordAdj > AxisAdj Then GetAng = 90
        If CoordAdj = AxisAdj Then GetAng = 0 'no angle
        If CoordAdj < AxisAdj Then GetAng = 270
    End If
    If CoordAdj = AxisAdj Then
        If CoordOpp > AxisOpp Then GetAng = 0
        If CoordOpp = AxisOpp Then GetAng = 0 'no angle
        If CoordOpp < AxisOpp Then GetAng = 180
    End If
    
End Function
Function GetCoord!(AxisName$, AxisOpp!, AxisAdj!, Ang!, Dist!)
    
    'gets the 2d coordinates of a point with its relation to its axis (or dependent point)
    
    If AxisName = "Opp" Then GetCoord = AxisOpp + Dist * Cos(Ang * Pi / 180)
    If AxisName = "Adj" Then GetCoord = AxisAdj + Dist * Sin(Ang * Pi / 180)
    
End Function
Function GetDist!(DistA!, DistB!, DistC!)
    
    'gets the distance between two points in 1d/2d/3d space (use given)
    
    GetDist = Sqr(DistA ^ 2 + DistB ^ 2 + DistC ^ 2)
    
End Function
Function Round!(Number!, Unit!)

    Round = Unit * Int((Number / Unit) + 0.5)

End Function
