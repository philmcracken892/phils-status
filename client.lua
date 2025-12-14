RegisterCommand('status', function()
    lib.callback('rsg-status:server:getOnDuty', false, function(data)
        local options = {}

        if not data or next(data) == nil then
            options[#options + 1] = {
                title = 'No Employees Online',
                description = 'There are currently no employed players online',
                icon = 'user-slash'
            }
        else
            -- Sort jobs alphabetically
            local sortedJobs = {}
            for job in pairs(data) do
                table.insert(sortedJobs, job)
            end
            table.sort(sortedJobs)

            for _, job in ipairs(sortedJobs) do
                local players = data[job]
                local description = ''
                local playerCount = #players

                for _, p in ipairs(players) do
                    local dutyStatus = p.onduty and '🟢' or '🔴'
                    description = description .. ('%s %s (%s)\n'):format(dutyStatus, p.name, p.grade)
                end

                options[#options + 1] = {
                    title = FormatJobName(job),
                    description = description,
                    icon = GetJobIcon(job),
                    metadata = {
                        { label = 'Employees Online', value = playerCount }
                    }
                }
            end
        end

        lib.registerContext({
            id = 'on_duty_status',
            title = '👥 Employee Status',
            options = options
        })

        lib.showContext('on_duty_status')
    end)
end, false)

-- Helper function to format job names
function FormatJobName(job)
    return job:gsub("_", " "):gsub("(%a)([%w]*)", function(a, b)
        return string.upper(a) .. b
    end)
end

-- Helper function to get job icons
function GetJobIcon(job)
    local icons = {
        ['vallaw'] = 'shield-halved',
        ['blklaw'] = 'shield-halved',
		['rholaw'] = 'shield-halved',
		['stdenlaw'] = 'shield-halved',
		['strlaw'] = 'shield-halved',
        ['medic'] = 'kit-medical',
        ['lawyer'] = 'building-columns',
        ['unemployed'] = 'user'
    }
    return icons[job] or 'briefcase'
end