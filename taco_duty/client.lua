

Citizen.CreateThread(function()
    for k,v in pairs(Config.NPC) do
        RequestModel(GetHashKey(v[7]))
        while not HasModelLoaded(GetHashKey(v[7])) do
            Wait(1)
        end

        RequestAnimDict("anim@heists@heist_corona@single_team")
        while not HasAnimDictLoaded("anim@heists@heist_corona@single_team") do
            Wait(1)
        end
        ped =  CreatePed(4, v[6],v[1],v[2],v[3], false, true)
        SetEntityHeading(ped, v[5])
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskPlayAnim(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss", 8.0, 0.0, -1, 1, 0, 0, 0, 0) 
        entities = ped

        local options = {
            {
                name = 'ox:option1',
                event = 'taco_duty:ChangeDutyOn',
                icon = 'fa-solid fa-road',
                label = 'On duty',
                canInteract = function(entity, distance, coords, name, bone)
                    return not IsEntityDead(entity)
                end
            },
            {
                name = 'ox:option2',
                event = 'taco_duty:ChangeDutyOff',
                icon = 'fa-solid fa-road',
                label = 'Off Duty',
                canInteract = function(entity, distance, coords, name, bone)
                    return not IsEntityDead(entity)
                end
            }
        }
        
        exports.ox_target:addLocalEntity(entities, options)
    end
end)



RegisterNetEvent("taco_duty:ChangeDutyOn")
AddEventHandler("taco_duty:ChangeDutyOn", function()
    local duty = true
    TriggerServerEvent("taco_duty:ChangeDutyServer", duty)
end)
RegisterNetEvent("taco_duty:ChangeDutyOff")
AddEventHandler("taco_duty:ChangeDutyOff", function()
    local duty = false
    TriggerServerEvent("taco_duty:ChangeDutyServer", duty)
end)