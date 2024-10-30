export BirthDeathConstant
export BirthDeathShift
export BirthDeathShiftContinuous

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

struct BirthDeathShiftContinuous
    dλ::Distributions.UnivariateDistribution
    dμ::Distributions.UnivariateDistribution
    α::Float64
    β::Float64
end