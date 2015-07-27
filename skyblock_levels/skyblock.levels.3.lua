--[[
	
Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 3 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 3
skyblock.levels[level] = {}


-- get pos
skyblock.levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+40,z=pos.z}
end


-- make start blocks
skyblock.levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = skyblock.levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 5
	local hollow = 1
	skyblock.levels.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)

	-- level 3
	--minetest.env:add_node(pos, {name='skyblock:level_3'})
	--skyblock.feats.update(player_name)

end


-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = { level=level, total=10, count=0, player_name=player_name, infotext='', formspec = '' };

	info.formspec = skyblock.levels.get_inventory_formspec(level,info.player_name)
		..'label[0,0.5; Does This Keep Going?]'
		..'label[0,1.0; If you are enjoying this world, then stray not]'
		..'label[0,1.5; from your mission traveller...]'
		..'label[0,2.0; ... for the end is near.]'
		..skyblock.levels.get_goal_formspec(info,1,'dig_papyrus',20,'dig 20 Papyrus')
		..skyblock.levels.get_goal_formspec(info,2,'place_papyrus',20,'place 20 Papyrus in a nice garden')
		..skyblock.levels.get_goal_formspec(info,3,'dig_cactus',15,'dig 15 Cactus')
		..skyblock.levels.get_goal_formspec(info,4,'place_cactus',15,'place 15 Cactus in another gargen')
		..skyblock.levels.get_goal_formspec(info,5,'place_fence',30,'place 30 fences around your gardens')
		..skyblock.levels.get_goal_formspec(info,6,'place_ladder',20,'add 20 ladders to your structures')
		..skyblock.levels.get_goal_formspec(info,7,'place_bookshelf',5,'decorate your house with 5 Bookshelves')
		..skyblock.levels.get_goal_formspec(info,8,'place_sign_wall',5,'place 5 Signs to help other travellers')
		..skyblock.levels.get_goal_formspec(info,9,'place_torch',50,'place 50 Torches to help you see at night')
		..skyblock.levels.get_goal_formspec(info,10,'dig_stone',500,'dig 500 Stone for your next project...')

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total
	
	return info
end


-- reward_achievement
skyblock.levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = skyblock.feats.get(level,player_name,achievement)
	
	-- dig_papyrus
	if achievement == 'dig_papyrus' and achievement_count == 20 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_papyrus
	if achievement == 'place_papyrus' and achievement_count == 20 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- dig_cactus
	if achievement == 'dig_cactus' and achievement_count == 15 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_cactus
	if achievement == 'place_cactus' and achievement_count == 15 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_fence
	if achievement == 'place_fence' and achievement_count == 30 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_ladder
	if achievement == 'place_ladder' and achievement_count == 20 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_bookshelf
	if achievement == 'place_bookshelf' and achievement_count == 5 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_sign_wall
	if achievement == 'place_sign_wall' and achievement_count == 10 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- place_torch
	if achievement == 'place_torch' and achievement_count == 50 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
	-- dig_stone
	if achievement == 'dig_stone' and achievement_count == 500 then
		skyblock.feats.give_reward(level,player_name,'default:mese '..math.random(1, 5))
		return true
	end
	
end


-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_papyrus
	if newnode.name == 'default:papyrus' then
		skyblock.feats.add(level,player_name,'place_papyrus')
		return
	end

	-- place_cactus
	if newnode.name == 'default:cactus' then
		skyblock.feats.add(level,player_name,'place_cactus')
		return
	end

	-- place_fence
        if newnode.name == 'default:fence_wood' or newnode.name == 'xfences:fence' then
		skyblock.feats.add(level,player_name,'place_fence')
		return
	end

	-- place_ladder
	if newnode.name == 'default:ladder' then
		skyblock.feats.add(level,player_name,'place_ladder')
		return
	end

	-- place_bookshelf
	if newnode.name == 'default:bookshelf' then
		skyblock.feats.add(level,player_name,'place_bookshelf')
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

-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	-- dig_papyrus
	if oldnode.name == 'default:papyrus' then
		skyblock.feats.add(level,player_name,'dig_papyrus')
		return
	end
	
	-- dig_cactus
	if oldnode.name == 'default:cactus' then
		skyblock.feats.add(level,player_name,'dig_cactus')
		return
	end
	
	-- dig_stone
	if oldnode.name == 'default:stone' then
		skyblock.feats.add(level,player_name,'dig_stone')
		return
	end
	
end

-- not used
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing) end
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end
