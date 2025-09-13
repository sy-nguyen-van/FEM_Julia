# Julia FEM with Tri3, Quad4, Tet4, and Hex8 Elements

This repository contains a **Finite Element Method (FEM) code in Julia**, translated from the original **MATLAB code** [MRF by jnorato](https://github.com/jnorato/MRF). It now supports multiple element types for 2D and 3D linear elasticity problems.

## Features

* Translated from MATLAB to Julia for improved performance and readability
* Supports the following element types:

  * **Tri3**: Linear triangular element (2D)
  * **Quad4**: Linear quadrilateral element (2D)
  * **Tet4**: Linear tetrahedral element (3D)
  * **Hex8**: Linear hexahedral element (3D)
* Modular and extensible design for experimenting with new elements
* Original MRF functionality retained

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/your-repo.git
cd your-repo
```

2. Open Julia and activate the project:

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

3. Required packages:

```julia
using LinearAlgebra, SparseArrays, StaticArrays
```


```

## Notes

* Linear element formulations are implemented for all supported types; higher-order elements are not yet included
* Meshes can be imported as node and element arrays
* This Julia version provides better performance and readability compared to the original MATLAB code

## References

* Original MATLAB MRF code: [https://github.com/jnorato/MRF](https://github.com/jnorato/MRF)
* FEM theory: standard textbooks on linear elasticity and finite elements

## License

This project is **MIT licensed**. See [LICENSE](LICENSE) for details.
