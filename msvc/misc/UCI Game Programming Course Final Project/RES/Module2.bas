Attribute VB_Name = "Module2"
Option Explicit

Public Const mMapWidth As Single = 100
Public Const mMapHeight As Single = 100
Public Const mPI As Single = 3.14159

Type Entity
    mModel As String
    mFlip As Boolean
    mMapDir As Long
    mSkyBox As Long
    mTexture As String
    mSize As Single
    mSprite As String
    mMask As String
    mAngle(2) As Single
    mOrigin(2) As Single
    mBox(2) As Single
    mAlign As Boolean
    mBase As Single
    mName As String
    mTag As String
    mVisible As Boolean
    mSolid As Boolean
End Type

Type ViewPort
    mX As Single
    mY As Single
    mWidth As Single
    mHeight As Single
    mError As Boolean
End Type

Public Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long

Public mEntity() As Entity
Public mViewPort As ViewPort
Public mScale As Single
Public mAspect As Single
Public mSelected As Long
Public mPrevSel As Long
Public mGroundName As String
Public mSkyName As String
Public mSkyMapDir As Long
Function ComboFind(pComboBox As ComboBox, Text As String) As Long

    Dim i As Long
    Dim Result As Long
    
    For i = 0 To pComboBox.ListCount - 1
        If pComboBox.List(i) = Text Then _
            Result = i
    Next i
    ComboFind = Result
    
End Function
Function InitMap(Canvas As PictureBox, Texture As PictureBox, Buffer As Image, MiniMap As PictureBox)

    ReDim mEntity(0)
    Canvas.Parent.ScaleMode = 3
    Canvas.ScaleMode = 3
    Texture.ScaleMode = 3
    MiniMap.ScaleMode = 3
    Canvas.AutoRedraw = True
    Texture.AutoRedraw = True
    MiniMap.AutoRedraw = True
    Texture.BorderStyle = vbBSNone
    Texture.BackColor = vbBlack
    Call Texture.Move(-Texture.Width, -Texture.Height)
    Buffer.Visible = False
    
End Function
Function SaveMapEx(Filename As String, Ground As Boolean, Sky As Boolean)

    Dim IndexA As Long
    Dim IndexB As Long
    
    'add ground
    If Ground Then
        IndexA = AddEntity
        mEntity(IndexA).mModel = "box"
        mEntity(IndexA).mFlip = False
        mEntity(IndexA).mMapDir = 4
        mEntity(IndexA).mSkyBox = True
        If mGroundName <> "" Then
            mEntity(IndexA).mTexture = mGroundName
        Else
            mEntity(IndexA).mTexture = "none"
        End If
        mEntity(IndexA).mSize = 1
        mEntity(IndexA).mSprite = "none"
        mEntity(IndexA).mMask = "none"
        mEntity(IndexA).mBox(0) = mMapWidth
        mEntity(IndexA).mBox(1) = 1
        mEntity(IndexA).mBox(2) = mMapHeight
        mEntity(IndexA).mAlign = True
        mEntity(IndexA).mBase = -1
        mEntity(IndexA).mVisible = True
        mEntity(IndexA).mSolid = False
    End If
    
    'add sky
    If Sky Then
        IndexB = AddEntity
        mEntity(IndexB).mModel = "sphere"
        mEntity(IndexB).mFlip = True
        mEntity(IndexB).mMapDir = mSkyMapDir
        mEntity(IndexB).mSkyBox = True
        If mSkyName <> "" Then
            mEntity(IndexB).mTexture = mSkyName
        Else
            mEntity(IndexB).mTexture = "none"
        End If
        mEntity(IndexB).mSize = 1
        mEntity(IndexB).mSprite = "none"
        mEntity(IndexB).mMask = "none"
        mEntity(IndexB).mBox(0) = mMapWidth
        mEntity(IndexB).mBox(1) = (mMapWidth + mMapHeight) / 2
        mEntity(IndexB).mBox(2) = mMapHeight
        mEntity(IndexB).mAlign = False
        mEntity(IndexB).mBase = -1
        mEntity(IndexB).mVisible = True
        mEntity(IndexA).mSolid = False
    End If
    
    'save
    Call SaveMap(Filename)
    
    'clean-up
    If Ground Then _
        Call RemEntity(IndexA)
    If Sky Then _
        Call RemEntity(IndexB)
        
End Function
Function LoadMapEx(Filename As String)

    Dim i As Long
    
    mGroundName = ""
    mSkyName = ""
    mSkyMapDir = 0
    Call LoadMap(Filename)
    For i = UBound(mEntity) To 1 Step -1
        If _
            mEntity(i).mBox(0) = mMapWidth And _
            mEntity(i).mBox(2) = mMapHeight _
        Then
            If mEntity(i).mBox(1) = 1 Then
                mGroundName = mEntity(i).mTexture
            Else
                mSkyName = mEntity(i).mTexture
                mSkyMapDir = mEntity(i).mMapDir
            End If
            Call RemEntity(i)
        End If
    Next i
    
End Function
Function SaveMap(Filename As String)

    Dim i As Long
    Dim Buffer As String
    
    On Error Resume Next
    For i = 1 To UBound(mEntity)
        'mesh info
        Buffer = Buffer & _
            Chr(34) & mEntity(i).mModel & Chr(34) & vbCrLf & _
            "flip=(" & CStr(mEntity(i).mFlip And 1) & ");" & vbCrLf
            
        'texture info
        Buffer = Buffer & _
            "style=(" & CStr(mEntity(i).mMapDir) & ", " & CStr(mEntity(i).mSkyBox And 1) & ");" & vbCrLf & _
            Chr(34) & mEntity(i).mTexture & Chr(34) & vbCrLf
            
        'sprite info
        Buffer = Buffer & _
            "size=(" & CStr(mEntity(i).mSize) & ");" & vbCrLf & _
            Chr(34) & mEntity(i).mSprite & Chr(34) & vbCrLf & _
            Chr(34) & mEntity(i).mMask & Chr(34) & vbCrLf
            
        'dimension info
        Buffer = Buffer & _
            "angle=(" & _
                CStr(mEntity(i).mAngle(0)) & ", " & _
                CStr(mEntity(i).mAngle(1)) & ", " & _
                CStr(mEntity(i).mAngle(2)) & _
            ");" & vbCrLf & _
            "origin=(" & _
                CStr(mEntity(i).mOrigin(0)) & ", " & _
                CStr(mEntity(i).mOrigin(1)) & ", " & _
                CStr(mEntity(i).mOrigin(2)) & _
            ");" & vbCrLf & _
            "box=(" & _
                CStr(mEntity(i).mBox(0)) & ", " & _
                CStr(mEntity(i).mBox(1)) & ", " & _
                CStr(mEntity(i).mBox(2)) & _
            ");" & vbCrLf
            
        'placement info
        Buffer = Buffer & _
            "base=(" & _
                CStr(mEntity(i).mAlign And 1) & ", " & _
                CStr(mEntity(i).mBase) & _
            ");" & vbCrLf
            
        'misc info
        Buffer = Buffer & _
            Chr(34) & mEntity(i).mName & Chr(34) & vbCrLf & _
            Chr(34) & mEntity(i).mTag & Chr(34) & vbCrLf & _
            "visible=(" & CStr(mEntity(i).mVisible And 1) & ");" & vbCrLf & _
            "solid=(" & CStr(mEntity(i).mSolid And 1) & ");" & vbCrLf
            
        Buffer = Buffer & vbCrLf
    Next i
    If Buffer <> "" Then _
        Buffer = Left(Buffer, Len(Buffer) - Len(vbCrLf) * 2)
    Call SaveText(Filename, Buffer)
    
End Function
Function LoadMap(Filename As String) As Long

    Dim i As Long
    Dim j As Long
    Dim Result As Long
    Dim TempA() As Single
    Dim TempB As String
    Dim Text As String
    Dim pLenA As Long
    Dim pLenB As Long
    Dim TokenA As String
    Dim TokenB As String
    Dim TokenC As String
    Dim IndexA As Long
    Dim IndexB As Long
    
    ReDim TempA(2)
    Text = LoadText(Filename)
    pLenA = Len(Text)
    i = 1
    Do While i <= pLenA
        TokenA = ScanText(Text, i, vbCrLf)
        If TokenA <> "" Then
            If Left(TokenA, 1) = Chr(34) Then
                TokenA = Mid(TokenA, 2, Len(TokenA) - 2)
                Select Case IndexA
                    Case 0
                        Result = AddEntity
                        mEntity(Result).mModel = TokenA
                    Case 1
                        mEntity(Result).mTexture = TokenA
                    Case 2
                        mEntity(Result).mSprite = TokenA
                    Case 3
                        mEntity(Result).mMask = TokenA
                    Case 4
                        mEntity(Result).mName = TokenA
                    Case 5
                        mEntity(Result).mTag = TokenA
                End Select
                IndexA = IndexA + 1
            Else
                j = 1
                TempB = ScanText(TokenA, j, "=(")
                TokenB = ScanText(TokenA, j, ");")
                IndexB = 0
                pLenB = Len(TokenB)
                j = 1
                Do While j <= pLenB
                    TokenC = ScanText(TokenB, j, ",")
                    TokenC = Trim(TokenC)
                    TempA(IndexB) = CSng(TokenC)
                    IndexB = IndexB + 1
                Loop
                Select Case TempB
                    Case "flip"
                        mEntity(Result).mFlip = CBool(TempA(0))
                    Case "style"
                        mEntity(Result).mMapDir = TempA(0)
                        mEntity(Result).mSkyBox = CBool(TempA(1))
                    Case "size"
                        mEntity(Result).mSize = TempA(0)
                    Case "angle"
                        For j = 0 To 2
                            mEntity(Result).mAngle(j) = TempA(j)
                        Next j
                    Case "origin"
                        For j = 0 To 2
                            mEntity(Result).mOrigin(j) = TempA(j)
                        Next j
                    Case "box"
                        For j = 0 To 2
                            mEntity(Result).mBox(j) = TempA(j)
                        Next j
                    Case "base"
                        mEntity(Result).mAlign = CBool(TempA(0))
                        mEntity(Result).mBase = TempA(1)
                    Case "visible"
                        mEntity(Result).mVisible = CBool(TempA(0))
                    Case "solid"
                        mEntity(Result).mSolid = CBool(TempA(0))
                End Select
            End If
        Else
            IndexA = 0
        End If
    Loop
    
End Function
Function AddEntity() As Long

    Dim Result As Long
    
    ReDim Preserve mEntity(UBound(mEntity) + 1)
    Result = UBound(mEntity)
    AddEntity = Result
    
End Function
Function RemEntity(Index As Long)

    Dim i As Long
    
    For i = Index To UBound(mEntity) - 1
        mEntity(i) = mEntity(i + 1)
    Next i
    ReDim Preserve mEntity(UBound(mEntity) - 1)
    
End Function
Function SetViewPort(X As Single, Y As Single, Width As Single, Aspect As Single)

    mViewPort.mX = X
    mViewPort.mY = Y
    mViewPort.mWidth = Width
    mViewPort.mHeight = Width * Aspect
    If mViewPort.mX < 0 Then mViewPort.mX = 0
    If mViewPort.mY < 0 Then mViewPort.mY = 0
    If mViewPort.mX + mViewPort.mWidth > 1 Then mViewPort.mX = 1 - mViewPort.mWidth
    If mViewPort.mY + mViewPort.mHeight > 1 Then mViewPort.mY = 1 - mViewPort.mHeight
    If mViewPort.mY < 0 Then
        mViewPort.mY = 0
        mViewPort.mHeight = 1
        mViewPort.mWidth = mViewPort.mHeight / Aspect
        mViewPort.mError = True
    Else
        mViewPort.mError = False
    End If
    
End Function
Function FindEntity(X As Single, Y As Single) As Long

    Dim i As Long
    Dim Result As Long
    
    For i = 1 To UBound(mEntity)
        If _
            X > mEntity(i).mOrigin(0) - mEntity(i).mBox(0) / 2 And _
            X < mEntity(i).mOrigin(0) + mEntity(i).mBox(0) / 2 And _
            Y > mEntity(i).mOrigin(2) - mEntity(i).mBox(2) / 2 And _
            Y < mEntity(i).mOrigin(2) + mEntity(i).mBox(2) / 2 _
        Then _
            Result = i
    Next i
    FindEntity = Result
    
End Function
Function MapCoords(Canvas As PictureBox, X As Single, Y As Single, NewX As Single, NewY As Single)

    NewX = -1 * mMapWidth * ((mViewPort.mX + X / Canvas.ScaleWidth * mViewPort.mWidth) - 0.5)
    NewY = -1 * mMapHeight * ((mViewPort.mY + Y / Canvas.ScaleHeight * mViewPort.mHeight) - 0.5)
    
End Function
Function DrawMap(Canvas As PictureBox, Texture As PictureBox, Buffer As Image, MiniMap As PictureBox)

    Dim i As Long
    Dim TempA As Long
    
    'setup back-buffer
    Texture.Picture = Buffer.Picture
    Call Texture.Move(-Buffer.Width, -Buffer.Height, Buffer.Width, Buffer.Height)
    
    'paint canvas background
    Canvas.Cls
    Call StretchBlt( _
        Canvas.hdc, _
        0, 0, Canvas.ScaleWidth, Canvas.ScaleHeight, _
        Texture.hdc, _
        Texture.ScaleWidth * mViewPort.mX, _
        Texture.ScaleHeight * mViewPort.mY, _
        Texture.ScaleWidth * mViewPort.mWidth, _
        Texture.ScaleHeight * mViewPort.mHeight, _
        vbSrcCopy _
    )
    
    'paint mini-map background
    MiniMap.Cls
    Call StretchBlt( _
        MiniMap.hdc, _
        0, 0, MiniMap.ScaleWidth, MiniMap.ScaleHeight, _
        Texture.hdc, _
        0, 0, Texture.ScaleWidth, Texture.ScaleHeight, _
        vbSrcCopy _
    )
    
    'draw entity (canvas & mini-map)
    For i = 1 To UBound(mEntity)
    
        'fill canvas block
        Canvas.DrawWidth = 1
        MiniMap.DrawWidth = 1
        If i = mSelected Then
            Canvas.ForeColor = vbYellow
            MiniMap.ForeColor = vbYellow
        Else
            If _
                mEntity(i).mName <> "" Or _
                mEntity(i).mTag <> "" Or _
                Not mEntity(i).mVisible Or _
                Not mEntity(i).mSolid _
            Then
                Canvas.ForeColor = vbWhite
                MiniMap.ForeColor = vbWhite
            Else
                Canvas.ForeColor = vbMagenta
                MiniMap.ForeColor = vbMagenta
            End If
            If mEntity(i).mName = "npc" Then
                Canvas.ForeColor = vbRed
                MiniMap.ForeColor = vbRed
            End If
            If mEntity(i).mTag <> "" Then
                Canvas.ForeColor = RGB(255, 192, 0)
                MiniMap.ForeColor = RGB(255, 192, 0)
            End If
        End If
        Canvas.Line _
            ( _
                -1 * Canvas.ScaleWidth * _
                    ((mEntity(i).mOrigin(0) + mEntity(i).mBox(0) / 2) / mMapWidth - 0.5 + mViewPort.mX) / _
                    mViewPort.mWidth, _
                -1 * Canvas.ScaleHeight * _
                    ((mEntity(i).mOrigin(2) + mEntity(i).mBox(2) / 2) / mMapHeight - 0.5 + mViewPort.mY) / _
                    mViewPort.mHeight _
            )- _
            ( _
                -1 * Canvas.ScaleWidth * _
                    ((mEntity(i).mOrigin(0) - mEntity(i).mBox(0) / 2) / mMapWidth - 0.5 + mViewPort.mX) / _
                    mViewPort.mWidth, _
                -1 * Canvas.ScaleHeight * _
                    ((mEntity(i).mOrigin(2) - mEntity(i).mBox(2) / 2) / mMapHeight - 0.5 + mViewPort.mY) / _
                    mViewPort.mHeight _
            ), , BF
            
        'label canvas orientation
        Canvas.DrawWidth = 1
        Canvas.ForeColor = vbBlack
        Canvas.Circle _
            ( _
                -1 * Canvas.ScaleWidth * _
                    (mEntity(i).mOrigin(0) / mMapWidth - 0.5 + mViewPort.mX) / _
                    mViewPort.mWidth, _
                -1 * Canvas.ScaleHeight * _
                    (mEntity(i).mOrigin(2) / mMapHeight - 0.5 + mViewPort.mY) / _
                    mViewPort.mHeight _
            ), Canvas.ScaleWidth * 0.5 / mMapHeight / mViewPort.mWidth
        Canvas.Line _
            ( _
                -1 * Canvas.ScaleWidth * _
                    (mEntity(i).mOrigin(0) / mMapWidth - 0.5 + mViewPort.mX) / _
                    mViewPort.mWidth, _
                -1 * Canvas.ScaleHeight * _
                    (mEntity(i).mOrigin(2) / mMapHeight - 0.5 + mViewPort.mY) / _
                    mViewPort.mHeight _
            )- _
            ( _
                -1 * Canvas.ScaleWidth * _
                    ( _
                        (mEntity(i).mOrigin(0) + Cos((mEntity(i).mAngle(2) - 90) * mPI / 180)) / mMapWidth - _
                        0.5 + mViewPort.mX _
                    ) / _
                    mViewPort.mWidth, _
                -1 * Canvas.ScaleHeight * _
                    ( _
                        (mEntity(i).mOrigin(2) - Sin((mEntity(i).mAngle(2) - 90) * mPI / 180)) / mMapHeight - _
                        0.5 + mViewPort.mY _
                    ) / _
                    mViewPort.mHeight _
            )
            
        'fill mini-map block
        MiniMap.Line _
            ( _
                -1 * MiniMap.ScaleWidth * ((mEntity(i).mOrigin(0) + mEntity(i).mBox(0) / 2) / mMapWidth - 0.5), _
                -1 * MiniMap.ScaleHeight * ((mEntity(i).mOrigin(2) + mEntity(i).mBox(2) / 2) / mMapHeight - 0.5) _
            )- _
            ( _
                -1 * MiniMap.ScaleWidth * ((mEntity(i).mOrigin(0) - mEntity(i).mBox(0) / 2) / mMapWidth - 0.5), _
                -1 * MiniMap.ScaleHeight * ((mEntity(i).mOrigin(2) - mEntity(i).mBox(2) / 2) / mMapHeight - 0.5) _
            ), , BF
    Next i
    
    'draw canvas outline
    For i = 1 To UBound(mEntity)
        If i = mPrevSel Then
            Canvas.DrawWidth = 2
            Canvas.ForeColor = vbGreen
        Else
            Canvas.DrawWidth = 1
            Canvas.ForeColor = vbBlack
        End If
        Canvas.Line _
            ( _
                -1 * Canvas.ScaleWidth * _
                    ((mEntity(i).mOrigin(0) + mEntity(i).mBox(0) / 2) / mMapWidth - 0.5 + mViewPort.mX) / _
                    mViewPort.mWidth, _
                -1 * Canvas.ScaleHeight * _
                    ((mEntity(i).mOrigin(2) + mEntity(i).mBox(2) / 2) / mMapHeight - 0.5 + mViewPort.mY) / _
                    mViewPort.mHeight _
            )- _
            ( _
                -1 * Canvas.ScaleWidth * _
                    ((mEntity(i).mOrigin(0) - mEntity(i).mBox(0) / 2) / mMapWidth - 0.5 + mViewPort.mX) / _
                    mViewPort.mWidth, _
                -1 * Canvas.ScaleHeight * _
                    ((mEntity(i).mOrigin(2) - mEntity(i).mBox(2) / 2) / mMapHeight - 0.5 + mViewPort.mY) / _
                    mViewPort.mHeight _
            ), , B
        If i = mPrevSel Then
            Canvas.CurrentX = Canvas.CurrentX + 60 / Screen.TwipsPerPixelX
            Canvas.CurrentY = Canvas.CurrentY + 60 / Screen.TwipsPerPixelY
            TempA = Canvas.CurrentX
            Canvas.Print CStr(mEntity(i).mBox(0)) & " x " & CStr(mEntity(i).mBox(2))
            Canvas.CurrentX = TempA
            Canvas.Print mEntity(i).mModel
        End If
    Next i
    
    'label canvas foreground
    Canvas.DrawWidth = 1
    Canvas.ForeColor = vbRed
    Canvas.CurrentX = 0
    Canvas.CurrentY = 0
    Canvas.Print _
        "(" & _
            Format(-1 * mMapWidth * (mViewPort.mX - 0.5), "0.00") & ", " & _
            Format(-1 * mMapHeight * (mViewPort.mY - 0.5), "0.00") & _
        ")"
        
    'label mini-map foreground
    MiniMap.DrawWidth = 2
    If Not mViewPort.mError Then
        MiniMap.ForeColor = vbRed
    Else
        MiniMap.ForeColor = vbYellow
    End If
    MiniMap.Line _
        ( _
            MiniMap.ScaleWidth * mViewPort.mX, _
            MiniMap.ScaleHeight * mViewPort.mY _
        )- _
        ( _
            MiniMap.ScaleWidth * (mViewPort.mX + mViewPort.mWidth), _
            MiniMap.ScaleHeight * (mViewPort.mY + mViewPort.mHeight) _
        ), , B
        
End Function
