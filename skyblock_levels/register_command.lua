--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--


-- register register_privilege
minetest.register_privilege('level', 'Can use /setlevel')

-- getlevel
minetest.register_chatcommand('getlevel', {
	description = 'Get a player\'s current level.',
	params = "<player_name>",
	func = function(name, param)
		local player_name = param
		if player_name == "" then
			player_name = name
		end
		minetest.chat_send_player(name, player_name..' is on level '..skyblock.feats.get_level(player_name))
		return
	end,
})

-- setlevel
minetest.register_chatcommand('setlevel', {
	description = 'Set a player\'s current level',
	privs = {level = true},
	params = "<player_name> <level>",
	func = function(name, param)
		local found, _, player_name, level = param:find("^([^%s]+)%s+(.+)$")
		if found and player_name and level then
			level = tonumber(level)
			if skyblock.feats.set_level(player_name, level) then
				minetest.chat_send_player(name, player_name..' has been set to level '..level)
			else
				minetest.chat_send_player(name, 'cannot change '..player_name..' to level '..level)
			end
		else
			return false, "Invalid use."
		end
	end,
})

-- who
minetest.register_chatcommand('who', {
	description = 'Display list of online players and their current level.',
	func = function(name)
		minetest.chat_send_player(name, 'Current Players:')
		for _,player in ipairs(minetest.get_connected_players()) do
			local player_name = player:get_player_name()
			minetest.chat_send_player(name, ' - '..player_name..' - level '..skyblock.feats.get_level(player_name))
		end
	end,
})
