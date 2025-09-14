function Be_Area(::Val{:CPS3}, e, FE_coords, FE_elem_node)
    # node ids of element e (assumes FE_elem_node is nodes_per_elem x n_elem)
    nids = FE_elem_node[:, e]
    x1, y1 = FE_coords[1, nids[1]], FE_coords[2, nids[1]]
    x2, y2 = FE_coords[1, nids[2]], FE_coords[2, nids[2]]
    x3, y3 = FE_coords[1, nids[3]], FE_coords[2, nids[3]]

    detA = (x2 * y3 - x3 * y2) - (x1 * y3 - x3 * y1) + (x1 * y2 - x2 * y1)
    area = 0.5 * detA

    # linear triangular shape function derivatives (b_i, c_i)
    # Using standard formula: N_i = (a_i + b_i x + c_i y), with
    # b1 = (y2 - y3)/(2A), c1 = (x3 - x2)/(2A), etc.
    denom = 2 * area
    b1 = (y2 - y3) / denom
    b2 = (y3 - y1) / denom
    b3 = (y1 - y2) / denom

    c1 = (x3 - x2) / denom
    c2 = (x1 - x3) / denom
    c3 = (x2 - x1) / denom

    # B matrix 3 x (2*3) following your quad ordering [u1 v1 u2 v2 u3 v3]
    B = zeros(3, 6)
    B[1, 1] = b1
    B[1, 3] = b2
    B[1, 5] = b3

    B[2, 2] = c1
    B[2, 4] = c2
    B[2, 6] = c3

    B[3, 1] = c1
    B[3, 2] = b1
    B[3, 3] = c2
    B[3, 4] = b2
    B[3, 5] = c3
    B[3, 6] = b3

    return B, area
end

# helper: linear tetra (4-node) -> returns B (6x12) and volume (scalar)
function Be_Area(::Val{:Tet4}, e, FE_coords, FE_elem_node)
    # node ids for tetra
    nids = FE_elem_node[:, e]
    x1, y1, z1 = FE_coords[1, nids[1]], FE_coords[2, nids[1]], FE_coords[3, nids[1]]
    x2, y2, z2 = FE_coords[1, nids[2]], FE_coords[2, nids[2]], FE_coords[3, nids[2]]
    x3, y3, z3 = FE_coords[1, nids[3]], FE_coords[2, nids[3]], FE_coords[3, nids[3]]
    x4, y4, z4 = FE_coords[1, nids[4]], FE_coords[2, nids[4]], FE_coords[3, nids[4]]

    xyz = [1 x1 y1 z1; 1 x2 y2 z2; 1 x3 y3 z3; 1 x4 y4 z4]
    V = det(xyz) / 6
    bb1 = [1 y2 z2; 1 y3 z3; 1 y4 z4]
    bb2 = [1 y1 z1; 1 y3 z3; 1 y4 z4]
    bb3 = [1 y1 z1; 1 y2 z2; 1 y4 z4]
    bb4 = [1 y1 z1; 1 y2 z2; 1 y3 z3]

    cc1 = [x2 1 z2; x3 1 z3; x4 1 z4]
    cc2 = [x1 1 z1; x3 1 z3; x4 1 z4]
    cc3 = [x1 1 z1; x2 1 z2; x4 1 z4]
    cc4 = [x1 1 z1; x2 1 z2; x3 1 z3]

    dd1 = [x2 y2 1; x3 y3 1; x4 y4 1]
    dd2 = [x1 y1 1; x3 y3 1; x4 y4 1]
    dd3 = [x1 y1 1; x2 y2 1; x4 y4 1]
    dd4 = [x1 y1 1; x2 y2 1; x3 y3 1]

    b1 = -1 * det(bb1)
    b2 = 1 * det(bb2)
    b3 = -1 * det(bb3)
    b4 = 1 * det(bb4)

    c1 = -1 * det(cc1)
    c2 = 1 * det(cc2)
    c3 = -1 * det(cc3)
    c4 = 1 * det(cc4)

    d1 = -1 * det(dd1)
    d2 = 1 * det(dd2)
    d3 = -1 * det(dd3)
    d4 = 1 * det(dd4)

    B1 = [b1 0 0 b2 0 0 b3 0 0 b4 0 0]
    B2 = [0 c1 0 0 c2 0 0 c3 0 0 c4 0]

    B3 = [0 0 d1 0 0 d2 0 0 d3 0 0 d4]

    B4 = [c1 b1 0 c2 b2 0 c3 b3 0 c4 b4 0]
    B5 = [0 d1 c1 0 d2 c2 0 d3 c3 0 d4 c4]
    B1 = [b1 0 0 b2 0 0 b3 0 0 b4 0 0]
    B6 = [d1 0 b1 d2 0 b2 d3 0 b3 d4 0 b4]

    B = [B1; B2; B3; B4; B5; B6] / (6 * V)

    return B, V
end

