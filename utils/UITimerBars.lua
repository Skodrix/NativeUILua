UITimerBars = setmetatable({}, UITimerBars)
UITimerBars.__index = UITimerBars
UITimerBars.__call = function() return "UITimerBars" end

function UITimerBars.New()
    local _UITimerBars = {
        Base = Sprite.New("timerbars", "all_black_bg", 1650, 1021, 230, 35, 0.0, 255, 255, 255, 160),
        Pagination = { Min = 0, Max = 9, Total = 9 },
    }
    return setmetatable(_UITimerBars, UITimerBars)
end



function UITimerBars:Draw()
      self.Base:Draw()
end
