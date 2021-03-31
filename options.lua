--[[--------------------------------------------------------------------
	Uber UI
	Darkens default UI
	Maintained by Uberlicious
----------------------------------------------------------------------]]

local addon, ns = ...
uuiopt = {}

local SOUND_OFF = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
local SOUND_ON = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON

local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

local Options = CreateFrame("Frame", "UberUI-Options", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(addon, "Title") or addon
InterfaceOptions_AddCategory(Options)

function uuiopt:ShowOptions()
	InterfaceOptionsFrame_OpenToCategory(Options)
end

Options:Hide()
Options:SetScript("OnShow", function(self)
	local Title = self:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalHuge")
	Title:SetPoint("TOPLEFT", 16, -16)
	Title:SetText(self.name)

	local SubText = self:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
	SubText:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 0, -8)
	SubText:SetPoint("RIGHT", -32, 0)
	SubText:SetHeight(32)
	SubText:SetJustifyH("LEFT")
	SubText:SetJustifyV("TOP")
	SubText:SetText("Darkens and modifies the default blizzard UI.")

	local GeneralCat = self:CreateFontString("$parentGeneralCat", "ARTWORK", "GameFontNormalLarge")
	GeneralCat:SetPoint("TOPLEFT", SubText, "BOTTOMLEFT", 0, -8)
	GeneralCat:SetPoint("RIGHT", -32, 0)
	GeneralCat:SetHeight(32)
	GeneralCat:SetJustifyH("LEFT")
	GeneralCat:SetJustifyV("TOP")
	GeneralCat:SetText("General")

	local Reload = CreateFrame("Button", "$parentReload" , self, "UIPanelButtonTemplate")
	Reload:SetPoint("TOPRIGHT", InterfaceOptionsFrameCancel, "TOPRIGHT", -15, 50)
	Reload:SetWidth(100)
	Reload:SetHeight(25)
	Reload:SetText("Save & Reload")

	Reload:SetScript(
		"OnClick",
		function(self, button, down)
			Options:Hide()
			ReloadUI()
		end
	)

	local function ColorPicker(r,g,b,a,callback)
		ColorPickerFrame:SetColorRGB(r,g,b)
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = true, 1
		ColorPickerFrame.previousValues = {r,g,b,a}
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = callback, callback, callback
		ColorPickerFrame:Hide() -- Need to run the OnShow handler.
		ColorPickerFrame:Show()
	end

	local Gryphon = CreateFrame("CheckButton", "$parentGryphon", self, "InterfaceOptionsCheckButtonTemplate")
	Gryphon:SetPoint("TOPLEFT", GeneralCat, "BOTTOMLEFT", 0, 2)
	Gryphon.Text:SetText("Show Gryphons")
	Gryphon.tooltipText = "Shows the gryphons on the sides of actionbars."
	Gryphon:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.mainmenu.gryphon = checked
		if uuidb.general.customcolor or uuidb.general.classcolorframes then
			UberUI.general:Gryphons(uuidb.general.customcolorval)
		else
			UberUI.general:Gryphons()
		end
	end)

	local MicroButtonBagBar = CreateFrame("CheckButton", "$parentMicroButtonBagBar", self, "InterfaceOptionsCheckButtonTemplate")
	MicroButtonBagBar:SetPoint("LEFT", Gryphon, "RIGHT", 200, 0)
	MicroButtonBagBar.Text:SetText("MicroButtonBagBar")
	MicroButtonBagBar.tooltipText = "Enable / Disable the Bag Bar Menu in the lower right corner."
	MicroButtonBagBar:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.mainmenu.microbuttonbar = checked
		UberUI.general.MicroBar()
	end)

	local ABCat = self:CreateFontString("$parentABCat", "ARTWORK", "GameFontNormalLarge")
	ABCat:SetPoint("TOPLEFT", GeneralCat, "BOTTOMLEFT", 0, -36)
	ABCat:SetPoint("RIGHT", -32, 0)
	ABCat:SetHeight(32)
	ABCat:SetJustifyH("LEFT")
	ABCat:SetJustifyV("TOP")
	ABCat:SetText("Actionbars")

	local Hotkey = CreateFrame("CheckButton", "$parentHotkey", self, "InterfaceOptionsCheckButtonTemplate")
	Hotkey:SetPoint("TOPLEFT", ABCat, "BOTTOMLEFT", 0, 2)
	Hotkey.Text:SetText("Show Hotkeys")
	Hotkey.tooltipText = "Shows the Hotkeys on the actionbar buttons."
	Hotkey:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.actionbars.hotkeys.show = checked
		UberUI.actionbars:Hotkeys()
	end)

	local Macroname = CreateFrame("CheckButton", "$parentMacroname", self, "InterfaceOptionsCheckButtonTemplate")
	Macroname:SetPoint("LEFT", Hotkey, "RIGHT", 200, 0)
	Macroname.Text:SetText("Show Macronames")
	Macroname.tooltipText = "Shows the Macronames on the actionbar buttons."
	Macroname:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.actionbars.macroname.show = checked
		UberUI.actionbars:Macroname()
	end)

	local Gloss = CreateFrame("CheckButton", "$parentGloss", self, "InterfaceOptionsCheckButtonTemplate")
	Gloss:SetPoint("LEFT", Macroname, "RIGHT", 200, 0)
	Gloss.Text:SetText("Glossy buttons")
	Gloss.tooltipText = "Shows the Glosss on the actionbar buttons."
	Gloss:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.actionbars.gloss = checked
	end)

	local UnitFrames = self:CreateFontString("$parentUnitFrames", "ARTWORK", "GameFontNormalLarge")
	UnitFrames:SetPoint("TOPLEFT", ABCat, "BOTTOMLEFT", 0, -36)
	UnitFrames:SetPoint("RIGHT", -32, 0)
	UnitFrames:SetHeight(32)
	UnitFrames:SetJustifyH("LEFT")
	UnitFrames:SetJustifyV("TOP")
	UnitFrames:SetText("Unit Frames")

	local BigFrames = CreateFrame("CheckButton", "$parentBigFrames", self, "InterfaceOptionsCheckButtonTemplate")
	BigFrames:SetPoint("TOPLEFT", UnitFrames, "BOTTOMLEFT", 0, 2)
	BigFrames.Text:SetText("Big Player / Target Frame")
	BigFrames.tooltipText = "Makes UI Health Bars Larger"
	BigFrames:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.playerframe.scaleframe = checked
		if checked then
			uuidb.playerframe.scale = 1.2
			uuidb.targetframe.scale = 1.2
			UberUI.playerframes:Scale(1.2)
			UberUI.targetframes:Scale(1.2)
		else
			uuidb.playerframe.scale = 1
			uuidb.targetframe.scale = 1
			UberUI.playerframes:Scale(1)
			UberUI.targetframes:Scale(1)
		end
	end)

	local ColorTarget = CreateFrame("frame", "$parentColorTarget", self, "UIDropDownMenuTemplate")
	ColorTarget:SetPoint("LEFT", BigFrames, "RIGHT", 180, 0)
	ColorTarget.text = ColorTarget:CreateFontString(nil, nil, "GameFontHighlight")
	ColorTarget.text:SetPoint("LEFT", ColorTarget, "RIGHT", -15, 24)
	ColorTarget.text:SetText("Color Target Frames")
	function ColorTarget:SetValue(value)
		local color = value
		uuidb.targetframe.colortargett = color
		UIDropDownMenu_SetText(ColorTarget, uuidb.targetframe.colortargett)
	end
	UIDropDownMenu_SetText(ColorTarget, uuidb.targetframe.colortargett)
	UIDropDownMenu_Initialize(ColorTarget, function(self,color)
		local info = UIDropDownMenu_CreateInfo()
		info.func = self.SetValue
		info.text, info.arg1 = "None", "None"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "All", "All"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Class", "Class"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Rare/Elite", "Rare/Elite"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Friendly/Hostile", "Friendly/Hostile"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Class/Friendly/Hostile", "Class/Friendly/Hostile"
		UIDropDownMenu_AddButton(info)
	end)

	--Bar Texture Option
	local BarTextures = CreateFrame("frame", "$parentBarTextures", self, "UIDropDownMenuTemplate")
	BarTextures:SetPoint("LEFT", ColorTarget, "RIGHT", 180, 0)
	BarTextures.text = BarTextures:CreateFontString(nil, nil, "GameFontHighlight")
	BarTextures.text:SetPoint("LEFT", BarTextures, "RIGHT", -15, 24)
	BarTextures.text:SetText("Bar Textures")
	function BarTextures:SetValue(value)
		local texture = value
		uuidb.general.bartexture = texture
		UIDropDownMenu_SetText(BarTextures, uuidb.general.bartexture)
		UberUI.general:BarTexture(texture)
	end
	UIDropDownMenu_SetText(BarTextures, uuidb.general.bartexture)
	UIDropDownMenu_Initialize(BarTextures, function(self,tex)
		local info = UIDropDownMenu_CreateInfo()
		info.func = self.SetValue
		info.text, info.arg1 = "Blizzard", "Blizzard"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Minimalist", "Minimalist"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Ace", "Ace"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Aluminum", "Aluminum"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Banto", "Banto"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Charcoal", "Charcoal"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Glaze", "Glaze"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Litestep", "Litestep"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Otravi", "Otravi"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Perl", "Perl"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Smooth", "Smooth"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Striped", "Striped"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Swag", "Swag"
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1 = "Flat", "Flat"
		UIDropDownMenu_AddButton(info)
	end)

	local ClassColorHealth = CreateFrame("CheckButton", "$parentClassColorHealth", self, "InterfaceOptionsCheckButtonTemplate")
	ClassColorHealth:SetPoint("TOPLEFT", BigFrames, "BOTTOMLEFT", 0, -12)
	ClassColorHealth.Text:SetText("Class Color Unit Health")
	ClassColorHealth.tooltipText = "Changes Frame Health to units class color. (disable requires reload)"
	ClassColorHealth:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.general.classcolorhealth = checked
		if uuidb.general.classcolorhealth then
			DEFAULT_CHAT_FRAME:AddMessage("Class Colors Enabled", 0, 1, 0)
			UberUI.general:HealthColor()
		else
			DEFAULT_CHAT_FRAME:AddMessage("Class Colors Disabled", 1, 0, 0)
			UberUI.general:HealthColorDisable()
		end
	end)

	local ClassColorFrames = CreateFrame("CheckButton", "$parentClassColorFrames", self, "InterfaceOptionsCheckButtonTemplate")
	ClassColorFrames:SetPoint("LEFT", ClassColorHealth, "RIGHT", 200, 0)
	ClassColorFrames.Text:SetText("Class Color Unitframes")
	ClassColorFrames.tooltipText = "Changes UI from dark to your class color. (requires reload)"
	ClassColorFrames:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.general.classcolorframes = checked
		uuidb.general.customcolor = false
		uuidb.general.customcolorval = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
		uuidb.actionbars.overridecol = true
		UberUI.general:ReworkColors(uuidb.general.customcolorval)
	end)

	--Color Picker Option
	local colpick = uuidb.general.customcolorval
	local CustomColor = CreateFrame("Frame", "$parentCustomColor", self)
	CustomColor:SetPoint("LEFT", ClassColorFrames, "RIGHT", 310, 0)
	CustomColor:SetSize(16,16)
	CustomColor.icon = CustomColor:CreateTexture(nil,"OVERLAY",nil,-7)
	CustomColor.icon:SetAllPoints(CustomColor)
	CustomColor.icon:SetTexture("Interface\\AddOns\\Uber UI\\textures\\statusbars\\smooth")
	CustomColor.icon:SetVertexColor(colpick.r,colpick.g,colpick.b)
	CustomColor.text = CustomColor:CreateFontString(nil, nil, "GameFontHighlight")
	CustomColor.text:SetPoint("RIGHT", CustomColor, "LEFT", -2, 0)
	CustomColor.text:SetText("Custom Color")
	CustomColor.recolorTexture = function(color)
			if uuidb.general.customcolor == true then
				local nr,ng,nb,na
				if color then
					uuidb.general.classcolorframes = false
				else
					nr,ng,nb = ColorPickerFrame:GetColorRGB()
					a = OpacitySliderFrame:GetValue()
				end
				uuidb.general.customcolorval = {r = nr, g = ng, b = nb, a = na}
				UberUI.general:ReworkColors(uuidb.general.customcolorval)
			end
		end
	CustomColor:EnableMouse(true)
	CustomColor:SetScript("OnMouseDown", function(this,button,...)
		if button == "LeftButton" then
			local r,g,b,a = colpick
			ColorPicker(colpick.r,colpick.g,colpick.b,1,CustomColor.recolorTexture)
		end
	end)
	CustomColor:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("Select custom color. Note: MUST RELOAD AFTER PICKING COLOR!")
		GameTooltip:Show()
	end)
	CustomColor:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	local CustomColorCheck = CreateFrame("CheckButton", "$parentCustomColorCheck", self, "InterfaceOptionsCheckButtonTemplate")
	CustomColorCheck:SetPoint("RIGHT", CustomColor, "LEFT", -84, 0)
	CustomColorCheck.tooltipText = "Check to set custom color"
	CustomColorCheck:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.general.customcolor = checked
		uuidb.general.classcolorframes = false
		UberUI.general:ReworkColors(uuidb.general.customcolorval)
	end)

	local LargeHealth = CreateFrame("CheckButton", "$parentLargeHealth", self, "InterfaceOptionsCheckButtonTemplate")
	LargeHealth:SetPoint("TOPLEFT", ClassColorHealth, "BOTTOMLEFT", 0, -12)
	LargeHealth.Text:SetText("Enlarge Health Bars")
	LargeHealth.tooltipText = "Makes UI Health Bars Larger (Requires Reload)"
	LargeHealth:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.playerframe.largehealth = checked
		uuidb.targetframe.largehealth = checked
		UberUI.general:ColorAllFrames()
	end)
	
	local TargetName = CreateFrame("CheckButton", "$parentTargetName", self, "InterfaceOptionsCheckButtonTemplate")
	TargetName:SetPoint("LEFT", LargeHealth, "RIGHT", 200, 0)
	TargetName.Text:SetText("Toggle Target Name")
	TargetName.tooltipText = "Toggles showing of target name."
	TargetName:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.targetframe.name = checked
		UberUI.targetframes.Name()
	end)


	local Pvpicons = CreateFrame("CheckButton", "$parentPvpicons", self, "InterfaceOptionsCheckButtonTemplate")
	Pvpicons:SetPoint("LEFT", TargetName, "RIGHT", 200, 0)
	Pvpicons.Text:SetText("Toggle PVP Icons")
	Pvpicons.tooltipText = "Toggles showing of the Player / Target PVP icons. (will not be colored)"
	Pvpicons:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.miscframes.pvpicons = checked
		UberUI.misc:pvpicons()
	end)

	local ArenaFrameCol = CreateFrame("CheckButton", "$parentArenaFrameCol", self, "InterfaceOptionsCheckButtonTemplate")
	ArenaFrameCol:SetPoint("TOPLEFT", LargeHealth, "BOTTOMLEFT", 0, -12)
	ArenaFrameCol.Text:SetText("Colors Arena Frames")
	ArenaFrameCol.tooltipText = "Colors arena frames by class."
	ArenaFrameCol:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.general.colorarenat = checked
	end)

	local TexRaid = CreateFrame("CheckButton", "$parentTexRaid", self, "InterfaceOptionsCheckButtonTemplate")
	TexRaid:SetPoint("LEFT", ArenaFrameCol, "RIGHT", 200, 0)
	TexRaid.Text:SetText("Texture Raid Frames")
	TexRaid.tooltipText = "Toggles the texturing of raid frames"
	TexRaid:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.miscframes.texraidframes = checked
		RaidColor()
	end)

	local TargetNameInside = CreateFrame("CheckButton", "$parentTargetNameInside", self, "InterfaceOptionsCheckButtonTemplate")
	TargetNameInside:SetPoint("LEFT", TexRaid, "RIGHT", 200, 0)
	TargetNameInside.Text:SetText("Target Name Inside")
	TargetNameInside.tooltipText = "Toggles the target name above the frame or not for large frames"
	TargetNameInside:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.targetframe.nameinside = checked
		UberUI.general:ColorAllFrames()
	end)

	local FocusNameInside = CreateFrame("CheckButton", "$parentFocusNameInside", self, "InterfaceOptionsCheckButtonTemplate")
	FocusNameInside:SetPoint("TOPLEFT", ArenaFrameCol, "BOTTOMLEFT", 0, -12)
	FocusNameInside.Text:SetText("Focus Name Inside")
	FocusNameInside.tooltipText = "Toggles the focus frame name above the frame or not for large frames"
	FocusNameInside:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.focusframe.nameinside = checked
		UberUI.misc:FocusName()
	end)

	local ColorDragonSeparate = CreateFrame("CheckButton", "$parentColorDragonSeparate", self, "InterfaceOptionsCheckButtonTemplate")
	ColorDragonSeparate:SetPoint("LEFT", FocusNameInside, "RIGHT", 200, 0)
	ColorDragonSeparate.Text:SetText("Color Dragons Separate")
	ColorDragonSeparate.tooltipText = "Selecting this option will color the dragons on target frame separate from the frame color"
	ColorDragonSeparate:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.targetframe.colordragon = checked
		UberUI.general:ReworkColors(uuidb.general.customcolorval)
	end)

	local BlizzardArenaFrames = CreateFrame("CheckButton", "$parentBlizzardArenaFrames", self, "InterfaceOptionsCheckButtonTemplate")
	BlizzardArenaFrames:SetPoint("LEFT", ColorDragonSeparate, "RIGHT", 200, 0)
	BlizzardArenaFrames.Text:SetText("Hide Arena Frames")
	BlizzardArenaFrames.tooltipText = "Selecting this option will hide the default blizzard arena frames"
	BlizzardArenaFrames:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.miscframes.hidedefaultarena = checked
		UberUI.arenaframes:HideArena()
	end)

	local NameplateNum = CreateFrame("CheckButton", "$parentNameplateNum", self, "InterfaceOptionsCheckButtonTemplate")
	NameplateNum:SetPoint("TOPLEFT", FocusNameInside, "BOTTOMLEFT", 0, -12)
	NameplateNum.Text:SetText("Nameplate Numbers")
	NameplateNum.tooltipText = "Selecting this will change nameplate in arenas to show target number instead of name"
	NameplateNum:SetScript("OnClick", function(this)
		local checked = not not this:GetChecked()
		PlaySound(checked and SOUND_ON or SOUND_OFF)
		uuidb.miscframes.nameplatenumbers = checked
		UberUI.arenaframes:NameplateNumbers()
	end)

	function self:refresh()
		Gryphon:SetChecked(uuidb.mainmenu.gryphon)
		Hotkey:SetChecked(uuidb.actionbars.hotkeys.show)
		Macroname:SetChecked(uuidb.actionbars.macroname.show)
		Gloss:SetChecked(uuidb.actionbars.gloss)
		LargeHealth:SetChecked(uuidb.playerframe.largehealth)
		ClassColorFrames:SetChecked(uuidb.general.classcolorframes)
		ClassColorHealth:SetChecked(uuidb.general.classcolorhealth)
		BigFrames:SetChecked(uuidb.playerframe.scaleframe)
		MicroButtonBagBar:SetChecked(uuidb.mainmenu.microbuttonbar)
		Pvpicons:SetChecked(uuidb.miscframes.pvpicons)
		TargetName:SetChecked(uuidb.targetframe.name)
		ArenaFrameCol:SetChecked(uuidb.general.colorarenat)
		CustomColorCheck:SetChecked(uuidb.general.customcolor)
		TexRaid:SetChecked(uuidb.miscframes.texraidframes)
		TargetNameInside:SetChecked(uuidb.targetframe.nameinside)
		FocusNameInside:SetChecked(uuidb.focusframe.nameinside)
		ColorDragonSeparate:SetChecked(uuidb.targetframe.colordragon)
		BlizzardArenaFrames:SetChecked(uuidb.miscframes.hidedefaultarena)
		NameplateNum:SetChecked(uuidb.miscframes.nameplatenumbers)
	end

	self:refresh()
	self:SetScript("OnShow", nil)
end)
