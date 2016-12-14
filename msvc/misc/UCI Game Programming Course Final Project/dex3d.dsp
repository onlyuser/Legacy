# Microsoft Developer Studio Project File - Name="dex3d" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=dex3d - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "dex3d.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "dex3d.mak" CFG="dex3d - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "dex3d - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "dex3d - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "dex3d - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x404 /d "NDEBUG"
# ADD RSC /l 0x404 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "dex3d - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0x404 /d "_DEBUG"
# ADD RSC /l 0x404 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "dex3d - Win32 Release"
# Name "dex3d - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\camera.cpp
# End Source File
# Begin Source File

SOURCE=.\image.cpp
# End Source File
# Begin Source File

SOURCE=.\io3ds.cpp
# End Source File
# Begin Source File

SOURCE=.\ioDib.cpp
# End Source File
# Begin Source File

SOURCE=.\ioMat.cpp
# End Source File
# Begin Source File

SOURCE=.\ioPak.cpp
# End Source File
# Begin Source File

SOURCE=.\keyBase.cpp
# End Source File
# Begin Source File

SOURCE=.\light.cpp
# End Source File
# Begin Source File

SOURCE=.\material.cpp
# End Source File
# Begin Source File

SOURCE=.\matrix.cpp
# End Source File
# Begin Source File

SOURCE=.\mesh.cpp
# End Source File
# Begin Source File

SOURCE=.\misc.cpp
# End Source File
# Begin Source File

SOURCE=.\modify.cpp
# End Source File
# Begin Source File

SOURCE=.\object.cpp
# End Source File
# Begin Source File

SOURCE=.\scene.cpp
# End Source File
# Begin Source File

SOURCE=.\treeNode.cpp
# End Source File
# Begin Source File

SOURCE=.\vector.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\camera.h
# End Source File
# Begin Source File

SOURCE=.\image.h
# End Source File
# Begin Source File

SOURCE=.\keyBase.h
# End Source File
# Begin Source File

SOURCE=.\light.h
# End Source File
# Begin Source File

SOURCE=.\material.h
# End Source File
# Begin Source File

SOURCE=.\matrix.h
# End Source File
# Begin Source File

SOURCE=.\mesh.h
# End Source File
# Begin Source File

SOURCE=.\misc.h
# End Source File
# Begin Source File

SOURCE=.\object.h
# End Source File
# Begin Source File

SOURCE=.\scene.h
# End Source File
# Begin Source File

SOURCE=.\treeNode.h
# End Source File
# Begin Source File

SOURCE=.\vector.h
# End Source File
# End Group
# Begin Group "Templates"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\list.h
# End Source File
# Begin Source File

SOURCE=.\list_node.h
# End Source File
# Begin Source File

SOURCE=.\sort.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\GL\glut32.lib
# End Source File
# Begin Source File

SOURCE=.\FMOD\fmodvc.lib
# End Source File
# End Group
# Begin Group "CUI"

# PROP Default_Filter ""
# Begin Group "Ben"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\CUI\benc.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\benc.h
# End Source File
# Begin Source File

SOURCE=.\CUI\collide.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\collide.h
# End Source File
# Begin Source File

SOURCE=.\CUI\rayTriSect.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\rayTriSect.h
# End Source File
# Begin Source File

SOURCE=.\CUI\triSect.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\triSect.h
# End Source File
# End Group
# Begin Group "Robbie"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\CUI\fmod.h
# End Source File
# Begin Source File

SOURCE=.\CUI\fmod_errors.h
# End Source File
# Begin Source File

SOURCE=.\CUI\robk.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\robk.h
# End Source File
# End Group
# Begin Group "Vinh"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\CUI\vinh.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\vinh.h
# End Source File
# End Group
# Begin Group "Test"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\CUI\test.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\test.h
# End Source File
# End Group
# Begin Group "Game"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\CUI\car.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\car.h
# End Source File
# Begin Source File

SOURCE=.\CUI\game.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\game.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\CUI\cui.cpp
# End Source File
# Begin Source File

SOURCE=.\CUI\cui.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\main.cpp
# End Source File
# End Target
# End Project
