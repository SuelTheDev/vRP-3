-- https://github.com/ImagicTheCat/vRP
-- MIT license (see LICENSE or vrp/vRPShared.lua)

if not vRP.modules.admin then return end

local Admin = class("Admin", vRP.Extension)

-- METHODS

function Admin:__construct()
  vRP.Extension.__construct(self)
  self.noclip = false
  self.spectate = false
  self.lastCoord = nil
  self.target = nil
  self.noclipEntity = nil
  self.noclip_speed = 1.0
  -- self.
  self.wallthread = false

  -- AddStateBagChangeHandler(nil, nil, function(bagName, key, value)
  --   local player = GetPlayerFromStateBagName(bagName)
  --   if player == 0 then return end
  --   if key == "wall" then
  --     self:toogleWall(value)
  --   end
  -- end)
end



function Admin:toogleWall(state)
  if state and not self.wallthread then
    self.wallthread = true
    Citizen.CreateThread(function()
      while self.wallthread do
        local myPos = GetEntityCoords(PlayerPedId())
        for k in pairs(vRP.EXT.Misc:getClosestPeds(250)) do          
          local pos = GetEntityCoords(k) -- colocar o ponto diretamente na função getClosest
          DrawLine(myPos.x, myPos.y, myPos.z, pos.x, pos.y, pos.z, 255, 0, 0)
          vRP.EXT.Misc:draw3dText(pos, "Wall " .. k , 1.0, 4, { 255, 0, 0 }, true)
        end
        Citizen.Wait(0)
      end
    end)
  elseif self.wallthread and not state then
    self.wallthread = false
  end
end

-- TUNNEL
Admin.tunnel = {}


vRP:registerExtension(Admin)
