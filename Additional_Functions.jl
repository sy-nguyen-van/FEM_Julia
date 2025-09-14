function Additional_Functions()
    push!(LOAD_PATH, "Abaqus_Mesh")
    ## ============ADD PATH of SUB-FOLDERS===============
    push!(LOAD_PATH, "input_files")
    include("input_files/Generate_Struct.jl")
    include("input_files/init_SGs.jl")
    include("input_files/get_inputs.jl")

    include("input_files/setup_bcs_Lbracket2d.jl")
    include("input_files/setup_bcs_cracked_plate2d.jl")
    include("input_files/setup_bcs_Vframe2d.jl")
    include("input_files/setup_bcs_doubleLbracket2d.jl")
    include("input_files/setup_bcs_cantilever3d.jl")
    include("input_files/setup_bcs_cantilever2d.jl")
    include("input_files/setup_bcs_mbb2d.jl")
    include("input_files/setup_bcs_Lbracket2d_2_Loads.jl")
    include("input_files/setup_bcs_3points_bending.jl")
    
    include("input_files/setup_bcs_Lbracket3d.jl")
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


    #------------------------------------------------------
    push!(LOAD_PATH, "functions")
    include("functions/obj_nonlcon.jl")
    include("functions/volume_fraction.jl")
    include("functions/compliance.jl")
    include("functions/compute_stress.jl")

    #------------------------------------------------------
    push!(LOAD_PATH, "FD_check")
    include("FD_check/run_finite_difference_check.jl")
    #------------------------------------------------------
    push!(LOAD_PATH, "optimization")
    include("optimization/init_optimization.jl")
    include("optimization/runmma.jl")
    include("optimization/kktcheck.jl")
    include("optimization/mma1999.jl")
    include("optimization/subsolv1999.jl")
    include("optimization/ACS_Call.jl")
    #------------------------------------------------------ 
    push!(LOAD_PATH, "plotting")
    include("plotting/plot_design.jl")
    include("plotting/plot_design_3D.jl")
    include("plotting/writevtk.jl")
    include("plotting/initial_design.jl")
    include("plotting/show_design_iter.jl")
    #------------------------------------------------------
    push!(LOAD_PATH, "outputs")
    #------------------------------------------------------
end