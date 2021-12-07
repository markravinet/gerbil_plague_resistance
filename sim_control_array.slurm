#!/bin/bash

# Job name:
#SBATCH --job-name=array_slim
#
# Project:
#SBATCH --account=nn9244k
# Wall clock limit (hh:mm:ss):
#SBATCH --time=02:00:00
#
# Processor and memory usage:
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=1

# notify end of job
#SBATCH --mail-user=mark.ravinet@ibv.uio.no
#SBATCH --mail-type=FAIL

## set up job environment
module purge
module load BCFtools/1.9-intel-2018b VCFtools/0.1.16-intel-2018b-Perl-5.28.0

echo "Run number ${SLURM_ARRAY_TASK_ID}"

# run slim
slim gerbil_sims_exp.slim > test_${SLURM_ARRAY_TASK_ID}.out

# extract vcf
tail -n+15 test_${SLURM_ARRAY_TASK_ID}.out | bgzip -c > test_${SLURM_ARRAY_TASK_ID}.vcf.gz

# run vcftools calculation
vcftools --gzvcf test_${SLURM_ARRAY_TASK_ID}.vcf.gz --weir-fst-pop pop1 --weir-fst-pop pop2 --out test_${SLURM_ARRAY_TASK_ID}

#grep "weighted" test1.log | awk '{print $7}'
