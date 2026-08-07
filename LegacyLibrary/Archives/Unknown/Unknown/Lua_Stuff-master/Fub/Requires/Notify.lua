NotifyTable = {}

local Screen = Instance.new('ScreenGui',game.CoreGui)
Screen.Name = 'Notifications'
function NotifyTable:SendMessage(msg)
    local start = UDim2.new(1,0,1,-50 + -50*#Screen:GetChildren())
    local no = Instance.new('TextLabel',Screen)
    no.Size = UDim2.new(0,140,0,40)
    no.Position = start
    no.Text = msg
    no:TweenPosition(start - UDim2.new(0,150,0,0),'Out','Sine',.5)
    wait(1)
    no:Destroy()
end

Notify = setmetatable(NotifyTable,{
    __index = function(self,prop)
        if self[prop] then
            return rawget(self,prop)
        else
            return game.Players.LocalPlayer:GetMouse()[prop]
        end
    end,
    __tostring = function(self)
        return "Notifications {Embed Functions}"
    end,
})



return Notify