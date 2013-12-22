Attribute VB_Name = "ModuleJ"
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

Public MyMesh As Integer
Public MyCamera As Integer
Public MyLight As Integer

Public BeginRenderLoop As Boolean
Public RefreshScene As Boolean

Public TickCount As Integer
Public BeginTime As Single
Public FinishTime As Single

Public LastMousePosition As POINTAPI

Public OrbitLongitude As Single
Public OrbitLatitude As Single
Public OrbitRadius As Single
Public OrbitSpeed As Single
Public DollySpeed As Single

Public FaceOver As Integer
Public LastFaceOver As Integer

Public PaletteColor As Long
Public BrushColor As Long
Public BrushAlpha As Single

Public LockCamera As Boolean
Public CameraModel As Integer
Function DrawArrow(Canvas As PictureBox, X As Single, Y As Single, Direction As Integer, Length As Single, Color As Long, DrawMode As Integer)

    Dim Vertex(2) As POINTAPI
    
    Select Case Direction
        Case 1 'up
            Vertex(0).X = X
            Vertex(0).Y = Y
            Vertex(1).X = X + Length / 2
            Vertex(1).Y = Y + Length
            Vertex(2).X = X - Length / 2
            Vertex(2).Y = Y + Length
        Case 2 'right
            Vertex(0).X = X
            Vertex(0).Y = Y
            Vertex(1).X = X - Length
            Vertex(1).Y = Y + Length / 2
            Vertex(2).X = X - Length
            Vertex(2).Y = Y - Length / 2
        Case 3 'down
            Vertex(0).X = X
            Vertex(0).Y = Y
            Vertex(1).X = X - Length / 2
            Vertex(1).Y = Y - Length
            Vertex(2).X = X + Length / 2
            Vertex(2).Y = Y - Length
        Case 4 'left
            Vertex(0).X = X
            Vertex(0).Y = Y
            Vertex(1).X = X + Length
            Vertex(1).Y = Y - Length / 2
            Vertex(2).X = X + Length
            Vertex(2).Y = Y + Length / 2
    End Select
    Canvas.DrawMode = DrawMode
    Canvas.DrawStyle = 5
    Canvas.FillStyle = 0
    Canvas.FillColor = Color
    Call Polygon(Canvas.hdc, Vertex(0), 3)
    
End Function
Function DrawBox(Canvas As PictureBox, X1 As Single, Y1 As Single, X2 As Single, Y2 As Single, Color As Long, DrawMode As Integer)

    Dim Vertex(3) As POINTAPI
    
    Vertex(0).X = X1
    Vertex(0).Y = Y1
    Vertex(1).X = X2
    Vertex(1).Y = Y1
    Vertex(2).X = X2
    Vertex(2).Y = Y2
    Vertex(3).X = X1
    Vertex(3).Y = Y2
    Canvas.DrawMode = DrawMode
    Canvas.DrawStyle = 5
    Canvas.FillStyle = 0
    Canvas.FillColor = Color
    Call Polygon(Canvas.hdc, Vertex(0), 4)
    
End Function
Function DrawColorShades(Canvas As PictureBox, X1 As Single, Y1 As Single, X2 As Single, Y2 As Single, Direction As Integer, Color As Long)

    Dim xInc As Single
    Dim yInc As Single
    Dim x3 As Single
    Dim y3 As Single
    Dim x4 As Single
    Dim y4 As Single
    
    Select Case Direction
        Case 1 'horizontal
            xInc = (X2 - X1) / 2
            x3 = X1
            y3 = Y1
            x4 = X1
            y4 = Y2
        Case 2 'vertical
            yInc = (Y2 - Y1) / 2
            x3 = X1
            y3 = Y1
            x4 = X2
            y4 = Y1
    End Select
    Call _
        DrawGradientBand( _
            Canvas, _
            x3 + xInc * 0, _
            y3 + yInc * 0, _
            x4 + xInc * 1, _
            y4 + yInc * 1, _
            Direction, _
            vbBlack, _
            Color _
        )
    Call _
        DrawGradientBand( _
            Canvas, _
            x3 + xInc * 1, _
            y3 + yInc * 1, _
            x4 + xInc * 2, _
            y4 + yInc * 2, _
            Direction, _
            Color, _
            vbWhite _
        )
        
End Function
Function DrawGradientBand(Canvas As PictureBox, X1 As Single, Y1 As Single, X2 As Single, Y2 As Single, Direction As Integer, ColorA As Long, ColorB As Long)

    Dim ColorC As ColorRGB
    Dim ColorD As ColorRGB
    Dim Vertex(1) As TRIVERTEX
    Dim Rect As GRADIENT_RECT
    
    ColorC = ColorLongToRGB(ColorA)
    ColorD = ColorLongToRGB(ColorB)
    Vertex(0).X = X1
    Vertex(0).Y = Y1
    Vertex(0).Red = "&H" & Hex(ColorC.R) & "00"
    Vertex(0).Green = "&H" & Hex(ColorC.G) & "00"
    Vertex(0).Blue = "&H" & Hex(ColorC.B) & "00"
    Vertex(1).X = X2
    Vertex(1).Y = Y2
    Vertex(1).Red = "&H" & Hex(ColorD.R) & "00"
    Vertex(1).Green = "&H" & Hex(ColorD.G) & "00"
    Vertex(1).Blue = "&H" & Hex(ColorD.B) & "00"
    Rect.UpperLeft = 0
    Rect.LowerRight = 1
    Select Case Direction
        Case 1 'horizontal
            Call GradientFill(Canvas.hdc, Vertex(0), 2, Rect, 1, GRADIENT_FILL_RECT_H)
        Case 2 'vertical
            Call GradientFill(Canvas.hdc, Vertex(0), 2, Rect, 1, GRADIENT_FILL_RECT_V)
    End Select
    
End Function
Function DrawColorSpectrum(Canvas As PictureBox, X1 As Single, Y1 As Single, X2 As Single, Y2 As Single, Direction As Integer)

    Dim xInc As Single
    Dim yInc As Single
    Dim x3 As Single
    Dim y3 As Single
    Dim x4 As Single
    Dim y4 As Single
    
    Select Case Direction
        Case 1 'horizontal
            xInc = (X2 - X1) / 6
            x3 = X1
            y3 = Y1
            x4 = X1
            y4 = Y2
        Case 2 'vertical
            yInc = (Y2 - Y1) / 6
            x3 = X1
            y3 = Y1
            x4 = X2
            y4 = Y1
    End Select
    Call _
        DrawGradientBand( _
            Canvas, _
            x3 + xInc * 0, _
            y3 + yInc * 0, _
            x4 + xInc * 1, _
            y4 + yInc * 1, _
            Direction, _
            vbMagenta, _
            vbRed _
        )
    Call _
        DrawGradientBand( _
            Canvas, _
            x3 + xInc * 1, _
            y3 + yInc * 1, _
            x4 + xInc * 2, _
            y4 + yInc * 2, _
            Direction, _
            vbRed, _
            vbYellow _
        )
    Call _
        DrawGradientBand( _
            Canvas, _
            x3 + xInc * 2, _
            y3 + yInc * 2, _
            x4 + xInc * 3, _
            y4 + yInc * 3, _
            Direction, _
            vbYellow, _
            vbGreen _
        )
    Call _
        DrawGradientBand( _
            Canvas, _
            x3 + xInc * 3, _
            y3 + yInc * 3, _
            x4 + xInc * 4, _
            y4 + yInc * 4, _
            Direction, _
            vbGreen, _
            vbCyan _
        )
    Call _
        DrawGradientBand( _
            Canvas, _
            x3 + xInc * 4, _
            y3 + yInc * 4, _
            x4 + xInc * 5, _
            y4 + yInc * 5, _
            Direction, _
            vbCyan, _
            vbBlue _
        )
    Call _
        DrawGradientBand( _
            Canvas, _
            x3 + xInc * 5, _
            y3 + yInc * 5, _
            x4 + xInc * 6, _
            y4 + yInc * 6, _
            Direction, _
            vbBlue, _
            vbMagenta _
        )
        
End Function
