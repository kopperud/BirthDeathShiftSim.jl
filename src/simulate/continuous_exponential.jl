
export simulate

function simulate(
    model::BirthDeathSpeciationExponential, 
    λ::Float64, ## starting speciation rate
    maxtime::Float64, 
    maxtips::Int64
    )
     
    root = Root()

    n_tips = [0]
    time = 0.0   

    for _ in 1:2
        branch = Branch(root)
        simulate!(model, branch, time, λ, maxtime, maxtips, n_tips)
    end

    return(root)    
end


function simulate!(
    model::BirthDeathSpeciationExponential, 
    branch::Branch,
    time::Float64,
    λ::Float64,
    maxtime::Float64,
    maxtips::Int64,
    n_tips::Vector{Int64},
    )

    if n_tips[1] > maxtips
        error("too many tips")
    end


    μ = model.μ
    η = model.η
   
    rate = λ + μ + η
    scale = 1.0 / rate 
    d = Distributions.Exponential(scale)
    r = rand(d)
    
    #d = Distributions.Exponential((1/λ) + (1/μ) + (1/η))
    #d = Distributions.Exponential(λ + μ + η)
    #r = 1/rand(d)

    is_tip = (time+r) > maxtime

    if is_tip
        r = maxtime - time
    end

    push!(branch.states, 1)
    push!(branch.states_rate, λ)
    push!(branch.times, r)

    time += r

    if is_tip

        ExtantTip(branch, "tip")
        n_tips[1] += 1
    else
        event = type_of_event(model, λ)
            
        if event == Speciation
            n1 = Node(branch)

            for _ in 1:2
                b = Branch(n1)

                simulate!(model, b, time, λ, maxtime, maxtips, n_tips)
            end
        elseif event == Extinction
            ExtinctionEvent(branch, "extinction") 
        elseif event == SpeciationShift
            d = Distributions.Exponential(model.λmean)
            λ1 = rand(d)

            simulate!(model, branch, time, λ1, maxtime, maxtips, n_tips)
            #println("missing code here")

        else
            error("something went wrong")
        end

    end
    nothing
end


