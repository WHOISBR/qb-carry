local QBCore = exports['qb-core']:GetCoreObject()

local holdingBody = false
local carrying = false

RegisterNetEvent('carry:command')
AddEventHandler('carry:command', function()
	if not carrying then
		local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
	
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			TriggerServerEvent('carry:sync', GetPlayerServerId(closestPlayer))
		end
	else
		QBCore.Functions.notify('no')
	end
end,false)

RegisterNetEvent('carry:syncTarget')
AddEventHandler('carry:syncTarget', function(target)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carrying = true

	QBCore.Functions.Notify('Press E to release carry.')

	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
		
	while carrying do

		DisableControlAction(1, 19, true)
		DisableControlAction(0, 34, true)
		DisableControlAction(0, 9, true)
	
		DisableControlAction(0, 288, true)
		DisableControlAction(0, 289, true)
		DisableControlAction(0, 170, true)
		DisableControlAction(0, 73, true)
		DisableControlAction(0, 79, true)
		DisableControlAction(0, 305, true)
		DisableControlAction(0, 82, true)
		DisableControlAction(0, 182, true)

		DisableControlAction(0, 32, true)
		DisableControlAction(0, 8, true)
		DisableControlAction(2, 31, true)
		DisableControlAction(2, 32, true)
		DisableControlAction(1, 33, true)
		DisableControlAction(1, 34, true)
		DisableControlAction(1, 35, true)
		DisableControlAction(1, 21, true)  -- space
		DisableControlAction(1, 22, true)  -- space
		DisableControlAction(1, 23, true)  -- F
		DisableControlAction(1, 24, true)  -- F
		DisableControlAction(1, 25, true)  -- F
	
	
		DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
		DisableControlAction(1, 140, true) --Disables Melee Actions
		DisableControlAction(1, 141, true) --Disables Melee Actions
		DisableControlAction(1, 142, true) --Disables Melee Actions 
		DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(playerPed, true) -- Disable weapon firing

		if not IsEntityPlayingAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 3) then
			loadAnim("amb@world_human_bum_slumped@male@laying_on_left_side@base")
			TaskPlayAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
		end

		if IsControlJustPressed(0, 38) then
			carrying = false
			ClearPedTasks(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent("carry:stop",GetPlayerServerId(closestPlayer))
			end
		end

		Wait(1)
	end

end)


RegisterNetEvent('carry:syncMe')
AddEventHandler('carry:syncMe', function()
	local playerPed = GetPlayerPed(-1)

	QBCore.Functions.Notify('Press E to release carry.')

	carrying = true

	while carrying do
		if not IsEntityPlayingAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
			loadAnim("missfinale_c2mcs_1")
			TaskPlayAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, 1.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustPressed(0, 38) then
			carrying = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent("carry:stop",GetPlayerServerId(closestPlayer))
			end
		end

		Wait(1)
	end

end)

RegisterNetEvent('carry:stop')
AddEventHandler('carry:stop', function()
	carrying = false
	ClearPedTasks(PlayerPedId())
	DetachEntity(GetPlayerPed(-1), true, false)
end)


function loadAnim( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end