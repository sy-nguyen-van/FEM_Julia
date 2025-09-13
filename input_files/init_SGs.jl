mutable struct SGs_struct
    min_thick::Float64
    max_thick::Float64
    Thick_Set_Train::Vector{Float64}
    n_case::Int64
    Coeffs_x_Top::Matrix{Float64}
    Coeffs_y_Top::Matrix{Float64}
    Coeffs_xy_Top::Matrix{Float64}
    Coeffs_x_Bottom::Matrix{Float64}
    Coeffs_y_Bottom::Matrix{Float64}
    Coeffs_xy_Bottom::Matrix{Float64}
    ele_SGs::Int64
    size_coeffs::Int64
    n_ele_micro::Int64
    degree::Int64
end

function init_SGs(OPT::OPT_struct)
    TPMS, examples = OPT.TPMS, OPT.examples
    Scaler_Name = "NoScaler"
    #-------------------
    opti_methods = "Poly"
    degree = 7
    #-----------Train-Test-No of Thick/Poisson-----------------------
    SGs = SGs_struct(
        0.0, # min_thick
        0.0,  # max_thick
        [0.0],  # Thick_Set_Train
        3,     # n_case
        rand(1, 1),  # Coeffs_x_Top
        rand(1, 1),  # Coeffs_y_Top
        rand(1, 1),  # Coeffs_xy_Top
        rand(1, 1),  # Coeffs_x_Bottom
        rand(1, 1),  # Coeffs_y_Bottom
        rand(1, 1),  # Coeffs_xy_Bottom
        0, 0, 0, #ele_SGs  size_coeffs   n_ele_micro,
        degree
    )
    No_Thick_Train = 150
    #----------------Range of Thickness/Poisson-----------------------
    SGs.min_thick = 0.05 # Minimum thickness-depend on manufacturing"s ability
    if OPT.TPMS == "Gyroid"
        SGs.max_thick = 0.25
    elseif OPT.TPMS == "Primitive"
        SGs.max_thick = 0.3
    elseif OPT.TPMS == "IWP"
        SGs.max_thick = 0.25
    end
    # =========
    # Parameters for converting from density to thickness of TPMS and initial density
    if OPT.TPMS == "Gyroid" # OPT.rho_thick = thickness/rho ==> rho = thickness/OPT.rho_thick
        OPT.rho_thick = 0.303 # Convert: rho to thickness of TPMS-sheet lattices 
    elseif OPT.TPMS == "Primitive" # thickness=OPT.rho_thick*rho
        OPT.rho_thick = 0.478
    elseif OPT.TPMS == "IWP"
        OPT.rho_thick = 0.259
    end
    # =====================

    SGs.Thick_Set_Train = range(start=SGs.min_thick, stop=SGs.max_thick, length=No_Thick_Train)
    if examples in ["Lbracket2d", "cracked_plate2d", "Vframe2d", "doubleLbracket2d", "cantilever2d", "mbb2d", "Lbracket2d_2_Loads"]
        Loads = [["E11"], ["E22"], ["E12"]]  # X-Y Normal Traction; XY-Shear Traction
        n_case = length(Loads)
    else
        Loads = [["E11"], ["E22"], ["E33"], ["E23"], ["E13"], ["E12"]]
        n_case = length(Loads)
    end

    SGs.n_case = (n_case)

    name_model = TPMS * "_Micro"    # Model TPMS"s name
    # --------------------------------------------------------
    Faces_Shell = [["Top"], ["Bottom"]]
    for i_face in 1:2
        Face_i = join(Faces_Shell[i_face])
        if Face_i == "Top"
            for i_load in 1:n_case
                Load_Case = join(Loads[i_load])
                File_Name_Coeffs = name_model * "_" * Load_Case * "_" * opti_methods * "_Degree_" * string(degree) * "_" * Scaler_Name * "_" * string(No_Thick_Train) * "_Thick_Set_"
                #----------------------------------------------------------------------
                Coeffs_x_icase = CSV.read("Data_SGs/" * File_Name_Coeffs * "Coeffs_11_" * Face_i * ".csv", DataFrame, header=false)
                index_iload = Int.((i_load-1)*size(Coeffs_x_icase, 1).+1:(i_load-1)*size(Coeffs_x_icase, 1)+size(Coeffs_x_icase, 1))
                if i_load == 1
                    SGs.Coeffs_x_Top = zeros(size(Coeffs_x_icase, 1) * n_case, size(Coeffs_x_icase, 2))
                    SGs.Coeffs_y_Top = zeros(size(Coeffs_x_icase, 1) * n_case, size(Coeffs_x_icase, 2))
                    SGs.Coeffs_xy_Top = zeros(size(Coeffs_x_icase, 1) * n_case, size(Coeffs_x_icase, 2))
                end
                SGs.Coeffs_x_Top[index_iload, :] .= Coeffs_x_icase
                #----------------------------------------------------------------------
                Coeffs_y_icase = CSV.read("Data_SGs/" * File_Name_Coeffs * "Coeffs_22_" * Face_i * ".csv", DataFrame, header=false)
                SGs.Coeffs_y_Top[index_iload, :] .= Coeffs_y_icase
                #----------------------------------------------------------------------
                Coeffs_xy_icase = CSV.read("Data_SGs/" * File_Name_Coeffs * "Coeffs_12_" * Face_i * ".csv", DataFrame, header=false)
                SGs.Coeffs_xy_Top[index_iload, :] .= Coeffs_xy_icase
                #----------------------------------------------------------------------
            end
        elseif Face_i == "Bottom"
            for i_load in 1:n_case
                Load_Case = join(Loads[i_load])
                File_Name_Coeffs = name_model * "_" * Load_Case * "_" * opti_methods * "_Degree_" * string(degree) * "_" * Scaler_Name * "_" * string(No_Thick_Train) * "_Thick_Set_"
                #----------------------------------------------------------------------
                Coeffs_x_icase = CSV.read("Data_SGs/" * File_Name_Coeffs * "Coeffs_11_" * Face_i * ".csv", DataFrame, header=false)
                index_iload = Int.((i_load-1)*size(Coeffs_x_icase, 1).+1:(i_load-1)*size(Coeffs_x_icase, 1)+size(Coeffs_x_icase, 1))
                if i_load == 1
                    SGs.Coeffs_x_Bottom = zeros(size(Coeffs_x_icase, 1) * n_case, size(Coeffs_x_icase, 2))
                    SGs.Coeffs_y_Bottom = zeros(size(Coeffs_x_icase, 1) * n_case, size(Coeffs_x_icase, 2))
                    SGs.Coeffs_xy_Bottom = zeros(size(Coeffs_x_icase, 1) * n_case, size(Coeffs_x_icase, 2))
                end
                SGs.Coeffs_x_Bottom[index_iload, :] .= Coeffs_x_icase
                #----------------------------------------------------------------------
                Coeffs_y_icase = CSV.read("Data_SGs/" * File_Name_Coeffs * "Coeffs_22_" * Face_i * ".csv", DataFrame, header=false)
                SGs.Coeffs_y_Bottom[index_iload, :] .= Coeffs_y_icase
                #----------------------------------------------------------------------
                Coeffs_xy_icase = CSV.read("Data_SGs/" * File_Name_Coeffs * "Coeffs_12_" * Face_i * ".csv", DataFrame, header=false)
                SGs.Coeffs_xy_Bottom[index_iload, :] .= Coeffs_xy_icase
                #----------------------------------------------------------------------
            end
        end
    end
    # #-----------------------
    SGs.ele_SGs = Int.(size(SGs.Coeffs_x_Bottom, 1) / SGs.n_case)
    SGs.size_coeffs = Int.((size(SGs.Coeffs_x_Bottom, 2)))
    if n_case == 3
        SGs.n_ele_micro = Int.((SGs.ele_SGs * 4))
    elseif n_case == 6
        SGs.n_ele_micro = Int.((SGs.ele_SGs * 8))
    end
    return SGs, OPT
end