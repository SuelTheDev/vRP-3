if not vRP.modules.garages then return end

local Garage = class("Garage", vRP.Extension)
Garage.User = class("User")

local function menu_garage(self)
    vRP.EXT.GUI:registerMenuBuilder("garage", function(menu)
        menu.title = "Garage"
        menu.css.header_color = "rgba(0,150,255,0.75)"
        print(self)
        menu:addOption("Give Vehicle", function(menu)
            local coord = GetEntityCoords(GetPlayerPed(menu.user.source))
            local heli = CreateVehicle(`brioso`, coord.x, coord.y, coord.z + 2.0 , 0.0, true, true)                      
            while not DoesEntityExist(heli) do Citizen.Wait(1000) end
            print(heli)
            TaskWarpPedIntoVehicle(GetPlayerPed(menu.user.source), heli, -1)
        end)
    end)
end

function Garage:__construct()
    vRP.Extension.__construct(self)
    self.vehicles = {}
    self.cfg = module("cfg/garages")

    async(function()
        vRP:prepare("vRP/garages_table", [[
                CREATE TABLE IF NOT EXISTS `vrp_character_vehicles` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `char_id` INT(11) NOT NULL,
                `vehicle` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
                PRIMARY KEY (`id`) USING BTREE,
                UNIQUE INDEX `char_id_vehicle` (`char_id`, `vehicle`) USING BTREE,
                INDEX `vehicle` (`vehicle`) USING BTREE,
                CONSTRAINT `fk_vrp_user_vehicles_char_id` FOREIGN KEY (`char_id`) REFERENCES `vrp_characters` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE
            )
            COLLATE='utf8mb4_general_ci'
            ENGINE=InnoDB;
            ]])

        vRP:prepare("vRP/garage_addVehicle",
            "INSERT INTO vrp_character_vehicles (char_id, vehicle) VALUES (@charid, @vehicle)")
        vRP:prepare("vRP/garage_deleteVehicle",
            "DELETE FROM vrp_character_vehicles WHERE char_id = @charid and LOWER(vehicle) = LOWER(@vehicle)")

        vRP:execute("vRP/garages_table")
    end)

    menu_garage(self)

    vRP.EXT.GUI:registerMenuBuilder("admin", function(menu)
        menu:addOption("Garage", function(menu)
            menu.user:openMenu("garage", {})
        end)
    end)
end

AddStateBagChangeHandler("loaded", nil, function(bagName, _, value, _, _)
    if value then
        vRP:registerExtension(Garage)
    end
end)
