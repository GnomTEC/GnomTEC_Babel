-- **********************************************************************
-- GnomTEC Babel
-- Version: 0.5
-- Author: Lugus Sprengfix
-- Copyright 2011-2012 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************
-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_Babel")

-- ----------------------------------------------------------------------
-- Legacy global variables and constants (will be deleted in future)
-- ----------------------------------------------------------------------

GnomTEC_Babel_Options = {
	["Enabled"] = true,
	["Language"] = GetDefaultLanguage(),
	["LanguageSelectorEnabled"] = true,
	
}

-- ----------------------------------------------------------------------
-- Addon global variables (local)
-- ----------------------------------------------------------------------

-- Main options menue with general addon information
local optionsMain = {
	name = "GnomTEC Babel",
	type = "group",
	args = {
		descriptionTitle = {
			order = 1,
			type = "description",
			name = L["L_OPTIONS_TITLE"],
		},
		babelOptionEnable = {
			type = "toggle",
			name = L["L_OPTIONS_ENABLE"],
			desc = "",
			set = function(info,val) GnomTEC_Babel_Options["Enable"] = val;  end,
			get = function(info) return GnomTEC_Babel_Options["Enable"] end,
			width = 'full',
			order = 2
		},
		babelOptionLanguageSelectorEnable = {
			type = "toggle",
			name = L["L_OPTIONS_BUTTON"],
			desc = "",
			set = function(info,val) GnomTEC_Babel_Options["LanguageSelectorEnabled"] = val; if (GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then GNOMTEC_BABEL_FRAME:Show(); else GNOMTEC_BABEL_FRAME:Hide(); end;  end,
			get = function(info) return GnomTEC_Babel_Options["LanguageSelectorEnabled"] end,
			width = 'full',
			order = 3
		},
		descriptionAbout = {
			name = "About",
			type = "group",
			guiInline = true,
			order = 4,
			args = {
				descriptionVersion = {
				order = 1,
				type = "description",			
				name = "|cffffd700".."Version"..": ".._G["GREEN_FONT_COLOR_CODE"]..GetAddOnMetadata("GnomTEC_Babel", "Version"),
				},
				descriptionAuthor = {
					order = 2,
					type = "description",
					name = "|cffffd700".."Autor"..": ".."|cffff8c00".."Lugus Sprengfix",
				},
				descriptionEmail = {
					order = 3,
					type = "description",
					name = "|cffffd700".."Email"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."info@gnomtec.de",
				},
				descriptionWebsite = {
					order = 4,
					type = "description",
					name = "|cffffd700".."Website"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."http://www.gnomtec.de/",
				},
				descriptionLicense = {
					order = 5,
					type = "description",
					name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."(c)2011 by GnomTEC",
				},
			}
		},
		descriptionLogo = {
			order = 5,
			type = "description",
			name = "",
			image = "Interface\\AddOns\\GnomTEC_Babel\\Textures\\GnomTEC-Logo",
			imageCoords = {0.0,1.0,0.0,1.0},
			imageWidth = 512,
			imageHeight = 128,
		},
	}
}
	
-- ----------------------------------------------------------------------
-- Startup initialization
-- ----------------------------------------------------------------------

GnomTEC_Babel = LibStub("AceAddon-3.0"):NewAddon("GnomTEC_Babel", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Babel Main", optionsMain)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Babel Main", "GnomTEC Babel");

-- ----------------------------------------------------------------------
-- Local functions
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Frame event handler and functions
-- ----------------------------------------------------------------------
function GnomTEC_Babel:ChangeLanguage()
	if (GetNumLanguages() > 1) then	
		 if (GetLanguageByIndex(1) == GnomTEC_Babel_Options["Language"]) then
		 	GnomTEC_Babel_Options["Language"] = GetLanguageByIndex(2)
		 else
		 	GnomTEC_Babel_Options["Language"] = GetLanguageByIndex(1)
		 end
	 	GNOMTEC_BABEL_FRAME_LANGUAGE:SetText(GnomTEC_Babel_Options["Language"])
 	end	
end

-- ----------------------------------------------------------------------
-- Hook functions
-- ----------------------------------------------------------------------
function GnomTEC_Babel:Translate(msg, chatType, language, channel)	
	if ((chatType == "SAY") or (chatType == "YELL")) then
		if (GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then
			language = GnomTEC_Babel_Options["Language"]
		end
		if (GnomTEC_Babel_Options["Enable"]) then
			if ((not language) or (language == GetLanguageByIndex(1))) then
				self.hooks.SendChatMessage(msg,chatType,language, channel)
			else
				self.hooks.SendChatMessage("["..language.."] "..msg,chatType,nil, channel)
			end
		else
			self.hooks.SendChatMessage(msg,chatType,language, channel)
		end
	else
		self.hooks.SendChatMessage(msg,chatType,language, channel)
	end
end

-- ----------------------------------------------------------------------
-- Event handler
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Addon OnInitialize, OnEnable and OnDisable
-- ----------------------------------------------------------------------

function GnomTEC_Babel:OnInitialize()
 	-- Code that you want to run when the addon is first loaded goes here.
  
  	GnomTEC_Babel:Print(L["L_WELCOME"])
  	  	
end

function GnomTEC_Babel:OnEnable()
    -- Called when the addon is enabled

	GnomTEC_Babel:Print("GnomTEC_Babel Enabled")
	self:RawHook("SendChatMessage","Translate",true)

	-- Initialize options which are propably not valid because they are new added in new versions of addon
	if (nil == GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then
		GnomTEC_Babel_Options["LanguageSelectorEnabled"] = GnomTEC_Babel_Options["Enabled"]
	end
	
	-- Show GUI
	if (GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then
		GNOMTEC_BABEL_FRAME:Show()
	end
end

function GnomTEC_Babel:OnDisable()
    -- Called when the addon is disabled
    
    GnomTEC_Babel:UnregisterAllEvents();
	GNOMTEC_BABEL_FRAME:Hide()

end

-- ----------------------------------------------------------------------
-- External API
-- ----------------------------------------------------------------------

