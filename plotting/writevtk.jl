function writevtk(OPT::OPT_struct, FE::FE_struct, folder, writevtk_stress)
    filename = folder * OPT.examples *".vtk"

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

    # Write elemental density
    println(fid, "CELL_DATA " * string(FE.n_elem))
    println(fid, "FIELD FieldData 1")
    println(fid, "density 1 ", FE.n_elem, " float")
    for iel in 1:FE.n_elem
        println(fid, OPT.pen_rho_e[iel])
    end

    close(fid)
end
