Attribute VB_Name = "ModuleK"
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

Public Const SW_NORMAL = 1

Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Function PathByFilename(Filename As String, AbortOnError As Boolean) As String

    If Mid(App.Path, Len(App.Path), 1) = "\" Then
        PathByFilename = App.Path & Filename
    Else
        PathByFilename = App.Path & "\" & Filename
    End If
    If Dir(PathByFilename) = "" Then
        If AbortOnError = True Then
            Call _
                MsgBox( _
                    "File not found. Aborting." & vbCrLf & _
                    vbCrLf & _
                    PathByFilename, _
                    16, _
                    "Error" _
                )
            End
        Else
            PathByFilename = ""
        End If
    End If
    
End Function
Function Explore(URL As String)

    Call ShellExecute(0, "open", URL, "", "", SW_NORMAL)
    
End Function
