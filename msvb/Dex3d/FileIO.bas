Attribute VB_Name = "ModuleE"
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

Function WriteSingle(FileNumber As Integer, Variable As Single)

    Put #FileNumber, Seek(FileNumber), Variable
    
End Function
Function WriteByte(FileNumber As Integer, Variable As Byte)

    Put #FileNumber, Seek(FileNumber), Variable
    
End Function
Function ReadSingle(FileNumber As Integer) As Single

    Get #FileNumber, Seek(FileNumber), ReadSingle
    
End Function
Function ReadByte(FileNumber As Integer) As Byte

    Get #FileNumber, Seek(FileNumber), ReadByte
    
End Function
Function ReadLong(FileNumber As Integer) As Long

    Get #FileNumber, Seek(FileNumber), ReadLong
    
End Function
Function ReadInteger(FileNumber As Integer) As Integer

    Get #FileNumber, Seek(FileNumber), ReadInteger
    
End Function
Function ReadString(FileNumber As Integer) As String

    Dim CurrentByte As Byte
    
    Do While EOF(FileNumber) = False
        CurrentByte = ReadByte(FileNumber)
        If CurrentByte <> 0 Then
            ReadString = ReadString & Chr(CurrentByte)
        Else
            Exit Function
        End If
    Loop
    
End Function
Function WriteLong(FileNumber As Integer, Variable As Long)

    Put #FileNumber, Seek(FileNumber), Variable
    
End Function
Function WriteInteger(FileNumber As Integer, Variable As Integer)

    Put #FileNumber, Seek(FileNumber), Variable
    
End Function
Function WriteString(FileNumber As Integer, Variable As String)

    Dim A As Integer
    
    For A = 1 To Len(Variable)
        Call WriteByte(FileNumber, Asc(Mid(Variable, A, 1)))
    Next A
    Call WriteByte(FileNumber, 0)
    
End Function
