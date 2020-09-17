using Printf

struct BracketingOptimizer
    f::Function
    a::Real
    b::Real
    max_iter::Integer
    function BracketingOptimizer(f::Function, a::Real, b::Real, max_iter::Integer=10)
        println("\n----------------------------------")
        println("Initializing Bracketing Optimizer:")
        @printf("a = %f\n", a)
        @printf("b = %f\n", b)
        println("f = ", f)
        println("max_iter = ", max_iter)
        println("----------------------------------\n")
        new(f::Function, a::Real, b::Real, max_iter::Integer)
    end
end
