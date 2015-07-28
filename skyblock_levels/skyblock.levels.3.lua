--[[
	
Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 3 FUNCTIONS

]]--


local level = 2
local feats = {
	{
		name = 'dig 20 Papyrus',
		hint = '',
		feat = 'dig_papyrus', 
		count = 20, 
		reward = 'default:mese',
		dignode = {'default:papyrus'},
	},
	{
		name = 'place 20 Papyrus in a nice garden',
		hint = '',
		feat = 'place_papyrus', 
		count = 20, 
		reward = 'default:mese',
		placenode = {'default:papyrus'},
	},
	{
		name = 'dig 15 Cactus',
		hint = '',
		feat = 'dig_cactus', 
		count = 15, 
		reward = 'default:mese',
		dignode = {'default:cactus'},
	},
	{
		name = 'place 15 Cactus in another gargen',
		hint = '',
		feat = 'place_cactus', 
		count = 15, 
		reward = 'default:mese',
		placenode = {'default:cactus'},
	},
	{
		name = 'place 30 fences around your gardens',
		hint = '',
		feat = 'place_fence', 
		count = 30, 
		reward = 'default:mese',
		placenode = {'default:fence_wood'},
	},
	{
		name = 'add 20 ladders to your structures',
		hint = '',
		feat = 'place_ladder', 
		count = 20, 
		reward = 'default:mese',
		placenode = {'default:ladder'},
	},
	{
		name = 'decorate your house with 5 Bookshelves',
		hint = '',
		feat = 'place_bookshelf', 
		count = 5, 
		reward = 'default:mese',
		placenode = {'default:bookshelf'},
	},
	{
		name = 'place 5 Signs to help other travellers',
		hint = '',
		feat = 'place_sign_wall', 
		count = 5, 
		reward = 'default:mese',
		placenode = {'default:sign_wall'},
	},
	{
		name = 'place 50 Torches to help you see at night',
		hint = '',
		feat = 'place_torch', 
		count = 50, 
		reward = 'default:mese',
		placenode = {'default:torch'},
	},
	{
		name = 'dig 500 Stone for your next project...',
		hint = '',
		feat = 'dig_stone', 
		count = 500, 
		reward = 'default:mese',
		dignode = {'default:stone'},
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
	return {x=pos.x,y=pos.y+40,z=pos.z}
end

-- make start blocks
skyblock.levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = skyblock.levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 5
	local hollow = 1
	skyblock.levels.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)

	-- level 3
	--minetest.env:add_node(pos, {name='skyblock:level_3'})
	--skyblock.feats.update(player_name)

end

-- get level information
skyblock.levels[level].get_info = function(player_name)
	local info = { level=level, total=10, count=0, player_name=player_name, infotext='', formspec = '' };

	info.formspec = skyblock.levels.get_inventory_formspec(level,info.player_name)
		..'label[0,0.5; Does This Keep Going?]'
		..'label[0,1.0; If you are enjoying this world, then stray not]'
		..'label[0,1.5; from your mission traveller...]'
		..'label[0,2.0; ... for the end is near.]'

	for k,v in ipairs(feats) do
		info.formspec = info.formspec..skyblock.levels.get_feat_formspec(info,k+1,v.feat,v.count,v.name,v.hint)
	end

	info.infotext = 'LEVEL '..info.level..' for '..info.player_name..': '..info.count..' of '..info.total
	
	return info
end

-- reward_feat
skyblock.levels[level].reward_feat = function(player_name,feat)
	skyblock.levels.reward_feat(feats, player_name, feat)
end

-- track digging feats
skyblock.levels[level].on_dignode = function(pos, oldnode, digger)
	skyblock.levels.on_placenode(feats, pos, oldnode, digger)
end

-- track placing feats
skyblock.levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	skyblock.levels.on_placenode(feats, pos, newnode, placer, oldnode)
end

-- track eating feats
skyblock.levels[level].on_item_eat = function(player_name, itemstack)
	skyblock.levels.on_item_eat(feats, player_name, itemstack)
end

-- track bucket feats
skyblock.levels[level].bucket_on_use = function(player_name, pointed_thing)
	skyblock.levels.bucket_on_use(feats, player_name, pointed_thing)
end

-- track bucket water feats
skyblock.levels[level].bucket_water_on_use = function(player_name, pointed_thing) 
	skyblock.levels.bucket_water_on_use(feats, player_name, pointed_thing)
end

-- track bucket lava feats
skyblock.levels[level].bucket_lava_on_use = function(player_name, pointed_thing)
	skyblock.levels.bucket_lava_on_use(feats, player_name, pointed_thing)
end