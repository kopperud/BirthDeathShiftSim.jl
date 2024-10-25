export newick

function newick(node::T) where {T <: BranchingEvent}
    tokens = String[]

    #push!(tokens, "(") 

    newick!(node, tokens)

    push!(tokens, ";")

    join(tokens)
end

function newick!(node::T, tokens::Vector{String}) where {T <: BranchingEvent}
    push!(tokens, "(")

    n_branches = length(node.children)
    for (i, branch) in enumerate(node.children)
        newick!(branch, tokens)
        if i < n_branches
            push!(tokens, ",")
        end
    end
    push!(tokens, ")")
end

function newick!(branch::Branch, tokens::Vector{String}) 
    newick!(branch.outbounds, tokens)
    push!(tokens, ":")
    push!(tokens, string(sum(branch.times)))
end

function newick!(tip::T, tokens::Vector{String}) where {T <: TipNode}
    push!(tokens, tip.label)
end