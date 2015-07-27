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
		..skyblock.levels.get_goal_formspec(info,1,'dig_dirt',10,'dig 10 Dirt')
		..skyblock.levels.get_goal_formspec(info,2,'place_dirt',10,'place 10 Dirt','default:dirt')
		..skyblock.levels.get_goal_formspec(info,3,'place_sapling',1,'craft a Sapling and grow a Tree','default:sapling')
		..skyblock.levels.get_goal_formspec(info,4,'dig_tree',16,'craft a Wooden Axe and dig 16 Tree','default:axe_wood')
		..skyblock.levels.get_goal_formspec(info,5,'place_furnace',1,'craft and place a Furnace','default:furnace')
		..skyblock.levels.get_goal_formspec(info,6,'place_cobble',50,'craft and place 50 Cobblestone','default:cobble')
		..skyblock.levels.get_goal_formspec(info,7,'place_chest',1,'craft and place a Chest','default:chest')
		..skyblock.levels.get_goal_formspec(info,8,'place_sign',1,'craft and place a Sign','default:sign_wall')
		..skyblock.levels.get_goal_formspec(info,9,'place_door',1,'craft and place a Door','doors:door_wood')
		..skyblock.levels.get_goal_formspec(info,10,'place_glass',2,'craft and place 2 Glass','default:glass')

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total
	
	return info
end


-- reward_achievement
skyblock.levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = skyblock.feats.get(level,player_name,achievement)
	
	-- dig_dirt x10
	if achievement == 'dig_dirt' and achievement_count == 10 then
		skyblock.feats.give_reward(level,player_name,'default:stick')
		return true
	end

	-- place_dirt x10
	if achievement == 'place_dirt' and achievement_count == 10 then
		skyblock.feats.give_reward(level,player_name,'default:leaves 6')
		return true
	end

	-- place_sapling x1
	if achievement == 'place_sapling' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:tree')
		return true
	end
	
	-- dig_tree x16
	if achievement == 'dig_tree' and achievement_count == 16 then
		skyblock.feats.give_reward(level,player_name,'default:cobble 8')
		return true
	end
	
	-- place_furnace x1
	if achievement == 'place_furnace' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:jungleleaves 6')
		return true
	end

	-- place_cobble x50
	if achievement == 'place_cobble' and achievement_count == 50 then
		skyblock.feats.give_reward(level,player_name,'stairs:stair_cobble 3')
		return true
	end

	-- place_chest x1
	if achievement == 'place_chest' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:sandstone 50')
		return true
	end

	-- place_sign x1
	if achievement == 'place_sign' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:coal_lump')
		return true
	end

	-- place_door x1
	if achievement == 'place_door' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:desert_stone 50')
		return true
	end
	
	-- place_glass x2
	if achievement == 'place_glass' and achievement_count == 2 then
		skyblock.feats.give_reward(level,player_name,'protector:protect')
		return true
	end

end


-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	-- dig_dirt
	if oldnode.name == 'default:dirt' or oldnode.name == 'default:dirt_with_grass' or oldnode.name == 'default:dirt_with_grass_footsteps' then
		skyblock.feats.add(level,player_name,'dig_dirt')
		return
	end
	
	-- dig_tree
	if oldnode.name == 'default:tree' then
		skyblock.feats.add(level,player_name,'dig_tree')
		return
	end
	
end


-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_dirt
	if newnode.name == 'default:dirt' then
		skyblock.feats.add(level,player_name,'place_dirt')
		return
	end

	-- place_sapling
	if newnode.name == 'default:sapling' then
		skyblock.feats.add(level,player_name,'place_sapling')
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

	-- place_chest
	if newnode.name == 'default:chest' then
		skyblock.feats.add(level,player_name,'place_chest')
		return
	end

	-- place_sign
	if newnode.name == 'default:sign_wall' then
		skyblock.feats.add(level,player_name,'place_sign')
		return
	end

	-- place_door
	if newnode.name == 'doors:door_wood' then
		skyblock.feats.add(level,player_name,'place_door')
		return
	end

	-- place_glass
	if newnode.name == 'default:glass' then
		skyblock.feats.add(level,player_name,'place_glass')
		return
	end

end


-- track bucket feats
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing) end

-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) end

-- track bucket lava feats
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end