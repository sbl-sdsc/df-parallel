# df-parallel

This repo demonstrates how to process tabular data with several dataframe libraries. 

It compares parallel and out-of-core (data that are too large to fit into the computer's memory) reading and processing of large datasets on CPU and GPU.

| Dataframe Library | Parallel | Out-of-core | CPU/GPU |
| ------------------| -------- | ----------- | ------- |
| Pandas      | no      | no [1]  | CPU |
| Dask        | yes     | yes | CPU |
| Spark       | yes     | yes | CPU |
| cuDF        | yes     | no  | GPU |
| Dask-cuDF   | yes     | yes | GPU |

[1] Pandas can read data in chunks, but they have to be processed independenly.

### Creating the benchmark dataset
Run the Notebook [1-DownloadData.ipynb](1-DownloadData.ipynb) first to create a dataset. In this notebook, specify the number of copies (`ncopies`) to be made from the orignal dataset to increase its size. By default, a single copy (~5.4 GB) is created.

### Running the benchmarks
After the dataset has been created, run the dataframe specific notebooks.

### Benchmark results (not representative)
Benchmark results for running on SDSC [Expanse GPU node](https://www.sdsc.edu/support/user_guides/expanse.html) with 10 CPU cores (Intel Xeon Gold 6248 2.5 GHz), 1 GPU (NVIDIA V100 SMX2), and 93 GB of memory (DDR4 DRAM).

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