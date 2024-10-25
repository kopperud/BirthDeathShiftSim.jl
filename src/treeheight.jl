export treeheight

function treeheight(node::T) where {T <: BranchingEvent}
    h = maximum(map(treeheight, node.children))
end

function treeheight(branch::Branch)
    treeheight(branch.outbounds) + sum(branch.times)
end

function treeheight(terminal::T) where {T <: TipNode}
    0.0
end