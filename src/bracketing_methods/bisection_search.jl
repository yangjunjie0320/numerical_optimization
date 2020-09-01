using Printf
include("bracketing_optimizer.jl")

f_test(x) = x^2 - 3*x 
function bisection_search(opt::BracketingOptimizer; rho::Real=1/2) 
    d   = rho * opt.b + (1 - rho)*opt.a 
    fd  = opt.f(d)
    a, b = opt.a, opt.b

    @printf("%4s %6s %6s %10s\n", "iter", "a", "b", "abs(a-b)")
    for i = 1 : opt.max_iter-1
        c = rho*a + (1 - rho)*b 
        fc = opt.f(c)
        if fc < fd
            b, d, fd = d, c, fc
        else
            a, b = b, c 
        end
        @printf("%4d % 6.2f % 6.2f % 10.4f\n", i, a, b, abs(a-b))
    end
    return a < b ? (a, b) : (b, a) 
end

opt = BracketingOptimizer(f_test, -1.0, 2.0, 10)

println("\nrho = 1/2")
bisection_search(opt; rho = 1/2) 
println("\nrho = (1+√5)/2-1")
bisection_search(opt; rho = (1+√5)/2-1) 
