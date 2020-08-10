using ForwardDiff: gradient, hessian
f(x::Vector) = sum(sin, x) + prod(tan, x) * sum(sqrt, x);
x = rand(5)
println("\ngradient(f, x) = ")
display(gradient(f, x))
println("\n")
println("hessian(f, x) = ")
display(hessian(f, x))



# a = ForwardDiff.Dual{Real}(3,1)
# println("log(a^2) = ", log(a^2))

# b = ForwardDiff.Dual{Real}(2,0)
# println("log(a*b + max(a,2)) = ", log(a*b + max(a,2)))