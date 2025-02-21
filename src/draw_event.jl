@enum Event Speciation Extinction SpeciationShift ExtinctionShift
#@enum EventSpeciation Speciation Extinction SpeciationShift


function type_of_event(
    model::BirthDeathConstant
)
    λ = model.λ
    μ = model.μ

    s = λ + μ

    d = Distributions.Categorical([λ/s, μ/s])
    events = instances(Event)
    r = rand(d)

    ev = events[r]

    return(ev)
end

function type_of_event(
    model::BirthDeathSpeciationExponential, λ::Float64,
)
    #λ = model.λ
    μ = model.μ
    η = model.η

    s = λ + μ + η ## s for sum

    d = Distributions.Categorical([λ/s, μ/s, η/s])
    events = instances(Event)
    r = rand(d)

    ev = events[r]

    return(ev)
end


function type_of_event(
    model::BirthDeathShiftContinuous, 
    λ::Float64,
    μ::Float64,
)
    α = model.α
    β = model.β

    s = λ + μ + α + β ## s for sum
    freqs = [λ, μ, α, β] ./ s
    
    d = Distributions.Categorical(freqs)
    events = instances(Event)
    r = rand(d)

    ev = events[r]

    return(ev)
end

function type_of_event(
    model::BirthDeathShift, 
    λ::Float64,
    μ::Float64,
    η::Float64,
)
    η = model.η

    s = λ + μ + η ## s for sum
    freqs = [λ, μ, η] ./ s
    
    d = Distributions.Categorical(freqs)
    events = instances(Event)
    r = rand(d)

    ev = events[r]

    return(ev)
end