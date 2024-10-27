
export simulate

function simulate(
    model::BirthDeathConstant, 
    maxtime::Float64, 
    maxtips::Int64
    )
     
    root = Root()

    n_tips = [0]
    time = 0.0   

    for _ in 1:2
        branch = Branch(root)
        simulate!(model, branch, time, maxtime, maxtips, n_tips)
    end

    return(root)    
end


function simulate!(
    model::BirthDeathConstant, 
    branch::Branch,
    time::Float64,
    maxtime::Float64,
    maxtips::Int64,
    n_tips::Vector{Int64},
    )

    if n_tips[1] > maxtips
        error("too many tips")
    end


    λ = model.λ
    μ = model.μ
    state = 1
    
    d = Distributions.Exponential(1/(λ + μ))
    r = rand(d)

    

    is_tip = (time+r) > maxtime

    if is_tip
        #excess = (time+r) - maxtime
        #r = r - excess
        r = maxtime - time
    end

    push!(branch.states, state)
    push!(branch.times, r)

    time += r

    if is_tip
        #r = maxtime - time

        ExtantTip(branch, "tip")
        n_tips[1] += 1
    else
        #time += r 

        event = type_of_event(λ,μ)

            
        if event == Speciation
            n1 = Node(branch)

            for _ in 1:2
                b = Branch(n1)

                simulate!(model, b, time, maxtime, maxtips, n_tips)
            end
        elseif event == Extinction
            ExtinctionEvent(branch, "extinction") 
        else
            error("something went wrong")
        end

    end
    nothing
end


