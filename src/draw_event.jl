@enum Event Speciation Extinction SpeciationShift
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