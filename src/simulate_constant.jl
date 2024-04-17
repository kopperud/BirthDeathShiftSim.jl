
export simulate

function simulate(model::BirthDeathConstant, time_limit = 10.0, taxa_limit = 100)
    t = 0.0
    species_counter = SpeciesCounter()
    extinction_counter = ExtinctionCounter()

    root = Root()
    branch_left = Branch()
    branch_left.inbounds = root
    root.left = branch_left
    simulate_branch!(branch_left, model, time_limit, taxa_limit, t, species_counter, extinction_counter)
    
    branch_right = Branch()
    branch_right.inbounds = root
    root.right = branch_right
    simulate_branch!(branch_right, model, time_limit, taxa_limit, t, species_counter, extinction_counter)

    return(root)
end

function simulate_branch!(branch, model, time_limit, taxa_limit, t, species_counter, extinction_counter)
    θ = 1/(model.μ + model.λ)
    wait_distribution = Distributions.Exponential(θ)
    waiting_time = rand(wait_distribution)

    r = rand()
    println(t)

    if species_counter.count > taxa_limit
        error("too many taxa")
    end

    if (waiting_time + t) > time_limit
        time = time_limit - t
        branch.times = [time]
        branch.states = [1]

        label = string("Species ", species_counter.count)
        Species(branch, label)
        increment!(species_counter)
        println(species_counter.count)
    else

        if (model.μ / (model.μ + model.λ)) > r
            branch.states = [1]
            branch.times = [waiting_time]

            label = string("Extinction ", extinction_counter.count)
            ExtinctionEvent(branch, label)
            increment!(extinction_counter)
        else
            branch.states = [1]
            branch.times = [waiting_time]

            node = Node(branch)
            left_child = Branch()
            left_child.inbounds = node
            node.left = left_child

            right_child = Branch()
            right_child.inbounds = node
            node.right = right_child

            t += waiting_time
            simulate_branch!(left_child, model, time_limit, taxa_limit, t, species_counter, extinction_counter)
            simulate_branch!(right_child, model, time_limit, taxa_limit, t, species_counter, extinction_counter)
        end
    end
end