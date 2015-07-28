--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL LOADER

]]--


skyblock.levels = {}

-- Should digging the spawn result in a new spawn pos?
skyblock.levels.DIG_NEW_SPAWN = minetest.setting_getbool("skyblock_levels_dig_new_spawn")

--
-- Functions
--

-- give initial items
skyblock.levels.give_initial_items = function(player)
	skyblock.log('skyblock.levels.give_initial_items() to '..player:get_player_name())
	--player:get_inventory():add_item('main', 'default:stick')
end

-- check inventory (needs to match the given items above to prevent death on initial falling)
skyblock.levels.check_inventory = function(player)
	skyblock.log('skyblock.levels.check_inventory() for '..player:get_player_name())
	local inv = player:get_inventory()
	local stack
	if inv==nil then return false end
	
	--stack = inv:get_stack('main', 1)
	--if stack:get_name() ~= 'default:stick' or stack:get_count() ~= 1 then
	--	return false
	--end
	for i=1,inv:get_size('main') do
		stack = inv:get_stack('main', i)
		if stack:get_name() ~= '' then
			return false
		end
	end
	for i=1,inv:get_size('craft') do
		stack = inv:get_stack('craft', i)
		if stack:get_name() ~= '' then
			return false
		end
	end
	for i=1,inv:get_size('rewards') do
		stack = inv:get_stack('rewards', i)
		if stack:get_name() ~= '' then
			return false
		end
	end
	for bag=1,4 do
		for i=1,inv:get_size('skyblock_bag'..bag) do
			stack = inv:get_stack('skyblock_bag'..bag, i)
			if stack:get_name() ~= '' then
				return false
			end
		end
		for i=1,inv:get_size('skyblock_bag'..bag..'contents') do
			stack = inv:get_stack('skyblock_bag'..bag..'contents', i)
			if stack:get_name() ~= '' then
				return false
			end
		end
end
	return true
end

-- empty inventory
skyblock.levels.empty_inventory = function(player)
	local inv = player:get_inventory()
	if not inv:is_empty('main') then
		for i=1,inv:get_size('main') do
			inv:set_stack('main', i, nil)
		end
	end
	if not inv:is_empty('craft') then
		for i=1,inv:get_size('craft') do
			inv:set_stack('craft', i, nil)
		end
	end
	if not inv:is_empty('rewards') then
		for i=1,inv:get_size('rewards') do
			inv:set_stack('rewards', i, nil)
		end
	end
	local bags_inv = minetest.get_inventory({type="detached", name=player:get_player_name()..'_skyblock_bags'})
	for bag=1,4 do
		if not bags_inv:is_empty('skyblock_bag'..bag) then
			for i=1,bags_inv:get_size('skyblock_bag'..bag) do
				inv:set_stack('skyblock_bag'..bag, i, nil)
			end
			for i=1,bags_inv:get_size('skyblock_bag'..bag) do
				bags_inv:set_stack('skyblock_bag'..bag, i, nil)
				inv:set_stack('skyblock_bag'..bag..'contents', i, nil)
			end
		end
	end
end


--
-- Formspec
--

-- get_formspec
skyblock.levels.get_formspec = function(player_name)
	local level = skyblock.feats.get_level(player_name)
	local level_info = skyblock.levels[level].get_info(player_name)
	return level_info.formspec
end

-- get_inventory_formspec
skyblock.levels.get_inventory_formspec = function(level,player_name)
	local formspec = 'size[15,10;]'
		..'button[7,0;2,0.5;skyblock_bags;Bags]'
		..'button_exit[9,0;2,0.5;skyblock_home_set;Set Home]'
		..'button_exit[11,0;2,0.5;skyblock_home_go;Go Home]'
		..'button_exit[13,0;2,0.5;close;Close]'
		
		..'label[0,0; --== LEVEL '..level..' for '..player_name..' ==--]'
		..'label[0,2.7; --== Quests ==--]'
		..'background[-0.1,-0.1;6.6,10.3;goals.png]'

		..'label[7,1.5; Rewards]'
		..'background[6.9,1.4;2.2,2.8;rewards.png]'
		..'list[current_player;rewards;7,2;2,2;]'

		..'label[10,1.5; Craft]'
		..'label[14,2.5;Output]'
		..'background[9.9,1.4;5.2,3.8;craft.png]'
		..'list[current_player;craft;10,2;3,3;]'
		..'list[current_player;craftpreview;14,3;1,1;]'
		
		..'label[7,5.5; Inventory]'
		..'background[6.9,5.4;8.2,4.8;inventory.png]'
		..'list[current_player;main;7,6;8,4;]'
	return formspec
end

-- get_goal_formspec
skyblock.levels.get_goal_formspec = function(data,i,feat,required,text,hint)
	local y = 2.9+(i*0.6)
	local formspec = 'label[0.5,'..y..'; '..i..') '..text..']'
	if hint then
		formspec = formspec..'item_image_button[5.8,'..y..';0.6,0.6;'..skyblock.craft_guide.image_button_link(hint)..']'
	end
	if skyblock.feats.get(data.level,data.player_name,feat) >= required then
		formspec = formspec .. 'image[-0.2,'..(y-0.25)..';1,1;checkbox_checked.png]'
		data.count = data.count + 1
	else
		formspec = formspec .. 'image[-0.2,'..(y-0.25)..';1,1;checkbox_unchecked.png]'
	end
	return formspec
end


--
-- Level Shapes
--

-- hollow sphere (based on sphere in multinode by mauvebic)
skyblock.levels.make_sphere =  function(pos,radius,nodename,hollow)
	pos.x = math.floor(pos.x+0.5)
	pos.y = math.floor(pos.y+0.5)
	pos.z = math.floor(pos.z+0.5)
	for x=-radius,radius do
	for y=-radius,radius do
	for z=-radius,radius do
		if hollow ~= nil then
			if x*x+y*y+z*z >= (radius-hollow) * (radius-hollow) + (radius-hollow) and x*x+y*y+z*z <= radius * radius + radius then
				minetest.env:add_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name=nodename})
			end
		else
			if x*x+y*y+z*z <= radius * radius + radius then
				minetest.env:add_node({x=pos.x+x,y=pos.y+y,z=pos.z+z},{name=nodename})
			end
		end
	end
	end
	end
end
