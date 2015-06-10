--[[

SkyBlock for MineTest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL LOADER

]]--


--
-- Level Files
--

local max_level = 6

levels = {}
for level=1,max_level do
	dofile(minetest.get_modpath("skyblock").."/levels/extended/level_"..tostring( level)..".lua")
end

--
-- Level Nodes
--

for level=1,max_level do
	minetest.register_node("skyblock:level_"..level, {
		description = "Level "..level,
		tiles = {"skyblock_"..level..".png"},
		is_ground_content = true,
		paramtype = "light",
		light_propagates = true,
		sunlight_propagates = true,
		light_source = 15,		
		groups = {crumbly=2,cracky=2},
		on_punch = function(pos, node, puncher)
			achievements.level_on_punch(level, pos, node, puncher)
		end,
		on_dig = function(pos, node, digger)
			achievements.level_on_dig(level, pos, node, digger)
		end,
		on_construct = function(pos)
			minetest.env:get_meta(pos):get_inventory():set_size("rewards", 2*2)
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			if( sender and craft_guide_mini and craft_guide_mini.inspect_show_crafting and fields and not(fields.quit)) then
				for k,v in pairs( fields ) do
					if( k ) then
						craft_guide_mini.inspect_show_crafting( sender:get_player_name(), k, fields );
						return;
					end
				end
			end
		end
	})
end


-- increases data.count by 1 if the achievement has been reached
skyblock.list_tasks = function( data, nr, achievement_name, amount, text, craft_guide_hint )
	local formspec = "label[9,"..(nr-1).."; "..nr..") "..text.."]";
	if( craft_guide_hint and craft_guide_mini and craft_guide_mini.image_button_link) then
		formspec = formspec.."item_image_button[8,"..(nr-1)..";1.0,1.0;"..
			craft_guide_mini.image_button_link( craft_guide_hint ).."]"
	end
	local done = achievements.get(data.level,data.player_name,achievement_name);
	if done >= amount then
		formspec = formspec .. "label[9.3,"..(nr-1)..".4; COMPLETE!]"
		data.count = data.count + 1
	elseif done<1 then
		formspec = formspec .. "label[9.3,"..(nr-1)..".4; not done]"
	else
		formspec = formspec .. "label[9.3,"..(nr-1)..".4; Progress: "..tostring(done).."/"..tostring(amount).." done]"
	end

        -- next level
        if data.count==data.total and achievements.get(0,data.player_name,"level")==data.level then
                levels[data.level+1].make_start_blocks(data.player_name)
                achievements.add(0,data.player_name,"level")
        end
        if  achievements.get(0,data.player_name,"level") > data.level then
                local pos = levels[data.level+1].get_pos(data.player_name)
                if pos and minetest.env:get_node(pos).name ~= "skyblock:level_"..tostring(data.level+1) then
                        levels[data.level+1].make_start_blocks(data.player_name)
                end
        end

        data.infotext = "LEVEL "..data.level.." for ".. data.player_name ..": ".. data.count .." of "..data.total

	return formspec;
end
