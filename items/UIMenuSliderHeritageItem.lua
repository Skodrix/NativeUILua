UIMenuSliderHeritageItem = setmetatable({}, UIMenuSliderHeritageItem)
UIMenuSliderHeritageItem.__index = UIMenuSliderHeritageItem
UIMenuSliderHeritageItem.__call = function() return "UIMenuItem", "UIMenuSliderHeritageItem" end

function UIMenuSliderHeritageItem.New(Text, Items, Index, Description)
    if type(Items) ~= "table" then Items = {} end
    if Index == 0 then Index = 1 end
    local _UIMenuSliderHeritageItem = {
        Base = UIMenuItem.New(Text or "", Description or ""),
        Items = Items,
        ShowDivider = 1,
        LeftArrow = Sprite.New("mpleaderboard", "leaderboard_male_icon", 0, 0, 30, 30, 0, 255, 255, 255, 255),
        RightArrow = Sprite.New("mpleaderboard", "leaderboard_female_icon", 0, 0, 30, 30, 0, 255, 255, 255, 255),
        Background = UIResRectangle.New(0, 0, 150, 10, 4, 32, 57, 255),
        Slider = UIResRectangle.New(0, 0, 75, 10, 57, 119, 200, 255),
        Divider = UIResRectangle.New(0, 0, 4, 20, 255, 255, 255, 255),
        _Index = tonumber(Index) or 1,
        OnSliderChanged = function(menu, item, newindex) end,
        OnSliderSelected = function(menu, item, newindex) end,
    }
    return setmetatable(_UIMenuSliderHeritageItem, UIMenuSliderHeritageItem)
end

function UIMenuSliderHeritageItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

function UIMenuSliderHeritageItem:Position(Y)
    if tonumber(Y) then
        self.Background:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
        self.Slider:Position(250 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 158.5 + self.Base._Offset.Y)
        self.Divider:Position(323.5 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, Y + 153 + self.Base._Offset.Y)
        self.LeftArrow:Position(220 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 148.5 + Y + self.Base._Offset.Y)
        self.RightArrow:Position(400 + self.Base._Offset.X + self.Base.ParentMenu.WidthOffset, 148.5 + Y + self.Base._Offset.Y)
        self.Base:Position(Y)
    end
end

function UIMenuSliderHeritageItem:Selected(bool)
    if bool ~= nil then
        self.Base._Selected = tobool(bool)
    else
        return self.Base._Selected
    end
end

function UIMenuSliderHeritageItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

function UIMenuSliderHeritageItem:Enabled(bool)
    if bool ~= nil then
        self.Base._Enabled = tobool(bool)
    else
        return self.Base._Enabled
    end
end

function UIMenuSliderHeritageItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base._Description = tostring(str)
    else
        return self.Base._Description
    end
end

function UIMenuSliderHeritageItem:Offset(X, Y)
    if tonumber(X) or tonumber(Y) then
        if tonumber(X) then
            self.Base._Offset.X = tonumber(X)
        end
        if tonumber(Y) then
            self.Base._Offset.Y = tonumber(Y)
        end
    else
        return self.Base._Offset
    end
end

function UIMenuSliderHeritageItem:Text(Text)
    if tostring(Text) and Text ~= nil then
        self.Base.Text:Text(tostring(Text))
    else
        return self.Base.Text:Text()
    end
end

function UIMenuSliderHeritageItem:Index(Index)
    if tonumber(Index) then
        if tonumber(Index) > #self.Items then
            self._Index = 1
        elseif tonumber(Index) < 1 then
            self._Index = #self.Items
        else
            self._Index = tonumber(Index)
        end
    else
        return self._Index
    end
end

function UIMenuSliderHeritageItem:ItemToIndex(Item)
    for i = 1, #self.Items do
        if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
            return i
        end
    end
end

function UIMenuSliderHeritageItem:IndexToItem(Index)
    if tonumber(Index) then
        if tonumber(Index) == 0 then Index = 1 end
        if self.Items[tonumber(Index)] then
            return self.Items[tonumber(Index)]
        end
    end
end

function UIMenuSliderHeritageItem:SetLeftBadge()
    error("This item does not support badges")
end

function UIMenuSliderHeritageItem:SetRightBadge()
    error("This item does not support badges")
end

function UIMenuSliderHeritageItem:RightLabel()
    error("This item does not support a right label")
end

function UIMenuSliderHeritageItem:Draw()
    self.Base:Draw()

    if self:Enabled() then
        if self:Selected() then
            self.LeftArrow:Colour(0, 0, 0, 255)
            self.RightArrow:Colour(0, 0, 0, 255)
        else
            self.LeftArrow:Colour(255, 255, 255, 255)
            self.RightArrow:Colour(255, 255, 255, 255)
        end
    else
        self.LeftArrow:Colour(255, 255, 255, 255)
        self.RightArrow:Colour(255, 255, 255, 255)
    end


    local Offset = ((self.Background.Width - self.Slider.Width) / (#self.Items - 1)) * (self._Index - 1)

    self.Slider:Position(250 + self.Base._Offset.X + Offset + self.Base.ParentMenu.WidthOffset, self.Slider.Y)


    self.LeftArrow:Draw()
    self.RightArrow:Draw()


    self.Background:Draw()
    self.Slider:Draw()

    if self.ShowDivider then
        self.Divider:Draw()
        if self:Selected() then
            self.Divider:Colour(0, 0, 0, 255)
        else
            self.Divider:Colour(255, 255, 255, 255)
        end
    end
end