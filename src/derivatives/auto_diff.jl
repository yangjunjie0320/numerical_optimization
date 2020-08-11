# Based on arXiv:1607.07892
using ForwardDiff: Dual, Tag, partials

function my_extract_derivative(::Type{T}, y::Dual) where {T}
    return partials(T, y, 1)
end 

function my_derivative(f::F, x::R) where {F,R<:Real}
    T = typeof(Tag(f, R))
    return my_extract_derivative(T, f(Dual{T}(x, one(x))))
end

x = Dual{Real}(0., 1.)
println("x = ", x)
f = x -> x^2 + 2*x + 1
println("f(x) = ", f(x))
println("my_derivative(x -> x^2 + 2*x + 1, 0.0) = ", my_derivative(x -> x^2 + 2*x + 1, 0.0))
println("sin(x) = ", sin(x))
println("my_derivative(sin, x) = ", my_derivative(sin, 0.0))
println("exp(x) = ", exp(x))
println("my_derivative(exp, x) = ", my_derivative(exp, 0.0))