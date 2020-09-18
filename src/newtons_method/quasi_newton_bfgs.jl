# W. C. Davidon, Variable Metric Method for Minimization SIAM Journal on Optimization. 1. (1991), 1-17.
using Printf
using LinearAlgebra
using ForwardDiff

f_test(x)     = (1-x[1])^2 + 100*(4x[2] - x[1]^2)^2
gradf_test(x) = ForwardDiff.gradient(f_test, x)
hessf_test(x) = ForwardDiff.hessian(f_test, x)

function line_search(f, grad_f, x, step_vec; alpha=5.0, beta=1e-4, sigma=0.1) 
    y0, g0     = f(x), grad_f(x)⋅step_vec
    y_prev     = NaN
    alpha_prev = 0
    alpha_low, alpha_high = NaN, NaN
    # bracket phase
    while true
        y = f(x + alpha*step_vec)
        if y > y0 + beta*alpha*g0 || (!isnan(y_prev) && y ≥ y_prev) 
            alpha_low, alpha_high = alpha_prev, alpha
            break 
        end
                
        g = grad_f(x + alpha*step_vec)⋅step_vec 
        if abs(g) ≤ -sigma*g0 # Gradient magnitude
            return alpha 
        elseif g ≥ 0
            alpha_low, alpha_high = alpha, alpha_prev
            break 
        end
        y_prev, alpha_prev, alpha = y, alpha, 2*alpha 
    end

    # zoom phase
    y_low = f(x + alpha_low*step_vec)
    n = 0
    while n < 40 # Maximum iterations
        alpha = (alpha_low + alpha_high)/2
        y = f(x + alpha*step_vec)
        if y > y0 + beta*alpha*g0 || y ≥ y_low #
            alpha_high = alpha 
        else
            g = grad_f(x + alpha*step_vec)⋅step_vec
            if abs(g) ≤ -sigma*g0 # Gradient magnitude
                return alpha 
            elseif g*(alpha_high - alpha_low) ≥ 0
                alpha_high = alpha_low 
            end
            alpha_low = alpha 
        end
        n += 1
    end 
end

abstract type DescentMethod end

mutable struct DFPMethod <: DescentMethod
    alpha::Real
    x::Vector{Float64}
    hinv_mat::Matrix{Float64}
end

function step!(dfp_obj::DFPMethod, f::Function, gradf::Function)
    x0       = dfp_obj.x
    hinv_mat = dfp_obj.hinv_mat
    grad_vec = gradf(x0)

    d     = -hinv_mat*grad_vec
    d    /= norm(d)
    alpha = line_search(f, gradf, dfp_obj.x, d)
    
    # if alpha is too small, use g
    if alpha < 1e-2
        d     = -grad_vec
        d    /= norm(d)
        alpha = line_search(f, gradf, dfp_obj.x, d)
    end
    
    dfp_obj.x    += alpha*d
    dfp_obj.alpha = alpha
    
    grad_vec′  = gradf(dfp_obj.x)
    delta      = dfp_obj.x - x0
    gamma      = grad_vec′ - grad_vec
    
    dfp_obj.hinv_mat  = hinv_mat
    dfp_obj.hinv_mat -= hinv_mat*gamma*gamma'*hinv_mat/(gamma'*hinv_mat*gamma)
    dfp_obj.hinv_mat += delta*delta'/(delta'*gamma) 
end

function optimize(dfp_obj::DFPMethod, f, gradf; f_tol=1e-4, g_tol=1e-4, max_iter=1000)
    
    xs = copy(dfp_obj.x)'

    @printf("%4s %6s %6s %10s\n", "iter", "x[1]", "x[2]", "norm(Δ)")
    println("------------------------------")
    for i in 1:max_iter
        x_prev = dfp_obj.x
        step!(dfp_obj::DFPMethod, f, gradf)
        xs = [xs; (dfp_obj.x)']
        @printf("%4d % 6.2f % 6.2f % 10.2e\n", i, dfp_obj.x[1], dfp_obj.x[2], norm(norm(gradf(dfp_obj.x))))
        
        if abs(f(dfp_obj.x)-f(x_prev)) < f_tol
            println("Terminate due to function value tolerance")
            break
        elseif norm(gradf(dfp_obj.x)) < g_tol
            println("Terminate due to gradient tolerance")
            break
        end
    end
    return xs
end

x0 = [-2, 1.5]
max_iter, f_tol, g_tol = 1000, 1e-6, 1e-8

dfp_obj = DFPMethod(2e-4, x0, Matrix(1.0I, length(x0), length(x0)))
xs      = optimize(dfp_obj, f_test, gradf_test, f_tol=f_tol, g_tol=g_tol, max_iter=max_iter)
open("../../test/dfp_result.csv", "w") do io
    for x in eachrow(xs)
        @printf(io, "% 12.6f, % 12.6f\n", x[1], x[2])
    end
end