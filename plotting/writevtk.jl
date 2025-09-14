function writevtk(OPT::OPT_struct, FE::FE_struct, folder)
    filename = folder * OPT.examples * ".vtk"

    fid = open(filename, "w")

    # Write header
    println(fid, "# vtk DataFile Version 1.0")
    println(fid, "Bar_TO_3D")
    println(fid, "ASCII")
    println(fid, "DATASET UNSTRUCTURED_GRID")

    # Write nodal coordinates
    coords = zeros(3, FE.n_node)
    coords[1:FE.dim, :] = FE.coords[1:FE.dim, :]
    println(fid, "POINTS " * string(FE.n_node) * " float ")
    for inode in 1:FE.n_node
        println(fid, coords[1, inode], " ", coords[2, inode], " ", coords[3, inode])
    end

    # Determine number of nodes per element and VTK type
    elem_type = FE.elem_type[1]
    if elem_type == :CPS3
        nnodes = 3
        vtk_type = 5
    elseif elem_type == :Quad4
        nnodes = 4
        vtk_type = 9
    elseif elem_type == :Tet4
        nnodes = 4
        vtk_type = 10
    elseif elem_type == :Hex8
        nnodes = 8
        vtk_type = 12
    else
        error("Unsupported element type: $(FE.elem_type)")
    end

    # Write elements
    println(fid, "CELLS " * string(FE.n_elem) * " " * string(FE.n_elem * (nnodes + 1)))
    for iel in 1:FE.n_elem
        writedlm(fid, [nnodes vec(FE.elem_node[:, iel])' .- 1], " ")
    end

    # Write cell types
    println(fid, "CELL_TYPES " * string(FE.n_elem))
    for iel in 1:FE.n_elem
        println(fid, vtk_type)
    end
    # ====================
    n_scalar_fields = 2 # density + stress
    # Write elemental density
    println(fid, "CELL_DATA " * string(FE.n_elem) * " ")
    println(fid, "FIELD FieldData  ", n_scalar_fields)
    println(fid, "density 1 ", FE.n_elem, " float")
    for iel in 1:FE.n_elem
        println(fid, OPT.pen_rho_e[iel])
    end
    # ========
    # Write elemental stress
    # Write elemental STRESS
    for iload in 1:FE.nloads
        println(fid, "stress_iload_" * string(iload) * " 1 ", FE.n_elem, " float ")
        for iel in 1:FE.n_elem
            stress = FE.svm[iel, iload]
            println(fid, stress, " ")
        end
    end

    # ========
    println(fid, "POINT_DATA ", FE.n_node)
    nloads = size(FE.U, 2)  # number of load cases
    println(fid, "FIELD FieldData ", nloads)
    for iload in 1:FE.nloads
        println(fid, "displacement_", iload, " 3 ", FE.n_node, " float")
        for inode in 1:FE.n_node
            ndofs_per_node = FE.dim
            dof_idx = ((inode-1)*ndofs_per_node+1):(inode*ndofs_per_node)
            U_node = FE.U[dof_idx, iload]
            if FE.dim==3
            println(fid, U_node[1], " ", U_node[2], " ", U_node[3])
            else
             println(fid, U_node[1], " ", U_node[2], " ", 0)
            end
        end
    end

    close(fid)
end
