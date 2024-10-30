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


dλ = LogNormal(log(0.3), 0.1)
dμ = LogNormal(log(0.2), 0.1)

model = BirthDeathShiftContinuous(
    dλ,
    dμ,
    0.01,
    0.01,
)

using Random
Random.seed!(124); tree = simulate(model, 0.2, 0.1, 40.0, 100_000)

tree = simulate(model, 0.2, 0.1, 40.0, 100_000)

tr = reconstruct(tree)



number_of_events(tree)

number_of_events(tr)

treeheight(tree)
treeheight(tr)

newick(tr)

tr.children

prune_extinct!(tree)
merge_branches!(tree)

tree

tree


root = Root()

bl = Branch(root)
ex = ExtinctionEvent(bl, "extinct")

br = Branch(root)
tip = ExtantTip(br, "homo sapiens")

root

prune_extinct!(root)

reconstruct(root)




tree

number_of_edges(tree)
merge_branches!(tree)

tree

number_of_events(tree) / treelength(tree)



et = ExtantTip()

