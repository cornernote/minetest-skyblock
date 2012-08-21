--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER MISC

]]--


-- handle new player
minetest.register_on_newplayer(function(player)
	return skyblock.give_inventory(player)
end)

-- handle respawn player
minetest.register_on_respawnplayer(function(player)
	return skyblock.on_respawnplayer(player)
end)

-- register the game after the server starts
minetest.after(10, function()

	-- handle globalstep
	minetest.register_globalstep(function(dtime)
		return skyblock.globalstep(dtime)
	end)

end)
