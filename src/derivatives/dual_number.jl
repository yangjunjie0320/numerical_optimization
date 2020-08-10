# https://en.wikipedia.org/wiki/Dual_number
struct DualNumber <: Number  # DualNumber is a function-derivative pair
    x::Real
    y::Real
end

# Add the last two rules
import Base: -,*,+, /, convert, promote_rule
-(a::DualNumber, b::DualNumber) = DualNumber(a.x-b.x, a.y-b.y)
*(a::DualNumber, b::DualNumber) = DualNumber(a.x*b.x, a.x*b.y+a.y*b.x)

+(a::DualNumber, b::DualNumber) = DualNumber(a.x+b.x, a.y+b.y)
/(a::DualNumber, b::DualNumber) = DualNumber(a.x/b.x, (b.x*a.y - a.x*b.y)/b.x^2)
convert(::Type{DualNumber}, x::Real) = DualNumber(x, zero(x))
promote_rule(::Type{DualNumber}, ::Type{<:Number}) = DualNumber

# Examples
epsilon = DualNumber(0,1)
println("epsilon                     = ", epsilon)
println("epsilon * epsilon           = ", epsilon * epsilon)
println("1 / (1+epsilon)             = ", 1/(1+epsilon))
println("(1+2*epsilon)*(3-4*epsilon) = ", (1+2*epsilon)*(3-4*epsilon))