ServerFunctions = {}

ServerFunctions.CheckOffDuty = function(JobName, src)
    local Players = ESX.GetPlayers()
    -- Iterate over all jobs and insert them as false
    for k,v in pairs(Players) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.getJob().name == JobName and v ~= src then
            -- Check if player is onduty
            if SharedFunctions.IsPlayerOnDuty(v) then
                return true
            end
        end
    end

    return false
end

ServerFunctions.IsPlayerBoss = function(src, playerJob)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getJob().name ~= playerJob then return false end

    for k,v in pairs(Config.BlipList[playerJob]["bossRanks"]) do
        if v == xPlayer.getJob().grade_name and SharedFunctions.IsPlayerOnDuty(src) then
            return true
        end
    end
    return false
end

ServerFunctions.IsBossOnline = function(JobName)
    local Players = ESX.GetPlayers()

    for k,v in pairs(Players) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if ServerFunctions.IsPlayerBoss(xPlayer.source, JobName) then
            return true
        end
    end

    return false
end

ServerFunctions.RefreshBlipsColors = function(playerJob)
    local currentColor = JobInformation[playerJob].color
    local newColor = ServerFunctions.GetRightBlipColor(playerJob, JobInformation[playerJob].member)

    if newColor ~= currentColor then
        JobInformation[playerJob].color = newColor
        ServerFunctions.RefreshBlipsForJob(playerJob)
    end
end

ServerFunctions.RefreshBlipsForJob = function(JobName)
    local Players = ESX.GetPlayers()

    for k,v in pairs(Players) do
        TriggerClientEvent("gp_dutyBlips:refreshBlipsForJob", v, JobName, JobInformation[JobName])
    end
end

ServerFunctions.OnDutyMemberCount = function(JobName)
    local Players = ESX.GetPlayers()
    local onDutyPlayers = 0
    for k,v in pairs(Players) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.getJob().name == JobName and SharedFunctions.IsPlayerOnDuty(v) then
            onDutyPlayers = onDutyPlayers + 1
        end
    end
    return onDutyPlayers
end

ServerFunctions.GetRightBlipColor = function(JobName, MemberCount)
    local blipColors = Config.BlipList[JobName].blipColors
    local validColor = tonumber(blipColors[1])

    for color, neededMembers in pairs(blipColors) do
        if MemberCount >= neededMembers then
            validColor = tonumber(color)
        end
    end

    return validColor
end