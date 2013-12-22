Attribute VB_Name = "Module0"
Public PeerRef As Boolean

Public URL$
Public RemPath$

Public Const CryptKey$ = "VB RULEZ!"
Public Const LocPath$ = "c:\VBO\"
Public Const CfgFile$ = "VBO.cfg"

Public Const ColumnMarks$ = "ABCDEFGH"
Public Const RowMarks$ = "12345678"

Public RemoteHost$
Public RemotePort&
Public UserName$
Public Password$

Declare Function rmove Lib "e:\endgame.dll" (board As Byte, ByVal color As Byte) As Byte
Function FTP(Message$)

    Const TimeOutTime% = 3 'seconds
    
    Dim Begin!
    Dim Finish!
    
    On Error Resume Next

    Form1.Inet1.Tag = 0
    Form1.Inet1.URL = RemoteHost
    Form1.Inet1.RemotePort = RemotePort
    Form1.Inet1.UserName = UserName
    Form1.Inet1.Password = Password
    Form1.Inet1.Execute , Message
    If Err <> 0 Then
        Call MsgBox(Error(Err), 16, "Error")
        Exit Function
    End If
    Begin = Timer
    Do Until Form1.Inet1.Tag = icResponseCompleted
        Finish = Timer
        If Finish - Begin >= TimeOutTime Then
            Call MsgBox("Connection timed out! Aborting operation!", 64, "FTP")
            Exit Do
        Else
            DoEvents
        End If
    Loop

End Function
Sub Main()

    If LCase(Command) <> "fast" Then
        Form0.Visible = True
        Call Wait(1)
        Call Unload(Form0)
    End If
    
    Depth = 1
    Mode = 2

    URL = "http://members.xoom.com/onlyuser/"
    RemPath = "PROGRAMS/VBO/"
    
    RemoteHost = CryptText("bVPJTKk5CTzo^&Jh` ", CryptKey, -1)
    RemotePort = Val(CryptText(".3", CryptKey, -1))
    UserName = CryptText(")pl21$j3", CryptKey, -1)
    Password = CryptText("*qn^)~q0", CryptKey, -1)

    Form1.Visible = True

End Sub
Function Wait(Seconds!)

    Dim Begin!
    Dim Finish!
    
    Begin = Timer
    Do
        Finish = Timer
        DoEvents
    Loop Until Finish - Begin >= Seconds
    
End Function
