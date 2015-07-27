--[[
	
Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--

skyblock.bags = {}

-- get_formspec
local get_formspec = function(player,page)
	if page=="skyblock_bags" then
		local player_name = player:get_player_name()
		return "size[8,7.5]"
			.."list[current_player;main;0,3.5;8,4;]"
			.."button[0,0;2,0.5;main;Back]"
			.."button[0,2;2,0.5;skyblock_bag1;Bag 1]"
			.."button[2,2;2,0.5;skyblock_bag2;Bag 2]"
			.."button[4,2;2,0.5;skyblock_bag3;Bag 3]"
			.."button[6,2;2,0.5;skyblock_bag4;Bag 4]"
			.."list[detached:"..player_name.."_skyblock_bags;skyblock_bag1;0.5,1;1,1;]"
			.."list[detached:"..player_name.."_skyblock_bags;skyblock_bag2;2.5,1;1,1;]"
			.."list[detached:"..player_name.."_skyblock_bags;skyblock_bag3;4.5,1;1,1;]"
			.."list[detached:"..player_name.."_skyblock_bags;skyblock_bag4;6.5,1;1,1;]"
	end
	for i=1,4 do
		if page=="skyblock_bag"..i then
			local image = player:get_inventory():get_stack("skyblock_bag"..i, 1):get_definition().inventory_image
			return "size[8,8.5]"
				.."list[current_player;main;0,4.5;8,4;]"
				.."button[0,0;2,0.5;main;Main]"
				.."button[2,0;2,0.5;skyblock_bags;Bags]"
				.."image[7,0;1,1;"..image.."]"
				.."list[current_player;skyblock_bag"..i.."contents;0,1;8,3;]"
		end
	end
end

-- on_receive_fields
skyblock.bags.on_receive_fields = function(player, formname, fields)
	if fields.skyblock_bags then
		minetest.show_formspec(player:get_player_name(), "skyblock:bags", get_formspec(player,"skyblock_bags"));
		return
	end
	for i=1,4 do
		local page = "skyblock_bag"..i
		if fields[page] then
			if player:get_inventory():get_stack(page, 1):get_definition().groups.bagslots==nil then
				page = "skyblock_bags"
			end
			minetest.show_formspec(player:get_player_name(), "skyblock:bags", get_formspec(player,page));
			return
		end
	end
end
minetest.register_on_player_receive_fields(skyblock.bags.on_receive_fields)
