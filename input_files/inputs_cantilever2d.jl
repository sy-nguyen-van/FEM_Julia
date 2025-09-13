function inputs_cantilever2d(OPT::OPT_struct, FE::FE_struct)
  ## ============Input file================
  FE.mesh_input.type = "generate"
  if OPT.fd_check == 1
    FE.mesh_input.box_dimensions = [10, 5];
    FE.mesh_input.elements_per_side = [10, 5];
    FE.mesh_input.element_size = FE.mesh_input.box_dimensions[1]/FE.mesh_input.elements_per_side[1];
  elseif OPT.fd_check == 0
    FE.mesh_input.box_dimensions = [120, 40];
    FE.mesh_input.elements_per_side =[120, 40] ;
    FE.mesh_input.element_size = FE.mesh_input.box_dimensions[1]/FE.mesh_input.elements_per_side[1];
  end
  
  ## =======================================================================
  ## Material information
  # Specify the Young"s modulus and Poisson ratio 
  FE.material.E = 119e3   # Young"s modulus of the design material
  FE.material.nu = 0.34 # Poisson ratio of the design material
  FE.material.rho_min = 1e-3 # Minimum density in void region
  FE.material.nu_void = 0.34 # Poisson ratio of the void material

  # ========
  OPT.options.obj_tol = 1e-5
  OPT.options.max_GRF = 0.15
  # ====
  OPT.parameters.init_dens_macro = 0.5  # initial macro density
  OPT.parameters.init_thickness_micro = 0.15  # initial micro THICKNESS
  # Parameters for Heaviside function
  OPT.beta_min = 1
  OPT.beta_max = 30
  OPT.eta_H = 0.5
  # =======================================================================        
  OPT.relax_power = 0.5         # power to compute the relaxed stress
  OPT.aggregation_power = 10    # the power for the p-norm
  if OPT.fd_check == 1
    OPT.load_amplitude = -10 # The magnitude of the applied unit load F (N)
  else
    if OPT.run_SGs == 1
    OPT.load_amplitude = -200 # The magnitude of the applied unit load F (N)
    else
    OPT.load_amplitude = -500 # The magnitude of the applied unit load F (N)
    end
  end
  # =======================================================================        
  ## Optimization problem definition
  # functions:
  # Name of objective function
  OPT.functions.objective_scale = 1.0        # Scale factor for objective function
  OPT.functions.constraints_scale = 1.0      # Scale factor for constraints function
  OPT.functions.ncons = 1                    # Number of constraints
  volume_fraction_limit = 0.1                # Volume fraction limit's value
  ## ===============Choosing the objective and constraints functions================
  # ----MULTI SCALE---
  if OPT.run_multi_scales == 1
    # -- TOP with multi-scales without stress --
    OPT.functions.objective = "compliance_multi_scales"
    OPT.functions.constraints = "volume_fraction_multi_scales"
    OPT.functions.volume_fraction_limit = copy(volume_fraction_limit)  # Limit for volume fraction function
    # ----STRESS---
    if OPT.run_stress == 1
      # -- TOP with multi-scales with stress --
      OPT.functions.stress_limit = [1080]   # MPa Stres Limit for stress constraints !!!
      OPT.functions.volume_fraction_limit = copy(volume_fraction_limit) # set volume fraction limit to 0.0
      # volume_fraction_multi_scales  maximum_stress_SGs maximum_stress_multi_scales
      if OPT.run_SGs == 1
        # -- TOP with multi-scales with stress +SGs--   
        OPT.functions.objective = "volume_fraction_multi_scales"       # volume_fraction_multi_scales    
        OPT.functions.constraints = "maximum_stress_SGs"
      else
        OPT.functions.objective = "volume_fraction_multi_scales"       # volume_fraction_multi_scales    
        OPT.functions.constraints = "maximum_stress_multi_scales"
      end
    end
    
  else
    OPT.functions.objective = "compliance"
    OPT.functions.constraints = "volume_fraction"
    OPT.functions.volume_fraction_limit = copy(volume_fraction_limit)  # Limit for volume fraction function
  end
  ## =======================================================================        
  ## Penalization and filtering parameters 
  # Penalization scheme 
  OPT.parameters.penalization_scheme = "modified_SIMP" # Options: "SIMP", "modified_SIMP", "RAMP", "modified_RAMP" 
  # Parameter to be used for the penalization
  OPT.parameters.penalization_param = 3
  # Filtering radius given as a factor of largest element side
  OPT.parameters.filter_radius_factor = 3.0
  return OPT, FE
end

