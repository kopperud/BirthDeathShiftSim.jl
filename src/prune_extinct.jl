## prune extinct

function prune_extinct!(tip::ExtinctionEvent)
    return(true)
end

function prune_extinct!(tip::ExtantTip)
    return(false)
end

function prune_extinct!(branch::Branch)
    is_extinct = prune_extinct!(branch.outbounds) 
    return(is_extinct)
end

function prune_extinct!(node::T) where {T <: BranchingEvent}
    new_children = Branch[]
    is_extinct = Bool[]

    #i = 1
    while length(node.children) > 0
        branch = pop!(node.children)

        branch_is_extinct = prune_extinct!(branch)
        push!(is_extinct, branch_is_extinct)

        if !branch_is_extinct
            push!(new_children, branch)
        end
        #i += 1
    end 
    
    node.children = new_children

    return(all(is_extinct))
end

function number_of_children(node::T) where {T <: TipNode}
    return(0)
end

function number_of_children(node::N) where {N <: BranchingEvent}
    return(length(node.children))
end

function number_of_children(node::AncestralSample)
    return(-1)
end

function merge_branches!(node::AncestralSample)
    merge_branches!(node.outbounds)
    nothing
end

export merge_branches!

function merge_branches!(node::ExtinctionEvent)
    error("did not expect to find an extinction event")
end

function merge_branches!(node::ExtantTip)
end



    #=
function merge_branches!(node::Node, parent_branch::Branch)
    n_children = length(node.children)

    if n_children == 1
        this_branch = node.children[1]

        parent_branch.times[end] += this_branch.times[1] 
        
        this_branch_episodes = length(this_branch.times)
        if this_branch_episodes > 2
            for i in 2:this_branch_episodes
                push!(parent_branch.times, this_branch.times[i])
                push!(parent_branch.λ, this_branch.λ[i])
                push!(parent_branch.μ, this_branch.μ[i])
            end
        end
        parent_branch.outbounds = this_branch.outbounds
        merge_branches!(parent_branch.outbounds, parent_branch)

    elseif n_children > 1
        ## dont merge anything, keep going
        for branch in node.children
            merge_branches!(branch, parent_branch)
        end
    else
        error("error")        
    end

    nothing
end
=#

function merge_branches!(root::Root)
    for branch in root.children
        merge_branches!(branch)
    end
end

function merge_branches!(branch::Branch)
    ## the number of offspring for the immediate descendant node
    n_children = number_of_children(branch.outbounds)

    if n_children == 1
        ## merge this and descendant branch
        child_branch = branch.outbounds.children[1]

        branch.times[end] += child_branch.times[1]  

        if length(child_branch.times) > 2
            for i in 2:length(child_branch.times)
                push!(branch.λ, child_branch.λ[i])
                push!(branch.μ, child_branch.μ[i])
            end
        end
        branch.outbounds = child_branch.outbounds
        merge_branches!(branch)

    elseif n_children == -1
        ## knuckle, proceed without merge
        merge_branches!(branch.outbounds)
    elseif n_children > 1
        child_node = branch.outbounds
        for child_branch in child_node.children
            merge_branches!(child_branch)
        end
    end
end

#=
function prune_extinct!(node::Root)
    prune_extinct!(node)
    
end
=#

export reconstruct

function reconstruct(root::Root)
    tree = deepcopy(root)

    prune_extinct!(tree)
    merge_branches!(tree)

    # re-assign root if necessary
    if length(tree.children) == 1 
        new_root = Root()

        child_branch = pop!(tree.children) 

        if child_branch.outbounds isa BranchingEvent 
            child_node = child_branch.outbounds

            for branch in child_node.children
                push!(new_root.children, branch)
            end
        else
            error("can not re-assign root if there is only no or only one extant or sampled tip")
        end

        return(new_root)
    else
        return(tree)
    end
end