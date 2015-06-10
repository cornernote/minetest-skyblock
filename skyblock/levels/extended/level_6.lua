--[[

SkyBlock for MineTest

Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 5 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 6
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log("level["..level.."].get_pos() for "..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+220,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log("level["..level.."].make_start_blocks() for "..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 25
	local hollow = 1
	skyblock.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,"default:dirt",hollow)

	-- level 4
	minetest.env:add_node(pos, {name="skyblock:level_6"})

end


-- update achievements
levels[level].update = function(player_name,pos)
	local formspec = ""
	local total = 0
	local count = 0

	formspec = formspec
		.."size[6,4;]"
		.."label[0,0;LEVEL "..level.." FOR: ".. player_name .."]"
		.."label[0,1; --== THE END ==--]"
		.."label[0,1.5; I hope you enjoyed your journey, and you]"
		.."label[0,2.0; are welcome to stay and keep building]"
		.."label[0,2.5; your new sky world.]"

	local infotext = "THE END! for ".. player_name .." ... or is it ..."
	return formspec, infotext
end


-- not used
levels[level].reward_achievement = function(player_name,achievement) end
levels[level].on_placenode = function(pos, newnode, placer, oldnode) end
levels[level].on_dignode = function(pos, oldnode, digger) end
levels[level].bucket_on_use = function(player_name, pointed_thing) end
levels[level].bucket_water_on_use = function(player_name, pointed_thing) end
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end
