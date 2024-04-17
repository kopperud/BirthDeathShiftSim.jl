using BirthDeathShiftSim

root = Root()

b1 = Branch_left(root, [1, 2], [0.5, 1.8])
b2 = Branch_right(root, [1], [2.0])


sp1 = Species(b1, "gorilla")


n1 = Node(b2)

b3 = Branch_left(n1, [1], [2.0])
b4 = Branch_right(n1, [1, 2], [0.5, 1.5])

sp2 = Species(b3, "chimp")
sp3 = Species(b4, "human")

postorder(root)



