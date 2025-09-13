# Thalamocortical System Simulation with Distributed-Delay Neural Mass Model (DD-NMM)

This repository provides the implementation of a **Thalamocortical Neural Mass Model** based on the **Distributed-Delay Neural Mass Model (DD-NMM)** introduced in our NeuroImage 2023 paper:

> González-Mitjans, A., Paz-Linares, D., López-Naranjo, C., Areces-González, A., Li, M., Wang, Y., García-Reyes, R., Bringas-Vega, M.L., Minati, L., Evans, A.C., Valdés-Sosa, P.A. (2023).  
> **Accurate and Efficient Simulation of Very High-Dimensional Neural Mass Models with Distributed-Delay Connectome Tensors.** *NeuroImage, 274*, 120137.  
> https://doi.org/10.1016/j.neuroimage.2023.120137

---

## About

This code implements a **thalamocortical extension of the DD-NMM**, enabling the study of:
- Cortico-thalamic and thalamo-reticular interactions  
- The role of distributed conduction delays in shaping oscillatory dynamics  
- Emergent behaviors such as **alpha rhythms** and **split alpha peaks**  

The implementation follows the tensor-based formulation and Local Linearization integration scheme described in the paper.

---

## Features
- Simulation of **thalamocortical circuits** using DD-NMM  
- Incorporates **distributed conduction delays**  
- Modular structure for extending to large-scale connectomes  
- Reproducible examples to study oscillatory dynamics  

---

## Citation

If you use this repository in your research, please cite:

**Paper:**
```bibtex
@article{GonzalezMitjans2023_DDNMM,
  title   = {Accurate and Efficient Simulation of Very High-Dimensional Neural Mass Models with Distributed-Delay Connectome Tensors},
  journal = {NeuroImage},
  volume  = {274},
  pages   = {120137},
  year    = {2023},
  doi     = {10.1016/j.neuroimage.2023.120137},
  author  = {González-Mitjans, Anisleidy and Paz-Linares, Deirel and López-Naranjo, Carlos and Areces-Gonzalez, Ariosky and Li, Min and Wang, Ying and García-Reyes, Ronaldo and Bringas-Vega, Maria L. and Minati, Ludovico and Evans, Alan C. and Valdés-Sosa, Pedro A.}
}

**Software Repository:**
```bibtex
@software{Thalamocortical_DDNMM_2025,
  author       = {González-Mitjans, Anisleidy},
  title        = {Thalamocortical System Simulation with Distributed-Delay Neural Mass Model (DD-NMM)},
  year         = {2025},
  url          = {https://github.com/anisleidygm/Thalamocortical_System_DDNMM}
}
