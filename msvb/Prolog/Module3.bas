Attribute VB_Name = "Module3"
Option Explicit

Public mStateList As New Collection
Function ListGet(List As Collection, Name As String) As Boolean

    Dim Result As Boolean
    
    If ListFind(List, Name) <> 0 Then _
        Result = True
    ListGet = Result
    
End Function
Function ListSet(List As Collection, Name As String, Value As Boolean)

    Dim Index As Integer
    
    Index = ListFind(List, Name)
    If Value Then
        If Index = 0 Then _
            Call List.Add(Name)
    Else
        If Index <> 0 Then _
            Call List.Remove(Index)
    End If
    
End Function
Function GetState(Name As String) As Boolean

    Dim Result As Boolean
    
    Result = ListGet(mStateList, Name)
    GetState = Result
    
End Function
Function SetState(Name As String, Value As Boolean)

    Call ListSet(mStateList, Name, Value)
    
End Function
Function FoilLogic(Text As String) As String

    Dim Result As String
    
    Result = Text
    Result = "(" & Result & ")"
    Result = EditReplace(Result, "(", EditRepeat("(", 2))
    Result = EditReplace(Result, ")", EditRepeat(")", 2))
    Result = ShieldOps(Result, "+", 2)
    Result = ShieldOps(Result, "*", 1)
    Result = FoilLogicEx(Result)
    FoilLogic = Result
    
End Function
Function FoilLogicEx(Text As String) As String

    Dim i As Integer
    Dim Result As String
    Dim Length As Integer
    Dim Token As String
    Dim DoMerge As Boolean
    
    Length = Len(Text)
    i = 1
    Do While i <= Length
        Token = GetShellPtn(Text, i, "(", ")")
        If FindText(Token, "(") <> 0 Then
            Token = FoilLogicEx(Token)
        Else
            Token = "(" & Token & ")"
        End If
        If DoMerge Then
            Result = MergeTokens(Result, Token)
        Else
            If Result <> "" Then
                Result = Result & "+" & Token
            Else
                Result = Token
            End If
        End If
        If i <= Length Then
            If Mid(Text, i, 1) = "*" Then
                DoMerge = True
            Else
                DoMerge = False
            End If
        End If
    Loop
    FoilLogicEx = Result
    
End Function
Function MergeTokens(TextA As String, TextB As String) As String

    Dim i As Integer
    Dim j As Integer
    Dim Result As String
    Dim LenTextA As Integer
    Dim LenTextB As Integer
    Dim TokenA As String
    Dim TokenB As String
    
    LenTextA = Len(TextA)
    LenTextB = Len(TextB)
    i = 1
    Do While i <= LenTextA
        TokenA = GetShellPtn(TextA, i, "(", ")")
        j = 1
        Do While j <= LenTextB
            TokenB = GetShellPtn(TextB, j, "(", ")")
            Result = Result & "(" & TokenA & "*" & TokenB & ")+"
        Loop
    Loop
    If Result <> "" Then _
        Result = Left(Result, Len(Result) - 1)
    MergeTokens = Result
    
End Function
