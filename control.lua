local Event = require('__stdlib__/stdlib/event/event')

--Set up default MOD global variables
MOD = {}
MOD.name = 'pycoalprocessing'
MOD.fullname = 'PyCoalProcessing'
MOD.IF = 'PYC'
MOD.path = '__pycoalprocessing__'
MOD.config = require('config')

Event.build_events = {defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive}
Event.death_events = {defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}

--Activate any scripts needed.
require('scripts/tailings-pond')
require('scripts/wiki/wiki')
require('scripts/wiki/text-pages')
require('scripts/wiki/spreadsheet-pages')
require('scripts/wiki/statistics-page')

--Add in our remote interfaces
remote.add_interface(script.mod_name, require('__stdlib__/stdlib/scripts/interface'))

Event.register(Event.core_events.init, function()
	if remote.interfaces['freeplay'] then
		local created_items = remote.call('freeplay', 'get_created_items')
		created_items['burner-mining-drill'] = 10
		remote.call('freeplay', 'set_created_items', created_items)

		local debris_items = remote.call('freeplay', 'get_debris_items')
		debris_items['iron-plate'] = 100
		debris_items['copper-plate'] = 50
		remote.call('freeplay', 'set_debris_items', debris_items)
	end

	if remote.interfaces['silo_script'] then
		remote.call('silo_script', 'set_no_victory', true)
	end
end)

Event.register(defines.events.on_research_finished, function(event)
	local tech = event.research
	if tech.name == 'pyrrhic' and game.tick ~= 0 then
		local force = tech.force
		for _, player in pairs(game.connected_players) do
			if player.force == force then player.opened = nil end
		end
		game.set_game_state{
			game_finished = true,
			player_won = true,
			can_continue = true,
			victorious_force = force
		}
	end
end)

Event.register(Event.build_events, function(event)
	local inserter = event.created_entity
	if inserter.type ~= 'inserter' then return end
	if inserter.get_control_behavior()
		or next(inserter.circuit_connected_entities.red)
		or next(inserter.circuit_connected_entities.green)
		or inserter.get_filter(1)
	then
		return
	end
	inserter.inserter_filter_mode = 'blacklist'
end)

-- grumble grumble filters apply for the whole mod
for _, event in pairs(Event.build_events) do
	script.set_event_filter(event, {
		{
			filter = 'name',
			name = 'inserter'
		},
		{
			filter = 'name',
			name = 'burner-inserter'
		},
		{
			filter = 'type',
			type = 'inserter',
			mode = 'and'
		},
		{
			filter = 'type',
			type = 'storage-tank',
			mode = 'or'
		},
		{
			filter = 'name',
			name = 'tailings-pond',
			mode = 'and'
		},
		{
			filter = 'type',
			type = 'beacon',
			mode = 'or'
		}
	})
end

Event.register(defines.events.on_gui_opened, function(event)
	if event.gui_type ~= defines.gui_type.entity then
		return
	end
	if event.entity.type ~= "beacon" then
		return
	end
	if string.match(event.entity.name, "beacon%-AM") == nil then 
		return 
	end
	if game.players[event.player_index].gui.relative.Dials ~= nil then
		game.players[event.player_index].gui.relative.Dials.destroy()
	end
	local dial = game.players[event.player_index].gui.relative.add(
		{
			type = "frame",
			name = "Dials",
			anchor =
			{
				gui = defines.relative_gui_type.beacon_gui,
				position = defines.relative_gui_position.right
			},
			direction = "vertical",
			caption = "Beacon Dials"
		}
	)
	local AM = dial.add(
		{
			type = "flow",
			name = "AM_flow"
		}
	)
	AM.style.vertical_align = 'center'
	AM.add(
		{
			type = "label",
			name = "AM_label",
			caption = "AM"
		}
	)
	AM.add(
		{
			type = "slider",
			name = "AM",
			minimum_value = 1,
			maximum_value = 10,
			value = event.entity.name:match('%d+'),
			discrete_slider = true,
			caption = "AM"
		}
	)
	AM.add(
		{
			type = "textfield",
			name = "AM_slider_num",
			text = event.entity.name:match('%d+'),
			numeric = true,
			lose_focus_on_confirm = true,
		}
	).style.maximal_width = 50
	local FM = dial.add(
		{
			type = "flow",
			name = "FM_flow"
		}
	)
	FM.style.vertical_align = 'center'
	FM.add(
		{
			type = "label",
			name = "FM_label",
			caption = "FM"
		}
	)
	FM.add(
		{
			type = "slider",
			name = "FM",
			minimum_value = 1,
			maximum_value = 10,
			value = event.entity.name:match('%d+$'),
			discrete_slider = true,
			caption = "FM"
		}
	)
	FM.add(
		{
			type = "textfield",
			name = "FM_slider_num",
			text = event.entity.name:match('%d+$'),
			numeric = true,
			lose_focus_on_confirm = true,
		}
	).style.maximal_width = 50
	dial.add(
		{
			type = "button",
			name = "radio_confirm",
			caption = "CONFIRM"
		}
	)
end)

Event.register(defines.events.on_gui_value_changed, function(event)
	if event.element.name == "AM" or event.element.name == "FM" then
		if event.element.name == "AM" then
			local AM = event.element
			AM.parent.AM_slider_num.text = tostring(AM.slider_value)
		end
		if event.element.name == "FM" then
			local FM = event.element
			FM.parent.FM_slider_num.text = tostring(FM.slider_value)
		end
	end
end)

Event.register(defines.events.on_gui_confirmed, function(event)
	if event.element.name == "AM_slider_num" or event.element.name == "FM_slider_num" then
		if event.element.name == "AM_slider_num" then
			local AM = event.element
			AM.parent.AM.slider_value = tonumber(AM.text)
		end
		if event.element.name == "FM_slider_num" then
			local FM = event.element
			FM.parent.FM.slider_value = tonumber(FM.text)
		end
	end
end)

local function beacon_check(beacon, killed)
	local killed = killed or false
	local recivers = beacon.get_beacon_effect_receivers()
	for r, reciver in pairs(recivers) do
		local beacons = reciver.get_beacons()
		local beacon_count = {}
		for b, bea in pairs(beacons) do
			log("hit")
			if killed == true and bea.unit_number == beacon.unit_number then
				log("hit")
			elseif bea.valid then
				if beacon_count[bea.name] == nil then
					beacon_count[bea.name] = 1
				elseif beacon_count[bea.name] ~= nil then
					beacon_count[bea.name] = beacon_count[bea.name] + 1
				end
			end
		end
		log(serpent.block(beacon_count))
		if next(beacon_count) ~= nil then
			for b, bea in pairs(beacons) do
				if beacon_count[bea.name] ~= nil then
					if beacon_count[bea.name] > 1 then
						bea.active = false
					elseif beacon_count[bea.name] <= 1 then
						bea.active = true
					end
				end
			end
		elseif next(beacon_count) == nil then
			for b, bea in pairs(beacons) do
					bea.active = true
			end
		end
	end
end

Event.register(defines.events.on_gui_click, function(event)
	if event.element.name == "radio_confirm" then
		log("hit")
		local GO = event.element
		local beacon = game.players[event.player_index].opened
		if beacon.name ~= "beacon-AM" .. GO.parent.AM_flow.AM.slider_value .. "-FM" .. GO.parent.FM_flow.FM.slider_value then
			local player = game.players[event.player_index]
			local surface = game.surfaces[player.surface.name]
			local new_beacon = surface.create_entity{
				name = "beacon-AM" .. GO.parent.AM_flow.AM.slider_value .. "-FM" .. GO.parent.FM_flow.FM.slider_value,
				position = beacon.position,
				force = beacon.force
			}
			local module_slot = beacon.get_inventory(defines.inventory.beacon_modules)
			if module_slot.is_empty ~= true then
				local new_beacon_slots = new_beacon.get_inventory(defines.inventory.beacon_modules)
				local modules = module_slot.get_contents()
				log(serpent.block(modules))
				for item, amount in pairs(modules) do
					log(item)
					log(amount)
					new_beacon_slots.insert{name = item, count = amount}
				end
			end
			beacon.destroy()
			player.opened = new_beacon
			beacon_check(new_beacon)
		end
	end
end)

Event.register(Event.build_events, function(event)
	local beacon = event.created_entity
	if beacon.type ~= "beacon" then return end
	if string.match(beacon.name, "beacon%-AM") == nil then return end
	--local killed = false
	beacon_check(beacon, killed)
end)

Event.register(Event.death_events, function(event)
	local beacon = event.entity
	if beacon.type ~= "beacon" then return end
	if string.match(beacon.name, "beacon%-AM") == nil then return end
	local killed = true
	beacon_check(beacon, killed)
end)