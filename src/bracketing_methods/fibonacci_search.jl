using Printf
include("bracketing_optimizer.jl")

f_test(x) = x^2 - 3*x
function fibonacci_search(opt::BracketingOptimizer; epsilon::Real=0.01) 
    a, b = opt.a, opt.b
    n = opt.max_iter

    phi = (1+√5)/2
    s = (1-√5)/(1+√5)

    rho = 1 / (phi*(1-s^(n+1))/(1-s^n))
    d = rho*opt.b + (1-rho)*opt.a
    yd = opt.f(d)

    @printf("%4s %6s %6s %10s\n", "iter", "a", "b", "abs(a-b)")
    for i in 1 : n-1
        if i == n-1
            c = epsilon*a + (1-epsilon)*d 
        else
            c = rho*a + (1-rho)*b 
        end
        yc = opt.f(c) 
        if yc < yd
            b, d, yd = d, c, yc
        else
            a, b = b, c 
        end
        rho = 1 / (phi*(1-s^(n-i+1))/(1-s^(n-i))) 
        @printf("%4d % 6.2f % 6.2f % 10.4f\n", i, a, b, abs(a-b))
    end
    return a < b ? (a, b) : (b, a) 
end

opt = BracketingOptimizer(f_test, -1.0, 2.0, 10)
fibonacci_search(opt; epsilon=0.01)