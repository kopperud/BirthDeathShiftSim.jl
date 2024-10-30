function Base.Multimedia.display(root::Root)
    n_taxa = number_of_taxa(root)
    n_extinctions = number_of_extinctions(root)
    n_events = number_of_events(root)
    
    println("A rooted phylogenetic tree with $n_taxa extant taxa, $n_extinctions extinction events, and $n_events number of diversification rate shifts.")
end