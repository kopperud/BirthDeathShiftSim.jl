
export simulate

function simulate(
    model::BirthDeathShift, 
    maxtime::Float64, 
    maxtips::Int64;
    starting_state::Int64 = 1,
    )
     
    root = Root()

    n_tips = [0]
    maxtime = 10.0
    time = 0.0   

    for _ in 1:2
        branch = Branch(root)
        simulate!(model, branch, state, time, maxtime, maxtips, n_tips)
    end

    return(root)    
end


function simulate!(
    model::BirthDeathConstant, 
    branch::Branch,
    state::Int64,
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
    
    d = Exponential(1/(λ + μ))
    r = rand(d)
    push!(branch.states, state)
    push!(branch.times, r)


    if (time+r) > maxtime
        r = maxtime - time

        ExtantTip(branch, "tip")
        n_tips[1] += 1
    else
        time += r 

        event = type_of_event(λ,μ,η)

            
        if event == Speciation
            n1 = Node(branch)

            for _ in 1:2
                b = Branch(n1)

                simulate!(model, b, time, maxtime, maxtips, n_tips)
            end
        elseif event == Extinction
            ExtinctionEvent(branch, "") 
        else
            error("something went wrong")
        end

    end
    nothing
end


