--[[local isInRagdoll = false
IsSleep = false

RegisterNetEvent('master_keymap:u')
AddEventHandler('master_keymap:u', function()
	if IsSleep then
		return
	end
	
	if Config.RagdollEnabled and IsPedOnFoot(PlayerPedId()) then
        if isInRagdoll then
            isInRagdoll = false
        else
            isInRagdoll = true
			
			Citizen.CreateThread(function()
			 while isInRagdoll do
				Citizen.Wait(10)
				SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
			  end
			end)
			
			IsSleep = true
            Wait(500)
			IsSleep = false
        end
	end
end)]]--