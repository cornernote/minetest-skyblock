--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--


-- quest node
minetest.override_item('skyblock:quest', {
    on_punch = function(pos, node, puncher)
		if not puncher then return end -- needed to prevent server crash when player leaves
		--local level = skyblock.feats.get_level(puncher:get_player_name())
		skyblock.feats.update(puncher:get_player_name())
	end,
    --on_dig = function(pos, node, digger)
		--if not digger then return end -- needed to prevent server crash when player leaves
		--local player_name = digger:get_player_name()
		--local spawn = skyblock.get_spawn(player_name)
		--skyblock.levels.spawn_diggers[player_name] = true
		--digger:set_hp(0)
	--end,
})

-- trees
local trees = {'default:tree','default:jungletree','default:pinetree'}
for k,node in ipairs(trees) do
	local groups = minetest.registered_nodes[node].groups
	groups.oddly_breakable_by_hand = 0
	minetest.override_item(node, {groups = groups})
end

-- leaves
local leaves = {'default:leaves','default:jungleleaves','default:pine_needles'}
for k,node in ipairs(leaves) do
	minetest.override_item(node, {climbable = true,	walkable = false})
end

-- instant grow sapling if there is room
minetest.override_item('default:sapling', {
	after_place_node = function(pos)
		-- check if we have space to make a tree
		for dy=1,4 do
			pos.y = pos.y+dy
			if minetest.env:get_node(pos).name ~= 'air' and minetest.env:get_node(pos).name ~= 'default:leaves' then
				return
			end
			pos.y = pos.y-dy
		end
		-- add the tree
		default.grow_tree(pos, math.random(1, 4) == 1)
	end,
})
