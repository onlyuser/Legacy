Attribute VB_Name = "ModuleI"
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

Function LandscapeMesh(MeshIndex As Integer, Height As Single)

    Dim A As Integer
    
    Randomize
    
    For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
        VVertex(A).Y = Rnd * Height
    Next A
    
End Function
Function SetMeshColorGradient(MeshIndex As Integer, Direction As Integer, ColorA As ColorRGB, ColorB As ColorRGB, Alpha As Single)

    Dim A As Integer
    Dim FacePosition As Single
    Dim Height As Single
    Dim CurrentHeight As Single
    
    Select Case Direction
        Case 1 'x axis
            Height = DimensionsMaximum(MeshIndex).X - DimensionsMinimum(MeshIndex).X
        Case 2 'y axis
            Height = DimensionsMaximum(MeshIndex).Y - DimensionsMinimum(MeshIndex).Y
        Case 3 'z axis
            Height = DimensionsMaximum(MeshIndex).Z - DimensionsMinimum(MeshIndex).Z
    End Select
    For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
        Select Case Direction
            Case 1 'x axis
                FacePosition = _
                    ( _
                        VVertex(VFace(A).A).X + _
                        VVertex(VFace(A).B).X + _
                        VVertex(VFace(A).C).X _
                    ) / _
                    3
                CurrentHeight = FacePosition - DimensionsMinimum(MeshIndex).X
            Case 2 'y axis
                FacePosition = _
                    ( _
                        VVertex(VFace(A).A).Y + _
                        VVertex(VFace(A).B).Y + _
                        VVertex(VFace(A).C).Y _
                    ) / _
                    3
                CurrentHeight = FacePosition - DimensionsMinimum(MeshIndex).Y
            Case 3 'z axis
                FacePosition = _
                    ( _
                        VVertex(VFace(A).A).Z + _
                        VVertex(VFace(A).B).Z + _
                        VVertex(VFace(A).C).Z _
                    ) / _
                    3
                CurrentHeight = FacePosition - DimensionsMinimum(MeshIndex).Z
        End Select
        If Height <> 0 Then
            VFace(A).Color = ColorInterpolate(ColorA, ColorB, CurrentHeight / Height)
        Else
            VFace(A).Color = ColorA
        End If
        VFace(A).Alpha = Alpha
    Next A
    
End Function
Function RippleMesh(MeshIndex As Integer, WaveLength As Single, Amplitude As Single, Shift As Single)

    Dim A As Integer
    
    For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
        VVertex(A).Y = _
            (Amplitude / 2) * _
            Sin( _
                VectorModulus(VVertex(A)) / _
                ( _
                    WaveLength / _
                    (2 * Pi) _
                ) + _
                Shift _
            )
    Next A
    
End Function
Function BlendMeshColor(MeshIndex As Integer, Color As ColorRGB, Alpha As Single, BlendRate As Single)

    Dim A As Integer
    
    For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
        VFace(A).Color = ColorInterpolate(VFace(A).Color, Color, BlendRate)
        VFace(A).Alpha = VFace(A).Alpha + (Alpha - VFace(A).Alpha) * BlendRate
    Next A
    
End Function
Function SetMeshRandom(MeshIndex As Integer, Dimensions As Vector)

    Dim A As Integer
    
    Randomize
    
    Call SetMeshBlank(MeshIndex)
    For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
        VVertex(A).X = Rnd * Dimensions.X
        VVertex(A).Y = Rnd * Dimensions.Y
        VVertex(A).Z = Rnd * Dimensions.Z
    Next A
    For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
        Do Until _
            (VFace(A).A <> VFace(A).B) And _
            (VFace(A).A <> VFace(A).C) And _
            (VFace(A).B <> VFace(A).C) And _
            (VFace(A).B <> VFace(A).A) And _
            (VFace(A).C <> VFace(A).A) And _
            (VFace(A).C <> VFace(A).B)
                VFace(A).A = VMesh(MeshIndex).Vertices.Start + Int(Rnd * VMesh(MeshIndex).Vertices.Length)
                VFace(A).B = VMesh(MeshIndex).Vertices.Start + Int(Rnd * VMesh(MeshIndex).Vertices.Length)
                VFace(A).C = VMesh(MeshIndex).Vertices.Start + Int(Rnd * VMesh(MeshIndex).Vertices.Length)
        Loop
    Next A
    
End Function
Function TessellateMeshByEdge(MeshIndex As Integer, Iterations As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim D As Integer
    
    TessellateMeshByEdge = UnlockMesh(MeshIndex)
    If TessellateMeshByEdge = 0 Then Exit Function
    
    C = VMesh(TessellateMeshByEdge).Vertices.Length + 1
    D = VMesh(TessellateMeshByEdge).Faces.Length + 1
    For A = 1 To Iterations
        For B = VMesh(TessellateMeshByEdge).Faces.Start To GetAddressLast(VMesh(TessellateMeshByEdge).Faces)
        
            If VMesh(TessellateMeshByEdge).Vertices.Start - 1 + 3 > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(TessellateMeshByEdge)
                Exit Function
            End If
            
            VVertex(VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C) = _
                VectorInterpolate(VVertex(VFace(B).A), VVertex(VFace(B).B), 0.5)
            C = C + 1
            
            VVertex(VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C) = _
                VectorInterpolate(VVertex(VFace(B).B), VVertex(VFace(B).C), 0.5)
            C = C + 1
            
            VVertex(VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C) = _
                VectorInterpolate(VVertex(VFace(B).C), VVertex(VFace(B).A), 0.5)
            C = C + 1
            
            If VMesh(TessellateMeshByEdge).Faces.Start - 1 + 3 > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(TessellateMeshByEdge)
                Exit Function
            End If
            
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).A = VFace(B).A
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).B = _
                VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 3
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).C = _
                VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 1
            D = D + 1
            
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).A = VFace(B).B
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).B = _
                VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 2
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).C = _
                VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 3
            D = D + 1
            
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).A = VFace(B).C
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).B = _
                VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 1
            VFace(VMesh(TessellateMeshByEdge).Faces.Start - 1 + D).C = _
                VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 2
            D = D + 1
            
            VFace(B).A = VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 2
            VFace(B).B = VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 1
            VFace(B).C = VMesh(TessellateMeshByEdge).Vertices.Start - 1 + C - 3
            
        Next B
        VMesh(TessellateMeshByEdge).Vertices.Length = C - 1
        VMesh(TessellateMeshByEdge).Faces.Length = D - 1
    Next A
    
    Call TrimMesh(TessellateMeshByEdge)
    TessellateMeshByEdge = FitMesh(TessellateMeshByEdge)
    
End Function
Function TessellateMeshByFace(MeshIndex As Integer, Iterations As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim D As Integer
    
    TessellateMeshByFace = UnlockMesh(MeshIndex)
    If TessellateMeshByFace = 0 Then Exit Function
    
    C = VMesh(TessellateMeshByFace).Vertices.Length + 1
    D = VMesh(TessellateMeshByFace).Faces.Length + 1
    For A = 1 To Iterations
        For B = VMesh(TessellateMeshByFace).Faces.Start To GetAddressLast(VMesh(TessellateMeshByFace).Faces)
        
            If VMesh(TessellateMeshByFace).Vertices.Start - 1 + 1 > UBound(VVertex) Then
                Call ShowError(1)
                Call RemoveMesh(TessellateMeshByFace)
                Exit Function
            End If
            
            VVertex(VMesh(TessellateMeshByFace).Vertices.Start - 1 + C).X = _
                ( _
                    VVertex(VFace(B).A).X + _
                    VVertex(VFace(B).B).X + _
                    VVertex(VFace(B).C).X _
                ) / _
                3
            VVertex(VMesh(TessellateMeshByFace).Vertices.Start - 1 + C).Y = _
                ( _
                    VVertex(VFace(B).A).Y + _
                    VVertex(VFace(B).B).Y + _
                    VVertex(VFace(B).C).Y _
                ) / _
                3
            VVertex(VMesh(TessellateMeshByFace).Vertices.Start - 1 + C).Z = _
                ( _
                    VVertex(VFace(B).A).Z + _
                    VVertex(VFace(B).B).Z + _
                    VVertex(VFace(B).C).Z _
                ) / _
                3
            C = C + 1
            
            If VMesh(TessellateMeshByFace).Faces.Start - 1 + 2 > UBound(VFace) Then
                Call ShowError(1)
                Call RemoveMesh(TessellateMeshByFace)
                Exit Function
            End If
            
            VFace(VMesh(TessellateMeshByFace).Faces.Start - 1 + D).A = VFace(B).B
            VFace(VMesh(TessellateMeshByFace).Faces.Start - 1 + D).B = VFace(B).C
            VFace(VMesh(TessellateMeshByFace).Faces.Start - 1 + D).C = _
                VMesh(TessellateMeshByFace).Vertices.Start - 1 + C - 1
            D = D + 1
            
            VFace(VMesh(TessellateMeshByFace).Faces.Start - 1 + D).A = VFace(B).C
            VFace(VMesh(TessellateMeshByFace).Faces.Start - 1 + D).B = VFace(B).A
            VFace(VMesh(TessellateMeshByFace).Faces.Start - 1 + D).C = _
                VMesh(TessellateMeshByFace).Vertices.Start - 1 + C - 1
            D = D + 1
            
            VFace(B).C = VMesh(TessellateMeshByFace).Vertices.Start - 1 + C - 1
            
        Next B
        VMesh(TessellateMeshByFace).Vertices.Length = C - 1
        VMesh(TessellateMeshByFace).Faces.Length = D - 1
    Next A
    
    TessellateMeshByFace = FitMesh(TessellateMeshByFace)
    
End Function
Function SetMeshColorRandom(MeshIndex As Integer)

    Dim A As Integer
    
    Randomize
    
    For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
        VFace(A).Color = ColorRandom
        VFace(A).Alpha = Rnd
    Next A
    
End Function
Function InvertMesh(MeshIndex As Integer)

    Dim A As Integer
    Dim B As Integer
    
    For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
        C = VFace(A).A
        VFace(A).A = VFace(A).B
        VFace(A).B = C
    Next A
    
End Function
