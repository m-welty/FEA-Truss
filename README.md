# FEA-Truss
MATLAB (.m file) that uses FEA to solve 2D trusses


When run, the code asks the user for inputs.

node_coords: Coordinates of nodes in the form [x1 y1; x2 y2; x3 y3...]. Units in meters.
Ex: [0 0; 1 0; 0 1; 1 1] will create node 1 at (0,0), node 2 at (1,0), node 3 at (0, 1) and node 4 at (1. 1).

element_connections: Connections between nodes in the form [n1 n2; n3 n4...]. The lowest nodes go first.
Ex: [1 2; 1 3; 2 4; 3 4] will create a square if using the previous example.

A: Cross-sectional area of the material used for connections. Units in m^2.

E: Elastic modulus of the material used for connections. Units in MPa.

The code will then calculate the stiffness matrix for each element.

The code will then assemble the global stiffness matrix.

Code accepts the last set of inputs.

f_initial: Applied forces at each node in the form [f1x; f1y; f2x; f2y...]. Units in N. Use NaN if unknown. Set other values to 0.
Ex: [1; 0; 0; 0; NaN; NaN; 0; -2] will have a force of 1N acting to the right of node 1, a force of 2N acting downward on node 4, node 2 will have no forces in equilibrium, and node 3 has reaction forces that need to be calculated.

d_initial: Displacement boundary conditions at each node in the form [u1; v1; u2; v2...]. Units in m. Use NaN if unknown. Set other values to 0.
Ex: [0; 0; 0; 0; NaN; NaN, 0, -0.5] will have displacements of 0 in both x- and y-directions for nodes 1 and 2, a displacement downward on node 4 of 0.5m, and node 3 has displacements that need to be calculated.

The code then performs matrix operations to solve for unknown values.

The final displacement, force and stress values are calculated.

The deformation plot is created.

The final displaces, forces and stresses are displayed.
