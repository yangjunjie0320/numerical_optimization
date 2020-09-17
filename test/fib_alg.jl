module StrategyExample

abstract type Algo end
struct Memoized <: Algo end
struct Iterative <: Algo end

# Memoization startegy
using Memoize

@memoize function _fib(n)
    n <= 2 ? 1 : _fib(n-1) + _fib(n-2)
end

function fib(algo::Memoized, n::Integer)
    println("Using memoization algorithm")
    _fib(n)
end

# Iterative strategy
function fib(algo::Iterative, n::Integer)
    println("Using iterative algorithm")
    n <= 2 && return 1
    prev1, prev2 = 1, 1
    local curr
    for i in 3:n
        curr = prev1 + prev2
        prev1, prev2 = curr, prev1
    end
    return curr
end

# auto-selection
using  Printf
function fib(n)
    algo = n > 50 ? Memoized() : Iterative()
    return fib(algo, n)
end

function test()
    t1 = now()
    @show fib(Iterative, 60)
    t2 = now()
    @show fib(Memoized,  60)
    t3 = now()
    @sprintf("t1 = %d", t2-t1)
    @sprintf("t2 = %d", t3-t2)
end

end #module

using .StrategyExample
StrategyExample.test()