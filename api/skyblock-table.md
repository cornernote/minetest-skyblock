---
layout: default
title: Skyblock Table
heading: Skyblock Table
permalink: /api/skyblock-table/
---

Loads and saves tables to a file.  Only saves Tables, Numbers and Strings. Insides Table References are saved.  Does not save Userdata, Metatables, Functions and indices of these


## Source Code

[skyblock/skyblock.table.lua](https://github.com/cornernote/minetest-skyblock/blob/master/skyblock/skyblock.table.lua)


## Methods

### `skyblock.table.save()`

Save Table to File

```
skyblock.table.save(table, filename)
```

### `skyblock.table.load()`

Load Table from File

```
skyblock.table.load(filename or stringtable)
```
