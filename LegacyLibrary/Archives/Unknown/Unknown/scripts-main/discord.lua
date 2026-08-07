local request = request or http_request or (syn and syn.request)

if not request then
    return function() end
end

local joinDiscord = function (inviteCode)
    local s = 6463
    for i=s-10, s+1 do
        spawn(function()
            pcall(function()
                request({
                    Url = 'http://127.0.0.1:' .. tostring(i) .. '/rpc?v=1',
                    Method = 'POST',
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = game:GetService('HttpService'):JSONEncode({
                        ["cmd"] = "INVITE_BROWSER",
                        ["nonce"] = game:GetService('HttpService'):GenerateGUID(false),
                        ["args"] = {
                            ["invite"] = {
                                ["code"] = inviteCode,
                            },
                            ["code"] = inviteCode
                        }
                    })
                })
            end)
        end)
    end
end

return joinDiscord
