--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

ACHIEVEMENT FUNCTIONS

]]--

-- expose api
achievements = {}

-- log
achievements.log = function(message)
	--if not skyblock.DEBUG then
	--	return
	--end
	minetest.log('action', '[skyblock] '..message)
end

-- file to save players achievements
achievements.FILENAME = minetest.get_worldpath()..'/achievements'

-- local variable to save players achievements
local players_achievements = table.load(achievements.FILENAME)
if players_achievements == nil then
	players_achievements = {}
end

-- get players current level
achievements.get_level = function(player_name)
	achievements.log('achievements.get_level('..player_name..')')
	return achievements.get(0, player_name, 'level')
end

-- reset
achievements.reset = function(player_name)
	achievements.log('achievements.reset('..player_name..')')
	players_achievements[player_name] = {}
	table.save(players_achievements, achievements.FILENAME)
	achievements.update(player_name)
end

-- update achievements
achievements.update = function(player_name)
	achievements.log('achievements.update('..player_name..')')
	local level = achievements.get_level(player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return pos end
	local meta = minetest.env:get_meta(pos)
	local level_info = levels[level].get_info(player_name)
	meta:set_string('formspec', level_info.formspec)
	meta:set_string('infotext', level_info.infotext)
	minetest.get_player_by_name(player_name):set_inventory_formspec(level_info.formspec)
end

-- get achievement
achievements.get = function(level,player_name,achievement)
	achievements.log('achievements.get('..level..','..player_name..','..achievement..')')
	if players_achievements[player_name] == nil then
		players_achievements[player_name] = {}
	end
	if players_achievements[player_name][level] == nil then
		players_achievements[player_name][level] = {}
	end
	if players_achievements[player_name][level][achievement] == nil then
		players_achievements[player_name][level][achievement] = 0
		if achievement=='level' then
			players_achievements[player_name][level][achievement] = 1
		end
	end
	return players_achievements[player_name][level][achievement]
end

-- set achievement
achievements.add = function(level,player_name,achievement)
	achievements.log('achievements.add('..level..','..player_name..','..achievement..')')
	local player_achievement = achievements.get(level,player_name,achievement)
	players_achievements[player_name][level][achievement] = player_achievement + 1
	if level==0 or achievement=='level' then
		table.save(players_achievements, achievements.FILENAME)
		return
	end
	local update = levels[level].reward_achievement(player_name,achievement)
	
	-- update
	if update then
		achievements.update(player_name)
		--minetest.chat_send_player(player_name, 'You earned the achievement "'..achievement..'"')
		minetest.chat_send_all(player_name..' was awarded the achievement "'..achievement..'"')
		minetest.log('action', player_name..' was awarded the achievement "'..achievement..'"')
	end
	
	table.save(players_achievements, achievements.FILENAME)
end

-- give reward
achievements.give_reward = function(level,player_name,item_name)
	achievements.log('achievements.give_reward('..level..','..player_name..','..item_name..')')
	local player = minetest.get_player_by_name(player_name)
	player:get_inventory():add_item('rewards', item_name)
	player:set_inventory_formspec(levels.get_formspec(player_name))
end

-- track eating
minetest.register_on_item_eat(function( hp_change, replace_with_item, itemstack, user, pointed_thing )
	if not user then return end
	local player_name = user:get_player_name()
	local level = achievements.get_level(player_name)
	if( levels[level].on_item_eat ) then
		levels[level].on_item_eat(player_name, itemstack)
	end
end)

-- track node digging
minetest.register_on_dignode(function(pos, oldnode, digger)
	if not digger then return end -- needed to prevent server crash when player leaves
	local player_name = digger:get_player_name()
	local level = achievements.get_level(player_name)
	levels[level].on_dignode(pos, oldnode, digger)
end)

-- track node placing
minetest.register_on_placenode(function(pos, newnode, placer, oldnode)
	if not placer then return end -- needed to prevent server crash when player leaves
	local player_name = placer:get_player_name()
	local level = achievements.get_level(player_name)
	levels[level].on_placenode(pos, newnode, placer, oldnode)
end)

-- track on_place of items with their own on_place
local on_place = function(v, is_craftitem)
	local entity = minetest.registered_items[ v ];
	if entity and entity.on_place then
		local old_on_place = entity.on_place;
		entity.on_place = function(itemstack, placer, pointed_thing)
			local old_count = itemstack:get_count();
			local res = old_on_place( itemstack, placer, pointed_thing );
			if( itemstack and itemstack:get_count() == old_count-1 ) then
				achievements.on_placenode(pointed_thing, {name=v,param2=0}, placer, nil);
			end
			return res;
		end
		if( is_craftitem == 1 ) then
			minetest.register_craftitem(":"..v, entity);
		else
			minetest.register_node(":"..v, entity);
		end
	end
end
for _,v in ipairs({"doors:door_wood","doors:door_glass","doors:door_steel","doors:door_obsidian_glass"}) do
	on_place(v,1);
end
for _,v in ipairs({"default:cactus", "farming:seed_wheat", "farming:seed_cotton"}) do
	on_place(v,0);
end

-- track bucket achievements
achievements.bucket_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = achievements.get_level(player_name)
	levels[level].bucket_on_use(player_name, pointed_thing)
end

-- track bucket_water achievements
achievements.bucket_water_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = achievements.get_level(player_name)
	levels[level].bucket_water_on_use(player_name, pointed_thing)
end

-- track bucket_lava achievements
achievements.bucket_lava_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = achievements.get_level(player_name)
	levels[level].bucket_lava_on_use(player_name, pointed_thing)
end

-- bucket_empty
local entity = skyblock.registered('craftitem','bucket:bucket_empty')
entity.on_use = function(itemstack, user, pointed_thing)
	-- Must be pointing to node
	if pointed_thing.type ~= 'node' then
		return
	end
	-- Check if pointing to a liquid source
	n = minetest.env:get_node(pointed_thing.under)
	liquiddef = bucket.liquids[n.name]
	if liquiddef ~= nil and liquiddef.source == n.name and liquiddef.itemname ~= nil then
		
		-- begin track bucket achievements
		achievements.bucket_on_use(itemstack, user, pointed_thing)
		-- end track bucket achievements
	
		minetest.env:add_node(pointed_thing.under, {name='air'})
		return {name=liquiddef.itemname}
	end
end
minetest.register_craftitem(':bucket:bucket_empty', entity)

-- bucket_water
local entity = skyblock.registered('craftitem','bucket:bucket_water')
entity.on_use = function(itemstack, user, pointed_thing)
	-- Must be pointing to node
	if pointed_thing.type ~= 'node' then
		return
	end
	-- Check if pointing to a liquid
	n = minetest.env:get_node(pointed_thing.under)
	if bucket.liquids[n.name] == nil then
		-- Not a liquid

		-- begin anti-grief change
		local player_name = user:get_player_name()
		local spawn = skyblock.has_spawn(player_name)
		local range = skyblock.START_GAP/3 -- how far from spawn you can use water
		local pos = pointed_thing.under
		if spawn==nil or (pos.x-spawn.x > range or pos.x-spawn.x < range*-1) or (pos.y-spawn.y > range/2 or pos.y-spawn.y < range*-1/2) or (pos.z-spawn.z > range or pos.z-spawn.z < range*-1) then
			minetest.chat_send_player(player_name, 'Cannot use bucket so far from your home.')
			return
		end
		-- end anti-grief change

		minetest.env:add_node(pointed_thing.above, {name='default:water_source'})
	elseif n.name ~= 'default:water_source' then
		-- It's a liquid
		minetest.env:add_node(pointed_thing.under, {name='default:water_source'})
	end

	-- begin track bucket achievements
	achievements.bucket_water_on_use(itemstack, user, pointed_thing)
	-- end track bucket achievements

	return {name='bucket:bucket_empty'}
end
minetest.register_craftitem(':bucket:bucket_water', entity)

-- bucket_lava
local entity = skyblock.registered('craftitem','bucket:bucket_lava')
entity.on_use = function(itemstack, user, pointed_thing)
	-- Must be pointing to node
	if pointed_thing.type ~= 'node' then
		return
	end
	-- Check if pointing to a liquid
	n = minetest.env:get_node(pointed_thing.under)
	if bucket.liquids[n.name] == nil then
		-- Not a liquid

		-- begin anti-grief change
		local player_name = user:get_player_name()
		local spawn = skyblock.has_spawn(player_name)
		local range = skyblock.START_GAP/3 -- how far from spawn you can use lava
		local pos = pointed_thing.under
		if spawn==nil or (pos.x-spawn.x > range or pos.x-spawn.x < range*-1) or (pos.z-spawn.z > range or pos.z-spawn.z < range*-1) then
			--if (pos.y-spawn.y > range/2 or pos.y-spawn.y < range*-1/2) then
				minetest.chat_send_player(player_name, 'Cannot use bucket so far from your home.')
				return
			--end
		end
		-- end anti-grief change

		minetest.env:add_node(pointed_thing.above, {name='default:lava_source'})
	elseif n.name ~= 'default:lava_source' then
		-- It's a liquid
		minetest.env:add_node(pointed_thing.under, {name='default:lava_source'})
	end

	-- begin track bucket achievements
	achievements.bucket_lava_on_use(itemstack, user, pointed_thing)
	-- end track bucket achievements

	return {name='bucket:bucket_empty'}
end
minetest.register_craftitem(':bucket:bucket_lava', entity)
