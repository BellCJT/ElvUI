﻿local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule("DataTexts");

local format = string.format;
local join = string.join;

local UnitArmor = UnitArmor;
local UnitLevel = UnitLevel;
local PaperDollFrame_GetArmorReduction = PaperDollFrame_GetArmorReduction;
local ARMOR = ARMOR;

local lastPanel;
local chanceString = "%.2f%%";
local displayString = "";
local baseArmor, effectiveArmor, armor, posBuff, negBuff;

local function OnEvent(self, event, ...)
	baseArmor, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
	
	self.text:SetFormattedText(displayString, ARMOR, effectiveArmor);
	lastPanel = self;
end

local function OnEnter(self)
	DT:SetupTooltip(self);
	
	DT.tooltip:AddLine(L["Mitigation By Level: "]);
	DT.tooltip:AddLine(" ");
	
	local playerLevel = UnitLevel("player") + 3;
	for i = 1, 4 do
		local armorReduction = PaperDollFrame_GetArmorReduction(effectiveArmor, playerLevel);
		DT.tooltip:AddDoubleLine(playerLevel, format(chanceString, armorReduction), 1, 1, 1);
		playerLevel = playerLevel - 1;
	end
	
	local targetLevel = UnitLevel("target");
	if(targetLevel and targetLevel > 0 and (targetLevel > playerLevel + 3 or targetLevel < playerLevel)) then
		local armorReduction = PaperDollFrame_GetArmorReduction(effectiveArmor, targetLevel);
		DT.tooltip:AddDoubleLine(targetLevel, format(chanceString, armorReduction), 1, 1, 1);
	end
	
	DT.tooltip:Show();
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", "%s: ", hex, "%d|r");
	
	if(lastPanel ~= nil) then
		OnEvent(lastPanel);
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true;

DT:RegisterDatatext(ARMOR, { "UNIT_STATS", "UNIT_RESISTANCES", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE" }, OnEvent, nil, nil, OnEnter);