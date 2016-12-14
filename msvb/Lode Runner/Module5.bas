Attribute VB_Name = "Module5"
Public Const SND_FILENAME = &H20000
Public Const SND_NODEFAULT = &H2
Public Const SND_NOWAIT = &H2000
Public Const SND_ASYNC = &H1
Public Const SND_PURGE = &H40

Public Declare Function PlaySound Lib "winmm.dll" Alias "PlaySoundA" (ByVal lpszName As String, ByVal hModule As Long, ByVal dwFlags As Long) As Long
Function GetStringVB(StringC() As Byte) As String

    Dim i As Integer
    Dim Result As String
    
    i = 0
    Do While (StringC(i) <> 0)
        Result = Result & Chr(StringC(i))
        i = i + 1
    Loop
    GetStringVB = Result
    
End Function
Function PlaySoundEx(Filename As String)

    Dim LocalPath As String
    
    If GameSound Then
        If Filename <> "" Then
            LocalPath = GetLocalResPath(Filename)
            If Dir(LocalPath) <> "" Then _
                Call _
                    PlaySound( _
                        LocalPath, _
                        vbNull, _
                        SND_FILENAME Or _
                            SND_NODEFAULT Or _
                            SND_NOWAIT Or _
                            SND_ASYNC _
                    )
        End If
    End If
    
End Function
Function ResetSound()

    Call PlaySound("", vbNull, SND_PURGE)
    
End Function
Sub ShowAbout()

    Call _
        MsgBox( _
            App.Title & " v" & App.Major & "." & App.Minor & vbCrLf & _
            vbCrLf & _
            "by Jerry Chen", _
            vbInformation, _
            "About" _
        )
        
End Sub
