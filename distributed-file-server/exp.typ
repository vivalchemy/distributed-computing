#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm) )

#import "../utils.typ" : rubric

#let code(filename, lang, desc: none) = {
  let desc = if desc != none {
    text(size: 10pt, weight: "bold", fill: rgb("666"))[\: #desc]
  } else { none }

  block(stroke: 1pt + gray, inset: 10pt, radius: 10pt)[
    === #filename #desc
    #line(length: 100%, stroke: 1pt + gray)

    #raw(read(filename), lang: lang)
  ]
}

#rubric(7, "Implement a Distributed File Server", dateOfPerformance: datetime(year:2025, month: 11, day:20))

#pagebreak()


== Aim

Implement a distributed file server that can be used to store and retrieve files from a cluster of machines.

== Code

*FILESYSTEM:*

```sh
.
├── chunk/
│   ├── chunk_data/
│   │   ├── chunk_{0..f}/ # directories to store the files of each chunk
│   └── chunk_server.py # the server that manages the chunks
├── client/ 
│   └── index.html # web client to view files and the chunk status
├── logs/
│   ├── chunk_{0..f}.log # logs for each chunk
│   └── master.log # logs for the master server
├── Makefile # makefile to setup and run the project 
├── master/
│   ├── file_index.json # the index of the files
│   └── master_server.py # the master server that manages the chunks
├── pyproject.toml # python project configuration
├── uploads/ # the temporary directory to store the files uploaded
└── uv.lock

```

#code("./Makefile", "Makefile")
#code("./pyproject.toml", "toml")
#code("./master/master_server.py", "py")
#code("./chunk/chunk_server.py", "py")
#code("./client/index.html", "html")

== Running the code

To run the code you need to have `Python` and `make` `uv(optional)` installed. Then, run the following commands:

```sh
make setup 
make run
```

If `uv` is not installed, you can run the following commands:

```sh
mkdir -p master chunk ./chunk/chunk_data chunk_pids logs
pip install -r requirements.txt
make run
```

#pagebreak()

== Output
#image("./assets/SS_2025-11-29 23-50-54.png")
#image("./assets/SS_2025-11-29 23-50-59.png")
#image("./assets/SS_2025-11-29 23-51-04.png")
#image("./assets/SS_2025-11-29 23-51-11.png")
#image("./assets/SS_2025-11-29 23-51-18.png")
#image("./assets/SS_2025-11-29 23-52-17.png")
#image("./assets/SS_2025-11-29 23-52-34.png")
#image("./assets/SS_2025-11-29 23-52-38.png")
#image("./assets/SS_2025-11-29 23-52-44.png")
#image("./assets/SS_2025-11-29 23-53-52.png")
#image("./assets/SS_2025-11-29 23-55-19.png")

#pagebreak()
== Removing a node to show failover to backup nodes
#image("./assets/SS_2025-11-29 23-56-14.png")
#image("./assets/SS_2025-11-29 23-56-32.png")
#image("./assets/SS_2025-11-29 23-57-17.png")

== Simplified file index on master node
#image("./assets/SS_2025-11-29 23-58-01.png")

#pagebreak()

== Postlab

+ *Difference between HDFS and SPARK*

  #block(width: 80%)[
    #table(
      fill: (x, y) => if y == 0 { gray.lighten(40%) },
      columns: (auto, auto),

      [HDFS], [Spark],

      [- Stands for Hadoop Distributed File System.],
      [- An open-source distributed computing system.],

      [- Supports batch, interactive, and streaming workloads.],
      [- Focuses on batch processing and data storage reliability.],

      [- A distributed storage system for storing large datasets across multiple machines.],
      [- Focuses on fast in-memory data processing.],

      [- Uses MapReduce for processing, which can be slower for iterative tasks.],
      [- Provides APIs in Java, Scala, Python, and R.],
    )
  ]

+ *Explain the Apache Spark architecture*

  #sym.arrow.double Apache Spark Architecture consists of the following components:

  - Driver Program: 
     - The main program that defines the Spark application and creates the SparkContext.
     - Coordinates tasks and keeps track of their execution.

  - Cluster Manager: 
     - Manages resources across the cluster.
     - Examples: YARN, Mesos, Kubernetes, or Spark’s standalone cluster manager.

  - Workers/Executor Nodes: 
     - Nodes that execute tasks assigned by the driver.
     - Each executor runs tasks and keeps data in memory for fast access.

  - Tasks and Jobs: 
     - A job is divided into smaller tasks which run in parallel across executors.
     - Tasks perform computation on partitions of the data.

  - RDD/DataFrames: 
     - Resilient Distributed Datasets (RDDs) or DataFrames represent distributed collections of data.
     - Spark operations transform or act on these datasets efficiently.

  - DAG Scheduler: 
     - Converts jobs into stages and tasks.
     - Optimizes execution by building a Directed Acyclic Graph (DAG) of stages.

  - Cluster Communication: 
     - Executors communicate results back to the driver.
     - Spark uses in-memory computation to reduce disk I/O and speed up processing.
