ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    PlayerLoaded = true
    TriggerServerEvent('SAM:LoadElevator')
end)



------------------------------------------------------------------------------------------------


local AllElevator = {}
local AllElevator_Name = {}

local filterArray = {Config.Lang.filterArray1, Config.Lang.filterArray2, Config.Lang.filterArray3, Config.Lang.filterArray4, Config.Lang.filterArray5,};
local filter = 1;

local filterArray_main = {Config.Lang.filterArray_main1, Config.Lang.filterArray_main2};
local filter_main = 1;

local NameElevator = ""
local Job = {}
local Pos = {}
local Label = {}

RegisterNetEvent('SAM:RefreshElevator_Points')
AddEventHandler('SAM:RefreshElevator_Points', function(data)
    AllElevator = data
end)

RegisterNetEvent('SAM:RefreshElevator_Name')
AddEventHandler('SAM:RefreshElevator_Name', function(data)
    AllElevator_Name = data
end)

RegisterNetEvent('SAM:TpPlayerCoords')
AddEventHandler('SAM:TpPlayerCoords', function(coords)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        Entity = GetVehiclePedIsIn(PlayerPedId(), false)
    else
        Entity = PlayerPedId()
    end
    DoScreenFadeOut(250)
    Wait(500)
    SetEntityCoords(Entity, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, true)
    MenuElevator = false
    RageUI.CloseAll()
    Wait(500)
    DoScreenFadeIn(250)
    cooldowncool(Config.Cooldown*1000)
end)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('SAM_Elevator:OpenMenu')
AddEventHandler('SAM_Elevator:OpenMenu', function()
    OpenMenuGElevator()
end)



local MenuGElevator = false

RMenu.Add('SaGElevator', 'main', RageUI.CreateMenu(Config.Lang.Menu_name, "INTERACTION"))
RMenu.Add('SaGElevator', 'create_main', RageUI.CreateSubMenu(RMenu:Get('SaGElevator', 'main'),Config.Lang.Menu_name, "INTERACTION"))
RMenu.Add('SaGElevator', 'gestion_main', RageUI.CreateSubMenu(RMenu:Get('SaGElevator', 'main'),Config.Lang.Menu_name, "INTERACTION"))
RMenu.Add('SaGElevator', 'gestion_edit', RageUI.CreateSubMenu(RMenu:Get('SaGElevator', 'gestion_main'),Config.Lang.Menu_name, "INTERACTION"))
RMenu:Get('SaGElevator', 'main'):SetRectangleBanner(0,0,0)
RMenu:Get('SaGElevator', 'create_main'):SetRectangleBanner(0,0,0)
RMenu:Get('SaGElevator', 'gestion_main'):SetRectangleBanner(0,0,0)
RMenu:Get('SaGElevator', 'gestion_edit'):SetRectangleBanner(0,0,0)
RMenu:Get('SaGElevator', 'main').Closed = function() 
    MenuGElevator = false
end 
RMenu:Get('SaGElevator', 'gestion_main').Closed = function() 
    getname = false
end 


function OpenMenuGElevator()
    if MenuGElevator then
        MenuGElevator = false
    else
        MenuGElevator = true
        RageUI.Visible(RMenu:Get('SaGElevator', 'main'), true)
        Citizen.CreateThread(function()
            while MenuGElevator do
                Wait(1)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                RageUI.IsVisible(RMenu:Get('SaGElevator', 'main'), true, true, true, function()
                    RageUI.Separator()

                    RageUI.Button(Config.Lang.Create_Menu, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end,RMenu:Get('SaGElevator', 'create_main'))

                    RageUI.Separator()

                    RageUI.Button(Config.Lang.Gestion_Menu, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end,RMenu:Get('SaGElevator', 'gestion_main'))

                    

                end, function() 
                end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                RageUI.IsVisible(RMenu:Get('SaGElevator', 'create_main'), true, true, true, function()

                    RageUI.Button(Config.Lang.Name_Elevator, nil, { RightLabel = "~HC_45~"..NameElevator.."~s~" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local SetElevator = KeyboardInput(Config.Lang.Name_Elevator_imput, Config.Lang.Name_Elevator_imput, "", 50)
                            if SetElevator ~= nil then
                                NameElevator = SetElevator
                            end
                        end
                    end)

                    RageUI.Button(Config.Lang.Add_point, Config.Lang.Add_point_desc, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local SetElevator1 = KeyboardInput(Config.Lang.Name_point_imput, Config.Lang.Name_point_imput, "", 50)
                            local SetElevator2 = KeyboardInput(Config.Lang.Name_Job_imput, Config.Lang.Name_Job_imput, "", 50)
                            if SetElevator1 ~= nil and SetElevator2 ~= nil then
                                
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)
                                table.insert(Pos,playerCoords)
                                Wait(100)
                                table.insert(Label,SetElevator1)
                                Wait(100)
                                table.insert(Job,SetElevator2)
                            end
                        end
                    end)


                    if #Pos < 1 then
                        RageUI.Separator(Config.Lang.Nil_point)
                    else
                        RageUI.Separator()
                        for k, v in pairs(Pos) do
                            RageUI.Button(Label[k], v.."\n"..Job[k], { RightLabel = Config.Lang.Delete_point }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    table.remove(Label, k);
                                    table.remove(Pos, k);
                                    table.remove(Job, k);
                                end
                            end)
                        end

                            RageUI.Button(Config.Lang.Save, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if #Pos >= 1 and NameElevator ~= nil or NameElevator ~= "" then
                                    for k, v in pairs(Pos) do
                                        Wait(100)
                                        TriggerServerEvent('SAM:addElevator',NameElevator,Pos[k],Label[k],Job[k])
                                    end
                                    Wait(100)
                                    TriggerServerEvent('SAM:addElevatorN',NameElevator)  
                                    NameElevator = ""
                                    Job = {}
                                    Pos = {}
                                    Label = {} 
                                    local Submenu = RMenu:Get('SaGElevator', 'main')
                                    if Submenu and Submenu() then
                                        RageUI.NextMenu = Submenu
                                    end
                                end                   
                            end
                        end)
                    end


                end, function() 
                end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                RageUI.IsVisible(RMenu:Get('SaGElevator', 'gestion_main'), true, true, true, function()
                    if #AllElevator_Name < 1 then
                        RageUI.Separator(Config.Lang.Loading)
                    else
                        for k, v in pairs(AllElevator_Name) do
                            RageUI.Button(v.name, k, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                                if Selected then 
                                    GestionName = v.name 
                                    GestionId = v.id                        
                                end
                            end,RMenu:Get('SaGElevator', 'gestion_edit'))
                        end
                    end
                end, function() 
                end)

-------------------------------------------------------------------------------------------------------------------------------------

                RageUI.IsVisible(RMenu:Get('SaGElevator', 'gestion_edit'), true, true, true, function()
                    
                    RageUI.Button(Config.Lang.Delete, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        if Selected then 
                            local DelElevator = KeyboardInput("Delete", Config.Lang.Del_valide, "", 50)
                            if DelElevator == "YES" then
                                for k, v in pairs(AllElevator) do
                                    if v.name == GestionName then 
                                        TriggerServerEvent('SAM:removeElevator', v.id)
                                    end
                                end 
                                TriggerServerEvent('SAM:removeElevatorN', GestionId)      
                            end            
                        end
                    end)

                    for k, v in pairs(AllElevator) do
                        table.sort(v)
                        if v.name == GestionName then
                            Pjob = v.job
                            if Pjob == nil or Pjob == "" then Pjob = Config.Lang.Draw_nil_Job end
                            DrawName3D(v.coords.x, v.coords.y, v.coords.z, Config.Lang.Draw_Floor..v.label.."\n"..Config.Lang.Draw_Elevator..v.name.."\n"..Config.Lang.Draw_Job..Pjob)
                            RageUI.List(v.label, filterArray, filter, AllGrade, {}, true, function(h, a, s, i)
                                filter = i
                                if s then
                                    if i == 1 then
                                        SetEntityCoords(PlayerPedId(), v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, true)
                                    elseif i == 2 then
                                        local SetElevator = KeyboardInput(Config.Lang.Name_point_imput, Config.Lang.Name_point_imput, "", 50)
                                            if SetElevator ~= nil then
                                                TriggerServerEvent('SAM:updateElevatorlabel',SetElevator,v.id)
                                            end
                                    elseif i == 3 then
                                        local playerPed = PlayerPedId()
                                        local playerCoords = GetEntityCoords(playerPed)
                                        TriggerServerEvent('SAM:updateElevatorcoords',playerCoords,v.id)
                                    elseif i == 4 then
                                        local SetElevator = KeyboardInput(Config.Lang.Name_Job_imput, Config.Lang.Name_Job_imput, "", 50)
                                            if SetElevator ~= nil then
                                                TriggerServerEvent('SAM:updateElevatorjob',SetElevator,v.id)
                                            end
                                    elseif i == 5 then
                                        TriggerServerEvent('SAM:removeElevator', v.id)
                                    end
                                end
                            end)
                        end
                    end

                    RageUI.Button(Config.Lang.Add_point, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local SetElevator1 = KeyboardInput(Config.Lang.Name_point_imput, Config.Lang.Name_point_imput, "", 50)
                            local SetElevator2 = KeyboardInput(Config.Lang.Name_Job_imput, Config.Lang.Name_Job_imput, "", 50)
                            if SetElevator1 ~= nil and SetElevator2 ~= nil then
                                
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)
                                table.insert(Pos,playerCoords)
                                Wait(100)
                                table.insert(Label,SetElevator1)
                                Wait(100)
                                table.insert(Job,SetElevator2)
                            end
                        end
                    end)


                    if #Pos < 1 then
                        RageUI.Separator(Config.Lang.Nil_point)
                    else
                        for k, v in pairs(Pos) do
                            RageUI.Button(Label[k], v, { RightLabel = Config.Lang.Delete_point }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    table.remove(Label, k);
                                    table.remove(Pos, k);
                                    table.remove(Job, k);
                                end
                            end)
                        end

                        RageUI.Button(Config.Lang.Save, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if #Pos >= 1 and GestionName ~= nil or GestionName ~= "" then
                                    for k, v in pairs(Pos) do
                                        Wait(100)
                                        TriggerServerEvent('SAM:addElevator',GestionName,Pos[k],Label[k],Job[k])
                                    end
                                    NameElevator = ""
                                    Job = {}
                                    Pos = {}
                                    Label = {}
                                    local Submenu = RMenu:Get('SaGElevator', 'gestion_main')
                                    if Submenu and Submenu() then
                                        RageUI.NextMenu = Submenu
                                    end
                                end                      
                            end
                        end)

                    end

                end, function() 
                end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            end
        end)
    end
end

































------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local cooldown = false

local MenuElevator = false

RMenu.Add('SaElevator', 'main', RageUI.CreateMenu(Config.Lang.Elevator, "INTERACTION"))
RMenu:Get('SaElevator', 'main'):SetRectangleBanner(0,0,0)
RMenu:Get('SaElevator', 'main').Closed = function() 
    MenuElevator = false
end 


function OpenMenuElevator(Name, JobP, px, py, pz)
    if MenuElevator then
        MenuElevator = false
    else
        MenuElevator = true
        view = false
        CoordsP = 'vector3(' .. px .. ', ' .. py .. ', ' .. pz .. ')'
        RageUI.Visible(RMenu:Get('SaElevator', 'main'), true)
        Citizen.CreateThread(function()
            while MenuElevator do
                Wait(1)

                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, px, py, pz)
                if dist > 3.0 and MenuElevator == true then
                    --print(dist)
                    MenuElevator = false
                    RageUI.CloseAll()
                end

                RageUI.IsVisible(RMenu:Get('SaElevator', 'main'), true, true, true, function()
                    RageUI.Separator(Config.Lang.Top_menu_elevator)

                    for k, v in pairs(AllElevator) do
                        table.sort(v)
                        if v.name == Name then
                            if ESX.PlayerData.job.name == JobP or JobP == "" then
                                    pointcoords = 'vector3(' .. v.coords.x .. ', ' .. v.coords.y .. ', ' .. v.coords.z .. ')'

                                if pointcoords ~= CoordsP then
                                    if cooldown then
                                        RightLabelTXT = Config.Lang.Cooldown_menu
                                    else
                                        if v.job == "" or ESX.PlayerData.job and ESX.PlayerData.job.name == v.job then
                                            RightLabelTXT = ""
                                        else
                                            RightLabelTXT = Config.Lang.Prohibited_menu
                                        end
                                    end
                                    RageUI.List(v.label, filterArray_main, filter_main, v.job, {RightLabel = RightLabelTXT}, true, function(h, a, s, i)
                                        filter_main = i
                                        if s then
                                            if RightLabelTXT == "" then
                                                if i == 1 then
                                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                                        Entity = GetVehiclePedIsIn(PlayerPedId(), false)
                                                    else
                                                        Entity = PlayerPedId()
                                                    end
                                                    DoScreenFadeOut(250)
                                                    Wait(500)
                                                    SetEntityCoords(Entity, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, true)
                                                    MenuElevator = false
                                                    RageUI.CloseAll()
                                                    Wait(500)
                                                    DoScreenFadeIn(250)
                                                    cooldowncool(Config.Cooldown*1000)
                                                elseif i == 2 then
                                                    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()

                                                    if closestPlayer == -1 or closestPlayerDistance > Config.RangeGroup then
                                                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                                                            Entity = GetVehiclePedIsIn(PlayerPedId(), false)
                                                        else
                                                            Entity = PlayerPedId()
                                                        end
                                                        DoScreenFadeOut(250)
                                                        Wait(500)
                                                        SetEntityCoords(Entity, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, true)
                                                        MenuElevator = false
                                                        RageUI.CloseAll()
                                                        Wait(500)
                                                        DoScreenFadeIn(250)
                                                        cooldowncool(Config.Cooldown*1000)
                                                    else
                                                        TriggerServerEvent('SAM:TpPlayerCoords', GetPlayerServerId(closestPlayer), v.coords)
                                                    end
                                                end
                                            end
                                        end
                                    end)
                                else
                                    RageUI.Button(v.label, v.job, { RightLabel = Config.Lang.actual_floor }, true, function(Hovered, Active, Selected)
                                    end)
                                end
                            else
                                
                                view = true
                            end
                        end

                    end

                    if view then
                        RageUI.Separator()
                        RageUI.Separator(Config.Lang.no_access)
                        RageUI.Separator()
                    end
                    

                end, function() 
                end)
            end
        end)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        local wait = 750

        for k, v in pairs(AllElevator) do


            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.coords.x, v.coords.y, v.coords.z)

            --if ESX.PlayerData.job and ESX.PlayerData.job.name == v.Job and MenuElevator == false then 
                if dist <= Config.RangeDrawMarker then
                    wait = 0
                    DrawMarker(6, v.coords.x, v.coords.y, v.coords.z-0.99, 2.0, 1.0, 500.0, 1.0, 50.0, 0.0, 0.8, 0.4, 0.8,  247,  222,  255, 200, false, false, 2, nil, nil, false)
                end


                if dist <= Config.RangeActive then
                    wait = 0
                    ESX.ShowHelpNotification(Config.Lang.Help_notif, true, false, 1)
                    if IsControlJustPressed(1,51) then
                        OpenMenuElevator(v.name, v.job, v.coords.x, v.coords.y, v.coords.z)
                    end
                
                end
            --end

        end
    Citizen.Wait(wait)
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------











function DrawName3D(x,y,z, text) -- some useful function, use it if you want!
    SetDrawOrigin(x, y, z, 0);
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.0, 0.23)
    SetTextColour(232, 142, 155, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end



function cooldowncool(time)
    cooldown = true
    Citizen.SetTimeout(time,function()
        cooldown = false
    end)
end


function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end