function my_func(x::Float64)
    x
end
#--------------------------------------------
mutable struct OPT_functions
    objective::String
    objective_scale::Float64
    constraints::String
    volume_fraction_limit::Float64
    constraints_scale::Float64
    ncons::Int64
    stress_limit::Vector{Float64}
    fatigue_limit::Float64
    fatigue_strength_coeff::Float64
end
#--------------------------------------------
mutable struct OPT_parameters
    penalization_scheme::String
    penalization_param::Float64
    filter_radius_factor::Float64
    init_dens_macro::Float64
    init_thickness_micro::Float64
end
#--------------------------------------------
mutable struct OPT_options
    max_iter::Int64
    move_limit::Float64
    obj_tol::Float64
    max_GRF::Float64
end

#--------------------------------------------
mutable struct OPT_struct
    functions::OPT_functions
    parameters::OPT_parameters
    options::OPT_options
    TPMS::String
    examples::String
    LB_macro::Float64
    UB_macro::Float64
    LB_micro::Float64
    UB_micro::Float64
    rho_thick::Float64
    beta_min::Float64
    beta_max::Float64
    eta_H::Float64
    iter::Int64
    index_dv_macro::Vector{Int64}
    index_dv_micro::Vector{Int64}
    fd_check::Int64
    H::SparseMatrixCSC{Float64,Int64}
    n_dv::Int64
    dv::Vector{Float64}
    filter_radius::Float64
    dv_micro::Vector{Float64}
    filt_rho_e::Vector{Float64}
    diff_Hea::Vector{Float64}
    pen_rho_e::Vector{Float64}
    dpen_rho_e::Vector{Float64}
    fd_step_size::Float64
    dv_old::Vector{Float64}
    compliance::Float64
    grad_compliance::Vector{Float64}
    volume_fraction::Float64
    grad_volume_fraction::Vector{Float64}
    approx_h_max::Float64
    true_h_max::Float64
    true_stress_fatigue_max::Float64
    grad_stress_fatigue::Vector{Float64}
    run_multi_scales::Bool
    run_stress::Bool
    run_SGs::Bool
    run_fatigue::Bool
    aggregation_power::Int64
    scaled_power::Float64
    load_amplitude::Float64
    time_points::Int64
    load_hist::Matrix{Float64}
    relax_power::Float64
    duration::Float64    # Hours
    life_constraint::Float64    # Hours
    Coeffs::Matrix{Float64}

end
#--------------------------------------------
mutable struct FE_mesh_input
    type::String
    L_side::Float64
    L_cutout::Float64
    L_element_size::Float64
    element_size::Float64
    box_dimensions::Vector{Int64}
    elements_per_side::Vector{Int64}
    cutout_dimensions::Vector{Int64}
    L_width::Float64
    L_height::Float64
end
#--------------------------------------------
mutable struct FE_material
    E::Float64
    nu::Float64
    rho_min::Float64
    nu_void::Float64
end
#--------------------------------------------
mutable struct FE_BC
    n_pre_force_dofs::Vector{Int64}
    force_node::Vector{Int64}
    force_dof::Vector{Int64}
    force_value::Vector{Float64}
    force_id::Vector{Int64}
    n_pre_disp_dofs::Int64
    disp_node::Vector{Int64}
    disp_dof::Vector{Int64}
    disp_value::Vector{Float64}

end
#--------------------------------------------
mutable struct FE_node_set
    T_edge::Vector{Float64}
    B_edge::Vector{Float64}
    L_edge::Vector{Float64}
    R_edge::Vector{Float64}
    BL_pt::Vector{Float64}
    BR_pt::Vector{Float64}
    TR_pt::Vector{Float64}
    TL_pt::Vector{Float64}
    ML_pt::Vector{Float64}
    MR_pt::Vector{Float64}
    MB_pt::Vector{Float64}
    MT_pt::Vector{Float64}
    C_pt::Vector{Float64}
    T_face::Vector{Float64}
    B_face::Vector{Float64}
    L_face::Vector{Float64}
    R_face::Vector{Float64}
    K_face::Vector{Float64}
    F_face::Vector{Float64}
    TK_edge::Vector{Float64}
    BK_edge::Vector{Float64}
    LK_edge::Vector{Float64}
    RK_edge::Vector{Float64}
    TF_edge::Vector{Float64}
    BF_edge::Vector{Float64}
    LF_edge::Vector{Float64}
    RF_edge::Vector{Float64}
    TL_edge::Vector{Float64}
    TR_edge::Vector{Float64}
    BL_edge::Vector{Float64}
    BR_edge::Vector{Float64}
    BLK_pt::Vector{Float64}
    BRK_pt::Vector{Float64}
    TRK_pt::Vector{Float64}
    TLK_pt::Vector{Float64}
    BLF_pt::Vector{Float64}
    BRF_pt::Vector{Float64}
    TRF_pt::Vector{Float64}
    TLF_pt::Vector{Float64}
    MLK_pt::Vector{Float64}
    MRK_pt::Vector{Float64}
    MBK_pt::Vector{Float64}
    MTK_pt::Vector{Float64}
    MLF_pt::Vector{Float64}
    MRF_pt::Vector{Float64}
    MBF_pt::Vector{Float64}
    MTF_pt::Vector{Float64}
    MBL_pt::Vector{Float64}
    MBR_pt::Vector{Float64}
    MTL_pt::Vector{Float64}
    MTR_pt::Vector{Float64}
    MK_pt::Vector{Float64}
    MF_pt::Vector{Float64}

end
#--------------------------------------------
mutable struct FE_struct
    mesh_input::FE_mesh_input
    material::FE_material
    BC::FE_BC
    node_set::FE_node_set
    dim::Int64
    n_elem::Int64
    n_node::Int64
    max_elem_side::Float64
    max_elem_diag::Float64
    nloads::Int64
    n_global_dof::Int64
    n_free_dof::Int64
    n_edof::Int64
    # Vec  Boolean
    fixeddofs::Vector{Bool}
    freedofs::Vector{Bool}
    # Vec  Int
    fixeddofs_ind::Vector{Int64}
    freedofs_ind::Vector{Int64}
    iK::Vector{Int64}
    jK::Vector{Int64}
    # Vec Float
    U::Matrix{Float64}
    elem_vol::Vector{Float64}
    rhs::Matrix{Float64}
    # SparseVector
    P::SparseMatrixCSC{Float64}
    Kpp::SparseMatrixCSC{Float64}
    Kfp::SparseMatrixCSC{Float64}
    Kff::SparseMatrixCSC{Float64}
    R::Any
    # Matrix float
    Ce::SharedArray{Float64}
    dCe::SharedArray{Float64}
    Ke::SharedArray{Float64}
    dKe::SharedArray{Float64}
    B0e::Array{Float64}
    V::Matrix{Float64}
    sK_penal::Vector{Float64}
    coord_min::Vector{Float64}
    coord_max::Vector{Float64}
    coords::Matrix{Float64}
    elem_node::Matrix{Int}
    centroids::Matrix{Float64}
    edofMat::Matrix{Float64}
    svm::Matrix{Float64}
    life::Vector{Float64}
    De::Vector{Float64}
    dJdu::Matrix{Float64}
    lambda::Matrix{Float64}
    elem_type::Vector{Symbol}
end
#--------------------------------------------
function Generate_Struct()
    mesh_input = FE_mesh_input("example", # example
        1.0,   # L_side
        1.0,   # L_cutout
        1,     # L_element_size
        1,     # element_size
        [1, 1],  #  box_dimensions
        [1, 1],  # elements_per_side
        [1, 1],  # cutout_dimensions
        1.0, #  L_width
        1.0, #  L_height
    )
    material = FE_material(1.0, 0.3, 1e-3, 0.3)
    BC = FE_BC([1], [0], [0], [0.0], [0], 0, [0], [0], [0.0])
    # --
    node_set = FE_node_set(
        zeros(1),  # T_edge::Vector{Float64}
        zeros(1),  # B_edge::Vector{Float64}
        zeros(1),  # L_edge::Vector{Float64}
        zeros(1),  # R_edge::Vector{Float64}
        zeros(1),  # BL_pt::Vector{Float64}
        zeros(1),  # BR_pt::Vector{Float64}
        zeros(1),  # TR_pt::Vector{Float64}
        zeros(1),  # TL_pt::Vector{Float64}
        zeros(1),  # ML_pt::Vector{Float64}
        zeros(1),  # MR_pt::Vector{Float64}
        zeros(1),  # MB_pt::Vector{Float64}
        zeros(1),  # MT_pt::Vector{Float64}
        zeros(1),  # C_pt::Vector{Float64}
        zeros(1),  # T_face::Vector{Float64}
        zeros(1),  # B_face::Vector{Float64}
        zeros(1),  # L_face::Vector{Float64}
        zeros(1),  # R_face::Vector{Float64}
        zeros(1),  # K_face::Vector{Float64}
        zeros(1),  # F_face::Vector{Float64}
        zeros(1),  # TK_edge::Vector{Float64}
        zeros(1),  # BK_edge::Vector{Float64}
        zeros(1),  # LK_edge::Vector{Float64}
        zeros(1),  # RK_edge::Vector{Float64}
        zeros(1),  # TF_edge::Vector{Float64}
        zeros(1),  # BF_edge::Vector{Float64}
        zeros(1),  # LF_edge::Vector{Float64}
        zeros(1),  # RF_edge::Vector{Float64}
        zeros(1),  # TL_edge::Vector{Float64}
        zeros(1),  # TR_edge::Vector{Float64}
        zeros(1),  # BL_edge::Vector{Float64}
        zeros(1),  # BR_edge::Vector{Float64}
        zeros(1),  # BLK_pt::Vector{Float64}
        zeros(1),  # BRK_pt::Vector{Float64}
        zeros(1),  # TRK_pt::Vector{Float64}
        zeros(1),  # TLK_pt::Vector{Float64}
        zeros(1),  # BLF_pt::Vector{Float64}
        zeros(1),  # BRF_pt::Vector{Float64}
        zeros(1),  # TRF_pt::Vector{Float64}
        zeros(1),  # TLF_pt::Vector{Float64}
        zeros(1),  # MLK_pt::Vector{Float64}
        zeros(1),  # MRK_pt::Vector{Float64}
        zeros(1),  # MBK_pt::Vector{Float64}
        zeros(1),  # MTK_pt::Vector{Float64}
        zeros(1),  # MLF_pt::Vector{Float64}
        zeros(1),  # MRF_pt::Vector{Float64}
        zeros(1),  # MBF_pt::Vector{Float64}
        zeros(1),  # MTF_pt::Vector{Float64}
        zeros(1),  # MBL_pt::Vector{Float64}
        zeros(1),  # MBR_pt::Vector{Float64}
        zeros(1),  # MTL_pt::Vector{Float64}
        zeros(1),  # MTR_pt::Vector{Float64}
        zeros(1),  # MK_pt::Vector{Float64}
        zeros(1)  # MF_pt::Vector{Float64}
    )

    # Create an instance of FE_struct
    FE = FE_struct(
        mesh_input,  # 
        material,    #
        BC,
        node_set,
        1,    # dim
        1,    # n_elem
        1,    # n_node
        1.0,    # max_elem_side    
        1.0,    # max_elem_diag 
        1,    # nloads 
        1,    # n_global_dof 
        1,    # n_free_dof 
        1,    # n_edof 

        # Vec  Boolean
        rand(Bool, 1),  # fixeddofs 
        rand(Bool, 1),  # freedofs 
        # Vec  Int
        [1],  # fixeddofs_ind 
        [1],  # freedofs_ind 
        [1],  # iK 
        [1],  # jK 
        # Vec  Float
        rand(1, 1),  # U
        rand(1),    # elem_vol
        rand(1, 1),    # rhs
        # SparseVector
        sparse(rand(1, 1)), # P 
        sparse(rand(1, 1)),    # Kpp::Any
        sparse(rand(1, 1)),    # Kfp::Any
        sparse(rand(1, 1)),    # Kff::Any
        factorize(Symmetric(rand(1, 1))),    # R::Any
        # Matrix float
        SharedArray{Float64}(1, 1, 1),  # Ce 
        SharedArray{Float64}(1, 1, 1),  # dCe 
        SharedArray{Float64}(1, 1, 1),  # Ke 
        SharedArray{Float64}(1, 1, 1),  # dKe 
        zeros(1, 1, 1),  # B0e 
        zeros(1, 1),  # V
        rand(1),  # sK_penal
        rand(1),  # coord_min
        rand(1),  # coord_max
        zeros(1, 1),  # coords
        rand(Int, 3, 3),  # elem_node    
        zeros(1, 1),   # centroids
        zeros(1, 1),   # edofMat
        rand(1, 1),  # FE_svm
        rand(1), # FE.life
        rand(1), # FE.De
        zeros(1, 1),   # dJdu
        zeros(1, 1),       # FE_lambda
        [:Tet4] # elem_type::Vector{Symbol}

    )
    #--------------------------------------------
    functions = OPT_functions(
        "compliance",       # objective
        1.0,      # objective_scale
        "volume fraction",  # constraints
        0.3,    # volume_fraction_limit
        1.0,    # constraints_scale
        1,      # n_func
        rand(1),       # stress_limit
        1.0,       # fatigue_limit
        1.0 #fatigue_strength_coeff
    )
    #--------------------------------------------
    parameters = OPT_parameters(
        "modified_SIMP", # penalization_scheme
        3,    # penalization_param
        2.5,  # filter_radius factor
        0.8,  # init_dens_macro
        0.1,  # init_thickness_micro
    )
    #--------------------------------------------
    options = OPT_options(
        2,       #
        0.02,       #
        1e-5,    #   
        0.1
    )


    #--------------------------------------------
    OPT = OPT_struct(functions, parameters, options,
        "Gyroid",  # TPMS::String
        "Lbracket2d", # Model
        0,    #    # LB_macro
        1,    # UB_macro
        0.1,    #    # LB_micro
        0.7,    # UB_micro
        0.364,  # rho_thick
        10,     # beta_min
        40,     # beta_max
        0.5,    # eta_H
        1.0,    # iter
        [1],    # index_macro
        [1],    # index_micro
        1,      # FD_check
        sparse(rand(1, 1)), # H
        1,      # n_dv
        rand(1),     # dv    
        1.5,    # filter_radius  
        rand(1),  # filt_t_e   
        rand(1),  # filt_rho_e 
        rand(1),  # diff_Hea 
        [1.0],  # pen_rho_e 
        rand(1),  # dpen_rho_e 
        1e-5,    # FD step size
        rand(1),    #  dv_old 
        1.0,    # compliance
        rand(1),    # grad_compliance
        1.0,    # volume_fraction
        rand(1),    # grad_volume_fraction
        0.0,    # approx_h_max::Float64
        0.0,    # true_h_max::Float64
        0.0,    # true_stress_fatigue_max::Float64
        rand(1),    # grad_stress_fatigue::Vector{Float64}
        true,       # run_multi_scales
        true,       # run_stress
        true,        # run_SGs
        false,
        10,         # aggregation_power
        -0.0909,  # scaled_power
        10,        #       load_amplitude::Float64
        1000,        #       time_points::Int64
        rand(1, 1),        #       load_hist::Vector{Float64}
        0.5, # relax_power
        1.0,    #     duration::Float64    # Hours
        10000 ,    #       life_constraint::Float64    # Hours
        rand(1,1),  # Coeffs
     
    )

    return OPT, FE

end