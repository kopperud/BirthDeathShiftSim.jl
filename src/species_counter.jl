export SpeciesCounter
export ExtinctionCounter

abstract type Counter end

mutable struct SpeciesCounter <: Counter
    count::Int64
end

mutable struct ExtinctionCounter <: Counter
    count::Int64
end

function SpeciesCounter()
    counter = SpeciesCounter(1)
    return(counter)
end

function ExtinctionCounter()
    counter = ExtinctionCounter(1)
    return(counter)
end

function increment!(counter::T) where {T <: Counter}
    counter.count += 1
end

function decrement!(counter::T) where {T <: Counter}
    counter.count -= 1
    @assert n > 0
end

