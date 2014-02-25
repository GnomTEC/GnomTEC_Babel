GnomTEC_Babel_Options = {
	["Enabled"] = true,
	["Language"] = GetDefaultLanguage(),	
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
			set = function(info,val) GnomTEC_Babel_Options["Enable"] = val; if (GnomTEC_Babel_Options["Enable"]) then GNOMTEC_BABEL_FRAME:Show(); else GNOMTEC_BABEL_FRAME:Hide(); end;  end,
			get = function(info) return GnomTEC_Babel_Options["Enable"] end,
			width = 'full',
			order = 2
		},
		descriptionAbout = {
			name = "About",
			type = "group",
			guiInline = true,
			order = 3,
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
			order = 4,
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

	if (GnomTEC_Babel_Options["Enable"]) then
		GNOMTEC_BABEL_FRAME:Show()
	end
end

function GnomTEC_Babel:OnDisable()
    -- Called when the addon is disabled
    
    GnomTEC_Babel:UnregisterAllEvents();
	GNOMTEC_BABEL_FRAME:Hide()

end

function GnomTEC_Babel:Translate(msg, chatType, language, channel)
	
	if ((GnomTEC_Babel_Options["Enable"]) and (chatType == "SAY")) then
		language = GnomTEC_Babel_Options["Language"]
		if ((language ~= "Gemeinsprache") and (language ~= "Orcisch") and (language ~= nil)) then
			self.hooks.SendChatMessage("["..language.."] "..msg,chatType,nil, channel)	
		else
			self.hooks.SendChatMessage(msg,chatType,nil, channel)
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


