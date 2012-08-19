--[[

SkyBlock Craft
Copyright (C) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>

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

-- handle globalstep
minetest.register_globalstep(function(dtime)
	return skyblock.globalstep(dtime)
end)
