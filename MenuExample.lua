function ShowNotification(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(false, false)
end

function ShowText(text)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(6000, 1)
end

ketchup = false
dish = "Banana"
quantity = 1
_menuPool = MenuPool.New()
mainMenu = UIMenu.New("NativeUI", "~b~NATIVEUI SHOWCASE", nil, nil, nil, nil, nil, 255, 255, 255, 255)
_menuPool:Add(mainMenu)




function DefaultItem(menu)
  local newitem = UIMenuListItem.New("Panel Elements", { "Exemple" }, 1)
  local opacityPanel = UIMenuPercentagePanel.New("0%", "Opacity", "100%")
  local colourPanel = UIMenuColourPanel.New("Colors Pickup", ColoursPanel.HairCut)
  local gridPanel = UIMenuGridPanel.New()
  newitem:AddPanel(opacityPanel)
  opacityPanel:Percentage(0.0)
  newitem:AddPanel(colourPanel)
  newitem:AddPanel(gridPanel)
  menu:AddItem(newitem)
  newitem.OnListChanged = function(ParentMenu, SelectedItem, Index)
    local ActiveItem = SelectedItem:IndexToItem(Index)
    local PanelItem = {
      opacity = (ActiveItem.Panels and ActiveItem.Panels[1] or 0.0) or 0.0,
      colors = (ActiveItem.Panels and ActiveItem.Panels[2] or 1) or 1,
      grids = {
        x = (ActiveItem.Panels and ActiveItem.Panels[3].X) or 0.0,
        y = (ActiveItem.Panels and ActiveItem.Panels[3].Y) or 0.0,
      },
    }
    ShowText("~b~Selected opacity : " .. PanelItem.opacity .. "\n ~o~Selected colors : " .. PanelItem.colors .. "\n ~r~GridPanel : X = " .. PanelItem.grids.x .. " -  Y = " .. PanelItem.grids.y .. "")
  end
end



function AddMenuKetchup(menu)
  local newitem = UIMenuCheckboxItem.New("Add ketchup?", ketchup, "Do you wish to add ketchup?")
  menu:AddItem(newitem)
  menu.OnCheckboxChange = function(sender, item, checked_)
    if item == newitem then
      ketchup = checked_
      ShowText("~r~Ketchup status: ~b~" .. tostring(ketchup))
    end
  end
end

function AddMenuFoods(menu)
  local foods = {
    "Banana",
    "Apple",
    "Pizza",
    "Quartilicious",
    "Steak",
    0xF00D,
  }
  local newitem = UIMenuListItem.New("Food", foods, 1)
  menu:AddItem(newitem)
  menu.OnListChange = function(sender, item, index)
    if item == newitem then
      dish = item:IndexToItem(index)
      ShowNotification("Preparing ~b~" .. dish .. "~w~...")
    end
  end
end

function AddMenuFoodCount(menu)
  local amount = {}
  for i = 1, 10 do amount[i] = i end
  local newitem = UIMenuSliderItem.New("Quantity", amount, 1, nil, false)
  menu:AddItem(newitem)
  menu.OnSliderChange = function(sender, item, index)
    if item == newitem then
      quantity = item:IndexToItem(index)
      ShowText("Preparing ~r~" .. quantity .. " ~b~" .. dish .. "(s)~w~...")
    end
  end
end

function AddMenuCook(menu)
  local newitem = UIMenuItem.New("Cook!", "Cook the dish with the appropriate ingredients and ketchup.")
  newitem:SetLeftBadge(BadgeStyle.Star)
  newitem:SetRightBadge(BadgeStyle.Tick)
  menu:AddItem(newitem)
  menu.OnItemSelect = function(sender, item, index)
    if item == newitem then
      local string = "You have ordered ~r~" .. quantity .. " ~b~" .. dish .. "(s)~w~ ~r~with~w~ ketchup."
      if not ketchup then
        string = "You have ordered ~r~" .. quantity .. " ~b~" .. dish .. "(s)~w~ ~r~without~w~ ketchup."
      end
      ShowNotification(string)
    end
  end
  menu.OnIndexChange = function(sender, index)
    if sender.Items[index] == newitem then
      newitem:SetLeftBadge(BadgeStyle.None)
    end
  end
end

function AddMenuAnotherMenu(menu)
  local submenu = _menuPool:AddSubMenu(menu, "Another Menu", true, true)
  submenu.Item:SetLeftBadge(BadgeStyle.Ammo)
  submenu.Item:RightLabel('~o~Hey RightLabel')
  submenu.Item:SetRightBadge(BadgeStyle.Heart)
  for i = 1, 20, 1 do
    submenu.SubMenu:AddItem(UIMenuColouredItem.New("#" .. i .. " PageFiller", "Sample description that takes more than one line. Moreso, it takes way more than two lines since it's so long. Wow, check out this length!", { R = 0, G = 180, B = 0, A = 40 }, { R = 0, G = 180, B = 0, A = 100 }))
  end
end



function AddMenuHeritageUI(menu)
  local MonHeritage = {}
  for i = 0, 20 do
    table.insert(MonHeritage, { Name = 'Shopie - ' .. i, Value = i })
  end
  local DadHeritage = {}
  for i = 0, 22 do
    table.insert(DadHeritage, { Name = 'Alexandre - ' .. i, Value = i })
  end
  local MixAmount = {}
  for i = 1, 9 do
    table.insert(MixAmount, { Value = tonumber("0." .. i) })
  end
  local heritage = {
    Mom = 0,
    Dad = 0,
  }
  local submenu = _menuPool:AddSubMenu(menu, "Heritage UI", "Sample description that takes more than one line. Moreso, it takes way more than two lines since it's so long. Wow, check out this length!", true, true)
  submenu.Item:SetRightBadge(BadgeStyle.Heart)
  local heritageWindow = UIMenuHeritageWindow.New(0, 0)
  local momSelect = UIMenuListItem.New(GetLabelText("FACE_MUMS"), MonHeritage, 0)
  local dadSelect = UIMenuListItem.New(GetLabelText("FACE_DADS"), DadHeritage, 0)
  local resSlider = UIMenuSliderHeritageItem.New("Ressemblance", MixAmount, 0, "", { R = 150, G = 0, B = 0, A = 255, }, { R = 100, G = 0, B = 0, A = 150, })
  local skinSlider = UIMenuSliderHeritageItem.New("Teinte", MixAmount, 0, "", { R = 0, G = 150, B = 150, A = 255, }, { R = 0, G = 100, B = 100, A = 200, })
  submenu.SubMenu:AddWindow(heritageWindow)
  submenu.SubMenu:AddItem(momSelect)
  submenu.SubMenu:AddItem(dadSelect)
  submenu.SubMenu:AddItem(resSlider)
  submenu.SubMenu:AddItem(skinSlider)
  momSelect.OnListChanged = function(ParentMenu, SelectedItem, Index)
    heritage.Mom = Index
    heritageWindow:Index(heritage.Mom, heritage.Dad)
    ShowText('Mom : ' .. heritage.Mom .. ' -  Dad : ' .. heritage.Dad .. '')
  end
  dadSelect.OnListChanged = function(ParentMenu, SelectedItem, Index)
    heritage.Dad = Index
    heritageWindow:Index(heritage.Mom, heritage.Dad)
    ShowText('Mom : ' .. heritage.Mom .. ' -  Dad : ' .. heritage.Dad .. '')
  end
  resSlider.OnSliderChanged = function(ParentMenu, SelectedItem, Index)
    ShowText("Ressemblance : " .. Index)
  end
  skinSlider.OnSliderChanged = function(ParentMenu, SelectedItem, Index)
    ShowText("Teinte : " .. Index)
  end
end


function CreateProgressItem(menu)
  local amount = {}
  for i = 1, 10 do amount[i] = i end
  local item = UIMenuProgressItem.New("Progression Item", amount, 1, "Desc", true)
  menu:AddItem(item)

  item.OnProgressChanged = function(menu, item, newindex)
    ShowText(newindex)
  end
end

--DefaultItem(mainMenu)
AddMenuKetchup(mainMenu)
AddMenuFoods(mainMenu)
AddMenuFoodCount(mainMenu)
AddMenuCook(mainMenu)
CreateProgressItem(mainMenu)
--AddMenuAnotherMenu(mainMenu)
--AddMenuHeritageUI(mainMenu)

_menuPool:RefreshIndex()

Citizen.CreateThread(function()
  while true do
  Citizen.Wait(1)
  --UITimerBars.New("gros fdp", 10, 10, 5, 255, 255, 255, 255, 1, 1, 1, 1, 0)

  --XXXnnSpriteTimeBars = Sprite.New("timerbars", "all_red_bg", 190 + 4.0, 147 + 37 * (1.0 + 1) + 1.0 - 37 + 1.0, 50, 50)
  -- xxxxx = Sprite.New("timerbars", "all_black_bg", 190 + 2.0, 147 + 37 * (1.0 + 1) + 1.0 - 37 + 1.0, 50, 50)
  --XXXnnSpriteTimeBars:Draw();

  local timebars = UITimerBars:New('', 1650);
  timebars:Draw();

  --[[
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 51) then
            mainMenu:Visible(not mainMenu:Visible())
        end
        ]]
end
end)
