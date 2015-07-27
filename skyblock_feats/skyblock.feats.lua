--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

-- expose api
skyblock.feats = {}

-- file to save players feat
skyblock.feats.FILENAME = minetest.get_worldpath()..'/feat'

-- local variable to save players feats
local players_feat = skyblock.table.load(skyblock.feats.FILENAME)
if players_feat == nil then
	players_feat = {}
	end

-- get players current level
skyblock.feats.get_level = function(player_name)
	skyblock.log('skyblock.feats.get_level('..player_name..')')
	return skyblock.feats.get(0, player_name, 'level')
end

-- reset
skyblock.feats.reset = function(player_name)
	skyblock.log('skyblock.feats.reset('..player_name..')')
	players_feat[player_name] = {}
	skyblock.table.save(players_feat, skyblock.feats.FILENAME)
	skyblock.feats.update(0,player_name)
end

-- update feats
skyblock.feats.update = function(level,player_name)
	skyblock.log('skyblock.feats.update('..level..','..player_name..')')
	local level = skyblock.feats.get_level(player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	local info = skyblock.levels[level].get_info(player_name)

	-- next level
	if info.count==info.total then
		skyblock.levels[level+1].make_start_blocks(info.player_name)
		skyblock.feats.add(0,info.player_name,'level')
		info = skyblock.levels[level+1].get_info(info.player_name)
	end
	
	-- update formspecs
	minetest.get_player_by_name(player_name):set_inventory_formspec(info.formspec)
	local meta = minetest.env:get_meta(pos)
	meta:set_string('formspec', info.formspec)
	meta:set_string('infotext', info.infotext)
end

-- get feat
skyblock.feats.get = function(level,player_name,achievement)
	skyblock.log('skyblock.feats.get('..level..','..player_name..','..achievement..')')
	if players_feat[player_name] == nil then
		players_feat[player_name] = {}
	end
	if players_feat[player_name][level] == nil then
		players_feat[player_name][level] = {}
	end
	if players_feat[player_name][level][achievement] == nil then
		players_feat[player_name][level][achievement] = 0
		if achievement=='level' then
			players_feat[player_name][level][achievement] = 1
		end
	end
	return players_feat[player_name][level][achievement]
end

-- add feat
skyblock.feats.add = function(level,player_name,achievement)
	skyblock.log('skyblock.feats.add('..level..','..player_name..','..achievement..')')
	local player_achievement = skyblock.feats.get(level,player_name,achievement)
	players_feat[player_name][level][achievement] = player_achievement + 1
	if level==0 or achievement=='level' then
		skyblock.table.save(players_feat, skyblock.feats.FILENAME)
		return
	end
	local update = skyblock.levels[level].reward_achievement(player_name,achievement)
	
	-- update
	if update then
		skyblock.feats.update(level,player_name)
		--minetest.chat_send_player(player_name, 'You earned the achievement "'..achievement..'"')
		minetest.chat_send_all(player_name..' completed the quest "'..achievement..'" on level '..level)
		minetest.log('action', player_name..' completed the quest "'..achievement..'" on level '..level)
	end
	
	skyblock.table.save(players_feat, skyblock.feats.FILENAME)
end

-- give reward
skyblock.feats.give_reward = function(level,player_name,item_name)
	skyblock.log('skyblock.feats.give_reward('..level..','..player_name..','..item_name..')')
	local player = minetest.get_player_by_name(player_name)
	player:get_inventory():add_item('rewards', item_name)
	player:set_inventory_formspec(skyblock.levels.get_formspec(player_name))
end

-- track eating
skyblock.feats.on_item_eat = function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	if not user then return end
	local player_name = user:get_player_name()
	local level = skyblock.feats.get_level(player_name)
	if( skyblock.levels[level].on_item_eat ) then
		skyblock.levels[level].on_item_eat(player_name, itemstack)
	end
end
minetest.register_on_item_eat(skyblock.feats.on_item_eat)

-- track node digging
skyblock.feats.on_dignode = function(pos, oldnode, digger)
	if not digger then return end -- needed to prevent server crash when player leaves
	local player_name = digger:get_player_name()
	local level = skyblock.feats.get_level(player_name)
	skyblock.levels[level].on_dignode(pos, oldnode, digger)
end
minetest.register_on_dignode(skyblock.feats.on_dignode)

-- track node placing
skyblock.feats.on_placenode = function(pos, newnode, placer, oldnode)
	if not placer then return end -- needed to prevent server crash when player leaves
	local player_name = placer:get_player_name()
	local level = skyblock.feats.get_level(player_name)
	skyblock.levels[level].on_placenode(pos, newnode, placer, oldnode)
end
minetest.register_on_placenode(skyblock.feats.on_placenode)

-- track on_place of items with their own on_place
local on_place = function(v, is_craftitem)
	local entity = minetest.registered_items[ v ];
	if entity and entity.on_place then
		local old_on_place = entity.on_place;
		entity.on_place = function(itemstack, placer, pointed_thing)
			local old_count = itemstack:get_count();
			local res = old_on_place( itemstack, placer, pointed_thing );
			if( itemstack and itemstack:get_count() == old_count-1 ) then
				skyblock.feats.on_placenode(pointed_thing, {name=v,param2=0}, placer, nil);
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

-- track bucket feats
skyblock.feats.bucket_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = skyblock.feats.get_level(player_name)
	skyblock.levels[level].bucket_on_use(player_name, pointed_thing)
end

-- track bucket_water feats
skyblock.feats.bucket_water_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = skyblock.feats.get_level(player_name)
	skyblock.levels[level].bucket_water_on_use(player_name, pointed_thing)
end

-- track bucket_lava feats
skyblock.feats.bucket_lava_on_use = function(itemstack, user, pointed_thing)
	if not user then return end -- needed to prevent server crash when player leaves
	local player_name = user:get_player_name()
	local level = skyblock.feats.get_level(player_name)
	skyblock.levels[level].bucket_lava_on_use(player_name, pointed_thing)
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
		
		-- begin track bucket feats
		skyblock.feats.bucket_on_use(itemstack, user, pointed_thing)
		-- end track bucket feats
	
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

	-- begin track bucket feats
	skyblock.feats.bucket_water_on_use(itemstack, user, pointed_thing)
	-- end track bucket feats

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

	-- begin track bucket feats
	skyblock.feats.bucket_lava_on_use(itemstack, user, pointed_thing)
	-- end track bucket feats

	return {name='bucket:bucket_empty'}
end
minetest.register_craftitem(':bucket:bucket_lava', entity)
