--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 1 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 1
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	return skyblock.has_spawn(player_name)
end


-- make start blocks
levels[level].make_start_blocks = function(pos, player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)

	-- level 0 - spawn
	minetest.env:add_node(pos, {name='skyblock:level_1'})
	achievements.update(level,player_name)
	
	-- level 0 - dirt
	for x=-1,1 do
		for z=-1,1 do
			if x~=0 or z~=0 then
				minetest.env:add_node({x=pos.x+x,y=pos.y,z=pos.z+z}, {name='default:dirt'})
			end
		end
	end

	-- level -1 and -2 dirt
	for x=-1,1 do
		for z=-1,1 do
			minetest.env:add_node({x=pos.x+x,y=pos.y-1,z=pos.z+z}, {name='default:dirt'})
			minetest.env:add_node({x=pos.x+x,y=pos.y-2,z=pos.z+z}, {name='default:dirt'})
		end
	end

end


-- update achievements
levels[level].update = function(player_name,nav)
	local formspec = ''
	local total = 10
	local count = 0

	formspec = achievements.get_items_formspec(level,nav)
		..'label[0,0.5;Welcome '..player_name..', of the Sky People]'
		..'label[0,1.0;We can no longer live on the surface.]'
		..'label[0,1.5;Can you help us rebuild in the sky?]'
		..'label[0,2.0;Complete the quests to receive great rewards!]'
		
	-- todo, add restart buttons

	-- todo, move to about button
	--..'label[0,3.5; --== About This Game ==--]'
	--..'label[0,4; For information and tutorials, please visit the website at:]'
	--..'label[0,4.5; https://cornernote.github.io/minetest-skyblock/]'

	local goal_formspac, success
		
	-- place_sapling
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,1,'craft a Sapling and grow a Tree','place_sapling',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- dig_tree
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,2,'craft an axe and dig 16 Trees','dig_tree',16)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_dirt
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,3,'extend your Island with 50 Dirt','place_dirt',50)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_chest
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,4,'craft and place a Chest','place_chest',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_sign_wall
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,5,'craft and place a Sign','place_sign_wall',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_wood
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,6,'build a house with 50 Wood','place_wood',50)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_cobble
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,7,'craft and place a 50 Cobblestone','place_cobble',50)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_furnace
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,8,'craft and place a Furnace','place_furnace',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- dig_stone_with_coal
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,9,'dig 4 Coal Lumps','dig_stone_with_coal',2)
	formspec = formspec..goal_formspac
	count = count + success

	-- place_torch
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,10,'place 8 Torches','place_torch',8)
	formspec = formspec..goal_formspac
	count = count + success

	-- next level
	if count==total and achievements.get(0,player_name,'level')==level then
		levels[level+1].make_start_blocks(player_name)
		achievements.add(0,player_name,'level')
		formspec = levels[level+1].update(player_name,nav)
	end
	if  achievements.get(0,player_name,'level') > level then
		local pos = levels[level+1].get_pos(player_name)
		if pos and minetest.env:get_node(pos).name ~= 'skyblock:level_2' then
			levels[level+1].make_start_blocks(player_name)
		end
	end
	
	local infotext = 'LEVEL '..level..' for '.. player_name ..': '.. count ..' of '..total
	return formspec, infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	
	-- place_sapling x1
	if achievement == 'place_sapling' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:tree')
		return true
	end
	
	-- dig_tree x16
	if achievement == 'dig_tree' and achievement_count == 16 then
		achievements.give_reward(level,player_name,'protector:protect')
		return true
	end

	-- place_dirt
	if achievement == 'place_dirt' and achievement_count == 50 then
		achievements.give_reward(level,player_name,'default:jungleleaves 6')
		return true
	end

	-- place_chest x1
	if achievement == 'place_chest' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:sandstone 50')
		return true
	end

	-- place_sign_wall x1
	if achievement == 'place_sign_wall' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:cactus')
		return true
	end

	-- place_wood x50
	if achievement == 'place_wood' and achievement_count == 50 then
		achievements.give_reward(level,player_name,'stairs:stair_wood 10')
		return true
	end

	-- place_cobble x50
	if achievement == 'place_cobble' and achievement_count == 50 then
		achievements.give_reward(level,player_name,'stairs:stair_cobble 10')
		return true
	end

	-- place_furnace x1
	if achievement == 'place_furnace' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:coal_lump')
		return true
	end

	-- dig_stone_with_coal x2
	if achievement == 'dig_stone_with_coal' and achievement_count == 2 then
		achievements.give_reward(level,player_name,'default:desert_stone 50')
		return true
	end

	-- place_torch x8
	if achievement == 'place_torch' and achievement_count == 8 then
		achievements.give_reward(level,player_name,'protector:protect 4')
		return true
	end

end


-- track digging achievements
levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	
	-- dig_tree
	if oldnode.name == 'default:tree' then
		achievements.add(level,player_name,'dig_tree')
		return
	end
	
	-- dig_stone
	if oldnode.name == 'default:stone' then
		achievements.add(level,player_name,'dig_stone')
		return
	end
	
	-- dig_stone_with_coal
	if oldnode.name == 'default:stone_with_coal' then
		achievements.add(level,player_name,'dig_stone_with_coal')
		return
	end
	
end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_sapling
	if newnode.name == 'default:sapling' then
		achievements.add(level,player_name,'place_sapling')
		return
	end

	-- place_dirt
	if newnode.name == 'default:dirt' then
		achievements.add(level,player_name,'place_dirt')
		return
	end

	-- place_chest
	if newnode.name == 'default:chest' then
		achievements.add(level,player_name,'place_chest')
		return
	end

	-- place_wood
	if newnode.name == 'default:wood' or newnode.name == 'default:junglewood' or newnode.name == 'default:pinewood' then
		achievements.add(level,player_name,'place_wood')
		return
	end

	-- place_cobble
	if newnode.name == 'default:cobble' then
		achievements.add(level,player_name,'place_cobble')
		return
	end

	-- place_furnace
	if newnode.name == 'default:furnace' then
		achievements.add(level,player_name,'place_furnace')
		return
	end

	-- place_sign_wall
	if newnode.name == 'default:sign_wall' then
		achievements.add(level,player_name,'place_sign_wall')
		return
	end

	-- place_torch
	if newnode.name == 'default:torch' then
		achievements.add(level,player_name,'place_torch')
		return
	end

end


-- track bucket achievements
levels[level].bucket_on_use = function(player_name, pointed_thing)

	-- collect_spawn_water
	--[[
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:water_source' then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			achievements.add(level,player_name,'collect_spawn_water')
		end
	end
	]]--

	-- collect_spawn_lava
	--[[
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:lava_source' then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			achievements.add(level,player_name,'collect_spawn_lava')
		end
	end
	]]--

end

-- track bucket water achievements
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end

-- track bucket lava achievements
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end