#!/bin/bash
# pack.sh creates a packed Conda environment from a Conda environment.yml file on Expanse
#
# Usage: pack.sh --account <account_number> --conda-env <name_of_conda_environment>  --conda-yml <path_to_environment.yml_file>"
# 
#
# Read in command-line options and assign input variables to local
# variables.
while (("${#}" > 0)); do
  case "${1}" in
    -A | --account )
      account="${2}"
      shift 2
      ;;
    --conda-env )
      conda_env="${2}"
      shift 2
      ;;
    --conda-yml )
      conda_yml="${2}"
      shift 2
      ;;
    *)
      echo "Command-line option ${1} not recognized or not supported."
      return 1
  esac
done

echo "pack --account ${account} --conda-env ${conda_env} --conda-yml ${conda_yml}"

# create sbatch script

sbatch <<EOT
#!/bin/bash

#SBATCH -A "${account}"
#SBATCH -p debug
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=8G
#SBATCH -t 00:30:00
#SBATCH -J conda-pack
#SBATCH -o %j.%N.out
#SBATCH -e %j.%N.err
#SBATCH --export=None

module purge
module load cpu
module load slurm

if [ ! -f "Miniconda3-latest-Linux-x86_64.sh" ]; then
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   chmod +x Miniconda3-latest-Linux-x86_64.sh
fi

export CONDA_INSTALL_PATH="/scratch/\${USER}/job_\${SLURM_JOB_ID}/miniconda3"
export CONDA_ENVS_PATH="\${CONDA_INSTALL_PATH}/envs"
export CONDA_PKGS_DIRS="\${CONDA_INSTALL_PATH}/pkgs"

echo "Conda install path \${CONDA_INSTALL_PATH}"
./Miniconda3-latest-Linux-x86_64.sh -b -p "\${CONDA_INSTALL_PATH}"
source "\${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"

conda activate base
conda install -c conda-forge mamba
conda install -c conda-forge conda-pack

mamba env create -f "${conda_yml}"

conda activate "${conda_env}"

conda pack --force

exit 0
EOT
