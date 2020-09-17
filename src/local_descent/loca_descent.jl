using Printf
using LinearAlgebra

function f_test(x::Array{Real,2})
    return x[1]^2 + x[1]*x[2] + x[2]^2
end

function gradf_test(x::Array{Real,2})
    return [2*x[1] + x[2], 2*x[2] + x[1]]
end

function strong_backtracking(f::Function, grad_f::Function, x0, step_size; alpha=5, beta=1e-4, sigma=0.1) 
    y0, g0     = f(x0), grad_f(x0)⋅step_size
    y_prev     = NaN
    alpha_prev = 0
    alpha_low, alpha_high = NaN, NaN
    # bracket phase
    while true
        y = f(x + alpha*step_size)[1]
        if y > y0 + beta*alpha*g0 || (!isnan(y_prev) && y ≥ y_prev) 
            alpha_low, alpha_high = alpha_prev, alpha
            break 
        end
                
        g = grad_f(x + alpha*step_size)⋅d 
        if abs(g) ≤ -sigma*g0
            return alpha 
        elseif g ≥ 0
            alpha_low, alpha_high = alpha, alpha_prev
            break 
        end
        y_prev, alpha_prev, alpha = y, alpha, 2*alpha 
    end
    
    @printf("The initial interval: %6.3f %6.3f\n", alpha_low, alpha_high)

    # zoom phase
    ylo = f(x + alpha_low*step_size)[1]
    n = 0
    while n < 10
        alpha = (alpha_low + alpha_high)/2
        y = f(x + alpha*step_size)[1]
        @printf("The interval: %6.3f %6.3f\n", alpha_low, alpha_high)
        if y > y0 + beta*alpha*g0 || y ≥ ylo #
            @printf("No sufficient decrease: %6.3f %6.3f %6.3f %6.3f\n", alpha, y, y0, ylo)
            alpha_high = alpha 
        else
            g = grad_f(x + alpha*step_size)⋅d 
            if abs(g) ≤ -sigma*g0
                return alpha
            elseif g*(alpha_high - alpha_low) ≥ 0
                alpha_high = alpha_low 
            end
            alpha_low = alpha 
        end
        n += 1
    end 
end

strong_backtracking(f, f_prime, x0, step_size)