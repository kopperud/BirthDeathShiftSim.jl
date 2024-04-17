export Root, Node, ExtinctionEvent, Species
export Branch, Branch_left, Branch_right

abstract type AbstractNode 
end

abstract type InternalNode <: AbstractNode
end

mutable struct Branch
    states::Vector{Int64}
    times::Vector{Float64}
    inbounds::InternalNode
    outbounds::AbstractNode

    Branch() = new()
end

function Branch_left(
    node::InternalNode, 
    states::Vector{Int64},
    times::Vector{Float64})

    branch = Branch()
    branch.inbounds = node
    branch.times = times
    branch.states = states

    node.left = branch
    return(branch)
end

function Branch_right(
    node::InternalNode, 
    states::Vector{Int64},
    times::Vector{Float64})

    branch = Branch()
    branch.inbounds = node
    branch.times = times
    branch.states = states

    node.right = branch
    return(branch)
end


abstract type TipNode <: AbstractNode
end

mutable struct Root <: InternalNode
    left::Branch
    right::Branch

    Root() = new()
end

mutable struct Node <: InternalNode
    inbounds::Branch
    left::Branch
    right::Branch

    Node() = new()
end

function Node(branch::Branch)
    node = Node()
    node.inbounds = branch
    branch.outbounds = node
    return(node)
end

mutable struct ExtinctionEvent <: TipNode
    inbounds::Branch
    label::String

    ExtinctionEvent() = new()
end

function ExtinctionEvent(branch::Branch, label::String)
    ext_event = ExtinctionEvent()
    ext_event.inbounds = branch
    ext_event.label = label
    branch.outbounds = ext_event
    return(ext_event)
end

mutable struct Species <: TipNode
    inbounds::Branch
    label::String

    Species() = new()
end

function Species(branch::Branch, label::String)
    sp = Species()
    sp.inbounds = branch
    sp.label = label
    branch.outbounds = sp
    return(sp)
end






