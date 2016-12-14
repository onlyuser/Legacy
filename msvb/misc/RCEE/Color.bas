Attribute VB_Name = "Module3"
'NOTE: Color format is &H0000BBGGRR&

Public Type ColorRGB
    R As Integer
    G As Integer
    B As Integer
End Type

Public Type ColorData
    Name As String
    Color As ColorRGB
End Type

Public Pal(7) As ColorData
Function FillPal()
    
    Pal(0).Name = "Black"
    Pal(0).Color.R = GetRGB(Hex(vbBlack)).R
    Pal(0).Color.G = GetRGB(Hex(vbBlack)).G
    Pal(0).Color.B = GetRGB(Hex(vbBlack)).B
    
    Pal(1).Name = "Red"
    Pal(1).Color.R = GetRGB(Hex(vbRed)).R
    Pal(1).Color.G = GetRGB(Hex(vbRed)).G
    Pal(1).Color.B = GetRGB(Hex(vbRed)).B
    
    Pal(2).Name = "Green"
    Pal(2).Color.R = GetRGB(Hex(vbGreen)).R
    Pal(2).Color.G = GetRGB(Hex(vbGreen)).G
    Pal(2).Color.B = GetRGB(Hex(vbGreen)).B
    
    Pal(3).Name = "Yellow"
    Pal(3).Color.R = GetRGB(Hex(vbYellow)).R
    Pal(3).Color.G = GetRGB(Hex(vbYellow)).G
    Pal(3).Color.B = GetRGB(Hex(vbYellow)).B
    
    Pal(4).Name = "Blue"
    Pal(4).Color.R = GetRGB(Hex(vbBlue)).R
    Pal(4).Color.G = GetRGB(Hex(vbBlue)).G
    Pal(4).Color.B = GetRGB(Hex(vbBlue)).B
    
    Pal(5).Name = "Magenta"
    Pal(5).Color.R = GetRGB(Hex(vbMagenta)).R
    Pal(5).Color.G = GetRGB(Hex(vbMagenta)).G
    Pal(5).Color.B = GetRGB(Hex(vbMagenta)).B
    
    Pal(6).Name = "Cyan"
    Pal(6).Color.R = GetRGB(Hex(vbCyan)).R
    Pal(6).Color.G = GetRGB(Hex(vbCyan)).G
    Pal(6).Color.B = GetRGB(Hex(vbCyan)).B
    
    Pal(7).Name = "White"
    Pal(7).Color.R = GetRGB(Hex(vbWhite)).R
    Pal(7).Color.G = GetRGB(Hex(vbWhite)).G
    Pal(7).Color.B = GetRGB(Hex(vbWhite)).B
    
End Function
Function GetAvg$(Hex$)

    Dim BufferA%
    
    BufferA = _
        ( _
            GetRGB(Hex).R + _
            GetRGB(Hex).G + _
            GetRGB(Hex).B _
        ) / _
        3

    GetMono = GetHex(BufferA, BufferA, BufferA)

End Function
Function GetPalColor(Name$) As ColorRGB

    Dim A%

    For A = 0 To 7
        If Pal(A).Name = Name Then
            GetPalColor.R = Pal(A).Color.R
            GetPalColor.G = Pal(A).Color.G
            GetPalColor.B = Pal(A).Color.B
            Exit Function
        End If
    Next A

End Function
Function GetPalName$(R%, G%, B%)

    Dim A%

    For A = 0 To 7
        If _
            Pal(A).Color.R = R And _
            Pal(A).Color.G = G And _
            Pal(A).Color.B = B _
                Then
                    GetPalName = Pal(A).Name
                    Exit Function
        End If
    Next A

End Function
Function GetRGB(Hex$) As ColorRGB
    
    'Converts color format from Hex to RGB
    
    Do While Len(Hex) < 6
        Hex = "0" + Hex
    Loop
    
    GetRGB.R = Val("&H" + Mid(Hex, 5, 2))
    GetRGB.G = Val("&H" + Mid(Hex, 3, 2))
    GetRGB.B = Val("&H" + Mid(Hex, 1, 2))

End Function
Function GetOnGrad$(A$, B$, Pos!)
    
    'Gets a color on a gradient color line
    
    Dim RedA%
    Dim BlueA%
    Dim GreenA%
    Dim RedB%
    Dim BlueB%
    Dim GreenB%
    Dim RedC%
    Dim BlueC%
    Dim GreenC%
    
    RedA = GetRGB(A).R
    GreenA = GetRGB(A).G
    BlueA = GetRGB(A).B
    
    RedB = GetRGB(B).R
    GreenB = GetRGB(B).G
    BlueB = GetRGB(B).B
    
    RedC = RedA + Pos / 1 * (RedB - RedA)
    GreenC = GreenA + Pos / 1 * (GreenB - GreenA)
    BlueC = BlueA + Pos / 1 * (BlueB - BlueA)
    
    GetOnGrad = GetHex(RedC, GreenC, BlueC)

End Function
Function GetHex$(R%, G%, B%)
    
    'Converts color format from RGB to Hex
    
    Dim Red$
    Dim Green$
    Dim Blue$
    
    Red = Hex(R)
    Green = Hex(G)
    Blue = Hex(B)
    
    Do While Len(Red) < 2
        Red = "0" + Red
    Loop
    Do While Len(Green) < 2
        Green = "0" + Green
    Loop
    Do While Len(Blue) < 2
        Blue = "0" + Blue
    Loop
    
    GetHex = Blue + Green + Red

End Function
Function Mono(Value%) As Long

    Mono = RGB(Value, Value, Value)

End Function


