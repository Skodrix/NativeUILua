ketchup = false
dish = "Banana"
quantity = 1
_menuPool = MenuPool.New()
mainMenu = UIMenu.New("Native UI", "~b~NATIVEUI SHOWCASE")
_menuPool:Add(mainMenu)

local MonHeritage = {}
for i = 0, 20 do
    table.insert(MonHeritage, { Name = 'Mon - ' .. i, Value = i })
end

local DadHeritage = {}
for i = 0, 22 do
    table.insert(DadHeritage, { Name = 'Dad - ' .. i, Value = i })
end


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


local heritage = {
    Mom = 0,
    Dad = 0,
}
function AddMenuHeritageUI(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Heritage")
    local heritageWindow = UIMenuHeritageWindow.New(heritage.Mom, heritage.Dad)
    local momSelect = UIMenuListItem.New(GetLabelText("FACE_MUMS"), MonHeritage, 0)
    local dadSelect = UIMenuListItem.New(GetLabelText("FACE_DADS"), DadHeritage, 0)
    submenu:AddWindow(heritageWindow)
    submenu:AddItem(momSelect)
    momSelect.OnListChanged = function(ParentMenu, SelectedItem, Index)
        heritage.Mon = Index
        heritageWindow:Index(heritage.Mom, heritage.Dad)
        ShowText('Mom : ' .. heritage.Mon .. ' -  Dad : ' .. heritage.Dad..'')
    end
    submenu:AddItem(dadSelect)
    dadSelect.OnListChanged = function(ParentMenu, SelectedItem, Index)
        heritage.Dad = Index
        heritageWindow:Index(heritage.Mom, heritage.Dad)
        ShowText('Mom : ' .. heritage.Mon .. ' -  Dad : ' .. heritage.Dad..'')
    end
end


function AddMenuKetchup(menu)
    local newitem = UIMenuCheckboxItem.New("Add ketchup?", ketchup, "Do you wish to add ketchup?")
    menu:AddItem(newitem)
    menu.OnCheckboxChange = function(sender, item, checked_)
        if item == newitem then
            ketchup = checked_
            ShowNotification("~r~Ketchup status: ~b~" .. tostring(ketchup))
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
    for i = 1, 100 do amount[i] = i end
    local newitem = UIMenuSliderItem.New("Quantity", amount, 1, false)
    menu:AddItem(newitem)
    menu.OnSliderChange = function(sender, item, index)
        if item == newitem then
            quantity = item:IndexToItem(index)
            ShowNotification("Preparing ~r~" .. quantity .. " ~b~" .. dish .. "(s)~w~...")
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

function AddMenuColouredItem(menu)
    local newitem = UIMenuColouredItem.New("Coloured Item", "Sample description...", { R = 0, G = 180, B = 0, A = 40 }, { R = 0, G = 180, B = 0, A = 100 })
    menu:AddItem(newitem)
    menu.OnItemSelect = function(sender, item, index)
        if item == newitem then
            ShowNotification('ALO TA VALIDEY RHEY')
        end
    end
end

function AddMenuAnotherMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Another Menu")
    for i = 1, 20, 1 do
        submenu:AddItem(UIMenuItem.New("#" .. i .. " PageFiller", "Sample description that takes more than one line. Moreso, it takes way more than two lines since it's so long. Wow, check out this length!"))
    end
end



AddMenuHeritageUI(mainMenu)
AddMenuKetchup(mainMenu)
AddMenuFoods(mainMenu)
AddMenuFoodCount(mainMenu)
AddMenuCook(mainMenu)
AddMenuColouredItem(mainMenu)
AddMenuAnotherMenu(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 51) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)
