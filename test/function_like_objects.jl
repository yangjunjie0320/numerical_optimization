struct Polynomial{Real}
    coeffs::Vector{Real}
end

function (p::Polynomial)(x)
    v = p.coeffs[end]
    for i = (length(p.coeffs)-1):-1:1
        v = v*x + p.coeffs[i]
    end
    return v
end

p = Polynomial([1,10,100])
println("p(3) = ", p(3))