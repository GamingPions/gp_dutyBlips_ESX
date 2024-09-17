SharedFunctions = {}

-- Server-Function to check if player is onduty
SharedFunctions.IsPlayerOnDuty = function(src)
    -- get player object
    local xPlayer = ESX.GetPlayerFromId(src)
    -- check if player is offduty
    if xPlayer.getJob().name:sub(1, 3) == "off" then
        -- return false if player is offduty
        return false
    else
        -- return true if player is onduty
        return true
    end
end

RegisterNetEvent('esx:setJob', function(source, job, lastJob)
    if lastJob ~= nil then
        -- Check if last job has any dutyBlips
        if Config.BlipList[lastJob["name"]] ~= nil then
            -- Check if player was onduty
            if lastJob["name"]:sub(1, 3) ~= "off" then
                -- Reduced member if player was onduty
                JobInformation[lastJob["name"]].member = JobInformation[lastJob["name"]].member - 1
                JobInformation[lastJob["name"]].showTick = ServerFunctions.IsBossOnline(lastJob["name"])
                -- Refresh dutyblips for last job
                ServerFunctions.RefreshBlipsColors(lastJob["name"])
            end
        end
    end
    
    if job ~= nil then
        local playerJob = job.name

        -- Check if the new job has any dutyBlips
        if Config.BlipList[playerJob] ~= nil then
            -- Check if player is onduty
            if SharedFunctions.IsPlayerOnDuty(source) then
                -- Increase member if player is onduty
                JobInformation[playerJob].member = JobInformation[playerJob].member + 1
                JobInformation[playerJob].showTick = ServerFunctions.IsBossOnline(playerJob)
                -- Refresh dutyblips for new job
                ServerFunctions.RefreshBlipsColors(playerJob)
            end
        end
    end
end)