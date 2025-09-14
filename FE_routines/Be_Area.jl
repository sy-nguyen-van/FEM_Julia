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
    xI, yI, zI = FE_coords[1, nids[1]], FE_coords[2, nids[1]], FE_coords[3, nids[1]]
    xJ, yJ, zJ = FE_coords[1, nids[2]], FE_coords[2, nids[2]], FE_coords[3, nids[2]]
    xK, yK, zK = FE_coords[1, nids[3]], FE_coords[2, nids[3]], FE_coords[3, nids[3]]
    xL, yL, zL = FE_coords[1, nids[4]], FE_coords[2, nids[4]], FE_coords[3, nids[4]]

    # Volume
    V6 = det([1 xI yI zI;
              1 xJ yJ zJ;
              1 xK yK zK;
              1 xL yL zL])
    V = abs(V6) / 6.0

    # Coefficients

    b = -[
        det([1 yJ zJ; 
            1 yK zK; 
            1 yL zL]),
        det([1 yK zK; 
            1 yL zL; 
            1 yI zI]),
        det([1 yL zL; 
            1 yI zI; 
            1 yJ zJ]),
        det([1 yI zI; 
            1 yJ zJ; 
            1 yK zK])
    ]

    c = [
        det([xJ 1 zJ; 
            xK 1 zK; 
            xL 1 zL]),
        det([xK 1 zK; 
            xL 1 zL; 
            xI 1 zI]),
        det([xL 1 zL; 
            xI 1 zI; 
            xJ 1 zJ]),
        det([xI 1 zI; 
            xJ 1 zJ; 
            xK 1 zK])
    ]

     d = -[
        det([xJ yJ 1; 
            xK yK 1; 
            xL yL 1]),
        det([xK yK 1; 
            xL yL 1; 
            xI yI 1]),
        det([xL yL 1;
            xI yI 1; 
            xJ yJ 1]),
        det([xI yI 1;
            xJ yJ 1; 
            xK yK 1])
    ]

    # Build B matrix 6 x (3*4) with node order [u1 v1 w1 u2 v2 w2 ...]
    B = zeros(6, 12)
    # row 1: ε_xx = b1 u1 + b2 u2 + ...
    B[1, 1] = b[1]
    B[1, 4] = b[2]
    B[1, 7] = b[3]
    B[1, 10] = b[4]
    # row 2: ε_yy = c1 v1 + c2 v2 + ...
    B[2, 2] = c[1]
    B[2, 5] = c[2]
    B[2, 8] = c[3]
    B[2, 11] = c[4]
    # row 3: ε_zz = d1 w1 + ...
    B[3, 3] = d[1]
    B[3, 6] = d[2]
    B[3, 9] = d[3]
    B[3, 12] = d[4]
    # row 4: ε_xy = c1 u1 + b1 v1 + ...
    B[4, 1] = c[1]
    B[4, 2] = b[1]
    B[4, 4] = c[2]
    B[4, 5] = b[2]
    B[4, 7] = c[3]
    B[4, 8] = b[3]
    B[4, 10] = c[4]
    B[4, 11] = b[4]
    # row 5: ε_yz = d1 v1 + c1 w1 + ...
    B[5, 2] = d[1]
    B[5, 3] = c[1]
    B[5, 5] = d[2]
    B[5, 6] = c[2]
    B[5, 8] = d[3]
    B[5, 9] = c[3]
    B[5, 11] = d[4]
    B[5, 12] = c[4]
    # row 6: ε_zx = b1 w1 + d1 u1 + ...
    B[6, 1] = d[1]
    B[6, 3] = b[1]
    B[6, 4] = d[2]
    B[6, 6] = b[2]
    B[6, 7] = d[3]
    B[6, 9] = b[3]
    B[6, 10] = d[4]
    B[6, 12] = b[4]
    #
    B0 = B/V6
    return B0, V
end

