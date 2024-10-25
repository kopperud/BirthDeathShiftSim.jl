@enum Event Speciation Extinction


function type_of_event(λ, μ)
    s = λ + μ
    d = Distributions.Categorical([λ/s, μ/s])
    inst = instances(Event)
    r = rand(d)

    ev = inst[r]

    return(ev)
end

function type_of_event(
    model::BirthDeathConstant
)
    λ = model.λ
    μ = model.μ

    s = λ + μ

    d = Distributions.Categorical([λ/s, μ/s])
    events = Events(model)
    r = rand(d)

    ev = events[r]

    return(ev)
end