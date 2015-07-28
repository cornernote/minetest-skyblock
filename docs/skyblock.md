---
layout: default
title: Skyblock API
heading: Skyblock API
permalink: /docs/skyblock/
---

## Variables

Variables can be set in the `minetest.conf` file.


### `skyblock.debug`

Debug mode

```
skyblock.debug = false
```

### `skyblock.start_gap`

How far apart to set players start positions

```
skyblock.start_gap = 32
```

### `skyblock.start_height`

The Y position the quest nodes will appear

```
skyblock.start_height = 4
```

### `skyblock.world_width`

How many players will be in 1 row
skyblock.world_width * skyblock.world_width = total players

```
skyblock.world_width = 100
```

How far down (in nodes) before a player dies and is respawned

### `skyblock.world_bottom`

```
skyblock.world_bottom = -8
```

Nodes above the spawn node where players are spawned

### `skyblock.spawn_height`

```
skyblock.spawn_height = 4
```

### `skyblock.filename`

File path and prefix for data files

```
skyblock.filename = 'skyblock'
```

## Methods

### `skyblock.log()`

log a message to the console

```
skyblock.log(message)
```

### `skyblock.dump_pos()`

dump_pos convert a pos to a string

```
skyblock.dump_pos(pos)
```

### `skyblock.get_spawn()`

get players spawn position

```
skyblock.get_spawn(player_name)
```

### `skyblock.set_spawn()`

set players spawn position

```
skyblock.set_spawn(player_name, pos)
```

### `skyblock.get_next_spawn()`

get next spawn position

```
skyblock.get_next_spawn()
```

### `skyblock.spawn_player()`

handle player spawn setup

```
skyblock.spawn_player(player)
```

### `skyblock.make_spawn_blocks()`

build spawn block

```
skyblock.make_spawn_blocks(pos, player_name)
```

### `skyblock.registered()`

gets a registered node

```
skyblock.registered(case,name)
```
