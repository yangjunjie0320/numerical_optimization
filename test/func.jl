function print_val(x, f::Function)
    fval = f(x)
    println("x = ", x, ", fval = ", fval)
end

print_val(0.2, sin)