Attribute VB_Name = "Module3"
Public Type Contact
    Name As String
    Host As String
    Port As Long
End Type

Public Player(1 To 16) As Contact
Public InMark As Single
Function AddContact(Text$)

    Dim A%
    Dim BufferA$
    Dim BufferB$
    Dim BufferC$
    
    BufferA = GetSeg(Text, ":", 1)
    BufferB = GetSeg(Text, ":", 2)
    BufferC = GetSeg(Text, ":", 3)
    For A = LBound(Player) To UBound(Player)
        If Player(A).Name = "" Then
            If GetContact(BufferA) = 0 Then
                Player(A).Name = BufferA
                Player(A).Host = BufferB
                Player(A).Port = Val(BufferC)
                Exit Function
            End If
        End If
    Next A
    
End Function
Function ClearContact()

    Dim A%
    
    For A = LBound(Player) To UBound(Player)
        If Player(A).Name <> "" Then
            Player(A).Name = ""
            Player(A).Host = ""
            Player(A).Port = 0
        End If
    Next A

End Function
Function EnumContact%()

    Dim A%
    Dim BufferA%

    For A = LBound(Player) To UBound(Player)
        If Player(A).Name <> "" Then
            BufferA = BufferA + 1
        End If
    Next A
    EnumContact = BufferA

End Function
Function GetContact(Name$)

    Dim A%
    
    For A = LBound(Player) To UBound(Player)
        If Player(A).Name = Name Then
            GetContact = A
            Exit Function
        End If
    Next A
    
End Function
Function ListContact(ListObj As ListBox)

    Dim A%

    ListObj.Clear
    For A = LBound(Player) To UBound(Player)
        If Player(A).Name <> "" Then
            ListObj.AddItem Player(A).Name
        End If
    Next A

End Function
Function RemContact(Name$)

    Dim BufferA%

    BufferA = GetContact(Name)
    If BufferA <> 0 Then
        Player(BufferA).Name = ""
        Player(BufferA).Host = ""
        Player(BufferA).Port = 0
    End If
    
End Function
Function UDPRecieve(WinsockObj As Winsock, Text$, RtnText$)

    Dim A%
    Dim BufferA$
    Dim BufferB$
    Dim OutMark!

    BufferA = GetBtw(Text, ">", ":", 1)
    BufferB = GetBtw(Text, "(", ")", 1)
    If BufferA = "GET" Then
        OutMark = GetSeg(BufferB, ":", 1)
        RtnText = GetSeg(BufferB, ":", 2)
        For A = 1 To 3
            WinsockObj.SendData ">GOT:(" & OutMark & ")"
            DoEvents
        Next A
    End If
    If BufferA = "GOT" Then
        InMark = GetSeg(BufferB, ":", 1)
    End If

End Function
Function UDPSend(WinsockObj As Winsock, Text$)

    Const TimeOutTime% = 3 'seconds
    
    Dim Begin!
    Dim Finish!
    Dim OutMark!
    
    OutMark = Timer
    Begin = Timer
    Do Until InMark = OutMark
        Finish = Timer
        If Finish - Begin < TimeOutTime Then
            WinsockObj.SendData ">GET:(" & OutMark & ":" & Text & ")"
            DoEvents
        Else
            Exit Do
        End If
    Loop
    
End Function
Function SendToAll(WinsockObj As Winsock, Text$)

    Dim A%
    
    For A = LBound(Player) To UBound(Player)
        If Player(A).Name <> "" Then
            If Player(A).Name <> WinsockObj.Tag Then
                Call UseContact(WinsockObj, Player(A).Name)
                WinsockObj.SendData Text
            End If
        End If
    Next A

End Function
Function UseContact(WinsockObj As Winsock, Name$)

    Dim BufferA%

    BufferA = GetContact(Name)
    If BufferA <> 0 Then
        WinsockObj.RemoteHost = Player(BufferA).Host
        WinsockObj.RemotePort = Player(BufferA).Port
    End If
    
End Function
