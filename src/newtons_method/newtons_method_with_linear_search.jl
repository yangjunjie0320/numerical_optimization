# necessary libraries
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
    while n < 10 # Maximum iterations
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


function newtons_method_ls(f, grad_f, hess_f, x; epsilon=1e-4, k_max=20) 
    xs = copy(x)'
    k, step_vec = 1, fill(Inf, length(x))
    @printf("%4s %6s %6s %10s\n", "k", "x[1]", "x[2]", "norm(Δ)")
    println("------------------------------")
    while norm(step_vec) > epsilon && k ≤ k_max
        step_vec = -hess_f(x) \ grad_f(x)
        alpha = line_search(f, grad_f, x, step_vec)
        if f(x+step_vec) < f(x+alpha*step_vec)
            x += step_vec
        else
            x += alpha*step_vec
        end
        k += 1
        xs = [xs; (x)'] 
        @printf("%4d % 6.3f % 6.3f % 10.4e\n", k, x[1], x[2], norm(step_vec))
    end
    return xs
end

x0 = [-2, 1.5]
xs = newtons_method_ls(f_test, gradf_test, hessf_test, x0)