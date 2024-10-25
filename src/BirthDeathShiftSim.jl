"""
Placeholder for a short summary about BirthDeathShiftSim.
"""
module BirthDeathShiftSim

import Distributions
import Random

include("types.jl")
include("postorder.jl")
include("models.jl")
include("simulate_constant.jl")
include("species_counter.jl")
include("number_of_taxa.jl")
include("treeplot.jl")
include("reindex.jl")
include("tipstates.jl")
include("prune_extinct.jl")
include("ladderize.jl")
include("display.jl")
include("draw_event.jl")
include("treeheight.jl")
include("write/newick.jl")


end # module
