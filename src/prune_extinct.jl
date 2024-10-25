## prune extinct

#= function prune_extinct!(node::Root)
    left_branch = node.left
    left_node = left_branch.outbounds

    right_branch = node.right
    right_node = right_branch.outbounds   

    if left_node isa ExtinctionEvent
        new_root = Root()
    end
end =#

export is_completely_extinct

function is_completely_extinct(node::T) where {T <: InternalNode}
    n = number_of_taxa(node)

    if n == 0
        is_extinct = true
    else
        is_extinct = false
    end

    return(is_extinct)
end

function is_completely_extinct(tip::ExtinctionEvent)
    return(true)
end

function is_completely_extinct(tip::ExtantTip)
    return(false)
end

export prune_extinct!

function prune_extinct!(root::Root)
    left_branch = root.left
    right_branch = root.right

    left_node = left_branch.outbounds
    right_node = right_branch.outbounds

    isextinct = is_completely_extinct(root)
    if isextinct
        error("tree is extinct, can't prune")
    end

    left_extinct = is_completely_extinct(left_node)
    right_extinct = is_completely_extinct(right_node)

    if !left_extinct
        prune_extinct!(left_node)
    else
        new_root = Root()
        #new_root.left = 
    end

    if !right_extinct
        prune_extinct!(right_node)
    end

    reindex!(root)
end


## @TODO: finish this
function prune_extinct!(node::Node)
    left_branch = node.left
    left_node = left_branch.outbounds

    right_branch = node.right
    right_node = right_branch.outbounds    

    prune_extinct!(left_node)
    prune_extinct!(right_node)

    left_branch = node.left
    left_node = left_branch.outbounds

    right_branch = node.right
    right_node = right_branch.outbounds    

    one_extinct = xor(left_node isa ExtinctionEvent, right_node isa ExtinctionEvent)
    both_extinct = (left_node isa ExtinctionEvent) & (right_node isa ExtinctionEvent)

    if one_extinct
        if left_node isa ExtinctionEvent
            println("merging parent and right branch")
            parent_branch = node.inbounds    
            append!(parent_branch.states, right_branch.states)
            append!(parent_branch.times, right_branch.times)
            parent_branch.outbounds = right_node
            right_node.inbounds = parent_branch
        end

        if right_node isa ExtinctionEvent
            println("merging parent and left branch")
            parent_branch = node.inbounds
            append!(parent_branch.states, left_branch.states)
            append!(parent_branch.times, left_branch.times)
            parent_branch.outbounds = left_node
            left_node.inbounds = parent_branch
        end
    elseif both_extinct
        println("both children extinct")
        parent_branch = node.inbounds
        new_fake_extinction_event = ExtinctionEvent()
        parent_branch.outbounds = new_fake_extinction_event
        new_fake_extinction_event.inbounds = parent_branch
        new_fake_extinction_event.label = "fake"      
    end
end

function prune_extinct!(node::ExtinctionEvent) end
function prune_extinct!(node::ExtantTip) end







