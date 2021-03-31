local addon, ns = ...
local targetframes = {}

--[[
	Local Variables
]]--
local class = UnitClass("player")
local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]


local targetframes = CreateFrame("frame")
targetframes:RegisterEvent("ADDON_LOADED")
targetframes:SetScript("OnEvent", function(self, event)
	if not (IsAddOnLoaded("EasyFrames")) then
		hooksecurefunc("TargetFrame_CheckClassification", uui_TargetFrameStyleTargetFrame)
	end

	if uuidb.targetframe.colortargett ~= ("None") then
		self:ClassColorTargetEnable()
	end
end)

function uui_TargetFrameStyleTargetFrame(self, forceNormalTexture)
	local classification = UnitClassification(self.unit)

	if uuidb.targetframe.largehealth then
		TargetFrameTextureFrameTexture:SetTexture("Interface\\Addons\\Uber UI Classic\\textures\\target\\targetingframebig")
		self.deadText:ClearAllPoints()
		self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
		self.levelText:SetPoint("RIGHT", self.healthbar, "BOTTOMRIGHT", 63, 10)
		self.nameBackground:Hide()
		self.Background:SetSize(119, 42)
		self.Background:ClearAllPoints()
		self.Background:SetPoint("TOPLEFT", 5, -24)
		self.manabar.pauseUpdates = false
		self.manabar:Show()
		-- (N'existe pas sur Classic)
		-- TextStatusBar_UpdateTextString(self.manabar)
		-- self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
		self.healthbar:SetSize(119, 29)
		self.healthbar:ClearAllPoints()
		self.healthbar:SetPoint("TOPLEFT", 5, -24)
		-- (N'existe pas sur Classic)
		-- self.healthbar.LeftText:ClearAllPoints()
		-- self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0)
		-- self.healthbar.RightText:ClearAllPoints()
		-- self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0)
		-- self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
		self.manabar:ClearAllPoints()
		self.manabar:SetPoint("TOPLEFT", 5, -52)
		self.manabar:SetSize(119, 13)
		-- (N'existe pas sur Classic)
		-- self.manabar.LeftText:ClearAllPoints()
		-- self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 8, 0)
		-- self.manabar.RightText:ClearAllPoints()
		-- self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -5, 0)
		-- self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0)


		-- TO CHECK
		-- for _, nmf in pairs({TargetFrameNumericalThreat:GetRegions()}) do
		-- 	nmf:Hide()
		-- end

		--TargetOfTarget (N'existe pas sur Classic)
		TargetFrameToTHealthBar:ClearAllPoints()
		TargetFrameToTHealthBar:SetPoint("TOPLEFT", 44, -15)
		TargetFrameToTHealthBar:SetHeight(8)
		TargetFrameToTManaBar:ClearAllPoints()
		TargetFrameToTManaBar:SetPoint("TOPLEFT", 44, -24)
		TargetFrameToTManaBar:SetHeight(5)
		-- FocusFrameToTHealthBar:ClearAllPoints()
		-- FocusFrameToTHealthBar:SetPoint("TOPLEFT", 45, -15)
		-- FocusFrameToTHealthBar:SetHeight(8)
		-- FocusFrameToTManaBar:ClearAllPoints()
		-- FocusFrameToTManaBar:SetPoint("TOPLEFT", 45, -25)
		-- FocusFrameToTManaBar:SetHeight(3)
		-- FocusFrameToT.deadText:SetWidth(0.01)
	else
		frametexture = uuidb.textures.targetframe
		local texture = uuidb.textures.statusbars[uuidb.general.bartexture]
		if uuidb.general.bartexture ~= "Blizzard" then
			TargetFrameTextureFrameName:Show()
			TargetFrameNameBackground:SetTexture(texture)
			FocusFrameNameBackground:SetTexture(texture)
		end
		if not uuidb.targetframe.name then
			TargetFrameTextureFrameName:Show()
			TargetFrameNameBackground:Hide()
			FocusFrameNameBackground:Hide()
			TargetFrameBackground:SetHeight(42)
			FocusFrameBackground:SetHeight(42)
		end
	end

	if uuidb.miscframes.pvpicons then
		TargetFrameTextureFramePrestigeBadge:SetAlpha(1)
		TargetFrameTextureFramePrestigePortrait:SetAlpha(1)
		TargetFrameTextureFramePrestigePortrait:SetTexture(uuidb.textures.other.prestige)
		if select(2, UnitFactionGroup("target")) == "Horde" then
			TargetFrameTextureFramePVPIcon:SetTexture(uuidb.textures.other.pvphorde)
			TargetFrameTextureFramePrestigePortrait:SetTexCoord(0.000976562, 0.0498047, 0.869141, 0.970703)
		elseif select(2, UnitFactionGroup("target")) == "Neutral" then
			TargetFrameTextureFramePrestigePortrait:SetTexCoord(0.0517578, 0.100586, 0.763672, 0.865234)
		else
			TargetFrameTextureFramePVPIcon:SetTexture(uuidb.textures.other.pvpally)
			TargetFrameTextureFramePrestigePortrait:SetTexCoord(0.000976562, 0.0498047, 0.763672, 0.865234)
		end
	else
		TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
		TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
	end

	if (uuidb.targetframe.colordragon and not TargetFrameTextureFrame.dragon) then
		local parent = TargetFrameTextureFrame
		local layer, sub = TargetFrameTextureFrameTexture:GetDrawLayer()
		local point, rf, rp, ofsx, ofsy = TargetFrameTextureFrameTexture:GetPoint()
		parent.dragon = parent:CreateTexture("TargetFrameTextureFrameDragon", "BACKGROUND", nil, 3)
		parent.dragon:SetPoint(point, rf, rp, ofsx-25, ofsy)
		parent.dragon:Hide()
	elseif TargetFrameTextureFrame.dragon then
		TargetFrameTextureFrame.dragon:Hide()
	end


	-- get color in use
	if uuidb.general.customcolor or uuidb.general.classcolorframes then
		colors = uuidb.general.customcolorval
	else
		colors = uuidb.targetframe.color
	end

	-- style frames accordingly
	local classification = UnitClassification(self.unit)
	if uuidb.targetframe.largehealth then
		if uuidb.targetframe.nameinside then
			TargetFrameTextureFrameName:SetPoint("CENTER", TargetFrameTextureFrame, "CENTER", -50, 20)
		else
			TargetFrameTextureFrameName:SetPoint("CENTER", TargetFrameTextureFrame, "CENTER", -50, 36)
		end
	end

	if (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Friendly/Hostile" or uuidb.targetframe.colortargett == "Class/Friendly/Hostile") then
		local red,green,_ = UnitSelectionColor(self.unit)
		if (red == 0) then
    	    colors = { r = 0, g = 1, b = 0}
    	elseif (green == 0) then
    	    colors = { r = 1, g = 0, b = 0}
    	else
    	    colors = { r = 1, g = 1, b = 0}
    	end
    end

	if ( classification == "minus" ) then
		self.borderTexture:SetTexture(frametexture.minus)
        if uuidb.targetframe.largehealth then
			self.borderTexture:SetTexture(frametexture.minus)
			self.threatIndicator:SetTexture(frametexture.minusflash)
			self.Background:SetSize(119, 22)
			self.Background:ClearAllPoints()
			self.Background:SetPoint("TOPLEFT", 5, -42)
			self.healthbar:SetSize(119, 22)
			self.healthbar:ClearAllPoints()
			self.healthbar:SetPoint("TOPLEFT", 5, -42)
			-- self.healthbar.LeftText:ClearAllPoints()
			-- self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0)
			-- self.healthbar.RightText:ClearAllPoints()
			-- self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0)
			-- self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
			TargetFrameTextureFrameName:SetPoint("CENTER", TargetFrameTextureFrame, "CENTER", -50, 20)
		end
		-- self.healthbar
		self.borderTexture:SetTexture(frametexture.minus)
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		self.nameBackground:Hide();
		self.manabar.pauseUpdates = true;
		self.manabar:Hide();
		-- self.manabar.TextString:Hide();
		-- self.manabar.LeftText:Hide();
		-- self.manabar.RightText:Hide();
		forceNormalTexture = true;
		TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	elseif ( classification == "worldboss" or classification == "elite" ) then
		self.borderTexture:SetTexture(frametexture.elite)
		if (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Rare/Elite") then
			colors = {r = 159/255, g = 115/255, b = 19/255}
			TargetFrameTextureFramePrestigePortrait:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
			TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		end
		if TargetFrameTextureFrame.dragon then
			if uuidb.targetframe.colordragon then
				TargetFrameTextureFrame.dragon:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\target\\EliteDragon")
				TargetFrameTextureFrame.dragon:Show()
			else
				TargetFrameTextureFrame.dragon:Hide()
			end
		end
		TargetFrameTextureFramePrestigePortrait:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	elseif ( classification == "rareelite" ) then
		self.borderTexture:SetTexture(frametexture.rareelite)
		if (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Rare/Elite") then
			colors = {r = 65/255, g = 66/255, b = 73/255}
			TargetFrameTextureFramePrestigePortrait:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
			TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		end
		if TargetFrameTextureFrame.dragon then
			if uuidb.targetframe.colordragon then
				TargetFrameTextureFrame.dragon:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\target\\RareEliteDragon")
				TargetFrameTextureFrame.dragon:Show()
			else
				TargetFrameTextureFrame.dragon:Hide()
			end
		end
		TargetFrameTextureFramePrestigePortrait:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	elseif ( classification == "rare" ) then
		self.borderTexture:SetTexture(frametexture.rare)
		if (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Rare/Elite") then
			colors = {r = 173/255, g = 166/255, b = 156/255}
			TargetFrameTextureFramePrestigePortrait:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
			TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		end
		if TargetFrameTextureFrame.dragon then
			if uuidb.targetframe.colordragon then
				TargetFrameTextureFrame.dragon:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\target\\RareDragon")
				TargetFrameTextureFrame.dragon:Show()
			else
				TargetFrameTextureFrame.dragon:Hide()
			end
		end
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	else
		if UnitIsPlayer(self.unit) and (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Class" or uuidb.targetframe.colortargett == "Class/Friendly/Hostile") then
			colors = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
			TargetFrameTextureFramePrestigePortrait:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
			TargetFrameSpellBar.Border:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		end
		TargetFrameTextureFramePrestigePortrait:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		self.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
		-- TODO : Debug
		-- self.borderTexture:SetTexture(frametexture.targetingframe)
		if not uuidb.miscframes.pvpicons then
			TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
		end
		TargetFrameToTTextureFrameTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	end

end

function targetframes:ClassColorTargetEnable()
	hooksecurefunc("TargetofTarget_Update", self.PLAYER_TARGET_CHANGED)
end

function targetframes:PLAYER_TARGET_CHANGED()
	local colors
	if UnitIsConnected("targettarget") and (uuidb.targetframe.colortargett == "All" or uuidb.targetframe.colortargett == "Class") then
		if UnitIsPlayer("targettarget") then
			colors = RAID_CLASS_COLORS[select(2, UnitClass("targettarget"))]
		else
			local red,green,_ = UnitSelectionColor("targettarget")
			if (red == 0) then
        	    colors = { r = 0, g = 1, b = 0}
        	elseif (green == 0) then
        	    colors = { r = 1, g = 0, b = 0}
        	else
        	    colors = { r = 1, g = 1, b = 0}
        	end
		end
		TargetFrameToTTextureFrameTexture:SetVertexColor(colors.r, colors.g, colors.b, colors.a)
	end
end

function targetframes:Name()
	if uuidb.targetframe.name and uuidb.targetframe.largehealth then
		TargetFrameTextureFrameName:ClearAllPoints()
		TargetFrameTextureFrameName:SetPoint("CENTER", TargetFrameTextureFrame, "CENTER", -50, 36)
		TargetFrameTextureFrameName:Show()
	elseif uuidb.targetframe.name then
		TargetFrameTextureFrameName:Show()
	else
		TargetFrameTextureFrameName:Hide()
		TargetFrameNameBackground:Hide()
		FocusFrameNameBackground:Hide()
	end
end

function targetframes:Scale(value)
	TargetFrame:SetScale(value)
end

function targetframes:Frames(color)
	for _,v in pairs({
		TargetFrameToTTextureFrameTexture,
		Boss1TargetFrameTextureFrameTexture,
		Boss2TargetFrameTextureFrameTexture,
		Boss3TargetFrameTextureFrameTexture,
		Boss4TargetFrameTextureFrameTexture,
		Boss5TargetFrameTextureFrameTexture,
		Boss1TargetFrameSpellBar.Border,
		Boss2TargetFrameSpellBar.Border,
		Boss3TargetFrameSpellBar.Border,
		Boss4TargetFrameSpellBar.Border,
		Boss5TargetFrameSpellBar.Border,
		TargetFrameSpellBar.Border,
	}) do
		v:SetVertexColor(color.r, color.g, color.b, color.a)
	end
	TargetFrameSpellBar.Border:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\castingbar-small")
end

function targetframes:ReworkAllColor(color)
	if not (IsAddOnLoaded("EasyFrames")) then
		if not (color) then
			color = uuidb.targetframe.color
		end

		self:Name()
		self:Scale(uuidb.targetframe.scale)
		self:Frames(color)
		uui_TargetFrameStyleTargetFrame(TargetFrame, color)
	end
end

UberUI.targetframes = targetframes
