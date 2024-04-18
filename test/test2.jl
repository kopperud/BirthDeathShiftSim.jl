using Revise
using BirthDeathShiftSim

time_limit = 15.0
taxa_limit = 10000
λ = 0.3
μ = 0.2

using Random
model = BirthDeathConstant(λ, μ)
Random.seed!(12356)
root = simulate(model, time_limit, taxa_limit); reindex!(root)
BirthDeathShiftSim.treeplot(root)

prune_extinct!(root); treeplot(root)

ladderize!(root); BirthDeathShiftSim.treeplot(root)


# animation settings
nframes = 180
framerate = 10
#hue_iterator = range(0, 360, length=nframes)
present_iterator = range(5, -0.5, length = nframes)

record(fig, "/home/bkopper/color_animation.mp4", present_iterator;
        framerate = framerate) do present
    #lineplot.color = HSV(hue, 1, 0.75)
    xlims!(fig.content[1], 15.3, present)
end

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





