using Revise
using BirthDeathShiftSim

time_limit = 15.0
taxa_limit = 10000
λ = 0.3
μ = 0.2

model = BirthDeathConstant(λ, μ)
root = simulate(model, time_limit, taxa_limit); reindex!(root)
BirthDeathShiftSim.treeplot(root)


root.index

number_of_taxa(root)
#number_of_edges(root) 


using CairoMakie






import Distributions

taxa_limit = 1000

trees = Root[]
@showprogress for i in 1:50_000
    root = simulate(model, time_limit, taxa_limit)
    push!(trees, root)
end

ntaxa = [number_of_taxa(root) for root in trees]
not_zero = ntaxa[ntaxa .!= 0]

hist(not_zero, bins = 100)


using ProgressMeter


@benchmark simulate(model, time_limit, taxa_limit)







rand(wait_distribution)





