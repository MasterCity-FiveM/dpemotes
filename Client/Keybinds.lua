local handsup = false
RegisterNetEvent('master_keymap:cc')
AddEventHandler('master_keymap:cc', function()
	if handsup == false then
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"),true)
		handsup = true
		EmoteCommandStart(nil,{'handsup', 0})
		StartHandsUp()
	else
		handsup = false
		TriggerEvent('dpemotes:cancelEmote')
	end
end)

RegisterNetEvent('master_keymap:stopHandsup')
AddEventHandler('master_keymap:stopHandsup', function()
	handsup = false
end)

RegisterNetEvent('master_keymap:t')
AddEventHandler('master_keymap:t', function()
	if handsup == true then
		EmoteCommandStart(nil,{'handsup', 0})
	end
end)

function StartHandsUp()
	Citizen.Wait(100)
	while handsup do
		Citizen.Wait(1)
		if IsEntityPlayingAnim(PlayerPedId(), 'missminuteman_1ig_2', 'handsup_base', 51) == false then
			handsup = false
		end
	end
end

RegisterNetEvent('master_keymap:h')
AddEventHandler('master_keymap:h', function()
	EmoteCommandStart(nil,{'whistle2', 0})
end)

local underPoint = false
RegisterNetEvent('master_keymap:b')
AddEventHandler('master_keymap:b', function()
	if underPoint then
		stopPointing()
	else
		startPointing()
	end
end)

function startPointing()
	underPoint = true
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
	
	Citizen.CreateThread(function()
		while underPoint do
			Wait(0)
			if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
				if not IsPedOnFoot(PlayerPedId()) then
					stopPointing()
				else
					local ped = GetPlayerPed(-1)
					local camPitch = GetGameplayCamRelativePitch()
					if camPitch < -70.0 then
						camPitch = -70.0
					elseif camPitch > 42.0 then
						camPitch = 42.0
					end
					camPitch = (camPitch + 70.0) / 112.0

					local camHeading = GetGameplayCamRelativeHeading()
					local cosCamHeading = Cos(camHeading)
					local sinCamHeading = Sin(camHeading)
					if camHeading < -180.0 then
						camHeading = -180.0
					elseif camHeading > 180.0 then
						camHeading = 180.0
					end
					camHeading = (camHeading + 180.0) / 360.0

					local blocked = 0
					local nn = 0

					local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
					local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
					nn,blocked,coords,coords = GetRaycastResult(ray)

					Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
					Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
					Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
					Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

				end
			end
		end
	end)
end

function stopPointing()
	underPoint = false
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end
