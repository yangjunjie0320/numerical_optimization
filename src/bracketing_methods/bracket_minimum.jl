using Printf
include("bracketing_optimizer.jl")

f_test(x) = x^2 - 3*x 
function bracket_minimum(opt::BracketingOptimizer; k::Real=2.0) 
    a, b = opt.a, opt.b
    s = b - a
    a, ya = a, opt.f(a)
    b, yb = b, opt.f(b) 
    if yb > ya
        a, b = b, a
        ya, yb = yb, ya
        s = -s
    end

    @printf("%4s %6s %6s %6s %6s\n", "iter", "a", "f(a)", "b", "f(a)")
    for i = 1 : opt.max_iter-1
        c, yc = b + s, opt.f(b + s)
        @printf("%4d % 6.3f % 6.3f % 6.3f % 6.3f\n", i, a, ya, c, yc)
        if yc > yb
            return a < c ? (a, c) : (c, a) 
        end
        a, ya, b, yb = b, yb, c, yc
        s *= k
    end
end

opt = BracketingOptimizer(f_test, 1.0, 1.02, 30)

println("\nk = 1.0")
bracket_minimum(opt; k=1.0)
println("\nk = 2.0")
bracket_minimum(opt; k=2.0)