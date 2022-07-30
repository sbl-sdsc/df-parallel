#!/bin/bash
# Batch script to run Jupyter Notebooks on Expanse CPU node.
#SBATCH -A <account_number> 
#SBATCH -p shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=20G
#SBATCH -t 00:15:00
#SBATCH -J df-parallel-batch
#SBATCH -o %j.%N.out
#SBATCH -e %j.%N.err
#SBATCH --export=ALL

module purge
module load slurm
module load cpu 

# specify name of Conda environment, path to environment.yml file, 
# notebook directory and a results directory
CONDA_ENV=df-parallel
REPO_DIR=${HOME}/df-parallel
CONDA_YML="${REPO_DIR}/environment.yml"
NOTEBOOK_DIR="${REPO_DIR}/notebooks"
RESULT_DIR="${REPO_DIR}/results"

export LOCAL_SCRATCH_DIR="/scratch/${USER}/job_${SLURM_JOB_ID}"

# download miniconds3
if [ ! -f "Miniconda3-latest-Linux-x86_64.sh" ]; then
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   chmod +x Miniconda3-latest-Linux-x86_64.sh
fi

# install miniconda3 on node local disk
export CONDA_INSTALL_PATH="${LOCAL_SCRATCH_DIR}/miniconda3"
export CONDA_ENVS_PATH="${CONDA_INSTALL_PATH}/envs"
export CONDA_PKGS_DIRS="${CONDA_INSTALL_PATH}/pkgs"
./Miniconda3-latest-Linux-x86_64.sh -b -p "${CONDA_INSTALL_PATH}"
source "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"

# use mamba to create conda environment
conda install mamba -n base -c conda-forge
mamba env create -f ${CONDA_YML}

# run notebooks using papermill
conda activate ${CONDA_ENV}
conda install papermill -c conda-forge

cd ${NOTEBOOK_DIR}
mkdir -p "${RESULT_DIR}"

papermill 1-DownloadData.ipynb "${RESULT_DIR}"/1-DownloadData.ipynb
papermill 2-PandasDataframe.ipynb "${RESULT_DIR}"/2-PandasDataframe.ipynb
papermill 3-DaskDataframe.ipynb "${RESULT_DIR}"/3-DaskDataframe.ipynb
papermill 4-SparkDataframe.ipynb "${RESULT_DIR}"/4-SparkDataframe.ipynb
