--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 2 FUNCTIONS

]]--


local level = 2
local feats = {
	{
		name = 'place a Trapdoor',
		hint = 'doors:trapdoor',
		feat = 'place_trapdoor', 
		count = 1, 
		reward = 'default:desert_stonebrick 50',
		placenode = {'doors:trapdoor'},
	},
	{
		name = 'place 10 Ladders',
		hint = 'default:ladder',
		feat = 'place_ladder', 
		count = 10, 
		reward = 'default:desert_cobble 50',
		placenode = {'default:ladder'},
	},
	{
		name = 'place 20 Wood Fences',
		hint = 'default:fence_wood',
		feat = 'place_fence', 
		count = 20, 
		reward = 'stairs:stair_brick 4',
		placenode = {'default:fence_wood'},
	},
	{
		name = 'extend your Island with 100 Dirt',
		hint = 'default:dirt',
		feat = 'place_dirt', 
		count = 100, 
		reward = 'default:jungleleaves 6',
		placenode = {'default:dirt'},
	},
	{
		name = 'craft and place 100 Cobblestone',
		hint = 'default:cobble',
		feat = 'place_cobble', 
		count = 100, 
		reward = 'stairs:stair_cobble 3',
		placenode = {'default:cobble'},
	},
	{
		name = 'build a structure using 100 Wood',
		hint = 'default:wood',
		feat = 'place_wood', 
		count = 100, 
		reward = 'default:brick 50',
		placenode = {'default:wood'},
	},
	{
		name = 'dig 4 Coal Lumps',
		hint = 'default:stone_with_coal',
		feat = 'dig_stone_with_coal', 
		count = 2, 
		reward = 'default:pine_needles 6',
		dignode = {'default:stone_with_coal'},
	},
	{
		name = 'place 8 Torches',
		hint = 'default:torch',
		feat = 'place_torch', 
		count = 8, 
		reward = 'default:iron_lump',
		placenode = {'default:torch'},
	},
	{
		name = 'dig 8 Iron Lumps',
		hint = 'default:stone_with_iron',
		feat = 'dig_stone_with_iron', 
		count = 4, 
		reward = 'default:pine_needles 6',
		dignode = {'default:stone_with_iron'},
	},
	{
		name = 'craft and place a Locked Chest',
		hint = 'default:chest_locked',
		feat = 'place_chest_locked', 
		count = 1, 
		reward = 'default:copper_lump',
		placenode = {'default:chest_locked'},
	},
}


--
-- PUBLIC FUNCTIONS
--

skyblock.levels[level] = {}

-- get pos
skyblock.levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+15,z=pos.z}
end

-- make start blocks
skyblock.levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = skyblock.levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 3
	local hollow = 1
	skyblock.levels.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)

	-- level 2
	--minetest.env:add_node(pos, {name='skyblock:level_2'})
	--skyblock.feats.update(player_name)

end

-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = { level=level, total=10, count=0, player_name=player_name, infotext='', formspec = '' };

	info.formspec = skyblock.levels.get_inventory_formspec(level,info.player_name)
		..'label[0,0.5; Hey '..player_name..', Come Up Here!]'
		..'label[0,1; Wow, look at that view... of... nothing...]'
		..'label[0,1.5; You should get to work extending this island.]'
		..'label[0,2; Perhaps you could build some structures too?]'

	for k,v in ipairs(feats) do
		info.formspec = info.formspec..skyblock.levels.get_goal_formspec(info,k+1,v.feat,v.count,v.name,v.hint)
	end

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total
	
	return info
end

-- reward_feat
skyblock.levels[level].reward_feat = function(player_name,feat)
	local count = skyblock.feats.get(level,player_name,feat)
	for _,v in ipairs(feats) do
		if v.feat == feat and v.count == count then
			skyblock.feats.give_reward(level,player_name,v.reward)
			return true
		end
	end
end

-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()
	for _,v in ipairs(feats) do
		if v.dignode then
			for _,vv in ipairs(v.dignode) do
				if oldnode.name == vv then
					skyblock.feats.add(level,player_name,v.feat)
					return
				end
			end
		end
	end
end

-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()
	for _,v in ipairs(feats) do
		if v.placenode then
			for _,vv in ipairs(v.placenode) do
				if newnode.name == vv then
					skyblock.feats.add(level,player_name,v.feat)
					return
				end
			end
		end
	end
end

-- track bucket feats
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing) end

-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) end

-- track bucket lava feats
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end