Attribute VB_Name = "Module1"
Const EarthGravAccel! = 9.80926  'm/s^2
Function ForceAccel!(Force!, Mass!)
ForceAccel = Force * Mass

End Function
Function AttractForce!(Mass1!, Mass2!, Dist!)
AttractForce = 6.67 * 10 ^ (-11) * Mass1 * Mass2 / Dist ^ 2

End Function
Function Pdelta!(Vaverage!, Tdelta!)
Pdelta = Vaverage * Tdelta

End Function
Function Vdelta!(Aaverage!, Tdelta!)
Vdelta = Aaverage * Tdelta

End Function


