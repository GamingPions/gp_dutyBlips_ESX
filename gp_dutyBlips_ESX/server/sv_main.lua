JobInformation = {}

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        if Config.useUpdateChecker then UpdateChecker.checkForUpdate() end

        Citizen.Wait(1000)
        local Players = ESX.GetPlayers()

        -- Iterate over all jobs and insert them as false
        for k,v in pairs(Config.BlipList) do
            local memberCount = ServerFunctions.OnDutyMemberCount(k)
            JobInformation[k] = {
                color = ServerFunctions.GetRightBlipColor(k, memberCount),
                member = memberCount,
                showTick = ServerFunctions.IsBossOnline(k)
            }
        end

        for k,v in pairs(Players) do
            TriggerClientEvent("gp_dutyBlips:SetBlips", v, JobInformation)
        end
    end
end)

RegisterNetEvent('esx:playerLoaded', function(playerId)
    local src = playerId
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerJob = xPlayer.getJob().name
    
    TriggerClientEvent("gp_dutyBlips:SetBlips", src, JobInformation)

    if Config.BlipList[playerJob] ~= nil then
        if SharedFunctions.IsPlayerOnDuty(src) then
            JobInformation[playerJob].member = JobInformation[playerJob].member + 1
            if ServerFunctions.IsPlayerBoss(src, playerJob) then
                JobInformation[playerJob].showTick = true
            end
            ServerFunctions.RefreshBlipsColors(playerJob)
        end
    end
end)

-- Return number if player disconnects and owns control center
AddEventHandler('playerDropped', function(reason)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerJob = xPlayer.getJob().name
    
    if SharedFunctions.IsPlayerOnDuty(src) then
        JobInformation[playerJob].member = JobInformation[playerJob].member - 1
    end
    ServerFunctions.RefreshBlipsColors(playerJob)
end)