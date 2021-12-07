# gerbil_plague_resistance

Scripts and code for simulations used in Nilsson et al

## Slim scripts

- `gerbil_sims_exp.slim` - SLiM script for neutral simulations
- `gerbil_sims_exp_sel_v2.slim` - SLiM script for simulations with a selective sweep

## Slurm scripts

Control array scripts for running SliM simulations on a cluster

- `slim_control_array.slurm` - for neutral simulations
- `slim_control_array_sel.slurm` - for simulations with selection

## R Scripts

The `process_sims_combined.R` will take the output of the simulations and then produce the figure in the supplementary materials.
