include("inputs_Lbracket2d.jl")
include("inputs_cracked_plate2d.jl")
include("inputs_Vframe2d.jl")
include("inputs_doubleLbracket2d.jl")
include("inputs_cantilever3d.jl")
include("inputs_cantilever2d.jl")
include("inputs_mbb2d.jl")
include("inputs_Lbracket2d_2_Loads.jl")
include("inputs_3points_bending.jl")

function get_inputs(OPT::OPT_struct, FE::FE_struct)
    # Create a Person instance with default values
    # Create an instance of FE_mesh_input
    #"Lbracket2d"; "cracked_plate2d"; "Vframe2d"; "cantilever3d"; "doubleLbracket2d"
    if OPT.examples == "Lbracket2d"   # Name of model
        OPT, FE = inputs_Lbracket2d(OPT, FE)
    elseif OPT.examples == "Lbracket2d_2_Loads"   # Name of model
        OPT, FE = inputs_Lbracket2d_2_Loads(OPT, FE)
    elseif OPT.examples == "cantilever2d"   # Name of model
        OPT, FE = inputs_cantilever2d(OPT, FE)
    elseif OPT.examples == "mbb2d"   # Name of model
        OPT, FE = inputs_mbb2d(OPT, FE)
    elseif OPT.examples == "cracked_plate2d"   # Name of model
        OPT, FE = inputs_cracked_plate2d(OPT, FE)
    elseif OPT.examples == "Vframe2d"   # Name of model
        OPT, FE = inputs_Vframe2d(OPT, FE)
    elseif OPT.examples == "doubleLbracket2d"   # Name of model
        OPT, FE = inputs_doubleLbracket2d(OPT, FE)
    elseif OPT.examples == "cantilever3d"   # Name of model
        OPT, FE = inputs_cantilever3d(OPT, FE)
    elseif OPT.examples == "PennState_3points_bending"   # Name of model
        OPT, FE = inputs_3points_bending(OPT, FE)
    end


    return OPT, FE
end