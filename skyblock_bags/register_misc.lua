--[[
	
Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

-- register bag tools
minetest.register_tool("skyblock_bags:small", {
	description = "Small Bag",
	inventory_image = "skyblock_bags_small.png",
	groups = {bagslots=8},
})
minetest.register_tool("skyblock_bags:medium", {
	description = "Medium Bag",
	inventory_image = "skyblock_bags_medium.png",
	groups = {bagslots=16},
})
minetest.register_tool("skyblock_bags:large", {
	description = "Large Bag",
	inventory_image = "skyblock_bags_large.png",
	groups = {bagslots=24},
})

-- register bag crafts
minetest.register_craft({
	output = "skyblock_bags:small",
	recipe = {
        {"", "default:stick", ""},
        {"default:wood", "default:wood", "default:wood"},
        {"default:wood", "default:wood", "default:wood"},
    },
})
minetest.register_craft({
	output = "skyblock_bags:medium",
	recipe = {
        {"skyblock_bags:small", "skyblock_bags:small"},
        {"skyblock_bags:small", "skyblock_bags:small"},
    },
})
minetest.register_craft({
	output = "skyblock_bags:large",
	recipe = {
        {"skyblock_bags:medium", "skyblock_bags:medium"},
        {"skyblock_bags:medium", "skyblock_bags:medium"},
    },
})

-- register_on_joinplayer
minetest.register_on_joinplayer(function(player)
	local player_inv = player:get_inventory()
	local bags_inv = minetest.create_detached_inventory(player:get_player_name().."_skyblock_bags",{
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, stack)
			player:get_inventory():set_size(listname.."contents", stack:get_definition().groups.bagslots)
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, nil)
		end,
		allow_put = function(inv, listname, index, stack, player)
			if stack:get_definition().groups.bagslots then
				return 1
			else
				return 0
			end
		end,
		allow_take = function(inv, listname, index, stack, player)
			if player:get_inventory():is_empty(listname.."contents")==true then
				return stack:get_count()
			else
				return 0
			end
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return 0
		end,
	})
	for i=1,4 do
		local bag = "skyblock_bag"..i
		player_inv:set_size(bag, 1)
		bags_inv:set_size(bag, 1)
		bags_inv:set_stack(bag,1,player_inv:get_stack(bag,1))
	end
end)