export tipstates

function tipstates(tree::Root)
    data = Dict{String,Int64}()

    ts_postorder!(tree, data)
    return(data)
end

function ts_postorder!(
    node::InternalNode, 
    data::Dict{String,Int64}
    ) #where {T1 <: InternalNode}
    left_branch = node.left
    right_branch = node.right

    left_node = left_branch.outbounds
    right_node = right_branch.outbounds

    ts_postorder!(left_node, data)
    ts_postorder!(right_node, data)
end

function ts_postorder!(
    node::TipNode, 
    data::Dict{String,Int64}
    ) #where {T2 <: TipNode}
    label = node.label
    parent_branch = node.inbounds
    most_recent_state = parent_branch.states[1]

    data[label] = most_recent_state
end