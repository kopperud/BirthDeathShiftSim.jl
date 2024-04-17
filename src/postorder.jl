export postorder

function postorder(node::T) where {T <: InternalNode}
    left = node.left.outbounds
    right = node.right.outbounds

    postorder(left)
    postorder(right)
end

function postorder(node::T) where {T <: TipNode}
    println(node.label)
end