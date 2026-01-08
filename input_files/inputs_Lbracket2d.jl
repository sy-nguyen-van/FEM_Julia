function inputs_Lbracket2d(OPT::OPT_struct, FE::FE_struct)
    ## ============Input file================
    FE.mesh_input.type = "Lbracket2d"

    if OPT.fd_check == 1
        FE.mesh_input.L_side = 50
        FE.mesh_input.L_cutout = 30
        FE.mesh_input.L_element_size = 5
    elseif OPT.fd_check == 0
        FE.mesh_input.L_side = 100
        FE.mesh_input.L_cutout = 60
        FE.mesh_input.L_element_size = 1  # Unit cell size = 1 mm
    end
    ## =======================================================================
    FE.material.E = 106e3   # Young"s modulus of the design material
    FE.material.nu = 0.34 # Poisson ratio of the design material
    FE.material.rho_min = 1e-3 # Minimum density in void region
    FE.material.nu_void = 0.34 # Poisson ratio of the void material
    # ========
    OPT.options.obj_tol = 1e-5
    OPT.options.max_GRF = 0.15
    # ====
    OPT.parameters.init_dens_macro = 0.5  # initial macro density
    OPT.functions.stress_limit = [992]
    OPT.aggregation_power = 10
    # =======================================================================        
    ## Optimization problem definition
    # functions:
    # Name of objective function
    OPT.functions.objective_scale = 1.0        # Scale factor for objective function
    OPT.functions.constraints_scale = 1.0      # Scale factor for constraints function
    OPT.functions.ncons = 1                    # Number of constraints
    volume_fraction_limit = 0.15               # Volume fraction limit's value
    ## ===============Choosing the objective and constraints functions================
    OPT.functions.objective = "volume_fraction"       # volume_fraction_multi_scales    
    OPT.functions.constraints = "maximum_stress"
    ## =======================================================================        
    ## Penalization and filtering parameters 
    # Penalization scheme 
    OPT.parameters.penalization_scheme = "modified_SIMP" # Options: "SIMP", "modified_SIMP", "RAMP", "modified_RAMP" 
    # Parameter to be used for the penalization
    OPT.parameters.penalization_param = 3
    # Filtering radius given as a factor of largest element side
    OPT.parameters.filter_radius_factor = 2.5
    return OPT, FE
end
