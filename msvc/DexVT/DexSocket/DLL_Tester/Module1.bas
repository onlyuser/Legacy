Attribute VB_Name = "Module1"
Option Explicit

Declare Sub DexSocket_regUserFunc Lib "DexSocket" (ByVal pEventFunc As Long, ByVal pMessageFunc As Long)
Declare Function DexSocket_sum Lib "DexSocket" (ByVal a As Long, ByVal b As Long) As Long
Declare Function DexSocket_echo Lib "DexSocket" (ByVal Text As String) As String
Declare Sub DexSocket_setModeVB Lib "DexSocket" (ByVal Value As Long)
Declare Function DexSocket_open Lib "DexSocket" (ByVal IP As String, ByVal Port As Long) As Long
Declare Sub DexSocket_close Lib "DexSocket" (ByVal pSocket As Long)
Declare Sub DexSocket_send Lib "DexSocket" (ByVal pSocket As Long, ByVal Data As String)
Declare Sub DexSocket_recv Lib "DexSocket" (ByVal pSocket As Long, ByVal Data As String)
Declare Function DexSocket_host Lib "DexSocket" (ByVal Port As Long) As Long
Sub Main()

    Dim hSocket As Long
    Dim Buffer As String
    
    Call DexSocket_regUserFunc(AddressOf EventFunc, AddressOf MessageFunc)
    Call DexSocket_setModeVB(1)
    
    hSocket = DexSocket_open("192.168.0.1", 669)
    'hSocket = DexSocket_open("140.112.20.224", 1024)
    Call DexSocket_send(hSocket, "LOOK")
    Call DexSocket_close(hSocket)
    
    'hSocket = DexSocket_host(666)
    'Buffer = Space(256)
    'Call DexSocket_recv(hSocket, Buffer)
    'Call MsgBox(Buffer)
    'Call DexSocket_send(hSocket, "hello world!")
    'Call DexSocket_close(hSocket)
    
End Sub
Sub EventFunc()

    DoEvents
    
End Sub
Sub MessageFunc(ByVal Message As String)

    Call Err.Raise(vbObjectError, , Message)
    
End Sub
