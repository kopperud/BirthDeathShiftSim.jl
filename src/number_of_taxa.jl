#######################################
##
## number of extant taxa
##
#######################################
export number_of_taxa

function number_of_taxa(root::T) where {T <: BranchingEvent}
    species_counter = SpeciesCounter()

    number_of_taxa_po!(root, species_counter)

    n = species_counter.count
    return(n)
end

function number_of_taxa(root::ExtinctionEvent)
    n = 0
    return(n)
end

function number_of_taxa(root::ExtantTip)
    n = 1
    return(n)
end

function number_of_taxa_po!(node::T, species_counter) where {T <: BranchingEvent}

    for branch in node.children
        number_of_taxa_po!(branch.outbounds, species_counter)
    end
end

function number_of_taxa_po!(node::ExtinctionEvent, species_counter)
end

function number_of_taxa_po!(node::ExtantTip, species_counter)
    increment!(species_counter)
end

#######################################
##
## number of extinction events
##
#######################################
export number_of_extinctions

function number_of_extinctions(root::T) where {T <: BranchingEvent}
    counter = ExtinctionCounter()

    number_of_extinctions!(root, counter)

    n = counter.count
    return(n)
end

function number_of_extinctions(root::ExtinctionEvent)
    n = 1
    return(n)
end

function number_of_extinctions(root::ExtantTip)
    n = 0
    return(n)
end

function number_of_extinctions!(node::T, counter) where {T <: BranchingEvent}
    
    for branch in node.children
        number_of_extinctions!(branch.outbounds, counter)
    end
end

function number_of_extinctions!(node::ExtinctionEvent, counter)
    increment!(counter)
end

function number_of_extinctions!(node::ExtantTip, counter)
end



#######################################
##
## number of edges
##
#######################################
export number_of_edges

function number_of_edges(tree::Root)
    counter = [0]

    number_of_edges!(tree, counter)
    return(counter[1])
end

function number_of_edges!(node::N, counter::Vector{Int64}) where {N <: BranchingEvent} 
    for branch in node.children
        number_of_edges!(branch, counter)
    end
end

function number_of_edges!(branch::Branch, counter::Vector{Int64})
    counter[1] += 1
    number_of_edges!(branch.outbounds, counter)
end

function number_of_edges!(node::T, counter::Vector{Int64}) where {T <: TipNode}
end


export number_of_nodes

## number of nodes
function number_of_nodes(tree::Root)
    n = 0
    n = nnodes_po(tree, n)
    return(n)
end

function nnodes_po(::TipNode, n::Int64)
    return(n+1)
end

function nnodes_po(node::T, n::Int64) where {T <: InternalNode}
    n = nnodes_po(node.left.outbounds, n)
    n = nnodes_po(node.right.outbounds, n)
    return(n+1)
end
