Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5000)
	end
end)

h4ci_conc = {
	catevehi = {},
	listecatevehi = {},
}

local derniervoituresorti = {}
local sortirvoitureacheter = {}


local open = false 
local mainMenu = RageUI.CreateMenu("Avion", "Concessionnaire Avion")
local subMenu = RageUI.CreateSubMenu(mainMenu, "Catégorie", " ")
local liste = RageUI.CreateSubMenu(subMenu, "Liste Véhicules", " ")
local achat = RageUI.CreateSubMenu(liste, "Achat", " ")
mainMenu:SetRectangleBanner(0, 0, 0)
subMenu:SetRectangleBanner(0, 0, 0)
liste:SetRectangleBanner(0, 0, 0)
achat:SetRectangleBanner(0, 0, 0)
mainMenu.Closed = function()   
	supprimeravionconcess()
    RageUI.Visible(mainMenu, false)
    open = false
end 

function OpenMenu()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(mainMenu,function() 

		   	RageUI.Separator('~r~↓ ~s~Accéder au Catalogue ~r~↓')

			RageUI.Button("Catalogue", nil , {RightLabel = "→"}, true , {
				onSelected = function()                       
				end
			}, subMenu)

		   end)


		   RageUI.IsVisible(subMenu,function() 

        	for i = 1, #h4ci_conc.catevehi, 1 do
				RageUI.Button("Catégorie - "..h4ci_conc.catevehi[i].label, nil , {RightLabel = "→"}, true , {
					onSelected = function()   
						nomcategorie = h4ci_conc.catevehi[i].label
						categorievehi = h4ci_conc.catevehi[i].name
						ESX.TriggerServerCallback('h4ci_avion:recupererlistevehicule', function(listevehi)
								h4ci_conc.listecatevehi = listevehi
						end, categorievehi)
					end                    
				}, liste)
			end

		   end)

		   RageUI.IsVisible(liste,function() 

			for i2 = 1, #h4ci_conc.listecatevehi, 1 do
				RageUI.Button(h4ci_conc.listecatevehi[i2].name, nil , {RightLabel = "~g~"..h4ci_conc.listecatevehi[i2].price.."$"}, true , {
					onSelected = function()  
						local nomvoiture = h4ci_conc.listecatevehi[i2].name
						prixvoiture = h4ci_conc.listecatevehi[i2].price
						modelevoiture = h4ci_conc.listecatevehi[i2].model
						supprimeravionconcess()
						chargementvoiture(modelevoiture)
						ESX.Game.SpawnLocalVehicle(modelevoiture, {x = -957.85, y = -2964.84, z = 13.94}, 59.96, function (vehicle)
						table.insert(derniervoituresorti, vehicle)
						FreezeEntityPosition(vehicle, true)
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						SetModelAsNoLongerNeeded(modelevoiture)
						end) 
					end                    
				}, achat)
			end

		   end)

		   RageUI.IsVisible(achat,function() 

		   	RageUI.Separator ('~r~↓ ~s~Prix du Véhicule ~r~↓')
			RageUI.Separator (prixvoiture)

			RageUI.Button("Acheter le ~r~Véhicule", 'Cette Action est ~r~Définitive !', {RightLabel = "⚠️"}, true , {
				onSelected = function()  
					ESX.TriggerServerCallback('h4ci_avion:verifsousconcess', function(suffisantsous)
						if suffisantsous then
						supprimeravionconcess()
						chargementvoiture(modelevoiture)
						ESX.Game.SpawnVehicle(modelevoiture, {x = -957.85, y = -2964.84, z = 13.94}, 59.96, function (vehicle)
						table.insert(sortirvoitureacheter, vehicle)
						FreezeEntityPosition(vehicle, true)
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						SetModelAsNoLongerNeeded(modelevoiture)
						local plaque     = GeneratePlate()
						local vehicleProps = ESX.Game.GetVehicleProperties(sortirvoitureacheter[#sortirvoitureacheter])
						vehicleProps.plate = plaque
						SetVehicleNumberPlateText(sortirvoitureacheter[#sortirvoitureacheter], plaque)
						FreezeEntityPosition(sortirvoitureacheter[#sortirvoitureacheter], false)
						TriggerServerEvent('shop:avion', vehicleProps, prixvoiture)
						ESX.ShowNotification("Vous avez achetez une ~b~"..modelevoiture..".")
						TriggerServerEvent('esx_vehiclelock:registerkey', vehicleProps.plate, GetPlayerServerId(closestPlayer))
						end)
						else
							ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent pour cette avion/helico !')
						end
		
					end, prixvoiture)

				end                    
			})

		   end)

		
		 Wait(0)
		end
	 end)
  end
end

-- POS DU MENU --

local position = {
	{x = -941.20, y = -2954.24, z = 13.94}
}

Citizen.CreateThread(function()
    while true do

     	local wait = 750

        for k in pairs(position) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

            if dist <= 8.0 then
            wait = 0
			DrawMarker(22, -941.20, -2954.24, 13.94, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)  

            if dist <= 1.0 then
               wait = 0
			   	Visual.Subtitle("Appuyer sur ~r~[E]~s~ pour ouvrir le ~r~Menu", 0) 
                if IsControlJustPressed(1,51) then
					supprimeravionconcess()
					ESX.TriggerServerCallback('h4ci_avion:recuperercategorieavion', function(catevehi)
						h4ci_conc.catevehi = catevehi
					end)
					OpenMenu()
            	end
            else RageUI.CloseAll()
        	end
    	end
    	Citizen.Wait(wait)
    end
end
end)

function supprimeravionconcess()
	while #derniervoituresorti > 0 do
		local vehicle = derniervoituresorti[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(derniervoituresorti, 1)
	end
end

function chargementvoiture(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('shop_awaiting_model')
		EndTextCommandBusyString(4)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end
		RemoveLoadingPrompt()
	end
end

------Blips
local blips = {
    -- Exemple {title="", colour=, id=, x=, y=, z=},
        {title="Concessionnaire Avion", colour=5, id=64, x = -941.20, y = -2954.24, z = 13.94},
  }

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.8)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)
