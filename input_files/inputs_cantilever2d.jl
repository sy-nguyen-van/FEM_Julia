function inputs_cantilever2d(OPT::OPT_struct, FE::FE_struct)
    ## ============Input file================
  FE.mesh_input.type = "Mesh_files"
  ## =======================================================================
  ## Material information
  # Specify the Young"s modulus and Poisson ratio 
  FE.material.E = 119e3   # Young"s modulus of the design material
  FE.material.nu = 0.34 # Poisson ratio of the design material
  FE.material.rho_min = 1e-3 # Minimum density in void region
  FE.material.nu_void = 0.34 # Poisson ratio of the void material
  return OPT, FE
end

