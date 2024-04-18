export number_of_taxa

function number_of_taxa(root::T) where {T <: InternalNode}
    species_counter = SpeciesCounter()

    number_of_taxa_po!(root, species_counter)

    n = species_counter.count
    return(n)
end

function number_of_taxa(root::ExtinctionEvent)
    n = 0
    return(n)
end

function number_of_taxa(root::Species)
    n = 1
    return(n)
end

function number_of_taxa_po!(root::InternalNode, species_counter)
    left_node = root.left.outbounds
    right_node = root.right.outbounds

    number_of_taxa_po!(left_node, species_counter)
    number_of_taxa_po!(right_node, species_counter)
end

function number_of_taxa_po!(node::ExtinctionEvent, species_counter)
end

function number_of_taxa_po!(node::Species, species_counter)
    increment!(species_counter)
end

export number_of_edges

function number_of_edges(tree::Root)
    n = 0
    n = nedges_po(tree, n)
    return(n)
end

function nedges_po(::TipNode,n::Int64) 
    return(n)
end

function nedges_po(node::T, n::Int64) where {T <: InternalNode}
    n = nedges_po(node.left.outbounds, n)
    n = nedges_po(node.right.outbounds, n)
    return(n+2)
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
