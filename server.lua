local RSGCore = exports['rsg-core']:GetCoreObject()

lib.callback.register('rsg-status:server:getOnDuty', function()
    local employees = {}

    for _, src in pairs(RSGCore.Functions.GetPlayers()) do
        local Player = RSGCore.Functions.GetPlayer(src)
        
        if Player then
            local job = Player.PlayerData.job
            local charinfo = Player.PlayerData.charinfo

            -- Include all jobs except unemployed (change if needed)
            if job and job.name ~= 'unemployed' then
                if not employees[job.name] then
                    employees[job.name] = {}
                end

                table.insert(employees[job.name], {
                    name = charinfo.firstname .. ' ' .. charinfo.lastname,
                    grade = job.grade.name or tostring(job.grade.level),
                    onduty = job.onduty or false
                })
            end
        end
    end

    return employees
end)