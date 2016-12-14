Attribute VB_Name = "Module1"
Option Explicit

Public Const GRADIENT_FILL_TRIANGLE = &H2

Type POINTAPI
    x As Long
    y As Long
End Type

Type TRIVERTEX
    x As Long
    y As Long
    Red As Integer
    Green As Integer
    Blue As Integer
    Alpha As Integer
End Type

Type GRADIENT_TRIANGLE
    Vertex1 As Long
    Vertex2 As Long
    Vertex3 As Long
End Type

Declare Sub Dex3D_RegUserFunc Lib "dex3d" ( _
        ByVal pEventFunc As Long, _
        ByVal pClearFunc As Long, _
        ByVal pPrintFunc As Long, _
        ByVal pTriFunc As Long, _
        ByVal pGradFunc As Long, _
        ByVal pPixFunc As Long _
    )
Declare Sub Dex3D_SetScene Lib "dex3d" (ByVal pCamIndex As Long, ByVal pWidth As Long, ByVal pHeight As Long, ByVal pDrawMode As Long, ByVal pDblSided As Boolean)
Declare Function Dex3D_Render Lib "dex3d" (ByVal pCamIndex As Long) As Long
Declare Sub Dex3D_Reset Lib "dex3d" ()

Declare Function Dex3D_AddMesh Lib "dex3d" (ByVal pVertCount As Long, ByVal pFaceCount As Long) As Long
Declare Function Dex3D_AddCamera Lib "dex3d" () As Long
Declare Function Dex3D_AddLight Lib "dex3d" () As Long

Declare Function Dex3D_RemMesh Lib "dex3d" (ByVal pIndex As Long) As Long
Declare Function Dex3D_RemCamera Lib "dex3d" (ByVal pIndex As Long) As Long
Declare Function Dex3D_RemLight Lib "dex3d" (ByVal pIndex As Long) As Long

Declare Sub Dex3D_SetMesh Lib "dex3d" (ByVal pMeshIndex As Long, ByVal pVisible As Long)
Declare Sub Dex3D_SetCamera Lib "dex3d" (ByVal pCamIndex As Long, ByVal pFov As Single, ByVal pNear As Single, ByVal pFar As Single, ByVal pPerspect As Long, ByVal pZoom As Single, ByVal pReflect As Long, ByVal pFog As Long)
Declare Sub Dex3D_SetLight Lib "dex3d" (ByVal pLightIndex As Long, ByVal pColor As Long, ByVal pNear As Single, ByVal pFar As Single)

Declare Sub Dex3D_MoveMesh Lib "dex3d" (ByVal pMeshIndex As Long, ByVal pMoveOp As Long, ByVal a As Single, ByVal b As Single, ByVal c As Single)
Declare Sub Dex3D_MoveCamera Lib "dex3d" (ByVal pCamIndex As Long, ByVal pMoveOp As Long, ByVal a As Single, ByVal b As Single, ByVal c As Single)
Declare Sub Dex3D_MoveLight Lib "dex3d" (ByVal pLightIndex As Long, ByVal x As Single, ByVal y As Single, ByVal z As Single)

Declare Sub Dex3D_SetVertex Lib "dex3d" (ByVal pMeshIndex As Long, ByVal pVertIndex As Long, ByVal x As Single, ByVal y As Single, ByVal z As Single)
Declare Sub Dex3D_SetFace Lib "dex3d" (ByVal pMeshIndex As Long, ByVal pFaceIndex As Long, ByVal a As Long, ByVal b As Long, ByVal c As Long)
Declare Sub Dex3D_SetColor Lib "dex3d" (ByVal pMeshIndex As Long, ByVal pFaceIndex As Long, ByVal pColor As Long, ByVal pAlpha As Single)
Declare Sub Dex3D_SetAxis Lib "dex3d" (ByVal pMeshIndex As Long, ByVal x As Single, ByVal y As Single, ByVal z As Single)

Declare Sub Dex3D_CenterAxis Lib "dex3d" (ByVal pMeshIndex As Long)
Declare Sub Dex3D_OrbitCamera Lib "dex3d" (ByVal pCamIndex As Long, ByVal x As Single, ByVal y As Single, ByVal z As Single, ByVal pRadius As Single, ByVal pLongitude As Single, ByVal pLatitude As Single)
Declare Sub Dex3D_LinkMesh Lib "dex3d" (ByVal pMeshIndexA As Long, ByVal pMeshIndexB As Long)
Declare Sub Dex3D_FlipFaces Lib "dex3d" (ByVal pMeshIndex As Long)

Declare Function Dex3D_AddPoly Lib "dex3d" (ByVal pRadius As Single, ByVal pLngSteps As Long, ByVal pLatSteps As Long) As Long
Declare Function Dex3D_Load Lib "dex3d" (ByVal pFilename As String, ByVal pMeshIndex As Long) As Long
Declare Sub Dex3D_Save Lib "dex3d" (ByVal pFilename As String, ByVal pMeshIndex As Long)
Declare Function Dex3D_Load3ds Lib "dex3d" (ByVal pFilename As String, ByVal pMeshIndex As Long) As Long

Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Declare Function Polygon Lib "gdi32" (ByVal hdc As Long, lpPoint As POINTAPI, ByVal nCount As Long) As Long
Declare Function SetPixelV Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Declare Function GradientFill Lib "msimg32.dll" (ByVal hdc As Long, PVertex As TRIVERTEX, ByVal dwNumVertex As Long, PMesh As Any, ByVal dwNumMesh As Long, ByVal dwMode As Long) As Boolean

Public mPoint(2) As POINTAPI
Public mVertex(2) As TRIVERTEX
Public mFace As GRADIENT_TRIANGLE
Sub Main()

    mFace.Vertex1 = 0
    mFace.Vertex2 = 1
    mFace.Vertex3 = 2
    Form1.Show
    
End Sub
Function AddBox(x1 As Long, y1 As Long, z1 As Long, x2 As Long, y2 As Long, z2 As Long) As Long

    Dim Result As Integer
    
    Result = Dex3D_AddMesh(8, 12)
    Call Dex3D_SetVertex(Result, 0, x1, y1, z1)
    Call Dex3D_SetVertex(Result, 1, x2, y1, z1)
    Call Dex3D_SetVertex(Result, 2, x2, y1, z2)
    Call Dex3D_SetVertex(Result, 3, x1, y1, z2)
    Call Dex3D_SetVertex(Result, 4, x1, y2, z1)
    Call Dex3D_SetVertex(Result, 5, x2, y2, z1)
    Call Dex3D_SetVertex(Result, 6, x2, y2, z2)
    Call Dex3D_SetVertex(Result, 7, x1, y2, z2)
    Call Dex3D_SetFace(Result, 0, 0, 4, 5)
    Call Dex3D_SetFace(Result, 1, 0, 5, 1)
    Call Dex3D_SetFace(Result, 2, 1, 5, 6)
    Call Dex3D_SetFace(Result, 3, 1, 6, 2)
    Call Dex3D_SetFace(Result, 4, 2, 6, 7)
    Call Dex3D_SetFace(Result, 5, 2, 7, 3)
    Call Dex3D_SetFace(Result, 6, 3, 7, 4)
    Call Dex3D_SetFace(Result, 7, 3, 4, 0)
    Call Dex3D_SetFace(Result, 8, 3, 0, 1)
    Call Dex3D_SetFace(Result, 9, 3, 1, 2)
    Call Dex3D_SetFace(Result, 10, 4, 7, 6)
    Call Dex3D_SetFace(Result, 11, 4, 6, 5)
    AddBox = Result
    
End Function
Function ToString(ByteArray() As Byte) As String

    Dim i As Long
    Dim Result As String
    
    i = 0
    Do While ByteArray(i) <> 0
        Result = Result & Chr(ByteArray(i))
        i = i + 1
    Loop
    ToString = Result
    
End Function
Sub EventFunc()

    Form1.Picture1.Refresh
    DoEvents
    
End Sub
Sub ClearFunc()

    Form1.Picture1.Cls
    
End Sub
Sub PrintFunc(ByVal TextAddress As Long, ByVal Length As Long, ByVal x As Long, ByVal y As Long, ByVal Color As Long)

    Dim ByteArray() As Byte
    Dim Text As String
    
    ReDim ByteArray(Length)
    Call CopyMemory(ByteArray(0), ByVal TextAddress, ByVal Length)
    Text = ToString(ByteArray)
    Form1.Picture1.CurrentX = x
    Form1.Picture1.CurrentY = y
    Form1.Picture1.ForeColor = Color
    Form1.Picture1.Print Text
    
End Sub
Sub TriFunc( _
        ByVal x1 As Long, ByVal y1 As Long, _
        ByVal x2 As Long, ByVal y2 As Long, _
        ByVal x3 As Long, ByVal y3 As Long, _
        ByVal Color As Long _
    )

    mPoint(0).x = x1
    mPoint(0).y = y1
    mPoint(1).x = x2
    mPoint(1).y = y2
    mPoint(2).x = x3
    mPoint(2).y = y3
    Form1.Picture1.ForeColor = Color
    Form1.Picture1.FillColor = Color
    Call Polygon(Form1.Picture1.hdc, mPoint(0), 3)
    
End Sub
Function ColorElem(Code As Long, Color As Long) As Long

    Dim Result As Long
    
    Select Case Code
        Case 0: Result = (Color And &HFF&)
        Case 1: Result = (Color And &HFF00&) / &H100&
        Case 2: Result = (Color And &HFF0000) / &H10000
    End Select
    ColorElem = Result
    
End Function
Sub GradFunc( _
        ByVal x1 As Long, ByVal y1 As Long, _
        ByVal x2 As Long, ByVal y2 As Long, _
        ByVal x3 As Long, ByVal y3 As Long, _
        ByVal c1 As Long, _
        ByVal c2 As Long, _
        ByVal c3 As Long _
    )

    mVertex(0).x = x1
    mVertex(0).y = y1
    mVertex(0).Red = "&H" & Hex(ColorElem(0, c1)) & "00"
    mVertex(0).Green = "&H" & Hex(ColorElem(1, c1)) & "00"
    mVertex(0).Blue = "&H" & Hex(ColorElem(2, c1)) & "00"
    mVertex(1).x = x2
    mVertex(1).y = y2
    mVertex(1).Red = "&H" & Hex(ColorElem(0, c2)) & "00"
    mVertex(1).Green = "&H" & Hex(ColorElem(1, c2)) & "00"
    mVertex(1).Blue = "&H" & Hex(ColorElem(2, c2)) & "00"
    mVertex(2).x = x3
    mVertex(2).y = y3
    mVertex(2).Red = "&H" & Hex(ColorElem(0, c3)) & "00"
    mVertex(2).Green = "&H" & Hex(ColorElem(1, c3)) & "00"
    mVertex(2).Blue = "&H" & Hex(ColorElem(2, c3)) & "00"
    Call GradientFill(Form1.Picture1.hdc, mVertex(0), 3, mFace, 1, GRADIENT_FILL_TRIANGLE)
    
End Sub
Sub PixFunc(ByVal x As Long, ByVal y As Long, ByVal Color As Long)

    Call SetPixelV(Form1.Picture1.hdc, x, y, Color)
    
End Sub
