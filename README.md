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

[1] Pandas can read data in chunks, but they have to be processed independenly.

## Running Jupyter Lab locally
1. Clone this git repository

```
git clone https://github.com/pwrose/df-parallel.git
```
2. Create CONDA environment

```
conda env create -f df-parallel/environment.yml
```
3. Activate the CONDA environment

```
conda activate df-parallel
```
4. Launch Jupyter Lab

```
jupyter lab
```

## Running Jupyter Lab on SDSC Expanse
To launch Jupyter Lab on [Expanse](https://www.sdsc.edu/services/hpc/expanse/), use the [galyleo](https://github.com/mkandes/galyleo#galyleo) script. Specify your XSEDE account number with the --account option.

Run on CPU:
```
galyleo launch --account <account_number> --partition shared --cpus 10 --memory 20 --time-limit 00:30:00 --conda-env df-parallel --conda-yml "${HOME}/df-parallel/environment.yml"  --mamba
```

Run on GPU (required for cuDF and Dask-cuDF):
```
galyleo launch --account <account_number> --partition gpu-shared --cpus 10 --memory 93 --gpus 1 --time-limit 00:30:00 --conda-env df-parallel-gpu --conda-yml "${HOME}/df-parallel/environment_gpu.yml" --mamba
```

## Running the example notebooks
After Jupyter Lab has been launched, run the Notebook [1-DownloadData.ipynb](1-DownloadData.ipynb) to create a dataset. In this notebook, specify the number of copies (`ncopies`) to be made from the orignal dataset to increase its size. By default, a single copy (~5.4 GB) is created. After the dataset has been created, run the dataframe specific notebooks. Note, the cuDF and Dask-cuDF dataframe libraries require a GPU.

## Test results (not representative)
Results for running on SDSC [Expanse GPU node](https://www.sdsc.edu/support/user_guides/expanse.html) with 10 CPU cores (Intel Xeon Gold 6248 2.5 GHz), 1 GPU (NVIDIA V100 SMX2), and 93 GB of memory (DDR4 DRAM), local storage (1.6 TB Samsung PM1745b NVMe PCIe SSD).

Datafile size: 21.4 GB (`ncopies=4`)
In-memory size (Pandas): 62.4 GB

| Dataframe Library | time (s) | Parallel | Out-of-core | CPU/GPU |
| ------------------| -------- | -------- |---- | ------- |
| Pandas            | 222.4    | no       | no  | CPU |
| Dask              | 42.1     | yes      | yes | CPU |
| Spark             | 31.2     | yes      | yes | CPU |
| cuDF              | -- [2]   |yes       | no  | GPU |
| Dask-cuDF         | 11.9     |yes       | yes | GPU |

[2] out of memory