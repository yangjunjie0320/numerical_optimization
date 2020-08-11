using Printf

f_test(x) = x^2 - 3*x 
function bracket_minimum(f, x=0.0; s=1e-2, k=2.0) 
    a, ya = x, f(x)
    b, yb = a + s, f(a + s) 
    if yb > ya
        a, b = b, a
        ya, yb = yb, ya
        s = -s
    end

    while true
        c, yc = b + s, f(b + s)
        @printf("%6.3f %6.3f %6.3f %6.3f\n", a, ya, c, yc)
        if yc > yb
            return a < c ? (a, c) : (c, a) 
        end
        a, ya, b, yb = b, yb, c, yc
        s *= k 
    end
end

bracket_minimum(f_test, 1.0)