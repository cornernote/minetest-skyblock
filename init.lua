--[[

SkyBlock
by cornernote <cornernote@gmail.com>

]]--

-- expose functions to other modules
skyblock = {}

-- How far apart to set players start positions
skyblock.START_GAP = 64

-- How many players will be in 1 row
-- skyblock.WORLD_WIDTH * skyblock.WORLD_WIDTH = total players
skyblock.WORLD_WIDTH = 5

-- How far down (in nodes) before a player dies and is respawned
skyblock.WORLD_BOTTOM = -32

-- load other files
dofile(minetest.get_modpath("skyblock").."/functions.lua")
dofile(minetest.get_modpath("skyblock").."/register.lua")

-- give initial stuff
minetest.register_on_newplayer(function(player)
	player:get_inventory():add_item('main', 'default:dirt 10')
	player:get_inventory():add_item('main', 'default:tree')
	player:get_inventory():add_item('main', 'default:sapling')
	player:get_inventory():add_item('main', 'default:lava_source')
	player:get_inventory():add_item('main', 'bucket:bucket_water')
end)
