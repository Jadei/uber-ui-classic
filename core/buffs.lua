local addon, ns = ...
buffs = {}

buffs = CreateFrame("frame")
buffs:RegisterEvent("ADDON_LOADED")

buffs:SetScript("OnEvent", function(self)
  local buff = uuidb.buffdebuff.buff
  local debuff = uuidb.buffdebuff.debuff

  -- Rewrite the oneletter shortcuts
  if uuidb.buffdebuff.oneletterabrev then
    HOUR_ONELETTER_ABBR = "%dh"
    DAY_ONELETTER_ABBR = "%dd"
    MINUTE_ONELETTER_ABBR = "%dm"
    SECOND_ONELETTER_ABBR = "%ds"
  end

  -- Backdrop debuff
  backdropDebuff = {
    bgFile = nil,
    edgeFile = "Interface\\AddOns\\Uber UI Classic\\textures\\outer_shadow",
    tile = false,
    tileSize = 32,
    edgeSize = 6,
    insets = {
      left = 6,
      right = 6,
      top = 6,
      bottom = 6,
    },
  }

  -- Backdrop buff
  backdropBuff = {
    bgFile = nil,
    edgeFile = "Interface\\AddOns\\Uber UI Classic\\textures\\outer_shadow",
    tile = false,
    tileSize = 32,
    edgeSize = 6,
    insets = {
      left = 6,
      right = 6,
      top = 6,
      bottom = 6,
    },
  }

  if not rBFS_BuffDragFrame then
    local bf = CreateFrame("Frame", "rBFS_BuffDragFrame", UIParent)
    bf:SetSize(buff.button.size,buff.button.size)
    bf:SetPoint(buff.pos.a1,buff.pos.af,buff.pos.a2,buff.pos.x,buff.pos.y)
  end

  if not rBFS_DebuffDragFrame then
    local df = CreateFrame("Frame", "rBFS_DebuffDragFrame", UIParent)
    df:SetSize(debuff.button.size,debuff.button.size)
    df:SetPoint(debuff.pos.a1,debuff.pos.af,debuff.pos.a2,debuff.pos.x,debuff.pos.y)
  end
end)

local ceil, min, max = ceil, min, max
local ShouldShowConsolidatedBuffFrame = ShouldShowConsolidatedBuffFrame

local buffFrameHeight = 0

---------------------------------------
-- FUNCTIONS
---------------------------------------
-- Apply aura frame texture func
local function applySkin(b)
  if not b then return end
  -- Button name
  local name = b:GetName()
  -- Check the button type
  local tempenchant, consolidated, debuff, buff = false, false, false, false
  if (name:match("TempEnchant")) then
    tempenchant = true
  elseif (name:match("Consolidated")) then
    consolidated = true
  elseif (name:match("Debuff")) then
    debuff = true
  else
    buff = true
  end
  -- Get cfg and backdrop
  if debuff then
    uui = uuidb.buffdebuff.debuff
    backdrop = backdropDebuff
  else
    uui = uuidb.buffdebuff.buff
    backdrop = backdropBuff
  end

  -- Check class coloring options
  if uuidb.general.customcolor or uuidb.general.classcolorframes then
    bordercolor = uuidb.general.customcolorval
    backgroundcolor = uuidb.general.customcolorval
  else
    bordercolor = uui.border.color
    backgroundcolor = uui.border.color
  end

  if b and b.styled then 
    b.border:SetVertexColor(bordercolor.r, bordercolor.g, bordercolor.b, bordercolor.a)
    b.bg:SetBackdropBorderColor(backgroundcolor.r, backgroundcolor.g, backgroundcolor.b, backgroundcolor.a)
  end
  
  if not b or (b and b.styled) then return end
  -- Button
  b:SetSize(uui.button.size, uui.button.size)

  -- Icon
  local icon = _G[name.."Icon"]
  if consolidated then
    if select(1,UnitFactionGroup("player")) == "Alliance" then
      icon:SetTexture(select(3,GetSpellInfo(61573)))
    elseif select(1,UnitFactionGroup("player")) == "Horde" then
      icon:SetTexture(select(3,GetSpellInfo(61574)))
    end
  end

  icon:SetTexCoord(0.1,0.9,0.1,0.9)
  icon:ClearAllPoints()
  icon:SetPoint("TOPLEFT", b, "TOPLEFT", -uui.icon.padding, uui.icon.padding)
  icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", uui.icon.padding, -uui.icon.padding)
  icon:SetDrawLayer("BACKGROUND",-8)
  b.icon = icon

  -- Border
  local border = _G[name.."Border"] or b:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
  border:SetTexture(uui.border.texture)
  border:SetTexCoord(0,1,0,1)
  border:SetDrawLayer("BACKGROUND",-7)
  
  if tempenchant then
    border:SetVertexColor(0.7,0,1)
  elseif not debuff then
    border:SetVertexColor(bordercolor.r, bordercolor.g, bordercolor.b, bordercolor.a)
  end
  border:ClearAllPoints()
  border:SetAllPoints(b)
  b.border = border

  -- Duration
  b.duration:SetFont(uui.duration.font, uui.duration.size, "THINOUTLINE")
  b.duration:ClearAllPoints()
  b.duration:SetPoint(uui.duration.pos.a1,uui.duration.pos.x,uui.duration.pos.y)

  -- Count
  b.count:SetFont(uui.count.font, uui.count.size, "THINOUTLINE")
  b.count:ClearAllPoints()
  b.count:SetPoint(uui.count.pos.a1,uui.count.pos.x,uui.count.pos.y)

  -- Shadow
  if uui.background.show then
    local back = CreateFrame("Frame", nil, b, BackdropTemplateMixin and "BackdropTemplate")
    back:SetPoint("TOPLEFT", b, "TOPLEFT", -uui.background.padding, uui.background.padding)
    back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", uui.background.padding, -uui.background.padding)
    back:SetFrameLevel(b:GetFrameLevel() - 1)
    back:SetBackdrop(backdrop)
    back:SetBackdropBorderColor(backgroundcolor.r, backgroundcolor.g, backgroundcolor.b, backgroundcolor.a)
    b.bg = back
  end

  -- Set button styled variable
  b.styled = true
end

-- Update debuff anchors
local function updateDebuffAnchors(buttonName,index)
  local button = _G[buttonName..index]
  if not button then return end
  -- Apply skin
  if not button.styled then applySkin(button) end
  -- Position button
  button:ClearAllPoints()
  if index == 1 then
    -- Debuffs and buffs are not combined anchor the debuffs to its own frame
    button:SetPoint("TOPRIGHT", rBFS_DebuffDragFrame, "TOPRIGHT", 0, 0)      
  elseif index > 1 and mod(index, uuidb.buffdebuff.debuff.buttonsperrow) == 1 then
    button:SetPoint("TOPRIGHT", _G[buttonName..(index-uuidb.buffdebuff.debuff.buttonsperrow)], "BOTTOMRIGHT", 0, -uuidb.buffdebuff.debuff.rowspacing)
  else
    button:SetPoint("TOPRIGHT", _G[buttonName..(index-1)], "TOPLEFT", -uuidb.buffdebuff.debuff.colspacing, 0)
  end
end

-- Update buff anchors
local function updateAllBuffAnchors()
  -- Variables
  local buttonName  = "BuffButton"
  local numEnchants = BuffFrame.numEnchants
  local numBuffs    = BUFF_ACTUAL_DISPLAY
  local currentPos = {rBFS_DebuffDragFrame:GetPoint()}
  local offset      = numEnchants
  local realIndex, previousButton, aboveButton

  -- Calculate the previous button in case tempenchant or consolidated buff are loaded
  if BuffFrame.numEnchants > 0 then
    previousButton = _G["TempEnchant"..numEnchants]
  end

  -- Calculate the above button in case tempenchant or consolidated buff are loaded
  if numEnchants > 0 then
    aboveButton = TempEnchant1
  end

  -- Loop on all active buff buttons
  local buffCounter = 0
  for index = 1, numBuffs do
    local button = _G[buttonName..index]
    if not button then return end
    if not button.consolidated then
      buffCounter = buffCounter + 1
      -- Apply skin
      if not button.styled then applySkin(button) end
      -- Position button
      button:ClearAllPoints()
      realIndex = buffCounter+offset
      if realIndex == 1 then
        button:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0)
        aboveButton = button
      elseif realIndex > 1 and mod(realIndex, uuidb.buffdebuff.buff.buttonsperrow) == 1 then
        button:SetPoint("TOPRIGHT", aboveButton, "BOTTOMRIGHT", 0, -uuidb.buffdebuff.buff.rowspacing)
        aboveButton = button
      else
        button:SetPoint("TOPRIGHT", previousButton, "TOPLEFT", -uuidb.buffdebuff.buff.colspacing, 0)
      end
      previousButton = button
    end
  end
  -- Calculate the height of the buff rows for the debuff frame calculation later
  local rows = ceil((buffCounter+offset)/uuidb.buffdebuff.buff.buttonsperrow)
  local height = uuidb.buffdebuff.buff.button.size*rows + uuidb.buffdebuff.buff.rowspacing*rows + uuidb.buffdebuff.buff.gap*min(1,rows)
  buffFrameHeight = height
end

function buffs:ReworkAllColor()
  updateDebuffAnchors("DebuffButton", 1)
  updateAllBuffAnchors()
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateAllBuffAnchors)
  hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffAnchors)
end

function buffs:UpdateColors(color)
  if not (color) then
    color = uuidb.buffdebuff.buff.border.color
  end

  for i = 1, BUFF_ACTUAL_DISPLAY do
    _G["BuffButton"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
  end
end

UberUI.buffs = buffs
