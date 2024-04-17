## prune extinct

function prune_extinct!(node::Root)
    left_branch = node.left
    left_node = left_branch.outbounds

    right_branch = node.right
    right_node = right_branch.outbounds   

    if left_node isa ExtinctionEvent
        new_root = Root()
    end
end

function prune_extinct!(node::InternalNode)
    left_branch = node.left
    left_node = left_branch.outbounds

    right_branch = node.right
    right_node = right_branch.outbounds    

    if left_node isa ExtinctionEvent
        parent_branch = node.inbounds
        parent_node = parent_branch.inbounds

        new_branch = Branch()
        new_branch.inbounds = parent_node
        new_branch.outbounds = right_node
        new_branch.states = vcat(parent_branch.states, right_branch.states)
        new_branch.times = vcat(parent_branch.times, right_branch.states)
    else   
        prune_extinct!(left_node)
    end

    if right_node isa ExtinctionEvent
        parent_branch = node.inbounds
        parent_node = parent_branch.inbounds

        new_branch = Branch()
        new_branch.inbounds = parent_node
        new_branch.outbounds = left_node
        new_branch.states = vcat(parent_branch.states, left_branch.states)
        new_branch.times = vcat(parent_branch.times, left_branch.states)
    else   
        prune_extinct!(right_node)
    end    
end

function prune_extinct!(node::Species) end







