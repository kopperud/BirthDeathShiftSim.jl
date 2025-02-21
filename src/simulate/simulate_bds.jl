
export simulate

function simulate(
    model::BirthDeathShift, 
    maxtime::Float64, 
    maxtips::Int64;
    starting_state::Int64 = 1,
    start = :mrca,
    )
     
    root = Root()

    n_tips = [0]
    time = 0.0   
    state = copy(starting_state)

    if start == :mrca
        for _ in 1:2
            branch = Branch(root)
            simulate!(model, branch, state, time, maxtime, maxtips, n_tips)
        end
    elseif start == :origin
        branch = Branch(root)
        simulate!(model, branch, state, time, maxtime, maxtips, n_tips)
    end

    return(root)    
end

@enum EventBDS Birth Death RateShift

function simulate!(
    model::BirthDeathShift, 
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

    λ = model.λ[state]
    μ = model.μ[state]
    η = model.η
    
    d = Distributions.Exponential(1/(λ + μ + η))
    r = rand(d)
    #push!(branch.states, state)
    push!(branch.λ, λ)
    push!(branch.μ, μ)



    if (time+r) > maxtime
        r = maxtime - time
        push!(branch.times, r)

        ExtantTip(branch, "tip")
        n_tips[1] += 1
    else
        push!(branch.times, r)

        time += r 

        η = model.η

        s = λ + μ + η ## s for sum
        freqs = [λ, μ, η] ./ s
        
        d = Distributions.Categorical(freqs)
        events = instances(EventBDS)
        r = rand(d)

        event = events[r]

        if event == Birth
            n1 = Node(branch)

            for _ in 1:2
                b = Branch(n1)

                simulate!(model, b, state, time, maxtime, maxtips, n_tips)
            end
        elseif event == RateShift
            p_new_category = ones(length(model.λ))
            p_new_category[state] = 0
            p_new_category = p_new_category / sum(p_new_category)

            new_category = rand(Distributions.Categorical(p_new_category))
            #println("new category: $new_category")
            
            simulate!(model, branch, new_category, time, maxtime, maxtips, n_tips)
        elseif event == Death
            ExtinctionEvent(branch, "") 
        else
            error("something went wrong")
        end

    end
    nothing
end


