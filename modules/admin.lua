-- https://github.com/ImagicTheCat/vRP
-- MIT license (see LICENSE or vrp/vRPShared.lua)

if not vRP.modules.admin then return end

local htmlEntities = module("lib/htmlEntities")
local lang = vRP.lang
local Admin = class("Admin", vRP.Extension)


local function menu_admin_models(self)
	vRP.EXT.GUI:registerMenuBuilder("admin.models", function(menu)
		local user = menu.user
		menu.title = lang.main_menu.admin.change_ped_model()
		menu.r = 194
		menu.g = 10
		menu.b = 129

		menu:addButtonOption("😊", lang.main_menu.skin_menu.input(), function(menu)
			local model = user:prompt(lang.admin.skin_menu.description(), "")
			if model then
				print(model)
			end
		end, lang.admin.skin_menu.description())

		local modelFiles = LoadResourceFile(GetCurrentResourceName(), "playermodels.json")
		if modelFiles then
			local modeltable = json.decode(modelFiles)
			for _, v in ipairs(modeltable.models) do
				menu:addButtonOption("😊", v, function(menu)
					print("SET MODEL", v)
				end)
			end
		end
	end)
end

local function menu_admin(self)
	vRP.EXT.GUI:registerMenuBuilder("admin", function(menu)
		local user = menu.user
		menu.title = lang.main_menu.admin.title()
		menu.subtitle = lang.main_menu.admin.description()
		menu.r = 255
		menu.g = 0
		menu.b = 0

		if user:hasPermission("player.noclip") then
			menu:addCheckboxOption("📎", lang.main_menu.admin.no_clip(), function(menu, mod, id)
				
				Player(user.source).state:set('noclip', mod, true)
			end, "", Player(user.source).state.noclip or false)
		end

		if user:hasPermission("player.revive") then
			menu:addCheckboxOption("🔱", lang.main_menu.admin.god_mode(), function(menu, mod, id)
				
			end)
		end

		if user:hasPermission("admin.wall") then
			menu:addCheckboxOption("🧱", lang.main_menu.admin.active_wall(), function(menu, mod, id)
				Player(user.source).state:set('wall', mod, true)				
			end, "", Player(user.source).state.wall or false)
		end


		if user:hasPermission("player.custom_model") then
			menu:addButtonOption("😊", lang.main_menu.admin.change_ped_model(), function(menu)
				menu.user:openMenu("admin.models")
			end)
		end
	end)
end

function Admin:__construct()
	vRP.Extension.__construct(self)

	menu_admin(self)
	menu_admin_models(self)

	-- main menu
	vRP.EXT.GUI:registerMenuBuilder("main", function(menu)
		menu:addButtonOption("⚙️", lang.main_menu.admin.title(), function(menu)
			menu.user:openMenu('admin')
		end, lang.main_menu.admin.description())

		menu:addButtonOption("🙍", lang.main_menu.users.title(), function(menu)
			menu.user:openMenu('users')
		end, lang.main_menu.admin.description())
	end)
end

AddStateBagChangeHandler("loaded", nil, function(bagName, _, value, _, _)
	if value then
		vRP:registerExtension(Admin)
	end
end)
