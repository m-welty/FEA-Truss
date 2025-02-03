clc;
clear;


% Creation of element stiffness matricies
node_coords = input('Enter the coordinates of the nodes: [x1 y1; x2 y2]\n');
num_nodes = size(node_coords,1);
element_connections = input('Enter element connections using node numbers, lowest first: [1 2; 1 3]\n');
num_elements = size(element_connections,1);
A = input('Enter the cross sectional area of the material\n');
E = input('Enter the elastic modulus of the material\n');

for i = 1:num_elements
    x1=node_coords(element_connections(i,1),1);
    x2=node_coords(element_connections(i,2),1);
    y1=node_coords(element_connections(i,1),2);
    y2=node_coords(element_connections(i,2),2);
    L = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    c = (x2 - x1) / L;
    s = (y2 - y1) / L;
    K{i} = E * A / L  * [c^2 c*s -c^2 -c*s; c*s s^2 -c*s -s^2; -c^2 -c*s c^2 c*s; -c*s -s^2 c*s s^2];
end


% Creation of global stiffness matrix
K_global=zeros(2*num_nodes, 2* num_nodes);

for i = 1:num_elements
    n1 = element_connections(i,1);
    n2 = element_connections(i,2);
    DoF_Map = [2*n1-1 2*n1 2*n2-1 2*n2];
    K_global(DoF_Map, DoF_Map) = K_global(DoF_Map, DoF_Map) + K{i};
end


% Initial Force Matrix
f_initial = zeros(1,2*num_nodes);
f_initial = input('Enter the applied forces at each node, including zeroes, using NaN if unknown: [f1x; f1y; f2x; f2y]\n');


% Initial Displacement Matrix
d_initial = zeros(1,2*num_nodes);
d_initial = input('Enter the displacement boundary conditions, including zeroes, and using NaN if unknown: [u1; v1; u2; v2]\n');


% Matrix Math
d_math = d_initial;
f_math = f_initial;
K_math = K_global;
remove=[];
for i = 1:size(d_initial,1)
    if ~isnan(d_initial(i,1))
        remove = [remove, i]; % Array of rows numbers of known displacements
    end
end

remove = flip(remove);
d_math(remove) = [];
f_math(remove) = [];
K_math(remove,: ) = [];
d_known = d_initial(remove);
f_math = f_math - K_math(:,remove)*d_known;
K_math(:,remove) = [];

d_math = K_math \ f_math;

d_final = d_initial;
for i = 1:size(d_initial,1)
    if isnan(d_final(i,1))
        d_final(i,1) = d_math(1);
        d_math(1,:) = [];
    end
end

f_math2 = K_global * d_final;
f_final = f_initial;
for i = 1:size(f_final,1)
    if isnan(f_final(i,1))
        f_final(i,1) = f_math2(i,1);
    end
end


% Calculating Stresses
stress = zeros(num_elements,1);
for i = 1:num_elements
    x1=node_coords(element_connections(i,1),1);
    x2=node_coords(element_connections(i,2),1);
    y1=node_coords(element_connections(i,1),2);
    y2=node_coords(element_connections(i,2),2);
    L = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    c = (x2 - x1) / L;
    s = (y2 - y1) / L;
    stress(i,1) = E * [-1/L 1/L] * [c s 0 0;0 0 c s] * [d_final(2*element_connections(i,1)-1); d_final(2*element_connections(i,1)); d_final(2*element_connections(i,2)-1); d_final(2*element_connections(i,2))];
end


% Plotting
figure
hold on
for i = 1:num_elements
    x1=node_coords(element_connections(i,1),1);
    x2=node_coords(element_connections(i,2),1);
    y1=node_coords(element_connections(i,1),2);
    y2=node_coords(element_connections(i,2),2);
    plot([x1 x2], [y1 y2], "red:")
end

for i = 1:num_elements
    x1 = node_coords(element_connections(i,1),1) + d_final(2*element_connections(i,1)-1);
    x2 = node_coords(element_connections(i,2),1) + d_final(2*element_connections(i,2)-1);
    y1 = node_coords(element_connections(i,1),2) + d_final(2*element_connections(i,1));
    y2 = node_coords(element_connections(i,2),2) + d_final(2*element_connections(i,2));
    plot([x1 x2], [y1 y2], "blue:")
end


% Additional Outputs
fprintf('\n_____FINAL DISPLACEMENTS_____\n')
d_final
fprintf('\n_____REACTION FORCES_____\n')
f_final
fprintf('\n_____ELEMENT STRESSES_____\n')
stress
