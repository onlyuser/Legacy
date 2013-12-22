VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   120
      Top             =   720
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox Picture3 
      Height          =   495
      Left            =   2760
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   2
      Top             =   120
      Width           =   1215
   End
   Begin VB.PictureBox Picture2 
      Height          =   495
      Left            =   1440
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   1
      Top             =   120
      Width           =   1215
   End
   Begin VB.PictureBox Picture1 
      Height          =   495
      Left            =   120
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuNew 
         Caption         =   "New"
      End
      Begin VB.Menu mnuBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuLoad 
         Caption         =   "Load"
      End
      Begin VB.Menu mnuSave 
         Caption         =   "Save"
      End
      Begin VB.Menu mnuBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "Edit"
      Begin VB.Menu mnuRename 
         Caption         =   "Rename"
      End
      Begin VB.Menu mnuBar3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuColorOption 
         Caption         =   "Color White"
         Index           =   0
      End
      Begin VB.Menu mnuColorOption 
         Caption         =   "Color Random"
         Index           =   1
      End
      Begin VB.Menu mnuColorOption 
         Caption         =   "Color Gradient"
         Index           =   2
      End
      Begin VB.Menu mnuBar4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuTessellationOption 
         Caption         =   "Tessellate By Face"
         Index           =   0
      End
      Begin VB.Menu mnuTessellationOption 
         Caption         =   "Tessellate By Edge"
         Index           =   1
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "View"
      Begin VB.Menu mnuLight 
         Caption         =   "Light"
         Shortcut        =   ^L
      End
      Begin VB.Menu mnuOrthographic 
         Caption         =   "Orthographic"
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuBar5 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDrawStyleOption 
         Caption         =   "Wireframe"
         Index           =   0
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuDrawStyleOption 
         Caption         =   "Solid"
         Index           =   1
         Shortcut        =   {F2}
      End
      Begin VB.Menu mnuDrawStyleOption 
         Caption         =   "Flat"
         Index           =   2
         Shortcut        =   {F3}
      End
      Begin VB.Menu mnuDrawStyleOption 
         Caption         =   "Transparent"
         Index           =   3
         Shortcut        =   {F4}
      End
      Begin VB.Menu mnuDrawStyleOption 
         Caption         =   "Contour"
         Index           =   4
         Shortcut        =   {F5}
      End
      Begin VB.Menu mnuDrawStyleOption 
         Caption         =   "Gourad"
         Index           =   5
         Shortcut        =   {F6}
      End
      Begin VB.Menu mnuBar6 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDrawModeOption 
         Caption         =   "Double-Sided"
         Index           =   0
         Shortcut        =   ^D
      End
      Begin VB.Menu mnuDrawModeOption 
         Caption         =   "Metallic"
         Index           =   1
         Shortcut        =   ^M
      End
      Begin VB.Menu mnuDrawModeOption 
         Caption         =   "Atmosphere"
         Index           =   2
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuDrawModeOption 
         Caption         =   "Color-Correct"
         Index           =   3
         Shortcut        =   ^C
      End
   End
   Begin VB.Menu mnuObject 
      Caption         =   "Object"
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Box"
         Index           =   0
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Grid"
         Index           =   1
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Sphere"
         Index           =   2
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Hemisphere"
         Index           =   3
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Cone"
         Index           =   4
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Cylinder"
         Index           =   5
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Pie"
         Index           =   6
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Tetrahedron"
         Index           =   7
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Octahedron"
         Index           =   8
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Geo-Sphere"
         Index           =   9
      End
      Begin VB.Menu mnuBasicOption 
         Caption         =   "Torus"
         Index           =   10
      End
      Begin VB.Menu mnuBar7 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSpecialOption 
         Caption         =   "Pixel"
         Index           =   0
      End
      Begin VB.Menu mnuSpecialOption 
         Caption         =   "Line"
         Index           =   1
      End
      Begin VB.Menu mnuSpecialOption 
         Caption         =   "Text"
         Index           =   2
      End
      Begin VB.Menu mnuSpecialOption 
         Caption         =   "Curve"
         Index           =   3
      End
      Begin VB.Menu mnuBar8 
         Caption         =   "-"
      End
      Begin VB.Menu mnuComboOption 
         Caption         =   "Bar Graph"
         Index           =   0
      End
      Begin VB.Menu mnuComboOption 
         Caption         =   "Grid Graph"
         Index           =   1
      End
      Begin VB.Menu mnuComboOption 
         Caption         =   "Pie Graph"
         Index           =   2
      End
      Begin VB.Menu mnuBar9 
         Caption         =   "-"
      End
      Begin VB.Menu mnuOtherOption 
         Caption         =   "Ripple"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "About"
      End
      Begin VB.Menu mnuHomepage 
         Caption         =   "Homepage"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Form_Activate()

    Dim FrameRate As Single
    
    If BeginRenderLoop = True Then
        BeginRenderLoop = False
        Do
            If RefreshScene = True Then
                RefreshScene = False
                If TickCount < 10 Then
                    TickCount = TickCount + 1
                Else
                    FinishTime = Timer
                    If FinishTime <> BeginTime Then
                        FrameRate = TickCount / (FinishTime - BeginTime)
                        Form1.Caption = App.Title & " - " & Format(FrameRate, "0.00") & " fps"
                        TickCount = 0
                        BeginTime = Timer
                    End If
                End If
                LastFaceOver = 0
                If LockCamera = True Then
                    VLight(MyLight).Origin = _
                        VectorAdd( _
                            VectorNull, _
                            VectorScale( _
                                OrientationToVector(OrientationInput(0, OrbitLatitude, -OrbitLongitude)), _
                                -OrbitRadius _
                            ) _
                        )
                    If CameraModel <> 0 Then
                        VMesh(CameraModel).Origin = VLight(MyLight).Origin
                        VMesh(CameraModel).Angles.Pitch = OrbitLatitude
                        VMesh(CameraModel).Angles.Yaw = -OrbitLongitude
                        VMesh(CameraModel).UpdateTransformation = True
                    End If
                Else
                    Call OrbitCamera(MyCamera, VectorNull, OrbitRadius, OrbitLongitude, OrbitLatitude)
                    VLight(MyLight).Origin = VCamera(MyCamera).Origin
                End If
                Picture1.Cls
                Call RenderImage(Picture1, MyCamera)
                Picture1.ForeColor = vbWhite
                Picture1.Print "Longitude: " & Int(RadianToDegree(OrbitLongitude))
                Picture1.Print "Latitude: " & Int(RadianToDegree(OrbitLatitude))
                Picture1.Print "Radius: " & Int(OrbitRadius)
                Picture1.Print
                Picture1.Print "Name: " & VMesh(MyMesh).Tag
                Picture1.Print "Vertices: " & VMesh(MyMesh).Vertices.Length
                Picture1.Print "Faces: " & VMesh(MyMesh).Faces.Length
            End If
            DoEvents
        Loop
    End If
    
End Sub
Private Sub Form_Load()

    Dim Extension As String
    
    CommonDialog1.CancelError = True
    
    Call InitializeScene(Picture1)
    Call InitializeCanvas(Picture2)
    Call InitializeCanvas(Picture3)
    Picture1.BorderStyle = 0
    Picture2.BorderStyle = 0
    Picture3.BorderStyle = 0
    Picture1.BackColor = vbBlack
    Picture2.BackColor = vbBlack
    Picture3.BackColor = vbBlack
    
    TickCount = 10
    
    MyCamera = AddCamera
    VCamera(MyCamera).Zoom = 1
    VCamera(MyCamera).DrawStyle = 2
    mnuDrawStyleOption(2).Checked = True
    
    MyLight = AddLight
    mnuLight.Checked = True
    
    OrbitRadius = 200
    OrbitSpeed = 0.01
    DollySpeed = 1
    
    If Command <> "" Then
        Extension = LCase(Right(Command, 3))
        If Extension = "dex" Then MyMesh = LoadDexMesh(Command)
        If Extension = "3ds" Then
            MyMesh = 0
            Call Load3dsFile(Command)
            Call SetSceneColor(ColorLongToRGB(vbWhite), 0.5)
        End If
        Call CenterMesh(MyMesh)
        RefreshScene = True
    End If
    
    BeginRenderLoop = True
    
End Sub
Private Sub Form_Resize()

    Dim PaletteWidth As Integer
    
    PaletteWidth = Form1.ScaleHeight / 20
    
    Picture1.Move 0, 0, Form1.ScaleWidth - PaletteWidth, Form1.ScaleHeight - PaletteWidth
    Picture2.Move Form1.ScaleWidth - PaletteWidth, 0, PaletteWidth, Form1.ScaleHeight - PaletteWidth
    Picture3.Move 0, Form1.ScaleHeight - PaletteWidth, Form1.ScaleWidth, PaletteWidth
    
    RefreshScene = True
    
End Sub
Private Sub Form_Unload(Cancel As Integer)

    End
    
End Sub
Private Sub mnuAbout_Click()

    Call ShowAbout
    
End Sub
Private Sub mnuBasicOption_Click(Index As Integer)

    Randomize
    
    Call ResetScene(0, MyCamera, MyLight)
    Select Case Index
        Case 0
            MyMesh = AddMeshBox(VectorInput(40, 40, 40))
        Case 1
            MyMesh = AddMeshGrid(80, 80, 4, 4, False)
        Case 2
            MyMesh = AddMeshSphere(40, 16, 8)
        Case 3
            MyMesh = AddMeshHemisphere(40, 16, 4)
        Case 4
            MyMesh = AddMeshCone(40, 60, 16)
        Case 5
            MyMesh = AddMeshCylinder(40, 60, 16)
        Case 6
            MyMesh = AddMeshPie(80, 20, 0, 60, 32)
        Case 7
            MyMesh = AddMeshTetrahedron(40)
        Case 8
            MyMesh = AddMeshSphere(40, 4, 2)
        Case 9
            MyMesh = AddMeshGeoSphere(40, 2)
        Case 10
            MyMesh = AddMeshTorus(40, 10, 16, 8)
    End Select
    Call CenterMesh(MyMesh)
    Call SetMeshColor(MyMesh, ColorRandom, 0.5)
    RefreshScene = True
    
End Sub
Private Sub mnuColorOption_Click(Index As Integer)

    Select Case Index
        Case 0
            Call SetMeshColor(MyMesh, ColorLongToRGB(vbWhite), 0.5)
        Case 1
            Call SetMeshColorRandom(MyMesh)
        Case 2
            Call _
                SetMeshColorGradient( _
                    MyMesh, _
                    2, _
                    ColorLongToRGB(vbBlue), _
                    ColorLongToRGB(vbRed), _
                    0.5 _
                )
    End Select
    RefreshScene = True
    
End Sub
Private Sub mnuComboOption_Click(Index As Integer)

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim D() As Single
    Dim E() As Long
    
    Randomize
    
    Call ResetScene(0, MyCamera, MyLight)
    Select Case Index
        Case 0
            ReDim D(1 To 18)
            ReDim E(1 To 18)
            C = 1
            For A = 1 To 3
                For B = 1 To 6
                    D(C) = Rnd
                    E(C) = RGB(255 * Rnd, 255 * Rnd, 255 * Rnd)
                    C = C + 1
                Next B
            Next A
            MyMesh = AddMeshBarGraph(6, 3, VectorInput(80, 40, 40), 5, D(), E())
        Case 1
            ReDim D(1 To 25)
            ReDim E(1 To 25)
            C = 1
            For A = 1 To 5
                For B = 1 To 5
                    D(C) = Rnd
                    E(C) = RGB(255 * Rnd, 255 * Rnd, 255 * Rnd)
                    C = C + 1
                Next B
            Next A
            MyMesh = AddMeshGridGraph(5, 5, VectorInput(80, 40, 80), D(), vbBlue, vbRed, False)
        Case 2
            ReDim D(1 To 4)
            ReDim E(1 To 4)
            For A = 1 To 4
                D(A) = Rnd
                E(A) = RGB(255 * Rnd, 255 * Rnd, 255 * Rnd)
            Next A
            MyMesh = AddMeshPieGraph(40, 10, 16, D(), E())
    End Select
    RefreshScene = True
    
End Sub
Private Sub mnuDrawModeOption_Click(Index As Integer)

    mnuDrawModeOption(Index).Checked = Not mnuDrawModeOption(Index).Checked
    Select Case Index
        Case 0
            VCamera(MyCamera).DoubleSided = mnuDrawModeOption(Index).Checked
        Case 1
            VCamera(MyCamera).Metallic = mnuDrawModeOption(Index).Checked
        Case 2
            VCamera(MyCamera).Atmosphere = mnuDrawModeOption(Index).Checked
        Case 3
            VCamera(MyCamera).ColorCorrect = mnuDrawModeOption(Index).Checked
    End Select
    RefreshScene = True
    
End Sub
Private Sub mnuDrawStyleOption_Click(Index As Integer)

    mnuDrawStyleOption(VCamera(MyCamera).DrawStyle).Checked = False
    mnuDrawStyleOption(Index).Checked = True
    VCamera(MyCamera).DrawStyle = Index
    RefreshScene = True
    
End Sub
Private Sub mnuExit_Click()

    End
    
End Sub

Private Sub mnuHomepage_Click()

    Call Explore("http://members.xoom.com/onlyuser")
    
End Sub
Private Sub mnuLight_Click()

    mnuLight.Checked = Not mnuLight.Checked
    VLight(MyLight).Enabled = mnuLight.Checked
    RefreshScene = True
    
End Sub
Private Sub mnuLoad_Click()

    Dim Extension As String
    
    On Error Resume Next
    
    CommonDialog1.Filter = _
        "Dex3D Files (*.dex)|*.dex|3D Studio Files (*.3ds)|*.3ds|All Files (*.*)|*.*"
    CommonDialog1.ShowOpen
    If Err = 0 Then
        Call ResetScene(0, MyCamera, MyLight)
        Extension = LCase(Right(CommonDialog1.Filename, 3))
        If Extension = "dex" Then MyMesh = LoadDexMesh(CommonDialog1.Filename)
        If Extension = "3ds" Then
            MyMesh = 1
            Call Load3dsFile(CommonDialog1.Filename)
            Call SetSceneColor(ColorLongToRGB(vbWhite), 0.5)
        End If
        RefreshScene = True
    End If
    
End Sub
Private Sub mnuNew_Click()

    Call ResetScene(0, MyCamera, MyLight)
    RefreshScene = True
    
End Sub

Private Sub mnuOrthographic_Click()

    mnuOrthographic.Checked = Not mnuOrthographic.Checked
    VCamera(MyCamera).Orthographic = mnuOrthographic.Checked
    RefreshScene = True
    
End Sub
Private Sub mnuOtherOption_Click()

    Call ResetScene(0, MyCamera, MyLight)
    MyMesh = AddMeshGrid(80, 80, 10, 10, False)
    Call CenterMesh(MyMesh)
    Call RippleMesh(MyMesh, 40, 20, 0)
    Call SetMeshColorGradient(MyMesh, 2, ColorLongToRGB(vbBlue), ColorLongToRGB(vbRed), 0.5)
    RefreshScene = True
    
End Sub
Private Sub mnuRename_Click()

    VMesh(MyMesh).Tag = InputBox("Enter new name:", "Rename", VMesh(MyMesh).Tag)
    RefreshScene = True
    
End Sub
Private Sub mnuSave_Click()

    On Error Resume Next
    
    CommonDialog1.Filter = "Dex3D Files (*.dex)|*.dex|All Files (*.*)|*.*"
    CommonDialog1.ShowSave
    If Err = 0 Then Call SaveDexMesh(MyMesh, CommonDialog1.Filename)
    
End Sub
Private Sub mnuSpecialOption_Click(Index As Integer)

    Dim A As Integer
    
    Randomize
    
    Call ResetScene(0, MyCamera, MyLight)
    Select Case Index
        Case 0
            For A = 1 To 40
                MyMesh = AddMeshPoint(VectorScale(VectorRandom, 40))
                Call SetMeshColorRandom(MyMesh)
            Next A
        Case 1
            For A = 1 To 10
                MyMesh = _
                    AddMeshLine( _
                        VectorScale(VectorRandom, 40), _
                        VectorScale(VectorRandom, 40) _
                    )
                Call SetMeshColorRandom(MyMesh)
            Next A
        Case 2
            For A = 1 To 20
                MyMesh = AddMeshText("3D", VectorScale(VectorRandom, 40))
                Call SetMeshColorRandom(MyMesh)
            Next A
        Case 3
            For A = 1 To 10
                MyMesh = _
                    AddMeshCurve( _
                        VectorScale(VectorRandom, 40), _
                        VectorScale(VectorRandom, 40), _
                        VectorScale(VectorRandom, 40), _
                        VectorScale(VectorRandom, 40) _
                    )
                Call SetMeshColorRandom(MyMesh)
            Next A
    End Select
    RefreshScene = True
    
End Sub
Private Sub mnuTessellationOption_Click(Index As Integer)

    Select Case Index
        Case 0
            Call TessellateMeshByFace(MyMesh, 1)
        Case 1
            Call TessellateMeshByEdge(MyMesh, 1)
    End Select
    Call SetMeshColor(MyMesh, ColorLongToRGB(vbWhite), 0.5)
    RefreshScene = True
    
End Sub
Private Sub Picture1_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = CShift Then
        LockCamera = True
        If CameraModel = 0 Then
            CameraModel = AddMeshCone(10, 20, 4)
            Call CenterMesh(CameraModel)
            Call TransformMesh(CameraModel, TransformationTranslate(VectorInput(0, 20, 0)))
            Call TransformMesh(CameraModel, TransformationRotate(1, -Pi / 2))
            Call TransformMesh(CameraModel, TransformationRotate(3, Pi / 4))
            Call SetMeshColor(CameraModel, ColorLongToRGB(vbRed), 0.5)
            Form1.mnuFile.Enabled = False
            Form1.mnuEdit.Enabled = False
            Form1.mnuView.Enabled = False
            Form1.mnuObject.Enabled = False
            Form1.mnuHelp.Enabled = False
        End If
    End If
    
End Sub
Private Sub Picture1_KeyUp(KeyCode As Integer, Shift As Integer)

    If KeyCode = CShift Then
        LockCamera = False
        If CameraModel <> 0 Then
            Call RemoveMesh(CameraModel)
            CameraModel = 0
            Form1.mnuFile.Enabled = True
            Form1.mnuEdit.Enabled = True
            Form1.mnuView.Enabled = True
            Form1.mnuObject.Enabled = True
            Form1.mnuHelp.Enabled = True
        End If
        RefreshScene = True
    End If
    
End Sub
Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If FaceOver <> 0 Then
        If CameraModel = 0 Then
            Select Case Button
                Case 1
                    VFace(FaceOver).Color = ColorLongToRGB(BrushColor)
                    VFace(FaceOver).Alpha = BrushAlpha
                    RefreshScene = True
                Case 2
                    BrushColor = ColorRGBToLong(VFace(FaceOver).Color)
                    BrushAlpha = VFace(FaceOver).Alpha
                    Call Picture3_Resize
            End Select
        End If
    End If
    
End Sub
Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button <> 0 Then
        Select Case Button
            Case 1 'orbit
                Picture1.MousePointer = 15
                OrbitLongitude = OrbitLongitude - (X - LastMousePosition.X) * OrbitSpeed
                OrbitLatitude = OrbitLatitude + (Y - LastMousePosition.Y) * OrbitSpeed
                If OrbitLongitude > Pi Then OrbitLongitude = OrbitLongitude - (2 * Pi)
                If OrbitLongitude < -Pi Then OrbitLongitude = OrbitLongitude + (2 * Pi)
                If OrbitLatitude > (Pi / 2) Then OrbitLatitude = (Pi / 2)
                If OrbitLatitude < -(Pi / 2) Then OrbitLatitude = -(Pi / 2)
            Case 2 'dolly
                Picture1.MousePointer = 7
                OrbitRadius = OrbitRadius + (Y - LastMousePosition.Y) * DollySpeed
                If OrbitRadius < 0 Then OrbitRadius = 0
        End Select
        RefreshScene = True
    Else
        If CameraModel = 0 Then
            FaceOver = FaceByPoint(POINTAPIInput(Int(X), Int(Y)))
            If FaceOver <> 0 Then
                Picture1.MousePointer = 2
            Else
                Picture1.MousePointer = 0
            End If
            If FaceOver <> LastFaceOver Then
                Picture1.DrawMode = 6
                Picture1.DrawStyle = 0
                Picture1.FillStyle = 1
                If LastFaceOver <> 0 Then Call DrawFace(Picture1, LastFaceOver, ColorNull)
                LastFaceOver = FaceOver
                Call DrawFace(Picture1, FaceOver, ColorNull)
                Picture1.Refresh
            End If
        Else
            Picture1.MousePointer = 0
        End If
    End If
    LastMousePosition.X = X
    LastMousePosition.Y = Y
    
End Sub
Private Sub Picture2_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Call Picture2_MouseMove(Button, Shift, X, Y)
    
End Sub
Private Sub Picture2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Picture2.MousePointer = 2
    If Button <> 0 Then
        PaletteColor = GetPixel(Picture2.hdc, X, Y)
        If PaletteColor <> -1 Then BrushColor = PaletteColor
        Call Picture3_Resize
    End If
    
End Sub
Private Sub Picture2_Resize()

    Picture2.Cls
    Call DrawColorSpectrum(Picture2, 0, 0, Picture2.ScaleWidth, Picture2.ScaleHeight, 2)
    
End Sub
Private Sub Picture3_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Call Picture3_MouseMove(Button, Shift, X, Y)
    
End Sub
Private Sub Picture3_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Picture3.MousePointer = 9
    If Button <> 0 Then
        BrushAlpha = Abs(X - Picture3.ScaleWidth / 2) / (Picture3.ScaleWidth / 2)
        If BrushAlpha > 1 Then BrushAlpha = 1
        Call Picture3_Resize
    End If
    
End Sub
Private Sub Picture3_Resize()

    Picture3.Cls
    Call DrawColorShades(Picture3, 0, 0, Picture3.ScaleWidth, Picture3.ScaleHeight, 1, BrushColor)
    Call _
        DrawArrow( _
            Picture3, _
            Picture3.ScaleWidth / 2 + BrushAlpha * Picture3.ScaleWidth / 2, _
            0, _
            1, _
            Picture3.Height, _
            vbWhite, _
            5 _
        )
    Call _
        DrawArrow( _
            Picture3, _
            Picture3.ScaleWidth / 2 - BrushAlpha * Picture3.ScaleWidth / 2, _
            0, _
            1, _
            Picture3.Height, _
            vbWhite, _
            5 _
        )
        
End Sub
