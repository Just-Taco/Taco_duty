local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPclient = Tunnel.getInterface("vRP", "taco_duty") 
vRP = Proxy.getInterface("vRP")

RegisterServerEvent("taco_duty:ChangeDutyServer")
AddEventHandler("taco_duty:ChangeDutyServer", function(duty)
    local source = source
    local user_id = vRP.getUserId({source})
    if duty == true then
        exports.oxmysql:query('SELECT * FROM duty WHERE user_id = ?', {user_id}, function(result)
            if result then
                for i = 1, #result do
                    local row = result[i]
                    if row.job == "0" then
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "Du er på job", length = 2500, style = { ['background-color'] = '#dc1313', ['color'] = '#ffffff' } })
                    else
                        vRP.addUserGroup({user_id, row.job})
                        exports.oxmysql:update('UPDATE duty SET job = ? WHERE user_id = ?', {0, user_id}, function(affectedRows) end)
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = "Du gik lige på job som: "..row.job.." ", length = 2500, style = { ['background-color'] = '#4ad066', ['color'] = '#ffffff' } })
                        print(row.job)
                    end
                end
            end
        end)
    else
        if vRP.getUserGroupByType({user_id,Config.jobtypes[1]}) ~= vRP.getUserGroupByType({user_id,"AbeMad?"}) then
            print("HELLOOO")
            jobs = vRP.getUserGroupByType({user_id,Config.jobtypes[1]})
        elseif vRP.getUserGroupByType({user_id,Config.jobtypes[2]}) ~= vRP.getUserGroupByType({user_id,"AbeMad?"}) then
            print("HELLOOO2")
            print(vRP.getUserGroupByType({user_id,Config.jobtypes[2]}))
            jobs = vRP.getUserGroupByType({user_id,Config.jobtypes[2]})
        elseif vRP.getUserGroupByType({user_id,Config.jobtypes[3]}) ~= vRP.getUserGroupByType({user_id,"AbeMad?"}) then
            print("HELLOOO3")
            jobs = vRP.getUserGroupByType({user_id,Config.jobtypes[3]})
        elseif vRP.getUserGroupByType({user_id,Config.jobtypes[4]}) ~= vRP.getUserGroupByType({user_id,"AbeMad?"}) then
            jobs = vRP.getUserGroupByType({user_id,Config.jobtypes[4]})
        elseif jobs == nil then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "Du har ikke et job?", length = 2500, style = { ['background-color'] = '#dc1313', ['color'] = '#ffffff' } })
        end
        Wait(500)
        print(jobs)
        if jobs then
            vRP.removeUserGroup({user_id,jobs})
            exports.oxmysql:update('UPDATE duty SET job = ? WHERE user_id = ?', {jobs, user_id}, function(affectedRows)
                if affectedRows ~= 0 then
                    print(affectedRows)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = "Du gik lige af job", length = 2500, style = { ['background-color'] = '#4ad066', ['color'] = '#ffffff' } })
                else
                    exports.oxmysql:insert('INSERT INTO duty (user_id, job) VALUES (?, ?)', {user_id, jobs}, function(id) end)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = "Du gik lige af job", length = 2500, style = { ['background-color'] = '#4ad066', ['color'] = '#ffffff' } })
                end
            end)
        end
    end
end)
