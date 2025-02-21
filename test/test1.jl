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
    0.05,
    0.01,
)

using Random
Random.seed!(124); tree = simulate(model, 0.2, 0.1, 40.0, 100_000)

tree = simulate(model, 0.3, 0.2, 40.0, 100_000)

tr = reconstruct(tree)

number_of_events(tree)
number_of_events(tr)

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



λ = [0.1, 0.2]
μ = [0.0, 0.0]
η = 0.2

model = BirthDeathShift(λ, μ, η)


state = 1
maxtips = 100
maxtime = 5.0

X = zeros(2,2)

trees = Root[]

for _ in 1:700_000
    starting_state = rand([1, 2])
    tree = simulate(model, maxtime, maxtips; starting_state = starting_state, start = :origin)
    push!(trees, tree)
end

for (i, tree) in enumerate(trees)
    ntaxa = number_of_taxa(tree)
    if ntaxa == 1
        j = findall(model.λ .== tree.children[1].λ[1])[1]
        i = findall(model.λ .== tree.children[1].λ[end])[1]
       
        X[i,j] += 1
    end
end


X

P = X ./ (ones(2) * sum(X, dims = 2)')

P_theoretical


## theoretical 
function one_hot_vector(K::Int64, i::Int64)
    u = zeros(K)
    u[i] = 1.0
    return(u)
end

function backward_ode(
    du::Matrix{T}, 
    u::Matrix{T}, 
    p, 
    t::Float64
) where {T <: Real}

    model, K = p
    E, D = eachcol(u)
    sumE = sum(E)
    sumD = sum(D)

    λ = model.λ
    μ = model.μ
    η = model.η

    r = η / (K-1)

    for i in axes(du, 1)
        du[i,1] = μ[i] -(λ[i]+μ[i]+η)*u[i,1] + λ[i]*u[i,1]*u[i,1] + r*(sumE-u[i,1]) 
        du[i,2] = -(λ[i]+μ[i]+η)*u[i,2] + 2*λ[i]*u[i,2]*u[i,1] + r*(sumD-u[i,2])
    end

    nothing
end

function extinction_ode(dE, E, p, t)
    model, K = p
    λ = model.λ
    μ = model.μ
    η = model.η

    sumE = sum(E)

    for i in 1:K
        dE[i] = μ[i] - (λ[i] + μ[i] + η) * E[i] + λ[i] * E[i] * E[i] + (η/(K-1)) * (sumE - E[i]) 
    end
    nothing
end

function extinction_probability(model, sampling_probability::Float64, time::Float64)
    alg = OrdinaryDiffEq.Tsit5()
    K = length(model.λ)
    p = (model, K)

    tspan = (0.0, time)

    E0 = repeat([1.0 - sampling_probability], K)
    
    pr = OrdinaryDiffEq.ODEProblem{true}(extinction_ode, E0, tspan, p);
    
    ## use low tolerance because we only solve E once, so we can afford it
    sol = OrdinaryDiffEq.solve(pr, alg, abstol = 1e-10, reltol = 1e-10, save_everystep = false)#, isoutofdomain = ispositive)
    E = sol.u[end] 
    return(E)
end

function transition_probability_matrix(model, t0::Float64, t1::Float64)
    K = length(model.λ)
    P = zeros(K,K)
    tspan = (t0, t1)
    params = (model, K)
    Et = extinction_probability(model, 1.0, t0)

    for initial_category in 1:K
        u0 = zeros(K,2)
        u0[:,1] = Et
        u0[:,2] = one_hot_vector(K, initial_category)
        ode = backward_ode

        prob = OrdinaryDiffEq.ODEProblem{true}(ode, u0, tspan, params)
        sol = OrdinaryDiffEq.solve(prob, OrdinaryDiffEq.Tsit5(), save_everystep = true, reltol = 1e-12)
        p = sol.u[end][:,2] 
        P[initial_category,:] = p
    end
    #P = normalize(P)
    #rsum = sum(P, dims = 2) * ones(K)'
    #P = P ./ rsum

    return(P)
end

P_theoretical = transition_probability_matrix(model, 0.0, 5.0)
P_theoretical = P_theoretical ./ (ones(2) * sum(P_theoretical, dims = 2)')

P

using OrdinaryDiffEq