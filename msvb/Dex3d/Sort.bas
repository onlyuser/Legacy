Attribute VB_Name = "ModuleD"
'The GNU General Public License does not apply to this module

'sorts an array from smallest to largest
Function SingleSort(ArrayKey() As Single, ArrayPointer() As Integer, First As Integer, Last As Integer)

    Dim A As Integer
    Dim B As Integer
    Dim C As Integer
    Dim Split As Single
    
    If First < Last Then
        If Last - First = 1 Then
            If ArrayKey(First) > ArrayKey(Last) Then
                Call SingleSwap(ArrayKey(First), ArrayKey(Last))
                Call IntegerSwap(ArrayPointer(First), ArrayPointer(Last))
            End If
        Else
            C = IntegerRandom(First, Last)
            Call SingleSwap(ArrayKey(Last), ArrayKey(C))
            Call IntegerSwap(ArrayPointer(Last), ArrayPointer(C))
            Split = ArrayKey(Last)
            Do
                A = First
                B = Last
                Do While (A < B) And ArrayKey(A) <= Split
                    A = A + 1
                Loop
                Do While (B > A) And ArrayKey(B) >= Split
                    B = B - 1
                Loop
                If A < B Then
                    Call SingleSwap(ArrayKey(A), ArrayKey(B))
                    Call IntegerSwap(ArrayPointer(A), ArrayPointer(B))
                End If
            Loop While A < B
            Call SingleSwap(ArrayKey(A), ArrayKey(Last))
            Call IntegerSwap(ArrayPointer(A), ArrayPointer(Last))
            If (A - First) < (Last - A) Then
                Call SingleSort(ArrayKey(), ArrayPointer(), First, A - 1)
                Call SingleSort(ArrayKey(), ArrayPointer(), A + 1, Last)
            Else
                Call SingleSort(ArrayKey(), ArrayPointer(), A + 1, Last)
                Call SingleSort(ArrayKey(), ArrayPointer(), First, A - 1)
            End If
        End If
    End If
    
End Function
Function IntegerSwap(A As Integer, B As Integer)

    Dim C As Integer
    
    C = A
    A = B
    B = C
    
End Function
Function SingleSwap(A As Single, B As Single)

    Dim C As Single
    
    C = A
    A = B
    B = C
    
End Function
Function IntegerRandom(Lower As Integer, Upper As Integer) As Integer

    Randomize
    
    IntegerRandom = Int(Rnd * (Upper - Lower + 1)) + Lower
    
End Function
