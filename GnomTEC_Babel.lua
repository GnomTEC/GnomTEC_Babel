GnomTEC_Babel_Options = {
	["Enabled"] = true,
	["Language"] = GetDefaultLanguage(),
	["LanguageSelectorEnabled"] = true,
	
}

local optionsMain = {
	name = "GnomTEC Babel",
	type = "group",
	args = {
		descriptionTitle = {
			order = 1,
			type = "description",
			name = "Antidiskriminierungsaddon welches die eigentlich verwendete Sprache durch [Sprache]-Prefix ersetzt\n\n",
		},
		babelOptionEnable = {
			type = "toggle",
			name = "Aktiviere Antidiskriminierung",
			desc = "",
			set = function(info,val) GnomTEC_Babel_Options["Enable"] = val;  end,
			get = function(info) return GnomTEC_Babel_Options["Enable"] end,
			width = 'full',
			order = 2
		},
		babelOptionLanguageSelectorEnable = {
			type = "toggle",
			name = "Aktiviere Button zur Sprachumschaltung",
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
			
GnomTEC_Babel = LibStub("AceAddon-3.0"):NewAddon("GnomTEC_Babel", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
LibStub("AceConfig-3.0"):RegisterOptionsTable("GnomTEC Babel Main", optionsMain)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GnomTEC Babel Main", "GnomTEC Babel");

function GnomTEC_Babel:OnInitialize()
 	-- Code that you want to run when the addon is first loaded goes here.
  
  	GnomTEC_Babel:Print("Willkommen bei GnomTEC_Babel")
  	  	
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

function GnomTEC_Babel:Translate(msg, chatType, language, channel)	
	if ((chatType == "SAY") or (chatType == "YELL")) then
		if (GnomTEC_Babel_Options["LanguageSelectorEnabled"]) then
			language = GnomTEC_Babel_Options["Language"]
		end
		if (GnomTEC_Babel_Options["Enable"]) then
			self.hooks.SendChatMessage("["..language.."] "..msg,chatType,nil, channel)
		else
			self.hooks.SendChatMessage(msg,chatType,language, channel)
		end
	else
		self.hooks.SendChatMessage(msg,chatType,language, channel)
	end
end

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


