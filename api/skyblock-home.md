---
layout: default
title: Skyblock Home
heading: Skyblock Home
permalink: /api/skyblock-home/
---


## Source Code

[skyblock_home/skyblock.home.lua](https://github.com/cornernote/minetest-skyblock/blob/master/skyblock_home/skyblock.home.lua)


## Methods

### `skyblock.home.on_receive_fields()`

Hook to handle when player submits a formspec action.

```
skyblock.home.on_receive_fields(player, formname, fields)
```

### `skyblock.home.set_home()`

Sets a players home position.

```
skyblock.home.set_home(player, pos)
```

### `skyblock.home.go_home()`

Moves a player to their home position.

```
skyblock.home.go_home(player)
```
