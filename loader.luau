local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local DISCORD_URL = "https://discord.gg/UPRtgK6tEJ"
local KEYUI_URL = "https://raw.githubusercontent.com/multyplyy/multyHubLoader/main/keyui.luau"

local HUB_OFFLINE = false
local HUB_OFFLINE_MESSAGE =
	"All scripts are offline for now. Most obfuscators have been cracked and Luraph is no longer reliable."

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
		url = "https://api.luarmor.net/files/v4/loaders/a5bab3832baa1e81d76157aa1e4a6516.lua",
	},
	{
		name = "Blackhawk Rescue Mission 5",
		placeIds = {
			4747446334,
			3701546109,
		},
		universeId = 1054526971,
		accent = { 138, 154, 91 },
		editionFile = "multyhub_brm5_edition.txt",
		editions = {
			{
				id = "private",
				label = "Private",
				keyName = "private key",
				scriptId = "f70c2c525f77307315f78fb73549bd7a",
				private = true,
				keyFile = "multyhub_privates_key.txt",
				url = "https://api.luarmor.net/files/v4/loaders/f70c2c525f77307315f78fb73549bd7a.lua",
			},
			{
				id = "public",
				label = "Public",
				keyName = "MultyHub key",
				offline = true,
				message = "The public version is disabled right now.",
				scriptId = "b55e67d5562bcf695ef042658cb621d1",
				url = "https://api.luarmor.net/files/v4/loaders/b55e67d5562bcf695ef042658cb621d1.lua",
			},
		},
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

local function readFile(name)
	local ok, data = pcall(function()
		if type(isfile) == "function" and isfile(name) then
			return readfile(name)
		end
	end)
	return ok and type(data) == "string" and data or nil
end

local function savedEdition(entry)
	local saved = entry.editionFile and readFile(entry.editionFile)
	local id = saved and saved:match("^%s*(%a+)")
	for _, edition in entry.editions do
		if edition.id == id then
			return id
		end
	end
	return nil
end

local function editionOrder(entry)
	local preferred = savedEdition(entry)
	local order = {}

	for _, offline in { false, true } do
		for _, edition in entry.editions do
			if (edition.offline == true) == offline and edition.id == preferred then
				table.insert(order, edition)
			end
		end
		for _, edition in entry.editions do
			if (edition.offline == true) == offline and edition.id ~= preferred then
				table.insert(order, edition)
			end
		end
	end

	return order
end

local function refuseEdition(entry, edition)
	local message = edition.message or ("The " .. string.lower(edition.label) .. " version is offline right now.")
	getgenv().MULTYHUB_EDITION_REFUSED = message
	notify("Multy Hub | " .. entry.name, message, 8)
	warn("[Multy Hub] " .. message)
end

local function askForKey(entry, editions, lock)
	local first = entry
	if editions then
		first = editions[1]
		for _, edition in editions do
			if edition.id == lock then
				first = edition
			end
		end
	end

	getgenv().MULTYHUB_KEYUI = {
		scriptId = first.scriptId,
		gameName = entry.name,
		accent = entry.accent,
		private = first.private,
		keyFile = first.keyFile,
		editions = editions,
		lock = lock,
	}
	getgenv().MULTYHUB_KEYUI_EDITION = nil

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

local function loadEditions(entry)
	local request = getgenv().MULTYHUB_EDITION_REQUEST
	getgenv().MULTYHUB_EDITION_REQUEST = nil

	getgenv().MULTYHUB_EDITION_REFUSED = nil

	local order = editionOrder(entry)
	local lock
	for _, edition in order do
		if edition.id == request then
			lock = edition.id
			if edition.offline then
				refuseEdition(entry, edition)
				return
			end
		end
	end

	if order[1].offline then
		refuseEdition(entry, order[1])
		return
	end

	if not askForKey(entry, order, lock) then
		return
	end

	local chosen = getgenv().MULTYHUB_KEYUI_EDITION or lock or order[1].id
	local target = order[1]
	for _, edition in order do
		if edition.id == chosen then
			target = edition
		end
	end

	if target.offline then
		refuseEdition(entry, target)
		return
	end

	if lock or not savedEdition(entry) then
		pcall(writefile, entry.editionFile, target.id)
	end
	getgenv().MULTYHUB_EDITION = target.id

	notify("Multy Hub", "Loading " .. entry.name .. " (" .. target.label .. ")...", 3)
	task.wait(1)

	runRemote(entry, target.url)
end

local function loadGame(entry)
	if entry.editions then
		loadEditions(entry)
		return
	end

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
