abstract type AbstractNode end

mutable struct Variable{T} <: AbstractNode
    value::T
    grad::T

    Variable(val::T) where T = new{T}(val, zero(grad))
end

struct Node{FT <: Function, ArgsT <: Tuple, KwargsT <: NamedTuple} <: AbstractNode
    f::FT
    args::ArgsT
    kwargs::KwargsT
end