# Julia FEM with Tri3, Quad4, Tet4, and Hex8 Elements

This repository provides a Finite Element Method (FEM) implementation in Julia, adapted from the original **MATLAB code** [MRF by jnorato](https://github.com/jnorato/MRF). While the MATLAB version did not include support for Tri3 and Tet4 elements, this Julia version extends the functionality to handle multiple element types for 2D and 3D linear elasticity problems.

## Features

* Translated from MATLAB to Julia for improved performance and readability
* Supports the following element types:

  * **Tri3**: Linear triangular element (2D)
  * **Quad4**: Linear quadrilateral element (2D)
  * **Tet4**: Linear tetrahedral element (3D)
  * **Hex8**: Linear hexahedral element (3D)
* Modular and extensible design for experimenting with new elements
* Original MRF functionality retained


## Notes

* Linear element formulations are implemented for all supported types; higher-order elements are not yet included
* Meshes can be imported as node and element arrays
* This Julia version provides better performance and readability compared to the original MATLAB code

## References

* Original MATLAB MRF code: [https://github.com/jnorato/MRF](https://github.com/jnorato/MRF)
* FEM theory: standard textbooks on linear elasticity and finite elements
