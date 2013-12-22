Attribute VB_Name = "Module4"

Function ComboAdd(ComboObj As ComboBox, NoRepeat As Boolean)

    Dim A%
    
    If NoRepeat = True Then
        For A = 0 To ComboObj.ListCount - 1
            If ComboObj.List(A) = ComboObj.Text Then GoTo Finish:
        Next A
    End If
    ComboObj.AddItem ComboObj.Text
    ComboObj.ListIndex = ComboGet(ComboObj, ComboObj.Text)
Finish:
    ComboObj.Text = ""

End Function
Function ComboGet%(ComboObj As ComboBox, Item$)

    Dim A%
    
    For A = 0 To ComboObj.ListCount - 1
        If ComboObj.List(A) = Item Then
            ComboGet = A
            Exit Function
        End If
    Next A
    ComboGet = -1

End Function
Function ComboMatch(ComboObj As ComboBox)
    
    Dim MarkA%
    Dim A%
    
    If Len(ComboObj.Text) <= Len(ComboObj.Tag) Then
        If ComboObj.Text <> Mid(ComboObj.Tag, 1, Len(ComboObj.Text)) Then ComboObj.Tag = ""
    End If
    If Len(ComboObj.Text) > Len(ComboObj.Tag) Then
        If ComboObj.ListCount > 0 Then
            MarkA = Len(ComboObj.Text)
            For A = 0 To ComboObj.ListCount - 1
                If Mid(ComboObj.List(A), 1, Len(ComboObj.Text)) = ComboObj.Text Then
                    ComboObj.ListIndex = A
                    ComboObj.SelStart = MarkA
                    ComboObj.SelLength = Len(ComboObj.Text) - MarkA
                    Exit For
                End If
            Next A
        End If
    End If
    ComboObj.Tag = Mid(ComboObj.Text, 1, ComboObj.SelStart)

End Function
