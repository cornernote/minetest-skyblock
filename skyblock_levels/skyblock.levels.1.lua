--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 1 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 1
skyblock.levels[level] = {}


-- get pos
skyblock.levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	return skyblock.has_spawn(player_name)
end


-- make start blocks
skyblock.levels[level].make_start_blocks = function(player_name)
	local pos = skyblock.levels[level].get_pos(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
end


-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = { level=level, total=10, count=0, player_name=player_name, infotext='', formspec = '' };

	info.formspec = skyblock.levels.get_inventory_formspec(level)
		..'label[0,0.5;Welcome '..player_name..', of the Sky People]'
		..'label[0,1.0;We can no longer live on the surface.]'
		..'label[0,1.5;Can you help us rebuild in the sky?]'
		..'label[0,2.0;Complete the quests to receive great rewards!]'
		..skyblock.levels.get_goal_formspec(info,1,'place_sapling',1,'craft a Sapling and grow a Tree','default:sapling')
		..skyblock.levels.get_goal_formspec(info,2,'dig_tree',16,'craft a Wooden Axe and dig 16 Trees','default:axe_wood')
		..skyblock.levels.get_goal_formspec(info,3,'place_cobble',20,'craft and place 20 Cobblestone','default:cobble')
		..skyblock.levels.get_goal_formspec(info,4,'place_chest',1,'craft and place a Chest','default:chest')
		..skyblock.levels.get_goal_formspec(info,5,'place_sign_wall',1,'craft and place a Sign','default:sign_wall')
		..skyblock.levels.get_goal_formspec(info,6,'place_stone',40,'build a house with 40 Stone','default:stone')
		..skyblock.levels.get_goal_formspec(info,7,'place_dirt',80,'extend your Island with 80 Dirt','default:dirt')
		..skyblock.levels.get_goal_formspec(info,8,'place_furnace',1,'craft and place a Furnace','default:furnace')
		..skyblock.levels.get_goal_formspec(info,9,'dig_stone_with_coal',2,'dig 4 Coal Lumps','default:stone_with_coal')
		..skyblock.levels.get_goal_formspec(info,10,'place_torch',8,'place 8 Torches','default:torch')

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total
		
	-- next level
	local current_level = skyblock.feats.get_level(player_name);
	if info.count==info.total and current_level==level then
		skyblock.levels[level+1].make_start_blocks(info.player_name)
		skyblock.feats.add(0,info.player_name,'level')
		info.formspec = skyblock.levels[level+1].get_info(info.player_name)
	end
	if current_level > level then
		local pos = skyblock.levels[level+1].get_pos(info.player_name)
		if pos and minetest.env:get_node(pos).name ~= 'skyblock:level_2' then
			skyblock.levels[level+1].make_start_blocks(info.player_name)
		end
	end
	
	return info
end


-- reward_achievement
skyblock.levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = skyblock.feats.get(level,player_name,achievement)
	
	-- place_sapling x1
	if achievement == 'place_sapling' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:tree')
		return true
	end
	
	-- dig_tree x16
	if achievement == 'dig_tree' and achievement_count == 16 then
		skyblock.feats.give_reward(level,player_name,'protector:protect')
		return true
	end

	-- place_stone x40
	if achievement == 'place_stone' and achievement_count == 40 then
		skyblock.feats.give_reward(level,player_name,'stairs:stair_wood 10')
		return true
	end

	-- place_dirt x80
	if achievement == 'place_dirt' and achievement_count == 80 then
		skyblock.feats.give_reward(level,player_name,'default:jungleleaves 6')
		return true
	end

	-- place_chest x1
	if achievement == 'place_chest' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:sandstone 50')
		return true
	end

	-- place_sign_wall x1
	if achievement == 'place_sign_wall' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:cactus')
		return true
	end

	-- place_cobble x50
	if achievement == 'place_cobble' and achievement_count == 20 then
		skyblock.feats.give_reward(level,player_name,'stairs:stair_cobble 10')
		return true
	end

	-- place_furnace x1
	if achievement == 'place_furnace' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:coal_lump')
		return true
	end

	-- dig_stone_with_coal x2
	if achievement == 'dig_stone_with_coal' and achievement_count == 2 then
		skyblock.feats.give_reward(level,player_name,'default:desert_stone 50')
		return true
	end

	-- place_torch x8
	if achievement == 'place_torch' and achievement_count == 8 then
		skyblock.feats.give_reward(level,player_name,'protector:protect 2')
		return true
	end

end


-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	-- dig_tree
	if oldnode.name == 'default:tree' then
		skyblock.feats.add(level,player_name,'dig_tree')
		return
	end
	
	-- dig_stone
	if oldnode.name == 'default:stone' then
		skyblock.feats.add(level,player_name,'dig_stone')
		return
	end
	
	-- dig_stone_with_coal
	if oldnode.name == 'default:stone_with_coal' then
		skyblock.feats.add(level,player_name,'dig_stone_with_coal')
		return
	end
	
end


-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_sapling
	if newnode.name == 'default:sapling' then
		skyblock.feats.add(level,player_name,'place_sapling')
		return
	end

	-- place_dirt
	if newnode.name == 'default:dirt' then
		skyblock.feats.add(level,player_name,'place_dirt')
		return
	end

	-- place_chest
	if newnode.name == 'default:chest' then
		skyblock.feats.add(level,player_name,'place_chest')
		return
	end

	-- place_stone
	if newnode.name == 'default:stone' then
		skyblock.feats.add(level,player_name,'place_stone')
		return
	end

	-- place_cobble
	if newnode.name == 'default:cobble' then
		skyblock.feats.add(level,player_name,'place_cobble')
		return
	end

	-- place_furnace
	if newnode.name == 'default:furnace' then
		skyblock.feats.add(level,player_name,'place_furnace')
		return
	end

	-- place_sign_wall
	if newnode.name == 'default:sign_wall' then
		skyblock.feats.add(level,player_name,'place_sign_wall')
		return
	end

	-- place_torch
	if newnode.name == 'default:torch' then
		skyblock.feats.add(level,player_name,'place_torch')
		return
	end

end


-- track bucket feats
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing)

	-- collect_spawn_water
	--[[
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:water_source' then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			skyblock.feats.add(level,player_name,'collect_spawn_water')
		end
	end
	]]--

	-- collect_spawn_lava
	--[[
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:lava_source' then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			skyblock.feats.add(level,player_name,'collect_spawn_lava')
		end
	end
	]]--

end

-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) end

-- track bucket lava feats
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end