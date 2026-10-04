local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local DISCORD_URL = "https://discord.gg/UPRtgK6tEJ"
local KEYUI_URL = "https://raw.githubusercontent.com/multyplyy/multyHubLoader/main/keyui.luau"

local HUB_OFFLINE = true
local HUB_OFFLINE_MESSAGE =
	"All scripts are offline for now. Most obfuscators have been cracked and Luraph is no longer reliable."

local RETIRED_MESSAGE =
	"This script is offline and not maintained. It is no longer updated, so it has broken features and a ban risk."

local GAMES = {
	{
		name = "Naramo Nuclear Plant",
		placeIds = { 98626216952426 },
		url = "https://api.luarmor.net/files/v4/loaders/06a53d37c77751da3995e5188d703ae3.lua",
	},
	{
		name = "Apocalypse Rising 2",
		placeIds = {
			863266079,
			10077968348,
			93911318070665,
			105446216022659,
		},
		universeId = 358276974,
		url = "https://api.jnkie.com/api/v1/luascripts/public/6bed93c42a6aea7af5193c70d2e9d0abfeaf0db4114e7ecf2bb9d0d6d81d3d03/download",
		offline = true,
		message = RETIRED_MESSAGE,
	},
	{
		name = "Blackhawk Rescue Mission 5",
		placeIds = {
			4747446334,
			3701546109,
		},
		universeId = 1054526971,
		scriptId = "b55e67d5562bcf695ef042658cb621d1",
		accent = { 138, 154, 91 },
		url = "https://api.luarmor.net/files/v4/loaders/b55e67d5562bcf695ef042658cb621d1.lua",
	},
	{
		name = "TTK Testing",
		placeIds = { 120189115846709 },
		universeId = 10090256806,
		url = "https://api.luarmor.net/files/v4/loaders/a0d8616495aaa451fc7c46353cb06e1a.lua",
	},
	{
		name = "bug fixes",
		placeIds = { 100971017807798 },
		universeId = 10666192800,
		scriptId = "ad5ce22cd1c6073a9e71dfe7fb9bc8e6",
		accent = { 176, 48, 60 },
		private = true,
		keyFile = "multyhub_privates_key.txt",
		url = "https://api.luarmor.net/files/v4/loaders/ad5ce22cd1c6073a9e71dfe7fb9bc8e6.lua",
	},
	{
		name = "Cold War",
		placeIds = { 13687899540 },
		universeId = 4750561026,
		scriptId = "ba1636f9907c5be638a3a0f88b448637",
		accent = { 138, 154, 91 },
		private = true,
		keyFile = "multyhub_privates_key.txt",
		url = "https://api.luarmor.net/files/v4/loaders/ba1636f9907c5be638a3a0f88b448637.lua",
	},
}

local byPlaceId = {}
local byUniverseId = {}

for _, entry in GAMES do
	for _, placeId in entry.placeIds do
		byPlaceId[placeId] = entry
	end

	if entry.universeId then
		byUniverseId[entry.universeId] = entry
	end
end

local function notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration,
		})
	end)
end

local function stop(title, message, duration)
	if type(setclipboard) == "function" and pcall(setclipboard, DISCORD_URL) then
		message = message .. " Discord invite copied to clipboard."
	else
		message = message .. " Discord: " .. DISCORD_URL
	end

	notify(title, message, duration)
	warn("[Multy Hub] " .. message)
end

local function reportFailure(entry, reason)
	local message = "Failed to load " .. entry.name .. ". Check the console for details."

	notify("Multy Hub | Error", message, 10)
	warn("[Multy Hub] " .. message, reason)
end

local function runRemote(entry, url)
	local fetched, source = pcall(game.HttpGet, game, url)
	if not fetched then
		reportFailure(entry, source)
		return false
	end

	local chunk, compileError = loadstring(source)
	if not chunk then
		reportFailure(entry, compileError)
		return false
	end

	local ran, result = pcall(chunk)
	if not ran then
		reportFailure(entry, result)
		return false
	end

	return true, result
end

local function askForKey(entry)
	getgenv().MULTYHUB_KEYUI = {
		scriptId = entry.scriptId,
		gameName = entry.name,
		accent = entry.accent,
		private = entry.private,
		keyFile = entry.keyFile,
	}

	if not runRemote(entry, KEYUI_URL) then
		return false
	end

	local key = getgenv().SCRIPT_KEY
	if type(key) ~= "string" or #key < 1 then
		warn("[Multy Hub] " .. entry.name .. ": no key provided, aborting.")
		return false
	end

	script_key = key
	getgenv().script_key = key

	return true
end

local function loadGame(entry)
	if entry.scriptId and not askForKey(entry) then
		return
	end

	notify("Multy Hub", "Loading " .. entry.name .. "...", 3)
	task.wait(1)

	runRemote(entry, entry.url)
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

repeat
	task.wait(0.1)
until game.PlaceId ~= 0 and game.GameId ~= 0 and Players.LocalPlayer and Workspace.CurrentCamera

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
	stop(
		"Multy Hub | Unsupported Device",
		"Mobile executors are not supported. Please use a supported desktop executor.",
		12
	)
	return
end

local current = byPlaceId[game.PlaceId] or byUniverseId[game.GameId]
if not current then
	stop("Multy Hub", "This game is not supported.", 5)
	return
end

if current.offline then
	stop("Multy Hub | Offline", current.message, 15)
	return
end

if HUB_OFFLINE then
	stop("Multy Hub | Offline", HUB_OFFLINE_MESSAGE, 15)
	return
end

loadGame(current)
