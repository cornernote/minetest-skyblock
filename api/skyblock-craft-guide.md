---
layout: default
title: Skyblock Craft Guide
heading: Skyblock Craft Guide
permalink: /api/skyblock-craft-guide/
---


## Source Code

[skyblock_craft_guide/skyblock.craft_guide.lua](https://github.com/cornernote/minetest-skyblock/blob/master/skyblock_craft_guide/skyblock.craft_guide.lua)


## Methods

### `skyblock.craft_guide.on_receive_fields()`

Hook to handle when player submits a formspec action.

```
skyblock.craft_guide.on_receive_fields(player, formname, fields)
```

### `skyblock.craft_guide.image_button_link()`

Render an image button for a formspec.

```
skyblock.craft_guide.image_button_link(stack_string)
```
