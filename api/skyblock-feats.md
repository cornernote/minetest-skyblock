---
layout: default
title: Skyblock Feats
heading: Skyblock Feats
permalink: /api/skyblock-feats/
---


## Methods

### `skyblock.feats.get_level()`

Get players current level.

```
skyblock.feats.get_level(player_name)
```

### `skyblock.feats.reset()`

Resets all feats and levels for a player.

```
skyblock.feats.reset(player_name)
```

### `skyblock.feats.update()`

Update formspecs for players inventory and quest nodes.

```
skyblock.feats.update(level,player_name)
```

### `skyblock.feats.get()`

Gets the feat count for a players feat.

```
skyblock.feats.get(level,player_name,feat)
```

### `skyblock.feats.add()`

Adds to the feat count for a players feat.

```
skyblock.feats.add(level,player_name,feat)
```

### `skyblock.feats.give_reward()`

Gives a reward to a player.

```
skyblock.feats.give_reward(level,player_name,item_name)
```

### `skyblock.feats.on_item_eat()`

Tracks eating feats.

```
skyblock.feats.on_item_eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
```

### `skyblock.feats.on_dignode()`

Tracks digging feats.

```
skyblock.feats.on_dignode(pos, oldnode, digger)
```

### `skyblock.feats.on_placenode()`

Tracks placing feats.

```
skyblock.feats.on_placenode(pos, newnode, placer, oldnode)
```

### `skyblock.feats.bucket_on_use()`

Tracks bucket feats.

```
skyblock.feats.bucket_on_use(itemstack, user, pointed_thing)
```

### `skyblock.feats.bucket_water_on_use()`

Tracks bucket_water feats.

```
skyblock.feats.bucket_water_on_use(itemstack, user, pointed_thing)
```

### `skyblock.feats.bucket_lava_on_use()`

Tracks bucket_lava feats.

```
skyblock.feats.bucket_lava_on_use(itemstack, user, pointed_thing)
```

