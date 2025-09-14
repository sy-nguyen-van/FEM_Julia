include("inputs_Lbracket2d.jl")
include("inputs_cracked_plate2d.jl")
include("inputs_Vframe2d.jl")
include("inputs_doubleLbracket2d.jl")
include("inputs_cantilever3d.jl")
include("inputs_cantilever2d.jl")
include("inputs_mbb2d.jl")
include("inputs_Lbracket2d_2_Loads.jl")
include("inputs_3points_bending.jl")
include("inputs_Lbracket3d.jl")
function get_inputs(OPT::OPT_struct, FE::FE_struct)
    OPT, FE  = eval(Symbol("inputs_"*OPT.examples))(OPT, FE)
    return OPT, FE
end