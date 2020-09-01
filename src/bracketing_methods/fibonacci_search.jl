using Printf

f_test(x) = x^2 - 3*x 
function fibonacci_search(f, a, b, n; epsilon=0.01) 
    phi = (1+√5)/2
    s = (1-√5)/(1+√5)
    rho = 1 / (phi*(1-s^(n+1))/(1-s^n))
    d = rho*b + (1-rho)*a
    yd = f(d)
    for i in 1 : n-1
        if i == n-1
            c = epsilon*a + (1-epsilon)*d 
        else
            c = rho*a + (1-rho)*b 
        end
        yc = f(c) 
        if yc < yd
            b, d, yd = d, c, yc
        else
            a, b = b, c 
        end
        rho = 1 / (phi*(1-s^(n-i+1))/(1-s^(n-i))) 
        @printf("%d %6.3f %6.3f %6.3f\n", i, a, b, abs(a-b))
    end
return a < b ? (a, b) : (b, a) 
end

fibonacci_search(f_test, -1, 2, 10; epsilon=0.01)