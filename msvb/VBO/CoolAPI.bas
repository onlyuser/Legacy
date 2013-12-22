Attribute VB_Name = "Module5"
Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Public Const SW_SHOW = 1
Public Declare Function ShellExecute Lib _
"shell32.dll" Alias "ShellExecuteA" _
(ByVal hwnd As Long, _
ByVal lpOperation As String, _
ByVal lpFile As String, _
ByVal lpParameters As String, _
ByVal lpDirectory As String, _
ByVal nShowCmd As Long) As Long
Public Sub Navigate(FormObj As Form, ByVal WebPageURL As String)
    
    Dim hBrowse As Long
    hBrowse = ShellExecute(FormObj.hwnd, "open", WebPageURL, "", "", SW_SHOW)

End Sub
Sub WinPos(Handle%, Position%)

    If Position = 1 Then Call SetWindowPos(Handle, -1, 0, 0, 0, 0, &H2 Or &H1 Or &H10)
    If Position = 0 Then Call SetWindowPos(Handle, -2, 0, 0, 0, 0, &H2 Or &H1 Or &H10)

End Sub
