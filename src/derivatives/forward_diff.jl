using ForwardDiff
a = ForwardDiff.Dual{Rational}(3,1)
println("log(a^2) = ", log(a^2))

b = ForwardDiff.Dual{Rational}(2,0)
println("log(a*b + max(a,2)) = ", log(a*b + max(a,2)))