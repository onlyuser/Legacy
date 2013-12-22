Attribute VB_Name = "ModuleC"
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

Type ColorRGB
    R As Integer
    G As Integer
    B As Integer
End Type
Function ColorAdd(A As ColorRGB, B As ColorRGB) As ColorRGB

    ColorAdd.R = A.R + B.R
    ColorAdd.G = A.G + B.G
    ColorAdd.B = A.B + B.B
    
End Function
Function ColorSubtract(A As ColorRGB, B As ColorRGB) As ColorRGB

    ColorSubtract.R = A.R - B.R
    ColorSubtract.G = A.G - B.G
    ColorSubtract.B = A.B - B.B
    
End Function
Function ColorScale(A As ColorRGB, B As Single) As ColorRGB

    ColorScale.R = A.R * B
    ColorScale.G = A.G * B
    ColorScale.B = A.B * B
    
End Function
Function ColorAverage(A As ColorRGB) As ColorRGB

    Dim B As Integer
    
    B = _
        ( _
            A.R + _
            A.G + _
            A.B _
        ) / _
        3
        
    ColorAverage = ColorMonochrome(B)
    
End Function
Function ColorHexToLong(A As String) As Long

    ColorHexToLong = _
        RGB( _
            (A And &HFF&), _
            (A And &HFF00&) / &H100&, _
            (A And &HFF0000) / &H10000 _
        )
        
End Function
Function ColorHexToRGB(A As String) As ColorRGB

    ColorHexToRGB.R = (A And &HFF&)
    ColorHexToRGB.G = (A And &HFF00&) / &H100&
    ColorHexToRGB.B = (A And &HFF0000) / &H10000
    
End Function
Function ColorInterpolate(A As ColorRGB, B As ColorRGB, Alpha As Single) As ColorRGB

    ColorInterpolate.R = A.R + Alpha * (B.R - A.R)
    ColorInterpolate.G = A.G + Alpha * (B.G - A.G)
    ColorInterpolate.B = A.B + Alpha * (B.B - A.B)
    
End Function
Function ColorLongToHex(A As Long) As String

    ColorLongToHex = Hex(A)
    
End Function
Function ColorLongToRGB(A As Long) As ColorRGB

    ColorLongToRGB.R = (A And &HFF&)
    ColorLongToRGB.G = (A And &HFF00&) / &H100&
    ColorLongToRGB.B = (A And &HFF0000) / &H10000
    
End Function
Function ColorPrint(A As ColorRGB) As String

    ColorPrint = A.R & vbTab & A.G & vbTab & A.B
    
End Function
Function ColorCompare(A As ColorRGB, B As ColorRGB) As Boolean

    If _
        A.R = B.R And _
        A.G = B.G And _
        A.B = B.B _
            Then _
                ColorCompare = True
                
End Function
Function ColorInput(R As Integer, G As Integer, B As Integer) As ColorRGB

    ColorInput.R = R
    ColorInput.G = G
    ColorInput.B = B
    
End Function
Function ColorInvert(A As ColorRGB) As ColorRGB

    ColorInvert.R = 255 - A.R
    ColorInvert.G = 255 - A.G
    ColorInvert.B = 255 - A.B
    
End Function
Function ColorNull() As ColorRGB

    ColorNull.R = 0
    ColorNull.G = 0
    ColorNull.B = 0
    
End Function
Function ColorRGBToHex(A As ColorRGB) As String

    ColorRGBToHex = Hex(RGB(A.R, A.G, A.B))
    
End Function
Function ColorRGBToLong(A As ColorRGB) As Long

    ColorRGBToLong = RGB(A.R, A.G, A.B)
    
End Function
Function ColorMonochrome(A As Integer) As ColorRGB

    ColorMonochrome.R = A
    ColorMonochrome.G = A
    ColorMonochrome.B = A
    
End Function
Function ColorRandom() As ColorRGB

    Randomize
    
    ColorRandom.R = 255 * Rnd
    ColorRandom.G = 255 * Rnd
    ColorRandom.B = 255 * Rnd
    
End Function
Function ColorUnion(A As ColorRGB, B As ColorRGB) As ColorRGB

    ColorUnion = A
    If B.R > ColorUnion.R Then ColorUnion.R = B.R
    If B.G > ColorUnion.G Then ColorUnion.G = B.G
    If B.B > ColorUnion.B Then ColorUnion.B = B.B
    
End Function
Function ColorIntersection(A As ColorRGB, B As ColorRGB) As ColorRGB

    ColorIntersection = A
    If B.R < ColorIntersection.R Then ColorIntersection.R = B.R
    If B.G < ColorIntersection.G Then ColorIntersection.G = B.G
    If B.B < ColorIntersection.B Then ColorIntersection.B = B.B
    
End Function
