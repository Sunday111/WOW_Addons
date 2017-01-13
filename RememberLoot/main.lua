local AccountSavedData = nil
local CharacterSavedData = nil

-- Need a frame to respond to events
local frame = CreateFrame("FRAME");

-- Fired when saved variables are loaded
frame:RegisterEvent("ADDON_LOADED");

-- Fired when about to log out
frame:RegisterEvent("PLAYER_LOGOUT");

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "HaveWeMet" then
		frame:UnregiserEvent("ADDON_LOADED")
		print("RememberLoot addon has loaded")
	end
end

frame:SetScript("OnEvent", frame.OnEvent);