#!/bin/bash
# Batch script to run Jupyter Notebooks on Expanse GPU node.
#SBATCH --account=gue998
#SBATCH --reservation=CIML23GPU2
#SBATCH --qos=gpu-shared-eot
#SBATCH --time=00:15:00
#SBATCH --partition=gpu-shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --gpus=1
#SBATCH --mem=92G
#SBATCH --job-name=df-parallel
#SBATCH --output %x.%j.%N.out
#SBATCH --error %x.%j.%N.err
#SBATCH --export=ALL

# set gpu environment
module purge
module load slurm
module load gpu 

# specify name of Conda environment, paths to Git repository, environment.yml file,
# notebook directory and a results directory
CONDA_ENV=df-parallel-gpu
REPO_DIR=${HOME}/df-parallel
CONDA_YML="${REPO_DIR}/environment-gpu.yml"
NOTEBOOK_DIR="${REPO_DIR}/notebooks"
RESULT_DIR="${NOTEBOOK_DIR}/results"

# create path to node local scratch directory
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

# activate conda environment
conda activate ${CONDA_ENV}

cd ${NOTEBOOK_DIR}
rm -rf "${RESULT_DIR}"
mkdir -p "${RESULT_DIR}"

# download dataset
papermill 1-FetchDataCIML2023.ipynb "${RESULT_DIR}"/1-FetchDataCIML2023.ipynb

# run the following notebooks using the parquet file format as input:

# 2-PandasDataframe.ipynb
papermill 2-PandasDataframe.ipynb "${RESULT_DIR}"/2-PandasDataframe_parquet.ipynb -p file_format parquet
# 3-DaskDataframe.ipynb
papermill 3-DaskDataframe.ipynb "${RESULT_DIR}"/3-DaskDataframe_parquet.ipynb -p file_format parquet
# 4-SparkDataframe.ipynb
papermill 4-SparkDataframe.ipynb "${RESULT_DIR}"/4-SparkDataframe_parquet.ipynb -p file_format parquet
# 5-CudaDataframe.ipynb
papermill 5-CudaDataframe.ipynb "${RESULT_DIR}"/5-CudaDataframe_parquet.ipynb -p file_format parquet
# 6-DaskCudaDataframe.ipynb
papermill 6-DaskCudaDataframe.ipynb "${RESULT_DIR}"/6-DaskCudaDataframe_parquet.ipynb -p file_format parquet

# deactivate the conda environment
conda deactivate

