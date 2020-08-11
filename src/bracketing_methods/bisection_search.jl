using Printf

f_test(x) = x^2 - 3*x 
function bisection_search(f, a, b, n) 
    ρ = 1/2
    d = ρ * b + (1 - ρ)*a 
    yd = f(d)
    for i = 1 : n-1
        c = ρ*a + (1 - ρ)*b 
        yc = f(c)
        if yc < yd
            b, d, yd = d, c, yc
        else
            a, b = b, c 
        end
        @printf("%d %6.3f %6.3f %6.3f\n", i, a, b, abs(a-b))
    end
    return a < b ? (a, b) : (b, a) 
end

bisection_search(f_test, -1, 2, 10) 