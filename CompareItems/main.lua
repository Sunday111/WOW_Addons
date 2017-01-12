local itemToSlot =
{
	["INVTYPE_2HWEAPON"] = { "MainHand" },
	["INVTYPE_FEET"] = { "Feet" },
	["INVTYPE_CHEST"] = { "Chest" },
	["INVTYPE_ROBE"] = { "Chest" },
	["INVTYPE_CLOAK"] = { "Back" },
	["INVTYPE_FINGER"] = { "Finger0", "Finger1" },
	["INVTYPE_HAND"] = { "Hands" },
	["INVTYPE_HEAD"] = { "Head" },
	["INVTYPE_HOLDABLE"] = { "SecondaryHand" },
	["INVTYPE_LEGS"] = { "Legs" },
	["INVTYPE_NECK"] = { "Neck" },
	["INVTYPE_RANGED"] = { "Ranged" },
	["INVTYPE_RANGEDRIGHT"] = { "Ranged" },
	["INVTYPE_SHIELD"] = { "SecondaryHand" },
	["INVTYPE_SHOULDER"] = { "Shoulder" },
	["INVTYPE_THROWN"] = { "RangedSlot" },
	["INVTYPE_TRINKET"] = { "Trinket0", "Trinket1" },
	["INVTYPE_WAIST"] = { "Waist" },
	["INVTYPE_WEAPON"] = { "MainHand", "SecondaryHand" },
	["INVTYPE_WEAPONMAINHAND"] = { "MainHand" },
	["INVTYPE_WEAPONOFFHAND"] = { "SecondaryHand" },
	["INVTYPE_WRIST"] = { "Wrist" },
}

local classProperties =
{
	--Fury warrior
	[72] =
	{
		["ITEM_MOD_HASTE_RATING_SHORT"] = 1.07,
		["ITEM_MOD_HASTE_MELEE_RATING_SHORT"] = 1.07,
		["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
		["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
		["ITEM_MOD_CRIT_MELEE_RATING_SHORT"] = 0.94,
		["ITEM_MOD_CRIT_RATING_SHORT"] = 0.94,
		["ITEM_MOD_MASTERY_RATING_SHORT"] = 0.82,
		["ITEM_MOD_VERSALITY_SHORT"] = 0.79
	}
}

local function ComputeColorByValue(value)
	if value > 0 then
		return 0, 1, 0
	end

	if value < 0 then
		return 1, 0, 0
	end

	return 1, 1, 1
end

local function OnTooltipSetItem(self)
	-- Get target item link
	local _, link = self:GetItem()

	-- Get equit slot of the target item
	local _, _, _, _, _, _, _, _, equipSlot = GetItemInfo(link)

	-- Look for slots to compare
	local slotNames = itemToSlot[equipSlot];

	if slotNames then
		-- Declare are which will store links to items for compare
		local associatedLinks = {}

		-- Get items items link in target equip slot for current player
		for _, slotName in pairs(slotNames) do
			local slotItemId = GetInventoryItemLink("player", GetInventorySlotInfo(slotName.."Slot"))

			if slotItemId then
				table.insert(associatedLinks, slotItemId)
			end
		end

		-- Get player global specialization id
		local specId = GetSpecializationInfo(GetSpecialization())

		-- Get class stats coefficients for current specialization
		local classStatsMap = classProperties[specId]

		-- Compute and show the difference between target item and every item which can be replaced
		for _, eqLink in pairs(associatedLinks) do
			local delta = GetItemStatDelta(link, eqLink)

			-- Check if delta collection is empty
			if next(delta) ~= nil then

				-- This is the difference between conventional items qualities
				local deltaValue = 0.0

				-- Get and show the name of item to compare with
				local eqName = GetItemInfo(eqLink)
				GameTooltip:AddLine(eqName, ": ")

				-- Compute the delta for common stats
				for key, value in pairs(delta) do
					local k = classStatsMap[key]

					if k then
						local deltaPerStat = k * value
						local r, g, b = ComputeColorByValue(deltaPerStat)

						-- Print every part
						GameTooltip:AddDoubleLine("   "..key, k.."*"..value.." = "..deltaPerStat, 1, 1, 1, r, g, b)
						deltaValue = deltaValue + deltaPerStat
					end
				end

				local r, g, b = ComputeColorByValue(deltaValue)

				-- Show the total difference between items
				GameTooltip:AddDoubleLine("   total:", deltaValue, 1.0, 1.0, 1.0, r, g, b)
			end
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)