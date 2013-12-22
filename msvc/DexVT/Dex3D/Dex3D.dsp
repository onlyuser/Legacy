# Microsoft Developer Studio Project File - Name="Dex3D" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=Dex3D - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "Dex3D.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Dex3D.mak" CFG="Dex3D - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Dex3D - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "Dex3D - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Dex3D - Win32 Release"

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
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "DEX3D_EXPORTS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "DEX3D_EXPORTS" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x404 /d "NDEBUG"
# ADD RSC /l 0x404 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /machine:I386

!ELSEIF  "$(CFG)" == "Dex3D - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "DEX3D_EXPORTS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /w /W0 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "DEX3D_EXPORTS" /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x404 /d "_DEBUG"
# ADD RSC /l 0x404 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib opengl32.lib /nologo /dll /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "Dex3D - Win32 Release"
# Name "Dex3D - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Group "Base Types"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Color.cpp
# End Source File
# Begin Source File

SOURCE=.\Matrix.cpp
# End Source File
# Begin Source File

SOURCE=.\Transform.cpp
# End Source File
# Begin Source File

SOURCE=.\Vector.cpp
# End Source File
# End Group
# Begin Group "Core Classes"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Camera.cpp
# End Source File
# Begin Source File

SOURCE=.\Face.cpp
# End Source File
# Begin Source File

SOURCE=.\Font.cpp
# End Source File
# Begin Source File

SOURCE=.\GroupMgr.cpp
# End Source File
# Begin Source File

SOURCE=.\HullPrim.cpp
# End Source File
# Begin Source File

SOURCE=.\Light.cpp
# End Source File
# Begin Source File

SOURCE=.\Mesh.cpp
# End Source File
# Begin Source File

SOURCE=.\Object.cpp
# End Source File
# Begin Source File

SOURCE=.\PhysObj.cpp
# End Source File
# Begin Source File

SOURCE=.\Scene.cpp
# End Source File
# Begin Source File

SOURCE=.\Texture.cpp
# End Source File
# End Group
# Begin Group "Exports"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Dex3D.cpp
# End Source File
# Begin Source File

SOURCE=.\Exports.cpp
# End Source File
# End Group
# Begin Group "Interfaces"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\IAttrib.cpp
# End Source File
# Begin Source File

SOURCE=.\IMesh.cpp
# End Source File
# Begin Source File

SOURCE=.\ISortable.cpp
# End Source File
# Begin Source File

SOURCE=.\ITagged.cpp
# End Source File
# End Group
# Begin Group "Portable Libs"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\CritSection.cpp
# End Source File
# Begin Source File

SOURCE=.\Exception.cpp
# End Source File
# Begin Source File

SOURCE=.\String.cpp
# End Source File
# End Group
# Begin Group "Add-ons"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\File3ds.cpp
# End Source File
# Begin Source File

SOURCE=.\FileBmp.cpp
# End Source File
# Begin Source File

SOURCE=.\FileSys.cpp
# End Source File
# Begin Source File

SOURCE=.\Polygon.cpp
# End Source File
# End Group
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Group "Base Types (H)"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Color.h
# End Source File
# Begin Source File

SOURCE=.\Matrix.h
# End Source File
# Begin Source File

SOURCE=.\Transform.h
# End Source File
# Begin Source File

SOURCE=.\Vector.h
# End Source File
# End Group
# Begin Group "Core Classes (H)"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Camera.h
# End Source File
# Begin Source File

SOURCE=.\Face.h
# End Source File
# Begin Source File

SOURCE=.\Font.h
# End Source File
# Begin Source File

SOURCE=.\GroupMgr.h
# End Source File
# Begin Source File

SOURCE=.\HullPrim.h
# End Source File
# Begin Source File

SOURCE=.\Light.h
# End Source File
# Begin Source File

SOURCE=.\Mesh.h
# End Source File
# Begin Source File

SOURCE=.\Object.h
# End Source File
# Begin Source File

SOURCE=.\PhysObj.h
# End Source File
# Begin Source File

SOURCE=.\Scene.h
# End Source File
# Begin Source File

SOURCE=.\Texture.h
# End Source File
# End Group
# Begin Group "Exports (H)"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Dex3D.h
# End Source File
# Begin Source File

SOURCE=.\Exports.h
# End Source File
# End Group
# Begin Group "Interfaces (H)"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\IAttrib.h
# End Source File
# Begin Source File

SOURCE=.\IMesh.h
# End Source File
# Begin Source File

SOURCE=.\ISortable.h
# End Source File
# Begin Source File

SOURCE=.\ITagged.h
# End Source File
# End Group
# Begin Group "Portable Libs (H)"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\CritSection.h
# End Source File
# Begin Source File

SOURCE=.\Exception.h
# End Source File
# Begin Source File

SOURCE=.\String.h
# End Source File
# Begin Source File

SOURCE=.\Util.h
# End Source File
# End Group
# Begin Group "Add-ons (H)"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\File3ds.h
# End Source File
# Begin Source File

SOURCE=.\FileBmp.h
# End Source File
# Begin Source File

SOURCE=.\FileSys.h
# End Source File
# Begin Source File

SOURCE=.\Polygon.h
# End Source File
# End Group
# Begin Group "Templates (H)"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Collection.h
# End Source File
# Begin Source File

SOURCE=.\TDex3D.h
# End Source File
# Begin Source File

SOURCE=.\TDexGL.h
# End Source File
# End Group
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\Dex3D.def
# End Source File
# End Group
# End Target
# End Project
