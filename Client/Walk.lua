function WalkMenuStart(name)
  if name == "Reset to default" then
    ResetPedMovementClipset(PlayerPedId())
  else
    RequestWalking(name)
    SetPedMovementClipset(PlayerPedId(), name, 0.2)
    RemoveAnimSet(name)
  end
end

function RequestWalking(set)
  RequestAnimSet(set)
  while not HasAnimSetLoaded(set) do
    Citizen.Wait(1)
  end 
end