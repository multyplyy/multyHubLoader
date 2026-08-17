local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local DISCORD_URL = "https://discord.gg/UPRtgK6tEJ"
local KEYUI_URL = "https://raw.githubusercontent.com/multyplyy/multyHubLoader/main/keyui.luau"

local HUB_OFFLINE = false
local HUB_OFFLINE_MESSAGE = "This script is currently offline."

local RETIRED_MESSAGE =
	"This script is offline and is not coming back for now. It is no longer updated, so it has broken features and a ban risk. It may return after the owner is back from vacation."

local GAMES = {
	{
		name = "SCP: Site Roleplay",
		placeIds = { 3226555017 },
		url = "https://api.jnkie.com/api/v1/luascripts/public/4fa86c6a73196bf8a2bb94234c069925d24fb2d6beeebb8683e6dd0c997c3c8a/download",
		offline = true,
		message = RETIRED_MESSAGE,
	},
	{
		name = "Refinery Caves 2",
		placeIds = { 12196278347 },
		url = "https://api.jnkie.com/api/v1/luascripts/public/b58914084e6def7d6d6476aa75b1c028075cfe85156ae93a027d09f38a72c721/download",
		offline = true,
		message = RETIRED_MESSAGE,
	},
	{
		name = "Naramo Nuclear Plant",
		placeIds = { 98626216952426 },
		url = "https://api.luarmor.net/files/v4/loaders/06a53d37c77751da3995e5188d703ae3.lua",
	},
	{
		name = "Energy Assault",
		placeIds = { 6172932937 },
		url = "https://api.jnkie.com/api/v1/luascripts/public/a2a45e4964bf767b1ad70f5f8ee2882fde0a548fe15110fc43c3969c7475fef0/download",
		offline = true,
		message = RETIRED_MESSAGE,
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
		name = "Valley Prison",
		placeIds = { 15784744207 },
		universeId = 5456952508,
		url = "https://api.jnkie.com/api/v1/luascripts/public/e9a1391186c98585ef9e21277c62a7af24d8ec222a2d9c70aac4bb78ff62f124/download",
		offline = true,
		message = RETIRED_MESSAGE,
	},
	{
		name = "TTK Testing",
		placeIds = { 120189115846709 },
		universeId = 10090256806,
		url = "https://api.luarmor.net/files/v4/loaders/a0d8616495aaa451fc7c46353cb06e1a.lua",
	},
	{
		name = "Havoc",
		placeIds = {
			13927562399,
			16530963934,
		},
		universeId = 4827308727,
		scriptId = "b72cb788dfef6ec345fb57e66eedcd0d",
		accent = { 240, 167, 51 },
		url = "https://api.luarmor.net/files/v4/loaders/b72cb788dfef6ec345fb57e66eedcd0d.lua",
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

if HUB_OFFLINE then
	stop("Multy Hub | Offline", HUB_OFFLINE_MESSAGE, 15)
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

loadGame(current)
