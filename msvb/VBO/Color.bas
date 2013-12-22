Attribute VB_Name = "Module7"
'&H0000BBGGRR&

Public Type ColorRGB
    R As Integer
    G As Integer
    B As Integer
End Type
Function GetColorAvg$(ColorHex$)

    Dim ColorAvg%
    
    ColorAvg = _
        ( _
            GetColorRGB(ColorHex).R + _
            GetColorRGB(ColorHex).G + _
            GetColorRGB(ColorHex).B _
        ) / _
        3

    GetColorAvg = GetColorHex(ColorAvg, ColorAvg, ColorAvg)

End Function
Function GetColorLong&(ColorHex$)

    GetColorLong = Val("&H" & ColorHex)

End Function
Function GetColorRGB(ColorHex$) As ColorRGB
    
    Do While Len(ColorHex) < 6
        ColorHex = "0" + ColorHex
    Loop
    
    GetColorRGB.R = GetColorLong(Mid(ColorHex, 5, 2))
    GetColorRGB.G = GetColorLong(Mid(ColorHex, 3, 2))
    GetColorRGB.B = GetColorLong(Mid(ColorHex, 1, 2))

End Function
Function GetColorInterp$(ColorA$, ColorB$, Alpha!)
    
    Dim RedA%
    Dim BlueA%
    Dim GreenA%
    Dim RedB%
    Dim BlueB%
    Dim GreenB%
    Dim RedC%
    Dim BlueC%
    Dim GreenC%
    
    RedA = GetColorRGB(ColorA).R
    GreenA = GetColorRGB(ColorA).G
    BlueA = GetColorRGB(ColorA).B
    
    RedB = GetColorRGB(ColorB).R
    GreenB = GetColorRGB(ColorB).G
    BlueB = GetColorRGB(ColorB).B
    
    RedC = RedA + Alpha * (RedB - RedA)
    GreenC = GreenA + Alpha * (GreenB - GreenA)
    BlueC = BlueA + Alpha * (BlueB - BlueA)
    
    GetColorInterp = GetColorHex(RedC, GreenC, BlueC)

End Function
Function GetColorHex$(Red%, Green%, Blue%)
    
    Dim RedHex$
    Dim GreenHex$
    Dim BlueHex$
    
    RedHex = Hex(Red)
    GreenHex = Hex(Green)
    BlueHex = Hex(Blue)
    
    Do While Len(RedHex) < 2
        RedHex = "0" + RedHex
    Loop
    Do While Len(GreenHex) < 2
        GreenHex = "0" + GreenHex
    Loop
    Do While Len(BlueHex) < 2
        BlueHex = "0" + BlueHex
    Loop
    
    GetColorHex = BlueHex + GreenHex + RedHex

End Function
Function GetColorMono&(Lum%)

    GetColorMono = RGB(Lum, Lum, Lum)

End Function
