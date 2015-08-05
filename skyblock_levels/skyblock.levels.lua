--[[

Skyblock for Minetest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

]]--


skyblock.levels = {}

--
-- Functions
--

-- empty inventory
function skyblock.levels.empty_inventory(player)
	local inv = player:get_inventory()
	if not inv:is_empty('rewards') then
		for i=1,inv:get_size('rewards') do
			inv:set_stack('rewards', i, nil)
		end
	end
	if skyblock.levels.lose_bags_on_death then
		local bags_inv = minetest.get_inventory({type='detached', name=player:get_player_name()..'_bags'})
		for bag=1,4 do
			if not bags_inv:is_empty('bag'..bag) then
				for i=1,bags_inv:get_size('bag'..bag) do
					inv:set_stack('bag'..bag, i, nil)
				end
				for i=1,bags_inv:get_size('bag'..bag) do
					bags_inv:set_stack('bag'..bag, i, nil)
					inv:set_stack('bag'..bag..'contents', i, nil)
				end
			end
		end
	end
end


--
-- Formspec
--

-- get_formspec
function skyblock.levels.get_formspec(player_name)
	local level = skyblock.feats.get_level(player_name)
	local level_info = skyblock.levels[level].get_info(player_name)
	return level_info.formspec
end

-- get_inventory_formspec
function skyblock.levels.get_inventory_formspec(level,player_name,nav)
	local formspec = 'size[15,10;]'
	if nav then
		formspec = formspec
			..'button[7,0;2,0.5;bags;Bags]'
			..'button[9,0;2,0.5;craft;Crafting]'
	end
		
	formspec = formspec
		..'button_exit[13,0;2,0.5;close;Close]'
		..'background[-0.1,-0.1;6.6,10.3;goals.png]'
		..'label[0,0; --== LEVEL '..level..' for '..player_name..' ==--]'

		..'label[7,1.5; Rewards]'
		..'background[6.9,1.4;2.2,2.8;rewards.png]'
		..'list[current_player;rewards;7,2;2,2;]'

		..'label[10,1.5; Craft]'
		..'label[14,2.5;Output]'
		..'background[9.9,1.4;5.2,3.8;craft.png]'
		..'list[current_player;craft;10,2;3,3;]'
		..'list[current_player;craftpreview;14,3;1,1;]'
		
		..'label[7,5.5; Inventory]'
		..'background[6.9,5.4;8.2,4.8;inventory.png]'
		..'list[current_player;main;7,6;8,4;]'
	return formspec
end

-- render an item image button for the formspec
local function image_button_link(stack_string)
	local stack = ItemStack(stack_string);
	local new_node_name = stack_string;
	if stack and stack:get_name() then
		new_node_name = stack:get_name()
	end
	return tostring( stack_string )..';item_button_nochange_'..unified_inventory.mangle_for_formspec(new_node_name)..';';
end

-- get_feat_formspec
function skyblock.levels.get_feat_formspec(info,i,feat,required,text,hint)
	local y = 2.9+(i*0.6)
	local count = skyblock.feats.get(info.level,info.player_name,feat)
	if count > required then
		count = required
	end
	local formspec = 'label[0.5,'..y..'; '..text..' ('..count..'/'..required..')]'
	if hint then
		--formspec = formspec..'item_image_button[5.8,'..y..';0.6,0.6;'..unified_inventory.mangle_for_formspec(hint)..']'
		formspec = formspec..'item_image_button[5.8,'..y..';0.6,0.6;'..image_button_link(hint)..']'
		--formspec = formspec..stack_image_button(item_pos, unified_inventory.formspec_y, 1.1, 1.1, 'item_button_'..other_dir[dir]..'_', ItemStack(item_name))
	end
	if count == required then
		formspec = formspec .. 'image[-0.2,'..(y-0.25)..';1,1;checkbox_checked.png]'
		info.count = info.count + 1
	else
		formspec = formspec .. 'image[-0.2,'..(y-0.25)..';1,1;checkbox_unchecked.png]'
	end
	return formspec
end

--
-- Feat Checks
--

-- reward_feat
function skyblock.levels.reward_feat(level,player_name,feat)
	local count = skyblock.feats.get(level,player_name,feat)
	for _,v in ipairs(skyblock.levels[level].feats) do
		if v.feat == feat and v.count == count then
			skyblock.feats.give_reward(level,player_name,v.reward)
			return true
		end
	end
end

-- track digging feats
function skyblock.levels.on_dignode(level,pos,oldnode,digger)
	local player_name = digger:get_player_name()
	for _,v in ipairs(skyblock.levels[level].feats) do
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
function skyblock.levels.on_placenode(level,pos,newnode,placer,oldnode)
	local player_name = placer:get_player_name()
	for _,v in ipairs(skyblock.levels[level].feats) do
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

-- track eating feats
function skyblock.levels.on_item_eat(level,player_name,itemstack)
	local item_name = itemstack:get_name()
	for _,v in ipairs(skyblock.levels[level].feats) do
		if v.item_eat then
			for _,vv in ipairs(v.item_eat) do
				if item_name==vv then
					skyblock.feats.add(level,player_name,v.feat)
					return
				end
			end
		end
	end
end

-- track crafting feats
function skyblock.levels.on_craft(level,player_name,itemstack)
	local item_name = itemstack:get_name()
	for _,v in ipairs(skyblock.levels[level].feats) do
		if v.craft then
			for _,vv in ipairs(v.craft) do
				if item_name==vv then
					skyblock.feats.add(level,player_name,v.feat)
					return
				end
			end
		end
	end
end

-- track bucket feats
function skyblock.levels.bucket_on_use(level,player_name,pointed_thing)
	local node = minetest.env:get_node(pointed_thing.under)
	for _,v in ipairs(skyblock.levels[level].feats) do
		if v.bucket then
			for _,vv in ipairs(v.bucket) do
				if node.name == vv then
					skyblock.feats.add(level,player_name,v.feat)
					return
				end
			end
		end
	end
end

-- track bucket water feats
function skyblock.levels.bucket_water_on_use(level,player_name,pointed_thing) 
	local node = minetest.env:get_node(pointed_thing.under)
	for _,v in ipairs(skyblock.levels[level].feats) do
		if v.bucket_water then
			for _,vv in ipairs(v.bucket_water) do
				if node.name == vv then
					skyblock.feats.add(level,player_name,v.feat)
					return
				end
			end
		end
	end
end

-- track bucket lava feats
function skyblock.levels.bucket_lava_on_use(level,player_name,pointed_thing)
	local node = minetest.env:get_node(pointed_thing.under)
	for _,v in ipairs(skyblock.levels[level].feats) do
		if v.bucket_lava then
			for _,vv in ipairs(v.bucket_lava) do
				if node.name == vv then
					skyblock.feats.add(level,player_name,v.feat)
					return
				end
			end
		end
	end
end