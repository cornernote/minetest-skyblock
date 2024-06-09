--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

--[[
Level 4 mostly revolving around farming and dying
level 4 feats and rewards:

* craft_mesehoe       farming:seed_wheat
* use_hoe x40            farming:melon_slice
* plant_wheatseed        default:cactus
* craft_flour            farming:seed_cotton x10
* place_snowblock x50    dye:red x20
* dig_cactus x10         dye:white x20
* dig_geranium x5        flowers:mushroom_brown x2
* dig_tulip x5           flowers:mushroom_red x2
* dig_brownmushroom x15  farming:corn x50
* craft_ethanol          default:meselamp x5

]]--

local level = 4

--
-- PUBLIC FUNCTIONS
--

skyblock.levels[level] = {}

-- feats
-- Parts of this are purely hypothetical and not implement yet
skyblock.levels[level].feats = {
   {
      name = "Craft a mese hoe",
      hint = "farming:hoe_mese",
      feat = "craft_mesehoe",
      count = 1,
      reward = "farming:seed_wheat 2",
      craft = {"farming:hoe_mese"}
   },
   {
      name = "Use the hoe 40 times",
      hint = "farming:hoe_mese",
      feat = "use_hoe",
      count = 40,
      reward = "farming:melon_slice",
      hoeuse = {},
      use_item = "farming:hoe_mese"
   },
   {
      name = "Plant 10 wheat seeds",
      hint = "farming:seed_wheat",
      feat = "place_wheatseed",
      count = 10,
      reward = "default:cactus",
      placenode = {"farming:seed_wheat"}
   },
   {
      name = "Craft 4 lumps of flour",
      hint = "farming:flour",
      feat = "craft_flour",
      count = 4,
      reward = "farming:seed_cotton 10",
      craft = {"farming:flour"},
   },
   {
      name = "Place 50 snow blocks",
      hint = "default:snowblock",
      feat = "place_snowblock",
      count = 50,
      reward = "dye:red 20",
      placenode = {"default:snowblock"},
   },
   {
      name = "Dig 10 cacti",
      hint = "default:cactus",
      feat = "dig_cactus",
      count = 10,
      reward = "dye:white 20",
      dignode = {"default:cactus"},
   },
   {
      name = "Pick 5 Geranium flowers",
      hint = "flowers:geranium",
      feat = "dig_geranium",
      count = 5,
      reward = "flowers:mushroom_brown 2",
      dignode = {"flowers:geranium"},
   },
   {
      name = "Pick 5 orange tulips",
      hint = "flowers:tulip",
      feat = "dig_tulip",
      count = 5,
      reward = "flowers:mushroom_red 2",
      dignode = {"flowers:tulip"},
   },
   {
      name = "Dig 10 brown mushrooms",
      hint = "flowers:mushroom_brown",
      feat = "dig_brownmushroom",
      count = 10,
      reward = "farming:corn",
      dignode = {"flowers:mushroom_brown"},
   },
   {
      name = "Make ethanol!",
      hint = "farming:corn",
      feat = "craft_ethanol",
      count = 1,
      reward = "default:meselamp 5",
      craft = {"farming:bottle_ethanol"},
   }
}

-- init level
skyblock.levels[level].init = function(player_name)
end

-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = {
		level=level,
		total=10,
		count=0,
		player_name=player_name,
		infotext='',
		formspec = '',
		formspec_quest = '',
	}

	local text = 'label[0,2.7; --== Quests ==--]'
		..'label[0,0.5; Time Goes On, '..player_name..'...]'
		..'label[0,1.0; You may wonder, traveller, where some of your]'
		..'label[0,1.5; precious items are. Be patient...]'
		..'label[0,2.0; They will come to you in time...]'

	info.formspec = skyblock.levels.get_inventory_formspec(level,info.player_name,true)..text
	info.formspec_quest = skyblock.levels.get_inventory_formspec(level,info.player_name)..text

	for k,v in ipairs(skyblock.levels[level].feats) do
		info.formspec = info.formspec..skyblock.levels.get_feat_formspec(info,k,v.feat,v.count,v.name,v.hint,true)
		info.formspec_quest = info.formspec_quest..skyblock.levels.get_feat_formspec(info,k,v.feat,v.count,v.name,v.hint)
	end
	if info.count>0 then
		info.count = info.count/2 -- only count once
	end

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total

	return info
end

-- Reward feats
skyblock.levels[level].reward_feat = function(player_name, feat)
   return skyblock.levels.reward_feat(level, player_name, feat)
end

-- Track node placement
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
   skyblock.levels.on_placenode(level, pos, newnode, placer, oldnode)
end

-- Track node digging
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
   skyblock.levels.on_dignode(level, pos, oldnode, digger)
end

-- track eating feats
skyblock.levels[level].on_item_eat = function(player_name, itemstack)
   skyblock.levels.on_item_eat(level, player_name, itemstack)
end

-- track crafting feats
skyblock.levels[level].on_craft = function(player_name, itemstack)
   skyblock.levels.on_craft(level, player_name, itemstack)
end

-- track hoe use
skyblock.levels[level].hoe_on_use = function(player_name, pointed_thing, wieldeditem)
   skyblock.levels.hoe_on_use(level, player_name, pointed_thing, wieldeditem)
end

skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing) end
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end
