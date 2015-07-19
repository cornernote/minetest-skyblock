---
layout: default
title: Documentation
heading: Documentation
permalink: /docs/
---

## Multi-Player Support

Although the default settings will work, you may want to consider the starting positions.

Each player is given a unique spawn position in an outwards spriral.

If `skyblock.WORLD_WIDTH=5` then players will be assigned in the following positions:

(looking down)

```
x+5|  21  22  23  24  25
   |
x+4|  20  07  08  09  10
   |
x+3|  19  06  01  02  11
   |
x+2|  18  05  04  03  12
   |                        <-- The distance between the players is
x+1|  17  16  15  14  13        defined by skyblock.START_GAP
   +--------------------
     z+1 z+2 z+3 z+4 z+5
```


## Ocean Mode

Inside config.lua you can set `skyblock.MODE` to either water or lava to create an endless ocean around your starting island.


## Other Options

Have a peek inside the `config.lua` to see other things you can change.
