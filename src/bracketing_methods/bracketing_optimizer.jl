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

function Base.show(io::IO, opt::BracketingOptimizer)
    println("----------------------")
    println(io, "Bracketing Optimizer:")
    @printf(io, "a = %f\n", opt.a)
    @printf(io, "b = %f\n", opt.b)
    println(io, "f = ", opt.f)
    println(io, "max_iter = ", opt.max_iter)
    println("----------------------")
end
