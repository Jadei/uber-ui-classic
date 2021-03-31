--get the addon namespace
local addon, ns = ...
auras = {}

local auras = CreateFrame("frame")
auras:RegisterEvent("ADDON_LOADED")
auras:RegisterEvent("UNIT_TARGET")
auras:SetScript("OnEvent", function(self,event)
	if (event == "UNIT_TARGET") then
		self:TargetSpellIcon()
	elseif (event == "PLAYER_FOCUS_CHANGED") then
		self:FocusSpellIcon()
	end
end)
local backdrop = {
		bgFile = nil,
		edgeFile = "Interface\\AddOns\\Uber UI\\textures\\outer_shadow",
		tile = false,
		tileSize = 32,
		edgeSize = 4,
		insets = {
			left = 4,
			right = 4,
			top = 4,
			bottom = 4,
		},
	}

 ---------------------------------------
  -- FUNCTIONS
 ---------------------------------------

--apply aura frame texture func
local function applySkin(b, color)
	if not b then return end
	--button name
	local u = b.unit
	local name = b:GetName()
	if (name:match("Debuff")) then
		b.debuff = true
	else
		b.buff = true
	end

	local colors = color
	local classification = UnitClassification(u)

	if (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Class" or uuidb.targetframe.colortargett == "Class/Friendly/Hostile") and (UnitIsConnected(u) and UnitIsPlayer(u)) then
		colors = RAID_CLASS_COLORS[select(2, UnitClass(u))]
	elseif (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Rare/Elite") and (classification == 'elite' or classification == 'worldboss' or classification == 'rare' or classification == 'rareelite') then
		if ( classification == "worldboss" or classification == "elite" ) then
			colors = {r = 159/255, g = 115/255, b = 19/255}
		elseif ( classification == "rareelite" ) then
			colors = {r = 65/255, g = 66/255, b = 73/255}
		elseif ( classification == "rare" ) then
			colors = {r = 173/255, g = 166/255, b = 156/255}
		end
	elseif (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Friendly/Hostile" or uuidb.targetframe.colortargett == "Class/Friendly/Hostile") then
		local red,green,_ = UnitSelectionColor(u)
		if (red == 0) then
    	    colors = { r = 0, g = 1, b = 0}
    	elseif (green == 0) then
    	    colors = { r = 1, g = 0, b = 0}
    	else
    	    colors = { r = 1, g = 1, b = 0}
    	end
	elseif uuidb.general.customcolor or uuidb.general.classcolorframesor then
		colors = uuidb.general.customcolorval
	else
		colors = uuidb.auras.color
	end

	if b and b.styled then
		b.bg:SetBackdropBorderColor(colors.r, colors.g, colors.b, colors.a)
	end

	if not b or (b and b.styled) then return end

	--icon
	local icon = _G[name.."Icon"]
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetDrawLayer("BACKGROUND",-8)
	b.icon = icon
	--border
	local border = _G[name.."Border"] or b:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
	border:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\gloss")
	border:SetTexCoord(0, 1, 0, 1)
	border:SetDrawLayer("BACKGROUND",- 7)
	border:ClearAllPoints()
	border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
	b.border = border
	--shadow
	local back = CreateFrame("Frame", nil, b, BackdropTemplateMixin and "BackdropTemplate")
	back:SetPoint("TOPLEFT", b, "TOPLEFT", -2, 2)
	back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 2, -2)
	back:SetFrameLevel(b:GetFrameLevel() - 1)
	back:SetBackdrop(backdrop)
	back:SetBackdropBorderColor(colors.r, colors.g, colors.b, colors.a)
	b.bg = back
	--set button styled variable
	b.styled = true
end

--apply castbar texture

local function applycastSkin(b, color)
	if not b or (b and b.styled) then
		b.bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
		return
	end
	---- parent
	if b == TargetFrameSpellBar.Icon then
		b.parent = TargetFrameSpellBar
	else
		b.parent = FocusFrameSpellBar
	end

	-- frame
	frame = CreateFrame("Frame", nil, b.parent)
	--icon
	b:SetTexCoord(0.2, 0.8, 0.2, 0.8)
	--border
	local border = frame:CreateTexture(nil, "BACKGROUND")
	border:SetTexture("Interface\\AddOns\\Uber UI\\textures\\glosslight")
	border:SetTexCoord(0, 1, 0, 1)
	border:SetDrawLayer("BACKGROUND",- 7)
	border:ClearAllPoints()
	border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
	--border color
	--if (UnitIsConnected(border.unit)) and uuidb.targetframe.colortargett then
	--	UberUI.general:ClassColored(border, border.unit)
	--else
	--end
	b.border = border
	--shadow
	local back = CreateFrame("Frame", nil, b.parent, BackdropTemplateMixin and "BackdropTemplate")
	back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
	back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
	back:SetFrameLevel(frame:GetFrameLevel() - 1)
	back:SetBackdrop(backdrop)
	back:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
	b.bg = back
	--set button styled variable
	b.styled = true
end

function auras:TargetSpellIcon()
	if UnitExists('target') then
		local u = 'target'
		if (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Class" or uuidb.targetframe.colortargett == "Class/Friendly/Hostile") then
			if UnitIsConnected(u) and UnitIsPlayer(u) then
				colors = RAID_CLASS_COLORS[select(2, UnitClass(u))]
			else
				local red,green,_ = UnitSelectionColor(u)
				if (red == 0) then
	        	    colors = { r = 0, g = 1, b = 0}
	        	elseif (green == 0) then
	        	    colors = { r = 1, g = 0, b = 0}
	        	else
	        	    colors = { r = 1, g = 1, b = 0}
	        	end
			end
		else
			colors = uuidb.auras.color
		end
		applycastSkin(TargetFrameSpellBar.Icon, colors)
	end
end	

function auras:FocusSpellIcon()
	if UnitExists('focus') then
		local u = 'focus'
		if uuidb.targetframe.colortargett == ("All") then
			if UnitIsConnected(u) and UnitIsPlayer(u) then
				colors = RAID_CLASS_COLORS[select(2, UnitClass(u))]
			else
				local red,green,_ = UnitSelectionColor(u)
				if (red == 0) then
	        	    colors = { r = 0, g = 1, b = 0}
	        	elseif (green == 0) then
	        	    colors = { r = 1, g = 0, b = 0}
	        	else
	        	    colors = { r = 1, g = 1, b = 0}
	        	end
			end
		else
			colors = uuidb.auras.color
		end
		applycastSkin(FocusFrameSpellBar.Icon, colors)
	end
end	

function auras:ReworkAllColors(color)
	if not (color) then
		color = uuidb.auras.color
	end
	hooksecurefunc("TargetFrame_UpdateAuras", function(self)
		for i = 1, MAX_TARGET_BUFFS do
			b = _G["TargetFrameBuff"..i]
			applySkin(b, color)
		end
		for i = 1, MAX_TARGET_DEBUFFS do
			b = _G["TargetFrameDebuff"..i]
			applySkin(b, color)
		end
		for i = 1, MAX_TARGET_BUFFS do
			b = _G["FocusFrameBuff"..i]
			applySkin(b, color)
		end
		for i = 1, MAX_TARGET_DEBUFFS do
			b = _G["FocusFrameDebuff"..i]
			applySkin(b, color)
		end
	end)
end

UberUI.auras = auras
