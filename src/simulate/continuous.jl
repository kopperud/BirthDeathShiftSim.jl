
export simulate

function simulate(
    model::BirthDeathShiftContinuous,
    λ::Float64, ## starting speciation rate
    μ::Float64, ## starting extinction rate
    maxtime::Float64, 
    maxtips::Int64
    )
     
    root = Root()

    n_tips = [0]
    time = 0.0   

    for _ in 1:2
        branch = Branch(root)
        simulate!(model, branch, time, λ, μ, maxtime, maxtips, n_tips)
    end

    return(root)    
end


function simulate!(
    model::BirthDeathShiftContinuous, 
    branch::Branch,
    time::Float64,
    λ::Float64,
    μ::Float64,
    maxtime::Float64,
    maxtips::Int64,
    n_tips::Vector{Int64},
    )

    if n_tips[1] > maxtips
        error("too many tips")
    end

    α = model.α
    β = model.β
   
    rate = λ + μ + α + β
    scale = 1.0 / rate 
    d = Distributions.Exponential(scale)
    r = rand(d)
    

    is_tip = (time+r) > maxtime

    if is_tip
        r = maxtime - time
    end


    push!(branch.λ, λ)
    push!(branch.μ, μ)
    push!(branch.times, r)

    time += r

    if is_tip

        ExtantTip(branch, "tip")
        n_tips[1] += 1
    else
        event = type_of_event(model, λ, μ)
            
        if event == Speciation
            n1 = Node(branch)

            for _ in 1:2
                b = Branch(n1)

                simulate!(model, b, time, λ, μ, maxtime, maxtips, n_tips)
            end
        elseif event == Extinction
            ExtinctionEvent(branch, "extinction") 
        elseif event == SpeciationShift
            #d = Distributions.LogNormal(model.α, model.σ)
            λ1 = rand(model.dλ)

            simulate!(model, branch, time, λ1, μ, maxtime, maxtips, n_tips)
        elseif event == ExtinctionShift
            μ1 = rand(model.dμ)

            simulate!(model, branch, time, λ, μ1, maxtime, maxtips, n_tips)
        else
            error("something went wrong")
        end

    end
    nothing
end


