struct Polar{T<:Real} <: Number
    r::T
    Θ::T
end

Polar(r::Real,Θ::Real) = Polar(promote(r,Θ)...)
function Base.show(io::IO, z::Polar)
    if get(io, :compact, false)
        print(io, "(",  z.r*cos(z.Θ), ",", z.r*sin(z.Θ), ")")
    else
        print(io, z.r, "*(cos", z.Θ, ", sin ", z.Θ, ")")
    end
end

a = Polar(3.0, 4.0)
println("a = ")
display(a)
println("\n")
polar_list = [Polar(3.0, 4.0) Polar(4.0,5.3)]
println("polar_list = ")
display(polar_list)
println("\n")