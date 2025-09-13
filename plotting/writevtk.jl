function writevtk(OPT::OPT_struct, FE::FE_struct, folder, writevtk_stress)
    # This function writes a vtk file with the mesh and the densities that can
    # be plotted with, e.g., ParaView
    #
    # This function writes an unstructured grid (vtk format) to folder (note
    # that the folder is relative to the rooth folder where the main script is
    # located).
    #
    # NOTE: if a vtk file with the same name exists in the folder, it will be
    # overwritten.
    filename = folder * OPT.examples *"_"*OPT.TPMS* "_"*OPT.functions.objective*"_"*OPT.functions.constraints*"_VTK.vtk"

    # Open the file for writing
    fid = open(filename, "w")

    # Write header
    println(fid, "# vtk DataFile Version 1.0")
    println(fid, "Bar_TO_3D")
    println(fid, "ASCII")
    println(fid, "DATASET UNSTRUCTURED_GRID")
    # Close the file when done
    # Write nodal coordinates
    coords = zeros(3, FE.n_node)
    coords[1:FE.dim, :] = FE.coords[1:FE.dim, :]
    println(fid, "POINTS " * string(FE.n_node) * " float ")
    for inode in 1:FE.n_node
        if FE.dim == 2
            println(fid, coords[1, inode], " ", coords[2, inode], " ", coords[3, inode], " ")
        elseif FE.dim == 3
            println(fid, coords[1, inode], " ", coords[2, inode], " ", coords[3, inode], " ")
        end
    end
    # Write elements
    nnodes = 2^FE.dim  # 4 for quads, 8 for hexas

    println(fid, " CELLS " * string(FE.n_elem) * " " * string(FE.n_elem * (nnodes + 1)) * "  ")
    for iel in 1:FE.n_elem
        # IMPORTANT! Vtk numbers nodes from 0, so we subtract 1
        if FE.dim == 2
            nel = 4
        elseif FE.dim == 3
            nel = 8
        end
        writedlm(fid, [nel vec(FE.elem_node[:, iel])' .- 1], " ")
    end
    # Write element types
    println(fid, "CELL_TYPES " * string(FE.n_elem) * " ")
    if FE.dim == 2
        elem_type = 9  # Corresponding to VTK_QUAD
    elseif FE.dim == 3
        elem_type = 12 # Corresponding to VTK_HEXAHEDRON
    end

    for iel in 1:FE.n_elem
        println(fid, elem_type)
    end
    # =================================================
    # =================================================
    # Write elemental DENSITY/THICKNESS    
    if OPT.run_multi_scales == 1
        if writevtk_stress == true
            n_scalar_fields = 3 + FE.nloads
        else
            n_scalar_fields = 3
        end

        println(fid, "CELL_DATA " * string(FE.n_elem) * " ")
        println(fid, "FIELD FieldData  ", n_scalar_fields)
        println(fid, "density 1 ", FE.n_elem, " float ")
        for iel in 1:FE.n_elem
            density = OPT.pen_rho_e[iel]
            println(fid, density, " ")
        end
        # Write elemental DENSITY/THICKNESS    
        println(fid, "thickness_micro 1 ", FE.n_elem, " float ")
        for iel in 1:FE.n_elem
            thickness = OPT.dv_micro[iel]
            println(fid, thickness, " ")
        end

        println(fid, "thickness_multi 1 ", FE.n_elem, " float ")
        for iel in 1:FE.n_elem
            thickness = OPT.pen_rho_e[iel] * OPT.dv_micro[iel]
            println(fid, thickness, " ")
        end

    else
        if writevtk_stress == true
            n_scalar_fields = 2
        else
            n_scalar_fields = 1
        end
        println(fid, "CELL_DATA " * string(FE.n_elem) * " ")
        println(fid, "FIELD FieldData  ", n_scalar_fields)
        println(fid, "thickness 1 ", FE.n_elem, " float ")
        for iel in 1:FE.n_elem
            thickness = OPT.dv_micro[iel]
            println(fid, thickness, " ")
        end

    end
    # =========================================
    # Write elemental STRESS
    for iload in 1:FE.nloads
        if writevtk_stress == true
            println(fid, "stress_iload_" * string(iload) * " 1 ", FE.n_elem, " float ")
            for iel in 1:FE.n_elem
                stress = FE.svm[iel, iload]
                println(fid, stress, " ")
            end
        end
    end

    close(fid)

end