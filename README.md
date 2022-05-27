# df-parallel

This repo demonstrates how to process tabular data with several dataframe libraries. 

It compares parallel and out-of-core (data that are too large to fit into the computer's memory) reading and processing of large datasets on CPU and GPU.

| Dataframe Library | Parallel | Out-of-core | CPU/GPU |
| ------------------| -------- | ----------- | ------- |
| Pandas      | no      | no`*`  | CPU |
| Dask        | yes     | yes | CPU |
| Spark       | yes     | yes | CPU |
| cuDF        | yes     | no  | GPU |
| Dask-cuDF   | yes     | yes | GPU |

`*` Pandas can read data in chunks, but they have to be processed independenly.

Run the Notebook [1-DownloadData.ipynb](1-DownloadData.ipynb) first to create a dataset. In this notebook, specify the number of copies (`ncopies`) to be made from the orignal dataset to increase its size. By default, a single copy (~5.4 GB) is created.

Then, run any of the Dataframe specific notebooks.
