---------------------------------------
-- VARIABLES
---------------------------------------
local addon, ns = ...
local actionbars = {}

local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
local class = UnitClass("player")
local dominos = IsAddOnLoaded("Dominos")
local bartender4 = IsAddOnLoaded("Bartender4")
local actionbars = CreateFrame("frame")
actionbars:RegisterEvent("ADDON_LOADED")
actionbars:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)

if IsAddOnLoaded("Masque") and (dominos or bartender4) then
  return
end

function actionbars:ADDON_LOADED()
   --backdrop settings
  local bgfile, edgefile = "", ""
  if uuidb.actionbars.showshadow then edgefile = uuidb.textures.buttons.outer_shadow end
  if uuidb.actionbars.useflatbackground and uuidb.actionbars.showbg then bgfile = uuidb.textures.buttons.buttonbackflat end

  --backdrop
 local backdrop = {
    bgFile = bgfile,
    edgeFile = edgefile,
    tile = false,
    tileSize = 32,
    edgeSize = uuidb.actionbars.inset,
    insets = {
      left = uuidb.actionbars.inset,
      right = uuidb.actionbars.inset,
      top = uuidb.actionbars.inset,
      bottom = uuidb.actionbars.inset,
    },
  }

  local abinit = 0
end

---------------------------------------
-- FUNCTIONS
---------------------------------------
local function applyBackground(bu)
  local bgfile, edgefile = "", ""
  if uuidb.actionbars.showshadow then edgefile = uuidb.textures.buttons.outer_shadow end
  if uuidb.actionbars.useflatbackground and uuidb.actionbars.showbg then bgfile = uuidb.textures.buttons.buttonbackflat end

  if uuidb.actionbars.overridecol  then
    edgefile = nil
  end

  local backdrop = {
    bgFile = bgfile,
    edgeFile = edgefile,
    tile = false,
    tileSize = 32,
    edgeSize = uuidb.actionbars.inset,
    insets = {
      left = uuidb.actionbars.inset,
      right = uuidb.actionbars.inset,
      top = uuidb.actionbars.inset,
      bottom = uuidb.actionbars.inset,
    }
  }

  if uuidb.general.customcolor or uuidb.general.classcolorframes then
    backgroundcolor = uuidb.general.customcolorval
    shadowcolor = uuidb.general.customcolorval
  else
    backgroundcolor = uuidb.actionbars.backgroundcolor
    shadowcolor = uuidb.actionbars.shadowcolor
  end

  if bu and bu.bg then
    bu.bg:SetBackdropBorderColor(shadowcolor.r,shadowcolor.g,shadowcolor.b,.9)
  end

  if not bu or (bu and bu.bg) then return end
  
  if bu:GetFrameLevel() < 1 then bu:SetFrameLevel(1) end

  if uuidb.actionbars.showbg or uuidb.actionbars.showshadow then
    bu.bg = CreateFrame("Frame", nil, bu, BackdropTemplateMixin and "BackdropTemplate")
    bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -4, 4)
    bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 4, -4)
    bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)
  end

  if uuidb.actionbars.showbg and not uuidb.actionbars.useflatbackground then
    local t = bu.bg:CreateTexture(nil, "BACKGROUND", nil)
    t:SetTexture(nil)
    t:SetTexture(uuidb.textures.buttons.buttonback)
    t:SetVertexColor(backgroundcolor.r,backgroundcolor.g,backgroundcolor.b,backgroundcolor.a)
  end

  bu.bg:SetBackdrop(backdrop)
  if uuidb.actionbars.useflatbackground then
    bu.bg:SetBackdropColor(backgroundcolor.r,backgroundcolor.g,backgroundcolor.b,backgroundcolor.a)
  end

  if uuidb.actionbars.showshadow then
    bu.bg:SetBackdropBorderColor(shadowcolor.r,shadowcolor.g,shadowcolor.b,.9)
  end
end

-- Style extraactionbutton
local function styleExtraActionButton(bu, color)
  if (color) then
    color = color
    backdropc = color
  else
    color = uuidb.actionbars.color.normal
    backdropc = uuidb.actionbars.shadowcolor
  end

  if uuidb.actionbars.gloss then
    butex = uuidb.textures.buttons.normal
  else
    butex = uuidb.textures.buttons.light
  end

  if not bu or (bu and bu.rabs_styled and not uuidb.actionbars.overridecol) then return end
  
  local name = bu:GetName() or bu:GetParent():GetName()
	local style = bu.style or bu.Style
	local icon = bu.icon or bu.Icon
	local cooldown = bu.cooldown or bu.Cooldown
  local ho = _G[name.."HotKey"]
  
  -- Remove the style background theme
	style:SetTexture(nil)

  hooksecurefunc(style, "SetTexture", function(self, texture)
    if texture then
      self:SetTexture(nil)
    end
  end)

  -- Icon
  icon:SetTexCoord(0.1,0.9,0.1,0.9)
  icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
  icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
  -- Cooldown
  cooldown:SetAllPoints(icon)
  -- Hotkey
	if ho then
		ho:Hide()
	end
  -- Add button normaltexture
  bu:SetNormalTexture(butex)
  local nt = bu:GetNormalTexture()
  nt:SetVertexColor(color.r, color.g, color.b, color.a)
  nt:SetAllPoints(bu)
  -- Apply background
  if not bu.bg or uuidb.actionbars.overridecol then applyBackground(bu) end
	
  bu.Back = CreateFrame("Frame", nil, bu, BackdropTemplateMixin and "BackdropTemplate")
  bu.Back:SetPoint("TOPLEFT", bu, "TOPLEFT", -3, 3)
  bu.Back:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 3, -3)
  bu.Back:SetFrameLevel(bu:GetFrameLevel() - 1)
  bu.Back:SetBackdrop(backdrop)
  bu.Back:SetBackdropBorderColor(backdropc.r, backdropc.g, backdropc.b, backdropc.a)
  bu.rabs_styled = true
end

-- Initial style func
local function styleActionButton(bu, color)
  if not (color) then
    color = uuidb.actionbars.color.normal
  end

  if uuidb.actionbars.gloss then
    butex = uuidb.textures.buttons.normal
  else
    butex = uuidb.textures.buttons.light
  end

  overridecol = uuidb.actionbars.overridecol

  if not bu or (bu and bu.rabs_styled and not uuidb.actionbars.overridecol) then return end

  local action = bu.action
  local name = bu:GetName()
  local ic  = _G[name.."Icon"]
  local co  = _G[name.."Count"]
  local bo  = _G[name.."Border"]
  local ho  = _G[name.."HotKey"]
  local cd  = _G[name.."Cooldown"]
  local na  = _G[name.."Name"]
  local fl  = _G[name.."Flash"]
  local nt  = _G[name.."NormalTexture"]
  local fbg  = _G[name.."FloatingBG"]
  local fob = _G[name.."FlyoutBorder"]
  local fobs = _G[name.."FlyoutBorderShadow"]
  if fbg then fbg:Hide() end  -- Floating background
  
  -- Flyout border stuff
  if fob then fob:SetTexture(nil) end
  if fobs then fobs:SetTexture(nil) end
  bo:SetTexture(nil) -- Hide the border (plain ugly, sry blizz)
  -- Hotkey
  if (ho:GetText() ~= nil and string.byte(ho:GetText())) == 226 then
    ho:SetFont("Fonts\\ARIALN.ttf", uuidb.actionbars.hotkeys.fontsize, "OUTLINE")
  else
    ho:SetFont(uuidb.general.font, uuidb.actionbars.hotkeys.fontsize, "OUTLINE")
  end

  ho:ClearAllPoints()
  ho:SetPoint(uuidb.actionbars.hotkeys.pos1.a1,bu,uuidb.actionbars.hotkeys.pos1.x,uuidb.actionbars.hotkeys.pos1.y)
  ho:SetPoint(uuidb.actionbars.hotkeys.pos2.a1,bu,uuidb.actionbars.hotkeys.pos2.x,uuidb.actionbars.hotkeys.pos2.y)
  if not dominos and not bartender4 and not uuidb.actionbars.hotkeys.show then
    ho:Hide()
  end

  -- Macro name
  na:SetFont(uuidb.general.font, uuidb.actionbars.macroname.fontsize, "OUTLINE")
  na:ClearAllPoints()
  na:SetPoint(uuidb.actionbars.macroname.pos1.a1,bu,uuidb.actionbars.macroname.pos1.x,uuidb.actionbars.macroname.pos1.y)
  na:SetPoint(uuidb.actionbars.macroname.pos2.a1,bu,uuidb.actionbars.macroname.pos2.x,uuidb.actionbars.macroname.pos2.y)
    
  if not dominos and not bartender4 and not uuidb.actionbars.macroname.show then
    na:Hide()
  end

  -- Item stack count
  co:SetFont(uuidb.general.font, uuidb.actionbars.count.fontsize, "OUTLINE")
  co:ClearAllPoints()
  co:SetPoint(uuidb.actionbars.count.pos.a1,bu,uuidb.actionbars.count.pos.x,uuidb.actionbars.count.pos.y)
  if not dominos and not bartender4 and not uuidb.actionbars.count.show then
    co:Hide()
  end

  -- Applying the textures
  fl:SetTexture(uuidb.textures.buttons.flash)
  bu:SetPushedTexture(uuidb.textures.buttons.pushed)
  bu:SetNormalTexture(butex)

  if not nt then
    -- Fix the non existent texture problem (no clue what is causing this)
    nt = bu:GetNormalTexture()
  end

  -- Cut the default border of the icons and make them shiny
  ic:SetTexCoord(0.1,0.9,0.1,0.9)
  ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
  ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
  -- Adjust the cooldown frame
  cd:SetPoint("TOPLEFT", bu, "TOPLEFT", uuidb.actionbars.cooldown.spacing, -uuidb.actionbars.cooldown.spacing)
  cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -uuidb.actionbars.cooldown.spacing, uuidb.actionbars.cooldown.spacing)

  -- Apply the normaltexture
  if action and (IsEquippedAction(action)) then
    bu:SetNormalTexture(uuidb.textures.buttons.equipped)
  else
    bu:SetNormalTexture(butex)
  end

  -- Make the normaltexture match the buttonsize
  nt:SetAllPoints(bu)
  -- Hook to prevent Blizzard from reseting our colors
  hooksecurefunc(nt, "SetVertexColor", function(nt, r, g, b, a)
    if uuidb.general.customcolor or uuidb.general.classcolorframes then
      color = uuidb.general.customcolorval
    end

    if uuidb.actionbars.gloss then
      butex = uuidb.textures.buttons.normal
    else
      butex = uuidb.textures.buttons.light
    end

    local bu = nt:GetParent()

    local action = bu.action
    local curR, curG, curB, curA = nt:GetVertexColor()
    local mult = 10^(2)
    curRR = math.floor(curR*mult+0.5)/mult
    curGG = math.floor(curG*mult+0.5)/mult
    curBB = math.floor(curB*mult+0.5)/mult
    curAA = math.floor(curA*mult+0.5)/mult
    if (curRR ~= color.r and curGG ~= color.g and curBB ~= color.b and curAA ~= color.a) then
      if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
        if uuidb.actionbars.color.equipped.r == 1 and  uuidb.actionbars.color.equipped.g == 1 and  uuidb.actionbars.color.equipped.b == 1 then
          nt:SetVertexColor(0.999,0.999,0.999,1)
        else
          bu:SetNormalTexture(uuidb.textures.buttons.equipped)
          nt:SetVertexColor(uuidb.actionbars.color.equipped.r, uuidb.actionbars.color.equipped.g, uuidb.actionbars.color.equipped.b, uuidb.actionbars.color.equipped.a)
        end
      elseif r==0.5 and g==0.5 and b==1 then
        -- Blizzard oom color
        if color.r == 0.5 and  color.g == 0.5 and  color.b == 1 then
          nt:SetVertexColor(0.499,0.499,0.999,1)
        else
          bu:SetNormalTexture(butex)
          nt:SetVertexColor(color.r, color.g, color.b, color.a)
        end
      elseif r==1 and g==1 and b==1 then
        if color.r == 1 and  color.g == 1 and  color.b == 1 then
          bu:SetNormalTexture(butex)
          nt:SetVertexColor(0.999,0.999,0.999,1)
        else
          bu:SetNormalTexture(butex)
          nt:SetVertexColor(color.r, color.g, color.b, color.a)
        end
      end
    end
  end)

  -- Shadows+backgroundr
  if not bu.bg or uuidb.actionbars.overridecol then applyBackground(bu) end
  
  bu.rabs_styled = true

  if bartender4 then -- Fix the normaltexture
    nt:SetTexCoord(0,1,0,1)
    nt.SetTexCoord = function() return end
    bu.SetNormalTexture = function() return end
  end
end

-- Style leave button
local function styleLeaveButton(bu, color)
  if not (color) then
    color = uuidb.actionbars.color.normal
  end

  if not bu or (bu and bu.rabs_styled and not uuidb.actionbars.overridecol) then return end
	
	local name = bu:GetName()
	local nt = bu:GetNormalTexture()
	local bo = bu:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
	nt:SetTexCoord(0.2,0.8,0.2,0.8)
	nt:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
  nt:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
	bo:SetTexture(butex)
	bo:SetTexCoord(0, 1, 0, 1)
	bo:SetDrawLayer("BACKGROUND",- 7)
	bo:SetVertexColor(0.4, 0.35, 0.35)
	bo:ClearAllPoints()
	bo:SetAllPoints(bu)

  -- Shadows+background
  if not bu.bg or uuidb.actionbars.overridecol then applyBackground(bu) end

  bu.rabs_styled = true
end

-- Style Pet buttons
local function stylePetButton(bu, color)
  if not (color) then
    color = uuidb.actionbars.color.normal
  end

  if not bu or (bu and bu.rabs_styled and not uuidb.actionbars.overridecol) then return end

  local name = bu:GetName()
  local ic  = _G[name.."Icon"]
  local fl  = _G[name.."Flash"]
  local nt  = _G[name.."NormalTexture2"]
  nt:SetAllPoints(bu)
  -- Applying color
  nt:SetVertexColor(color.r, color.g, color.b, color.a)
  -- Setting the textures
  fl:SetTexture(uuidb.textures.buttons.flash)
  bu:SetPushedTexture(uuidb.textures.buttons.pushed)
  bu:SetNormalTexture(butex)

  hooksecurefunc(bu, "SetNormalTexture", function(self, texture)
    -- Make sure the normaltexture stays the way we want it
    if uuidb.actionbars.gloss then
      butex = uuidb.textures.buttons.normal
    else
      butex = uuidb.textures.buttons.light
    end

    if texture and texture ~= butex then
      self:SetNormalTexture(butex)
    end
  end)

  -- Cut the default border of the icons and make them shiny
  ic:SetTexCoord(0.1,0.9,0.1,0.9)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
    
  -- Shadows+background
  if not bu.bg or uuidb.actionbars.overridecol then applyBackground(bu) end

  bu.rabs_styled = true
end

-- Style stance buttons
local function styleStanceButton(bu, color)
  if not (color) then
    color = uuidb.actionbars.color.normal
  end

  if uuidb.actionbars.gloss then
    butex = uuidb.textures.buttons.normal
  else
    butex = uuidb.textures.buttons.light
  end

  if not bu or (bu and bu.rabs_styled and not uuidb.actionbars.overridecol) then return end

  local name = bu:GetName()
  local ic  = _G[name.."Icon"]
  local fl  = _G[name.."Flash"]
  local nt  = _G[name.."NormalTexture2"]
  nt:SetAllPoints(bu)
  -- Applying color
  nt:SetVertexColor(color.r, color.g, color.b, color.a)
  -- Setting the textures
  fl:SetTexture(uuidb.textures.buttons.flash)
  bu:SetPushedTexture(uuidb.textures.buttons.pushed)
  bu:SetNormalTexture(butex)
  -- Cut the default border of the icons and make them shiny
  ic:SetTexCoord(0.1,0.9,0.1,0.9)
  ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
  ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)

  -- Shadows+background
  if not bu.bg or uuidb.actionbars.overridecol then applyBackground(bu) end

  bu.rabs_styled = true
end

-- Style possess buttons
local function stylePossessButton(bu, color)
  if not (color) then
    color = uuidb.actionbars.color.normal
  end

  if uuidb.actionbars.gloss then
    butex = uuidb.textures.buttons.normal
  else
    butex = uuidb.textures.buttons.light
  end

  if not bu or (bu and bu.rabs_styled) then return end
  local name = bu:GetName()
  local ic  = _G[name.."Icon"]
  local fl  = _G[name.."Flash"]
  local nt  = _G[name.."NormalTexture"]
  nt:SetAllPoints(bu)
  -- Applying color
  nt:SetVertexColor(color.r, color.g, color.b, color.a)
  -- Setting the textures
  fl:SetTexture(uuidb.textures.buttons.flash)
  bu:SetPushedTexture(uuidb.textures.buttons.pushed)
  bu:SetNormalTexture(butex)
  -- Cut the default border of the icons and make them shiny
  ic:SetTexCoord(0.1,0.9,0.1,0.9)
  ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
  ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
  -- Shadows+background
  if not bu.bg or uuidb.actionbars.overridecol then applyBackground(bu) end
  bu.rabs_styled = true
end

function actionbars:Hotkeys()
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    if uuidb.actionbars.hotkeys.show then
      _G["ActionButton"..i]["HotKey"]:Show()
      _G["MultiBarBottomLeftButton"..i]["HotKey"]:Show()
      _G["MultiBarBottomRightButton"..i]["HotKey"]:Show()
      _G["MultiBarRightButton"..i]["HotKey"]:Show()
      _G["MultiBarLeftButton"..i]["HotKey"]:Show()
      if  _G["PetActionButton"] then
        _G["PetActionButton"..i]["HotKey"]:Show()
      end
    else
      _G["ActionButton"..i]["HotKey"]:Hide()
      _G["MultiBarBottomLeftButton"..i]["HotKey"]:Hide()
      _G["MultiBarBottomRightButton"..i]["HotKey"]:Hide()
      _G["MultiBarRightButton"..i]["HotKey"]:Hide()
      _G["MultiBarLeftButton"..i]["HotKey"]:Hide()
      if  _G["PetActionButton"] then
        _G["PetActionButton"..i]["HotKey"]:Hide()
      end
    end
  end
end

function actionbars:Macroname()
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    if uuidb.actionbars.macroname.show then
      _G["ActionButton"..i]["Name"]:Show()
      _G["MultiBarBottomLeftButton"..i]["Name"]:Show()
      _G["MultiBarBottomRightButton"..i]["Name"]:Show()
      _G["MultiBarRightButton"..i]["Name"]:Show()
      _G["MultiBarLeftButton"..i]["Name"]:Show()
      if  _G["PetActionButton"] then
        _G["PetActionButton"..i]["Name"]:Show()
      end
    else
      _G["ActionButton"..i]["Name"]:Hide()
      _G["MultiBarBottomLeftButton"..i]["Name"]:Hide()
      _G["MultiBarBottomRightButton"..i]["Name"]:Hide()
      _G["MultiBarRightButton"..i]["Name"]:Hide()
      _G["MultiBarLeftButton"..i]["Name"]:Hide()
      if  _G["PetActionButton"] then
        _G["PetActionButton"..i]["Name"]:Hide()
      end
    end
  end
end

-- Style bags
local function styleBag(bu, color)
  if not (color) then
      color = uuidb.actionbars.bagiconcolor
    end

  if uuidb.actionbars.gloss then
    butex = uuidb.textures.buttons.normal
  else
    butex = uuidb.textures.buttons.light
  end

	if not bu or (bu and bu.rabs_styled and not uuidb.actionbars.overridecol) then return end
	local name = bu:GetName()
	local ic  = _G[name.."IconTexture"]
	local nt  = _G[name.."NormalTexture"]
	nt:SetTexCoord(0,1,0,1)
	nt:SetDrawLayer("BACKGROUND", -7)
	nt:SetVertexColor(color.r, color.g, color.b, color.a)
	nt:SetAllPoints(bu)
	local bo = bu.IconBorder
	bo:Hide()
	bo.Show = function() end
	ic:SetTexCoord(0.1,0.9,0.1,0.9)
  ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
  ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
  bu:SetNormalTexture(butex)
  bu:SetPushedTexture(uuidb.textures.buttons.pushed)
end

---------------------------------------
-- INIT
---------------------------------------
function actionbars:ReworkAllColors(color)
  if not (color) then
    local color = nil
  end

  -- Style the actionbar buttons
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    styleActionButton(_G["ActionButton"..i], color)
    styleActionButton(_G["MultiBarBottomLeftButton"..i], color)
    styleActionButton(_G["MultiBarBottomRightButton"..i], color)
    styleActionButton(_G["MultiBarRightButton"..i], color)
    styleActionButton(_G["MultiBarLeftButton"..i], color)
  end

	-- Style bags
  for i = 0, 3 do
	  styleBag(_G["CharacterBag"..i.."Slot"], color)
  end
	styleBag(MainMenuBarBackpackButton)

  -- Style leave button
	styleLeaveButton(MainMenuBarVehicleLeaveButton)
  styleLeaveButton(rABS_LeaveVehicleButton)

  -- Petbar buttons
  for i=1, NUM_PET_ACTION_SLOTS do
    stylePetButton(_G["PetActionButton"..i], color)
  end

  -- Stancebar buttons
  for i=1, NUM_STANCE_SLOTS do
    styleStanceButton(_G["StanceButton"..i], color)
  end

  -- Possess buttons
  if _G["PossessButton1"] then
    for i=1, NUM_POSSESS_SLOTS do
      stylePossessButton(_G["PossessButton"..i], color)
    end
  end

  -- Extraactionbutton1
  styleExtraActionButton(ExtraActionButton1, color)

	-- Not Available
  if ZoneAbilityFrame then
    styleExtraActionButton(ZoneAbilityFrame.SpellButton, color)
  end

  -- Leave Button
  styleLeaveButton(_G["MainMenuBarVehicleLeaveButton"], color)

  -- Spell flyout
  if SpellFlyoutBackgroundEnd and SpellFlyoutHorizontalBackground and SpellFlyoutVerticalBackground then
    SpellFlyoutBackgroundEnd:SetTexture(nil)
    SpellFlyoutHorizontalBackground:SetTexture(nil)
    SpellFlyoutVerticalBackground:SetTexture(nil)

    local function checkForFlyoutButtons(self)
      local NUM_FLYOUT_BUTTONS = 10
      for i = 1, NUM_FLYOUT_BUTTONS do
        styleActionButton(_G["SpellFlyoutButton"..i], color)
      end
    end
    SpellFlyout:HookScript("OnShow",checkForFlyoutButtons)
  end

  -- Dominos styling
  if dominos then
    for i = 1, 60 do
      styleActionButton(_G["DominosActionButton"..i], color)
    end
  end

  -- Bartender4 styling
  if bartender4 then
    for i = 1, 120 do
      styleActionButton(_G["BT4Button"..i], color)
	    stylePetButton(_G["BT4PetButton"..i], color)
    end
  end
end

function actionbars.EditColors(color)
  if not (color) then
    color = uuidb.actionbars.shadowcolor
  end

  -- Style the actionbar buttons
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    _G["ActionButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    _G["MultiBarBottomLeftButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    _G["MultiBarBottomRightButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    _G["MultiBarRightButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    _G["MultiBarLeftButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
  end

  -- Style bags
  for i = 0, 3 do
    if _G["CharacterBag"..i.."Slot"].bg then
      _G["CharacterBag"..i.."Slot"].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    end
  end

  if MainMenuBarBackpackButton.bg then
    MainMenuBarBackpackButton.bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
  end
  
  -- Petbar buttons
  if UnitExists("pet") then
    for i=1, NUM_PET_ACTION_SLOTS do
      _G["PetActionButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    end
  end

  -- Stancebar buttons
  for i=1, NUM_STANCE_SLOTS do
    if _G["StanceButton"..i].bg then
      _G["StanceButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    end
  end
 
  -- Dominos styling
  if dominos then
    for i = 1, 60 do
      _G["DominosActionButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    end
  end

  -- Bartender4 styling
  if bartender4 then
    for i = 1, 120 do
      _G["BT4Button"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
      _G["BT4PetButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
    end
  end

  uuidb.actionbars.overridecol = false
end

UberUI.actionbars = actionbars
