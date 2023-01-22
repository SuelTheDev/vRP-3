-- https://github.com/ImagicTheCat/vRP
-- MIT license (see LICENSE or vrp/vRPShared.lua)


local vRPShared = module("vrp", "vRPShared")

-- Client vRP
local vRP = class("vRP", vRPShared)


function vRP:__construct()

  vRPShared.__construct(self)
  self.cfg = module("vrp", "cfg/client")
  AddStateBagChangeHandler("loaded", nil, function(_, _, value, _, _)
    print("loaded")
    if value then
      TriggerServerEvent("vRPcli:playerSpawned")
    end
  end)
end

return vRP
