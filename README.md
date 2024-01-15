# MdTools

Markdown Processing MdTools

Written for personal experimentation - this code will have bugs and is not
intended for production use.

Main functions:

- splitter - split markdown documents into chunks based on section delimeters 
- FTS (Full Text Search) indexer, file watcher and restful JSON api 
- VSS (Vector Similarity Search) indexer, file watcher and restful JSON api  

The database backend used for FTS and VSS is Sqlite3. 

## FTS 

Schema: 
- filepath, doctitle, sectitle, body, start_line

## VSS

Schema: 
- filepath, doctitle, sectitle, body, start_line
- v_filepathv, v_doctitle, v_sectitle, v_body

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

VSS operations will benefit from a GPU.  Presence of a GPU is auto-detected.
Only Nvidia GPUs are supported. A RTX3060-class GPU can increase the speed of
embedding generation 100X.

