using Revise
using Random
using BirthDeathShiftSim
using Distributions

λ = 1.0
μ = 1.0

model = BirthDeathConstant(λ, μ)





using BenchmarkTools

model = BirthDeathConstant(0.30, 0.22)

using StatsPlots
using ProgressMeter

n = Int64[]
@showprogress for _ in 1:10_000
    r = simulate(model, 65.0, 10001)
    nt_left = number_of_taxa(r.children[1].outbounds)
    nt_right = number_of_taxa(r.children[2].outbounds)
    if (nt_left > 0) & (nt_right > 0)
        push!(n, number_of_taxa(r))
    end
end

median(n .* 0.62)
mean(n .* 0.62)
histogram(n)

number_of_taxa(r.children[1].outbounds)
number_of_taxa(r.children[2].outbounds)

model = BirthDeathConstant(0.30, 0.23)
Random.seed!(123); r = simulate(model, 20.0, 1_000_000)
r = simulate(model, 65.0, 10_000)

treeheight(r)

number_of_taxa(r.children[1].outbounds)
number_of_taxa(r.children[2].outbounds)

@benchmark number_of_taxa(r)

newick(r)

histogram(n)

function baz()
    r = 1.05

    if r > 1.0
        r = 1.0
    end

    return(r)
end

baz()
