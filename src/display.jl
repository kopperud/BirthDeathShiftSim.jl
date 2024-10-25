function Base.Multimedia.display(root::Root)
    n_taxa = number_of_taxa(root)
    n_extinctions = number_of_extinctions(root)
    
    println("A rooted phylogenetic tree with $n_taxa extant taxa and $n_extinctions extinction events.")
end