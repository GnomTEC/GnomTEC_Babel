-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC_Babel", "enUS", true)
if not L then return end

L["L_OPTIONS_TITLE"] = "Addon to change used language into common and add a prefix of used language in say and yell channel that other races can read the text (like gnomes should understand dwarf). Additional support of button to change language.\n\n"
L["L_OPTIONS_ENABLE"] = "Activate translation and language prefix"
L["L_OPTIONS_BUTTON"] = "Activate button for language switching"
L["L_OPTIONS_LANGUAGES"] = "User defined languages (only with activated language prefix)"
L["L_OPTIONS_LANGUAGES_1"] = "Language #1"
L["L_OPTIONS_LANGUAGES_2"] = "Language #2"
L["L_OPTIONS_LANGUAGES_3"] = "Language #3"
L["L_OPTIONS_LANGUAGES_4"] = "Language #4"
L["L_OPTIONS_LANGUAGES_5"] = "Language #5"
L["L_WELCOME"] = "Welcome to GnomTEC_Babel"
L["L_LDB_HINT"] = "Hint: click for language selection"