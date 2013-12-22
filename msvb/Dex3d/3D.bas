Attribute VB_Name = "ModuleF"
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

Public Const GRADIENT_FILL_RECT_H = &H0
Public Const GRADIENT_FILL_RECT_V = &H1
Public Const GRADIENT_FILL_TRIANGLE = &H2

Public Const CVectorNumber = 10000
Public Const CFaceNumber = 10000
Public Const CMeshNumber = 10000

Public Const CNear = 1
Public Const CFar = 1600

Public Const CArrowUp = 38
Public Const CArrowDown = 40
Public Const CArrowLeft = 37
Public Const CArrowRight = 39
Public Const CEscape = 27
Public Const CBackspace = 8
Public Const CTab = 9
Public Const CEnter = 13
Public Const CShift = 16
Public Const CControl = 17
Public Const CAlternate = 18
Public Const CSpace = 32

Type TRIVERTEX
    X As Long
    Y As Long
    Red As Integer
    Green As Integer
    Blue As Integer
    Alpha As Integer
End Type

Type GRADIENT_RECT
    UpperLeft As Long
    LowerRight As Long
End Type

Type GRADIENT_TRIANGLE
    Vertex1 As Long
    Vertex2 As Long
    Vertex3 As Long
End Type

Type TFace
    A As Integer
    B As Integer
    C As Integer
    Color As ColorRGB
    Alpha As Single
End Type

Type TAddress
    Start As Integer
    Length As Integer
End Type

Type TMesh
    Vertices As TAddress
    Faces As TAddress
    Scales As Vector
    Angles As Orientation
    Origin As Vector
    Parent As Integer
    UpdateTransformation As Boolean
    Transformation As Matrix
    Visible As Boolean
    Tag As String
End Type

Type TCamera
    FOVHalfTan As Single
    Front As Single
    Back As Single
    BrightRange As Single
    DarkRange As Single
    Angles As Orientation
    Origin As Vector
    UpdateTransformation As Boolean
    Transformation As Matrix
    DoubleSided As Boolean
    Metallic As Boolean
    Atmosphere As Boolean
    ColorCorrect As Boolean
    Ambient As ColorRGB
    DrawStyle As Integer
    Orthographic As Boolean
    Zoom As Single
    Tag As String
End Type

Type TLight
    Color As ColorRGB
    BrightRange As Single
    DarkRange As Single
    Angles As Orientation
    Origin As Vector
    Hotspot As Single
    Falloff As Single
    Enabled As Boolean
    Tag As String
End Type

Type TScene
    Meshes As TAddress
    Cameras As TAddress
    Lights As TAddress
End Type

Declare Function Polygon Lib "gdi32" (ByVal hdc As Long, lpPoint As POINTAPI, ByVal nCount As Long) As Long
Declare Function GradientFill Lib "msimg32.dll" (ByVal hdc As Long, PVertex As TRIVERTEX, ByVal dwNumVertex As Long, PMesh As Any, ByVal dwNumMesh As Long, ByVal dwMode As Long) As Boolean
Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long) As Long
Declare Function SetPixel Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal crColor As Long) As Long
Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, lpPoint As POINTAPI) As Long
Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long) As Long
Declare Function TextOut Lib "gdi32" Alias "TextOutA" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal lpString As String, ByVal nCount As Long) As Long
Declare Function PolyBezier Lib "gdi32" (ByVal hdc As Long, lppt As POINTAPI, ByVal cPoints As Long) As Long

Public VVertex(CVectorNumber) As Vector
Public VFace(CFaceNumber) As TFace
Public VMesh(CMeshNumber) As TMesh
Public VCamera(CVectorNumber) As TCamera
Public VLight(CVectorNumber) As TLight
Public VScene As TScene

Public WVertex(CVectorNumber) As Vector 'world system
Public CVertex(CVectorNumber) As Vector 'camera system
Public SVertex(CVectorNumber) As Vector 'screen system

Public FaceDepth(CFaceNumber) As Single
Public FaceOrder(CFaceNumber) As Integer
Public VertexNormal(CVectorNumber) As Vector
Public VertexColor(CVectorNumber) As ColorRGB
Public FaceColor(CFaceNumber) As ColorRGB
Function AbsoluteOrigin(MeshIndex As Integer) As Vector

    Dim A As Integer
    Dim Transformation As Matrix
    
    Transformation = MatrixIdentity
    
    A = MeshIndex
    
    Do
    
        Transformation = MatrixIdentity
        
        Transformation = _
            MatrixDotProduct( _
                Transformation, _
                TransformationScale(VMesh(A).Scales) _
            )
            
        Transformation = _
            MatrixDotProduct( _
                Transformation, _
                TransformationRotate(3, VMesh(A).Angles.Roll) _
            )
            
        Transformation = _
            MatrixDotProduct( _
                Transformation, _
                TransformationRotate(1, VMesh(A).Angles.Pitch) _
            )
            
        Transformation = _
            MatrixDotProduct( _
                Transformation, _
                TransformationRotate(2, VMesh(A).Angles.Yaw) _
            )
            
        Transformation = _
            MatrixDotProduct( _
                Transformation, _
                TransformationTranslate(VMesh(A).Origin) _
            )
            
        AbsoluteOrigin = _
            VectorMatrixDotProductToVector(AbsoluteOrigin, Transformation)
            
        If VMesh(A).Parent <> 0 Then
            A = VMesh(A).Parent
        Else
            Exit Function
        End If
        
    Loop
    
End Function
Function InitializeCanvas(Canvas As PictureBox)

    Canvas.AutoRedraw = True
    Canvas.ScaleMode = 3
    
End Function
Function SetMeshOrigin(MeshIndex As Integer, Origin As Vector)

    Call _
        TransformMesh( _
            MeshIndex, _
            TransformationTranslate( _
                VectorSubtract( _
                    VMesh(MeshIndex).Origin, _
                    Origin _
                ) _
            ) _
        )
    VMesh(MeshIndex).Origin = Origin
    
End Function
Function UnlockMesh(MeshIndex As Integer) As Integer

    Dim A As Integer
    Dim VertexOffset As Integer
    Dim FaceOffset As Integer
    
    UnlockMesh = AddMesh(0, 0)
    If UnlockMesh = 0 Then Exit Function
    
    VertexOffset = VMesh(UnlockMesh).Vertices.Start - VMesh(MeshIndex).Vertices.Start
    FaceOffset = VMesh(UnlockMesh).Faces.Start - VMesh(MeshIndex).Faces.Start
    
    For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
        If A + VertexOffset > UBound(VVertex) Then
            Call ShowError(1)
            Call RemoveMesh(MeshIndex)
            Exit Function
        End If
        VVertex(A + VertexOffset) = VVertex(A)
    Next A
    
    For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
        If A + FaceOffset > UBound(VFace) Then
            Call ShowError(1)
            Call RemoveMesh(MeshIndex)
            Exit Function
        End If
        VFace(A + FaceOffset) = VFace(A)
        VFace(A + FaceOffset).A = VFace(A).A + VertexOffset
        VFace(A + FaceOffset).B = VFace(A).B + VertexOffset
        VFace(A + FaceOffset).C = VFace(A).C + VertexOffset
    Next A
    
    VMesh(UnlockMesh) = VMesh(MeshIndex)
    VMesh(UnlockMesh).Vertices.Start = VMesh(MeshIndex).Vertices.Start + VertexOffset
    VMesh(UnlockMesh).Vertices.Length = VMesh(MeshIndex).Vertices.Length
    VMesh(UnlockMesh).Faces.Start = VMesh(MeshIndex).Faces.Start + FaceOffset
    VMesh(UnlockMesh).Faces.Length = VMesh(MeshIndex).Faces.Length
    
    Call RemoveMesh(MeshIndex)
    UnlockMesh = UnlockMesh - 1
    
End Function
Function GetMeshCenter(MeshIndex As Integer) As Vector

    GetMeshCenter = _
        VectorScale( _
            VectorAdd( _
                DimensionsMaximum(MeshIndex), _
                DimensionsMinimum(MeshIndex) _
            ), _
            0.5 _
        )
        
End Function
Function TrimMesh(MeshIndex As Integer) As Integer

    Const Zero = 0.0001
    
    Dim A As Integer
    Dim B As Integer
    Dim Reference As Boolean
    
    'remove dulicate vertex reference to location
    For A = GetAddressLast(VMesh(MeshIndex).Vertices) To VMesh(MeshIndex).Vertices.Start Step -1
        For B = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
            If B <> A Then
                If VectorDistance(VVertex(B), VVertex(A)) < Zero Then
                    Call RemoveVertex(B, A)
                    Exit For
                End If
            End If
        Next B
    Next A
    
    'remove mesh reference to unused vertex
    For A = GetAddressLast(VMesh(MeshIndex).Vertices) To VMesh(MeshIndex).Vertices.Start Step -1
        Reference = False
        For B = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
            If _
                VFace(B).A = A Or _
                VFace(B).B = A Or _
                VFace(B).C = A _
                    Then _
                        Reference = True
        Next B
        If Reference = False Then Call RemoveVertex(A, 0)
    Next A
    
    'remove face reference to foreign vertex
    For A = GetAddressLast(VMesh(MeshIndex).Faces) To VMesh(MeshIndex).Faces.Start Step -1
        If _
            IsVertexInMesh(VFace(A).A, MeshIndex) = False Or _
            IsVertexInMesh(VFace(A).B, MeshIndex) = False Or _
            IsVertexInMesh(VFace(A).C, MeshIndex) = False _
                Then _
                    Call RemoveFace(A)
    Next A
    
    'remove duplicate face reference to vertex
    For A = GetAddressLast(VMesh(MeshIndex).Faces) To VMesh(MeshIndex).Faces.Start Step -1
        If _
            VFace(A).A = VFace(A).B Or _
            VFace(A).B = VFace(A).C Or _
            VFace(A).C = VFace(A).A _
                Then _
                    Call RemoveFace(A)
    Next A
    
    'remove face reference to null
    For A = GetAddressLast(VMesh(MeshIndex).Faces) To VMesh(MeshIndex).Faces.Start Step -1
        If _
            VFace(A).A = 0 Or _
            VFace(A).B = 0 Or _
            VFace(A).C = 0 _
                Then _
                    Call RemoveFace(A)
    Next A
    
End Function
Function ResizeCanvas(Canvas As PictureBox, Owner As Form)

    Canvas.Move 0, 0, Owner.ScaleWidth, Owner.ScaleHeight
    
End Function
Function AbsoluteParent(MeshIndex As Integer) As Integer

    Dim A As Integer
    
    A = MeshIndex
    Do
        If VMesh(A).Parent <> 0 Then
            A = VMesh(A).Parent
        Else
            Exit Do
        End If
    Loop
    AbsoluteParent = A
    
End Function
Function AllocateMesh() As Integer

    If GetAddressLast(VScene.Meshes) + 1 <= UBound(VMesh) Then _
        AllocateMesh = GetAddressLast(VScene.Meshes) + 1
        
End Function
Function AllocateCamera() As Integer

    If GetAddressLast(VScene.Cameras) + 1 <= UBound(VCamera) Then _
        AllocateCamera = GetAddressLast(VScene.Cameras) + 1
        
End Function
Function AllocateLight() As Integer

    If GetAddressLast(VScene.Lights) + 1 <= UBound(VLight) Then _
        AllocateLight = GetAddressLast(VScene.Lights) + 1
        
End Function
Function AttachMeshes(MeshIndexA As Integer, MeshIndexB As Integer) As Integer

    Dim A As Integer
    Dim MeshIndexC As Integer
    Dim VertexOffset As Integer
    Dim FaceOffset As Integer
    
    MeshIndexC = _
        AddMesh( _
            VMesh(MeshIndexA).Vertices.Length + VMesh(MeshIndexB).Vertices.Length, _
            VMesh(MeshIndexA).Faces.Length + VMesh(MeshIndexB).Faces.Length _
        )
    If MeshIndexC = 0 Then Exit Function
    
    VertexOffset = VMesh(MeshIndexC).Vertices.Start - VMesh(MeshIndexA).Vertices.Start
    FaceOffset = VMesh(MeshIndexC).Faces.Start - VMesh(MeshIndexA).Faces.Start
    
    For A = VMesh(MeshIndexC).Vertices.Start To GetAddressLast(VMesh(MeshIndexC).Vertices)
        VVertex(A) = VVertex(A - VertexOffset)
    Next A
    
    For A = VMesh(MeshIndexC).Faces.Start To GetAddressLast(VMesh(MeshIndexC).Faces)
        VFace(A) = VFace(A - FaceOffset)
        VFace(A).A = VFace(A).A + VertexOffset
        VFace(A).B = VFace(A).B + VertexOffset
        VFace(A).C = VFace(A).C + VertexOffset
    Next A
    
    VertexOffset = VMesh(MeshIndexC).Vertices.Start + VMesh(MeshIndexA).Vertices.Length - VMesh(MeshIndexB).Vertices.Start
    FaceOffset = VMesh(MeshIndexC).Faces.Start + VMesh(MeshIndexA).Faces.Length - VMesh(MeshIndexB).Faces.Start
    
    For A = VMesh(MeshIndexC).Vertices.Start + VMesh(MeshIndexA).Vertices.Length To GetAddressLast(VMesh(MeshIndexC).Vertices)
        VVertex(A) = VVertex(A - VertexOffset)
    Next A
    
    For A = VMesh(MeshIndexC).Faces.Start + VMesh(MeshIndexA).Faces.Length To GetAddressLast(VMesh(MeshIndexC).Faces)
        VFace(A) = VFace(A - FaceOffset)
        VFace(A).A = VFace(A).A + VertexOffset
        VFace(A).B = VFace(A).B + VertexOffset
        VFace(A).C = VFace(A).C + VertexOffset
    Next A
    
    Call RemoveMesh(MeshIndexA)
    MeshIndexC = MeshIndexC - 1
    
    Call RemoveMesh(MeshIndexB)
    MeshIndexC = MeshIndexC - 1
    
    AttachMeshes = MeshIndexC
    
End Function
Function CopyMesh(MeshIndex As Integer) As Integer

    Dim A As Integer
    Dim VertexOffset As Integer
    Dim FaceOffset As Integer
    
    CopyMesh = AddMesh(VMesh(MeshIndex).Vertices.Length, VMesh(MeshIndex).Faces.Length)
    If CopyMesh = 0 Then Exit Function
    
    VertexOffset = VMesh(CopyMesh).Vertices.Start - VMesh(MeshIndex).Vertices.Start
    FaceOffset = VMesh(CopyMesh).Faces.Start - VMesh(MeshIndex).Faces.Start
    
    For A = VMesh(CopyMesh).Vertices.Start To GetAddressLast(VMesh(CopyMesh).Vertices)
        VVertex(A) = VVertex(A - VertexOffset)
    Next A
    
    For A = VMesh(CopyMesh).Faces.Start To GetAddressLast(VMesh(CopyMesh).Faces)
        VFace(A) = VFace(A - FaceOffset)
        VFace(A).A = VFace(A).A + VertexOffset
        VFace(A).B = VFace(A).B + VertexOffset
        VFace(A).C = VFace(A).C + VertexOffset
    Next A
    
    VMesh(CopyMesh) = VMesh(MeshIndex)
    VMesh(CopyMesh).Vertices.Start = VMesh(MeshIndex).Vertices.Start + VertexOffset
    VMesh(CopyMesh).Faces.Start = VMesh(MeshIndex).Faces.Start + FaceOffset
    
End Function
Function CopyLight(LightIndex As Integer) As Integer

    CopyLight = AddLight
    VLight(CopyLight) = VLight(LightIndex)
    
End Function
Function CopyCamera(CameraIndex As Integer) As Integer

    CopyCamera = AddCamera
    VCamera(CopyCamera) = VCamera(CameraIndex)
    
End Function
Function DrawGradientFace(Canvas As PictureBox, FaceIndex As Integer, ColorA As ColorRGB, ColorB As ColorRGB, ColorC As ColorRGB)

    Dim Vertex(2) As TRIVERTEX
    Dim Triangle As GRADIENT_TRIANGLE
    
    Vertex(0).X = SVertex(VFace(FaceIndex).A).X
    Vertex(0).Y = SVertex(VFace(FaceIndex).A).Y
    Vertex(0).Red = "&H" & Hex(ColorA.R) & "00"
    Vertex(0).Green = "&H" & Hex(ColorA.G) & "00"
    Vertex(0).Blue = "&H" & Hex(ColorA.B) & "00"
    Vertex(1).X = SVertex(VFace(FaceIndex).B).X
    Vertex(1).Y = SVertex(VFace(FaceIndex).B).Y
    Vertex(1).Red = "&H" & Hex(ColorB.R) & "00"
    Vertex(1).Green = "&H" & Hex(ColorB.G) & "00"
    Vertex(1).Blue = "&H" & Hex(ColorB.B) & "00"
    Vertex(2).X = SVertex(VFace(FaceIndex).C).X
    Vertex(2).Y = SVertex(VFace(FaceIndex).C).Y
    Vertex(2).Red = "&H" & Hex(ColorC.R) & "00"
    Vertex(2).Green = "&H" & Hex(ColorC.G) & "00"
    Vertex(2).Blue = "&H" & Hex(ColorC.B) & "00"
    Triangle.Vertex1 = 0
    Triangle.Vertex2 = 1
    Triangle.Vertex3 = 2
    Call _
        GradientFill( _
            Canvas.hdc, _
            Vertex(0), _
            3, _
            Triangle, _
            1, _
            GRADIENT_FILL_TRIANGLE _
        )
        
End Function
Function FitMesh(MeshIndex As Integer) As Integer

    FitMesh = CopyMesh(MeshIndex)
    If FitMesh = 0 Then Exit Function
    
    Call RemoveMesh(MeshIndex)
    FitMesh = FitMesh - 1
    
End Function
Function IsTriangleClockwise(PointA As POINTAPI, PointB As POINTAPI, PointC As POINTAPI) As Boolean

    Dim AB As Vector
    Dim AC As Vector
    
    AB = POINTAPIToVector(POINTAPISubtract(PointB, PointA))
    AC = POINTAPIToVector(POINTAPISubtract(PointC, PointA))
    
    If VectorCrossProduct(AB, AC).Z < 0 Then IsTriangleClockwise = True
    
End Function
Function FaceByPoint(Point As POINTAPI) As Integer

    Dim A As Integer
    Dim CurrentDepth As Single
    Dim BestDepth As Single
    
    For A = LBound(FaceOrder) To UBound(FaceOrder)
        If FaceOrder(A) = 0 Then Exit For
        If IsPointInFace(Point, FaceOrder(A)) = True Then
            CurrentDepth = _
                ( _
                    SVertex(VFace(FaceOrder(A)).A).Z + _
                    SVertex(VFace(FaceOrder(A)).A).Z + _
                    SVertex(VFace(FaceOrder(A)).C).Z _
                )
            If BestDepth = 0 Or CurrentDepth < BestDepth Then
                BestDepth = CurrentDepth
                FaceByPoint = FaceOrder(A)
            End If
        End If
    Next A
    
End Function
Function IsPointInFace(Point As POINTAPI, FaceIndex As Integer) As Boolean

    Dim A As POINTAPI
    Dim B As POINTAPI
    Dim C As POINTAPI
    Dim D As POINTAPI
    
    A = VectorToPOINTAPI(SVertex(VFace(FaceIndex).A))
    B = VectorToPOINTAPI(SVertex(VFace(FaceIndex).B))
    C = VectorToPOINTAPI(SVertex(VFace(FaceIndex).C))
    D = Point
    
    A.Y = -A.Y
    B.Y = -B.Y
    C.Y = -C.Y
    D.Y = -D.Y
    
    If _
        IsTriangleClockwise(A, B, D) = True And _
        IsTriangleClockwise(B, C, D) = True And _
        IsTriangleClockwise(C, A, D) = True _
            Then _
                IsPointInFace = True
                
End Function
Function IsVertexInMesh(VertexIndex As Integer, MeshIndex As Integer) As Boolean

    If _
        VertexIndex >= VMesh(MeshIndex).Vertices.Start And _
        VertexIndex <= GetAddressLast(VMesh(MeshIndex).Vertices) _
            Then _
                IsVertexInMesh = True
                
End Function
Function IsVertexInFace(VertexIndex As Integer, FaceIndex As Integer) As Boolean

    If _
        VertexIndex = VFace(FaceIndex).A Or _
        VertexIndex = VFace(FaceIndex).B Or _
        VertexIndex = VFace(FaceIndex).C _
            Then _
                IsVertexInFace = True
                
End Function
Function IsFaceInMesh(FaceIndex As Integer, MeshIndex As Integer) As Boolean

    If _
        FaceIndex >= VMesh(MeshIndex).Faces.Start And _
        FaceIndex <= GetAddressLast(VMesh(MeshIndex).Faces) _
            Then _
                IsFaceInMesh = True
                
End Function
Function MeshByFace(FaceIndex As Integer) As Integer

    Dim A As Integer
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If IsFaceInMesh(FaceIndex, A) = True Then
            MeshByFace = A
            Exit For
        End If
    Next A
    
End Function
Function FaceByVertex(VertexIndex As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        For B = VMesh(A).Faces.Start To GetAddressLast(VMesh(A).Faces)
            If IsVertexInFace(VertexIndex, B) = True Then
                FaceByVertex = B
                Exit For
            End If
        Next B
    Next A
    
End Function
Function MeshByTag(Tag As String) As Integer

    Dim A As Integer
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If UCase(VMesh(A).Tag) = UCase(Tag) Then
            MeshByTag = A
            Exit For
        End If
    Next A
    
End Function
Function LightByTag(Tag As String) As Integer

    Dim A As Integer
    
    For A = VScene.Lights.Start To GetAddressLast(VScene.Lights)
        If UCase(VLight(A).Tag) = UCase(Tag) Then
            LightByTag = A
            Exit For
        End If
    Next A
    
End Function
Function CameraByTag(Tag As String) As Integer

    Dim A As Integer
    
    For A = VScene.Cameras.Start To GetAddressLast(VScene.Cameras)
        If UCase(VCamera(A).Tag) = UCase(Tag) Then
            CameraByTag = A
            Exit For
        End If
    Next A
    
End Function
Function MeshByVertex(VertexIndex As Integer) As Integer

    Dim A As Integer
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If IsVertexInMesh(VertexIndex, A) = True Then
            MeshByVertex = A
            Exit For
        End If
    Next A
    
End Function
Function ShowAbout()

    Call _
        MsgBox( _
            App.Title & " version " & App.Major & "." & App.Minor & "." & App.Revision & vbCrLf & _
            vbCrLf & _
            "by Jerry Chen", _
            64, _
            "About" _
        )
        
End Function
Function ShowError(ErrorNumber As Integer)

    Dim ErrorMessage As String
    
    Select Case ErrorNumber
        Case 1
            ErrorMessage = "Unable to allocate memory for mesh!"
        Case 2
            ErrorMessage = "Unable to allocate memory for camera!"
        Case 3
            ErrorMessage = "Unable to allocate memory for light!"
        Case 4
            ErrorMessage = "Bad camera settings!"
        Case 5
            ErrorMessage = "Bad light settings!"
        Case Else
            ErrorMessage = "Unknown error!"
    End Select
    Call MsgBox(ErrorMessage, 16, "Error")
    
End Function
Function TransformMesh(MeshIndex As Integer, Transformation As Matrix)

    Dim A As Integer
    
    For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
        VVertex(A) = VectorMatrixDotProductToVector(VVertex(A), Transformation)
    Next A
    
End Function
Function CenterMesh(MeshIndex As Integer)

    Call _
        TransformMesh( _
            MeshIndex, _
            TransformationTranslate( _
                VectorScale( _
                    GetMeshCenter(MeshIndex), _
                    -1 _
                ) _
            ) _
        )
        
End Function
Function DimensionsMaximum(MeshIndex As Integer) As Vector

    Dim A As Integer
    
    DimensionsMaximum = VVertex(VMesh(MeshIndex).Vertices.Start)
    
    For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
        If VVertex(A).X > DimensionsMaximum.X Then DimensionsMaximum.X = VVertex(A).X
        If VVertex(A).Y > DimensionsMaximum.Y Then DimensionsMaximum.Y = VVertex(A).Y
        If VVertex(A).Z > DimensionsMaximum.Z Then DimensionsMaximum.Z = VVertex(A).Z
    Next A
    
End Function
Function DimensionsMinimum(MeshIndex As Integer) As Vector

    Dim A As Integer
    
    DimensionsMinimum = VVertex(VMesh(MeshIndex).Vertices.Start)
    
    For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
        If VVertex(A).X < DimensionsMinimum.X Then DimensionsMinimum.X = VVertex(A).X
        If VVertex(A).Y < DimensionsMinimum.Y Then DimensionsMinimum.Y = VVertex(A).Y
        If VVertex(A).Z < DimensionsMinimum.Z Then DimensionsMinimum.Z = VVertex(A).Z
    Next A
    
End Function
Function SetMeshColor(MeshIndex As Integer, Color As ColorRGB, Alpha As Single)

    Dim A As Integer
    
    For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
        VFace(A).Color = Color
        VFace(A).Alpha = Alpha
    Next A
    
End Function
Function SetSceneColor(Color As ColorRGB, Alpha As Single)

    Dim A As Integer
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        Call SetMeshColor(A, Color, Alpha)
    Next A
    
End Function
Function AddCamera() As Integer

    Dim A As Integer
    
    A = AllocateCamera
    If A <> 0 Then
        AddCamera = A
        Call SetCameraFOV(A, DegreeToRadian(60))
        VCamera(A).Front = CNear
        VCamera(A).Back = CFar
        VCamera(A).BrightRange = CNear
        VCamera(A).DarkRange = CFar
        VCamera(A).UpdateTransformation = True
        VScene.Cameras.Length = VScene.Cameras.Length + 1
    Else
        Call ShowError(2)
    End If
    
End Function
Function ClearMeshes(MeshIgnore As Integer)

    Dim A As Integer
    
    For A = GetAddressLast(VScene.Meshes) To VScene.Meshes.Start Step -1
        If A <> MeshIgnore Then Call RemoveMesh(A)
    Next A
    
End Function
Function ClearCameras(CameraIgnore As Integer)

    Dim A As Integer
    
    For A = GetAddressLast(VScene.Cameras) To VScene.Cameras.Start Step -1
        If A <> CameraIgnore Then Call RemoveCamera(A)
    Next A
    
End Function
Function ClearLights(LightIgnore As Integer)

    Dim A As Integer
    
    For A = GetAddressLast(VScene.Lights) To VScene.Lights.Start Step -1
        If A <> LightIgnore Then Call RemoveLight(A)
    Next A
    
End Function
Function RemoveCamera(CameraIndex As Integer)

    Dim A As Integer
    Dim Dummy As TCamera
    
    For A = CameraIndex To GetAddressLast(VScene.Cameras)
        If A <> GetAddressLast(VScene.Cameras) Then
            VCamera(A) = VCamera(A + 1)
        Else
            VCamera(A) = Dummy
        End If
    Next A
    VScene.Cameras.Length = VScene.Cameras.Length - 1
    
End Function
Function AddLight() As Integer

    Dim A As Integer
    
    A = AllocateLight
    If A <> 0 Then
        AddLight = A
        VLight(A).Color = ColorLongToRGB(vbWhite)
        VLight(A).BrightRange = CNear
        VLight(A).DarkRange = CFar
        VLight(A).Enabled = True
        VScene.Lights.Length = VScene.Lights.Length + 1
    Else
        Call ShowError(3)
    End If
    
End Function
Function RemoveLight(LightIndex As Integer)

    Dim A As Integer
    Dim Dummy As TLight
    
    For A = LightIndex To GetAddressLast(VScene.Lights)
        If A <> GetAddressLast(VScene.Lights) Then
            VLight(A) = VLight(A + 1)
        Else
            VLight(A) = Dummy
        End If
    Next A
    VScene.Lights.Length = VScene.Lights.Length - 1
    
End Function
Function GetFaceCenter(FaceIndex As Integer) As Vector

    GetFaceCenter.X = _
        ( _
            WVertex(VFace(FaceIndex).A).X + _
            WVertex(VFace(FaceIndex).B).X + _
            WVertex(VFace(FaceIndex).C).X _
        ) / _
        3
        
    GetFaceCenter.Y = _
        ( _
            WVertex(VFace(FaceIndex).A).Y + _
            WVertex(VFace(FaceIndex).B).Y + _
            WVertex(VFace(FaceIndex).C).Y _
        ) / _
        3
        
    GetFaceCenter.Z = _
        ( _
            WVertex(VFace(FaceIndex).A).Z + _
            WVertex(VFace(FaceIndex).B).Z + _
            WVertex(VFace(FaceIndex).C).Z _
        ) / _
        3
        
End Function
Function GetFaceNormal(FaceIndex As Integer) As Vector

    GetFaceNormal = _
        VectorCrossProduct( _
            VectorSubtract( _
                WVertex(VFace(FaceIndex).B), _
                WVertex(VFace(FaceIndex).A) _
            ), _
            VectorSubtract( _
                WVertex(VFace(FaceIndex).C), _
                WVertex(VFace(FaceIndex).A) _
            ) _
        )
        
End Function
Function AllocateVertices(Number As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim GapStart As Integer
    Dim GapEnd As Integer
    
    If Number <> 0 Then
        For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
            GapEnd = VMesh(A).Vertices.Start - 1
            GapStart = 0
            For B = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
                If _
                    VMesh(B).Vertices.Start < VMesh(A).Vertices.Start And _
                    GetAddressLast(VMesh(B).Vertices) > GapStart _
                        Then _
                            GapStart = GetAddressLast(VMesh(B).Vertices)
            Next B
            GapStart = GapStart + 1
            If GapEnd - GapStart + 1 >= Number Then
                AllocateVertices = GapStart
                Exit Function
            End If
        Next A
    End If
    GapStart = 0
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If GetAddressLast(VMesh(A).Vertices) > GapStart Then _
            GapStart = GetAddressLast(VMesh(A).Vertices)
    Next A
    GapStart = GapStart + 1
    If GapStart - 1 + Number <= UBound(VVertex) Then AllocateVertices = GapStart
    
End Function
Function AllocateFaces(Number As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim GapStart As Integer
    Dim GapEnd As Integer
    
    If Number <> 0 Then
        For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
            GapEnd = VMesh(A).Faces.Start - 1
            GapStart = 0
            For B = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
                If _
                    VMesh(B).Faces.Start < VMesh(A).Faces.Start And _
                    GetAddressLast(VMesh(B).Faces) > GapStart _
                        Then _
                            GapStart = GetAddressLast(VMesh(B).Faces)
            Next B
            GapStart = GapStart + 1
            If GapEnd - GapStart + 1 >= Number Then
                AllocateFaces = GapStart
                Exit Function
            End If
        Next A
    End If
    GapStart = 0
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If GetAddressLast(VMesh(A).Faces) > GapStart Then _
            GapStart = GetAddressLast(VMesh(A).Faces)
    Next A
    GapStart = GapStart + 1
    If GapStart - 1 + Number <= UBound(VFace) Then AllocateFaces = GapStart
    
End Function
Function InitializeScene(Canvas As PictureBox)

    Call InitializeCanvas(Canvas)
    
    VScene.Meshes.Start = 1
    VScene.Cameras.Start = 1
    VScene.Lights.Start = 1
    
End Function
Function LoadDexMesh(Filename As String) As Integer

    Dim A As Integer
    Dim MeshIndex As Integer
    Dim FileNumber As Integer
    
    MeshIndex = AddMesh(0, 0)
    If MeshIndex = 0 Then Exit Function
    
    FileNumber = FreeFile
    Open Filename For Binary As #FileNumber
    
        VMesh(MeshIndex).Tag = ReadString(FileNumber)
        
        VMesh(MeshIndex).Vertices.Length = ReadInteger(FileNumber)
        If GetAddressLast(VMesh(MeshIndex).Vertices) > UBound(VVertex) Then
            Call ShowError(1)
            Call RemoveMesh(MeshIndex)
            Exit Function
        End If
        For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
            If EOF(FileNumber) = True Then Exit For
            VVertex(A).X = ReadSingle(FileNumber)
            VVertex(A).Y = ReadSingle(FileNumber)
            VVertex(A).Z = ReadSingle(FileNumber)
        Next A
        
        VMesh(MeshIndex).Faces.Length = ReadInteger(FileNumber)
        If GetAddressLast(VMesh(MeshIndex).Faces) > UBound(VFace) Then
            Call ShowError(1)
            Call RemoveMesh(MeshIndex)
            Exit Function
        End If
        For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
            If EOF(FileNumber) = True Then Exit For
            VFace(A).A = ReadInteger(FileNumber) + VMesh(MeshIndex).Vertices.Start
            VFace(A).B = ReadInteger(FileNumber) + VMesh(MeshIndex).Vertices.Start
            VFace(A).C = ReadInteger(FileNumber) + VMesh(MeshIndex).Vertices.Start
            VFace(A).Color.R = ReadInteger(FileNumber)
            VFace(A).Color.G = ReadInteger(FileNumber)
            VFace(A).Color.B = ReadInteger(FileNumber)
            VFace(A).Alpha = ReadSingle(FileNumber)
        Next A
        
    Close #FileNumber
    
    Call TrimMesh(MeshIndex)
    LoadDexMesh = FitMesh(MeshIndex)
    
End Function
Function OrbitCamera(CameraIndex As Integer, Origin As Vector, Radius As Single, Longitude As Single, Latitude As Single)

    VCamera(CameraIndex).Origin = _
        VectorAdd( _
            Origin, _
            VectorScale( _
                OrientationToVector(OrientationInput(0, Latitude, -Longitude)), _
                -Radius _
            ) _
        )
        
    VCamera(CameraIndex).Angles.Pitch = Latitude
    VCamera(CameraIndex).Angles.Yaw = -Longitude
    
    VCamera(CameraIndex).UpdateTransformation = True
    
End Function
Function RenderImage(Canvas As PictureBox, CameraIndex As Integer)

    Call AlignMeshesToWorld
    Call AlignWorldToCamera(CameraIndex)
    Call ProjectScene(Canvas, CameraIndex)
    Call SortFaces(CameraIndex)
    Call DrawScene(Canvas, CameraIndex)
    
End Function
Function ResetScene(MeshIgnore As Integer, CameraIgnore As Integer, LightIgnore As Integer)

    Call ClearMeshes(MeshIgnore)
    Call ClearCameras(CameraIgnore)
    Call ClearLights(LightIgnore)
    
End Function
Function SaveDexMesh(MeshIndex As Integer, Filename As String)

    Dim A As Integer
    Dim FileNumber As Integer
    
    If Dir(Filename) <> "" Then Kill Filename
    
    FileNumber = FreeFile
    Open Filename For Binary As #FileNumber
    
        Call WriteString(FileNumber, VMesh(MeshIndex).Tag)
        
        Call WriteInteger(FileNumber, VMesh(MeshIndex).Vertices.Length)
        For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
            Call WriteSingle(FileNumber, VVertex(A).X)
            Call WriteSingle(FileNumber, VVertex(A).Y)
            Call WriteSingle(FileNumber, VVertex(A).Z)
        Next A
        
        Call WriteInteger(FileNumber, VMesh(MeshIndex).Faces.Length)
        For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
            Call WriteInteger(FileNumber, VFace(A).A - VMesh(MeshIndex).Vertices.Start)
            Call WriteInteger(FileNumber, VFace(A).B - VMesh(MeshIndex).Vertices.Start)
            Call WriteInteger(FileNumber, VFace(A).C - VMesh(MeshIndex).Vertices.Start)
            Call WriteInteger(FileNumber, VFace(A).Color.R)
            Call WriteInteger(FileNumber, VFace(A).Color.G)
            Call WriteInteger(FileNumber, VFace(A).Color.B)
            Call WriteSingle(FileNumber, VFace(A).Alpha)
        Next A
        
    Close #FileNumber
    
End Function
Function SetCameraFOV(CameraIndex As Integer, Angle As Single) As Single

    VCamera(CameraIndex).FOVHalfTan = Tan(Angle / 2)

End Function
Function GetCameraFOV(CameraIndex As Integer) As Single

    GetCameraFOV = 2 * Atn(VCamera(CameraIndex).FOVHalfTan)
    
End Function
Function ShadeFace(FaceCenter As Vector, FaceNormal As Vector, FaceIndex As Integer, CameraIndex As Integer) As ColorRGB

    Dim A As Integer
    Dim Alpha As Single
    Dim Beta As Single
    Dim Gamma As Single
    Dim Delta As Single
    Dim Epsilon As Single
    Dim ColorSum As ColorRGB
    
    For A = VScene.Lights.Start To GetAddressLast(VScene.Lights)
    
        If VLight(A).Enabled = True Then
        
            'use spotlight filter
            Epsilon = 1
            If VLight(A).Falloff > 0 Then
                Epsilon = _
                    VectorAngle( _
                        OrientationToVector(VLight(A).Angles), _
                        VectorSubtract( _
                            FaceCenter, _
                            VLight(A).Origin _
                        ) _
                    )
                If Epsilon < 0 Then Epsilon = 0
                If VLight(A).Falloff <> VLight(A).Hotspot Then
                    Epsilon = _
                        (VLight(A).Falloff - Epsilon) / _
                        (VLight(A).Falloff - VLight(A).Hotspot)
                    If Epsilon < 0 Then Epsilon = 0
                    If Epsilon > 1 Then Epsilon = 1
                Else
                    Call ShowError(5)
                End If
            End If
            
            'perform incident ray shading
            Alpha = _
                VectorAngle( _
                    VectorSubtract( _
                        VLight(A).Origin, _
                        FaceCenter _
                    ), _
                    FaceNormal _
                )
            If Alpha < 0 Then Alpha = 0
            
            'perform reflected ray shading
            If VCamera(CameraIndex).Metallic = True Then
                Beta = _
                    VectorAngle( _
                        VectorReflect( _
                            VectorSubtract( _
                                FaceCenter, _
                                VLight(A).Origin _
                            ), _
                            FaceNormal _
                        ), _
                        VectorSubtract( _
                            VCamera(CameraIndex).Origin, _
                            FaceCenter _
                        ) _
                    )
                If Beta < 0 Then Beta = 0
            End If
            
            'apply light distance decay
            Gamma = 1
            If VCamera(CameraIndex).Atmosphere = True Then
                If VLight(A).DarkRange <> VLight(A).BrightRange Then
                    Gamma = _
                        ( _
                            VLight(A).DarkRange - _
                            VectorDistance(FaceCenter, VLight(A).Origin) _
                        ) / _
                        (VLight(A).DarkRange - VLight(A).BrightRange)
                    If Gamma < 0 Then Gamma = 0
                    If Gamma > 1 Then Gamma = 1
                Else
                    Call ShowError(5)
                End If
            End If
            
            If VCamera(CameraIndex).ColorCorrect = True Then
                ColorSum = _
                    ColorAdd( _
                        ColorSum, _
                        ColorScale( _
                            ColorAdd( _
                                ColorScale( _
                                    VFace(FaceIndex).Color, _
                                    Alpha _
                                ), _
                                ColorScale( _
                                    VLight(A).Color, _
                                    Beta * VFace(FaceIndex).Alpha _
                                ) _
                            ), _
                            Gamma * Epsilon _
                        ) _
                    )
            Else
                ColorSum = _
                    ColorAdd( _
                        ColorSum, _
                        ColorScale( _
                            VLight(A).Color, _
                            ( _
                                Alpha + _
                                Beta * VFace(FaceIndex).Alpha _
                            ) * _
                            Gamma * Epsilon _
                        ) _
                    )
            End If
            
        End If
        
    Next A
    
    If ColorSum.R > 255 Then ColorSum.R = 255
    If ColorSum.G > 255 Then ColorSum.G = 255
    If ColorSum.B > 255 Then ColorSum.B = 255
    
    'apply camera distance decay
    Delta = 1
    If VCamera(CameraIndex).Atmosphere = True Then
        If VCamera(CameraIndex).DarkRange <> VCamera(CameraIndex).BrightRange Then
            Delta = _
                ( _
                    VCamera(CameraIndex).DarkRange - _
                    VectorDistance(FaceCenter, VCamera(CameraIndex).Origin) _
                ) / _
                (VCamera(CameraIndex).DarkRange - VCamera(CameraIndex).BrightRange)
            If Delta < 0 Then Delta = 0
            If Delta > 1 Then Delta = 1
        Else
            Call ShowError(4)
        End If
    End If
    
    If VCamera(CameraIndex).ColorCorrect = True Then
        ShadeFace = _
            ColorInterpolate( _
                VCamera(CameraIndex).Ambient, _
                ColorSum, _
                Delta _
            )
    Else
        ShadeFace = _
            ColorInterpolate( _
                VCamera(CameraIndex).Ambient, _
                ColorInterpolate( _
                    VFace(FaceIndex).Color, _
                    ColorSum, _
                    VFace(FaceIndex).Alpha _
                ), _
                Delta _
            )
    End If
    
End Function
Function SortFaces(CameraIndex As Integer)

    Dim A As Integer
    Dim B As Integer
    Dim BufferA As Vector
    Dim LastIndex As Integer
    
    BufferA = _
        VectorSubtract( _
            VCamera(CameraIndex).Origin, _
            OrientationToVector(VCamera(CameraIndex).Angles) _
        )
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If VMesh(A).Visible = True Then
            For B = VMesh(A).Faces.Start To GetAddressLast(VMesh(A).Faces)
                If _
                    SVertex(VFace(B).A).Z > 0 And SVertex(VFace(B).B).Z > 0 And SVertex(VFace(B).C).Z > 0 And _
                    SVertex(VFace(B).A).Z < 1 And SVertex(VFace(B).B).Z < 1 And SVertex(VFace(B).C).Z < 1 And _
                    ( _
                        ( _
                            Abs(CVertex(VFace(B).A).X) < VCamera(CameraIndex).FOVHalfTan * CVertex(VFace(B).A).Z And _
                            Abs(CVertex(VFace(B).A).Y) < VCamera(CameraIndex).FOVHalfTan * CVertex(VFace(B).A).Z And _
                            Abs(CVertex(VFace(B).B).X) < VCamera(CameraIndex).FOVHalfTan * CVertex(VFace(B).B).Z And _
                            Abs(CVertex(VFace(B).B).Y) < VCamera(CameraIndex).FOVHalfTan * CVertex(VFace(B).B).Z And _
                            Abs(CVertex(VFace(B).C).X) < VCamera(CameraIndex).FOVHalfTan * CVertex(VFace(B).C).Z And _
                            Abs(CVertex(VFace(B).C).Y) < VCamera(CameraIndex).FOVHalfTan * CVertex(VFace(B).C).Z _
                        ) Or _
                        VCamera(CameraIndex).Orthographic = True _
                    ) _
                        Then
                            If _
                                VCamera(CameraIndex).DoubleSided = True Or _
                                0 < _
                                VectorAngle( _
                                    VectorSubtract( _
                                        VCamera(CameraIndex).Origin, _
                                        GetFaceCenter(B) _
                                    ), _
                                    GetFaceNormal(B) _
                                ) Or _
                                ( _
                                    VCamera(CameraIndex).Orthographic = True And _
                                    0 < _
                                    VectorAngle( _
                                        BufferA, _
                                        GetFaceNormal(B) _
                                    ) _
                                ) _
                                    Then
                                        FaceDepth(LastIndex) = _
                                            -1 * _
                                            ( _
                                                SVertex(VFace(B).A).Z + _
                                                SVertex(VFace(B).B).Z + _
                                                SVertex(VFace(B).C).Z _
                                            )
                                        FaceOrder(LastIndex) = B
                                        LastIndex = LastIndex + 1
                            End If
                End If
            Next B
        End If
    Next A
    For A = LastIndex To UBound(FaceOrder) 'flush array
        If FaceOrder(A) = 0 Then Exit For
        FaceOrder(A) = 0
    Next A
    Call SingleSort(FaceDepth(), FaceOrder(), LBound(FaceOrder), LastIndex - 1)
    
End Function
Function AlignMeshesToWorld()

    Dim A As Integer
    Dim B As Integer
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If VMesh(VMesh(A).Parent).UpdateTransformation = True Then _
            VMesh(A).UpdateTransformation = True
    Next A
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
    
        If VMesh(A).UpdateTransformation = True Then
        
            VMesh(A).UpdateTransformation = False
            
            VMesh(A).Transformation = MatrixIdentity
            
            VMesh(A).Transformation = _
                MatrixDotProduct( _
                    VMesh(A).Transformation, _
                    TransformationScale(VMesh(A).Scales) _
                )
                
            VMesh(A).Transformation = _
                MatrixDotProduct( _
                    VMesh(A).Transformation, _
                    TransformationRotate(3, VMesh(A).Angles.Roll) _
                )
                
            VMesh(A).Transformation = _
                MatrixDotProduct( _
                    VMesh(A).Transformation, _
                    TransformationRotate(1, VMesh(A).Angles.Pitch) _
                )
                
            VMesh(A).Transformation = _
                MatrixDotProduct( _
                    VMesh(A).Transformation, _
                    TransformationRotate(2, VMesh(A).Angles.Yaw) _
                )
                
            VMesh(A).Transformation = _
                MatrixDotProduct( _
                    VMesh(A).Transformation, _
                    TransformationTranslate(VMesh(A).Origin) _
                )
                
            If _
                MatrixCompare( _
                    VMesh(VMesh(A).Parent).Transformation, _
                    MatrixNull _
                ) = _
                False _
                    Then
                        VMesh(A).Transformation = _
                            MatrixDotProduct( _
                                VMesh(A).Transformation, _
                                VMesh(VMesh(A).Parent).Transformation _
                            )
            End If
            
        End If
        
        For B = VMesh(A).Vertices.Start To GetAddressLast(VMesh(A).Vertices)
            WVertex(B) = VectorMatrixDotProductToVector(VVertex(B), VMesh(A).Transformation)
        Next B
        
    Next A
    
End Function
Function AlignWorldToCamera(CameraIndex As Integer)

    Dim A As Integer
    Dim B As Integer
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
    
        If VCamera(CameraIndex).UpdateTransformation = True Then
        
            VCamera(CameraIndex).UpdateTransformation = False
            
            VCamera(CameraIndex).Transformation = MatrixIdentity
            
            VCamera(CameraIndex).Transformation = _
                MatrixDotProduct( _
                    VCamera(CameraIndex).Transformation, _
                    TransformationRotate(3, VCamera(CameraIndex).Angles.Roll) _
                )
                
            VCamera(CameraIndex).Transformation = _
                MatrixDotProduct( _
                    VCamera(CameraIndex).Transformation, _
                    TransformationRotate(1, VCamera(CameraIndex).Angles.Pitch) _
                )
                
            VCamera(CameraIndex).Transformation = _
                MatrixDotProduct( _
                    VCamera(CameraIndex).Transformation, _
                    TransformationRotate(2, VCamera(CameraIndex).Angles.Yaw) _
                )
                
            VCamera(CameraIndex).Transformation = _
                MatrixDotProduct( _
                    VCamera(CameraIndex).Transformation, _
                    TransformationTranslate(VCamera(CameraIndex).Origin) _
                )
                
            VCamera(CameraIndex).Transformation = MatrixInvert(VCamera(CameraIndex).Transformation)
            
        End If
        
        For B = VMesh(A).Vertices.Start To GetAddressLast(VMesh(A).Vertices)
            CVertex(B) = VectorMatrixDotProductToVector(WVertex(B), VCamera(CameraIndex).Transformation)
        Next B
        
    Next A
    
End Function
Function DrawScene(Canvas As PictureBox, CameraIndex As Integer)

    Dim A As Integer
    Dim BufferA As POINTAPI
    Dim FaceNormal As Vector
    Dim Vertex(3) As POINTAPI
    
    Select Case VCamera(CameraIndex).DrawStyle
        Case 0 'wireframe
            Canvas.DrawMode = 13
            Canvas.DrawStyle = 0
            Canvas.FillStyle = 1
            Canvas.ForeColor = vbWhite 'vbBlack
        Case 1 'solid
            Canvas.DrawMode = 13
            Canvas.DrawStyle = 0
            Canvas.FillStyle = 0
            Canvas.ForeColor = vbWhite 'vbBlack
            For A = LBound(FaceOrder) To UBound(FaceOrder)
                If FaceOrder(A) = 0 Then Exit For
                FaceColor(FaceOrder(A)) = VFace(FaceOrder(A)).Color
            Next A
        Case 2 'flat
            Canvas.DrawMode = 13
            Canvas.DrawStyle = 5
            Canvas.FillStyle = 0
            For A = LBound(FaceOrder) To UBound(FaceOrder)
                If FaceOrder(A) = 0 Then Exit For
                FaceColor(FaceOrder(A)) = _
                    ShadeFace( _
                        GetFaceCenter(FaceOrder(A)), _
                        GetFaceNormal(FaceOrder(A)), _
                        FaceOrder(A), _
                        CameraIndex _
                    )
            Next A
        Case 3 'transparent
            Canvas.DrawMode = 15
            Canvas.DrawStyle = 5
            Canvas.FillStyle = 0
            For A = LBound(FaceOrder) To UBound(FaceOrder)
                If FaceOrder(A) = 0 Then Exit For
                FaceColor(FaceOrder(A)) = _
                    ShadeFace( _
                        GetFaceCenter(FaceOrder(A)), _
                        GetFaceNormal(FaceOrder(A)), _
                        FaceOrder(A), _
                        CameraIndex _
                    )
            Next A
        Case 4 'contour
            Canvas.DrawMode = 6
            Canvas.DrawStyle = 0
            Canvas.FillStyle = 1
        Case 5 'gourad
            Canvas.DrawMode = 13
            For A = LBound(FaceOrder) To UBound(FaceOrder) 'initialize vertex normal
                If FaceOrder(A) = 0 Then Exit For
                VertexNormal(VFace(FaceOrder(A)).A) = VectorNull
                VertexNormal(VFace(FaceOrder(A)).B) = VectorNull
                VertexNormal(VFace(FaceOrder(A)).C) = VectorNull
            Next A
            For A = LBound(FaceOrder) To UBound(FaceOrder) 'get vertex normal
                If FaceOrder(A) = 0 Then Exit For
                FaceNormal = GetFaceNormal(FaceOrder(A))
                VertexNormal(VFace(FaceOrder(A)).A) = _
                    VectorAdd(VertexNormal(VFace(FaceOrder(A)).A), FaceNormal)
                VertexNormal(VFace(FaceOrder(A)).B) = _
                    VectorAdd(VertexNormal(VFace(FaceOrder(A)).B), FaceNormal)
                VertexNormal(VFace(FaceOrder(A)).C) = _
                    VectorAdd(VertexNormal(VFace(FaceOrder(A)).C), FaceNormal)
            Next A
            For A = LBound(FaceOrder) To UBound(FaceOrder) 'get vertex color
                If FaceOrder(A) = 0 Then Exit For
                VertexColor(VFace(FaceOrder(A)).A) = _
                    ShadeFace( _
                        VVertex(VFace(FaceOrder(A)).A), _
                        VertexNormal(VFace(FaceOrder(A)).A), _
                        FaceOrder(A), _
                        CameraIndex _
                    )
                VertexColor(VFace(FaceOrder(A)).B) = _
                    ShadeFace( _
                        VVertex(VFace(FaceOrder(A)).B), _
                        VertexNormal(VFace(FaceOrder(A)).B), _
                        FaceOrder(A), _
                        CameraIndex _
                    )
                VertexColor(VFace(FaceOrder(A)).C) = _
                    ShadeFace( _
                        VVertex(VFace(FaceOrder(A)).C), _
                        VertexNormal(VFace(FaceOrder(A)).C), _
                        FaceOrder(A), _
                        CameraIndex _
                    )
            Next A
    End Select
    
    If VCamera(CameraIndex).DrawStyle <> 5 Then
        For A = LBound(FaceOrder) To UBound(FaceOrder)
            If FaceOrder(A) = 0 Then Exit For
            Call DrawFace(Canvas, FaceOrder(A), FaceColor(FaceOrder(A)))
        Next A
    Else
        For A = LBound(FaceOrder) To UBound(FaceOrder)
            If FaceOrder(A) = 0 Then Exit For
            Call _
                DrawGradientFace( _
                    Canvas, _
                    FaceOrder(A), _
                    VertexColor(VFace(FaceOrder(A)).A), _
                    VertexColor(VFace(FaceOrder(A)).B), _
                    VertexColor(VFace(FaceOrder(A)).C) _
                )
        Next A
    End If
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If VMesh(A).Visible = True Then
            If VMesh(A).Faces.Length = 1 Then
                If SVertex(VMesh(A).Vertices.Start).Z > 0 And SVertex(VMesh(A).Vertices.Start).Z < 1 Then
                    Select Case VMesh(A).Vertices.Length
                        Case 1
                            If VMesh(A).Tag <> "" Then
                                Canvas.ForeColor = ColorRGBToLong(VFace(VMesh(A).Faces.Start).Color)
                                Call _
                                    TextOut( _
                                        Canvas.hdc, _
                                        SVertex(VMesh(A).Vertices.Start).X, _
                                        SVertex(VMesh(A).Vertices.Start).Y, _
                                        VMesh(A).Tag, _
                                        Len(VMesh(A).Tag) _
                                    )
                            Else
                                Canvas.DrawMode = 13
                                Call _
                                    SetPixel( _
                                        Canvas.hdc, _
                                        SVertex(VMesh(A).Vertices.Start).X, _
                                        SVertex(VMesh(A).Vertices.Start).Y, _
                                        ColorRGBToLong(VFace(VMesh(A).Faces.Start).Color) _
                                    )
                            End If
                        Case 2
                            Canvas.DrawMode = 13
                            Canvas.DrawStyle = 0
                            Canvas.ForeColor = ColorRGBToLong(VFace(VMesh(A).Faces.Start).Color)
                            Call _
                                MoveToEx( _
                                    Canvas.hdc, _
                                    SVertex(VMesh(A).Vertices.Start).X, _
                                    SVertex(VMesh(A).Vertices.Start).Y, _
                                    BufferA _
                                )
                            Call _
                                LineTo( _
                                    Canvas.hdc, _
                                    SVertex(VMesh(A).Vertices.Start + 1).X, _
                                    SVertex(VMesh(A).Vertices.Start + 1).Y _
                                )
                        Case 4
                            Canvas.DrawMode = 13
                            Canvas.DrawStyle = 0
                            Canvas.ForeColor = ColorRGBToLong(VFace(VMesh(A).Faces.Start).Color)
                            Vertex(0) = VectorToPOINTAPI(SVertex(VMesh(A).Vertices.Start))
                            Vertex(1) = VectorToPOINTAPI(SVertex(VMesh(A).Vertices.Start + 1))
                            Vertex(2) = VectorToPOINTAPI(SVertex(VMesh(A).Vertices.Start + 2))
                            Vertex(3) = VectorToPOINTAPI(SVertex(VMesh(A).Vertices.Start + 3))
                            Call PolyBezier(Canvas.hdc, Vertex(0), 4)
                    End Select
                End If
            End If
        End If
    Next A
    
End Function
Function RemoveFace(FaceIndex As Integer)

    Dim A As Integer
    Dim B As Integer
    Dim Dummy As TFace
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If IsFaceInMesh(FaceIndex, A) = True Then
            For B = FaceIndex To GetAddressLast(VMesh(A).Faces)
                If B <> GetAddressLast(VMesh(A).Faces) Then
                    VFace(B) = VFace(B + 1)
                Else
                    VFace(B) = Dummy
                End If
            Next B
            VMesh(A).Faces.Length = VMesh(A).Faces.Length - 1
        End If
    Next A
    
End Function
Function RemoveVertex(VertexIndex As Integer, Substitute As Integer)

    Dim A As Integer
    Dim B As Integer
    Dim Dummy As Vector
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If IsVertexInMesh(VertexIndex, A) = True Then
            For B = VertexIndex To GetAddressLast(VMesh(A).Vertices)
                If B <> GetAddressLast(VMesh(A).Vertices) Then
                    VVertex(B) = VVertex(B + 1)
                Else
                    VVertex(B) = Dummy
                End If
            Next B
            VMesh(A).Vertices.Length = VMesh(A).Vertices.Length - 1
            For B = GetAddressLast(VMesh(A).Faces) To VMesh(A).Faces.Start Step -1
                If IsVertexInFace(VertexIndex, B) Then
                    If Substitute = 0 Then
                        Call RemoveFace(B)
                    Else
                        If VFace(B).A = VertexIndex Then VFace(B).A = Substitute
                        If VFace(B).B = VertexIndex Then VFace(B).B = Substitute
                        If VFace(B).C = VertexIndex Then VFace(B).C = Substitute
                    End If
                End If
                If VFace(B).A > VertexIndex Then VFace(B).A = VFace(B).A - 1
                If VFace(B).B > VertexIndex Then VFace(B).B = VFace(B).B - 1
                If VFace(B).C > VertexIndex Then VFace(B).C = VFace(B).C - 1
            Next B
        End If
    Next A
    
End Function
Function DrawFace(Canvas As PictureBox, FaceIndex As Integer, Color As ColorRGB)

    Dim Vertex(2) As POINTAPI
    
    Vertex(0).X = SVertex(VFace(FaceIndex).A).X
    Vertex(0).Y = SVertex(VFace(FaceIndex).A).Y
    Vertex(1).X = SVertex(VFace(FaceIndex).B).X
    Vertex(1).Y = SVertex(VFace(FaceIndex).B).Y
    Vertex(2).X = SVertex(VFace(FaceIndex).C).X
    Vertex(2).Y = SVertex(VFace(FaceIndex).C).Y
    Canvas.FillColor = ColorRGBToLong(Color)
    Call Polygon(Canvas.hdc, Vertex(0), 3)
    
End Function
Function AddMesh(Vertices As Integer, Faces As Integer) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    
    A = AllocateMesh
    B = AllocateVertices(Vertices)
    C = AllocateFaces(Faces)
    If A <> 0 And B <> 0 And C <> 0 Then
        AddMesh = A
        VMesh(A).Vertices.Start = B
        VMesh(A).Vertices.Length = Vertices
        VMesh(A).Faces.Start = C
        VMesh(A).Faces.Length = Faces
        VMesh(A).Scales = VectorUnit
        VMesh(A).UpdateTransformation = True
        VMesh(A).Visible = True
        VScene.Meshes.Length = VScene.Meshes.Length + 1
    Else
        Call ShowError(1)
    End If
    
End Function
Function RemoveMesh(MeshIndex As Integer)

    Dim A As Integer
    Dim Dummy As TMesh
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If A <> MeshIndex Then
            If VMesh(A).Parent <> 0 Then
                If VMesh(A).Parent = MeshIndex Then VMesh(A).Parent = 0
                If VMesh(A).Parent > MeshIndex Then VMesh(A).Parent = VMesh(A).Parent - 1
            End If
        End If
    Next A
    For A = MeshIndex To GetAddressLast(VScene.Meshes)
        If A <> GetAddressLast(VScene.Meshes) Then
            VMesh(A) = VMesh(A + 1)
        Else
            VMesh(A) = Dummy
        End If
    Next A
    VScene.Meshes.Length = VScene.Meshes.Length - 1
    
End Function
Function GetAddressLast(Address As TAddress) As Integer

    GetAddressLast = Address.Start - 1 + Address.Length
    
End Function
Function SetAddressLast(Address As TAddress, Last As Integer)

    Address.Length = Last - Address.Start + 1
    
End Function
Function ProjectScene(Canvas As PictureBox, CameraIndex As Integer)

    Dim A As Integer
    Dim B As Integer
    Dim CanvasCenter As Vector
    Dim SafeScale As Single
    Dim Height As Single
    Dim View As Matrix
    Dim BufferA As Vectrix
    
    CanvasCenter.X = (Canvas.ScaleWidth / 2)
    CanvasCenter.Y = (Canvas.ScaleHeight / 2)
    
    If CanvasCenter.X > CanvasCenter.Y Then
        SafeScale = CanvasCenter.X
    Else
        SafeScale = CanvasCenter.Y
    End If
    
    Height = VCamera(CameraIndex).FOVHalfTan * VCamera(CameraIndex).Front
    
    View = _
        TransformationView( _
            Height, VCamera(CameraIndex).Front, VCamera(CameraIndex).Back, _
            SafeScale, SafeScale, CanvasCenter.X, CanvasCenter.Y, _
            VCamera(CameraIndex).Orthographic, VCamera(CameraIndex).Zoom _
        )
        
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        If VMesh(A).Visible = True Then
            For B = VMesh(A).Vertices.Start To GetAddressLast(VMesh(A).Vertices)
                BufferA = VectorMatrixDotProductToVectrix(CVertex(B), View)
                If BufferA.S <> 0 Then _
                    SVertex(B) = VectorScale(VectrixToVector(BufferA), 1 / BufferA.S)
            Next B
        End If
    Next A
    
End Function
Function SetMeshBlank(MeshIndex As Integer)

    Dim A As Integer
    Dim Dummy As TFace
    
    For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
        VVertex(A) = VectorNull
    Next A
    For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
        VFace(A) = Dummy
    Next A
    
End Function
Function _
    TransformationView( _
        Height As Single, Front As Single, Back As Single, _
        ScaleX As Single, ScaleY As Single, OriginX As Single, OriginY As Single, _
        Orthographic As Boolean, Zoom As Single _
    ) _
        As Matrix

    If Front > 0 And Front < Back Then
        If Orthographic = False Then
            TransformationView = _
                MatrixInput( _
                    VectrixInput(ScaleX, 0, 0, 0), _
                    VectrixInput(0, -ScaleY, 0, 0), _
                    VectrixInput( _
                        OriginX * (Height / Front), _
                        OriginY * (Height / Front), _
                        (Height * Back) / (Front * (Back - Front)), _
                        Height / Front _
                    ), _
                    VectrixInput(0, 0, -(Height * Back) / (Back - Front), 0) _
                )
        Else
            TransformationView = _
                MatrixInput( _
                    VectrixInput(Zoom, 0, 0, 0), _
                    VectrixInput(0, -Zoom, 0, 0), _
                    VectrixInput(0, 0, 1 / (Back - Front), 0), _
                    VectrixInput(OriginX, OriginY, -Front / (Back - Front), 1) _
                )
        End If
    Else
        Call ShowError(4)
    End If
    
End Function
Function VertexByPoint(Point As POINTAPI) As Integer

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim CurrentDistance As Single
    Dim BestDistance As Single
    
    For A = VScene.Meshes.Start To GetAddressLast(VScene.Meshes)
        For B = VMesh(A).Vertices.Start To GetAddressLast(VMesh(A).Vertices)
             For C = LBound(FaceOrder) To UBound(FaceOrder)
                If FaceOrder(C) = 0 Then Exit For
                If IsVertexInFace(B, FaceOrder(C)) = True Then
                    CurrentDistance = _
                        ( _
                            (Point.X - SVertex(B).X) ^ 2 + _
                            (Point.Y - SVertex(B).Y) ^ 2 _
                        ) ^ _
                        (1 / 2)
                    If BestDistance = 0 Or CurrentDistance < BestDistance Then
                        BestDistance = CurrentDistance
                        VertexByPoint = B
                    End If
                    Exit For
                End If
            Next C
        Next B
    Next A
    
End Function
