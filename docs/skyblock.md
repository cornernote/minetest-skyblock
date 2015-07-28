---
layout: default
title: Skyblock API
heading: Skyblock API
permalink: /docs/skyblock/
---

## Variables

Variables can be set in the `minetest.conf` file.


Debug mode

```
skyblock.debug = false
```

How far apart to set players start positions

```
skyblock.start_gap = 32
```

The Y position the quest nodes will appear

```
skyblock.start_height = 4
```

How many players will be in 1 row
skyblock.world_width * skyblock.world_width = total players

```
skyblock.world_width = 100
```

How far down (in nodes) before a player dies and is respawned

```
skyblock.world_bottom = -8
```

Nodes above the spawn node where players are spawned

```
skyblock.spawn_height = 4
```

File path and prefix for data files

```
skyblock.filename = 'skyblock'
```

## Methods

log a message to the console

```
skyblock.log(message)
```

dump_pos convert a pos to a string

```
skyblock.dump_pos(pos)
```

get players spawn position

```
skyblock.get_spawn(player_name)
```

set players spawn position

```
skyblock.set_spawn(player_name, pos)
```

get next spawn position

```
skyblock.get_next_spawn()
```

handle player spawn setup

```
skyblock.spawn_player(player)
```

build spawn block

```
skyblock.make_spawn_blocks(pos, player_name)
```

gets a registered node

```
skyblock.registered(case,name)
```
