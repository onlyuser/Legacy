Attribute VB_Name = "Module2"
'TYPES

    'basic element
    
        'positioner
        
            Public Type Point2D
                X As Single
                Y As Single
            End Type
            
            Public Type Point3D
                X As Single
                Y As Single
                Z As Single
            End Type
            
            Public Type Bound2E
                Upper As Single
                Lower As Single
            End Type
            
        'identifyer
        
            Public Type Line2P
                A As Integer
                B As Integer
            End Type
            
            Public Type Range2E
                Bgn As Integer
                Fin As Integer
            End Type
            
    'complex element
    
        Public Type Point3DX
            Exist As Boolean
            Tag As String
            Pos As Point3D
            Color As ColorRGB
        End Type
        
        Public Type Line2PX
            Exist As Boolean
            Tag As String
            Struct As Line2P
            Color As ColorRGB
        End Type
        
    'bound
    
        Public Type Bound3D
            XBnd As Bound2E
            YBnd As Bound2E
            ZBnd As Bound2E
        End Type
        
    'vector
    
        Public Type Vector
            Trans As Point3D
            Rot As Point3D
        End Type
    
    'object
    
        Public Type Mesh
            Exist As Boolean
            Vis As Boolean
            Tag As String
            Edit As Boolean
            DrawStyle As Integer
            BoundBox As Integer
            VectAxis As Integer
            Vect As Vector
            PointRng As Range2E
            LineRng As Range2E
        End Type
        
        Public Type Camera
            Exist As Boolean
            Tag As String
            Vect As Vector
            FOV As Single
            Mode As String
            Filt As ColorRGB
            Atm As Boolean
            GradRng As Range2E
        End Type
        
    'world
    
        Public Type World
            MeshRng As Range2E
            CameraRng As Range2E
        End Type

'VARIABLES

    'element
    
        Public FPoint(1000) As Point3DX
        Public FLine(1000) As Line2PX

    'object
    
        Public FMesh(1000) As Mesh
        Public FCamera(1000) As Camera
        
    'world
    
        Public FWorld As World

    'system
    
        Public WPoint(1000) As Point3D
        Public CPoint(1000) As Point3D
        Public SPoint(1000) As Point2D
        
    'miscellanious
    
        Public Update As Boolean
        
        Public SelIndex%
        Public SelElem$
Function AddCamera()
    
    'appends new camera to camera array
    
    Dim A%
    Dim CameraIndex%
    
    FWorld.CameraRng.Bgn = 1
    
    CameraIndex = FWorld.CameraRng.Fin + 1
    FWorld.CameraRng.Fin = FWorld.CameraRng.Fin + 1
    
    FCamera(CameraIndex).Exist = True
    FCamera(CameraIndex).Tag = "Unnamed"
    FCamera(CameraIndex).FOV = 60
    FCamera(CameraIndex).Mode = "All"
    FCamera(CameraIndex).Filt.R = 1
    FCamera(CameraIndex).Filt.G = 1
    FCamera(CameraIndex).Filt.B = 1
    FCamera(CameraIndex).Atm = True
    FCamera(CameraIndex).GradRng.Bgn = 200
    FCamera(CameraIndex).GradRng.Fin = 400
    
End Function
Function DefragMeshes()

    'defragments world

    Dim A%
    Dim B%
    Dim LastPoint%
    Dim LastLine%
    Dim PointOffset%
    Dim LineOffset%
    Dim TempFpoint(1000) As Point3DX
    Dim TempFLine(1000) As Line2PX
    
    PointOffset = 0
    LineOffset = 0
    LastPoint = 0
    LastLine = 0
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            PointOffset = PointOffset + (FMesh(A).PointRng.Bgn - (LastPoint + 1))
            LineOffset = LineOffset + (FMesh(A).LineRng.Bgn - (LastLine + 1))
            If LastPoint + 1 < FMesh(A).PointRng.Bgn Then
                For B = LastPoint + 1 To FMesh(A).PointRng.Bgn - 1 Step 1
                    If FPoint(B).Exist Then
                        Call DelElem("Point", B)
                    End If
                Next B
            End If
            If LastPoint + 1 > FMesh(A).PointRng.Bgn Then
                For B = LastPoint To FMesh(A).PointRng.Bgn Step -1
                    If FPoint(B).Exist Then
                        Call DelElem("Point", B)
                    End If
                Next B
            End If
            If LastLine + 1 < FMesh(A).LineRng.Bgn Then
                For B = LastLine + 1 To FMesh(A).LineRng.Bgn - 1 Step 1
                    If FLine(B).Exist Then
                        Call DelElem("Line", B)
                    End If
                Next B
            End If
            If LastLine + 1 > FMesh(A).LineRng.Bgn Then
                For B = LastLine To FMesh(A).LineRng.Bgn Step -1
                    If FLine(B).Exist Then
                        Call DelElem("Line", B)
                    End If
                Next B
            End If
            LastPoint = FMesh(A).PointRng.Fin
            LastLine = FMesh(A).LineRng.Fin
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist Then
                    TempFpoint(B - PointOffset).Exist = FPoint(B).Exist
                    TempFpoint(B - PointOffset).Tag = FPoint(B).Tag
                    TempFpoint(B - PointOffset).Pos.X = FPoint(B).Pos.X
                    TempFpoint(B - PointOffset).Pos.Y = FPoint(B).Pos.Y
                    TempFpoint(B - PointOffset).Pos.Z = FPoint(B).Pos.Z
                    TempFpoint(B - PointOffset).Color.R = FPoint(B).Color.R
                    TempFpoint(B - PointOffset).Color.G = FPoint(B).Color.G
                    TempFpoint(B - PointOffset).Color.B = FPoint(B).Color.B
                End If
            Next B
            For B = FMesh(A).LineRng.Bgn To FMesh(A).LineRng.Fin
                If FLine(B).Exist Then
                    TempFLine(B - LineOffset).Exist = FLine(B).Exist
                    TempFLine(B - LineOffset).Tag = FLine(B).Tag
                    TempFLine(B - LineOffset).Struct.A = FLine(B).Struct.A - PointOffset
                    TempFLine(B - LineOffset).Struct.B = FLine(B).Struct.B - PointOffset
                    TempFLine(B - LineOffset).Color.R = FLine(B).Color.R
                    TempFLine(B - LineOffset).Color.G = FLine(B).Color.G
                    TempFLine(B - LineOffset).Color.B = FLine(B).Color.B
                End If
            Next B
            FMesh(A).PointRng.Bgn = FMesh(A).PointRng.Bgn - PointOffset
            FMesh(A).PointRng.Fin = FMesh(A).PointRng.Fin - PointOffset
            FMesh(A).LineRng.Bgn = FMesh(A).LineRng.Bgn - LineOffset
            FMesh(A).LineRng.Fin = FMesh(A).LineRng.Fin - LineOffset
        End If
    Next A
    
    PointOffset = 0
    LineOffset = 0
    LastPoint = 0
    LastLine = 0
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist Then
                    FPoint(B).Exist = TempFpoint(B).Exist
                    FPoint(B).Tag = TempFpoint(B).Tag
                    FPoint(B).Pos.X = TempFpoint(B).Pos.X
                    FPoint(B).Pos.Y = TempFpoint(B).Pos.Y
                    FPoint(B).Pos.Z = TempFpoint(B).Pos.Z
                    FPoint(B).Color.R = TempFpoint(B).Color.R
                    FPoint(B).Color.G = TempFpoint(B).Color.G
                    FPoint(B).Color.B = TempFpoint(B).Color.B
                End If
            Next B
            For B = FMesh(A).LineRng.Bgn To FMesh(A).LineRng.Fin
                If FLine(B).Exist Then
                    FLine(B).Exist = TempFLine(B).Exist
                    FLine(B).Tag = TempFLine(B).Tag
                    FLine(B).Struct.A = TempFLine(B).Struct.A
                    FLine(B).Struct.B = TempFLine(B).Struct.B
                    FLine(B).Color.R = TempFLine(B).Color.R
                    FLine(B).Color.G = TempFLine(B).Color.G
                    FLine(B).Color.B = TempFLine(B).Color.B
                End If
            Next B
        End If
    Next A
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).LineRng.Bgn To FMesh(A).LineRng.Fin
                If FLine(B).Exist Then
                    If _
                        (FPoint(FLine(B).Struct.A).Exist = False Or FPoint(FLine(B).Struct.B).Exist = False) Or _
                        ( _
                            ( _
                                FLine(B).Struct.A > FMesh(FMesh(A).BoundBox).PointRng.Bgn And _
                                FLine(B).Struct.A < FMesh(FMesh(A).BoundBox).PointRng.Fin _
                            ) And _
                            ( _
                                FLine(B).Struct.B > FMesh(FMesh(A).BoundBox).PointRng.Bgn And _
                                FLine(B).Struct.B < FMesh(FMesh(A).BoundBox).PointRng.Fin _
                            ) _
                        ) Or _
                        ( _
                            ( _
                                FLine(B).Struct.A > FMesh(FMesh(A).VectAxis).PointRng.Bgn And _
                                FLine(B).Struct.A < FMesh(FMesh(A).VectAxis).PointRng.Fin _
                            ) And _
                            ( _
                                FLine(B).Struct.B > FMesh(FMesh(A).VectAxis).PointRng.Bgn And _
                                FLine(B).Struct.B < FMesh(FMesh(A).VectAxis).PointRng.Fin _
                            ) _
                        ) _
                            Then
                                Call DelElem("Line", B)
                    End If
                End If
            Next B
        End If
    Next A
    
End Function

Function InsElem(Elem$, Index%, Tag$, Color As ColorRGB)

    'inserts an element

    If Elem = "Point" Then
        FPoint(Index).Exist = True
        FPoint(Index).Tag = Tag
        FPoint(Index).Color.R = Color.R
        FPoint(Index).Color.G = Color.G
        FPoint(Index).Color.B = Color.B
    End If
    If Elem = "Line" Then
        FLine(Index).Exist = True
        FLine(Index).Tag = Tag
        FLine(Index).Color.R = Color.R
        FLine(Index).Color.G = Color.G
        FLine(Index).Color.B = Color.B
    End If
    
End Function
Function DelElem(Elem$, Index%)

    'deletes an element

    If Elem = "Point" Then
        FPoint(Index).Exist = False
        FPoint(Index).Tag = ""
        FPoint(Index).Pos.X = 0
        FPoint(Index).Pos.Y = 0
        FPoint(Index).Pos.Z = 0
        FPoint(Index).Color.R = 0
        FPoint(Index).Color.G = 0
        FPoint(Index).Color.B = 0
    End If
    If Elem = "Line" Then
        FLine(Index).Exist = False
        FLine(Index).Tag = ""
        FLine(Index).Struct.A = 0
        FLine(Index).Struct.B = 0
        FLine(Index).Color.R = 0
        FLine(Index).Color.G = 0
        FLine(Index).Color.B = 0
    End If
    
End Function
Function ClearMeshes()

    'clears all meshes

    Dim A%
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            Call SetBlkMesh(A)
        End If
    Next A
    For A = FWorld.MeshRng.Fin To FWorld.MeshRng.Bgn Step -1
        If FMesh(A).Exist = True Then
            Call RemMesh
        End If
    Next A

End Function
Function ClearCameras()

    'clears all cameras

    Dim A%
    
    For A = FWorld.CameraRng.Fin To FWorld.CameraRng.Bgn Step -1
        Call RemCamera
    Next A

End Function

Function InScr(Scr As PictureBox, X!, Y!) As Boolean

    'determines if a point is in Scr

    If _
        (X > 0 And X < Scr.ScaleWidth) And _
        (Y > 0 And Y < Scr.ScaleHeight) _
            Then _
                InScr = True
    
End Function
Function MakeBoundBox(MeshIndex%, Color As ColorRGB)

    'makes a bounding box

    Dim A%
    Dim BufferA!
    Dim BufferB!
    Dim CurVal!
    Dim BestVal!
    Dim BoundBox As Bound3D
    
    If FMesh(MeshIndex).BoundBox <> 0 Then
        For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
            If FPoint(A).Exist = True Then BufferA = BufferA + 1
        Next A
        If BufferA <> 0 Then
            BufferB = 0
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then BufferB = BufferB + WPoint(A).X
            Next A
            BufferB = BufferB / BufferA
            BestVal = BufferB
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then
                    CurVal = WPoint(A).X
                    If CurVal < BestVal Then BestVal = CurVal
                End If
            Next A
            BoundBox.XBnd.Lower = BestVal
            BestVal = BufferB
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then
                    CurVal = WPoint(A).X
                    If CurVal > BestVal Then BestVal = CurVal
                End If
            Next A
            BoundBox.XBnd.Upper = BestVal
            BufferB = 0
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then BufferB = BufferB + WPoint(A).Y
            Next A
            BufferB = BufferB / BufferA
            BestVal = BufferB
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then
                    CurVal = WPoint(A).Y
                    If CurVal < BestVal Then BestVal = CurVal
                End If
            Next A
            BoundBox.YBnd.Lower = BestVal
            BestVal = BufferB
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then
                    CurVal = WPoint(A).Y
                    If CurVal > BestVal Then BestVal = CurVal
                End If
            Next A
            BoundBox.YBnd.Upper = BestVal
            BufferB = 0
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then BufferB = BufferB + WPoint(A).Z
            Next A
            BufferB = BufferB / BufferA
            BestVal = BufferB
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then
                    CurVal = WPoint(A).Z
                    If CurVal < BestVal Then BestVal = CurVal
                End If
            Next A
            BoundBox.ZBnd.Lower = BestVal
            BestVal = BufferB
            For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
                If FPoint(A).Exist = True Then
                    CurVal = WPoint(A).Z
                    If CurVal > BestVal Then BestVal = CurVal
                End If
            Next A
            BoundBox.ZBnd.Upper = BestVal
        Else
            BoundBox.XBnd.Lower = 0
            BoundBox.XBnd.Upper = 0
            BoundBox.YBnd.Lower = 0
            BoundBox.YBnd.Upper = 0
            BoundBox.ZBnd.Lower = 0
            BoundBox.ZBnd.Upper = 0
        End If
        Call MakeBox(FMesh(MeshIndex).BoundBox, BoundBox, Color)
        FMesh(FMesh(MeshIndex).BoundBox).Tag = ""
        FMesh(FMesh(MeshIndex).BoundBox).Edit = False
        FMesh(FMesh(MeshIndex).BoundBox).DrawStyle = 2
    End If
    
End Function
Function MakeBox(MeshIndex%, BoundBox As Bound3D, Color As ColorRGB)
    
    'makes a box
    
    Dim A%
    Dim BufferA%
    Dim BufferB%
    
    BufferA = FMesh(MeshIndex).PointRng.Bgn - 1
    FPoint(BufferA + 1).Pos.X = BoundBox.XBnd.Lower
    FPoint(BufferA + 1).Pos.Y = BoundBox.YBnd.Lower
    FPoint(BufferA + 1).Pos.Z = BoundBox.ZBnd.Lower
    FPoint(BufferA + 2).Pos.X = BoundBox.XBnd.Lower
    FPoint(BufferA + 2).Pos.Y = BoundBox.YBnd.Lower
    FPoint(BufferA + 2).Pos.Z = BoundBox.ZBnd.Upper
    FPoint(BufferA + 3).Pos.X = BoundBox.XBnd.Lower
    FPoint(BufferA + 3).Pos.Y = BoundBox.YBnd.Upper
    FPoint(BufferA + 3).Pos.Z = BoundBox.ZBnd.Lower
    FPoint(BufferA + 4).Pos.X = BoundBox.XBnd.Lower
    FPoint(BufferA + 4).Pos.Y = BoundBox.YBnd.Upper
    FPoint(BufferA + 4).Pos.Z = BoundBox.ZBnd.Upper
    FPoint(BufferA + 5).Pos.X = BoundBox.XBnd.Upper
    FPoint(BufferA + 5).Pos.Y = BoundBox.YBnd.Lower
    FPoint(BufferA + 5).Pos.Z = BoundBox.ZBnd.Lower
    FPoint(BufferA + 6).Pos.X = BoundBox.XBnd.Upper
    FPoint(BufferA + 6).Pos.Y = BoundBox.YBnd.Lower
    FPoint(BufferA + 6).Pos.Z = BoundBox.ZBnd.Upper
    FPoint(BufferA + 7).Pos.X = BoundBox.XBnd.Upper
    FPoint(BufferA + 7).Pos.Y = BoundBox.YBnd.Upper
    FPoint(BufferA + 7).Pos.Z = BoundBox.ZBnd.Lower
    FPoint(BufferA + 8).Pos.X = BoundBox.XBnd.Upper
    FPoint(BufferA + 8).Pos.Y = BoundBox.YBnd.Upper
    FPoint(BufferA + 8).Pos.Z = BoundBox.ZBnd.Upper
    FMesh(MeshIndex).PointRng.Fin = BufferA + 8
    BufferB = FMesh(MeshIndex).LineRng.Bgn - 1
    FLine(BufferB + 1).Struct.A = BufferA + 1
    FLine(BufferB + 1).Struct.B = BufferA + 2
    FLine(BufferB + 2).Struct.A = BufferA + 2
    FLine(BufferB + 2).Struct.B = BufferA + 4
    FLine(BufferB + 3).Struct.A = BufferA + 4
    FLine(BufferB + 3).Struct.B = BufferA + 3
    FLine(BufferB + 4).Struct.A = BufferA + 3
    FLine(BufferB + 4).Struct.B = BufferA + 1
    FLine(BufferB + 5).Struct.A = BufferA + 1
    FLine(BufferB + 5).Struct.B = BufferA + 5
    FLine(BufferB + 6).Struct.A = BufferA + 2
    FLine(BufferB + 6).Struct.B = BufferA + 6
    FLine(BufferB + 7).Struct.A = BufferA + 4
    FLine(BufferB + 7).Struct.B = BufferA + 8
    FLine(BufferB + 8).Struct.A = BufferA + 3
    FLine(BufferB + 8).Struct.B = BufferA + 7
    FLine(BufferB + 9).Struct.A = BufferA + 5
    FLine(BufferB + 9).Struct.B = BufferA + 6
    FLine(BufferB + 10).Struct.A = BufferA + 6
    FLine(BufferB + 10).Struct.B = BufferA + 8
    FLine(BufferB + 11).Struct.A = BufferA + 8
    FLine(BufferB + 11).Struct.B = BufferA + 7
    FLine(BufferB + 12).Struct.A = BufferA + 7
    FLine(BufferB + 12).Struct.B = BufferA + 5
    FMesh(MeshIndex).LineRng.Fin = BufferB + 12
    For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
        Call InsElem("Point", A, "", Color)
    Next A
    For A = FMesh(MeshIndex).LineRng.Bgn To FMesh(MeshIndex).LineRng.Fin
        Call InsElem("Line", A, "", Color)
    Next A
    FMesh(MeshIndex).Exist = True
    
End Function
Function MakeVectAxis(MeshIndex%, Color As ColorRGB, AxisLen!)
    
    'makes a vector axis
    
    Dim A%
    Dim BufferA%
    Dim BufferB%
    
    If FMesh(MeshIndex).VectAxis <> 0 Then
        BufferA = FMesh(FMesh(MeshIndex).VectAxis).PointRng.Bgn - 1
        FPoint(BufferA + 1).Pos.X = 0
        FPoint(BufferA + 1).Pos.Y = 0
        FPoint(BufferA + 1).Pos.Z = 0
        FPoint(BufferA + 2).Pos.X = 0 + AxisLen
        FPoint(BufferA + 2).Pos.Y = 0
        FPoint(BufferA + 2).Pos.Z = 0
        FPoint(BufferA + 3).Pos.X = 0
        FPoint(BufferA + 3).Pos.Y = 0 + AxisLen
        FPoint(BufferA + 3).Pos.Z = 0
        FPoint(BufferA + 4).Pos.X = 0
        FPoint(BufferA + 4).Pos.Y = 0
        FPoint(BufferA + 4).Pos.Z = 0 + AxisLen
        FMesh(FMesh(MeshIndex).VectAxis).PointRng.Fin = BufferA + 4
        BufferB = FMesh(FMesh(MeshIndex).VectAxis).LineRng.Bgn - 1
        FLine(BufferB + 1).Struct.A = BufferA + 1
        FLine(BufferB + 1).Struct.B = BufferA + 2
        FLine(BufferB + 2).Struct.A = BufferA + 1
        FLine(BufferB + 2).Struct.B = BufferA + 3
        FLine(BufferB + 3).Struct.A = BufferA + 1
        FLine(BufferB + 3).Struct.B = BufferA + 4
        FMesh(FMesh(MeshIndex).VectAxis).LineRng.Fin = BufferB + 3
        FMesh(FMesh(MeshIndex).VectAxis).Vect.Rot.X = FMesh(MeshIndex).Vect.Rot.X
        FMesh(FMesh(MeshIndex).VectAxis).Vect.Rot.Y = FMesh(MeshIndex).Vect.Rot.Y
        FMesh(FMesh(MeshIndex).VectAxis).Vect.Rot.Z = FMesh(MeshIndex).Vect.Rot.Z
        FMesh(FMesh(MeshIndex).VectAxis).Vect.Trans.X = FMesh(MeshIndex).Vect.Trans.X
        FMesh(FMesh(MeshIndex).VectAxis).Vect.Trans.Y = FMesh(MeshIndex).Vect.Trans.Y
        FMesh(FMesh(MeshIndex).VectAxis).Vect.Trans.Z = FMesh(MeshIndex).Vect.Trans.Z
        For A = FMesh(FMesh(MeshIndex).VectAxis).PointRng.Bgn To FMesh(FMesh(MeshIndex).VectAxis).PointRng.Fin
            Call InsElem("Point", A, "", Color)
        Next A
        For A = FMesh(FMesh(MeshIndex).VectAxis).LineRng.Bgn To FMesh(FMesh(MeshIndex).VectAxis).LineRng.Fin
            Call InsElem("Line", A, "", Color)
        Next A
        FPoint(BufferA + 2).Tag = "X"
        FPoint(BufferA + 3).Tag = "Y"
        FPoint(BufferA + 4).Tag = "Z"
        FMesh(FMesh(MeshIndex).VectAxis).Tag = ""
        FMesh(FMesh(MeshIndex).VectAxis).Edit = False
        FMesh(FMesh(MeshIndex).VectAxis).DrawStyle = 0
    End If
    
End Function
Function ObserveMesh(CameraIndex%, MeshIndex%, Radius!, Longitude!, Latitude!)

    'views mesh from an angle

    'Vect -> Vect

    Dim BufferA!
    Dim BufferB!
    
    FCamera(CameraIndex).Vect.Rot.X = 0
    FCamera(CameraIndex).Vect.Rot.Y = 0
    FCamera(CameraIndex).Vect.Rot.Z = 0
    
    FCamera(CameraIndex).Vect.Trans.X = 0
    FCamera(CameraIndex).Vect.Trans.Y = 0 - Radius
    FCamera(CameraIndex).Vect.Trans.Z = 0

    BufferA = _
        GetAng( _
            FCamera(CameraIndex).Vect.Trans.Y, _
            FCamera(CameraIndex).Vect.Trans.Z, _
            0, _
            0 _
        )
    BufferB = _
        GetDist( _
            FCamera(CameraIndex).Vect.Trans.Y - 0, _
            FCamera(CameraIndex).Vect.Trans.Z - 0, _
            0 _
        )
    FCamera(CameraIndex).Vect.Trans.Y = GetCoord("Opp", 0, 0, BufferA - Latitude, BufferB)
    FCamera(CameraIndex).Vect.Trans.Z = GetCoord("Adj", 0, 0, BufferA - Latitude, BufferB)

    FCamera(CameraIndex).Vect.Rot.X = FCamera(CameraIndex).Vect.Rot.X - Latitude 'x - pitch
       
    BufferA = _
        GetAng( _
            FCamera(CameraIndex).Vect.Trans.X, _
            FCamera(CameraIndex).Vect.Trans.Y, _
            0, _
            0 _
        )
    BufferB = _
        GetDist( _
            FCamera(CameraIndex).Vect.Trans.X - 0, _
            FCamera(CameraIndex).Vect.Trans.Y - 0, _
            0 _
        )
    FCamera(CameraIndex).Vect.Trans.X = GetCoord("Opp", 0, 0, BufferA + Longitude, BufferB)
    FCamera(CameraIndex).Vect.Trans.Y = GetCoord("Adj", 0, 0, BufferA + Longitude, BufferB)

    FCamera(CameraIndex).Vect.Rot.Y = FCamera(CameraIndex).Vect.Rot.Y + Longitude 'y - yaw
    
    FCamera(CameraIndex).Vect.Trans.X = FCamera(CameraIndex).Vect.Trans.X + FMesh(MeshIndex).Vect.Trans.X
    FCamera(CameraIndex).Vect.Trans.Y = FCamera(CameraIndex).Vect.Trans.Y + FMesh(MeshIndex).Vect.Trans.Y
    FCamera(CameraIndex).Vect.Trans.Z = FCamera(CameraIndex).Vect.Trans.Z + FMesh(MeshIndex).Vect.Trans.Z
    
End Function
Function AddMesh(PointNum%, LineNum%)

    'appends new mesh to mesh array

    Dim MeshIndex%
    Dim A%
    Dim BufferA%
    Dim BufferB%
    
    FWorld.MeshRng.Bgn = 1
    
    MeshIndex = FWorld.MeshRng.Fin + 1
    FWorld.MeshRng.Fin = FWorld.MeshRng.Fin + 1

    FMesh(MeshIndex).Exist = True
    FMesh(MeshIndex).Tag = "Unnamed"
    FMesh(MeshIndex).Vis = True
    FMesh(MeshIndex).Edit = True

    BufferB = 0
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        BufferA = FMesh(A).PointRng.Fin
        If BufferA > BufferB Then BufferB = BufferA
    Next A
    FMesh(MeshIndex).PointRng.Bgn = BufferB + 1
    FMesh(MeshIndex).PointRng.Fin = BufferB + 1 + PointNum - 1
    
    BufferB = 0
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        BufferA = FMesh(A).LineRng.Fin
        If BufferA > BufferB Then BufferB = BufferA
    Next A
    FMesh(MeshIndex).LineRng.Bgn = BufferB + 1
    FMesh(MeshIndex).LineRng.Fin = BufferB + 1 + LineNum - 1

End Function
Function RemCamera()
    
    'truncates last camera from camera array
    
    Dim CameraIndex%
    
    FWorld.CameraRng.Bgn = 1
    
    CameraIndex = FWorld.CameraRng.Fin
    FWorld.CameraRng.Fin = FWorld.CameraRng.Fin - 1
    
    If FWorld.CameraRng.Fin < FWorld.CameraRng.Bgn Then FWorld.CameraRng.Fin = FWorld.CameraRng.Bgn - 1
    
    FCamera(CameraIndex).Vect.Trans.X = 0
    FCamera(CameraIndex).Vect.Trans.Y = 0
    FCamera(CameraIndex).Vect.Trans.Z = 0
    
    FCamera(CameraIndex).Exist = False
    FCamera(CameraIndex).Tag = ""
    FCamera(CameraIndex).FOV = 0
    FCamera(CameraIndex).Mode = ""
    FCamera(CameraIndex).Filt.R = 0
    FCamera(CameraIndex).Filt.G = 0
    FCamera(CameraIndex).Filt.B = 0
    FCamera(CameraIndex).Atm = False
    FCamera(CameraIndex).GradRng.Bgn = 0
    FCamera(CameraIndex).GradRng.Fin = 0
    
End Function

Function RemMesh()
    
    'truncates last mesh from mesh array
    
    Dim MeshIndex%
    
    FWorld.MeshRng.Bgn = 1
    
    MeshIndex = FWorld.MeshRng.Fin
    FWorld.MeshRng.Fin = FWorld.MeshRng.Fin - 1
    
    If FWorld.MeshRng.Fin < FWorld.MeshRng.Bgn Then FWorld.MeshRng.Fin = FWorld.MeshRng.Bgn - 1
    
    Call SetBlkMesh(MeshIndex)
    
    FMesh(MeshIndex).Exist = False
    FMesh(MeshIndex).Tag = ""
    FMesh(MeshIndex).Vis = False
    FMesh(MeshIndex).DrawStyle = 0
    
    FMesh(MeshIndex).Vect.Trans.X = 0
    FMesh(MeshIndex).Vect.Trans.Y = 0
    FMesh(MeshIndex).Vect.Trans.Z = 0
    
    FMesh(MeshIndex).PointRng.Bgn = 0
    FMesh(MeshIndex).PointRng.Fin = 0
    FMesh(MeshIndex).LineRng.Bgn = 0
    FMesh(MeshIndex).LineRng.Fin = 0
    FMesh(MeshIndex).Vect.Rot.X = 0
    FMesh(MeshIndex).Vect.Rot.Y = 0
    FMesh(MeshIndex).Vect.Rot.Z = 0
    FMesh(MeshIndex).Vect.Trans.X = 0
    FMesh(MeshIndex).Vect.Trans.Y = 0
    FMesh(MeshIndex).Vect.Trans.Z = 0

End Function
Function ResetScr(Scr As PictureBox)
    
    'aligns screen system points to Scr
    
    'SPoint -> SPoint
    
    Dim A%
    Dim B%
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                SPoint(B).X = (Scr.ScaleWidth / 2) + SPoint(B).X
                SPoint(B).Y = Scr.ScaleHeight - ((Scr.ScaleHeight / 2) + SPoint(B).Y)
            Next B
        End If
    Next A
    
End Function
Function ProjView3D(CameraIndex%, Scr As PictureBox)
    
    'projects view in 3d

    'CPoint -> SPoint
    
    Dim A%
    Dim B%
    Dim BufferA!
    Dim BufferB!
    
    Call AlignMeshes
    Call AlignView(CameraIndex)

    If View = "Perceptive Camera (Ang)" Then
        For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
            If FMesh(A).Exist = True Then
                For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                    If FPoint(B).Exist = True Then
                        If CPoint(B).Z < 0 Then
                            SPoint(B).X = _
                                GetCoord( _
                                    "Opp", _
                                    0, _
                                    0, _
                                    GetAng(CPoint(B).X, CPoint(B).Y, 0, 0), _
                                    ( _
                                        Atn( _
                                            GetDist(CPoint(B).X - 0, CPoint(B).Y - 0, 0) / _
                                            Abs(CPoint(B).Z - 0) _
                                        ) * (180 / Pi) _
                                    ) / (FCamera(CameraIndex).FOV / 2) _
                                )
                            SPoint(B).Y = _
                                GetCoord( _
                                    "Adj", _
                                    0, _
                                    0, _
                                    GetAng(CPoint(B).X, CPoint(B).Y, 0, 0), _
                                    ( _
                                        Atn( _
                                            GetDist(CPoint(B).X - 0, CPoint(B).Y - 0, 0) / _
                                            Abs(CPoint(B).Z - 0) _
                                        ) * (180 / Pi) _
                                    ) / (FCamera(CameraIndex).FOV / 2) _
                                )
                        End If
                        If CPoint(B).Z = 0 Then
                            SPoint(B).X = _
                                GetCoord( _
                                    "Opp", _
                                    0, _
                                    0, _
                                    GetAng(CPoint(B).X, CPoint(B).Y, 0, 0), _
                                    90 / (FCamera(CameraIndex).FOV / 2) _
                                )
                            SPoint(B).Y = _
                                GetCoord( _
                                    "Adj", _
                                    0, _
                                    0, _
                                    GetAng(CPoint(B).X, CPoint(B).Y, 0, 0), _
                                    90 / (FCamera(CameraIndex).FOV / 2) _
                                )
                        End If
                        If CPoint(B).Z > 0 Then
                            SPoint(B).X = _
                                GetCoord( _
                                    "Opp", _
                                    0, _
                                    0, _
                                    GetAng(CPoint(B).X, CPoint(B).Y, 0, 0), _
                                    ( _
                                        180 - _
                                        Atn( _
                                            GetDist(CPoint(B).X - 0, CPoint(B).Y - 0, 0) / _
                                            Abs(CPoint(B).Z - 0) _
                                        ) * (180 / Pi) _
                                    ) / (FCamera(CameraIndex).FOV / 2) _
                                )
                            SPoint(B).Y = _
                                GetCoord( _
                                    "Adj", _
                                    0, _
                                    0, _
                                    GetAng(CPoint(B).X, CPoint(B).Y, 0, 0), _
                                    ( _
                                        180 - _
                                            Atn( _
                                                GetDist(CPoint(B).X - 0, CPoint(B).Y - 0, 0) / _
                                                Abs(CPoint(B).Z - 0) _
                                            ) * (180 / Pi) _
                                    ) / (FCamera(CameraIndex).FOV / 2) _
                                )
                        End If
                        SPoint(B).X = SPoint(B).X * (Scr.ScaleWidth / 2)
                        SPoint(B).Y = SPoint(B).Y * (Scr.ScaleHeight / 2)
                    End If
                Next B
            End If
        Next A
    Else
        BufferA = (Scr.ScaleWidth / 2) * (1 / (Tan((FCamera(CameraIndex).FOV / 2) * (Pi / 180))))
        If BufferA > 0 Then
            For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
                If FMesh(A).Exist = True And FMesh(A).Vis = True Then
                    For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                        If FPoint(B).Exist = True Then
                            If CPoint(B).Z < 0 Then
                                BufferB = Abs(BufferA / CPoint(B).Z)
                                SPoint(B).X = CPoint(B).X * BufferB
                                SPoint(B).Y = CPoint(B).Y * BufferB
                            End If
                        End If
                    Next B
                End If
            Next A
        End If
    End If
    
End Function

Function SetBlkMesh(MeshIndex%)
    
    'sets a blank mesh
    
    'FPoint -> FPoint
    
    Dim A%
    
    SelElem = ""
    SelIndex = 0
    
    For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
        If FPoint(A).Exist = True Then
            Call DelElem("Point", A)
        End If
    Next A
    
    For A = FMesh(MeshIndex).LineRng.Bgn To FMesh(MeshIndex).LineRng.Fin
        If FLine(A).Exist = True Then
            Call DelElem("Line", A)
        End If
    Next A
    
End Function
Function SetRndMesh(MeshIndex%, Radius!)
    
    'sets a random mesh
    
    'FPoint -> FPoint
    
    Dim A%
    Dim BufferA As ColorRGB
    Randomize
    
    SelElem = ""
    SelIndex = 0
    
    Call SetBlkMesh(MeshIndex)
    
    For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
        Do Until _
            GetDist(FPoint(A).Pos.X, FPoint(A).Pos.Y, FPoint(A).Pos.Z) < Radius And _
            GetDist(FPoint(A).Pos.X, FPoint(A).Pos.Y, FPoint(A).Pos.Z) <> 0
                FPoint(A).Pos.X = Radius - 2 * Radius * Rnd
                FPoint(A).Pos.Y = Radius - 2 * Radius * Rnd
                FPoint(A).Pos.Z = Radius - 2 * Radius * Rnd
        Loop
        BufferA = Pal(Int(Rnd * 7)).Color
        Call InsElem("Point", A, "", BufferA)
    Next A
    
    For A = FMesh(MeshIndex).LineRng.Bgn To FMesh(MeshIndex).LineRng.Fin
        Do Until FLine(A).Struct.A <> FLine(A).Struct.B
            FLine(A).Struct.A = Int((FMesh(MeshIndex).PointRng.Fin - FMesh(MeshIndex).PointRng.Bgn + 1) * Rnd + FMesh(MeshIndex).PointRng.Bgn)
            FLine(A).Struct.B = Int((FMesh(MeshIndex).PointRng.Fin - FMesh(MeshIndex).PointRng.Bgn + 1) * Rnd + FMesh(MeshIndex).PointRng.Bgn)
        Loop
        BufferA = Pal(Int(Rnd * 7)).Color
        Call InsElem("Line", A, "", BufferA)
    Next A

End Function
Function ProjView2D(CameraIndex%, Scr As PictureBox, View$, Zoom!, XOffset!, YOffset!)

    'projects view in 2d

    'CPoint -> SPoint

    Dim A%
    Dim B%
    
    Call AlignMeshes
    
    If View = "Linear Camera" Then
        Call AlignView(CameraIndex)
        For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
            If FMesh(A).Exist = True Then
                For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                    If FPoint(B).Exist = True Then
                        SPoint(B).X = CPoint(B).X
                        SPoint(B).Y = CPoint(B).Y
                    End If
                Next B
            End If
        Next A
    Else
        For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
            If FMesh(A).Exist = True Then
                For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                    If FPoint(B).Exist = True Then
                        CPoint(B).X = WPoint(B).X
                        CPoint(B).Y = WPoint(B).Y
                        CPoint(B).Z = WPoint(B).Z
                    End If
                Next B
            End If
        Next A
        For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
            If FMesh(A).Exist = True Then
                For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                    If FPoint(B).Exist = True Then
                        If View = "Top" Then
                            SPoint(B).X = CPoint(B).X
                            SPoint(B).Y = CPoint(B).Y
                        End If
                        If View = "Back" Then
                            SPoint(B).X = CPoint(B).X
                            SPoint(B).Y = CPoint(B).Z
                        End If
                        If View = "Right" Then
                            SPoint(B).X = CPoint(B).Y
                            SPoint(B).Y = CPoint(B).Z
                        End If
                        If View = "Bottom" Then
                            SPoint(B).X = -CPoint(B).X
                            SPoint(B).Y = CPoint(B).Y
                        End If
                        If View = "Front" Then
                            SPoint(B).X = -CPoint(B).X
                            SPoint(B).Y = CPoint(B).Z
                        End If
                        If View = "Left" Then
                            SPoint(B).X = -CPoint(B).Y
                            SPoint(B).Y = CPoint(B).Z
                        End If
                    End If
                Next B
            End If
        Next A
    End If
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist = True Then
                    SPoint(B).X = SPoint(B).X * Zoom + OffsetX
                    SPoint(B).Y = SPoint(B).Y * Zoom + OffsetY
                End If
            Next B
        End If
    Next A
    
End Function
Function AlignView(CameraIndex%)

    'aligns camera system points to camera vector

    'WPoint -> CPoint
    
    Dim A%
    Dim B%
    Dim BufferA!
    Dim BufferB!
        
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist = True Then
                    CPoint(B).X = WPoint(B).X - FCamera(CameraIndex).Vect.Trans.X
                    CPoint(B).Y = WPoint(B).Y - FCamera(CameraIndex).Vect.Trans.Y
                    CPoint(B).Z = WPoint(B).Z - FCamera(CameraIndex).Vect.Trans.Z
                End If
            Next B
        End If
    Next A
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist = True Then
                    BufferA = _
                        GetAng( _
                            CPoint(B).X, _
                            CPoint(B).Y, _
                            0, _
                            0 _
                        )
                    BufferB = _
                        GetDist( _
                            CPoint(B).X - 0, _
                            CPoint(B).Y - 0, _
                            0 _
                        )
                    CPoint(B).X = GetCoord("Opp", 0, 0, (BufferA - (0 + FCamera(CameraIndex).Vect.Rot.Y)), BufferB) 'z - yaw
                    CPoint(B).Y = GetCoord("Adj", 0, 0, (BufferA - (0 + FCamera(CameraIndex).Vect.Rot.Y)), BufferB)
                    BufferA = _
                        GetAng( _
                            CPoint(B).Y, _
                            CPoint(B).Z, _
                            0, _
                            0 _
                        )
                    BufferB = _
                        GetDist( _
                            CPoint(B).Y - 0, _
                            CPoint(B).Z - 0, _
                            0 _
                        )
                    CPoint(B).Y = GetCoord("Opp", 0, 0, (BufferA - (90 + FCamera(CameraIndex).Vect.Rot.X)), BufferB) 'x - pitch
                    CPoint(B).Z = GetCoord("Adj", 0, 0, (BufferA - (90 + FCamera(CameraIndex).Vect.Rot.X)), BufferB)
                    BufferA = _
                        GetAng( _
                            CPoint(B).X, _
                            CPoint(B).Y, _
                            0, _
                            0 _
                        )
                    BufferB = _
                        GetDist( _
                            CPoint(B).X - 0, _
                            CPoint(B).Y - 0, _
                            0 _
                        )
                    CPoint(B).X = GetCoord("Opp", 0, 0, (BufferA - (0 + FCamera(CameraIndex).Vect.Rot.Z)), BufferB) 'z - roll
                    CPoint(B).Y = GetCoord("Adj", 0, 0, (BufferA - (0 + FCamera(CameraIndex).Vect.Rot.Z)), BufferB)
                End If
            Next B
        End If
    Next A

End Function
Function DrawView(CameraIndex%, Scr As PictureBox)
    
    'draws view on Scr
    
    'SPoint -> Scr
    
    Dim A%
    Dim B%
    Dim BufferA!
    Dim BufferB As Long
    
    Call ResetScr(Scr)
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True And FMesh(A).Vis = True Then
            Scr.DrawStyle = FMesh(A).DrawStyle
            If FCamera(CameraIndex).Mode = "Point" Or FCamera(CameraIndex).Mode = "All" Then
                For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                    If FPoint(B).Exist = True Then
                        If _
                            InScr( _
                                Scr, _
                                SPoint(B).X, _
                                SPoint(B).Y _
                            ) = _
                                True _
                                    Then
                                        If FCamera(CameraIndex).Atm = True Then
                                            BufferA = _
                                                GetDist( _
                                                    CPoint(B).X - 0, _
                                                    CPoint(B).Y - 0, _
                                                    CPoint(B).Z - 0 _
                                                )
                                            BufferA = _
                                                1 - _
                                                (BufferA - FCamera(CameraIndex).GradRng.Bgn) / _
                                                (FCamera(CameraIndex).GradRng.Fin - FCamera(CameraIndex).GradRng.Bgn)
                                            If BufferA > 1 Then BufferA = 1
                                            If BufferA < 0 Then BufferA = 0
                                        End If
                                        If FCamera(CameraIndex).Atm = False Or FMesh(A).Edit = False Then
                                            BufferA = 1
                                        End If
                                        BufferB = _
                                            RGB( _
                                                FPoint(B).Color.R * FCamera(CameraIndex).Filt.R * BufferA, _
                                                FPoint(B).Color.G * FCamera(CameraIndex).Filt.G * BufferA, _
                                                FPoint(B).Color.B * FCamera(CameraIndex).Filt.B * BufferA _
                                            )
                                        Scr.PSet _
                                            (SPoint(B).X, SPoint(B).Y), _
                                            BufferB
                                        If FPoint(B).Tag <> "" Then
                                            Scr.CurrentX = SPoint(B).X
                                            Scr.CurrentY = SPoint(B).Y
                                            Scr.ForeColor = RGB(FPoint(B).Color.R, FPoint(B).Color.G, FPoint(B).Color.B)
                                            Scr.Print FPoint(B).Tag
                                            Scr.ForeColor = vbBlack
                                        End If
                        End If
                    End If
                Next B
            End If
            If FCamera(CameraIndex).Mode = "Line" Or FCamera(CameraIndex).Mode = "All" Then
                For B = FMesh(A).LineRng.Bgn To FMesh(A).LineRng.Fin
                    If FLine(B).Exist = True Then
                        If _
                            InScr( _
                                Scr, _
                                (SPoint(FLine(B).Struct.A).X + SPoint(FLine(B).Struct.B).X) / 2, _
                                (SPoint(FLine(B).Struct.A).Y + SPoint(FLine(B).Struct.B).Y) / 2 _
                            ) = _
                                True _
                                    Then
                                        If FCamera(CameraIndex).Atm = True Then
                                            BufferA = _
                                                GetDist( _
                                                    (CPoint(FLine(B).Struct.A).X + CPoint(FLine(B).Struct.B).X) / 2 - 0, _
                                                    (CPoint(FLine(B).Struct.A).Y + CPoint(FLine(B).Struct.B).Y) / 2 - 0, _
                                                    (CPoint(FLine(B).Struct.A).Z + CPoint(FLine(B).Struct.B).Z) / 2 - 0 _
                                                )
                                            BufferA = _
                                                1 - _
                                                (BufferA - FCamera(CameraIndex).GradRng.Bgn) / _
                                                (FCamera(CameraIndex).GradRng.Fin - FCamera(CameraIndex).GradRng.Bgn)
                                            If BufferA > 1 Then BufferA = 1
                                            If BufferA < 0 Then BufferA = 0
                                        End If
                                        If FCamera(CameraIndex).Atm = False Or FMesh(A).Edit = False Then
                                            BufferA = 1
                                        End If
                                        BufferB = _
                                            RGB( _
                                                FLine(B).Color.R * FCamera(CameraIndex).Filt.R * BufferA, _
                                                FLine(B).Color.G * FCamera(CameraIndex).Filt.G * BufferA, _
                                                FLine(B).Color.B * FCamera(CameraIndex).Filt.B * BufferA _
                                            )
                                        Scr.Line _
                                            (SPoint(FLine(B).Struct.A).X, SPoint(FLine(B).Struct.A).Y)- _
                                            (SPoint(FLine(B).Struct.B).X, SPoint(FLine(B).Struct.B).Y), _
                                            BufferB
                                        If FLine(B).Tag <> "" Then
                                            Scr.CurrentX = (SPoint(FLine(B).Struct.A).X + SPoint(FLine(B).Struct.B).X) / 2
                                            Scr.CurrentY = (SPoint(FLine(B).Struct.A).Y + SPoint(FLine(B).Struct.B).Y) / 2
                                            Scr.ForeColor = RGB(FLine(B).Color.R, FLine(B).Color.G, FLine(B).Color.B)
                                            Scr.Print FLine(B).Tag
                                            Scr.ForeColor = vbBlack
                                        End If
                        End If
                    End If
                Next B
            End If
            Scr.DrawStyle = 0
        End If
    Next A

    If SelElem <> "" Then
        If SelElem = "Point" Then
            Scr.Circle _
                ( _
                    SPoint(SelIndex).X, _
                    SPoint(SelIndex).Y _
                ), _
                2, _
                vbRed
            Scr.CurrentX = SPoint(SelIndex).X
            Scr.CurrentY = SPoint(SelIndex).Y
        End If
        If SelElem = "Line" Then
            Scr.Circle _
                ( _
                    SPoint(FLine(SelIndex).Struct.A).X, _
                    SPoint(FLine(SelIndex).Struct.A).Y _
                ), _
                2, _
                vbRed
            Scr.DrawStyle = 2
            Scr.Line _
                ( _
                    SPoint(FLine(SelIndex).Struct.A).X, _
                    SPoint(FLine(SelIndex).Struct.A).Y _
                )- _
                ( _
                    SPoint(FLine(SelIndex).Struct.B).X, _
                    SPoint(FLine(SelIndex).Struct.B).Y _
                ), _
                vbRed
            Scr.DrawStyle = 0
            Scr.Circle _
                ( _
                    SPoint(FLine(SelIndex).Struct.B).X, _
                    SPoint(FLine(SelIndex).Struct.B).Y _
                ), _
                2, _
                vbRed
            Scr.CurrentX = (SPoint(FLine(SelIndex).Struct.A).X + SPoint(FLine(SelIndex).Struct.B).X) / 2
            Scr.CurrentY = (SPoint(FLine(SelIndex).Struct.A).Y + SPoint(FLine(SelIndex).Struct.B).Y) / 2
        End If
        Scr.ForeColor = vbRed
        Scr.Print SelElem & " " & Format$(SelIndex)
        Scr.ForeColor = vbBlack
    End If

End Function
Function OpenWorld(FileName$, Merge As Boolean)

    'opens world from file

    Dim A%
    Dim CurData$
    Dim CurType$
    Dim CurField$
    Dim CurRecord$
    Dim InitPoint%
    Dim InitLine%
    Dim InitMesh%
    
    SelElem = ""
    SelIndex = 0
    
    If Merge = True Then
        InitPoint = FMesh(FWorld.MeshRng.Fin).PointRng.Fin
        InitLine = FMesh(FWorld.MeshRng.Fin).LineRng.Fin
        InitMesh = FWorld.MeshRng.Fin
    Else
        Call ClearMeshes
    End If
    
    Open FileName For Input As 1
    
        Do Until EOF(1)
                    
            Line Input #1, CurData
            
            If CntStr(CurData, "> ") = 0 Then GoTo FoundItem
            
            CurField = GetBtw(CurData, "> ", " =", 1)
            CurRecord = GetBtw(CurData, "[", "]", 1)
            
            If CurField = "Data" Then
                CurType = CurRecord
                GoTo FoundItem
            End If
            
            If CurField = "Index" Then
                A = CurRecord
                GoTo FoundItem
            End If
            
            If CurType = "World" Then
                If Merge = False Then
                    If CurField = "MeshRng.Bgn" Then
                        If CurRecord <> 0 Then FWorld.MeshRng.Bgn = CurRecord
                        GoTo FoundItem
                    End If
                End If
                If CurField = "MeshRng.Fin" Then
                    If CurRecord <> 0 Then FWorld.MeshRng.Fin = InitMesh + CurRecord
                    GoTo FoundItem
                End If
            End If
            
            If CurType = "Mesh" Then
                If CurField = "Exist" Then
                    FMesh(InitMesh + A).Exist = StrToBool(CurRecord)
                    GoTo FoundItem
                End If
                If CurField = "Vis" Then
                    FMesh(InitMesh + A).Vis = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Tag" Then
                    FMesh(InitMesh + A).Tag = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Edit" Then
                    FMesh(InitMesh + A).Edit = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "DrawStyle" Then
                    FMesh(InitMesh + A).DrawStyle = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "BoundBox" Then
                    If CurRecord <> 0 Then FMesh(InitMesh + A).BoundBox = InitMesh + CurRecord
                    GoTo FoundItem
                End If
                If CurField = "VectAxis" Then
                    If CurRecord <> 0 Then FMesh(InitMesh + A).VectAxis = InitMesh + CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Rot.X" Then
                    FMesh(InitMesh + A).Vect.Rot.X = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Rot.Y" Then
                    FMesh(InitMesh + A).Vect.Rot.Y = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Rot.Z" Then
                    FMesh(InitMesh + A).Vect.Rot.Z = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Trans.X" Then
                    FMesh(InitMesh + A).Vect.Trans.X = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Trans.Y" Then
                    FMesh(InitMesh + A).Vect.Trans.Y = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Trans.Z" Then
                    FMesh(InitMesh + A).Vect.Trans.Z = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "PointRng.Bgn" Then
                    If CurRecord <> 0 Then FMesh(InitMesh + A).PointRng.Bgn = InitPoint + CurRecord
                    GoTo FoundItem
                End If
                If CurField = "PointRng.Fin" Then
                    If CurRecord <> 0 Then FMesh(InitMesh + A).PointRng.Fin = InitPoint + CurRecord
                    GoTo FoundItem
                End If
                If CurField = "LineRng.Bgn" Then
                    If CurRecord <> 0 Then FMesh(InitMesh + A).LineRng.Bgn = InitLine + CurRecord
                    GoTo FoundItem
                End If
                If CurField = "LineRng.Fin" Then
                    If CurRecord <> 0 Then FMesh(InitMesh + A).LineRng.Fin = InitLine + CurRecord
                    GoTo FoundItem
                End If
            End If
            
            If CurType = "Point" Then
                If CurField = "Exist" Then
                    FPoint(InitPoint + A).Exist = StrToBool(CurRecord)
                    GoTo FoundItem
                End If
                If CurField = "Tag" Then
                    FPoint(InitPoint + A).Tag = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Pos.X" Then
                    FPoint(InitPoint + A).Pos.X = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Pos.Y" Then
                    FPoint(InitPoint + A).Pos.Y = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Pos.Z" Then
                    FPoint(InitPoint + A).Pos.Z = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Color.R" Then
                    FPoint(InitPoint + A).Color.R = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Color.G" Then
                    FPoint(InitPoint + A).Color.G = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Color.B" Then
                    FPoint(InitPoint + A).Color.B = CurRecord
                    GoTo FoundItem
                End If
            End If
            
            If CurType = "Line" Then
                If CurField = "Exist" Then
                    FLine(InitLine + A).Exist = StrToBool(CurRecord)
                    GoTo FoundItem
                End If
                If CurField = "Tag" Then
                    FLine(InitLine + A).Tag = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Struct.A" Then
                    If CurRecord <> 0 Then FLine(InitLine + A).Struct.A = InitPoint + CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Struct.B" Then
                    If CurRecord <> 0 Then FLine(InitLine + A).Struct.B = InitPoint + CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Color.R" Then
                    FLine(InitLine + A).Color.R = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Color.G" Then
                    FLine(InitLine + A).Color.G = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Color.B" Then
                    FLine(InitLine + A).Color.B = CurRecord
                    GoTo FoundItem
                End If
            End If
            
FoundItem:
            
        Loop
        
    Close 1

End Function
Function SaveWorld(FileName$)

    'saves world to file

    Dim A%
    Dim B%
    Dim BufferA$

    Open FileName For Output As 1
        
        BufferA = BufferA + vbCrLf
        BufferA = BufferA + "> " + "Data = [" + "World" + "]" + vbCrLf
        
        BufferA = BufferA + vbCrLf
        BufferA = BufferA + "> " + "MeshRng.Bgn = [" + Format$(FWorld.MeshRng.Bgn) + "]" + vbCrLf
        BufferA = BufferA + "> " + "MeshRng.Fin = [" + Format$(FWorld.MeshRng.Fin) + "]" + vbCrLf
        
        For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
            If FMesh(A).Exist = True Then
            
                BufferA = BufferA + vbTab + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Data = [" + "Mesh" + "]" + vbCrLf
                
                BufferA = BufferA + vbTab + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Index = [" + Format$(A) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Exist = [" + Format$(FMesh(A).Exist) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Vis = [" + Format$(FMesh(A).Vis) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Tag = [" + Format$(FMesh(A).Tag) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Edit = [" + Format$(FMesh(A).Edit) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "DrawStyle = [" + Format$(FMesh(A).DrawStyle) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "BoundBox = [" + Format$(FMesh(A).BoundBox) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "VectAxis = [" + Format$(FMesh(A).VectAxis) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Vect.Rot.X = [" + Format$(FMesh(A).Vect.Rot.X) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Vect.Rot.Y = [" + Format$(FMesh(A).Vect.Rot.Y) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Vect.Rot.Z = [" + Format$(FMesh(A).Vect.Rot.Z) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Vect.Trans.X = [" + Format$(FMesh(A).Vect.Trans.X) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Vect.Trans.Y = [" + Format$(FMesh(A).Vect.Trans.Y) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "Vect.Trans.Z = [" + Format$(FMesh(A).Vect.Trans.Z) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "PointRng.Bgn = [" + Format$(FMesh(A).PointRng.Bgn) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "PointRng.Fin = [" + Format$(FMesh(A).PointRng.Fin) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "LineRng.Bgn = [" + Format$(FMesh(A).LineRng.Bgn) + "]" + vbCrLf
                BufferA = BufferA + vbTab + "> " + "LineRng.Fin = [" + Format$(FMesh(A).LineRng.Fin) + "]" + vbCrLf
                
                BufferA = BufferA + vbTab + vbTab + vbCrLf
                BufferA = BufferA + vbTab + vbTab + "> " + "Data = [" + "Point" + "]" + vbCrLf
                
                For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                    If FPoint(B).Exist = True Then
                    
                        BufferA = BufferA + vbTab + vbTab + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Index = [" + Format$(Format$(B)) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Exist = [" + Format$(FPoint(B).Exist) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Tag = [" + Format$(FPoint(B).Tag) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Pos.X = [" + Format$(FPoint(B).Pos.X) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Pos.Y = [" + Format$(FPoint(B).Pos.Y) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Pos.Z = [" + Format$(FPoint(B).Pos.Z) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Color.R = [" + Format$(FPoint(B).Color.R) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Color.G = [" + Format$(FPoint(B).Color.G) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Color.B = [" + Format$(FPoint(B).Color.B) + "]" + vbCrLf
                    
                    End If
                Next B
                
                BufferA = BufferA + vbTab + vbTab + vbCrLf
                BufferA = BufferA + vbTab + vbTab + "> " + "Data = [" + "Line" + "]" + vbCrLf
                
                For B = FMesh(A).LineRng.Bgn To FMesh(A).LineRng.Fin
                    If FLine(B).Exist = True Then
                    
                        BufferA = BufferA + vbTab + vbTab + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Index = [" + Format$(Format$(B)) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Exist = [" + Format$(FLine(B).Exist) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Tag = [" + Format$(FLine(B).Tag) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Struct.A = [" + Format$(FLine(B).Struct.A) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Struct.B = [" + Format$(FLine(B).Struct.B) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Color.R = [" + Format$(FLine(B).Color.R) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Color.G = [" + Format$(FLine(B).Color.G) + "]" + vbCrLf
                        BufferA = BufferA + vbTab + vbTab + "> " + "Color.B = [" + Format$(FLine(B).Color.B) + "]" + vbCrLf
                    
                    End If
                Next B
                
            End If
        Next A

        Print #1, BufferA
        
    Close 1

End Function
Function AlignMeshes()
    
    'aligns mesh point to mesh vector
    
    'FPoint -> WPoint
    
    Dim A%
    Dim B%
    Dim BufferA!
    Dim BufferB!
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist = True Then
                    WPoint(B).X = FPoint(B).Pos.X
                    WPoint(B).Y = FPoint(B).Pos.Y
                    WPoint(B).Z = FPoint(B).Pos.Z
                End If
            Next B
        End If
    Next A

    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist = True Then
                    BufferA = _
                        GetAng( _
                            WPoint(B).Z, _
                            WPoint(B).X, _
                            0, _
                            0 _
                        )
                    BufferB = _
                        GetDist( _
                            WPoint(B).Z - 0, _
                            WPoint(B).X - 0, _
                            0 _
                        )
                    WPoint(B).Z = GetCoord("Opp", 0, 0, BufferA + FMesh(A).Vect.Rot.Y, BufferB) 'y - roll
                    WPoint(B).X = GetCoord("Adj", 0, 0, BufferA + FMesh(A).Vect.Rot.Y, BufferB)
                    BufferA = _
                        GetAng( _
                            WPoint(B).Y, _
                            WPoint(B).Z, _
                            0, _
                            0 _
                        )
                    BufferB = _
                        GetDist( _
                            WPoint(B).Y - 0, _
                            WPoint(B).Z - 0, _
                            0 _
                        )
                    WPoint(B).Y = GetCoord("Opp", 0, 0, BufferA + FMesh(A).Vect.Rot.X, BufferB) 'x - pitch
                    WPoint(B).Z = GetCoord("Adj", 0, 0, BufferA + FMesh(A).Vect.Rot.X, BufferB)
                    BufferA = _
                        GetAng( _
                            WPoint(B).X, _
                            WPoint(B).Y, _
                            0, _
                            0 _
                        )
                    BufferB = _
                        GetDist( _
                            WPoint(B).X - 0, _
                            WPoint(B).Y - 0, _
                            0 _
                        )
                    WPoint(B).X = GetCoord("Opp", 0, 0, BufferA + FMesh(A).Vect.Rot.Z, BufferB) 'z - yaw
                    WPoint(B).Y = GetCoord("Adj", 0, 0, BufferA + FMesh(A).Vect.Rot.Z, BufferB)
                End If
            Next B
        End If
    Next A
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            For B = FMesh(A).PointRng.Bgn To FMesh(A).PointRng.Fin
                If FPoint(B).Exist = True Then
                    WPoint(B).X = WPoint(B).X + FMesh(A).Vect.Trans.X
                    WPoint(B).Y = WPoint(B).Y + FMesh(A).Vect.Trans.Y
                    WPoint(B).Z = WPoint(B).Z + FMesh(A).Vect.Trans.Z
                End If
            Next B
        End If
    Next A

    Call RefMarkers

End Function
Function TransElem(Elem$, Index%, X!, Y!, Z!)
    
    'moves an element
    
    Dim A%
    
    If Elem = "Point" Then
        FPoint(Index).Pos.X = FPoint(Index).Pos.X + X
        FPoint(Index).Pos.Y = FPoint(Index).Pos.Y + Y
        FPoint(Index).Pos.Z = FPoint(Index).Pos.Z + Z
    End If
    If Elem = "Line" Then
        FPoint(FLine(Index).Struct.A).Pos.X = FPoint(FLine(Index).Struct.A).Pos.X + X
        FPoint(FLine(Index).Struct.A).Pos.Y = FPoint(FLine(Index).Struct.A).Pos.Y + Y
        FPoint(FLine(Index).Struct.A).Pos.Z = FPoint(FLine(Index).Struct.A).Pos.Z + Z
        FPoint(FLine(Index).Struct.B).Pos.X = FPoint(FLine(Index).Struct.B).Pos.X + X
        FPoint(FLine(Index).Struct.B).Pos.Y = FPoint(FLine(Index).Struct.B).Pos.Y + Y
        FPoint(FLine(Index).Struct.B).Pos.Z = FPoint(FLine(Index).Struct.B).Pos.Z + Z
    End If

End Function
Function RefMarkers()

    'refreshes all markers

    Dim A%
    Dim Color As ColorRGB
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            Color.R = 150
            Color.G = 150
            Color.B = 150
            Call MakeBoundBox(A, Color)
            Color.R = 150
            Color.G = 150
            Color.B = 0
            Call MakeVectAxis(A, Color, 20)
        End If
    Next A
    
End Function
