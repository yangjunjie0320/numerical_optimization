using Printf

f_test(x) = x^2 - 3*x 
function golden_section_search(f, a, b, n) 
    phi = (1+√5)/2
    rho = phi-1
    d = rho * b + (1 - rho)*a 
    yd = f(d)
    for i = 1 : n-1
        c = rho*a + (1 - rho)*b 
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

golden_section_search(f_test, -1, 2, 10)