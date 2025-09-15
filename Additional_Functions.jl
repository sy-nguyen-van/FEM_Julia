function Additional_Functions()
    push!(LOAD_PATH, "Mesh_files")
    ## ============ADD PATH of SUB-FOLDERS===============
    push!(LOAD_PATH, "input_files")
    include("input_files/Generate_Struct.jl")
    include("input_files/get_inputs.jl")
    include("input_files/inputs_cantilever3d.jl")
    include("input_files/inputs_cantilever2d.jl")
    include("input_files/inputs_Lbracket3d.jl")

    include("input_files/setup_bcs_cantilever3d.jl")
    include("input_files/setup_bcs_cantilever2d.jl") 
    include("input_files/setup_bcs_Lbracket3d.jl")
    include("input_files/read_mesh_Abaqus.jl")
    include("input_files/read_inp_mesh.jl")
    #-----------------------------------------------------
    push!(LOAD_PATH, "FE_routines")
    include("FE_routines/Call_Ce.jl")
    include("FE_routines/Jacobian.jl")
    include("FE_routines/Jacobian8.jl")
    include("FE_routines/G0_N.jl")
    include("FE_routines/G0_N8.jl")

    include("FE_routines/init_FE.jl")
    include("FE_routines/perform_analysis.jl")
    include("FE_routines/FE_analysis.jl")
    include("FE_routines/FE_solve.jl")
    include("FE_routines/FE_compute_element_stiffness.jl")
    include("FE_routines/compute_predefined_node_sets.jl")
    include("FE_routines/Ke_Ce_Update.jl")
    include("FE_routines/Be_Area.jl")
    include("FE_routines/FE_assemble_stiffness_matrix.jl")
    include("FE_routines/Heaviside.jl")
    include("FE_routines/penalize.jl")
    #------------------------------------------------------
    push!(LOAD_PATH, "functions")
    include("functions/volume_fraction.jl")
    include("functions/compliance.jl")
    include("functions/compute_stress.jl")
    #------------------------------------------------------ 
    push!(LOAD_PATH, "plotting")
    include("plotting/writevtk.jl")
    #------------------------------------------------------
    push!(LOAD_PATH, "outputs")
    #------------------------------------------------------
end