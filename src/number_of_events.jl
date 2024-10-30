
#function number_of_events()


#######################################
##
## number of rate shift events 
##
#######################################
export number_of_events

function number_of_events(node::N) where {N <: TipNode}
    n = 0
    return(n)
end

function number_of_events(root::T) where {T <: BranchingEvent}
    counter = [0]

    number_of_events!(root, counter)

    #n = species_counter.count
    n = counter[1]
    return(n)
end
function number_of_events!(node::T, counter) where {T <: BranchingEvent}

    for branch in node.children
        number_of_events!(branch.outbounds, counter)
        n = length(branch.times) - 1
        counter[1] += n
    end
end

function number_of_events!(node::T, counter) where {T <: TipNode}
end
