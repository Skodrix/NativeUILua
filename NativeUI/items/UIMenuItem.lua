UIMenuItem = setmetatable({}, UIMenuItem)
UIMenuItem.__index = UIMenuItem
UIMenuItem.__call = function() return "UIMenuItem", "UIMenuItem" end

function UIMenuItem.New(Text, Description)
	_UIMenuItem = {
		Rectangle = UIResRectangle.New(0, 0, 431, 38, 255, 255, 255, 20),
		Text = UIResText.New(tostring(Text) or "", 8, 0, 0.33, 245, 245, 245, 255, 0),
		_Description = tostring(Description) or "";
		SelectedSprite = Sprite.New("commonmenu", "gradient_nav", 0, 0, 431, 38),
		LeftBadge = { Sprite = Sprite.New("commonmenu", "", 0, 0, 40, 40), Badge = 0},
		RightBadge = { Sprite = Sprite.New("commonmenu", "", 0, 0, 40, 40), Badge = 0},
		LabelText = UIResText.New("", 0, 0, 0.35, 245, 245, 245, 255, 0, "Right"),
		_Selected = false,
		_Hovered = false,
		_Enabled = true,
		_Offset = {X = 0, Y = 0},
		ParentMenu = nil,
		Activated = function(menu) end
	}
	return setmetatable(_UIMenuItem, UIMenuItem)
end

function UIMenuItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.ParentMenu = Menu
	else
		return self.ParentMenu
	end
end

function UIMenuItem:Selected(bool)
	if bool ~= nil then
		self._Selected = tobool(bool)
	else
		return self._Selected
	end
end

function UIMenuItem:Hovered(bool)
	if bool ~= nil then
		self._Hovered = tobool(bool)
	else
		return self._Hovered
	end
end

function UIMenuItem:Enabled(bool)
	if bool ~= nil then
		self._Enabled = tobool(bool)
	else
		return self._Enabled
	end
end

function UIMenuItem:Description(str)
	if tostring(str) and str ~= nil then
		self._Description = tostring(str)
	else
		return self._Description
	end
end

function UIMenuItem:Offset(X, Y)
	if tonumber(X) or tonumber(Y) then
		if tonumber(X) then
			self._Offset.X = tonumber(X)
		end
		if tonumber(Y) then
			self._Offset.Y = tonumber(Y)
		end
	else
		return self._Offset
	end
end

function UIMenuItem:Position(Y)
	if tonumber(Y) then
		self.Rectangle:Position(self._Offset.X, Y + 144 + self._Offset.Y)
		self.SelectedSprite:Position(0 + self._Offset.X, Y + 144 + self._Offset.Y)
		self.Text:Position(8 + self._Offset.X, Y + 147 + self._Offset.Y)
		self.LeftBadge.Sprite:Position(0 + self._Offset.X, Y + 142 + self._Offset.Y)
		self.RightBadge.Sprite:Position(385 + self._Offset.X, Y + 142 + self._Offset.Y)
		self.LabelText:Position(420 + self._Offset.X, Y + 148 + self._Offset.Y)
	end
end

function UIMenuItem:RightLabel(Text)
	if tostring(Text) and Text ~= nil then
		self.LabelText:Text(tostring(Text))
	else
		return self.LabelText:Text()
	end
end

function UIMenuItem:SetLeftBadge(Badge)
	if tonumber(Badge) then
		self.LeftBadge.Badge = tonumber(Badge)
	end
end

function UIMenuItem:SetRightBadge(Badge)
	if tonumber(Badge) then
		self.RightBadge.Badge = tonumber(Badge)
	end
end

function UIMenuItem:Text(Text)
	if tostring(Text) and Text ~= nil then
		self.Text:Text(tostring(Text))
	else
		return self.Text:Text()
	end
end

function UIMenuItem:Draw()
	self.Rectangle:Size(431 + self.ParentMenu.WidthOffset, 38)
	self.SelectedSprite:Size(431 + self.ParentMenu.WidthOffset, 38)

	if self._Hovered and not self._Selected then
		self.Rectangle:Draw()
	end

	if self._Selected then
		self.SelectedSprite:Draw()
	end

	if self._Enabled then
		if self._Selected then
			self.Text:Colour(0, 0, 0, 255)
		else
			self.Text:Colour(245, 245, 245, 255)
		end
	else
		self.Text:Colour(163, 159, 148, 255)
	end

	if self.LeftBadge.Badge == BadgeStyle.None then
		self.Text:Position(8 + self._Offset.X, self.Text.Y)
	else
		self.Text:Position(35 + self._Offset.X, self.Text.Y)
		self.LeftBadge.Sprite.TxtDictionary = GetBadgeDictionary(self.LeftBadge.Badge, self._Selected)
		self.LeftBadge.Sprite.TxtName = GetBadgeTexture(self.LeftBadge.Badge, self._Selected)
		self.LeftBadge.Sprite:Colour(GetBadgeColour(self.LeftBadge.Badge, self._Selected))
		self.LeftBadge.Sprite:Draw()
	end

	if self.RightBadge.Badge ~= BadgeStyle.None then
		self.RightBadge.Sprite:Position(385 + self._Offset.X + self.ParentMenu.WidthOffset, self.RightBadge.Sprite.Y)
		self.RightBadge.Sprite.TxtDictionary = GetBadgeDictionary(self.RightBadge.Badge, self._Selected)
		self.RightBadge.Sprite.TxtName = GetBadgeTexture(self.RightBadge.Badge, self._Selected)
		self.RightBadge.Sprite:Colour(GetBadgeColour(self.RightBadge.Badge, self._Selected))
		self.RightBadge.Sprite:Draw()
	end

	if self.LabelText:Text() ~= "" and string.len(self.LabelText:Text()) > 0 then
		self.LabelText:Position(420 + self._Offset.X + self.ParentMenu.WidthOffset, self.LabelText.Y)
		self.LabelText:Draw()
	end

	self.Text:Draw()
end