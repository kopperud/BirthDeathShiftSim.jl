export Branch 

export Root, Node
export AncestralSample, TerminalSample

export ExtinctionEvent, ExtantTip

#####################################
##
##   abstract types 
##
#####################################

abstract type AbstractNode end

abstract type InternalNode <: AbstractNode end
abstract type BranchingEvent <: InternalNode end

#####################################
##
##   concrete types 
##
#####################################
mutable struct Branch
    states::Vector{Int64}
    times::Vector{Float64}

    outbounds::AbstractNode

    Branch() = new()
end

mutable struct AncestralSample <: InternalNode
    outbounds::Branch

    AncestralSample() = new()
end

abstract type TipNode <: AbstractNode end


mutable struct Root <: BranchingEvent
    children::Vector{Branch}

end

mutable struct Node <: BranchingEvent
    children::Vector{Branch}
end

mutable struct ExtinctionEvent <: TipNode
    label::String
    
    ExtinctionEvent() = new()
end

mutable struct TerminalSample <: TipNode
    label::String

    TerminalSample() = new()
end

mutable struct ExtantTip <: TipNode
    label::String

    ExtantTip() = new()
end



#####################################
##
##   constructors 
##
#####################################

function Root()
    v = Branch[]

    r = Root(v)
    return(r)
end

function Branch(
    node::T,
    #states::Vector{Int64},
    #times::Vector{Float64},
) where {T <: BranchingEvent}
    branch = Branch()

    branch.states = Int64[]
    branch.times = Float64[]
    push!(node.children, branch)

    return(branch)
end

function Branch(
    knuckle::AncestralSample,
    #states::Vector{Int64},
    #times::Vector{Float64},
)
    branch = Branch()

    branch.states = Int64[]
    branch.times = Float64[]
    knuckle.outbounds = branch

    return(branch)
end

function Node(branch::Branch)
    v = Branch[]
    node = Node(v)
    branch.outbounds = node
    return(node)
end

function ExtinctionEvent(branch::Branch, label::String)
    ext_event = ExtinctionEvent()
    ext_event.label = label
    branch.outbounds = ext_event

    return(ext_event)
end

function ExtantTip(branch::Branch, label::String)
    sp = ExtantTip()
    sp.label = label
    branch.outbounds = sp
    return(sp)
end

function AncestralSample(
    branch::Branch
    )
    as = AncestralSample()
    branch.outbounds = as

    return(as)
end


function TerminalSample(branch::Branch, label::String)
    ts = TerminalSample()

    branch.outbounds = ts
    ts.label = label

    return(ts)
end






