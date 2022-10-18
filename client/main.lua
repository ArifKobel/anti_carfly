function TeleportPedToGround()
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  local groundZ = getGroundZ(coords.x, coords.y, coords.z)
  local vehicle = GetVehiclePedIsIn(ped, false)
  
  SetEntityCoords(vehicle, coords.x, coords.y, groundZ)
  SetVehicleOnGroundProperly(vehicle)
end

function getGroundZ(x, y, z)
  local retval, groundZ = GetGroundZFor_3dCoord(x, y, z, true)
  return groundZ
end

Citizen.CreateThread(function()
  local ped = PlayerPedId()

  while true do
    Citizen.Wait(config.Settings.CheckingInterval)

    local coords = GetEntityCoords(ped)
    local groundZ = getGroundZ(coords.x, coords.y, coords.z)

    if groundZ == 0.0 then
      goto continue
    end

    if IsPedInAnyVehicle(ped, false) == false then
      goto continue
    end

    if IsPedInAnyPlane(ped) or IsPedInAnyHeli(ped) then
      goto continue
    end

    if coords.z - groundZ > config.Settings.DistanceToGround then
      TeleportPedToGround()
    end

    ::continue::
  end
end)