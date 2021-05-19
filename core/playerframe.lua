local addon, ns = ...
local playerframes = {}

playerframes = CreateFrame("frame")
playerframes:RegisterEvent("ADDON_LOADED")
playerframes:RegisterEvent("PLAYER_LOGIN")
playerframes:RegisterEvent("PLAYER_ENTERING_WORLD")
-- Commentaire: Pas encore de véhicule
-- playerframes:RegisterEvent("UNIT_ENTERED_VEHICLE")
-- playerframes:RegisterEvent("UNIT_EXITED_VEHICLE")

playerframes:SetScript("OnEvent", function(self,event)
	if not ((IsAddOnLoaded("EasyFrames")) or (IsAddOnLoaded("Shadowed Unit Frames")) or (IsAddOnLoaded("PitBull Unit Frames 4.0")) or (IsAddOnLoaded("X-Perl UnitFrames"))) then
	end

	if uuidb.general.customcolor or uuidb.general.classcolorframes then
		playerframes:ReworkAllColor(color)
	end
	player = uuidb.playerframe

	if uuidb.playerframe.largehealth then
		hooksecurefunc("PlayerFrame_ToPlayerArt", uui_playerframes_LargeHealth)
	end

	-- Commentaire: Pas encore de véhicule
	-- current_v_state = UnitInVehicle("Player")
	-- prev_v_state = false
	-- if current_v_state ~= prev_v_state and uuidb.playerframe.largehealth then
	-- 	uui_playerframes_LargeHealth()
	-- end
end)

local function MiscFrames(color)
	if not (color) then
		color = uuidb.playerframe.color
	end

	if uuidb.playerframe.largehealth then
		frametexture = uuidb.textures.targetframebig
	else
		frametexture = uuidb.textures.targetframe
	end

	for _,v in pairs({
		PlayerFrameTexture,
		CastingBarFrame.Border,
		PlayerFrameAlternateManaBarBorder, 
		PlayerFrameAlternateManaBarRightBorder, 
		PlayerFrameAlternateManaBarLeftBorder,
		-- TBT: Voleur et les combos
		-- ComboPointPlayerFrame.Background,
		-- ComboPointPlayerFrame.Combo1.PointOff,
		-- ComboPointPlayerFrame.Combo2.PointOff,
		-- ComboPointPlayerFrame.Combo3.PointOff,
		-- ComboPointPlayerFrame.Combo4.PointOff,
		-- ComboPointPlayerFrame.Combo5.PointOff,
		-- ComboPointPlayerFrame.Combo6.PointOff,
		AlternatePowerBarBorder,
		AlternatePowerBarLeftBorder,
		AlternatePowerBarRightBorder,
		PetFrameTexture,
		PaladinPowerBarFrameBG,
		PaladinPowerBarFrameBankBG
	}) do
		-- Texture frames to appropriately color
		if v:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame" and not uuidb.playerframe.LargeHealth then
			v:SetTexture(frametexture.targetingframe)
        elseif v:GetTexture() == "Interface\\TargetingFrame\\UI-SmallTargetingFrame" then
			v:SetTexture(uuidb.textures.other.smalltarget) 
        elseif v:GetTexture() == "Interface\\TargetingFrame\\UI-PartyFrame" then
			v:SetTexture(uuidb.textures.other.party)
        elseif v:GetTexture() == "Interface\\TargetingFrame\\UI-TargetofTargetFrame" then
			v:SetTexture(uuidb.textures.other.tot)
		end
		v:SetVertexColor(color.r, color.g, color.b, color.a)
    end
    CastingBarFrame.Border:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\castingbarborder")

	for _,v in pairs({
      TotemFrameTotem1,
      TotemFrameTotem2,
      TotemFrameTotem3,
      TotemFrameTotem4
	}) do
	   for _,child in pairs({v:GetChildren()}) do
	      local name = child:GetName()
	      if name == nil then
	         local regions = child:GetRegions()
	         for _,region in pairs({regions}) do
	            if region:GetTexture():find("TotemBorder") then
	            	region:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\TotemBorder")
	            	region:SetVertexColor(color.r, color.g, color.b, color.a)
	            end
	         end
	      end
	   end
	end
end

local pcount = 0
 
function uui_playerframes_LargeHealth(color)
	if uuidb.general.customcolor or uuidb.general.classcolorframes then
		color = uuidb.general.customcolorval
	else
		color = uuidb.playerframe.color
	end

	-- Commentaire: Pas encore de véhicule
	-- if uuidb.playerframe.largehealth and not UnitInVehicle("Player") then
	if uuidb.playerframe.largehealth then
		PlayerFrameTexture:SetTexture("Interface\\Addons\\Uber UI Classic\\textures\\target\\targetingframebig")
		PlayerFrameTexture:SetVertexColor(color.r, color.g, color.b, color.a)
		PlayerFrameGroupIndicatorText:ClearAllPoints()
		PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame, "TOP", 0, -20)
		PlayerFrameGroupIndicatorLeft:Hide()
		PlayerFrameGroupIndicatorMiddle:Hide()
		PlayerFrameGroupIndicatorRight:Hide()
		PlayerFrameHealthBar:SetPoint("TOPLEFT", 106, -24)
		PlayerFrameHealthBar:SetHeight(29)
		PlayerFrameHealthBar.LeftText:ClearAllPoints()
		PlayerFrameHealthBar.LeftText:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 10, 0)
		PlayerFrameHealthBar.RightText:ClearAllPoints()
		PlayerFrameHealthBar.RightText:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -5, 0)
		PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)
		PlayerFrameManaBar:SetPoint("TOPLEFT", 106, -52)
		PlayerFrameManaBar:SetHeight(13)
		PlayerFrameManaBar.LeftText:ClearAllPoints()
		PlayerFrameManaBar.LeftText:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 10, 0)
		PlayerFrameManaBar.RightText:ClearAllPoints()
		PlayerFrameManaBar.RightText:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -5, 1)
		PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)

		if PlayerFrameManaBar.FeedbackFrame then
			PlayerFrameManaBar.FeedbackFrame:ClearAllPoints()
			PlayerFrameManaBar.FeedbackFrame:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
			PlayerFrameManaBar.FeedbackFrame:SetHeight(13)
		end 
		
    if PlayerFrameManaBar.FullPowerFrame then
      PlayerFrameManaBar.FullPowerFrame.SpikeFrame.AlertSpikeStay:ClearAllPoints()
      PlayerFrameManaBar.FullPowerFrame.SpikeFrame.AlertSpikeStay:SetPoint("CENTER",PlayerFrameManaBar.FullPowerFrame,"RIGHT",-6,-3)
      PlayerFrameManaBar.FullPowerFrame.SpikeFrame.AlertSpikeStay:SetSize(30, 29)
      PlayerFrameManaBar.FullPowerFrame.PulseFrame:ClearAllPoints()
      PlayerFrameManaBar.FullPowerFrame.PulseFrame:SetPoint("CENTER", PlayerFrameManaBar.FullPowerFrame, "CENTER", -6, -2)
      PlayerFrameManaBar.FullPowerFrame.SpikeFrame.BigSpikeGlow:ClearAllPoints()
      PlayerFrameManaBar.FullPowerFrame.SpikeFrame.BigSpikeGlow:SetPoint("CENTER",PlayerFrameManaBar.FullPowerFrame,"RIGHT",5,-4)
      PlayerFrameManaBar.FullPowerFrame.SpikeFrame.BigSpikeGlow:SetSize(30, 50)
    end 
	-- Commentaire: Pas encore de véhicule
	-- elseif uuidb.playerframe.largehealth and UnitInVehicle("Player") and (PlayerFrame.state == "vehicle" or PlayerFrameTexture:GetTexture() ~= "Interface\\Addons\\Uber UI Classic\\textures\\target\\targetingframebig") then
	-- 	PlayerFrameHealthBar:SetHeight(12)
	-- 	PlayerFrameHealthBar.LeftText:ClearAllPoints()
	-- 	PlayerFrameHealthBar.LeftText:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 10, 0)
	-- 	PlayerFrameHealthBar.RightText:ClearAllPoints()
	-- 	PlayerFrameHealthBar.RightText:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -5, 0)
	end

	if pcount == 0 then
		hooksecurefunc("PlayerFrame_UpdateStatus",function()
			PlayerStatusTexture:Hide()
			PlayerRestGlow:Hide()
			PlayerStatusGlow:Hide()
		end)
		pcount = pcount + 1
	end

	PlayerFrameGroupIndicator:SetAlpha(0)
	PlayerHitIndicator:SetText(nil) 
	PlayerHitIndicator.SetText = function() end
end

function playerframes:Name()
	if uuidb.playerframe.largehealth then
		PlayerName:Hide()
	end
end

function playerframes:Scale(value)
	if (PlayerFrame:GetScale() ~= value) then
		PlayerFrame:SetScale(value)
	end
end

function playerframes:RoleIconBorder(color)
	if uuidb.general.customcolor or uuidb.general.classcolorframes then
		color = uuidb.general.customcolorval
	else
		color = uuidb.playerframe.color
	end

	if not _G["PlayerFrameRoleIconBorder"] then
		-- Not Available
		local parent = PlayerFrameRoleIcon:GetParent()
		local ri_layer, ri_sub = PlayerFrameRoleIcon:GetDrawLayer()
		parent.roleIconBorder = parent:CreateTexture("PlayerFrameRoleIconBorder")
		parent.roleIconBorder:SetPoint(PlayerFrameRoleIcon:GetPoint())
		parent.roleIconBorder:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\ui-portraitroles")
		parent.roleIconBorder:SetSize(PlayerFrameRoleIcon:GetSize())
		parent.roleIconBorder:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
		parent.roleIconBorder:SetDrawLayer(ri_layer,ri_sub+1)
		parent.roleIconBorder:SetVertexColor(color.r, color.g, color.b)
		hooksecurefunc("PlayerFrame_UpdateRolesAssigned", function()
			local role = UnitGroupRolesAssigned("player");
			local parent = PlayerFrameRoleIcon:GetParent()
			if ( role == "TANK" or role == "HEALER" or role == "DAMAGER") then
				parent.roleIconBorder:Show();
			else
				parent.roleIconBorder:Hide();
			end
		end)
	else
		local parent = PlayerFrameRoleIcon:GetParent()
		parent.roleIconBorder:SetVertexColor(color.r, color.g, color.b)
	end
end

function playerframes:PetFrame()
	hooksecurefunc("PetFrame_Update", function(self, override)
		  if ( (not PlayerFrame.animating or UnitInVehicle("player") or UnitisDead("player")) or (override) ) then
			if ( UnitIsVisible(self.unit) and PetUsesPetFrame() and not PlayerFrame.vehicleHidesPet ) then
			    if ( self:IsShown() ) then
			      UnitFrame_Update(self);
			    else
			      self:Show();
			    end
			    --self.flashState = 1;
			    --self.flashTimer = PET_FLASH_ON_TIME;
			    if ( UnitPowerMax(self.unit) == 0 ) then
			      PetFrameTexture:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\target\\smalltargetingframe-nomana");
			      PetFrameManaBarText:Hide();
			    else
			      PetFrameTexture:SetTexture("Interface\\AddOns\\Uber UI Classic\\textures\\target\\smalltargetingframe");
			    end
			    PetAttackModeTexture:Hide();
			    RefreshDebuffs(self, self.unit, nil, nil, true);
			else
			    self:Hide();
			end
		end
	end)
	PetHitIndicator:SetText(nil) 
	PetHitIndicator.SetText = function() end
end

function playerframes:ReworkAllColor(color)
	if not ((IsAddOnLoaded("EasyFrames")) or (IsAddOnLoaded("Shadowed Unit Frames")) or (IsAddOnLoaded("PitBull Unit Frames 4.0")) or (IsAddOnLoaded("X-Perl UnitFrames"))) then
		if not (self) then
			self = playerframes
		end
		if not (color) then
			local colors = uuidb.playerframe.color
		end

		--enable large health style
		if uuidb.playerframe.largehealth then
			uui_playerframes_LargeHealth(color)
		end
		MiscFrames(color)
		self:Name()
		self:Scale(uuidb.playerframe.scale)

    if _G["PlayerFrameRoleIconBorder"] then
		  self:RoleIconBorder()
    end
	end
end

UberUI.playerframes = playerframes
