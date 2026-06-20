local Game = game
local Players = Game:GetService("Players")
local StarterGui = Game:GetService("StarterGui")
local Workspace = Game:GetService("Workspace")

local DISCORD_URL = "https://discord.gg/UPRtgK6tEJ"
local DEFAULT_OFFLINE_MESSAGE = "This script is currently offline."

local HUB = {
	offline = false,
	message = DEFAULT_OFFLINE_MESSAGE,
}

local GAMES = {
	{
		name = "SCP: Site Roleplay",
		placeIds = { 3226555017 },
		url = "https://api.jnkie.com/api/v1/luascripts/public/4fa86c6a73196bf8a2bb94234c069925d24fb2d6beeebb8683e6dd0c997c3c8a/download",
	},
	{
		name = "Refinery Caves 2",
		placeIds = { 12196278347 },
		url = "https://api.jnkie.com/api/v1/luascripts/public/b58914084e6def7d6d6476aa75b1c028075cfe85156ae93a027d09f38a72c721/download",
	},
	{
		name = "Naramo Nuclear Plant",
		placeIds = { 98626216952426 },
		url = "https://api.jnkie.com/api/v1/luascripts/public/86e7ce3479f8686809da4db8bc437a2e1800e4f83f223d0d091e3a9f06c41680/download",
	},
	{
		name = "Energy Assault",
		placeIds = { 6172932937 },
		url = "https://api.jnkie.com/api/v1/luascripts/public/a2a45e4964bf767b1ad70f5f8ee2882fde0a548fe15110fc43c3969c7475fef0/download",
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
		status = "discontinued",
		message = "The Apocalypse Rising 2 script has been discontinued and is no longer available. Discord invite copied to clipboard.",
	},
	{
		name = "Blackhawk Rescue Mission 5",
		placeIds = {
			4747446334,
			3701546109,
		},
		universeId = 1054526971,
		url = "https://api.jnkie.com/api/v1/luascripts/public/c1d9891c5990d92853439b6e0a31adacba9209631ef18b9817dd0a31fc79ba0b/download",
	},
	{
		name = "Valley Prison",
		placeIds = { 15784744207 },
		universeId = 5456952508,
		url = "https://api.jnkie.com/api/v1/luascripts/public/e9a1391186c98585ef9e21277c62a7af24d8ec222a2d9c70aac4bb78ff62f124/download",
	},
	{
		name = "TTK Testing",
		placeIds = { 120189115846709 },
		universeId = 10090256806,
		url = "https://api.jnkie.com/api/v1/luascripts/public/a5bbf4363782723c19581df435c0c1803e697b9c05580b26ea39565b84140584/download",
	},
}

local STATUS_TITLES = {
	discontinued = "Discontinued",
	offline = "Offline",
}

local gamesByPlaceId = {}
local gamesByUniverseId = {}

local function indexGames()
	for _, gameDefinition in GAMES do
		for _, placeId in gameDefinition.placeIds do
			gamesByPlaceId[placeId] = gameDefinition
		end

		if gameDefinition.universeId then
			gamesByUniverseId[gameDefinition.universeId] = gameDefinition
		end
	end
end

local function waitUntilReady()
	if not Game:IsLoaded() then
		Game.Loaded:Wait()
	end

	repeat
		task.wait(0.1)
	until Game.PlaceId ~= 0 and Game.GameId ~= 0 and Players.LocalPlayer and Workspace.CurrentCamera
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

local function copyDiscordInvite()
	if type(setclipboard) ~= "function" then
		return false
	end

	return pcall(setclipboard, DISCORD_URL)
end

local function addDiscordDetails(message)
	if copyDiscordInvite() then
		return message .. " Discord invite copied to clipboard."
	end

	return message .. " Discord: " .. DISCORD_URL
end

local function showUnavailable(title, message, duration)
	notify(title, addDiscordDetails(message), duration)
	warn("[Multy Hub] " .. message)
end

local function resolveGame()
	return gamesByPlaceId[Game.PlaceId] or gamesByUniverseId[Game.GameId]
end

local function reportLoadFailure(gameDefinition, reason)
	local message = "Failed to load " .. gameDefinition.name .. ". Check the console for details."

	notify("Multy Hub | Error", message, 10)
	warn("[Multy Hub] " .. message, reason)
end

local function loadGame(gameDefinition)
	if not gameDefinition.url then
		reportLoadFailure(gameDefinition, "No script URL is configured.")
		return
	end

	notify("Multy Hub", "Loading " .. gameDefinition.name .. "...", 3)
	task.wait(1)

	local requestSucceeded, source = pcall(Game.HttpGet, Game, gameDefinition.url)
	if not requestSucceeded then
		reportLoadFailure(gameDefinition, source)
		return
	end

	local chunk, compileError = loadstring(source)
	if not chunk then
		reportLoadFailure(gameDefinition, compileError)
		return
	end

	local executionSucceeded, runtimeError = pcall(chunk)
	if not executionSucceeded then
		reportLoadFailure(gameDefinition, runtimeError)
	end
end

waitUntilReady()

if HUB.offline then
	showUnavailable("Multy Hub | Offline", HUB.message, 15)
	return
end

indexGames()

local currentGame = resolveGame()
if not currentGame then
	showUnavailable("Multy Hub", "This game is not supported.", 5)
	return
end

if currentGame.status then
	local statusTitle = STATUS_TITLES[currentGame.status] or "Offline"
	showUnavailable("Multy Hub | " .. statusTitle, currentGame.message or DEFAULT_OFFLINE_MESSAGE, 15)
	return
end

loadGame(currentGame)
