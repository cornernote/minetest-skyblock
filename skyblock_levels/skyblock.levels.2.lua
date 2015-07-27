--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 2 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 2
skyblock.levels[level] = {}


-- get pos
skyblock.levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+15,z=pos.z}
end


-- make start blocks
skyblock.levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = skyblock.levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 3
	local hollow = 1
	skyblock.levels.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)

	-- level 2
	--minetest.env:add_node(pos, {name='skyblock:level_2'})
	--skyblock.feats.update(player_name)

end


-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = { level=level, total=10, count=0, player_name=player_name, infotext='', formspec = '' };

	info.formspec = skyblock.levels.get_inventory_formspec(level,info.player_name)
		..'label[0,0.5; Hey '..player_name..', Come Up Here!]'
		..'label[0,1; Wow, look at that view... of... nothing...]'
		..'label[0,1.5; You should get to work extending this island.]'
		..'label[0,2; Perhaps you could build some structures too?]'
		..skyblock.levels.get_goal_formspec(info,1,'place_trapdoor',1,'place a Trapdoor','doors:trapdoor')
		..skyblock.levels.get_goal_formspec(info,2,'place_ladder',10,'place 10 Ladders','default:ladder')
		..skyblock.levels.get_goal_formspec(info,3,'place_fence_wood',20,'place 20 Wood Fences','default:fence_wood')
		..skyblock.levels.get_goal_formspec(info,4,'place_dirt',100,'extend your Island with 100 Dirt','default:dirt')
		..skyblock.levels.get_goal_formspec(info,5,'place_cobble',100,'craft and place 100 Cobblestone','default:cobble')
		..skyblock.levels.get_goal_formspec(info,6,'place_wood',100,'build a structure using 100 Wood','default:wood')
		..skyblock.levels.get_goal_formspec(info,7,'dig_stone_with_coal',2,'dig 4 Coal Lumps','default:stone_with_coal')
		..skyblock.levels.get_goal_formspec(info,8,'place_torch',8,'place 8 Torches','default:torch')
		..skyblock.levels.get_goal_formspec(info,9,'dig_stone_with_iron',4,'dig 8 Iron Lumps','default:stone_with_iron')
		..skyblock.levels.get_goal_formspec(info,10,'place_chest_locked',1,'craft and place a Locked Chest','default:chest_locked')

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total
	
	return info
end


-- reward_achievement
skyblock.levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = skyblock.feats.get(level,player_name,achievement)
	
	-- place_trapdoor x1
	if achievement == 'place_trapdoor' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:desert_stonebrick 50')
		return true
	end

	-- place_ladder x10
	if achievement == 'place_ladder' and achievement_count == 10 then
		skyblock.feats.give_reward(level,player_name,'default:desert_cobble 50')
		return true
	end

	-- place_fence_wood x20
	if achievement == 'place_fence_wood' and achievement_count == 20 then
		skyblock.feats.give_reward(level,player_name,'stairs:stair_brick 3')
		return true
	end
	
	-- place_dirt x100
	if achievement == 'place_dirt' and achievement_count == 100 then
		skyblock.feats.give_reward(level,player_name,'default:jungleleaves 6')
		return true
	end

	-- place_cobble x100
	if achievement == 'place_cobble' and achievement_count == 100 then
		skyblock.feats.give_reward(level,player_name,'stairs:stair_cobble 3')
		return true
	end
	
	-- place_wood x100
	if achievement == 'place_wood' and achievement_count == 100 then
		skyblock.feats.give_reward(level,player_name,'default:brick 50')
		return true
	end

	-- dig_stone_with_coal x4
	if achievement == 'dig_stone_with_coal' and achievement_count == 2 then
		skyblock.feats.give_reward(level,player_name,'default:pine_needles 6')
		return true
	end

	-- place_torch x8
	if achievement == 'place_torch' and achievement_count == 8 then
		skyblock.feats.give_reward(level,player_name,'default:iron_lump')
		return true
	end

	-- dig_stone_with_iron x8
	if achievement == 'dig_stone_with_iron' and achievement_count == 4 then
		skyblock.feats.give_reward(level,player_name,'default:pine_needles 6')
		return true
	end

	-- place_chest_locked
	if achievement == 'place_chest_locked' and achievement_count == 1 then
		skyblock.feats.give_reward(level,player_name,'default:copper_lump')
		return true
	end
	
end


-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()

	-- dig_stone_with_coal
	if oldnode.name == 'default:stone_with_coal' then
		skyblock.feats.add(level,player_name,'dig_stone_with_coal')
		return
	end
	
	-- dig_stone_with_iron
	if oldnode.name == 'default:stone_with_iron' then
		skyblock.feats.add(level,player_name,'dig_stone_with_iron')
		return
	end
	
end


-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_trapdoor
	if newnode.name == 'doors:trapdoor' then
		skyblock.feats.add(level,player_name,'place_trapdoor')
		return
	end

	-- place_ladder
	if newnode.name == 'default:ladder' then
		skyblock.feats.add(level,player_name,'place_ladder')
		return
	end

	-- place_fence_wood
	if newnode.name == 'default:fence_wood' then
		skyblock.feats.add(level,player_name,'place_fence_wood')
		return
	end

	-- place_dirt
	if newnode.name == 'default:dirt' then
		skyblock.feats.add(level,player_name,'place_dirt')
		return
	end

	-- place_cobble
	if newnode.name == 'default:cobble' then
		skyblock.feats.add(level,player_name,'place_cobble')
		return
	end

	-- place_wood
	if newnode.name == 'default:wood' or newnode.name == 'default:junglewood' or newnode.name == 'default:pinewood' then
		skyblock.feats.add(level,player_name,'place_wood')
		return
	end

	-- place_torch
	if newnode.name == 'default:torch' then
		skyblock.feats.add(level,player_name,'place_torch')
		return
	end

	-- place_chest_locked
	if newnode.name == 'default:chest_locked' then
		skyblock.feats.add(level,player_name,'place_chest_locked')
		return
	end

end


-- track bucket feats
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing) end


-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) end


-- track bucket lava feats
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end