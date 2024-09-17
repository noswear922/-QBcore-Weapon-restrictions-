local allowedWeapons = {
    "WEAPON_AIRSOFTAK47",
    "WEAPON_AIRSOFTGLOCK20",
    "WEAPON_AIRSOFTM4",
    "WEAPON_AIRSOFTM249",
    "WEAPON_AIRSOFTUZIMICRO",
    "WEAPON_AIRSOFTMP5",
    "WEAPON_AIRSOFTR700",
    "WEAPON_AIRSOFTG36C",
    "WEAPON_AIRSOFTR870"
}

Config = {}
Config.AllowedZone = { 
    coordinates = vector3(2025.99, 2784.98, 76.39), -- Center of the zone
    radius = 58, -- Radius of the zone
}

function isInAllowedZone(playerCoords)
    local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, Config.AllowedZone.coordinates.x, Config.AllowedZone.coordinates.y, Config.AllowedZone.coordinates.z)
    return distance <= Config.AllowedZone.radius
end

Citizen.CreateThread(function()
    local notified = false  

    while true do
        Citizen.Wait(0) 

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, weapon in ipairs(allowedWeapons) do
            if HasPedGotWeapon(playerPed, GetHashKey(weapon), false) then
               
                if not isInAllowedZone(playerCoords) then
                    
                    DisableControlAction(1, 24, true)  
                    DisableControlAction(1, 257, true) 

                    if not notified then
                        TriggerEvent('QBCore:Notify', 'You cannot shoot outside the allowed zone!', 'error')
                        notified = true  
                    end
                else
                    notified = false  
                end
            end
        end
    end
end)