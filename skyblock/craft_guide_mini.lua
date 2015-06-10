
craft_guide_mini = {}

-- some common groups
craft_guide_mini.group_placeholder = {};
craft_guide_mini.group_placeholder[ 'group:wood'  ] = 'default:wood';
craft_guide_mini.group_placeholder[ 'group:tree'  ] = 'default:tree';
craft_guide_mini.group_placeholder[ 'group:stick' ] = 'default:stick';
craft_guide_mini.group_placeholder[ 'group:stone' ] = 'default:cobble'; -- 'default:stone';  point people to the cheaper cobble
craft_guide_mini.group_placeholder[ 'group:sand'  ] = 'default:sand';
craft_guide_mini.group_placeholder[ 'group:leaves'] = 'default:leaves';
craft_guide_mini.group_placeholder[ 'group:wood_slab'] = 'stairs:slab_wood';
craft_guide_mini.group_placeholder[ 'group:wool'  ] = 'wool:white';

-- handle the standard dye color groups
if( dyelocal and dyelocal.dyes ) then
	for i,d in ipairs( dyelocal.dyes ) do
		for k,v in pairs(d[3]) do
			if( k ~= 'dye' ) then
				craft_guide_mini.group_placeholder[ 'group:dye,'..k ] = 'dye:'..d[1];
			end
		end
	end
end

craft_guide_mini.image_button_link = function( stack_string )
	local group = '';
	if( craft_guide_mini.group_placeholder[ stack_string ] ) then
		stack_string = craft_guide_mini.group_placeholder[ stack_string ];
		group = 'G';
	end		
-- TODO: show information about other groups not handled above
	local stack = ItemStack( stack_string );
	local new_node_name = stack_string;
	if( stack and stack:get_name()) then
		new_node_name = stack:get_name();
	end
	return tostring( stack_string )..';'..tostring( new_node_name )..';'..group;
end


craft_guide_mini.inspect_show_crafting = function( name, node_name, fields )
	if( not( name )) then
		return;
	end
	local receipe_nr = 1;
	if( not( node_name )) then
		node_name  = fields.node_name;
		receipe_nr = tonumber(fields.receipe_nr);
	end

	-- the player may ask for receipes of indigrents to the current receipe
	if( fields ) then
		for k,v in pairs( fields ) do
			if( v and v=="" and (minetest.registered_items[ k ]
			                 or  minetest.registered_nodes[ k ]
			                 or  minetest.registered_craftitems[ k ]
			                 or  minetest.registered_tools[ k ] )) then
				node_name = k;
				receipe_nr = 1;
			end
		end
	end

	local res = minetest.get_all_craft_recipes( node_name );
	if( not( res )) then
		res = {};
	end

	-- offer all alternate creafting receipes thrugh prev/next buttons
	if(     fields and fields.prev_receipe and receipe_nr > 1 ) then
		receipe_nr = receipe_nr - 1;
	elseif( fields and fields.next_receipe and receipe_nr < #res ) then
		receipe_nr = receipe_nr + 1;
	end

	local formspec = "size[6,6]"..
		"label[0,0;Name:]"..
		"field[20,20;0.1,0.1;node_name;node_name;"..node_name.."]".. -- invisible field for passing on information
		"field[21,21;0.1,0.1;receipe_nr;receipe_nr;"..tostring( receipe_nr ).."]".. -- another invisible field
		"label[1,0;"..tostring( node_name ).."]"..
		"item_image_button[5,2;1.0,1.0;"..tostring( node_name )..";normal;]";
	if( not( res ) or receipe_nr > #res or receipe_nr < 1 ) then
		receipe_nr = 1;
	end
	if( res and receipe_nr > 1 ) then
		formspec = formspec.."button[3.8,5;1,0.5;prev_receipe;prev]";
	end
	if( res and receipe_nr < #res ) then
		formspec = formspec.."button[5.0,5;1,0.5;next_receipe;next]";
	end
	if( not( res ) or #res<1) then
		formspec = formspec..'label[3,1;No receipes.]';
		if(   minetest.registered_nodes[ node_name ]
		  and minetest.registered_nodes[ node_name ].drop ) then
			local drop = minetest.registered_nodes[ node_name ].drop;
			if( drop and type( drop )=='string' and drop ~= node_name ) then
				formspec = formspec.."label[2,1.6;Drops on dig:]"..
					"item_image_button[2,2;1.0,1.0;"..craft_guide_mini.image_button_link( drop ).."]";
			end
		end
	else
		formspec = formspec.."label[1,5;Alternate "..tostring( receipe_nr ).."/"..tostring( #res ).."]";
		-- reverse order; default receipes (and thus the most intresting ones) are usually the oldest
		local receipe = res[ #res+1-receipe_nr ];
		if(     receipe.type=='normal'  and receipe.items) then
			for i=1,9 do
				if( receipe.items[i] ) then
					formspec = formspec.."item_image_button["..(((i-1)%receipe.width)+1)..','..(math.floor((i-1)/receipe.width)+1)..";1.0,1.0;"..
							craft_guide_mini.image_button_link( receipe.items[i] ).."]";
				end
			end
		elseif( receipe.type=='cooking' and receipe.items and #receipe.items==1 ) then
			formspec = formspec.."item_image_button[1,1;3.4,3.4;"..craft_guide_mini.image_button_link( 'default:furnace' ).."]".. --default_furnace_front.png]"..
					"item_image_button[2.9,2.7;1.0,1.0;"..craft_guide_mini.image_button_link( receipe.items[1] ).."]";
		elseif( receipe.type=='colormachine' and receipe.items and #receipe.items==1 ) then
			formspec = formspec.."item_image_button[1,1;3.4,3.4;"..craft_guide_mini.image_button_link( 'colormachine:colormachine' ).."]".. --colormachine_front.png]"..
					"item_image_button[2,2;1.0,1.0;"..craft_guide_mini.image_button_link( receipe.items[1] ).."]";
		elseif( receipe.type=='saw'          and receipe.items and #receipe.items==1 ) then
			--formspec = formspec.."item_image[1,1;3.4,3.4;moreblocks:circular_saw]"..
			formspec = formspec.."item_image_button[1,1;3.4,3.4;"..craft_guide_mini.image_button_link( 'moreblocks:circular_saw' ).."]"..
					"item_image_button[2,0.6;1.0,1.0;"..craft_guide_mini.image_button_link( receipe.items[1] ).."]";
		else
			formspec = formspec..'label[3,1;Error: Unkown receipe.]';
		end
		-- show how many of the items the receipe will yield
		local outstack = ItemStack( receipe.output );
		if( outstack and outstack:get_count() and outstack:get_count()>1 ) then
			formspec = formspec..'label[5.5,2.5;'..tostring( outstack:get_count() )..']';
		end
	end
	minetest.show_formspec( name, "craft_guide_mini:crafting", formspec );
end

-- translate general formspec calls back to specific calls
craft_guide_mini.form_input_handler = function( player, formname, fields)
        if( formname and formname == "craft_guide_mini:crafting" and player and not( fields.quit )) then
		craft_guide_mini.inspect_show_crafting( player:get_player_name(), nil, fields );
                return;
        end
end

-- establish a callback so that input from the player-specific formspec gets handled
minetest.register_on_player_receive_fields( craft_guide_mini.form_input_handler );
