Attribute VB_Name = "ModuleH"
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

Function AddMeshBarGraph(Columns As Integer, Rows As Integer, Dimensions As Vector, Thickness As Single, Value() As Single, Color() As Long) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim LastMeshIndex As Integer
    Dim BarHeight As Single
    Dim MaximumBarHeight As Single
    Dim BarPositionZ As Single
    Dim BarPositionX As Single
    
    For A = LBound(Value) To UBound(Value)
        If Value(A) > MaximumBarHeight Then MaximumBarHeight = Value(A)
    Next A
    C = 1
    For A = 1 To Rows
        For B = 1 To Columns
            BarHeight = Value(C) / MaximumBarHeight * Dimensions.Y
            BarPositionZ = (A - 1) * Dimensions.Z / (Rows - 1)
            BarPositionX = (B - 1) * Dimensions.X / (Columns - 1)
            MeshIndex = AddMeshBox(VectorInput(Thickness, BarHeight, Thickness))
            Call TransformMesh(MeshIndex, TransformationTranslate(VectorInput(BarPositionX, 0, BarPositionZ)))
            Call SetMeshColor(MeshIndex, ColorLongToRGB(Color(C)), 0.5)
            If LastMeshIndex <> 0 Then
                LastMeshIndex = AttachMeshes(MeshIndex, LastMeshIndex)
            Else
                LastMeshIndex = MeshIndex
            End If
            C = C + 1
        Next B
    Next A
    Call CenterMesh(LastMeshIndex)
    AddMeshBarGraph = LastMeshIndex
    
End Function
Function AddMeshGridGraph(Columns As Integer, Rows As Integer, Dimensions As Vector, Value() As Single, ColorA As Long, ColorB As Long, DoubleSided As Boolean) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim GridHeight As Single
    Dim MaximumGridHeight As Single
    
    For A = LBound(Value) To UBound(Value)
        If Value(A) > MaximumGridHeight Then MaximumGridHeight = Value(A)
    Next A
    MeshIndex = AddMeshGrid(Dimensions.X, Dimensions.Z, Columns - 1, Rows - 1, DoubleSided)
    If MeshIndex = 0 Then Exit Function
    C = 1
    For A = 1 To Rows
        For B = 1 To Columns
            GridHeight = Value(C) / MaximumGridHeight * Dimensions.Y
            VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C).Y = GridHeight
            C = C + 1
        Next B
    Next A
    Call SetMeshColorGradient(MeshIndex, 2, ColorLongToRGB(ColorA), ColorLongToRGB(ColorB), 0.5)
    Call CenterMesh(MeshIndex)
    AddMeshGridGraph = MeshIndex
    
End Function
Function AddMeshPieGraph(Radius As Single, Height As Single, LongitudeSteps As Integer, Value() As Single, Color() As Long) As Integer

    Dim A As Integer
    Dim MeshIndex As Integer
    Dim LastMeshIndex As Integer
    Dim Sum As Single
    Dim LongitudeStart As Single
    Dim LongitudeEnd As Single
    Dim SliceAngle As Single
    
    For A = LBound(Value) To UBound(Value)
        Sum = Sum + Value(A)
    Next A
    For A = LBound(Value) To UBound(Value)
        SliceAngle = Value(A) / Sum * 360
        LongitudeStart = LongitudeEnd
        LongitudeEnd = LongitudeStart + SliceAngle
        MeshIndex = AddMeshPie(Radius, Height, LongitudeStart, LongitudeEnd, LongitudeSteps)
        Call SetMeshColor(MeshIndex, ColorLongToRGB(Color(A)), 0.5)
        If LastMeshIndex <> 0 Then
            LastMeshIndex = AttachMeshes(MeshIndex, LastMeshIndex)
        Else
            LastMeshIndex = MeshIndex
        End If
    Next A
    Call CenterMesh(LastMeshIndex)
    AddMeshPieGraph = LastMeshIndex
    
End Function
Function AddMeshGeoSphere(Radius As Single, Iterations As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim MeshIndex As Integer
    
    MeshIndex = AddMeshSphere(Radius, 4, 2)
    If MeshIndex = 0 Then Exit Function
    
    For A = 1 To Iterations
        Call TessellateMeshByEdge(MeshIndex, 1)
        For B = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
            VVertex(B) = VectorScale(VectorNormalize(VVertex(B)), Radius)
        Next B
    Next A
    
    AddMeshGeoSphere = MeshIndex
    
End Function
Function AddMeshText(Text As String, A As Vector) As Integer

    Dim MeshIndex As Integer
    
    MeshIndex = AddMesh(1, 1)
    If MeshIndex = 0 Then Exit Function
    
    VVertex(VMesh(MeshIndex).Vertices.Start) = A
    VFace(VMesh(MeshIndex).Faces.Start).A = 0
    VFace(VMesh(MeshIndex).Faces.Start).B = 0
    VFace(VMesh(MeshIndex).Faces.Start).C = 0
    VMesh(MeshIndex).Tag = Text
    AddMeshText = MeshIndex
    
End Function
Function AddMeshTorus(RadiusA As Single, RadiusB As Single, LongitudeSteps As Integer, LatitudeSteps As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim LongitudeUnit As Single
    Dim LatitudeUnit As Single
    Dim LongitudeCurrent As Single
    Dim LatitudeCurrent As Single
    
    LongitudeUnit = (Pi * 2) / LongitudeSteps
    LatitudeUnit = (Pi * 2) / LatitudeSteps
    
    MeshIndex = AddMesh(0, 0)
    If MeshIndex = 0 Then Exit Function
    
    C = 1
    For A = 1 To LatitudeSteps + 1
        For B = 1 To LongitudeSteps + 1
        
            If VMesh(MeshIndex).Vertices.Start - 1 + C > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            LongitudeCurrent = (B - 1) * LongitudeUnit
            LatitudeCurrent = -(Pi / 2) + (A - 1) * LatitudeUnit
            VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                VectorAdd( _
                    VectorScale( _
                        OrientationToVector( _
                            OrientationInput( _
                                0, _
                                0, _
                                LongitudeCurrent _
                            ) _
                        ), _
                        RadiusA _
                    ), _
                    VectorScale( _
                        OrientationToVector( _
                            OrientationInput( _
                                0, _
                                LatitudeCurrent, _
                                LongitudeCurrent _
                            ) _
                        ), _
                        RadiusB _
                    ) _
                )
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Vertices.Length = C - 1
    
    C = 1
    For A = 1 To LatitudeSteps
        For B = 1 To LongitudeSteps
        
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Faces.Length = C - 1
    
    Call TrimMesh(MeshIndex)
    AddMeshTorus = FitMesh(MeshIndex)
    
End Function
Function AddMeshTetrahedron(Radius As Single) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim MeshIndex As Integer
    
    MeshIndex = AddMesh(4, 4)
    If MeshIndex = 0 Then Exit Function
    
    A = VMesh(MeshIndex).Vertices.Start
    
    VVertex(A + 0) = _
        VectorInput( _
            0, _
            0, _
            0 _
        )
        
    VVertex(A + 1) = _
        VectorInput( _
            1, _
            0, _
            1 _
        )
        
    VVertex(A + 2) = _
        VectorInput( _
            1, _
            1, _
            0 _
        )
        
    VVertex(A + 3) = _
        VectorInput( _
            0, _
            1, _
            1 _
        )
        
    B = VMesh(MeshIndex).Faces.Start
    
    VFace(B + 0).A = A + 1
    VFace(B + 0).B = A + 2
    VFace(B + 0).C = A + 3
    
    VFace(B + 1).A = A + 1
    VFace(B + 1).B = A + 0
    VFace(B + 1).C = A + 2
    
    VFace(B + 2).A = A + 2
    VFace(B + 2).B = A + 0
    VFace(B + 2).C = A + 3
    
    VFace(B + 3).A = A + 3
    VFace(B + 3).B = A + 0
    VFace(B + 3).C = A + 1
    
    Call CenterMesh(MeshIndex)
    
    Call _
        TransformMesh( _
            MeshIndex, _
            TransformationScale( _
                VectorScale( _
                    VectorUnit, _
                    Radius / VectorModulus(VVertex(A + 0)) _
                ) _
            ) _
        )
        
    AddMeshTetrahedron = MeshIndex
    
End Function

Function AddMeshLine(A As Vector, B As Vector) As Integer

    Dim MeshIndex As Integer
    
    MeshIndex = AddMesh(2, 1)
    If MeshIndex = 0 Then Exit Function
    
    VVertex(VMesh(MeshIndex).Vertices.Start) = A
    VVertex(VMesh(MeshIndex).Vertices.Start + 1) = B
    VFace(VMesh(MeshIndex).Faces.Start).A = 0
    VFace(VMesh(MeshIndex).Faces.Start).B = 0
    VFace(VMesh(MeshIndex).Faces.Start).C = 0
    AddMeshLine = MeshIndex
    
End Function
Function AddMeshCurve(A As Vector, B As Vector, C As Vector, D As Vector) As Integer

    Dim MeshIndex As Integer
    
    MeshIndex = AddMesh(4, 1)
    If MeshIndex = 0 Then Exit Function
    
    VVertex(VMesh(MeshIndex).Vertices.Start) = A
    VVertex(VMesh(MeshIndex).Vertices.Start + 1) = B
    VVertex(VMesh(MeshIndex).Vertices.Start + 2) = C
    VVertex(VMesh(MeshIndex).Vertices.Start + 3) = D
    VFace(VMesh(MeshIndex).Faces.Start).A = 0
    VFace(VMesh(MeshIndex).Faces.Start).B = 0
    VFace(VMesh(MeshIndex).Faces.Start).C = 0
    AddMeshCurve = MeshIndex
    
End Function
Function AddMeshPoint(A As Vector) As Integer

    Dim MeshIndex As Integer
    
    MeshIndex = AddMesh(1, 1)
    If MeshIndex = 0 Then Exit Function
    
    VVertex(VMesh(MeshIndex).Vertices.Start) = A
    VFace(VMesh(MeshIndex).Faces.Start).A = 0
    VFace(VMesh(MeshIndex).Faces.Start).B = 0
    VFace(VMesh(MeshIndex).Faces.Start).C = 0
    AddMeshPoint = MeshIndex
    
End Function
Function AddMeshBox(Dimensions As Vector) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim MeshIndex As Integer
    
    MeshIndex = AddMesh(8, 12)
    If MeshIndex = 0 Then Exit Function
    
    A = VMesh(MeshIndex).Vertices.Start
    
    VVertex(A + 0) = _
        VectorInput( _
            0, _
            0, _
            0 _
        )
        
    VVertex(A + 1) = _
        VectorInput( _
            Dimensions.X, _
            0, _
            0 _
        )
        
    VVertex(A + 2) = _
        VectorInput( _
            Dimensions.X, _
            0, _
            Dimensions.Z _
        )
        
    VVertex(A + 3) = _
        VectorInput( _
            0, _
            0, _
            Dimensions.Z _
        )
        
    VVertex(A + 4) = _
        VectorInput( _
            0, _
            Dimensions.Y, _
            0 _
        )
        
    VVertex(A + 5) = _
        VectorInput( _
            Dimensions.X, _
            Dimensions.Y, _
            0 _
        )
        
    VVertex(A + 6) = _
        VectorInput( _
            Dimensions.X, _
            Dimensions.Y, _
            Dimensions.Z _
        )
        
    VVertex(A + 7) = _
        VectorInput( _
            0, _
            Dimensions.Y, _
            Dimensions.Z _
        )
        
    B = VMesh(MeshIndex).Faces.Start
    
    VFace(B + 0).A = A + 0
    VFace(B + 0).B = A + 4
    VFace(B + 0).C = A + 5
    
    VFace(B + 1).A = A + 0
    VFace(B + 1).B = A + 5
    VFace(B + 1).C = A + 1
    
    VFace(B + 2).A = A + 1
    VFace(B + 2).B = A + 5
    VFace(B + 2).C = A + 6
    
    VFace(B + 3).A = A + 1
    VFace(B + 3).B = A + 6
    VFace(B + 3).C = A + 2
    
    VFace(B + 4).A = A + 2
    VFace(B + 4).B = A + 6
    VFace(B + 4).C = A + 7
    
    VFace(B + 5).A = A + 2
    VFace(B + 5).B = A + 7
    VFace(B + 5).C = A + 3
    
    VFace(B + 6).A = A + 3
    VFace(B + 6).B = A + 7
    VFace(B + 6).C = A + 4
    
    VFace(B + 7).A = A + 3
    VFace(B + 7).B = A + 4
    VFace(B + 7).C = A + 0
    
    VFace(B + 8).A = A + 3
    VFace(B + 8).B = A + 0
    VFace(B + 8).C = A + 1
    
    VFace(B + 9).A = A + 3
    VFace(B + 9).B = A + 1
    VFace(B + 9).C = A + 2
    
    VFace(B + 10).A = A + 4
    VFace(B + 10).B = A + 7
    VFace(B + 10).C = A + 6
    
    VFace(B + 11).A = A + 4
    VFace(B + 11).B = A + 6
    VFace(B + 11).C = A + 5
    
    AddMeshBox = MeshIndex
    
End Function
Function AddMeshGrid(X As Single, Z As Single, XSteps As Integer, ZSteps As Integer, DoubleSided As Boolean) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim WidthUnit As Single
    Dim LengthUnit As Single
    Dim WidthCurrent As Single
    Dim LengthCurrent As Single
    
    WidthUnit = X / XSteps
    LengthUnit = Z / ZSteps
    
    MeshIndex = AddMesh(0, 0)
    If MeshIndex = 0 Then Exit Function
    
    C = 1
    For A = 1 To ZSteps + 1
        For B = 1 To XSteps + 1
        
            If VMesh(MeshIndex).Vertices.Start - 1 + C > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            WidthCurrent = (B - 1) * WidthUnit
            LengthCurrent = (A - 1) * LengthUnit
            VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C).X = WidthCurrent
            VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C).Y = 0
            VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C).Z = LengthCurrent
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Vertices.Length = C - 1
    
    C = 1
    For A = 1 To ZSteps
        For B = 1 To XSteps
        
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (XSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (XSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (XSteps + 1) + B + 1
            C = C + 1
            
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (XSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (XSteps + 1) + B + 1
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (XSteps + 1) + B + 1
            C = C + 1
            
            If DoubleSided = True Then
            
                If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                    Call ShowError(1)
                    Call RemoveMesh(MeshIndex)
                    Exit Function
                End If
                VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                    VFace(VMesh(MeshIndex).Faces.Start - 1 + C - 2).A
                VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                    VFace(VMesh(MeshIndex).Faces.Start - 1 + C - 2).C
                VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                    VFace(VMesh(MeshIndex).Faces.Start - 1 + C - 2).B
                C = C + 1
                
                If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                    Call ShowError(1)
                    Call RemoveMesh(MeshIndex)
                    Exit Function
                End If
                VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                    VFace(VMesh(MeshIndex).Faces.Start - 1 + C - 2).A
                VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                    VFace(VMesh(MeshIndex).Faces.Start - 1 + C - 2).C
                VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                    VFace(VMesh(MeshIndex).Faces.Start - 1 + C - 2).B
                C = C + 1
                
            End If
            
        Next B
    Next A
    VMesh(MeshIndex).Faces.Length = C - 1
    
    Call TrimMesh(MeshIndex)
    AddMeshGrid = FitMesh(MeshIndex)
    
End Function
Function AddMeshSphere(Radius As Single, LongitudeSteps As Integer, LatitudeSteps As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim LongitudeUnit As Single
    Dim LatitudeUnit As Single
    Dim LongitudeCurrent As Single
    Dim LatitudeCurrent As Single
    
    LongitudeUnit = (Pi * 2) / LongitudeSteps
    LatitudeUnit = Pi / LatitudeSteps
    
    MeshIndex = AddMesh(0, 0)
    If MeshIndex = 0 Then Exit Function
    
    C = 1
    For A = 1 To LatitudeSteps + 1
        For B = 1 To LongitudeSteps + 1
        
            If VMesh(MeshIndex).Vertices.Start - 1 + C > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            LongitudeCurrent = (B - 1) * LongitudeUnit
            LatitudeCurrent = -(Pi / 2) + (A - 1) * LatitudeUnit
            VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                VectorScale( _
                    OrientationToVector( _
                        OrientationInput( _
                            0, _
                            LatitudeCurrent, _
                            LongitudeCurrent _
                        ) _
                    ), _
                    Radius _
                )
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Vertices.Length = C - 1
    
    C = 1
    For A = 1 To LatitudeSteps
        For B = 1 To LongitudeSteps
        
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Faces.Length = C - 1
    
    Call TrimMesh(MeshIndex)
    AddMeshSphere = FitMesh(MeshIndex)
    
End Function
Function AddMeshHemisphere(Radius As Single, LongitudeSteps As Integer, LatitudeSteps As Integer) As Integer

    'Const TopCap = 1
    'Const TopSteps = 1
    'Const LatitudeSteps = 1
    Const BottomSteps = 1
    Const BottomCap = 1
    'Const SideCap = 1
    
    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim LongitudeUnit As Single
    Dim LatitudeUnit As Single
    Dim LongitudeCurrent As Single
    Dim LatitudeCurrent As Single
    
    LongitudeUnit = (Pi * 2) / LongitudeSteps
    LatitudeUnit = (Pi / 2) / LatitudeSteps
    
    MeshIndex = AddMesh(0, 0)
    If MeshIndex = 0 Then Exit Function
    
    C = 1
    For A = 1 To LatitudeSteps + 1 + BottomCap
        For B = 1 To LongitudeSteps + 1
        
            If VMesh(MeshIndex).Vertices.Start - 1 + C > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            LongitudeCurrent = -(Pi / 2) + (A - 1) * LongitudeUnit
            LatitudeCurrent = (B - 1) * LatitudeUnit
            If A < LatitudeSteps + 1 + BottomCap Then
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorScale( _
                        OrientationToVector( _
                            OrientationInput( _
                                0, _
                                LongitudeCurrent, _
                                LatitudeCurrent _
                            ) _
                        ), _
                        Radius _
                    )
            End If
            If A = LatitudeSteps + 1 + BottomCap Then
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorInput(0, 0, 0)
            End If
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Vertices.Length = C - 1
    
    C = 1
    For A = 1 To LatitudeSteps + BottomSteps
        For B = 1 To LongitudeSteps
        
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Faces.Length = C - 1
    
    Call TrimMesh(MeshIndex)
    AddMeshHemisphere = FitMesh(MeshIndex)
    
End Function
Function AddMeshCylinder(Radius As Single, Height As Single, LongitudeSteps As Integer) As Integer

    Const TopCap = 1
    Const TopSteps = 1
    Const HeightSteps = 1
    Const BottomSteps = 1
    Const BottomCap = 1
    'Const SideCap = 1
    
    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim LongitudeUnit As Single
    Dim HeightUnit As Single
    Dim LongitudeCurrent As Single
    Dim HeightCurrent As Single
    
    LongitudeUnit = (2 * Pi) / LongitudeSteps
    HeightUnit = Height / HeightSteps
    
    MeshIndex = AddMesh(0, 0)
    If MeshIndex = 0 Then Exit Function
    
    C = 1
    For A = 1 To HeightSteps + 1 + TopCap + BottomCap
        For B = 1 To LongitudeSteps + 1
        
            If VMesh(MeshIndex).Vertices.Start - 1 + C > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            If A = 1 Then
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorInput(0, Height, 0)
            End If
            If A > 1 And A < HeightSteps + 1 + TopCap + BottomCap Then
                LongitudeCurrent = (B - 1) * LongitudeUnit
                HeightCurrent = Height - (A - 2) * HeightUnit
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorAdd( _
                        VectorInput(0, HeightCurrent, 0), _
                        VectorScale( _
                            OrientationToVector( _
                                OrientationInput( _
                                    0, _
                                    0, _
                                    LongitudeCurrent _
                                ) _
                            ), _
                            Radius _
                        ) _
                    )
            End If
            If A = HeightSteps + 1 + TopCap + BottomCap Then
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorInput(0, 0, 0)
            End If
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Vertices.Length = C - 1
    
    C = 1
    For A = 1 To HeightSteps + TopSteps + BottomSteps
        For B = 1 To LongitudeSteps
        
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Faces.Length = C - 1
    
    Call TrimMesh(MeshIndex)
    AddMeshCylinder = FitMesh(MeshIndex)
    
End Function
Function AddMeshPie(Radius As Single, Height As Single, LongitudeStart As Single, LongitudeEnd As Single, LongitudeSteps As Integer) As Integer

    Const TopCap = 1
    Const TopSteps = 1
    Const HeightSteps = 1
    Const BottomSteps = 1
    Const BottomCap = 1
    Const SideCap = 1
    
    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim LongitudeUnit As Single
    Dim HeightUnit As Single
    Dim LongitudeCurrent As Single
    Dim HeightCurrent As Single
    Dim FoundLongitudeStart As Boolean
    
    LongitudeUnit = (2 * Pi) / LongitudeSteps
    HeightUnit = Height / HeightSteps
    
    MeshIndex = AddMesh(0, 0)
    If MeshIndex = 0 Then Exit Function
    
    C = 1
    For A = 1 To HeightSteps + 1 + TopCap + BottomCap
        For B = 1 To LongitudeSteps + 1
        
            If VMesh(MeshIndex).Vertices.Start - 1 + C > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            If A = 1 Then
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorInput(0, Height, 0)
            End If
            If A > 1 And A < HeightSteps + 1 + TopCap + BottomCap Then
                LongitudeCurrent = (B - 1) * LongitudeUnit
                HeightCurrent = Height - (A - 2) * HeightUnit
                If FoundLongitudeStart = False Then
                    If Abs(LongitudeCurrent - DegreeToRadian(LongitudeStart)) <= LongitudeUnit Then
                        LongitudeCurrent = DegreeToRadian(LongitudeStart)
                        FoundLongitudeStart = True
                    End If
                Else
                    If Abs(LongitudeCurrent - DegreeToRadian(LongitudeEnd)) <= LongitudeUnit Then
                        LongitudeCurrent = DegreeToRadian(LongitudeEnd)
                        FoundLongitudeStart = False
                    End If
                End If
                If _
                    LongitudeCurrent >= DegreeToRadian(LongitudeStart) And _
                    LongitudeCurrent <= DegreeToRadian(LongitudeEnd) _
                        Then
                            VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                                VectorAdd( _
                                    VectorInput(0, HeightCurrent, 0), _
                                    VectorScale( _
                                        OrientationToVector( _
                                            OrientationInput( _
                                                0, _
                                                0, _
                                                LongitudeCurrent _
                                            ) _
                                        ), _
                                        Radius _
                                    ) _
                                )
                Else
                    VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                        VectorInput(0, HeightCurrent, 0)
                End If
            End If
            If A = HeightSteps + 1 + TopCap + BottomCap Then
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorInput(0, 0, 0)
            End If
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Vertices.Length = C - 1
    
    C = 1
    For A = 1 To HeightSteps + TopSteps + BottomSteps
        For B = 1 To LongitudeSteps + SideCap
        
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Faces.Length = C - 1
    
    Call TrimMesh(MeshIndex)
    AddMeshPie = FitMesh(MeshIndex)
    
End Function
Function AddMeshCone(Radius As Single, Height As Single, LongitudeSteps As Integer) As Integer

    Const TopCap = 1
    'Const TopSteps = 1
    Const HeightSteps = 1
    Const BottomSteps = 1
    Const BottomCap = 1
    'Const SideCap = 1
    
    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim MeshIndex As Integer
    Dim LongitudeUnit As Single
    Dim HeightUnit As Single
    Dim LongitudeCurrent As Single
    Dim HeightCurrent As Single
    
    LongitudeUnit = (2 * Pi) / LongitudeSteps
    HeightUnit = Height / HeightSteps
    
    MeshIndex = AddMesh(0, 0)
    If MeshIndex = 0 Then Exit Function
    
    C = 1
    For A = 1 To HeightSteps + TopCap + BottomCap
        For B = 1 To LongitudeSteps + 1
        
            If VMesh(MeshIndex).Vertices.Start - 1 + C > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            If A = 1 Then
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorInput(0, Height, 0)
            End If
            If A > 1 And A < HeightSteps + TopCap + BottomCap Then
                LongitudeCurrent = (B - 1) * LongitudeUnit
                HeightCurrent = Height - (A - 1) * HeightUnit
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorAdd( _
                        VectorInput(0, HeightCurrent, 0), _
                        VectorScale( _
                            OrientationToVector( _
                                OrientationInput( _
                                    0, _
                                    0, _
                                    LongitudeCurrent _
                                ) _
                            ), _
                            Radius _
                        ) _
                    )
            End If
            If A = HeightSteps + TopCap + BottomCap Then
                VVertex(VMesh(MeshIndex).Vertices.Start - 1 + C) = _
                    VectorInput(0, 0, 0)
            End If
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Vertices.Length = C - 1
    
    C = 1
    For A = 1 To HeightSteps + BottomSteps
        For B = 1 To LongitudeSteps
        
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
            If VMesh(MeshIndex).Faces.Start - 1 + C > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(MeshIndex)
                Exit Function
            End If
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).A = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).B = _
                VMesh(MeshIndex).Vertices.Start - 1 + A * (LongitudeSteps + 1) + B + 1
            VFace(VMesh(MeshIndex).Faces.Start - 1 + C).C = _
                VMesh(MeshIndex).Vertices.Start - 1 + (A - 1) * (LongitudeSteps + 1) + B + 1
            C = C + 1
            
        Next B
    Next A
    VMesh(MeshIndex).Faces.Length = C - 1
    
    Call TrimMesh(MeshIndex)
    AddMeshCone = FitMesh(MeshIndex)
    
End Function
