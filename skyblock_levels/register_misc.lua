--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--


-- new player
minetest.register_on_newplayer(function(player)
	local player_name = player:get_player_name()
	skyblock.levels.give_initial_items(player)

	skyblock.spawn_player(player)
	skyblock.levels[1].make_start_blocks(player_name)

	-- move the player up high enough in order to avoid collusions with the ground
	local pos = skyblock.get_spawn(player_name)
	if pos then
		skyblock.feats.update(player_name)
		player:setpos({x=pos.x, y=pos.y+8, z=pos.z});
	end
end)

-- override skyblock.bak_make_spawn_blocks
local make_spawn_blocks = skyblock.make_spawn_blocks
skyblock.make_spawn_blocks = function(spawn,player_name)
	skyblock.levels[1].make_start_blocks(player_name)
	make_spawn_blocks(spawn,player_name)
end

-- handle respawn player
minetest.register_on_respawnplayer(function(player)
	local player_name = player:get_player_name()
	local spawn = skyblock.get_spawn(player_name)
	
	-- empty inventory
	skyblock.levels.empty_inventory(player)
	
	-- give inventory
	skyblock.levels.give_initial_items(player)

	-- unset old spawn position
	if skyblock.levels.dig_new_spawn then
		skyblock.set_spawn(player_name, nil)
		skyblock.set_spawn(player_name..'_DEAD', spawn)
	end

	-- rebuild spawn blocks
	skyblock.make_spawn_blocks(spawn,player_name)
	--skyblock.levels[1].make_start_blocks(player_name)
	
	-- reset feats
	skyblock.feats.reset(player_name)
	
	return true
end)

-- player has joined
minetest.register_on_joinplayer(function(player)
	-- add rewards to player inventory
	player:get_inventory():set_size('rewards', 4)
	-- set inventory formspec
	minetest.after(1,function()
		player:set_inventory_formspec(skyblock.levels.get_formspec(player:get_player_name()))
	end)
end)

-- on_receive_fields
skyblock.on_receive_fields = function(player, formname, fields)
	--skyblock.log(formname..dump(fields))
	--if fields.skyblock ~= nil or fields.main ~= nil then
		--minetest.show_formspec(player:get_player_name(), "skyblock", skyblock.levels.get_formspec(player:get_player_name()))
		--return
	--end
	if fields.craft then
		unified_inventory.set_inventory_formspec(player, "craft")
		--minetest.show_formspec(player:get_player_name(), "craft", unified_inventory.get_formspec(player, "craft"))
		return
	end
end
minetest.register_on_player_receive_fields(skyblock.on_receive_fields)

-- unified inventory skyblock button
unified_inventory.register_button("skyblock", {
	type = "image",
	image = "skyblock_quest.png",
	tooltip = "Skyblock Missions",
	action = function(player)
		skyblock.feats.update(player:get_player_name())
		--minetest.show_formspec(player:get_player_name(), "skyblock", player:get_inventory_formspec())
	end,	
})

