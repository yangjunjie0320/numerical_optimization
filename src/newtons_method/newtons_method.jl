# necessary libraries
using Printf
using LinearAlgebra
using ForwardDiff

f_test(x)     = (1-x[1])^2 + 100*(4x[2] - x[1]^2)^2
gradf_test(x) = ForwardDiff.gradient(f_test, x)
hessf_test(x) = ForwardDiff.hessian(f_test, x)

function newtons_method(grad_f, hess_f, x; epsilon=1e-4, k_max=20) 
    xs = copy(x)'
    k, step_vec = 1, fill(Inf, length(x))
    @printf("%4s %6s %6s %10s\n", "k", "x[1]", "x[2]", "norm(Δ)")
    println("------------------------------")
    while norm(step_vec) > epsilon && k ≤ k_max
        step_vec = -hess_f(x) \ grad_f(x)
        x += step_vec
        k += 1
        xs = [xs; (x)']
        @printf("%4d % 6.2f % 6.2f % 10.4e\n", k, x[1], x[2], norm(step_vec))
    end
    return xs
end

x0 = [-2, 1.5]
xs = newtons_method(gradf_test, hessf_test, x0)