Attribute VB_Name = "ModuleG"
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

Public Const ChunkMain = &H4D4D
Public Const ChunkEditor = &H3D3D
Public Const ChunkObject = &H4000
Public Const ChunkMesh = &H4100
Public Const ChunkVertex = &H4110
Public Const ChunkAxis = &H4160
Public Const ChunkFace = &H4120
Public Const ChunkKeyFramer = &HB000
Public Const ChunkObjectDescription = &HB002
Public Const ChunkObjectHierarchy = &HB010
Public Const ChunkLight = &H4600
Public Const ChunkColor = &H10
Public Const ChunkLightSpotLight = &H4610
Public Const ChunkLightOn = &H4620
Public Const ChunkCamera = &H4700
Function CheckChunk(FileNumber As Integer) As Integer

    CheckChunk = ReadInteger(FileNumber)
    Seek #FileNumber, Seek(FileNumber) - Len(CheckChunk)
    
End Function
Function ReadChunkAxis(FileNumber As Integer, SeekStop As Integer, MeshIndex As Integer)

    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkAxis, SeekStop)
    
    If NewSeekStop <> 0 Then
        Call Read3dsVector(FileNumber) 'ignore transformation matrix
        Call Read3dsVector(FileNumber)
        Call Read3dsVector(FileNumber)
        Call _
            SetMeshOrigin( _
                MeshIndex, _
                Read3dsVector(FileNumber) _
            )
    End If
    
End Function
Function Read3dsColor(FileNumber As Integer) As ColorRGB

    Read3dsColor.R = ReadSingle(FileNumber) * 255
    Read3dsColor.G = ReadSingle(FileNumber) * 255
    Read3dsColor.B = ReadSingle(FileNumber) * 255
    
End Function
Function ReadChunkColor(FileNumber As Integer, SeekStop As Integer, Color As ColorRGB)

    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkColor, SeekStop)
    
    If NewSeekStop <> 0 Then Color = Read3dsColor(FileNumber)
    
End Function
Function ReadChunkEditor(FileNumber As Integer, SeekStop As Integer)

    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkEditor, SeekStop)
    
    If NewSeekStop <> 0 Then
        Do While Seek(FileNumber) < NewSeekStop
            Select Case CheckChunk(FileNumber)
                Case ChunkObject
                    Call ReadChunkObject(FileNumber, NewSeekStop)
                Case Else
                    Call SkipChunk(FileNumber)
            End Select
        Loop
    End If
    
End Function
Function ReadChunkFaces(FileNumber As Integer, SeekStop As Integer, MeshIndex As Integer, VertexOffset As Integer)

    Dim A As Integer
    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkFace, SeekStop)
    
    If NewSeekStop <> 0 Then
        VMesh(MeshIndex).Faces.Length = ReadInteger(FileNumber)
        If GetAddressLast(VMesh(MeshIndex).Faces) > UBound(VFace) Then
            Call ShowError(1)
            Call RemoveMesh(MeshIndex)
            Exit Function
        End If
        For A = VMesh(MeshIndex).Faces.Start To GetAddressLast(VMesh(MeshIndex).Faces)
            If EOF(FileNumber) = True Then Exit For
            VFace(A) = Read3dsFace(FileNumber, VertexOffset)
        Next A
    End If
    
End Function
'begins recursion with NewSeekStop
Function ReadChunkKeyFramer(FileNumber As Integer, SeekStop As Integer)

    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkKeyFramer, SeekStop)
    
    If NewSeekStop <> 0 Then _
        Call ReadChunkObjectDescription(FileNumber, NewSeekStop, 0, 0)
        
End Function
Function ReadChunkLight(FileNumber As Integer, SeekStop As Integer, LightName As String)

    Dim NewSeekStop As Integer
    Dim LightIndex As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkLight, SeekStop)
    
    If SeekStop <> 0 Then
        LightIndex = AddLight
        VLight(LightIndex).Tag = LightName
        VLight(LightIndex).Origin = Read3dsVector(FileNumber)
        Call ReadChunkColor(FileNumber, NewSeekStop, VLight(LightIndex).Color)
        Do While Seek(FileNumber) < NewSeekStop
            Select Case CheckChunk(FileNumber)
                Case ChunkLightOn
                    Call _
                        ReadChunkLightOn( _
                            FileNumber, _
                            NewSeekStop, _
                            VLight(LightIndex).Enabled _
                        )
                    If VLight(LightIndex).Enabled = False Then _
                        Call RemoveLight(LightIndex)
                Case ChunkLightSpotLight
                    Call ReadChunkLightSpotLight(FileNumber, NewSeekStop, LightIndex)
                Case Else
                    Call SkipChunk(FileNumber)
            End Select
        Loop
    End If
    
End Function
Function ReadChunkCamera(FileNumber As Integer, SeekStop As Integer, CameraName As String)

    Dim NewSeekStop As Integer
    Dim CameraIndex As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkCamera, SeekStop)
    
    If SeekStop <> 0 Then
        CameraIndex = AddCamera
        VCamera(CameraIndex).Tag = CameraName
        Call SetCameraFOV(CameraIndex, DegreeToRadian(60))
        VCamera(CameraIndex).Origin = Read3dsVector(FileNumber)
        VCamera(CameraIndex).Angles = _
            VectorToOrientation( _
                VectorSubtract( _
                    Read3dsVector(FileNumber), _
                    VCamera(CameraIndex).Origin _
                ) _
            )
        Call ReadSingle(FileNumber) 'bank
        Call ReadSingle(FileNumber) 'lens
    End If
    
End Function
Function ReadChunkLightOn(FileNumber As Integer, SeekStop As Integer, LightOn As Boolean)

    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkLightOn, SeekStop)
    
    If NewSeekStop <> 0 Then LightOn = False 'true by default
    
End Function
Function ReadChunkLightSpotLight(FileNumber As Integer, SeekStop As Integer, LightIndex As Integer)

    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkLightSpotLight, SeekStop)
    
    If NewSeekStop <> 0 Then
        VLight(LightIndex).Angles = _
            VectorToOrientation( _
                VectorSubtract( _
                    Read3dsVector(FileNumber), _
                    VLight(LightIndex).Origin _
                ) _
            )
        VLight(LightIndex).Hotspot = Cos(DegreeToRadian(ReadSingle(FileNumber)))
        VLight(LightIndex).Falloff = Cos(DegreeToRadian(ReadSingle(FileNumber)))
    End If
    
End Function
Function ReadChunkMain(FileNumber As Integer, SeekStop As Integer)

    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkMain, SeekStop)
    
    If NewSeekStop <> 0 Then
        Do While Seek(FileNumber) < NewSeekStop
            Select Case CheckChunk(FileNumber)
                Case ChunkEditor
                    Call ReadChunkEditor(FileNumber, NewSeekStop)
                Case ChunkKeyFramer
                    Call ReadChunkKeyFramer(FileNumber, NewSeekStop)
                Case Else
                    Call SkipChunk(FileNumber)
            End Select
        Loop
    End If
    
End Function
Function ReadChunkMesh(FileNumber As Integer, SeekStop As Integer, MeshName As String)

    Dim NewSeekStop As Integer
    Dim MeshIndex As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkMesh, SeekStop)
    
    If NewSeekStop <> 0 Then
    
        MeshIndex = AddMesh(0, 0)
        If MeshIndex = 0 Then Exit Function
        
        VMesh(MeshIndex).Tag = MeshName
        
        Do While Seek(FileNumber) < NewSeekStop
            Select Case CheckChunk(FileNumber)
                Case ChunkVertex
                    Call ReadChunkVertices(FileNumber, NewSeekStop, MeshIndex)
                Case ChunkFace
                    Call ReadChunkFaces(FileNumber, NewSeekStop, MeshIndex, VMesh(MeshIndex).Vertices.Start)
                Case ChunkAxis
                    Call ReadChunkAxis(FileNumber, NewSeekStop, MeshIndex)
                Case Else
                    Call SkipChunk(FileNumber)
            End Select
        Loop
        
        Call TrimMesh(MeshIndex)
        Call FitMesh(MeshIndex)
        
    End If
    
End Function
Function ReadChunkObject(FileNumber As Integer, SeekStop As Integer)

    Dim NewSeekStop As Integer
    Dim ObjectName As String
    
    NewSeekStop = SeekChunk(FileNumber, ChunkObject, SeekStop)
    
    If NewSeekStop <> 0 Then
        ObjectName = ReadString(FileNumber)
        Do While Seek(FileNumber) < NewSeekStop
            Select Case CheckChunk(FileNumber)
                Case ChunkMesh
                    Call ReadChunkMesh(FileNumber, NewSeekStop, ObjectName)
                Case ChunkCamera
                    Call ReadChunkCamera(FileNumber, NewSeekStop, ObjectName)
                Case ChunkLight
                    Call ReadChunkLight(FileNumber, NewSeekStop, ObjectName)
                Case Else
                    Call SkipChunk(FileNumber)
            End Select
        Loop
    End If
    
End Function
'continues recursion with SeekStop
Function ReadChunkObjectDescription(FileNumber As Integer, SeekStop As Integer, LastIndex As Integer, LastHierarchy As Integer) As Boolean

    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkObjectDescription, SeekStop)
    
    If NewSeekStop <> 0 Then
        ReadChunkObjectDescription = True
        Call ReadChunkObjectHierarchy(FileNumber, SeekStop, LastIndex, LastHierarchy)
    End If
        
End Function
'continues recursion with SeekStop
Function ReadChunkObjectHierarchy(FileNumber As Integer, SeekStop As Integer, LastIndex As Integer, LastHierarchy As Integer)

    Dim NewSeekStop As Integer
    Dim ObjectIndex As Integer
    Dim ObjectHierarchy As Integer
    Dim NewBranch As Boolean
    
    NewSeekStop = SeekChunk(FileNumber, ChunkObjectHierarchy, SeekStop)
    
    If NewSeekStop <> 0 Then
    
        ObjectIndex = MeshByTag(ReadString(FileNumber))
        Call ReadInteger(FileNumber) 'ignore unknown chunks
        Call ReadInteger(FileNumber)
        ObjectHierarchy = ReadInteger(FileNumber)
        
        If ObjectHierarchy = -1 Then
            LastIndex = 0
            LastHierarchy = 0
        End If
        
        If ObjectHierarchy = -1 Or ObjectHierarchy > LastHierarchy Then
        
            If LastIndex <> 0 Then
                VMesh(ObjectIndex).Parent = LastIndex
                VMesh(ObjectIndex).Origin = _
                    VectorSubtract( _
                        VMesh(ObjectIndex).Origin, _
                        AbsoluteOrigin(VMesh(ObjectIndex).Parent) _
                    )
                'Debug.Print ObjectIndex & " linked to " & LastIndex
            End If
            
            Do
            
                If NewBranch = True Then
                    NewBranch = False
                    VMesh(LastIndex).Parent = ObjectIndex
                    VMesh(LastIndex).Origin = _
                        VectorSubtract( _
                            VMesh(LastIndex).Origin, _
                            AbsoluteOrigin(VMesh(LastIndex).Parent) _
                        )
                    'Debug.Print LastIndex & " linked to " & ObjectIndex
                Else
                    LastIndex = ObjectIndex
                    LastHierarchy = ObjectHierarchy
                End If
                
                If _
                    ReadChunkObjectDescription(FileNumber, SeekStop, LastIndex, LastHierarchy) = _
                    False _
                        Then
                            If LastHierarchy - 1 = ObjectHierarchy Then _
                                NewBranch = True
                Else
                    Exit Function
                End If
                
            Loop While NewBranch = True
            
        Else
        
            LastIndex = ObjectIndex
            LastHierarchy = ObjectHierarchy
            
        End If
        
    End If
    
End Function
Function ReadChunkVertices(FileNumber As Integer, SeekStop As Integer, MeshIndex As Integer)

    Dim A As Integer
    Dim NewSeekStop As Integer
    
    NewSeekStop = SeekChunk(FileNumber, ChunkVertex, SeekStop)
    
    If NewSeekStop <> 0 Then
        VMesh(MeshIndex).Vertices.Length = ReadInteger(FileNumber)
        If GetAddressLast(VMesh(MeshIndex).Vertices) > UBound(VVertex) Then
            Call ShowError(1)
            Call RemoveMesh(MeshIndex)
            Exit Function
        End If
        For A = VMesh(MeshIndex).Vertices.Start To GetAddressLast(VMesh(MeshIndex).Vertices)
            If EOF(FileNumber) = True Then Exit For
            VVertex(A) = Read3dsVector(FileNumber)
        Next A
    End If
    
End Function
Function Read3dsVector(FileNumber As Integer) As Vector

    Read3dsVector.X = ReadSingle(FileNumber)
    Read3dsVector.Z = ReadSingle(FileNumber)
    Read3dsVector.Y = ReadSingle(FileNumber)
    
End Function
Function Read3dsFace(FileNumber As Integer, VertexOffset As Integer) As TFace

    Read3dsFace.A = ReadInteger(FileNumber) + VertexOffset
    Read3dsFace.C = ReadInteger(FileNumber) + VertexOffset
    Read3dsFace.B = ReadInteger(FileNumber) + VertexOffset
    Call ReadInteger(FileNumber) 'ignore face attributes
    
End Function
'seeks ChunkID between the current read position and SeekStop
'returns location of next ChunkID if found
'returns nothing otherwise
Function SeekChunk(FileNumber As Integer, ChunkID As Integer, SeekStop As Integer) As Integer

    Dim CurrentChunkID As Integer
    Dim CurrentChunkLength As Long
    Dim NextChunkStart As Integer
    
    Do While _
        EOF(FileNumber) = False And _
        Seek(FileNumber) < SeekStop
            CurrentChunkID = ReadInteger(FileNumber) 'read 2 bytes
            CurrentChunkLength = ReadLong(FileNumber) 'read 4 bytes
            NextChunkStart = _
                Seek(FileNumber) - _
                ( _
                    Len(CurrentChunkID) + _
                    Len(CurrentChunkLength) _
                ) + _
                CurrentChunkLength
            If CurrentChunkID = ChunkID Then
                SeekChunk = NextChunkStart 'return location of next chunk
                Exit Function
            Else
                Seek #FileNumber, NextChunkStart 'skip to next chunk
                'Debug.Print _
                    NextChunkStart - CurrentChunkLength & ": " & _
                    "Looking for " & Hex(ChunkID) & " -> " & _
                    "Found " & Hex(CurrentChunkID) & " of LEN: " & CurrentChunkLength
            End If
    Loop
    
End Function
Function SkipChunk(FileNumber As Integer) As Integer

    Dim CurrentChunkLength As Long
    Dim NextChunkStart As Integer
    
    SkipChunk = ReadInteger(FileNumber) 'read 2 bytes
    CurrentChunkLength = ReadLong(FileNumber) 'read 4 bytes
    NextChunkStart = _
        Seek(FileNumber) - _
        ( _
            Len(SkipChunk) + _
            Len(CurrentChunkLength) _
        ) + _
        CurrentChunkLength
    Seek #FileNumber, NextChunkStart 'skip to next chunk
    
End Function
Function Load3dsFile(Filename As String)

    Dim FileNumber As Integer
    Dim NewSeekStop As Integer
    
    FileNumber = FreeFile
    Open Filename For Binary As #FileNumber
    
        NewSeekStop = LOF(FileNumber)
        
        If NewSeekStop <> 0 Then
            Do While Seek(FileNumber) < NewSeekStop
                Select Case CheckChunk(FileNumber)
                    Case ChunkMain
                        Call ReadChunkMain(FileNumber, NewSeekStop)
                    Case Else
                        Call SkipChunk(FileNumber)
                End Select
            Loop
        End If
        
    Close #FileNumber
    
End Function
