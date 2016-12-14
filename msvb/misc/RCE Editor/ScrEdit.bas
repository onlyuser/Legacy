Attribute VB_Name = "Module5"
Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
Public Function InvScrY(SrcScr As PictureBox, DestScr As PictureBox)

    Call StretchBlt(DestScr.hdc, 0, SrcScr.ScaleHeight, SrcScr.ScaleWidth, -SrcScr.ScaleHeight, SrcScr.hdc, 0, 0, SrcScr.ScaleWidth, SrcScr.ScaleHeight, vbSrcCopy)

End Function
Public Function InvScrX(SrcScr As PictureBox, DestScr As PictureBox)

    Call StretchBlt(DestScr.hdc, SrcScr.ScaleWidth, 0, -SrcScr.ScaleWidth, SrcScr.ScaleHeight, SrcScr.hdc, 0, 0, SrcScr.ScaleWidth, SrcScr.ScaleHeight, vbSrcCopy)

End Function

Function ScaleScr(SrcScr As PictureBox, DestScr As PictureBox)

    Call StretchBlt(DestScr.hdc, 0, 0, DestScr.ScaleWidth, DestScr.ScaleHeight, SrcScr.hdc, 0, 0, SrcScr.ScaleWidth, SrcScr.ScaleHeight, vbSrcCopy)

End Function
