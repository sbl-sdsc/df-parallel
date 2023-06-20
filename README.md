# df-parallel

This repo demonstrates how to setup CONDA environments for popular Dataframe libraries and process large tabular data files.

It compares parallel and out-of-core (data that are too large to fit into the computer's memory) reading and processing of large datasets on CPU and GPU.

| Dataframe Library | Parallel | Out-of-core | CPU/GPU |
| ------------------| -------- | ----------- | ------- |
| Pandas      | no      | no [1]  | CPU |
| Dask        | yes     | yes | CPU |
| Spark       | yes     | yes | CPU |
| cuDF        | yes     | no  | GPU |
| Dask-cuDF   | yes     | yes | GPU |

[1] Pandas can read data in chunks, but they have to be processed independently.

## Running Jupyter Lab locally
------
Prerequisites: Miniconda3 (light-weight, preferred) or Anaconda3 and Mamba

* Install [Miniconda3](https://docs.conda.io/en/latest/miniconda.html)
* Install Mamba: ```conda install mamba -n base -c conda-forge```
------

1. Clone this git repository

```
git clone https://github.com/sbl-sdsc/df-parallel.git
```
2. Create CONDA environment

```
mamba env create -f df-parallel/environment.yml
```
3. Activate the CONDA environment

```
conda activate df-parallel
```
4. Launch Jupyter Lab

```
jupyter lab
```

5. Deactivate the CONDA environment

```
conda deactivate
```

------
> To remove the CONDA environment, run ```conda env remove -n df-parallel```
------


## Running Jupyter Lab on SDSC Expanse
To launch Jupyter Lab on [Expanse](https://www.sdsc.edu/services/hpc/expanse/), use the [galyleo](https://github.com/mkandes/galyleo#galyleo) script. Specify your XSEDE account number with the --account option.

1. Clone this git repository

```
git clone https://github.com/sbl-sdsc/df-parallel.git
```


2a. Run on CPU (Pandas, Dask, and Spark dataframes):
```
galyleo launch --account <account_number> --partition shared --cpus 10 --memory 20 --time-limit 00:30:00 --conda-env df-parallel --conda-yml "${HOME}/df-parallel/environment.yml"  --mamba
```

2b. Run on GPU (required for cuDF and Dask-cuDF dataframes):
```
galyleo launch --account <account_number> --partition gpu-shared --cpus 10 --memory 92 --gpus 1 --time-limit 00:30:00 --conda-env df-parallel-gpu --conda-yml "${HOME}/df-parallel/environment-gpu.yml" --mamba
```

## Creating a packed Conda Environment on SDSC Expanse
If a Conda environment will be used frequently, a Conda environment can be created once and packed. A packed Conda Environment can be moved, from example for the home directory to a scratch directory on an Expanse compute node. A regular Conda Environment cannot be moved.

Download pack script
```
wget https://raw.githubusercontent.com/sbl-sdsc/df-parallel/main/pack.sh
chmod +x pack.sh
```

Create a packed Conda environment for CPU:
```
./pack.sh --account <account_number> --conda-env df-parallel --conda-yml "${HOME}/df-parallel/environment.yml"
```
This command will generate the packed Conda environment ```df-parallel.tar.gz```

Create a packed Conda environment for GPU:
```
./pack.sh --account <account_number> --conda-env df-parallel-gpu --conda-yml "${HOME}/df-parallel/environment_gpu.yml"
```
This command will generate the packed Conda environment ```df-parallel-gpu.tar.gz```

## Running Jupyter Lab with a packed Conda Environment on SDSC Expanse
Run on CPU:
```
galyleo launch --account <account_number> --partition shared --cpus 10 --memory 20 --time-limit 00:30:00 --conda-env df-parallel --conda-pack "${HOME}/df-parallel.tar.gz"
```

Run on GPU (required for cuDF and Dask-cuDF):
```
galyleo launch --account <account_number> --partition gpu-shared --cpus 10 --memory 92 --gpus 1 --time-limit 00:30:00 --conda-env df-parallel-gpu --conda-pack "${HOME}/df-parallel-gpu.tar.gz"
```

## Running Jupyter Lab on Google Colab
[![DownloadData](https://img.shields.io/badge/Launch-DownloadData-blue)](http://colab.research.google.com/github/pwrose/df-parallel/blob/master/notebooks/1-DownloadData_colab.ipynb)

[![PandasDataframe](https://img.shields.io/badge/Launch-PandasDataframe-blue)](http://colab.research.google.com/github/pwrose/df-parallel/blob/master/notebooks/2-PandasDataframe_colab.ipynb)

## Running the example notebooks
After Jupyter Lab has been launched, run the Notebook [1-DownloadData.ipynb](1-DownloadData.ipynb) to create a dataset. In this notebook, specify the number of copies (`ncopies`) to be made from the orignal dataset to increase its size. By default, a single copy (~5.4 GB) is created. After the dataset has been created, run the dataframe specific notebooks. Note, the cuDF and Dask-cuDF dataframe libraries require a GPU.

## Test results (not representative)
Results for running on SDSC [Expanse GPU node](https://www.sdsc.edu/support/user_guides/expanse.html) with 10 CPU cores (Intel Xeon Gold 6248 2.5 GHz), 1 GPU (NVIDIA V100 SMX2), and 92 GB of memory (DDR4 DRAM), local storage (1.6 TB Samsung PM1745b NVMe PCIe SSD).

Datafile size (gene_info.tsv): 

* Dataset 1: 5.4 GB (18 GB in Pandas)
* Dataset 2: 21.4 GB (4 x Dataset 1) (62.4 GB in Pandas)
* Dataset 3: 43.7 GB (8 x Dataset 1)

| Dataframe Library | time(5.4 GB) (s) | time(21.4 GB) (s) | time(43.7 GB) (s) | Parallel | Out-of-core | CPU/GPU |
| -----------------| ----------------: | ----------------: | ----------------: |--------- | ----------- | ------- |
| Pandas            | 56.3 |222.4   | -- [2] | no       | no  | CPU |
| Dask              | 15.7 | 42.1   | 121.8  | yes      | yes | CPU |
| Spark             | 14.2 | 31.2   |  56.5  | yes      | yes | CPU |
| cuDF              |  3.2 | -- [2] | -- [2] | yes      | no  | GPU |
| Dask-cuDF         |  7.3 | 11.9   | 19.0   | yes      | yes | GPU |

[2] out of memory
