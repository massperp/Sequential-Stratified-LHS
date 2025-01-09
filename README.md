# Sequential Stratified Latin Hypercube Sampling

This code provides an implementation of the Sequential Stratified Latin Hypercube Sampling method to estimate expectations of quantities of interest of the form

[<img src="./assets/QoI.png" width="150"/>](./assets/QoI.png)

where the random vector satisfies

[<img src="./assets/QoI_details.png" width="550"/>](./assets/QoI_details.png)

is a given function.

## Using the code

A Matlab implementation of the Sequential Stratified Latin Hypercube Sampling method is available in the `matlab-src` folder. The scripts rely on the `Statistics and Machine Learning Toolbox`.

### Example

A worked out example illustrating how to use the Matlab functions is available in the Matlab script [sequential\_LHS\_strat\_main.m](./matlab-src/sequential_LHS_strat_main.m) in the `matlab-src` folder.  The script shows the use of the Sequential Stratified Latin Hypercube Sampling method applied to the test functions considered in the [accompanying paper](https://arxiv.org/abs/2305.13421).

## Citing

If you benefit from this implementation, please cite the accompanying [paper](https://doi.org/10.1007/978-3-031-59762-6_19):

```
@inproceedings{KrumscheidPettersson23,
author = {S. Krumscheid and P. Pettersson},
title = {Sequential Estimation using Hierarchically Stratified Domains with Latin Hypercube Sampling},
year = {2024},
booktitle = {Monte Carlo and Quasi-Monte Carlo Methods : MCQMC 2022, Linz, Austria, July 17–22. Ed.: A. Hinrichs},
doi = {10.1007/978-3-031-59762-6_19},
publisher = {Springer International Publishing}
}
```

