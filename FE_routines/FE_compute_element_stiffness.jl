function FE_compute_element_stiffness(OPT::OPT_struct, FE::FE_struct)
    FE.Ce = FE.Ce * 0
    FE.Ke = FE.Ke * 0
    Ke_Ce_Update!(FE.Ce, FE.Ke, FE.B0e,   FE.n_elem, FE.dim, FE.material.E, FE.material.nu, FE.coords, FE.elem_node)
    return OPT, FE
end