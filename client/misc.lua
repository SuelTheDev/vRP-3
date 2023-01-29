-- https://github.com/ImagicTheCat/vRP
-- MIT license (see LICENSE or vrp/vRPShared.lua)

if not vRP.modules.misc then return end

local Misc = class("Misc", vRP.Extension)

function Misc:__construct()
	vRP.Extension.__construct(self)
end

function Misc:getEntity() -- checks if entity is ped or not
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then
		entity = GetVehiclePedIsIn(ped, false)
	else
		entity = ped
	end

	return entity
end

function Misc:getClosestPeds(radius) -- gets all nearby ped
	local r = {}
	local pos = GetEntityCoords(PlayerPedId())

	for _, pedAI in ipairs(GetGamePool('CPed')) do
		if pedAI ~= PlayerPedId() then
			local pedCoord =  GetEntityCoords(pedAI)
			local dist = #(pedCoord - pos)
			if dist <= radius then
				r[pedAI] = dist
			end
		end
	end

	return r
end

function Misc:getClosestPed(radius) --gets closest ped
	local p = nil

	local ai = self:getClosestPeds(radius)
	local min = radius + 10.0
	for k, v in pairs(ai) do
		if v < min then
			min = v
			p = k
		end
	end

	return p
end

function Misc:getClosestObjects(radius) -- gets all nearby objects
	local r = {}
	local pos = GetEntityCoords(PlayerPedId())

	for _, obj in ipairs(GetGamePool('CObject')) do
		if obj ~= PlayerPedId() then
			local objpos = GetEntityCoords(obj)
			local dist = #(objpos - pos)
			if dist <= radius then
				r[obj] = dist
			end
		end
	end

	return r
end

function Misc:getClosestObject(radius) --gets closest object
	local p = nil

	local obj = self:getClosestObjects(radius)
	local min = radius + 10.0
	for k, v in pairs(obj) do
		if v < min then
			min = v
			p = k
		end
	end

	return p
end

function Misc:getClosestPlayers(radius)
	local r = {}
	local ped = PlayerPedId()
	local pId = PlayerId()
	local pos = GetEntityCoords(ped)
	for _, player in ipairs(GetActivePlayers()) do
		if player ~= pId then
			local nped = GetPlayerPed(player)
			local dist = #(GetEntityCoords(nped) - pos)
			if dist <= radius then
				r[player] = dist
			end
		end
	end
	return r
end

function Misc:getClosestPlayer(radius)
	local p = nil
	local players = self:getClosestPlayers(radius)
	local min = radius + 10.0
	for k, v in pairs(players) do
		if v < min then
			min = v
			p = k
		end
	end
	return p
end

function Misc:draw3dText(pos, text, scale, font, color, outline)
	if not text or not pos then return end 
	if not scale then scale = 1.0 end
	if not font then font = 0 end
	if not color or not color[1] then color = {255,255,255} end
	
	local onscreen, y, z = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
	local p = GetGameplayCamCoord()
	local dist = #(p - pos)
	local _scale = (1 / dist) * scale	
	if onscreen then
		SetTextScale(0.0, _scale)
		SetTextFont(font)
		SetTextProportional(true)
		SetTextColour(color[1], color[2], color[3], 255)
		if outline then SetTextOutline() end
		SetTextCentre(true)
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandDisplayText(x, y)
	end

end

Misc.tunnel = {}

Misc.tunnel.getEntity = Misc.getEntity
Misc.tunnel.getClosestObject = Misc.getClosestObject
Misc.tunnel.getClosestObjects = Misc.getClosestObjects
Misc.tunnel.getClosestPed = Misc.getClosestPed
Misc.tunnel.getClosestPeds = Misc.getClosestPeds
Misc.tunnel.getClosestPlayers = Misc.getClosestPlayers
Misc.tunnel.getClosestPlayer = Misc.getClosestPlayer

vRP:registerExtension(Misc)
