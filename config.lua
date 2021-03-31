
-- // Uber UI
-- // Uberlicious - 2018

-----------------------------
-- INIT
-----------------------------

--get the addon namespace
local addon, ns = ...
UberUI = {}
uuidb = {}

local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
-----------------------------
-- DEFAULTS
-----------------------------

--generate a holder for the config data
local UberUI = CreateFrame("Frame")
UberUI:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
UberUI:RegisterEvent("ADDON_LOADED")
UberUI:RegisterEvent("PLAYER_LOGIN")
UberUI:RegisterEvent("PLAYER_LOGOUT")

local defaults = {
  textures = {
    buttons = {
      normal            = "Interface\\AddOns\\Uber UI Classic\\textures\\gloss",
      light             = "Interface\\AddOns\\Uber UI Classic\\textures\\glosslight",
      flash             = "Interface\\AddOns\\Uber UI Classic\\textures\\flash",
      hover             = "Interface\\AddOns\\Uber UI Classic\\textures\\hover",
      pushed            = "Interface\\AddOns\\Uber UI Classic\\textures\\pushed",
      checked           = "Interface\\AddOns\\Uber UI Classic\\textures\\checked",
      equipped          = "Interface\\AddOns\\Uber UI Classic\\textures\\gloss_grey",
      inverse           = "Interface\\AddOns\\Uber UI Classic\\textures\\button_backgroundinverse",
      buttonback        = "Interface\\AddOns\\Uber UI Classic\\textures\\button_backgroundlight",
      buttonbackflat    = "Interface\\AddOns\\Uber UI Classic\\textures\\button_background_flat",
      outer_shadow      = "Interface\\AddOns\\Uber UI Classic\\textures\\outer_shadow_bold",
    },
    statusbars = {
      Minimalist        = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\Minimalist",
      Ace               = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\Ace",
      Aluminum          = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\Aluminum",
      Banto             = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\banto",
      Blizzard          = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\blizzard",
      Charcoal          = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\Charcoal",
      Glaze             = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\glaze",
      Litestep          = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\LiteStep",
      Otravi            = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\otravi",
      Perl              = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\perl",
      Smooth            = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\smooth",
      Striped           = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\striped",
      Swag              = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\swag",
      Flat              = "Interface\\AddOns\\Uber UI Classic\\textures\\statusbars\\flat",
    },
    targetframebig = {
      targetingframe    = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\targetingframebig",
      minus             = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\minusbig",
      minusflash        = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\minusbigflash",
      elite             = "Interface\\Addons\\Uber UI Classic\\textures\\target\\elitebig",
      rareelite         = "Interface\\Addons\\Uber UI Classic\\textures\\target\\rare-elitebig",
      rare              = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\rarebig",
    },
    targetframe = {
      targetingframe    = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\targetingframe",
      minus             = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\minus",
      elite             = "Interface\\Addons\\Uber UI Classic\\textures\\target\\elite",
      rareelite         = "Interface\\Addons\\Uber UI Classic\\textures\\target\\rare-elite",
      rare              = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\rare",
    },
    other = {
      smalltarget       = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\smalltargetingframe",
      party             = "Interface\\AddOns\\Uber UI Classic\\textures\\partyframe",
      tot               = "Interface\\AddOns\\Uber UI Classic\\textures\\target\\targetoftargetframe",
      pvphorde          = "Interface\\AddOns\\Uber UI Classic\\textures\\pvp-horde",
      pvpally           = "Interface\\AddOns\\Uber UI Classic\\textures\\pvp-alliance",
      clockbutton       = "Interface\\AddOns\\Uber UI Classic\\textures\\clockbackground",
      prestige          = "Interface\\AddOns\\Uber UI Classic\\textures\\PvPPrestigeIconsborder",
    },
  },
  general = {
    classcolorhealth  = true,
    classcolorframes  = false,
    customcolor       = false,
    colorarenat       = true,
    customcolorval    = RAID_CLASS_COLORS[select(2, UnitClass("player"))],
    font              = STANDARD_TEXT_FONT,
    bartexture        = "Flat",
    forcemanabar      = false,
  },
  mainmenu = {
    gryphon           = true,
    microbuttonbar    = true,
    mainbarcolor      = {r = .1, g = .1, b =.1, a = 1},
    gryphcolor        = {r = .15, g = .15, b = .15, a = 1}
  },
  playerframe = {
    largehealth       = true,
    scaleframe        = true,
    scale             = 1.2,
    color             = {r = .05, g = .05, b =.05, a = 1},
    name              = false
  },
  targetframe = {
    largehealth       = true,
    scaleframe        = true,
    scale             = 1.2,
    color             = {r = .05, g = .05, b =.05, a = 1},
    name              = true,
    nameinside        = false,
    colortargett      = false,
    colorfocust       = false,
    colortott         = false,
    colordragon       = true,
  },
  focusframe = {
    nameinside        = true,
  },
  minimap = {
    color             = {r = .05, g = .05, b =.05, a = 1},
    texture           = "Interface\\AddOns\\Uber UI Classic\\textures\\minimap-border"
  },
  buffdebuff = {
    oneletterabbrev   = true,
    tooltipscale      = 1.2,
    buffsanddebuffs   = false,
    buff = {
      pos               = {a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 },
      gap               = 30,
      locked            = true,
      rowspacing        = 10,
      colspacing        = 7,
      buttonsperrow     = 10,
      button = {
        size            = 30,
      },
      icon = {
        padding         = -2,
      },
      border = {
        texture         = "Interface\\AddOns\\Uber UI Classic\\textures\\gloss",
        color           = {r = 0, g = 0, b = 0, a = .9},
      },
      background = {
        show            = true,
        edgefile        = "Interface\\AddOns\\Uber UI Classic\\textures\\outer_shadow",
        color           = {r = 0, g = 0, b = 0, a = .9},
        inset           = 6,
        padding         = 4,
      },
      duration = {
        font            = STANDARD_TEXT_FONT,
        size            = 11,
        pos             = {a1 = "BOTTOM", x = 0, y = 0}
      },
      count = {
        font            = STANDARD_TEXT_FONT,
        size            = 11,
        pos             = {a1 = "TOPRIGHT", x = 0, y = 0}
      },
    },
    debuff = {
      pos               = {a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = -120 },
      gap               = 30,
      locked            = true,
      rowspacing        = 10,
      colspacing        = 7,
      buttonsperrow     = 10,
      button = {
        size            = 30,
      },
      icon = {
        padding         = -2,
      },
      border = {
        texture         = "Interface\\AddOns\\Uber UI Classic\\textures\\gloss",
        color           = {r = 0, g = 0, b = 0, a = .9},
      },
      background = {
        show            = true,
        edgefile        = "Interface\\AddOns\\Uber UI Classic\\textures\\outer_shadow",
        color           = {r = 0, g = 0, b = 0, a = .9},
        inset           = 6,
        padding         = 4,
      },
      duration = {
        font            = STANDARD_TEXT_FONT,
        size            = 11,
        pos             = {a1 = "BOTTOM", x = 0, y = 0}
      },
      count = {
        font            = STANDARD_TEXT_FONT,
        size            = 11,
        pos             = {a1 = "TOPRIGHT", x = 0, y = 0}
      },
    },
  },
  auras = {
    edgefile            = "Interface\\AddOns\\Uber UI Classic\\textures\\outer_shadow",
    tile                = false,
    tilesize            = 32,
    edgesize            = 2,
    insets              = {l = 4, r = 4, t = 4, b = 4},
    color               = {r = 0, g = 0, b = 0, a = .9},
  },
  actionbars = {
    showbg              = true,
    showshadow          = true,
    useflatbackground   = false,
    gloss               = false,
    backgroundcolor     = {r = .2, g = .2, b = .2, a = .3},
    shadowcolor         = {r = 0, g = 0, b = 0, a = .9},
    bagiconcolor        = {r = 0.4, g = 0.35, b = 0.35, a = 1},
    inset               = 5,
    overridecol         = false,
    color = {
      normal            = {r = .3, g = .3, b = .3, a = 1},
      equipped          = {r = .1, g = .5, b = .1, a = .9},
    },
    hotkeys = {
      show              = true,
      fontsize          = 12,
      pos1              = {a1 = "TOPRIGHT", x = 0, y = 0},
      pos2              = {a1 = "TOPLEFT", x = 0, y = 0},
    },
    macroname = {
      show              = true,
      fontsize          = 12,
      pos1              = {a1 = "BOTTOMLEFT", x = 0, y = 0},
      pos2              = {a1 = "BOTTOMRIGHT", x = 0, y = 0},
    },
    count = {
      show              = true,
      fontsize          = 12,
      pos               = {a1 = "BOTTOMRIGHT", x = 0, y = 0},
    },
    cooldown = {
      spacing           = 0,
    }
  },
  miscframes = {
    partycolort         = false,
    raidgroupcolor      = true,
    raidsinglecolor     = true,
    pvpicons            = false,
    texraidframes       = true,
    hidedefaultarena    = false,
    nameplatenumbers    = false,
    arenaframescolor    = {r = .05, g = .05, b = .05, a = 1},
    misccolor           = {r = .05, g = .05, b = .05, a = 1},
  },
}

function UberUI:ADDON_LOADED()
   local function initDB(def, tbl, saved)
      if type(def) ~= "table" then return {} end
      if type(tbl) ~= "table" then tbl = {} end
      if type(saved) ~= "table" then saved = {} end
      for k,v in pairs(def) do
         if type(v) == "table" then
            tbl[k] = initDB(v, tbl[k], saved[k])
         elseif type(tbl[k]) ~= "table" and saved[k] ~= nil then -- If saved value exists use it
            tbl[k] = saved[k]
         elseif type(tbl[k]) ~= "table" and saved[k] == nil then -- If saved value does not exist use default
            tbl[k] = v
         end
      end
      return tbl
   end
   uuidb = initDB(defaults, uuidb, UberuiDB)
   --self:UnregisterEvent("ADDON_LOADED")
end

function UberUI:PLAYER_LOGOUT()
  local function updateSave(def, tbl, saved)
    if type(def) ~= "table" then return {} end
    if type(tbl) ~= "table" then tbl = {} end
    if type(saved) ~= "table" then saved = {} end
    for k,v in pairs(tbl) do
      if type(v) == "table" then
        saved[k] = updateSave(def[k], v, saved[k])
      elseif type(saved[k]) ~= "table" and v ~= def[k] then -- If temp value does not equal the default, save it
        saved[k] = v
      elseif type(saved[k]) ~= "table" and v == def[k] and saved[k] ~= def[k] then -- Unset saved value if temp == default and saved value exists
        saved[k] = nil
      elseif type(saved[k]) ~= "table" and saved[k] == def[k] then -- Cleanup if save value happens to == default
        saved[k] = nil
      end
    end
    return saved
  end
  UberuiDB = updateSave(defaults, uuidb, UberuiDB)

  local function cleanupSave(saved)
    for k,v in pairs(saved) do
      if type(v) == "table" and next(v) then
        cleanupSave(v)
      elseif type(v) == "table" and not next(v) then
       saved[k] = nil
      end
    end
    return saved
  end
  UberuiDB = cleanupSave(UberuiDB)
end

  -----------------------------
  -- SLASH COMMAND
  -----------------------------

SlashCmdList.UBERUI = function(msg)
    msg = msg:lower()
    if msg == "options" then
      uuiopt:ShowOptions()
    else
      InterfaceOptionsFrame_OpenToCategory(addon)
      InterfaceOptionsFrame_OpenToCategory(addon)
    end
end
SLASH_UBERUI1 = "/uui"
Slash_UBERUI2 = "/uberui"
