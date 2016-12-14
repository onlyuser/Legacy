Attribute VB_Name = "Module4"
Option Explicit
Public Const BIG_NUMBER As Double = 65536
Function calcDeviation(theta As Double, i As Integer) As Double

    If theta = 0 Then
        calcDeviation = 0
        Exit Function
    End If
    Dim angle As Double
    angle = theta / (2 ^ i)
    calcDeviation = (1 - Cos(angle)) / (2 * Sin(angle))
    
End Function
Function sumDeviation(theta As Double, n As Integer) As Double

    Dim sum As Double
    Dim i As Integer
    For i = 1 To n
        sum = sum + calcDeviation(theta, i) * 2 ^ (i - 1)
    Next i
    sumDeviation = sum
    
End Function
Function avgDeviation(theta As Double, n As Integer) As Double

    avgDeviation = CSng(1) / (2 ^ n - 1) * sumDeviation(theta, n)
    
End Function
Function testRange( _
    minTheta As Double, maxTheta As Double, stepTheta As Double, _
    minCut As Integer, maxCut As Integer, stepCut As Integer _
    ) As String

    Debug.Print "Test 1"
    Dim i As Integer
    For i = minCut To maxCut Step stepCut 'to the limit!
        Dim s As String
        s = ""
        Dim j As Double
        For j = minTheta To maxTheta Step stepTheta 'try a range
            s = s & vbTab & CStr(avgDeviation(j, i)) 'value
        Next j
        Debug.Print s
    Next i
    Debug.Print "Test 2"
    For i = minCut To maxCut - 1 Step stepCut 'to the limit!
        s = ""
        For j = minTheta To maxTheta Step stepTheta 'try a range
            s = s & vbTab & CStr(avgDeviation(j, i + 1) / avgDeviation(j, i)) 'converge ratio
        Next j
        Debug.Print s
    Next i
    
End Function
