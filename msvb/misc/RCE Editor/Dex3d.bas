Attribute VB_Name = "Module6"
Public View$
Public Zoom!
Public OffsetX!
Public OffsetY!

Public Longitude!
Public Latitude!
Public Radius!

Public OrbitDir%
Public OrbitIncre!

Public MDPos As Point2D
Public MDBtn%

Public OrbitSns!
Public DollySns!
Public ZoomSns!

Public Unit!

Public AddElem As Boolean
Public RemElem As Boolean

Public AutoFix As Boolean

Public CurMesh%
Public CurCamera%
Public CurColor As ColorRGB

Public Type Header
    ScriptRng As Range2E
End Type

Public Type Script
    Exist As Boolean
    Tag As String
    File As String
    CurKey As Integer
    KeyRng As Range2E
    CurStep As Integer
    Steps As Integer
End Type

Public Type VectorX
    Exist As Boolean
    Tag As String
    Vect As Vector
End Type

Public FHeader As Header
Public FScript(1000) As Script
Public FKey(1000) As VectorX

Public PlayDir%
Function GetNextMesh%(MeshIndex%, Dir%)

    Dim A%

    If Dir = 1 Then
        For A = MeshIndex To FWorld.MeshRng.Fin Step 1
            If A <> MeshIndex And FMesh(A).Exist = True And FMesh(A).Edit = True Then
                GetNextMesh = A
                Exit For
            End If
        Next A
    End If
    If Dir = -1 Then
        For A = MeshIndex To FWorld.MeshRng.Bgn Step -1
            If A <> MeshIndex And FMesh(A).Exist = True And FMesh(A).Edit = True Then
                GetNextMesh = A
                Exit For
            End If
        Next A
    End If
    If GetNextMesh = 0 Then
        If Dir = 1 Then
            For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin Step 1
                If FMesh(A).Exist = True And FMesh(A).Edit = True Then
                    GetNextMesh = A
                    Exit For
                End If
            Next A
        End If
        If Dir = -1 Then
            For A = FWorld.MeshRng.Fin To FWorld.MeshRng.Bgn Step -1
                If FMesh(A).Exist = True And FMesh(A).Edit = True Then
                    GetNextMesh = A
                    Exit For
                End If
            Next A
        End If
    End If
    
End Function

Function LoadHeader(FileName$)

    'opens header from file

    Dim A%
    Dim CurData$
    Dim CurType$
    Dim CurField$
    Dim CurRecord$
    
    Open FileName For Input As 1
    
        Do Until EOF(1)
                    
            Line Input #1, CurData
            
            If CntStr(CurData, ">") = 0 Then GoTo FoundItem
            
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
            
            If CurType = "Header" Then
                If CurField = "ScriptRng.Bgn" Then
                    FHeader.ScriptRng.Bgn = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "ScriptRng.Fin" Then
                    FHeader.ScriptRng.Fin = CurRecord
                    GoTo FoundItem
                End If
            End If
            
            If CurType = "Script" Then
                If CurField = "Exist" Then
                    FScript(A).Exist = StrToBool(CurRecord)
                    GoTo FoundItem
                End If
                If CurField = "Tag" Then
                    FScript(A).Tag = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "File" Then
                    FScript(A).File = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "KeyRng.Bgn" Then
                    FScript(A).KeyRng.Bgn = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "KeyRng.Fin" Then
                    FScript(A).KeyRng.Fin = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Steps" Then
                    FScript(A).Steps = CurRecord
                    GoTo FoundItem
                End If
            End If

            If CurType = "Key" Then
                If CurField = "Exist" Then
                    FKey(A).Exist = StrToBool(CurRecord)
                    GoTo FoundItem
                End If
                If CurField = "Tag" Then
                    FKey(A).Tag = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Rot.X" Then
                    FKey(A).Vect.Rot.X = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Rot.Y" Then
                    FKey(A).Vect.Rot.Y = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Rot.Z" Then
                    FKey(A).Vect.Rot.Z = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Trans.X" Then
                    FKey(A).Vect.Trans.X = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Trans.Y" Then
                    FKey(A).Vect.Trans.Y = CurRecord
                    GoTo FoundItem
                End If
                If CurField = "Vect.Trans.Z" Then
                    FKey(A).Vect.Trans.Z = CurRecord
                    GoTo FoundItem
                End If
            End If
                                    
FoundItem:
            
        Loop
        
    Close 1

    For A = FHeader.ScriptRng.Bgn To FHeader.ScriptRng.Fin
        If FScript(A).Exist = True Then
            FScript(A).CurStep = 0
            FScript(A).CurKey = 0
            Call OpenWorld(FScript(A).File, True)
        End If
    Next A

End Function
Function EnumElem%(Elem$, MeshIndex%)

    Dim A%
    Dim BufferA%
    
    BufferA = 0
    If Elem = "Point" Then
        For A = FMesh(MeshIndex).PointRng.Bgn To FMesh(MeshIndex).PointRng.Fin
            If FPoint(A).Exist = True Then BufferA = BufferA + 1
        Next A
        EnumElem = BufferA
    End If
    BufferA = 0
    If Elem = "Line" Then
        For A = FMesh(MeshIndex).LineRng.Bgn To FMesh(MeshIndex).LineRng.Fin
            If FLine(A).Exist = True Then BufferA = BufferA + 1
        Next A
        EnumElem = BufferA
    End If

End Function
Function GetMesh%(Tag$)

    Dim A%
    
    For A = FWorld.MeshRng.Bgn To FWorld.MeshRng.Fin
        If FMesh(A).Exist = True Then
            If FMesh(A).Tag = Tag Then
                GetMesh = A
                Exit For
            End If
        End If
    Next A

End Function
Function ResetMDPos!(AxisName$, Scr As PictureBox, X!, Y!, Zoom!, OffsetX!, OffsetY!, Unit!)

    Dim BufferA!

    If AxisName = "Opp" Then BufferA = (X - Scr.ScaleWidth / 2 - OffsetX) / Zoom
    If AxisName = "Adj" Then BufferA = ((Scr.ScaleHeight - Y) - Scr.ScaleHeight / 2 - OffsetY) / Zoom

    ResetMDPos = Round(BufferA, Unit)

End Function
Function GetNextElem%(Elem$, Mesh%)

    Dim A%
    
    If Elem = "Point" Then
        If FMesh(Mesh).Exist = True Then
            For A = FMesh(Mesh).PointRng.Bgn To FMesh(Mesh).PointRng.Fin
                If FPoint(A).Exist = False Then
                    GetNextElem = A
                    Exit Function
                End If
            Next A
        End If
    End If
    If Elem = "Line" Then
        If FMesh(Mesh).Exist = True Then
            For A = FMesh(Mesh).LineRng.Bgn To FMesh(Mesh).LineRng.Fin
                If FLine(A).Exist = False Then
                    GetNextElem = A
                    Exit Function
                End If
            Next A
        End If
    End If

End Function
Function DrawGrid(Scr As PictureBox, View$, Zoom!, OffsetX!, OffsetY!, Unit!)

    Dim A!
    Dim B!
    Dim BufferA!
    Dim BufferB!
    Dim BufferC!
    Dim BufferD!
    
    Scr.Line _
        ( _
            Scr.ScaleWidth / 2 + OffsetX, _
            0 _
        )- _
        ( _
            Scr.ScaleWidth / 2 + OffsetX, _
            Scr.ScaleHeight _
        ), _
        RGB(150, 150, 150)
    Scr.Line _
        ( _
            0, _
            Scr.ScaleHeight / 2 - OffsetY _
        )- _
        ( _
            Scr.ScaleWidth, _
            Scr.ScaleHeight / 2 - OffsetY _
        ), _
        RGB(150, 150, 150)
    
    Scr.ForeColor = RGB(150, 150, 150)
    If View = "Top" Then
        Scr.CurrentX = Scr.ScaleWidth - 10
        Scr.CurrentY = Scr.ScaleHeight / 2 - OffsetY
        Scr.Print "X"
        Scr.CurrentX = Scr.ScaleWidth / 2 + OffsetX
        Scr.CurrentY = 0
        Scr.Print "Y"
    End If
    If View = "Back" Then
        Scr.CurrentX = Scr.ScaleWidth - 10
        Scr.CurrentY = Scr.ScaleHeight / 2 - OffsetY
        Scr.Print "X"
        Scr.CurrentX = Scr.ScaleWidth / 2 + OffsetX
        Scr.CurrentY = 0
        Scr.Print "Z"
    End If
    If View = "Right" Then
        Scr.CurrentX = Scr.ScaleWidth - 10
        Scr.CurrentY = Scr.ScaleHeight / 2 - OffsetY
        Scr.Print "Y"
        Scr.CurrentX = Scr.ScaleWidth / 2 + OffsetX
        Scr.CurrentY = 0
        Scr.Print "Z"
    End If
    If View = "Bottom" Then
        Scr.CurrentX = 0
        Scr.CurrentY = Scr.ScaleHeight / 2 - OffsetY
        Scr.Print "X"
        Scr.CurrentX = Scr.ScaleWidth / 2 + OffsetX
        Scr.CurrentY = 0
        Scr.Print "Y"
    End If
    If View = "Front" Then
        Scr.CurrentX = 0
        Scr.CurrentY = Scr.ScaleHeight / 2 - OffsetY
        Scr.Print "X"
        Scr.CurrentX = Scr.ScaleWidth / 2 + OffsetX
        Scr.CurrentY = 0
        Scr.Print "Z"
    End If
    If View = "Left" Then
        Scr.CurrentX = 0
        Scr.CurrentY = Scr.ScaleHeight / 2 - OffsetY
        Scr.Print "Y"
        Scr.CurrentX = Scr.ScaleWidth / 2 + OffsetX
        Scr.CurrentY = 0
        Scr.Print "Z"
    End If
    Scr.ForeColor = vbBlack
    
    For A = 0 To 100 Step Unit
        BufferA = A * Zoom
        For B = 0 To 100 Step Unit
            BufferB = B * Zoom
            BufferC = Scr.ScaleWidth / 2 + BufferA + OffsetX ',
            BufferD = Scr.ScaleHeight - (Scr.ScaleWidth / 2 + BufferB + OffsetY) '_
            If InScr(Scr, BufferC, BufferD) Then Scr.PSet (BufferC, BufferD), RGB(150, 150, 150)
            BufferC = Scr.ScaleWidth / 2 + BufferA + OffsetX ',
            BufferD = Scr.ScaleHeight - (Scr.ScaleWidth / 2 - BufferB + OffsetY) '_
            If InScr(Scr, BufferC, BufferD) Then Scr.PSet (BufferC, BufferD), RGB(150, 150, 150)
            BufferC = Scr.ScaleWidth / 2 - BufferA + OffsetX ',
            BufferD = Scr.ScaleHeight - (Scr.ScaleWidth / 2 - BufferB + OffsetY) '_
            If InScr(Scr, BufferC, BufferD) Then Scr.PSet (BufferC, BufferD), RGB(150, 150, 150)
            BufferC = Scr.ScaleWidth / 2 - BufferA + OffsetX ',
            BufferD = Scr.ScaleHeight - (Scr.ScaleWidth / 2 + BufferB + OffsetY) '_
            If InScr(Scr, BufferC, BufferD) Then Scr.PSet (BufferC, BufferD), RGB(150, 150, 150)
        Next B
    Next A

End Function
Function RunScript(Dir%)

    Dim A%
    Dim B%
    Dim C%
    Dim D%
    Dim E%
    Dim F%
    Dim G%
    Dim H%
    Dim I%
    Dim J!
    
    For A = FHeader.ScriptRng.Bgn To FHeader.ScriptRng.Fin
        If FScript(A).Exist = True Then
            B = GetMesh(FScript(A).Tag) 'current mesh index
            If FMesh(B).Exist = True Then
                C = FScript(A).CurKey
                D = FScript(A).KeyRng.Bgn
                E = FScript(A).KeyRng.Fin
                F = FScript(A).CurStep
                G = FScript(A).Steps
                H = E - (D - 1) 'keys
                If Dir = -1 Then I = E + ((C - E) - 1) Mod H 'real previous key
                If Dir = 0 Then I = C
                If Dir = 1 Then I = D + ((C - D) + 1) Mod H  'real next key
                J = F / G 'step completion ratio
                FMesh(B).Vect.Rot.X = FKey(C).Vect.Rot.X + (FKey(I).Vect.Rot.X - FKey(C).Vect.Rot.X) * J
                FMesh(B).Vect.Rot.Y = FKey(C).Vect.Rot.Y + (FKey(I).Vect.Rot.Y - FKey(C).Vect.Rot.Y) * J
                FMesh(B).Vect.Rot.Z = FKey(C).Vect.Rot.Z + (FKey(I).Vect.Rot.Z - FKey(C).Vect.Rot.Z) * J
                FMesh(B).Vect.Trans.X = FKey(C).Vect.Trans.X + (FKey(I).Vect.Trans.X - FKey(C).Vect.Trans.X) * J
                FMesh(B).Vect.Trans.Y = FKey(C).Vect.Trans.Y + (FKey(I).Vect.Trans.Y - FKey(C).Vect.Trans.Y) * J
                FMesh(B).Vect.Trans.Z = FKey(C).Vect.Trans.Z + (FKey(I).Vect.Trans.Z - FKey(C).Vect.Trans.Z) * J
                FScript(A).CurStep = FScript(A).CurStep + 1
                If Dir = 1 Then
                    If FScript(A).CurStep = FScript(A).Steps Then
                        FScript(A).CurStep = 0
                        FScript(A).CurKey = FScript(A).CurKey + 1
                    End If
                End If
                If Dir = -1 Then
                    If FScript(A).CurStep = FScript(A).Steps Then
                        FScript(A).CurStep = 0
                        FScript(A).CurKey = FScript(A).CurKey - 1
                    End If
                End If
                If FScript(A).CurKey > FScript(A).KeyRng.Fin Then
                    FScript(A).CurKey = FScript(A).KeyRng.Bgn
                End If
                If FScript(A).CurKey < FScript(A).KeyRng.Bgn Then
                    FScript(A).CurKey = FScript(A).KeyRng.Fin
                End If
            End If
        End If
    Next A

End Function
Function SetDefCfg()

    Dim BufferA%

    Call AddMesh(10, 20)
    Call SetRndMesh(FWorld.MeshRng.Fin, 100)
    BufferA = FWorld.MeshRng.Fin
    
    Call AddMesh(8, 12)
    FMesh(FWorld.MeshRng.Fin).Edit = True
    FMesh(BufferA).BoundBox = FWorld.MeshRng.Fin
    
    Call AddMesh(3, 4)
    FMesh(FWorld.MeshRng.Fin).Edit = True
    FMesh(BufferA).VectAxis = FWorld.MeshRng.Fin

    Call AddCamera

    CurMesh = 1
    CurCamera = 1
    
    CurColor.R = 255
    CurColor.G = 255
    CurColor.B = 255
    
    View = "Perceptive Camera (Flat)"
    Zoom = 1
    OffsetX = 0
    OffsetY = 0
    
    Radius = 300
    Longitude = 0
    Latitude = 0
    
    OrbitSns = 1
    DollySns = 1
    ZoomSns = 0.01
    Unit = 10
    
    OrbitDir = 0
    OrbitIncre = 5
    
    AutoFix = False

    PlayDir = 0

End Function
Function KeyCommand(KeyCode%, Mesh%, Camera%)

    If KeyCode = 27 Then 'escape
        End
    End If
    
    If KeyCode = 192 Then '`
        Call SetBlkMesh(Mesh)
    End If
    
    If Chr(KeyCode) = "T" Then View = "Top"
    If Chr(KeyCode) = "K" Then View = "Back"
    If Chr(KeyCode) = "R" Then View = "Right"
    If Chr(KeyCode) = "B" Then View = "Bottom"
    If Chr(KeyCode) = "F" Then View = "Front"
    If Chr(KeyCode) = "L" Then View = "Left"
    If Chr(KeyCode) = "Q" Then View = "Linear Camera"
    If Chr(KeyCode) = "A" Then View = "Perceptive Camera (Flat)"
    If Chr(KeyCode) = "Z" Then View = "Perceptive Camera (Ang)"
    
    If KeyCode = 8 Then 'backspace
        Call SetRndMesh(Mesh, 100)
    End If
    
    If KeyCode = 13 Then 'enter
        If FCamera(Camera).Atm = True Then
            FCamera(Camera).Atm = False
        ElseIf FCamera(Camera).Atm = False Then
            FCamera(Camera).Atm = True
        End If
    End If
    If KeyCode = 16 Then 'shift
        If FCamera(Camera).Mode = "All" Then
            FCamera(Camera).Mode = "Point"
        ElseIf FCamera(Camera).Mode = "Point" Then
            FCamera(Camera).Mode = "Line"
        ElseIf FCamera(Camera).Mode = "Line" Then
            FCamera(Camera).Mode = "All"
        End If
        SelElem = ""
        SelIndex = 0
    End If
    If KeyCode = 17 Then 'control
        FMesh(Mesh).Vect.Rot.X = 0
        FMesh(Mesh).Vect.Rot.Y = 0
        FMesh(Mesh).Vect.Rot.Z = 0
        FMesh(Mesh).Vect.Trans.X = 0
        FMesh(Mesh).Vect.Trans.Y = 0
        FMesh(Mesh).Vect.Trans.Z = 0
    End If
    If KeyCode = 32 Then 'space
        Radius = 0
        Longitude = 0
        Latitude = 0
        Zoom = 1
        OffsetX = 0
        OffsetY = 0
    End If
    
    If KeyCode = 219 Then '[
        OrbitDir = -1
    End If
    If KeyCode = 222 Then ''
        OrbitDir = 0
    End If
    If KeyCode = 221 Then ']
        OrbitDir = 1
    End If
    If KeyCode = 186 Then ';
        If FCamera(Camera).Filt.R = 1 Then
            FCamera(Camera).Filt.R = 0
        ElseIf FCamera(Camera).Filt.R = 0 Then
            FCamera(Camera).Filt.R = 1
        End If
    End If
    If KeyCode = 190 Then '.
        If FCamera(Camera).Filt.G = 1 Then
            FCamera(Camera).Filt.G = 0
        ElseIf FCamera(Camera).Filt.G = 0 Then
            FCamera(Camera).Filt.G = 1
        End If
    End If
    If KeyCode = 191 Then '/
        If FCamera(Camera).Filt.B = 1 Then
            FCamera(Camera).Filt.B = 0
        ElseIf FCamera(Camera).Filt.B = 0 Then
            FCamera(Camera).Filt.B = 1
        End If
    End If
    
    If KeyCode = 33 Then
        CurMesh = GetNextMesh(CurMesh, -1)
    End If
    If KeyCode = 34 Then
        CurMesh = GetNextMesh(CurMesh, 1)
    End If
    
    If Left(View, 1) = "P" Then
        If KeyCode = 38 Then 'up arrow
            FCamera(Camera).FOV = FCamera(Camera).FOV + 5
            If FCamera(Camera).FOV > 360 Then FCamera(Camera).FOV = 360
        End If
        If KeyCode = 40 Then 'down arrow
            FCamera(Camera).FOV = FCamera(Camera).FOV - 5
            If FCamera(Camera).FOV < 5 Then FCamera(Camera).FOV = 5
        End If
    End If
    
    If Left(View, 1) = "P" Then
        If KeyCode = 107 Then '+
            Zoom = Zoom * 2
        End If
        If KeyCode = 109 Then '-
            Zoom = Zoom / 2
        End If
        If KeyCode = 100 Then 'left pad
            OffsetX = OffsetX + 5
        End If
        If KeyCode = 102 Then 'right pad
            OffsetX = OffsetX - 5
        End If
        If KeyCode = 104 Then 'up pad
            OffsetY = OffsetY - 5
        End If
        If KeyCode = 98 Then 'down pad
            OffsetY = OffsetY + 5
        End If
    End If
    
End Function
Function SetPointPos(Index%, Scr As PictureBox, View$, X!, Y!, Unit!)

    If View = "Top" Then
        FPoint(Index).Pos.X = ResetMDPos("Opp", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
        FPoint(Index).Pos.Y = ResetMDPos("Adj", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
    End If
    If View = "Back" Then
        FPoint(Index).Pos.X = ResetMDPos("Opp", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
        FPoint(Index).Pos.Z = ResetMDPos("Adj", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
    End If
    If View = "Right" Then
        FPoint(Index).Pos.Y = ResetMDPos("Opp", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
        FPoint(Index).Pos.Z = ResetMDPos("Adj", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
    End If
    If View = "Bottom" Then
        FPoint(Index).Pos.X = -ResetMDPos("Opp", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
        FPoint(Index).Pos.Y = ResetMDPos("Adj", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
    End If
    If View = "Front" Then
        FPoint(Index).Pos.X = -ResetMDPos("Opp", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
        FPoint(Index).Pos.Z = ResetMDPos("Adj", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
    End If
    If View = "Left" Then
        FPoint(Index).Pos.Y = -ResetMDPos("Opp", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
        FPoint(Index).Pos.Z = ResetMDPos("Adj", Scr, X, Y, Zoom, OffsetX, OffsetY, Unit)
    End If
    
End Function
Function UnloadHeader()

    Dim A%
    Dim B%
    
    For A = FHeader.ScriptRng.Bgn To FHeader.ScriptRng.Fin
        If FScript(A).Exist = True Then
            For B = FScript(A).KeyRng.Bgn To FScript(A).KeyRng.Fin
                If FKey(B).Exist = True Then
                    FKey(B).Tag = ""
                    FKey(B).Vect.Rot.X = 0
                    FKey(B).Vect.Rot.Y = 0
                    FKey(B).Vect.Rot.Z = 0
                    FKey(B).Vect.Trans.X = 0
                    FKey(B).Vect.Trans.Y = 0
                    FKey(B).Vect.Trans.Z = 0
                End If
            Next B
            FScript(A).Tag = ""
            FScript(A).File = ""
            FScript(A).CurKey = 0
            FScript(A).KeyRng.Bgn = 0
            FScript(A).KeyRng.Fin = 0
            FScript(A).CurStep = 0
            FScript(A).Steps = 0
        End If
    Next A
    FHeader.ScriptRng.Bgn = 0
    FHeader.ScriptRng.Fin = 0
    
End Function

Function ViewInfo()
    
    If Left(View, 1) = "P" Then
        ViewInfo = _
            "View: " + View + _
            "; Long: " + Format$(Longitude) + _
            "; Lat: " + Format$(Latitude) + _
            "; Rad: " + Format$(Radius) + _
            "; FOV: " + Format$(FCamera(CurCamera).FOV)
    Else
        ViewInfo = _
            "View: " + View + _
            "; OffsetX: " + Format$(Int(OffsetX)) + _
            "; OffsetY: " + Format$(Int(OffsetY)) + _
            "; Zoom: " + Format$(Int(Zoom * 100)) + "%"
    End If
    
End Function
