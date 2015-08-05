---
layout: default
title: Skyblock Level
heading: Skyblock Level
permalink: /api/skyblock-level/
---


## Source Code

* [skyblock_levels/skyblock.levels.1.lua](https://github.com/cornernote/minetest-skyblock/blob/master/skyblock_levels/skyblock.levels.1.lua)
* [skyblock_levels/skyblock.levels.2.lua](https://github.com/cornernote/minetest-skyblock/blob/master/skyblock_levels/skyblock.levels.2.lua)
* [skyblock_levels/skyblock.levels.3.lua](https://github.com/cornernote/minetest-skyblock/blob/master/skyblock_levels/skyblock.levels.3.lua)
* [skyblock_levels/skyblock.levels.4.lua](https://github.com/cornernote/minetest-skyblock/blob/master/skyblock_levels/skyblock.levels.4.lua)


## Methods

### `skyblock.levels[level].init()`

Initializes the level.

```
skyblock.levels[level].init(player_name)
```

### `skyblock.levels[level].get_info()`

Gets level formspec and infotext.

```
skyblock.levels[level].get_info(player_name)
```

### `skyblock.levels[level].reward_feat()`

Gives player a reward when a feat is achieved.

```
skyblock.levels[level].reward_feat(player_name)
```

### `skyblock.levels[level].on_dignode()`

Tracks digging feats.

```
skyblock.levels[level].on_dignode(pos,oldnode,digger)
```

### `skyblock.levels[level].on_placenode()`

Tracks placing feats.

```
skyblock.levels[level].on_placenode(pos,newnode,placer,oldnode)
```

### `skyblock.levels[level].on_item_eat()`

Tracks eating feats.

```
skyblock.levels[level].on_item_eat(player_name,itemstack)
```

### `skyblock.levels[level].on_craft()`

Tracks crafting feats.

```
skyblock.levels[level].on_craft(player_name,itemstack)
```

### `skyblock.levels[level].bucket_on_use()`

Tracks bucket feats.

```
skyblock.levels[level].bucket_on_use(player_name,pointed_thing)
```

### `skyblock.levels[level].bucket_water_on_use()`

Tracks bucket_water feats.

```
skyblock.levels[level].bucket_water_on_use(player_name,pointed_thing)
```

### `skyblock.levels[level].bucket_lava_on_use()`

Tracks bucket_lava feats.

```
skyblock.levels[level].bucket_lava_on_use(player_name,pointed_thing)
```
