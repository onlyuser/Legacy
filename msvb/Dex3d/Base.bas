Attribute VB_Name = "ModuleA"
'Dex3D
'A Visual Basic 3D Engine
'
'Copyright (C) 1999 by Jerry J. Chen
'
'This program is free software; you can redistribute it and/or
'modify it under the terms of the GNU General Public License
'as published by the Free Software Foundation; either version 2
'of the License, or (at your option) any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
'GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
'
'Jerry J. Chen
'onlyuser@hotmail.com

Function LogN(Number As Double, Base As Double) As Double

    If Base <> 1 Then LogN = Log(Number) / Log(Base)
    
End Function
Function Sec(Number As Double) As Double

    If Number <> Pi / 2 And Number <> -Pi / 2 Then Sec = 1 / Cos(Number)
    
End Function
Function Csc(Number As Double) As Double

    If Number <> 0 And Number <> Pi Then Csc = 1 / Sin(Number)
    
End Function
Function Cot(Number As Double) As Double

    If Number <> 0 And Number <> Pi Then Cot = 1 / Tan(Number)
    
End Function
Function ArcSin(Number As Double) As Double

    Select Case Number
        Case 1
            ArcSin = Pi / 2
        Case -1
            ArcSin = -Pi / 2
        Case Else
            If Abs(Number) < 1 Then _
                ArcSin = Atn(Number / Sqr(-Number ^ 2 + 1))
    End Select
    
End Function
Function ArcCos(Number As Double) As Double

    Select Case Number
        Case 1
            ArcCos = 0
        Case -1
            ArcCos = Pi
        Case Else
            If Abs(Number) < 1 Then _
                ArcCos = Atn(-Number / Sqr(-Number ^ 2 + 1)) + 2 * Atn(1)
    End Select
    
End Function
Function ArcSec(Number As Double) As Double

    Select Case Number
        Case 1
            ArcSec = 0
        Case -1
            ArcSec = Pi
        Case Else
            If Abs(Number) < 1 Then _
                ArcSec = Atn(Number / Sqr(Number ^ 2 - 1)) + Sgn(Number - 1) * (2 * Atn(1))
    End Select
    
End Function
Function ArcCsc(Number As Double) As Double

    Select Case Number
        Case 1
            ArcCsc = Pi / 2
        Case -1
            ArcCsc = -Pi / 2
        Case Else
            If Abs(Number) < 1 Then _
                ArcCsc = Atn(Number / Sqr(Number ^ 2 - 1)) + (Sgn(Number) - 1) * (2 * Atn(1))
    End Select
    
End Function
Function ArcCot(Number As Double) As Double

    ArcCot = Atn(Number) + 2 * Atn(1)
    
End Function
