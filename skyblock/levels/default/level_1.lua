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

	formspec = formspec..'size[17,13;]'
	if nav then
		formspec = formspec..'button[15,12;2,0.5;main;Back]'
		formspec = formspec..'button[13,12;2,0.5;craft;Craft]'
	end
	formspec = formspec
		..'label[0,0;LEVEL '..level..' FOR: '.. player_name ..']'
		..'label[6,6; Rewards]'
		..'list[current_player;rewards;6,6.5;2,2;]'
		..'label[0,8.5; Inventory]'
		..'list[current_player;main;0,9;8,4;]'

		..'label[0,1.5; --== Welcome Traveller ==--]'
		..'label[0,2; Complete the tasks to the right to receive great rewards!]'
		
		-- todo, move to about button
		..'label[0,3.5; --== About This Game ==--]'
		..'label[0,4; For information and tutorials, please visit the website at:]'
		..'label[0,4.5; https://cornernote.github.io/minetest-skyblock/]'

		..'label[9,0.5; --== Goals ==--]'
	
	-- todo, add restart and refresh buttons
	--..'label[0,3; --== About The Level '..level..' Block ==--]'
	--..'label[0,3.5; * SHORT LEFT CLICK]'
	--..'label[0.4,4; = PUNCH - refresh achievements]'
	--..'label[0,4.5; * LONG LEFT CLICK]'
	--..'label[0.4,5; = DIG - restart in a new spawn location]'

	local goal_formspac, success
		
	-- place_sapling
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,1,'craft a Sapling and grow a Tree','place_sapling',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- dig_tree
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,2,'craft an axe and dig 4 Trees','dig_tree',4)
	formspec = formspec..goal_formspac
	count = count + success

	-- collect water under spawn node
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,3,'collect the Water under your Spawn','collect_spawn_water',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- place chest
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,4,'craft and place a Chest','place_chest',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- place sign_wall
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,5,'craft and place a Sign','place_sign_wall',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- collect lava under spawn node
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,6,'collect the Lava under your Spawn','collect_spawn_lava',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- dig stone
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,7,'build a Stone Generator and dig 20 Cobble','dig_stone',20)
	formspec = formspec..goal_formspac
	count = count + success

	-- place furnace
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,8,'craft and place a Furnace','place_furnace',1)
	formspec = formspec..goal_formspac
	count = count + success

	-- dig 4 coal lumps
	goal_formspac,success = achievements.get_goal_formspac(player_name,level,9,'dig 2 Coal Lumps','dig_stone_with_coal',2)
	formspec = formspec..goal_formspac
	count = count + success

	-- place 8 torches
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
	
	-- dig_tree x4
	if achievement == 'dig_tree' and achievement_count == 4 then
		achievements.give_reward(level,player_name,'bucket:bucket_empty')
		-- put water under spawn
		local pos = levels[level].get_pos(player_name)
		minetest.env:add_node({x=pos.x,y=pos.y-1,z=pos.z}, {name='default:water_source'})
		return true
	end
	
	-- collect_spawn_water x1
	if achievement == 'collect_spawn_water' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:jungleleaves 6')
		return true
	end

	-- place_chest x1
	if achievement == 'place_chest' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:cactus')
		return true
	end

	-- place_sign_wall
	if achievement == 'place_sign_wall' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:papyrus')
		-- put lava under spawn
		local pos = levels[level].get_pos(player_name)
		minetest.env:add_node({x=pos.x,y=pos.y-1,z=pos.z}, {name='default:lava_source'})
		return true
	end

	-- collect_spawn_lava x1
	if achievement == 'collect_spawn_lava' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'wool:white 50')
		return true
	end

	-- dig_stone x20
	if achievement == 'dig_stone' and achievement_count == 20 then
		achievements.give_reward(level,player_name,'default:sandstone 50')
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
		achievements.give_reward(level,player_name,'default:pine_needles 6')
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

	-- place_chest
	if newnode.name == 'default:chest' then
		achievements.add(level,player_name,'place_chest')
		return
	end

	-- place_furnace
	if newnode.name == 'default:furnace' then
		achievements.add(level,player_name,'place_furnace')
		return
	end

	-- place_torch
	if newnode.name == 'default:torch' then
		achievements.add(level,player_name,'place_torch')
		return
	end

	-- place_sign_wall
	if newnode.name == 'default:sign_wall' then
		achievements.add(level,player_name,'place_sign_wall')
		return
	end

end


-- track bucket achievements
levels[level].bucket_on_use = function(player_name, pointed_thing)

	-- collect_spawn_water
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:water_source' then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			achievements.add(level,player_name,'collect_spawn_water')
		end
	end

	-- collect_spawn_lava
	n = minetest.env:get_node(pointed_thing.under)
	if n.name == 'default:lava_source' then
		local spawn = skyblock.has_spawn(player_name)
		if spawn~=nil and pointed_thing.under.x==spawn.x and pointed_thing.under.y==spawn.y-1 and pointed_thing.under.z==spawn.z then
			achievements.add(level,player_name,'collect_spawn_lava')
		end
	end

end

-- track bucket water achievements
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end

-- track bucket lava achievements
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end