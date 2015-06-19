--[[

SkyBlock for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

REGISTER NODES

]]--


--
-- Override Default Nodes
--

local entity

-- stone
entity = skyblock.registered("node","default:stone")
entity.drop = {
	max_items = 1,
	items = {
		{items = {"default:desert_stone"}, rarity = 20},
		{items = {"default:sandstone"}, rarity = 10},
		{items = {"default:cobble"}}
	}
}
minetest.register_node(":default:stone", entity)

-- trees
entity = skyblock.registered("node","default:tree")
entity.groups = {tree=1,snappy=1,choppy=2,flammable=2}
minetest.register_node(":default:tree", entity)

entity = skyblock.registered("node","default:jungletree")
entity.groups = {tree=1,snappy=1,choppy=2,flammable=2}
minetest.register_node(":default:jungletree", entity)

entity = skyblock.registered("node","default:pinetree")
entity.groups = {tree=1,snappy=1,choppy=2,flammable=2}
minetest.register_node(":default:pinetree", entity)

-- leaves
entity = skyblock.registered("node","default:leaves")
entity.drop = "default:leaves"
entity.groups = {oddly_breakable_by_hand=1, snappy=3, leafdecay=3, flammable=2}
entity.climbable = true
entity.walkable = false
minetest.register_node(":default:leaves", entity)

-- sapling
entity = skyblock.registered("node","default:sapling")
entity.after_place_node = skyblock.generate_tree
minetest.register_node(":default:sapling", entity)

-- sandstone
entity = skyblock.registered("node","default:sandstone")
entity.drop = "default:sandstone"
minetest.register_node(":default:sandstone", entity)

-- bucket_empty
entity = skyblock.registered("craftitem","bucket:bucket_empty")
entity.on_use = skyblock.bucket_on_use
minetest.register_craftitem(":bucket:bucket_empty", entity)

-- bucket_water
entity = skyblock.registered("craftitem","bucket:bucket_water")
entity.on_use = skyblock.bucket_water_on_use
entity.on_place = skyblock.bucket_water_on_use
minetest.register_craftitem(":bucket:bucket_water", entity)

-- bucket_lava
entity = skyblock.registered("craftitem","bucket:bucket_lava")
entity.on_use = skyblock.bucket_lava_on_use
entity.on_place = skyblock.bucket_lava_on_use
minetest.register_craftitem(":bucket:bucket_lava", entity)


-- default cacti auto-rotate when placed; on_use is not caught by the achievement-function
entity = skyblock.registered("item","default:cactus")
entity.on_place = nil
minetest.register_item(":default:cactus", entity)




local catch_on_place = function( v, is_craftitem )
	local def = minetest.registered_items[ v ];
	if( def and def.on_place ) then
		local old_on_place = def.on_place;
		def.on_place = function(itemstack, placer, pointed_thing)
			local old_count = itemstack:get_count();
			local res = old_on_place( itemstack, placer, pointed_thing );
			if( itemstack and itemstack:get_count() == old_count-1 ) then
				achievements.on_placenode(pointed_thing, {name=v,param2=0}, placer, nil);
			end
			return res;
		end
		if( is_craftitem == 1 ) then
			minetest.register_craftitem( ":"..v, def );
		else
			minetest.register_node( ":"..v, def );
		end
	end
end

local on_place_craftitems = {"doors:door_wood","doors:door_glass","doors:door_steel","doors:door_obsidian_glass"};
for _,v in ipairs( on_place_craftitems ) do
	catch_on_place( v, 1 );
end
local on_place_nodes = { "default:cactus", "farming:seed_wheat", "farming:seed_cotton"};
for _,v in ipairs( on_place_nodes ) do
	catch_on_place( v, 0 );
end
