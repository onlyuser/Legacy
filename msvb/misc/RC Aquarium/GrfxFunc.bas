Attribute VB_Name = "Module2"
Const pi = 3.14159265358979
Function GetAng!(CoordOpp!, CoordAdj!, AxisOpp!, AxisAdj!)
'Gets the 2d Ang of a point with it's relation to it's axis (or dependent point)

GetAng = 0
If CoordAdj > AxisAdj Then GetAng = -Atn((CoordOpp - AxisOpp) / (CoordAdj - AxisAdj)) * 180 / pi + 90
If CoordAdj = AxisAdj Then
    If CoordOpp > AxisOpp Then GetAng = 0
    If CoordOpp = AxisOpp Then GetAng = 0 'No Ang
    If CoordOpp < AxisOpp Then GetAng = 180
End If
If CoordAdj < AxisAdj Then GetAng = -Atn((CoordOpp - AxisOpp) / (CoordAdj - AxisAdj)) * 180 / pi + 270

End Function
Function GetCoord!(OutputType$, AxisOpp!, AxisAdj!, Ang!, Dist!)
'Gets the 2d Coords of a point with it's relation to it's axis (or dependent point)

GetCoord = 0
If OutputType = "Opp" Then GetCoord = AxisOpp + Dist * Cos(Ang * pi / 180)
If OutputType = "Adj" Then GetCoord = AxisAdj + Dist * Sin(Ang * pi / 180)

End Function
Function GetDist!(DistX!, DistY!, DistZ!)
'Gets the Dist between two points in 2d/3d space (use ommitted)

GetDist = 0
GetDist = Sqr(DistX ^ 2 + DistY ^ 2 + DistZ ^ 2)

End Function
