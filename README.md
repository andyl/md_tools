# MdTools

Markdown Processing Tools

Written for personal experimentation - this code will have bugs and is not
intended for production use.

Main functions:

- document processing: reading markdown files and directories, splitting
  documents into searchable chunks
- cache management: intermediate cache files for data (`ndjson` format) and
  vectors (`parquet` format).  
- search: FTS (Full Text Search) and VSS (Vector Similarity Search), file
  watcher and restful JSON services

The database backend used for FTS and VSS is Sqlite3. 

FTS Fields: filepath, startline, doctitle, sectitle, body, uuid, updated

VSS Fields: v_filepath, v_doctitle, v_sectitle, v_body, uuid

## Overview 

```
~/util/org 
-> org/watcher(text-gen) 
--> ~/util/org/.md_tools/data.ndjson 
---> watcher(vector-gen)
----> ~/util/org/.md_tools/data.parquet 
-----> watcher(db-load)

```

## Installation

```elixir
def deps do
  [
    {:md_tools, github: "andyl/md_tools"} 
  ]
end
```

## Supported Platforms 

This has been tested on Ubuntu 22.04 with 16 cores and 64GB of ram. 

FTS operations will run fine without a GPU.

VSS operations will benefit from a GPU.  Only Nvidia GPUs are supported. A
RTX3060-class GPU can increase the speed of embedding generation ~40X.

