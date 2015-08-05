---
layout: default
title: Skyblock
heading: Skyblock
permalink: /api/skyblock/
---


## Source Code

[skyblock/skyblock.lua](https://github.com/cornernote/minetest-skyblock/blob/master/skyblock/skyblock.lua)


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

### `skyblock.world_bottom_node`

Node to use for the world bottom

```
skyblock.world_bottom_node = 'air'
```

Nodes above the spawn node where players are spawned

### `skyblock.dig_new_spawn`

Should digging the spawn result in a new spawn pos?

```
skyblock.dig_new_spawn = false
```

### `skyblock.lose_bags_on_death`

Should player lose bags on death?

```
skyblock.lose_bags_on_death = false
```

### `skyblock.schem`

Which schem file to use for starting island

```
skyblock.schem = island.schem
```

### `skyblock.schem_offset_x`

Schem offset X

```
skyblock.schem_offset_x = -3
```

### `skyblock.schem_offset_y`

Schem offset Y

```
skyblock.schem_offset_y = -4
```

### `skyblock.schem_offset_z`

Schem offset Z

```
skyblock.schem_offset_z = -3
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
