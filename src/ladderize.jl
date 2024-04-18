export ladderize!

function ladderize!(node::Root)
    left_branch = node.left
    right_branch = node.right

    left_node = left_branch.outbounds
    right_node = right_branch.outbounds

    n_left = number_of_taxa(left_node)
    n_right = number_of_taxa(right_node)

    if n_right > n_left
        ## swap left and right
        node.right = left_branch
        node.left = right_branch
    end

    ladderize!(left_node)
    ladderize!(right_node)

    reindex!(node)
end

function ladderize!(node::InternalNode)
    left_branch = node.left
    right_branch = node.right

    left_node = left_branch.outbounds
    right_node = right_branch.outbounds

    n_left = number_of_taxa(left_node)
    n_right = number_of_taxa(right_node)

    if n_right > n_left
        println("asd")
        ## swap left and right
        node.right = left_branch
        node.left = right_branch
    end

    ladderize!(left_node)
    ladderize!(right_node)
end

function ladderize!(tip::T) where {T <: TipNode} end