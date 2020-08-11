using ForwardDiff: gradient, gradient!, hessian
using ForwardDiff: GradientConfig, Chunk

function rosenbrock(x)
    a = one(eltype(x))
    b = 100 * a
    result = zero(eltype(x))
    for i in 1:length(x)-1
        result += (a - x[i])^2 + b*(x[i+1] - x[i]^2)^2
    end
    return result
end

f(x::Vector) = sum(sin, x) + prod(tan, x) * sum(sqrt, x);
x = rand(10)

println("\n\nx =")
display(x)
println("\n\ngradient(f, x) = ")
display(gradient(f, x))
println("\n\nhessian(f, x) = ")
display(hessian(rosenbrock, x))
println("\n\ngradient(rosenbrock, x) = ")
display(gradient(rosenbrock, x))
println("\n\nhessian(rosenbrock, x) = ")
display(hessian(rosenbrock, x))

println("\n")
xx = rand(100000)
out = similar(xx)
cfg1 = GradientConfig(rosenbrock, xx, Chunk{1}())
println("\ngradient!(out, rosenbrock, xx, cfg1)")
@time gradient!(out, rosenbrock, xx, cfg1)

cfg2 = GradientConfig(rosenbrock, xx, Chunk{2}())
println("\ngradient!(out, rosenbrock, xx, cfg2)")
@time gradient!(out, rosenbrock, xx, cfg2)

cfg4 = GradientConfig(rosenbrock, xx, Chunk{4}())
println("\ngradient!(out, rosenbrock, xx, cfg4)")
@time gradient!(out, rosenbrock, xx, cfg4)