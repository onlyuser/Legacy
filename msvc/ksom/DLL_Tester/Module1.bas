Attribute VB_Name = "Module1"
Option Explicit

Declare Sub regUserFunc Lib "ksom" (ByVal pEventFunc As Long, ByVal pMessageFunc As Long)
Declare Function ksom_sum Lib "ksom" (ByVal A As Long, ByVal B As Long) As Long
Declare Function ksom_echo Lib "ksom" (ByVal Text As String) As String
Declare Sub ksom_test Lib "ksom" (ByVal Script As String)
Declare Sub ksom_load Lib "ksom" (ByVal groupCnt As Long, ByRef data As Single, ByVal Length As Long, ByVal windowSize As Long, ByVal stepSize As Long, ByVal min As Single, ByVal max As Single, ByVal kernel As Boolean)
Declare Sub ksom_loadMatrix Lib "ksom" (ByVal groupCnt As Long, ByRef data As Single, ByVal rowSize As Long, ByVal colSize As Long, ByVal windowSize As Long)
Declare Sub ksom_tallyMatrix Lib "ksom" (ByVal tallySize As Long)
Declare Function ksom_verify Lib "ksom" (ByVal windowSize As Long, ByVal tallySize As Long) As Single
Declare Sub ksom_unload Lib "ksom" ()
Declare Sub ksom_clear Lib "ksom" ()
Declare Sub ksom_reset Lib "ksom" ()
Declare Function ksom_getGroupCnt Lib "ksom" () As Long
Declare Function ksom_getGroupSize Lib "ksom" (ByVal index As Long) As Long
Declare Function ksom_getGroupMember Lib "ksom" (ByVal groupIndex As Long, ByVal index As Long) As Long
Declare Sub ksom_getGroupKernel Lib "ksom" (ByVal groupIndex As Long, ByRef data As Single)
Declare Sub ksom_getGroupInfo Lib "ksom" (ByVal groupIndex As Long)
Declare Function ksom_getGroupError Lib "ksom" (ByVal groupIndex As Long) As Single
Declare Function ksom_getGroupMemberError Lib "ksom" (ByVal groupIndex As Long, ByVal index As Long) As Single
Declare Function ksom_exec Lib "ksom" (ByVal init As Boolean, ByVal train As Boolean, ByVal eval As Boolean) As Single
Declare Sub ksom_execBatch Lib "ksom" (ByVal Iters As Long, ByVal MaxEpochs As Long, ByVal maxEntropy As Single)
Declare Sub ksom_simplify Lib "ksom" (ByVal nearThresh As Single)
Declare Sub ksom_print Lib "ksom" ()

Public mResult As String
Sub Main()

    Call regUserFunc(AddressOf EventFunc, AddressOf MessageFunc)
    Call Form1.Show
    
End Sub
Sub EventFunc()

    DoEvents
    
End Sub
Sub MessageFunc(ByVal Message As String)

    Select Case Left(Message, 5)
        Case "error"
            Call Err.Raise(vbObjectError, , Message)
        Case "state"
            Form2.Caption = Message
        Case Else
            Call MsgBox(Message, vbInformation + vbOKOnly, "Info")
            mResult = Message
    End Select
    
End Sub
