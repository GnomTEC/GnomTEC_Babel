-- **********************************************************************
-- GnomTEC Babel
-- Version: 5.3.0.7
-- Author: GnomTEC
-- Copyright 2011-2013 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************
-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_Babel")

-- ----------------------------------------------------------------------
-- Legacy global variables and constants (will be deleted in future)
-- ----------------------------------------------------------------------

GnomTEC_Babel_Options = {
	["Enabled"] = true,
	["LanguageID"] = select(2, GetLanguageByIndex(1)),
	["LanguageSelectorEnabled"] = true,
}

-- ----------------------------------------------------------------------
-- Addon global Constants (local)
-- ----------------------------------------------------------------------
-- Horde
local LANGUAGE_ORCISH					= 1
local LANGUAGE_TAURAHE 					= 3
local LANGUAGE_THALASSIAN				= 10
local LANGUAGE_ZANDALI					= 14
local LANGUAGE_FORSAKEN					= 33
local LANGUAGE_GOBLIN					= 40
local LANGUAGE_PANDAREN_HORDE			= 44
-- Alliance
local LANGUAGE_DARNASSIAN				= 2
local LANGUAGE_DWARVISH					= 6
local LANGUAGE_COMMON					= 7
local LANGUAGE_GNOMISH					= 13
local LANGUAGE_DRAENEI					= 35
local LANGUAGE_PANDAREN_ALLIANCE		= 43
-- Other
local LANGUAGE_Demonic					= 8

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
			set = function(info,val) GnomTEC_Babel_Options["Enabled"] = val;  end,
			get = function(info) return GnomTEC_Babel_Options["Enabled"] end,
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
					name = "|cffffd700".."Autor"..": ".."|cffff8c00".."GnomTEC",
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
					name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"].."(c)2011-2013 by GnomTEC",
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
function GnomTEC_Babel:SetLanguage(ID)
	local i = 1
	local languageName, languageID
	GnomTEC_Babel_Options["LanguageID"] = ID
	repeat
		languageName, languageID = GetLanguageByIndex(i)
		if (languageID == GnomTEC_Babel_Options["LanguageID"]) then
			i = 0
		else
			i = i + 1
		end
	until ((i < 1) or (i > GetNumLanguages()))
	if (i > 0) then
		-- we can not speak the given language so change to the first one
		languageName, GnomTEC_Babel_Options["LanguageID"] = GetLanguageByIndex(1)
	end
 	GNOMTEC_BABEL_FRAME_LANGUAGE:SetText(languageName or "")
 	return languageName
end


-- ----------------------------------------------------------------------
-- Frame event handler and functions
-- ----------------------------------------------------------------------
function GnomTEC_Babel:ChangeLanguage()
 	local i = 1
	local languageName, languageID
	repeat
		languageName, languageID = GetLanguageByIndex(i)
		if (languageID == GnomTEC_Babel_Options["LanguageID"]) then
			if (GetNumLanguages() > i) then
				languageName, GnomTEC_Babel_Options["LanguageID"] = GetLanguageByIndex(i+1)
			else
				languageName, GnomTEC_Babel_Options["LanguageID"] = GetLanguageByIndex(1)
			end
			i = 0
		else
			i = i + 1
		end
	until ((i < 1) or (i > GetNumLanguages()))
	if (i > 0) then
		-- we can not speak the given language so change to the first one
		languageName, GnomTEC_Babel_Options["LanguageID"] = GetLanguageByIndex(1)
	end
 	GNOMTEC_BABEL_FRAME_LANGUAGE:SetText(languageName or "")
end

-- ----------------------------------------------------------------------
-- Hook functions
-- ----------------------------------------------------------------------
function GnomTEC_Babel:Translate(msg, chatType, languageID, channel)	
	if ((chatType == "SAY") or (chatType == "YELL")) then
		if (GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then
			-- check if we know this language yet, when not will be reset to common
			GnomTEC_Babel:SetLanguage(GnomTEC_Babel_Options["LanguageID"])
			languageID = GnomTEC_Babel_Options["LanguageID"]
		end
		if (GnomTEC_Babel_Options["Enabled"]) then
			if ((not languageID) or (LANGUAGE_ORCISH == languageID) or (LANGUAGE_DARNASSIAN == languageID)) then
				self.hooks.SendChatMessage(msg,chatType,nil, channel)
			else
				self.hooks.SendChatMessage("["..GnomTEC_Babel:SetLanguage(languageID).."] "..msg,chatType,nil, channel)
			end
		else
			self.hooks.SendChatMessage(msg,chatType,languageID, channel)
		end
	else
		self.hooks.SendChatMessage(msg,chatType,languageID, channel)
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
	if (nil == GnomTEC_Babel_Options["LanguageID"]) then
		GnomTEC_Babel_Options["LanguageID"] = select(2, GetLanguageByIndex(1))
		GnomTEC_Babel_Options["Language"] = nil
	end
		
	-- Show GUI
	if (GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then
		GNOMTEC_BABEL_FRAME:Show()
	end

	GnomTEC_Babel:SetLanguage(GnomTEC_Babel_Options["LanguageID"])

end

function GnomTEC_Babel:OnDisable()
    -- Called when the addon is disabled
    
	GnomTEC_Babel:UnregisterAllEvents();
	GNOMTEC_BABEL_FRAME:Hide()

end

-- ----------------------------------------------------------------------
-- External API
-- ----------------------------------------------------------------------

