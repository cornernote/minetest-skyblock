---
layout: default
title: Skyblock Levels
heading: Skyblock Levels
permalink: /api/skyblock-levels/
---


## Variables

### `skyblock.levels.dig_new_spawn`

Should digging the spawn result in a new spawn pos?

```
skyblock.levels.dig_new_spawn = false
```

## Methods

### `skyblock.levels.give_initial_items()`

Give the player initial items.

```
skyblock.levels.give_initial_items(player)
```

### `skyblock.levels.check_inventory()`

Checks if the players inventory matches the items given in `give_initial_items()`.  Used to prevent death when they join the server.

```
skyblock.levels.check_inventory(player)
```

### `skyblock.levels.empty_inventory()`

Empties the players inventory.  Used when they are respawned.

```
skyblock.levels.empty_inventory(player)
```

### `skyblock.levels.get_formspec()`

Gets the formspec for players inventory and quest node.

```
skyblock.levels.get_formspec(player_name)
```

### `skyblock.levels.get_inventory_formspec()`

Gets the partial formspec that represents the inventory, crafts, rewards, etc

```
skyblock.levels.get_inventory_formspec(level,player_name)
```

### `skyblock.levels.get_feat_formspec()`

Gets the partial formspec that represents a single feat.

```
skyblock.levels.get_feat_formspec(data,i,feat,required,text,hint)
```

### `skyblock.levels.make_sphere()`

Creates a hollow sphere in the world.

```
skyblock.levels.make_sphere(pos,radius,nodename,hollow)
```

### `skyblock.levels.reward_feat()`

Gives player a reward when a feat is achieved.

```
skyblock.levels.reward_feat(feats,player_name,feat)
```

### `skyblock.levels.on_dignode()`

Tracks diffing feats.

```
skyblock.levels.on_dignode(feats,pos,oldnode,digger)
```

### `skyblock.levels.on_placenode()`

Tracks placing feats.

```
skyblock.levels.on_placenode(feats,pos,newnode,placer,oldnode)
```

### `skyblock.levels.on_item_eat()`

Tracks eating feats.

```
skyblock.levels.on_item_eat(feats,player_name,itemstack)
```

### `skyblock.levels.bucket_on_use()`

Tracks bucket feats.

```
skyblock.levels.bucket_on_use(feats,player_name,pointed_thing)
```

### `skyblock.levels.bucket_water_on_use()`

Tracks bucket_water feats.

```
skyblock.levels.bucket_water_on_use(feats,player_name,pointed_thing)
```

### `skyblock.levels.bucket_lava_on_use()`

Tracks bucket_lava feats.

```
skyblock.levels.bucket_lava_on_use(feats,player_name,pointed_thing)
```

