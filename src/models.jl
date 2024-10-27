export BirthDeathConstant
export BirthDeathShift

struct BirthDeathConstant
    λ::Float64
    μ::Float64
end

struct BirthDeathShift
    λ::Vector{Float64}
    μ::Vector{Float64}
    η::Float64
end

struct BirthDeathSpeciationExponential
    λmean::Float64 ## the mean of the exponential distribution
    μ::Float64 ## constant extinction rate
    η::Float64 ## shift rate
end