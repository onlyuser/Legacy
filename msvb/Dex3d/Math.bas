Attribute VB_Name = "ModuleB"
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

Public Const Pi = 3.14159265358979

Type POINTAPI
    X As Long
    Y As Long
End Type

Type Vector
    X As Single
    Y As Single
    Z As Single
End Type

Type Vectrix
    X As Single
    Y As Single
    Z As Single
    S As Single
End Type

Type Matrix
    A As Vectrix
    B As Vectrix
    C As Vectrix
    D As Vectrix
End Type

Type Orientation
    Roll As Single
    Pitch As Single
    Yaw As Single
End Type
Function OrientationReverse(A As Orientation) As Orientation

    OrientationReverse = _
        VectorToOrientation( _
            VectorScale( _
                OrientationToVector(A), _
                -1 _
            ) _
        )
        
End Function
Function VectorToVectrix(A As Vector) As Vectrix

    VectorToVectrix.X = A.X
    VectorToVectrix.Y = A.Y
    VectorToVectrix.Z = A.Z
    VectorToVectrix.S = 1
    
End Function
Function VectorToPOINTAPI(A As Vector) As POINTAPI

    VectorToPOINTAPI.X = A.X
    VectorToPOINTAPI.Y = A.Y
    
End Function
Function POINTAPIToVector(A As POINTAPI) As Vector

    POINTAPIToVector.X = A.X
    POINTAPIToVector.Y = A.Y
    
End Function
Function POINTAPIToVectrix(A As POINTAPI) As Vectrix

    POINTAPIToVectrix.X = A.X
    POINTAPIToVectrix.Y = A.Y
    POINTAPIToVectrix.S = 1
    
End Function
Function VectrixToVector(A As Vectrix) As Vector

    VectrixToVector.X = A.X
    VectrixToVector.Y = A.Y
    VectrixToVector.Z = A.Z
    
End Function
Function VectrixToPOINTAPI(A As Vectrix) As POINTAPI

    VectrixToPOINTAPI.X = A.X
    VectrixToPOINTAPI.Y = A.Y
    
End Function
Function OrientationAngle(A As Orientation, B As Orientation) As Single

    OrientationAngle = _
        VectorAngle( _
            OrientationToVector(A), _
            OrientationToVector(B) _
        )
        
End Function
Function OrientationModulus(A As Orientation) As Single

    OrientationModulus = _
        VectorAngle( _
            OrientationToVector(OrientationNull), _
            OrientationToVector(A) _
        )
        
End Function
Function OrientationToVector(A As Orientation) As Vector

    Dim Transformation As Matrix
    
    Transformation = MatrixIdentity
    
    Transformation = _
        MatrixDotProduct( _
            Transformation, _
            TransformationRotate(1, A.Pitch) _
        )
        
    Transformation = _
        MatrixDotProduct( _
            Transformation, _
            TransformationRotate(2, A.Yaw) _
        )
        
    OrientationToVector = _
        VectorMatrixDotProductToVector( _
            VectorInput( _
                0, _
                0, _
                1 _
            ), _
            Transformation _
        )
        
End Function
Function TransformationRotate(Axis As Integer, Angle As Single) As Matrix

    Select Case Axis
        Case 1 'x axis
            TransformationRotate = _
                MatrixInput( _
                    VectrixInput(1, 0, 0, 0), _
                    VectrixInput(0, Cos(Angle), Sin(Angle), 0), _
                    VectrixInput(0, -Sin(Angle), Cos(Angle), 0), _
                    VectrixInput(0, 0, 0, 1) _
                )
        Case 2 'y axis
            TransformationRotate = _
                MatrixInput( _
                    VectrixInput(Cos(Angle), 0, -Sin(Angle), 0), _
                    VectrixInput(0, 1, 0, 0), _
                    VectrixInput(Sin(Angle), 0, Cos(Angle), 0), _
                    VectrixInput(0, 0, 0, 1) _
                )
        Case 3 'z axis
            TransformationRotate = _
                MatrixInput( _
                    VectrixInput(Cos(Angle), Sin(Angle), 0, 0), _
                    VectrixInput(-Sin(Angle), Cos(Angle), 0, 0), _
                    VectrixInput(0, 0, 1, 0), _
                    VectrixInput(0, 0, 0, 1) _
                )
    End Select
    
End Function
Function TransformationScale(Factor As Vector) As Matrix

    TransformationScale = _
        MatrixInput( _
            VectrixInput(Factor.X, 0, 0, 0), _
            VectrixInput(0, Factor.Y, 0, 0), _
            VectrixInput(0, 0, Factor.Z, 0), _
            VectrixInput(0, 0, 0, 1) _
        )
        
End Function
Function TransformationTranslate(Distance As Vector) As Matrix

    TransformationTranslate = _
        MatrixInput( _
            VectrixInput(1, 0, 0, 0), _
            VectrixInput(0, 1, 0, 0), _
            VectrixInput(0, 0, 1, 0), _
            VectrixInput(Distance.X, Distance.Y, Distance.Z, 1) _
        )
        
End Function
Function VectorToOrientation(A As Vector) As Orientation

    VectorToOrientation.Yaw = _
        ArcCos( _
            VectorAngle( _
                VectorInput(A.X, 0, A.Z), _
                VectorInput(0, 0, 1) _
            ) _
        )
        
    VectorToOrientation.Pitch = _
        ArcCos( _
            VectorAngle( _
                VectorInput(A.X, A.Y, A.Z), _
                VectorInput(A.X, 0, A.Z) _
            ) _
        )
        
    If A.X < 0 Then VectorToOrientation.Yaw = -VectorToOrientation.Yaw
    If A.Y > 0 Then VectorToOrientation.Pitch = -VectorToOrientation.Pitch
    
End Function
Function OrientationInput(Roll As Single, Pitch As Single, Yaw As Single) As Orientation

    OrientationInput.Roll = Roll
    OrientationInput.Pitch = Pitch
    OrientationInput.Yaw = Yaw
    
End Function
Function OrientationNull() As Orientation

    OrientationNull = OrientationInput(0, 0, 0)
    
End Function
Function OrientationRandom() As Orientation

    Randomize
    
    OrientationRandom.Roll = (2 * Rnd - 1) * Pi
    OrientationRandom.Pitch = (2 * Rnd - 1) * Pi
    OrientationRandom.Yaw = (2 * Rnd - 1) * Pi
    
End Function
Function OrientationScale(A As Orientation, B As Single) As Orientation

    OrientationScale.Roll = A.Roll * B
    OrientationScale.Pitch = A.Pitch * B
    OrientationScale.Yaw = A.Yaw * B
    
End Function
Function OrientationAdd(A As Orientation, B As Orientation) As Orientation

    OrientationAdd.Roll = A.Roll + B.Roll
    OrientationAdd.Pitch = A.Pitch + B.Pitch
    OrientationAdd.Yaw = A.Yaw + B.Yaw
    
End Function
Function OrientationInvert(A As Orientation) As Orientation

    OrientationInvert.Roll = 1 / A.Roll
    OrientationInvert.Pitch = 1 / A.Pitch
    OrientationInvert.Yaw = 1 / A.Yaw
    
End Function
Function OrientationSubtract(A As Orientation, B As Orientation) As Orientation

    OrientationSubtract.Roll = A.Roll - B.Roll
    OrientationSubtract.Pitch = A.Pitch - B.Pitch
    OrientationSubtract.Yaw = A.Yaw - B.Yaw
    
End Function
Function OrientationPrint(A As Orientation) As String

    OrientationPrint = A.Roll & vbTab & A.Pitch & vbTab & A.Yaw

End Function
Function OrientationCompare(A As Orientation, B As Orientation) As Boolean

    If _
        A.Roll = B.Roll And _
        A.Pitch = B.Pitch And _
        A.Yaw = B.Yaw _
            Then _
                OrientationCompare = True
                
End Function
Function _
    Matrix2By2Determinant( _
        A As Single, B As Single, _
        C As Single, D As Single _
    ) As _
        Single

        Matrix2By2Determinant = _
            A * D - _
            B * C
            
End Function
Function _
    Matrix3By3Determinant( _
        A As Single, B As Single, C As Single, _
        D As Single, E As Single, F As Single, _
        G As Single, H As Single, I As Single _
    ) As _
        Single

        Matrix3By3Determinant = _
            A * Matrix2By2Determinant(E, F, H, I) - _
            B * Matrix2By2Determinant(D, F, G, I) + _
            C * Matrix2By2Determinant(D, E, G, H)
            
End Function
Function _
    Matrix4By4Determinant( _
        A As Single, B As Single, C As Single, D As Single, _
        E As Single, F As Single, G As Single, H As Single, _
        I As Single, J As Single, K As Single, L As Single, _
        M As Single, N As Single, O As Single, P As Single _
    ) As _
        Single

        Matrix4By4Determinant = _
            A * Matrix3By3Determinant(F, G, H, J, K, L, N, O, P) - _
            B * Matrix3By3Determinant(E, G, H, I, K, L, M, O, P) + _
            C * Matrix3By3Determinant(E, F, H, I, J, L, M, N, P) - _
            D * Matrix3By3Determinant(E, F, G, I, J, K, M, N, O)
            
End Function
Function MatrixCompare(A As Matrix, B As Matrix) As Boolean

    If _
        VectrixCompare(A.A, B.A) = True And _
        VectrixCompare(A.B, B.B) = True And _
        VectrixCompare(A.C, B.C) = True And _
        VectrixCompare(A.D, B.D) = True _
            Then _
                MatrixCompare = True
                
End Function
Function MatrixDeterminant(A As Matrix) As Single

    MatrixDeterminant = _
        Matrix4By4Determinant( _
            A.A.X, A.A.Y, A.A.Z, A.A.S, _
            A.B.X, A.B.Y, A.B.Z, A.B.S, _
            A.C.X, A.C.Y, A.C.Z, A.C.S, _
            A.D.X, A.D.Y, A.D.Z, A.D.S _
        )
        
End Function
Function MatrixDivide(A As Matrix, B As Matrix) As Matrix

    MatrixDivide = MatrixDotProduct(A, MatrixInvert(B))
    
End Function
Function MatrixTranspose(A As Matrix) As Matrix

    MatrixTranspose.A.X = A.A.X
    MatrixTranspose.A.Y = A.B.X
    MatrixTranspose.A.Z = A.C.X
    MatrixTranspose.A.S = A.D.X
    
    MatrixTranspose.B.X = A.A.Y
    MatrixTranspose.B.Y = A.B.Y
    MatrixTranspose.B.Z = A.C.Y
    MatrixTranspose.B.S = A.D.Y
    
    MatrixTranspose.C.X = A.A.Z
    MatrixTranspose.C.Y = A.B.Z
    MatrixTranspose.C.Z = A.C.Z
    MatrixTranspose.C.S = A.D.Z
    
    MatrixTranspose.D.X = A.A.S
    MatrixTranspose.D.Y = A.B.S
    MatrixTranspose.D.Z = A.C.S
    MatrixTranspose.D.S = A.D.S
    
End Function
Function MatrixIdentity() As Matrix

    MatrixIdentity = _
        MatrixInput( _
            VectrixInput(1, 0, 0, 0), _
            VectrixInput(0, 1, 0, 0), _
            VectrixInput(0, 0, 1, 0), _
            VectrixInput(0, 0, 0, 1) _
        )
        
End Function
Function MatrixInvert(A As Matrix) As Matrix

    Dim B As Matrix
    
    B.A.X = _
        Matrix3By3Determinant( _
            A.B.Y, A.B.Z, A.B.S, _
            A.C.Y, A.C.Z, A.C.S, _
            A.D.Y, A.D.Z, A.D.S _
        )
    
    B.A.Y = - _
        Matrix3By3Determinant( _
            A.B.X, A.B.Z, A.B.S, _
            A.C.X, A.C.Z, A.C.S, _
            A.D.X, A.D.Z, A.D.S _
        )
    
    B.A.Z = _
        Matrix3By3Determinant( _
            A.B.X, A.B.Y, A.B.S, _
            A.C.X, A.C.Y, A.C.S, _
            A.D.X, A.D.Y, A.D.S _
        )
    
    B.A.S = - _
        Matrix3By3Determinant( _
            A.B.X, A.B.Y, A.B.Z, _
            A.C.X, A.C.Y, A.C.Z, _
            A.D.X, A.D.Y, A.D.Z _
        )
    
    B.B.X = - _
        Matrix3By3Determinant( _
            A.A.Y, A.A.Z, A.A.S, _
            A.C.Y, A.C.Z, A.C.S, _
            A.D.Y, A.D.Z, A.D.S _
        )
    
    B.B.Y = _
        Matrix3By3Determinant( _
            A.A.X, A.A.Z, A.A.S, _
            A.C.X, A.C.Z, A.C.S, _
            A.D.X, A.D.Z, A.D.S _
        )
    
    B.B.Z = - _
        Matrix3By3Determinant( _
            A.A.X, A.A.Y, A.A.S, _
            A.C.X, A.C.Y, A.C.S, _
            A.D.X, A.D.Y, A.D.S _
        )
    
    B.B.S = _
        Matrix3By3Determinant( _
            A.A.X, A.A.Y, A.A.Z, _
            A.C.X, A.C.Y, A.C.Z, _
            A.D.X, A.D.Y, A.D.Z _
        )
    
    B.C.X = _
        Matrix3By3Determinant( _
            A.A.Y, A.A.Z, A.A.S, _
            A.B.Y, A.B.Z, A.B.S, _
            A.D.Y, A.D.Z, A.D.S _
        )
    
    B.C.Y = - _
        Matrix3By3Determinant( _
            A.A.X, A.A.Z, A.A.S, _
            A.B.X, A.B.Z, A.B.S, _
            A.D.X, A.D.Z, A.D.S _
        )
    
    B.C.Z = _
        Matrix3By3Determinant( _
            A.A.X, A.A.Y, A.A.S, _
            A.B.X, A.B.Y, A.B.S, _
            A.D.X, A.D.Y, A.D.S _
        )
    B.C.S = - _
        Matrix3By3Determinant( _
            A.A.X, A.A.Y, A.A.Z, _
            A.B.X, A.B.Y, A.B.Z, _
            A.D.X, A.D.Y, A.D.Z _
        )
    
    B.D.X = - _
        Matrix3By3Determinant( _
            A.A.Y, A.A.Z, A.A.S, _
            A.B.Y, A.B.Z, A.B.S, _
            A.C.Y, A.C.Z, A.C.S _
        )
    
    B.D.Y = _
        Matrix3By3Determinant( _
            A.A.X, A.A.Z, A.A.S, _
            A.B.X, A.B.Z, A.B.S, _
            A.C.X, A.C.Z, A.C.S _
        )
    
    B.D.Z = - _
        Matrix3By3Determinant( _
            A.A.X, A.A.Y, A.A.S, _
            A.B.X, A.B.Y, A.B.S, _
            A.C.X, A.C.Y, A.C.S _
        )
    
    B.D.S = _
        Matrix3By3Determinant( _
            A.A.X, A.A.Y, A.A.Z, _
            A.B.X, A.B.Y, A.B.Z, _
            A.C.X, A.C.Y, A.C.Z _
        )
    
    MatrixInvert = MatrixTranspose(MatrixScale(B, 1 / MatrixDeterminant(A)))
    
End Function
Function MatrixPrint(A As Matrix) As String

    MatrixPrint = _
        A.A.X & vbTab & A.A.Y & vbTab & A.A.Z & vbTab & A.A.S & vbCrLf & _
        A.B.X & vbTab & A.B.Y & vbTab & A.B.Z & vbTab & A.B.S & vbCrLf & _
        A.C.X & vbTab & A.C.Y & vbTab & A.C.Z & vbTab & A.C.S & vbCrLf & _
        A.D.X & vbTab & A.D.Y & vbTab & A.D.Z & vbTab & A.D.S
        
End Function
Function MatrixRandom() As Matrix

    MatrixRandom.A = VectrixRandom
    MatrixRandom.B = VectrixRandom
    MatrixRandom.C = VectrixRandom
    MatrixRandom.D = VectrixRandom
    
End Function
Function MatrixNull() As Matrix

    MatrixNull = _
        MatrixInput( _
            VectrixInput(0, 0, 0, 0), _
            VectrixInput(0, 0, 0, 0), _
            VectrixInput(0, 0, 0, 0), _
            VectrixInput(0, 0, 0, 0) _
        )
        
End Function
Function MatrixUnit() As Matrix

    MatrixUnit.A = VectrixUnit
    MatrixUnit.B = VectrixUnit
    MatrixUnit.C = VectrixUnit
    MatrixUnit.D = VectrixUnit
    
End Function
Function RadianToDegree(AngleRadian As Single) As Single

    RadianToDegree = AngleRadian * 180 / Pi
    
End Function
Function DegreeToRadian(AngleDegree As Single) As Single

    DegreeToRadian = AngleDegree * Pi / 180
    
End Function
'returns the cosine of an angle
Function VectorAngle(A As Vector, B As Vector) As Single

    If _
        VectorCompare(A, VectorNull) = False And _
        VectorCompare(B, VectorNull) = False _
            Then
                VectorAngle = _
                    VectorDotProduct( _
                        VectorNormalize(A), _
                        VectorNormalize(B) _
                    )
    End If
    
End Function
Function VectorCompare(A As Vector, B As Vector) As Boolean

    If _
        A.X = B.X And _
        A.Y = B.Y And _
        A.Z = B.Z _
            Then _
                VectorCompare = True
                
End Function
Function VectrixCompare(A As Vectrix, B As Vectrix) As Boolean

    If _
        A.X = B.X And _
        A.Y = B.Y And _
        A.Z = B.Z And _
        A.S = B.S _
            Then _
                VectrixCompare = True
                
End Function
Function POINTAPICompare(A As POINTAPI, B As POINTAPI) As Boolean

    If _
        A.X = B.X And _
        A.Y = B.Y _
            Then _
                POINTAPICompare = True
                
End Function
'returns vector component of A orthogonal to B
Function VectorComponentOrthogonal(A As Vector, B As Vector) As Vector

    VectorComponentOrthogonal = _
        VectorSubtract( _
            A, _
            VectorComponentAlong(A, B) _
        )
        
End Function
Function VectorCrossProduct(A As Vector, B As Vector) As Vector
    
    VectorCrossProduct.X = Matrix2By2Determinant(A.Y, A.Z, B.Y, B.Z)
    VectorCrossProduct.Y = -Matrix2By2Determinant(A.X, A.Z, B.X, B.Z)
    VectorCrossProduct.Z = Matrix2By2Determinant(A.X, A.Y, B.X, B.Y)
    
End Function
Function VectorDistance(A As Vector, B As Vector) As Single

    VectorDistance = VectorModulus(VectorSubtract(A, B))
    
End Function
Function VectorInvert(A As Vector) As Vector

    VectorInvert.X = 1 / A.X
    VectorInvert.Y = 1 / A.Y
    VectorInvert.Z = 1 / A.Z
    
End Function
Function VectrixInvert(A As Vectrix) As Vectrix

    VectrixInvert.X = 1 / A.X
    VectrixInvert.Y = 1 / A.Y
    VectrixInvert.Z = 1 / A.Z
    VectrixInvert.S = 1 / A.S
    
End Function
Function POINTAPIInvert(A As POINTAPI) As POINTAPI

    POINTAPIInvert.X = 1 / A.X
    POINTAPIInvert.Y = 1 / A.Y
    
End Function
Function VectorMatrixDivide(A As Vector, B As Matrix) As Vector

    VectorMatrixDivide = VectorMatrixDotProductToVector(A, MatrixInvert(B))
    
End Function
Function VectorDotProduct(A As Vector, B As Vector) As Single

    VectorDotProduct = A.X * B.X + A.Y * B.Y + A.Z * B.Z
    
End Function
Function VectorDivide(A As Vector, B As Vector) As Single

    VectorDivide = VectorDotProduct(A, VectorInvert(B))
    
End Function
Function VectrixDivide(A As Vectrix, B As Vectrix) As Single

    VectrixDivide = VectrixDotProduct(A, VectrixInvert(B))
    
End Function
Function POINTAPIDivide(A As POINTAPI, B As POINTAPI) As Single

    POINTAPIDivide = POINTAPIDotProduct(A, POINTAPIInvert(B))
    
End Function
Function VectorMultiply(A As Vector, B As Vector) As Vector

    VectorMultiply.X = A.X * B.X
    VectorMultiply.Y = A.Y * B.Y
    VectorMultiply.Z = A.Z * B.Z
    
End Function
Function VectrixMultiply(A As Vectrix, B As Vectrix) As Vectrix

    VectrixMultiply.X = A.X * B.X
    VectrixMultiply.Y = A.Y * B.Y
    VectrixMultiply.Z = A.Z * B.Z
    VectrixMultiply.S = A.S * B.S
    
End Function
Function POINTAPIMultiply(A As POINTAPI, B As POINTAPI) As POINTAPI

    POINTAPIMultiply.X = A.X * B.X
    POINTAPIMultiply.Y = A.Y * B.Y
    
End Function
Function VectorPrint(A As Vector) As String

    VectorPrint = A.X & vbTab & A.Y & vbTab & A.Z
    
End Function
'returns vector component of A along B
Function VectorComponentAlong(A As Vector, B As Vector) As Vector

    VectorComponentAlong = _
        VectorScale( _
            VectorNormalize(B), _
            VectorDotProduct( _
                A, _
                VectorNormalize(B) _
            ) _
        )
        
End Function
Function VectrixDotProduct(A As Vectrix, B As Vectrix) As Single

    VectrixDotProduct = A.X * B.X + A.Y * B.Y + A.Z * B.Z + A.S * B.S
    
End Function
Function POINTAPIDotProduct(A As POINTAPI, B As POINTAPI) As Single

    POINTAPIDotProduct = A.X * B.X + A.Y * B.Y
    
End Function
'returns reflection of A off of B
Function VectorReflect(A As Vector, B As Vector) As Vector

    If VectorAngle(A, B) < 0 Then _
        VectorReflect = _
            VectorAdd( _
                A, _
                VectorScale(VectorComponentAlong(A, B), -2) _
            )
            
End Function
Function VectorScale(A As Vector, B As Single) As Vector

    VectorScale.X = A.X * B
    VectorScale.Y = A.Y * B
    VectorScale.Z = A.Z * B
    
End Function
Function VectrixScale(A As Vectrix, B As Single) As Vectrix

    VectrixScale.X = A.X * B
    VectrixScale.Y = A.Y * B
    VectrixScale.Z = A.Z * B
    VectrixScale.S = A.S * B
    
End Function
Function POINTAPIScale(A As POINTAPI, B As Single) As POINTAPI

    POINTAPIScale.X = A.X * B
    POINTAPIScale.Y = A.Y * B
    
End Function
Function MatrixScale(A As Matrix, B As Single) As Matrix

    MatrixScale.A = VectrixScale(A.A, B)
    MatrixScale.B = VectrixScale(A.B, B)
    MatrixScale.C = VectrixScale(A.C, B)
    MatrixScale.D = VectrixScale(A.D, B)
    
End Function
Function VectorModulus(A As Vector) As Single

    VectorModulus = (A.X ^ 2 + A.Y ^ 2 + A.Z ^ 2) ^ (1 / 2)
    
End Function
Function VectrixMatrixDotProduct(A As Vectrix, B As Matrix) As Vectrix

    Dim C As Matrix
    
    C = MatrixTranspose(B)
    
    VectrixMatrixDotProduct.X = VectrixDotProduct(A, C.A)
    VectrixMatrixDotProduct.Y = VectrixDotProduct(A, C.B)
    VectrixMatrixDotProduct.Z = VectrixDotProduct(A, C.C)
    VectrixMatrixDotProduct.S = VectrixDotProduct(A, C.D)
    
End Function
Function VectorMatrixDotProductToVector(A As Vector, B As Matrix) As Vector

    Dim C As Vectrix
    Dim D As Matrix
    
    C = VectorToVectrix(A)
    D = MatrixTranspose(B)
    
    VectorMatrixDotProductToVector.X = VectrixDotProduct(C, D.A)
    VectorMatrixDotProductToVector.Y = VectrixDotProduct(C, D.B)
    VectorMatrixDotProductToVector.Z = VectrixDotProduct(C, D.C)
    
End Function
Function VectorMatrixDotProductToVectrix(A As Vector, B As Matrix) As Vectrix

    Dim C As Vectrix
    Dim D As Matrix
    
    C = VectorToVectrix(A)
    D = MatrixTranspose(B)
    
    VectorMatrixDotProductToVectrix.X = VectrixDotProduct(C, D.A)
    VectorMatrixDotProductToVectrix.Y = VectrixDotProduct(C, D.B)
    VectorMatrixDotProductToVectrix.Z = VectrixDotProduct(C, D.C)
    VectorMatrixDotProductToVectrix.S = VectrixDotProduct(C, D.D)
    
End Function
Function MatrixDotProduct(A As Matrix, B As Matrix) As Matrix

    Dim C As Matrix
    
    C = MatrixTranspose(B)
    
    MatrixDotProduct.A.X = VectrixDotProduct(A.A, C.A)
    MatrixDotProduct.A.Y = VectrixDotProduct(A.A, C.B)
    MatrixDotProduct.A.Z = VectrixDotProduct(A.A, C.C)
    MatrixDotProduct.A.S = VectrixDotProduct(A.A, C.D)
    
    MatrixDotProduct.B.X = VectrixDotProduct(A.B, C.A)
    MatrixDotProduct.B.Y = VectrixDotProduct(A.B, C.B)
    MatrixDotProduct.B.Z = VectrixDotProduct(A.B, C.C)
    MatrixDotProduct.B.S = VectrixDotProduct(A.B, C.D)
    
    MatrixDotProduct.C.X = VectrixDotProduct(A.C, C.A)
    MatrixDotProduct.C.Y = VectrixDotProduct(A.C, C.B)
    MatrixDotProduct.C.Z = VectrixDotProduct(A.C, C.C)
    MatrixDotProduct.C.S = VectrixDotProduct(A.C, C.D)
    
    MatrixDotProduct.D.X = VectrixDotProduct(A.D, C.A)
    MatrixDotProduct.D.Y = VectrixDotProduct(A.D, C.B)
    MatrixDotProduct.D.Z = VectrixDotProduct(A.D, C.C)
    MatrixDotProduct.D.S = VectrixDotProduct(A.D, C.D)
    
End Function
Function MatrixMultiply(A As Matrix, B As Matrix) As Matrix

    MatrixMultiply.A = VectrixMultiply(A.A, B.A)
    MatrixMultiply.B = VectrixMultiply(A.B, B.B)
    MatrixMultiply.C = VectrixMultiply(A.C, B.C)
    MatrixMultiply.D = VectrixMultiply(A.D, B.D)
    
End Function
Function MatrixAdd(A As Matrix, B As Matrix) As Matrix

    MatrixAdd.A = VectrixAdd(A.A, B.A)
    MatrixAdd.B = VectrixAdd(A.B, B.B)
    MatrixAdd.C = VectrixAdd(A.C, B.C)
    MatrixAdd.D = VectrixAdd(A.D, B.D)
    
End Function
Function MatrixSubtract(A As Matrix, B As Matrix) As Matrix

    MatrixSubtract.A = VectrixSubtract(A.A, B.A)
    MatrixSubtract.B = VectrixSubtract(A.B, B.B)
    MatrixSubtract.C = VectrixSubtract(A.C, B.C)
    MatrixSubtract.D = VectrixSubtract(A.D, B.D)
    
End Function
Function VectorNormalize(A As Vector) As Vector

    Dim Length As Single
    
    Length = VectorModulus(A)
    If Length <> 0 Then VectorNormalize = VectorScale(A, 1 / Length)
    
End Function
Function VectorInterpolate(A As Vector, B As Vector, Alpha As Single) As Vector

    VectorInterpolate.X = A.X + Alpha * (B.X - A.X)
    VectorInterpolate.Y = A.Y + Alpha * (B.Y - A.Y)
    VectorInterpolate.Z = A.Z + Alpha * (B.Z - A.Z)
    
End Function
Function VectrixInterpolate(A As Vectrix, B As Vectrix, Alpha As Single) As Vectrix

    VectrixInterpolate.X = A.X + Alpha * (B.X - A.X)
    VectrixInterpolate.Y = A.Y + Alpha * (B.Y - A.Y)
    VectrixInterpolate.Z = A.Z + Alpha * (B.Z - A.Z)
    VectrixInterpolate.S = A.S + Alpha * (B.S - A.S)
    
End Function
Function POINTAPIInterpolate(A As POINTAPI, B As POINTAPI, Alpha As Single) As POINTAPI

    POINTAPIInterpolate.X = A.X + Alpha * (B.X - A.X)
    POINTAPIInterpolate.Y = A.Y + Alpha * (B.Y - A.Y)
    
End Function
Function MatrixInterpolate(A As Matrix, B As Matrix, Alpha As Single) As Matrix

    MatrixInterpolate.A = VectrixInterpolate(A.A, B.A, Alpha)
    MatrixInterpolate.B = VectrixInterpolate(A.B, B.B, Alpha)
    MatrixInterpolate.C = VectrixInterpolate(A.C, B.C, Alpha)
    MatrixInterpolate.D = VectrixInterpolate(A.D, B.D, Alpha)
    
End Function
Function VectorAdd(A As Vector, B As Vector) As Vector

    VectorAdd.X = A.X + B.X
    VectorAdd.Y = A.Y + B.Y
    VectorAdd.Z = A.Z + B.Z
    
End Function
Function VectrixAdd(A As Vectrix, B As Vectrix) As Vectrix

    VectrixAdd.X = A.X + B.X
    VectrixAdd.Y = A.Y + B.Y
    VectrixAdd.Z = A.Z + B.Z
    VectrixAdd.S = A.Z + B.S
    
End Function
Function POINTAPIAdd(A As POINTAPI, B As POINTAPI) As POINTAPI

    POINTAPIAdd.X = A.X + B.X
    POINTAPIAdd.Y = A.Y + B.Y
    
End Function
Function VectorSubtract(A As Vector, B As Vector) As Vector

    VectorSubtract.X = A.X - B.X
    VectorSubtract.Y = A.Y - B.Y
    VectorSubtract.Z = A.Z - B.Z
    
End Function
Function VectrixSubtract(A As Vectrix, B As Vectrix) As Vectrix

    VectrixSubtract.X = A.X - B.X
    VectrixSubtract.Y = A.Y - B.Y
    VectrixSubtract.Z = A.Z - B.Z
    VectrixSubtract.S = A.S - B.S
    
End Function
Function POINTAPISubtract(A As POINTAPI, B As POINTAPI) As POINTAPI

    POINTAPISubtract.X = A.X - B.X
    POINTAPISubtract.Y = A.Y - B.Y
    
End Function
Function VectorInput(X As Single, Y As Single, Z As Single) As Vector

    VectorInput.X = X
    VectorInput.Y = Y
    VectorInput.Z = Z
    
End Function
Function VectorRandom() As Vector

    Randomize
    
    VectorRandom.X = 2 * Rnd - 1
    VectorRandom.Y = 2 * Rnd - 1
    VectorRandom.Z = 2 * Rnd - 1
    
End Function
Function VectrixRandom() As Vectrix

    Randomize
    
    VectrixRandom.X = 2 * Rnd - 1
    VectrixRandom.Y = 2 * Rnd - 1
    VectrixRandom.Z = 2 * Rnd - 1
    VectrixRandom.S = 2 * Rnd - 1
    
End Function
Function POINTAPIRandom() As POINTAPI

    Randomize
    
    POINTAPIRandom.X = 2 * Rnd - 1
    POINTAPIRandom.Y = 2 * Rnd - 1
    
End Function
Function MatrixInput(A As Vectrix, B As Vectrix, C As Vectrix, D As Vectrix) As Matrix

    MatrixInput.A = A
    MatrixInput.B = B
    MatrixInput.C = C
    MatrixInput.D = D
    
End Function
Function VectorUnit() As Vector

    VectorUnit = VectorInput(1, 1, 1)
    
End Function
Function VectrixUnit() As Vectrix

    VectrixUnit = VectrixInput(1, 1, 1, 1)
    
End Function
Function VectrixPrint(A As Vectrix) As String

    VectrixPrint = A.X & vbTab & A.Y & vbTab & A.Z & vbTab & A.S
    
End Function
Function POINTAPIUnit() As POINTAPI

    POINTAPIUnit = POINTAPIInput(1, 1)
    
End Function
Function POINTAPIPrint(A As POINTAPI) As String

    POINTAPIPrint = A.X & vbTab & A.Y
    
End Function
Function POINTAPINull() As POINTAPI

    POINTAPINull = POINTAPIInput(0, 0)
    
End Function
Function VectrixNull() As Vectrix

    VectrixNull = VectrixInput(0, 0, 0, 0)
    
End Function
Function VectorNull() As Vector

    VectorNull = VectorInput(0, 0, 0)
    
End Function
Function VectrixInput(X As Single, Y As Single, Z As Single, S As Single) As Vectrix

    VectrixInput.X = X
    VectrixInput.Y = Y
    VectrixInput.Z = Z
    VectrixInput.S = S
    
End Function
Function POINTAPIInput(X As Long, Y As Long) As POINTAPI

    POINTAPIInput.X = X
    POINTAPIInput.Y = Y
    
End Function
