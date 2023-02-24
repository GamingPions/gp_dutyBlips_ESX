-- Gets triggered if any resource gets stopped
AddEventHandler('onResourceStop', function(resource)
    -- check if this resource gets stopped
	if resource == GetCurrentResourceName() then
        for k,v in pairs(Config.BlipList) do
            for k,v in pairs(v.JobBlips) do
                if DoesBlipExist(v.Blip) then
                    -- delete all blips (just for safty, perhaps isnt even necessary)
                    RemoveBlip(v.Blip)
                end
            end
        end
	end
end)

RegisterNetEvent("gp_dutyBlips:SetBlips")
AddEventHandler("gp_dutyBlips:SetBlips", function(JobInformation)
    for JobName, BilpData in pairs(Config.BlipList) do
        for k,v in pairs(BilpData.JobBlips) do
            if DoesBlipExist(v.Blip) then
                SetBlipColour(v.Blip, JobInformation[JobName].color)
                ShowTickOnBlip(v.Blip, JobInformation[JobName].showTick)
            else
                v.Blip = AddBlipForCoord(v.BlipCoord.x, v.BlipCoord.y, v.BlipCoord.z)
                SetBlipSprite(v.Blip, v.BlipSprite)
                SetBlipScale(v.Blip, v.BlipScale)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.DisplayName)
                EndTextCommandSetBlipName(v.Blip)
                SetBlipColour(v.Blip, JobInformation[JobName].color)
                SetBlipAsShortRange(v.Blip, true)
                ShowTickOnBlip(v.Blip, JobInformation[JobName].showTick)
            end
        end
    end
end)

RegisterNetEvent("gp_dutyBlips:refreshBlipsForJob")
AddEventHandler("gp_dutyBlips:refreshBlipsForJob", function(JobName, JobInformation)
    -- Change all blips colors of the given job
    for k,v in pairs(Config.BlipList[JobName].JobBlips) do
        if DoesBlipExist(v.Blip) then
            SetBlipColour(v.Blip, JobInformation.color)
            ShowTickOnBlip(v.Blip, JobInformation.showTick)
        end
    end
end)