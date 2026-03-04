local Teams, Export = {}, Jet.dep.teams.object

---@param source integer
---@return boolean
function Teams.InTeam(source)
    return Export:IsPlayerInTeamSimple(source)
end

---@param source integer
---@return table
function Teams.GetMembers(source)
    return Export:GetTeamMembersSimple(source)
end

---@param source integer
---@param func function
function Teams.Run(source, func)
    local teamMembers = Export:GetTeamMembersSimple(source)
    for i = 1, #teamMembers do
        func(teamMembers[i].source)
    end
end

return Teams