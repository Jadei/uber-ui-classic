local addon, ns = ...
local minimap = {}

minimap=CreateFrame("frame")
minimap:RegisterEvent("PLAYER_LOGIN")
minimap:SetScript("OnEvent", function(self, event)
	if not (IsAddOnLoaded("SexyMap")) then
	end
end)

function minimap:Color(color)
	if not (color) then
		color = uuidb.minimap.color
	end
	MinimapBorder:SetTexture(uuidb.minimap.texture)
	for _,v in pairs({
		MinimapBorder,
		MiniMapMailBorder,
		QueueStatusMinimapButtonBorder,
		select(1, TimeManagerClockButton:GetRegions()),
    }) do
		v:SetVertexColor(color.r, color.g, color.b, color.a)
	end
	select(2, TimeManagerClockButton:GetRegions()):SetVertexColor(1,1,1)
end

function minimap:GarrisonBtn(color)
	if not (color) then
		local color = uuidb.minimap.color
	end

	if gb then
		gb.border.texture:SetVertexColor(color.r, color.g, color.b, color.a)
	end
end

function minimap:Other()
  	MinimapBorderTop:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	MiniMapWorldMapButton:Hide()
	MinimapZoneText:SetPoint("CENTER", Minimap, 0, 80)
	-- GameTimeFrame:Hide()
	-- GameTimeFrame:UnregisterAllEvents()
	-- GameTimeFrame.Show = kill
	-- MiniMapTracking:Hide()
	-- MiniMapTracking.Show = kill
	-- MiniMapTracking:UnregisterAllEvents()
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, z)
		local c = Minimap:GetZoom()
		if(z > 0 and c < 5) then
			Minimap:SetZoom(c + 1)
		elseif(z < 0 and c > 0) then
			Minimap:SetZoom(c - 1)
		end
	end)
	Minimap:SetScript("OnMouseUp", function(self, btn)
		if btn == "RightButton" then
			_G.GameTimeFrame:Click()
		elseif btn == "MiddleButton" then
			_G.ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, self)
		else
			_G.Minimap_OnClick(self)
		end
	end)
end

function minimap:ReworkAllColor(color)
	if not (color) then
		color = uuidb.minimap.color
	end
	self:Color(color)
	-- self:GarrisonBtn(color)
	self:Other()
end

UberUI.minimap = minimap
