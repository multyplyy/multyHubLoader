local CONFIG = (type(getgenv) == "function" and getgenv().MULTYHUB_KEYUI) or {}

local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()

local function makeEdition(source)
    return {
        id = source.id or "default",
        label = source.label or "",
        keyName = source.keyName or "key",
        scriptId = source.scriptId,
        private = source.private == true,
        offline = source.offline == true,
        message = source.message,
        keyFile = (type(source.keyFile) == "string" and source.keyFile ~= "") and source.keyFile or "multyhub_key.txt",
    }
end

local EDITIONS = {}
if type(CONFIG.editions) == "table" and #CONFIG.editions > 0 then
    for _, source in ipairs(CONFIG.editions) do
        table.insert(EDITIONS, makeEdition(source))
    end
else
    EDITIONS[1] = makeEdition({
        scriptId = CONFIG.scriptId or "b72cb788dfef6ec345fb57e66eedcd0d",
        private = CONFIG.private,
        keyFile = CONFIG.keyFile,
    })
end

local LOCK
for _, edition in ipairs(EDITIONS) do
    if CONFIG.lock ~= nil and edition.id == CONFIG.lock then
        LOCK = edition
    end
end

local ORDER = {}
if LOCK then
    table.insert(ORDER, LOCK)
end
for _, edition in ipairs(EDITIONS) do
    if edition ~= LOCK then
        table.insert(ORDER, edition)
    end
end

local MULTI = #EDITIONS > 1
local SHOWN = LOCK or (not MULTI and EDITIONS[1]) or nil

local GAME_NAME = CONFIG.gameName or "Havoc"
local IS_PRIVATE = SHOWN ~= nil and SHOWN.private
local ANY_PRIVATE = false
for _, edition in ipairs(EDITIONS) do
    if edition.private then
        ANY_PRIVATE = true
    end
end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function accentColor(fallbackR, fallbackG, fallbackB)
    local rgb = CONFIG.accent
    if type(rgb) == "table" and #rgb == 3 then
        return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
    end
    return Color3.fromRGB(fallbackR, fallbackG, fallbackB)
end

local ACCENT = accentColor(240, 167, 51)
local ACCENT_HOVER = Color3.fromRGB(
    math.min(255, math.floor(ACCENT.R * 255) + 12),
    math.min(255, math.floor(ACCENT.G * 255) + 15),
    math.min(255, math.floor(ACCENT.B * 255) + 23)
)
local DISCORD = Color3.fromRGB(40, 40, 44)
local DISCORD_HOVER = Color3.fromRGB(52, 52, 58)
local BG = Color3.fromRGB(14, 14, 16)
local PANEL = Color3.fromRGB(20, 20, 24)
local PANEL_2 = Color3.fromRGB(24, 24, 28)
local STROKE = Color3.fromRGB(23, 23, 29)
local STROKE_2 = Color3.fromRGB(34, 34, 40)
local TEXT = Color3.fromRGB(230, 230, 235)
local MUTED = Color3.fromRGB(145, 145, 150)
local ERROR = Color3.fromRGB(235, 80, 95)
local WARNING = Color3.fromRGB(235, 180, 80)

local DISCORD_INVITE = "https://discord.gg/UPRtgK6tEJ"
local PAYMENT_URL = type(CONFIG.getKeyUrl) == "string" and CONFIG.getKeyUrl or "https://www.scpscript.info/payment/"
local SHOW_GET_KEY = type(CONFIG.getKeyUrl) == "string" or (not MULTI and not IS_PRIVATE)

local fontBold, fontMedium
local fontOk = pcall(function()
    fontBold = Font.new(getcustomasset("SemiBold.font"), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    fontMedium = Font.new(getcustomasset("Medium.font"), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end)

if not fontOk then
    fontBold = Font.fromEnum(Enum.Font.GothamBold)
    fontMedium = Font.fromEnum(Enum.Font.GothamMedium)
end

local hasFS = pcall(function()
    return type(writefile) == "function"
        and type(readfile) == "function"
        and type(isfile) == "function"
end)

local function readKeyFile(name)
    local ok, data = pcall(function()
        if isfile(name) then
            return readfile(name)
        end
    end)

    if ok and data and #data > 0 then
        return data
    end

    return nil
end

local function keyFilesFor(edition)
    if edition.keyFile == "multyhub_key.txt" then
        return { edition.keyFile, "havoc_key.txt" }
    end
    return { edition.keyFile }
end

local function trimKey(key)
    return (tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function savedKeys(editions)
    local list, seen = {}, {}
    if not hasFS then return list end

    for _, edition in ipairs(editions) do
        for _, file in ipairs(keyFilesFor(edition)) do
            local key = readKeyFile(file)
            key = key and trimKey(key)
            if key and key ~= "" and not seen[key] then
                seen[key] = true
                table.insert(list, { key = key, file = file })
                break
            end
        end
    end

    return list
end

local function saveKey(edition, key)
    if not hasFS then return end
    pcall(function()
        writefile(edition.keyFile, key)
    end)
end

local function forgetKey(file, key)
    if not hasFS or not file then return end
    pcall(function()
        if isfile(file) and trimKey(readfile(file)) == key then
            delfile(file)
        end
    end)
end

local function forgetKeyEverywhere(key)
    for _, edition in ipairs(EDITIONS) do
        for _, file in ipairs(keyFilesFor(edition)) do
            forgetKey(file, key)
        end
    end
end

local ERROR_MESSAGES = {
    KEY_INCORRECT = "Key not found or deleted.",
    KEY_INVALID = "Key is in an invalid format.",
    KEY_EXPIRED = "This key has expired. Renew it on our website or Discord to keep access.",
    KEY_BANNED = "This key is blacklisted.",
    KEY_HWID_LOCKED = "Key is locked to a different HWID. Reset it with our Discord bot.",
    SCRIPT_ID_INCORRECT = "Script configuration error. Contact staff.",
    SCRIPT_ID_INVALID = "Script configuration error. Contact staff.",
    INVALID_EXECUTOR = "Your executor is not supported.",
    SECURITY_ERROR = "Security check failed. Try again.",
    TIME_ERROR = "System clock is off. Fix your time and retry.",
    UNKNOWN_ERROR = "Server error. Please try again shortly.",
    ERROR = "Network error. Please try again."
}

local PRIVATE_MESSAGES = {
    KEY_EXPIRED = "This key has expired. Open a ticket in our Discord to have it extended.",
    KEY_HWID_LOCKED = "Key is locked to a different HWID. Open a ticket in our Discord and staff will reset it."
}

local function errorMessage(code, edition, fallback)
    if edition and edition.private and PRIVATE_MESSAGES[code] then
        return PRIVATE_MESSAGES[code]
    end
    return ERROR_MESSAGES[code] or tostring(fallback or code)
end

local NOT_THIS_SCRIPT = { KEY_INCORRECT = true, SCRIPT_ID_INCORRECT = true, SCRIPT_ID_INVALID = true }
local TEMPORARY = { UNKNOWN_ERROR = true, SECURITY_ERROR = true, TIME_ERROR = true }

local function resolveKey(key)
    local missCode
    for _, edition in ipairs(ORDER) do
        api.script_id = edition.scriptId
        local ok, status = pcall(function()
            return api.check_key(key)
        end)
        if not ok or type(status) ~= "table" then
            return { kind = "network" }
        end

        local code = status.code or "ERROR"
        if code == "KEY_VALID" then
            return { kind = "valid", edition = edition }
        end
        if TEMPORARY[code] then
            return { kind = "retry", code = code }
        end
        if not NOT_THIS_SCRIPT[code] then
            return { kind = "error", code = code, edition = edition, message = status.message }
        end
        if missCode ~= "KEY_INCORRECT" then
            missCode = code
        end
    end
    return { kind = "error", code = missCode or "KEY_INCORRECT" }
end

local function makeCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

local function makeStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function makeButton(parent, text, color, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = textColor or Color3.fromRGB(15, 15, 20)
    btn.FontFace = fontBold
    btn.TextSize = 16
    btn.AutoButtonColor = false
    btn.ZIndex = 9005
    btn.Parent = parent

    makeCorner(btn, 7)

    return btn
end

do
    getgenv().SCRIPT_KEY = nil
    getgenv().MULTYHUB_KEYUI_EDITION = nil
    getgenv().UI_CLOSED = false

    if type(getgenv().MULTYHUB_KEYUI_DISMISS) == "function" then
        pcall(getgenv().MULTYHUB_KEYUI_DISMISS)
    end
    getgenv().MULTYHUB_KEYUI_DISMISS = nil

    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local function cursorRefs()
        local g = (type(getgenv) == "function" and getgenv()) or _G
        g.MULTYHUB_CURSOR_REFS = g.MULTYHUB_CURSOR_REFS or {}
        return g.MULTYHUB_CURSOR_REFS
    end

    local function installCursorOverride()
        local g = (type(getgenv) == "function" and getgenv()) or _G
        if g.MULTYHUB_CURSOR_HOOKED then return end
        local in_havoc = false
        pcall(function() in_havoc = game.GameId == 4827308727 end)
        if not in_havoc then return end
        if type(getgc) ~= "function" then return end

        local proto
        pcall(function()
            for _, v in next, getgc(true) do
                if type(v) == "table"
                    and rawget(v, "__index") == v
                    and type(rawget(v, "Update")) == "function"
                    and type(rawget(v, "_update")) == "function"
                    and type(rawget(v, "SetBlockedPosition")) == "function"
                    and type(rawget(v, "new")) == "function" then
                    proto = v
                    break
                end
            end
        end)
        if not proto then return end

        local old_update = proto.Update
        local wrap = (type(newcclosure) == "function" and newcclosure) or function(f) return f end
        proto.Update = wrap(function(self, ...)
            old_update(self, ...)
            local refs = rawget(g, "MULTYHUB_CURSOR_REFS")
            if refs and next(refs) ~= nil then
                pcall(function()
                    UserInputService.MouseIconEnabled = true
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                end)
            end
        end)

        g.MULTYHUB_CURSOR_HOOKED = true
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "\0"
    gui.Parent = CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999600

    local backdrop = Instance.new("Frame")
    backdrop.Name = "\0"
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 1
    backdrop.BorderSizePixel = 0
    backdrop.ZIndex = 9000
    backdrop.Parent = gui

    local card = Instance.new("CanvasGroup")
    card.Name = "\0"
    card.Size = UDim2.new(0, 430, 0, 140)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = BG
    card.BorderSizePixel = 0
    card.GroupTransparency = 1
    card.ZIndex = 9001
    card.Parent = gui

    makeCorner(card, 10)
    local cardStroke = makeStroke(card, STROKE, 1)
    cardStroke.Transparency = 1

    local cardScale = Instance.new("UIScale")
    cardScale.Scale = 1
    cardScale.Parent = card

    local topClip = Instance.new("Frame")
    topClip.Name = "\0"
    topClip.Size = UDim2.new(1, 0, 0, 3)
    topClip.Position = UDim2.new(0, 0, 0, 0)
    topClip.BackgroundTransparency = 1
    topClip.BorderSizePixel = 0
    topClip.ClipsDescendants = true
    topClip.ZIndex = 9004
    topClip.Parent = card

    local topBar = Instance.new("Frame")
    topBar.Name = "\0"
    topBar.Size = UDim2.new(1, 0, 0, 20)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = ACCENT
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 9004
    topBar.Parent = topClip

    makeCorner(topBar, 10)

    local keyPage = Instance.new("CanvasGroup")
    keyPage.Name = "\0"
    keyPage.Size = UDim2.new(1, 0, 0, 0)
    keyPage.AutomaticSize = Enum.AutomaticSize.Y
    keyPage.Position = UDim2.new(0, 0, 0, 3)
    keyPage.BackgroundTransparency = 1
    keyPage.BorderSizePixel = 0
    keyPage.GroupTransparency = 0
    keyPage.ZIndex = 9002
    keyPage.Parent = card

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 18)
    padding.PaddingBottom = UDim.new(0, 20)
    padding.PaddingLeft = UDim.new(0, 22)
    padding.PaddingRight = UDim.new(0, 22)
    padding.Parent = keyPage

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 11)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = keyPage

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 0)
    title.AutomaticSize = Enum.AutomaticSize.Y
    title.BackgroundTransparency = 1
    title.RichText = true
    title.Text = '<font color="rgb(240, 167, 51)">multy</font><font color="rgb(255,255,255)">hub</font>'
    title.FontFace = fontBold
    title.TextSize = 28
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.LayoutOrder = 1
    title.ZIndex = 9003
    title.Parent = keyPage

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 0)
    subtitle.AutomaticSize = Enum.AutomaticSize.Y
    subtitle.BackgroundTransparency = 1
    subtitle.RichText = true
    subtitle.Text = '<font color="rgb(205,205,215)">' .. GAME_NAME .. "</font>"
    subtitle.FontFace = fontMedium
    subtitle.TextSize = 16
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.LayoutOrder = 2
    subtitle.ZIndex = 9003
    subtitle.Parent = keyPage

    local betaBox = Instance.new("Frame")
    betaBox.Size = UDim2.new(1, 0, 0, 72)
    betaBox.BackgroundColor3 = PANEL
    betaBox.BorderSizePixel = 0
    betaBox.LayoutOrder = 3
    betaBox.ZIndex = 9003
    betaBox.Parent = keyPage

    makeCorner(betaBox, 8)
    makeStroke(betaBox, STROKE_2, 1)

    local accentTag = string.format(
        "rgb(%d,%d,%d)",
        math.floor(ACCENT.R * 255),
        math.floor(ACCENT.G * 255),
        math.floor(ACCENT.B * 255)
    )

    local function accented(text)
        return '<font color="' .. accentTag .. '">' .. text .. "</font>"
    end

    local HWID_NOTE = "HWID resets for private keys are done by staff in a Discord ticket."
    local titleText, infoText, footerText

    if LOCK then
        titleText = "Switch to " .. accented(LOCK.label)
        infoText = "Paste your " .. LOCK.keyName .. ". It gets saved for next time."
        footerText = "Press Abort to keep the version you are running now."
            .. (LOCK.private and (" " .. HWID_NOTE) or "")
    elseif MULTI then
        local labels, parts = {}, {}
        for _, edition in ipairs(EDITIONS) do
            table.insert(labels, accented(edition.label))
            table.insert(parts, "a " .. edition.keyName .. " loads the " .. string.lower(edition.label) .. " version")
        end
        local info = table.concat(parts, ", ")
        titleText = table.concat(labels, " or ") .. " key"
        infoText = string.upper(string.sub(info, 1, 1)) .. string.sub(info, 2) .. "."
        footerText = "Paste either key above." .. (ANY_PRIVATE and (" " .. HWID_NOTE) or "")
    elseif IS_PRIVATE then
        titleText = accented("Private") .. " script"
        infoText = "This script is not for sale. Keys are handed out by staff only."
        footerText = "Got a key from staff? Paste it above. HWID resets for this script are done by staff in a Discord ticket."
    else
        titleText = accented("One key") .. " - Havoc + BRM5"
        infoText = "\226\130\172" .. "4.99/week, \226\130\172" .. "9.99/month or \226\130\172"
            .. "19.99 lifetime - every plan unlocks both scripts. Get a key below."
        footerText = "One key runs Havoc and BRM5. Tap Get Key to grab yours, then paste it above."
    end

    local betaTitle = Instance.new("TextLabel")
    betaTitle.Size = UDim2.new(1, -24, 0, 28)
    betaTitle.Position = UDim2.new(0, 12, 0, 10)
    betaTitle.BackgroundTransparency = 1
    betaTitle.RichText = true
    betaTitle.Text = titleText
    betaTitle.TextColor3 = TEXT
    betaTitle.FontFace = fontBold
    betaTitle.TextSize = 18
    betaTitle.TextXAlignment = Enum.TextXAlignment.Center
    betaTitle.ZIndex = 9004
    betaTitle.Parent = betaBox

    local betaInfo = Instance.new("TextLabel")
    betaInfo.Size = UDim2.new(1, -24, 0, 24)
    betaInfo.Position = UDim2.new(0, 12, 0, 38)
    betaInfo.BackgroundTransparency = 1
    betaInfo.Text = infoText
    betaInfo.TextColor3 = MUTED
    betaInfo.FontFace = fontMedium
    betaInfo.TextSize = 14
    betaInfo.TextWrapped = true
    betaInfo.TextXAlignment = Enum.TextXAlignment.Center
    betaInfo.ZIndex = 9004
    betaInfo.Parent = betaBox

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 0)
    statusLabel.AutomaticSize = Enum.AutomaticSize.Y
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Enter your key below to continue."
    statusLabel.TextColor3 = MUTED
    statusLabel.FontFace = fontMedium
    statusLabel.TextSize = 15
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.LayoutOrder = 4
    statusLabel.ZIndex = 9003
    statusLabel.Parent = keyPage

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, 0, 0, 40)
    inputFrame.BackgroundColor3 = PANEL_2
    inputFrame.BorderSizePixel = 0
    inputFrame.LayoutOrder = 5
    inputFrame.ZIndex = 9003
    inputFrame.Parent = keyPage

    makeCorner(inputFrame, 7)
    local inputStroke = makeStroke(inputFrame, STROKE_2, 1)

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -18, 1, 0)
    inputBox.Position = UDim2.new(0, 9, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.Text = ""
    inputBox.PlaceholderText = "Paste your key here..."
    inputBox.PlaceholderColor3 = Color3.fromRGB(95, 95, 110)
    inputBox.TextColor3 = TEXT
    inputBox.FontFace = fontMedium
    inputBox.TextSize = 16
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.ClearTextOnFocus = false
    inputBox.ZIndex = 9004
    inputBox.Parent = inputFrame

    inputBox.Focused:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.15), {
            Color = ACCENT
        }):Play()
    end)

    inputBox.FocusLost:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.15), {
            Color = STROKE_2
        }):Play()
    end)

    local validateRow = Instance.new("Frame")
    validateRow.Size = UDim2.new(1, 0, 0, 36)
    validateRow.BackgroundTransparency = 1
    validateRow.LayoutOrder = 6
    validateRow.ZIndex = 9003
    validateRow.Parent = keyPage

    local validateBtn = makeButton(validateRow, "Validate Key", ACCENT, Color3.fromRGB(255, 255, 255))

    local buttonRow = Instance.new("Frame")
    buttonRow.Size = UDim2.new(1, 0, 0, 36)
    buttonRow.BackgroundTransparency = 1
    buttonRow.LayoutOrder = 7
    buttonRow.ZIndex = 9003
    buttonRow.Parent = keyPage

    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.Padding = UDim.new(0, 10)
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonLayout.Parent = buttonRow

    local getKeyHolder = Instance.new("Frame")
    getKeyHolder.Size = UDim2.new(1 / 3, -7, 1, 0)
    getKeyHolder.BackgroundTransparency = 1
    getKeyHolder.LayoutOrder = 1
    getKeyHolder.Parent = buttonRow

    local discordHolder = Instance.new("Frame")
    discordHolder.Size = UDim2.new(1 / 3, -7, 1, 0)
    discordHolder.BackgroundTransparency = 1
    discordHolder.LayoutOrder = 2
    discordHolder.Parent = buttonRow

    local abortHolder = Instance.new("Frame")
    abortHolder.Size = UDim2.new(1 / 3, -7, 1, 0)
    abortHolder.BackgroundTransparency = 1
    abortHolder.LayoutOrder = 3
    abortHolder.Parent = buttonRow

    local getKeyBtn = makeButton(getKeyHolder, "Get Key", ACCENT, Color3.fromRGB(255, 255, 255))
    local discordBtn = makeButton(discordHolder, "Discord", DISCORD, Color3.fromRGB(230, 230, 235))
    local abortBtn = makeButton(abortHolder, "Abort", Color3.fromRGB(30, 30, 34), Color3.fromRGB(205, 205, 215))
    makeStroke(abortBtn, Color3.fromRGB(40, 40, 46), 1)

    if not SHOW_GET_KEY then
        getKeyHolder.Visible = false
        discordHolder.Size = UDim2.new(0.5, -5, 1, 0)
        abortHolder.Size = UDim2.new(0.5, -5, 1, 0)
    end

    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, 0, 0, 0)
    footer.AutomaticSize = Enum.AutomaticSize.Y
    footer.BackgroundTransparency = 1
    footer.RichText = true
    footer.Text = '<font color="rgb(120,120,130)">' .. footerText .. "</font>"
    footer.TextColor3 = MUTED
    footer.FontFace = fontMedium
    footer.TextSize = 15
    footer.TextWrapped = true
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.LayoutOrder = 8
    footer.ZIndex = 9003
    footer.Parent = keyPage

    local loadPage = Instance.new("CanvasGroup")
    loadPage.Name = "\0"
    loadPage.Size = UDim2.new(1, 0, 0, 0)
    loadPage.AutomaticSize = Enum.AutomaticSize.Y
    loadPage.Position = UDim2.new(0, 0, 0, 3)
    loadPage.BackgroundTransparency = 1
    loadPage.BorderSizePixel = 0
    loadPage.GroupTransparency = 1
    loadPage.Visible = false
    loadPage.ZIndex = 9002
    loadPage.Parent = card

    local loadPad = Instance.new("UIPadding")
    loadPad.PaddingTop = UDim.new(0, 26)
    loadPad.PaddingBottom = UDim.new(0, 26)
    loadPad.PaddingLeft = UDim.new(0, 28)
    loadPad.PaddingRight = UDim.new(0, 28)
    loadPad.Parent = loadPage

    local loadLayout = Instance.new("UIListLayout")
    loadLayout.Padding = UDim.new(0, 14)
    loadLayout.SortOrder = Enum.SortOrder.LayoutOrder
    loadLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    loadLayout.Parent = loadPage

    local loadTitle = Instance.new("TextLabel")
    loadTitle.Size = UDim2.new(1, 0, 0, 0)
    loadTitle.AutomaticSize = Enum.AutomaticSize.Y
    loadTitle.BackgroundTransparency = 1
    loadTitle.RichText = true
    loadTitle.Text = '<font color="rgb(240, 167, 51)">multy</font><font color="rgb(255,255,255)">hub</font>'
    loadTitle.FontFace = fontBold
    loadTitle.TextSize = 28
    loadTitle.TextXAlignment = Enum.TextXAlignment.Center
    loadTitle.LayoutOrder = 1
    loadTitle.ZIndex = 9003
    loadTitle.Parent = loadPage

    local loadStatus = Instance.new("TextLabel")
    loadStatus.Size = UDim2.new(1, 0, 0, 0)
    loadStatus.AutomaticSize = Enum.AutomaticSize.Y
    loadStatus.BackgroundTransparency = 1
    loadStatus.RichText = true
    loadStatus.Text = '<font color="rgb(120,200,110)">Key validated</font>'
    loadStatus.FontFace = fontBold
    loadStatus.TextSize = 16
    loadStatus.TextXAlignment = Enum.TextXAlignment.Center
    loadStatus.LayoutOrder = 2
    loadStatus.ZIndex = 9003
    loadStatus.Parent = loadPage

    local barTrack = Instance.new("Frame")
    barTrack.Size = UDim2.new(1, -16, 0, 6)
    barTrack.BackgroundColor3 = PANEL_2
    barTrack.BorderSizePixel = 0
    barTrack.ClipsDescendants = true
    barTrack.LayoutOrder = 3
    barTrack.ZIndex = 9003
    barTrack.Parent = loadPage

    makeCorner(barTrack, 3)

    local barPill = Instance.new("Frame")
    barPill.Size = UDim2.new(0.4, 0, 1, 0)
    barPill.Position = UDim2.new(0, 0, 0, 0)
    barPill.BackgroundColor3 = ACCENT
    barPill.BorderSizePixel = 0
    barPill.ZIndex = 9004
    barPill.Parent = barTrack

    makeCorner(barPill, 3)

    local loadMsg = Instance.new("TextLabel")
    loadMsg.Size = UDim2.new(1, 0, 0, 0)
    loadMsg.AutomaticSize = Enum.AutomaticSize.Y
    loadMsg.BackgroundTransparency = 1
    loadMsg.RichText = true
    loadMsg.Text = '<font color="rgb(178,178,185)">Loading the main script. This can take a while depending on your executor and device, especially on the first launch, please be patient.</font>\n\n<font color="rgb(130,130,138)">Do not exit the game.</font>'
    loadMsg.TextColor3 = MUTED
    loadMsg.FontFace = fontMedium
    loadMsg.TextSize = 15
    loadMsg.TextWrapped = true
    loadMsg.TextXAlignment = Enum.TextXAlignment.Center
    loadMsg.LayoutOrder = 4
    loadMsg.ZIndex = 9003
    loadMsg.Parent = loadPage

    local function hover(btn, normal, hovered)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
                BackgroundColor3 = hovered
            }):Play()
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
                BackgroundColor3 = normal
            }):Play()
        end)
    end

    hover(validateBtn, ACCENT, ACCENT_HOVER)
    hover(getKeyBtn, ACCENT, ACCENT_HOVER)
    hover(discordBtn, DISCORD, DISCORD_HOVER)
    hover(abortBtn, Color3.fromRGB(30, 30, 34), Color3.fromRGB(43, 43, 51))

    local TOP_BAR = 3

    local function pageHeight(page)
        local s = cardScale.Scale
        if s <= 0 then s = 1 end
        return page.AbsoluteSize.Y / s
    end

    local function setCardHeight(h)
        card.Size = UDim2.new(0, 430, 0, TOP_BAR + h)
    end

    local busy = false
    local closed = false
    local barConn = nil
    local cursorConn = nil

    local function setStatus(msg, color)
        statusLabel.Text = msg
        statusLabel.TextColor3 = color or MUTED
    end

    local function setBusy(state)
        busy = state
        validateBtn.Text = state and "Validating..." or "Validate Key"
        validateBtn.BackgroundTransparency = state and 0.15 or 0
    end

    local function stopBar()
        if barConn then
            pcall(function() barConn:Disconnect() end)
            barConn = nil
        end
    end

    local function startBar()
        if barConn then return end
        barConn = RunService.RenderStepped:Connect(function()
            local t = (os.clock() % 1.5) / 1.5
            local pp = t < 0.5 and t * 2 or 2 - t * 2
            pp = pp * pp * (3 - 2 * pp)
            barPill.Position = UDim2.new(pp * 0.6, 0, 0, 0)
        end)
    end

    cursorRefs()["keyui"] = true
    installCursorOverride()
    cursorConn = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not UserInputService.MouseIconEnabled then
                UserInputService.MouseIconEnabled = true
            end
            if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
        end)
    end)

    local function playExit(after)
        if closed then return end
        closed = true
        stopBar()
        if cursorConn then
            pcall(function() cursorConn:Disconnect() end)
            cursorConn = nil
        end
        cursorRefs()["keyui"] = nil

        TweenService:Create(backdrop, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { GroupTransparency = 1 }):Play()
        TweenService:Create(cardStroke, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Transparency = 1 }):Play()
        TweenService:Create(cardScale, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Scale = 0.97 }):Play()

        task.delay(0.24, function()
            pcall(function() gui:Destroy() end)
            if after then pcall(after) end
        end)
    end

    getgenv().MULTYHUB_KEYUI_DISMISS = function()
        playExit()
    end

    local function goToLoading()
        loadPage.Visible = true
        loadPage.GroupTransparency = 1
        task.wait()
        local loadH = pageHeight(loadPage)
        if loadH < 60 then loadH = 170 end
        loadPage.Visible = false

        TweenService:Create(keyPage, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { GroupTransparency = 1 }):Play()
        task.wait(0.22)
        keyPage.Visible = false

        task.wait(0.06)
        loadPage.Visible = true
        startBar()
        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 430, 0, TOP_BAR + loadH) }):Play()
        TweenService:Create(loadPage, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
        task.wait(0.32)
    end

    local function onValidated(key, edition)
        if closed then return end
        saveKey(edition, key)

        goToLoading()

        local fh = pageHeight(loadPage)
        if fh < 60 then fh = 170 end
        setCardHeight(fh)
        keyPage.Visible = false
        keyPage.GroupTransparency = 1
        loadPage.Visible = true
        loadPage.GroupTransparency = 0

        task.wait()

        getgenv().MULTYHUB_KEYUI_EDITION = edition.id
        getgenv().SCRIPT_KEY = key
    end

    local function tryValidate(key, file)
        if busy or closed then return "stop" end

        key = trimKey(key)

        if #key < 1 then
            setStatus("Please enter your key first.", ERROR)
            return "failed"
        end

        setBusy(true)
        setStatus("Checking your key...", Color3.fromRGB(200, 200, 210))

        local result = resolveKey(key)

        if result.kind == "network" then
            setStatus("Network error. Please try again.", ERROR)
            setBusy(false)
            return "stop"
        end

        if result.kind == "valid" then
            local wrongBuild = LOCK and result.edition ~= LOCK
            if wrongBuild or result.edition.offline then
                saveKey(result.edition, key)
                if file and file ~= result.edition.keyFile then
                    forgetKey(file, key)
                end
                if wrongBuild then
                    setStatus("That is a " .. string.lower(result.edition.label) .. " key. Paste your "
                        .. LOCK.keyName .. " to switch, or press Abort.", ERROR)
                    if file then
                        inputBox.Text = ""
                    end
                else
                    setStatus(result.edition.message
                        or ("The " .. string.lower(result.edition.label) .. " version is offline right now."), WARNING)
                end
                setBusy(false)
                return "failed"
            end
            if file and file ~= result.edition.keyFile then
                forgetKey(file, key)
            end
            setBusy(false)
            onValidated(key, result.edition)
            return "valid"
        end

        if result.kind == "retry" then
            setStatus((ERROR_MESSAGES[result.code] or "Temporary error") .. " Retrying in 10s...", WARNING)
            validateBtn.Text = "Waiting..."

            task.spawn(function()
                task.wait(10)
                busy = false
                tryValidate(key, file)
            end)

            return "stop"
        end

        if result.code == "KEY_BANNED" then
            setStatus("This key is blacklisted.", ERROR)
            getgenv().MULTYHUB_KEYUI_DISMISS = nil
            playExit(function()
                pcall(function()
                    game.Players.LocalPlayer:Kick("Key blacklisted")
                end)
            end)
            return "stop"
        end

        if result.code ~= "KEY_HWID_LOCKED" then
            forgetKeyEverywhere(key)
        end
        setStatus(errorMessage(result.code, result.edition, result.message), ERROR)
        setBusy(false)
        return "failed"
    end

    validateBtn.MouseButton1Click:Connect(function()
        tryValidate(inputBox.Text)
    end)

    local copyGen = {}
    local function copyFeedback(btn, label, url)
        pcall(function() setclipboard(url) end)
        copyGen[btn] = (copyGen[btn] or 0) + 1
        local gen = copyGen[btn]
        btn.Text = "Copied!"
        task.delay(1.5, function()
            if copyGen[btn] == gen and not closed then
                pcall(function() btn.Text = label end)
            end
        end)
    end

    getKeyBtn.MouseButton1Click:Connect(function()
        copyFeedback(getKeyBtn, "Get Key", PAYMENT_URL)
    end)

    discordBtn.MouseButton1Click:Connect(function()
        copyFeedback(discordBtn, "Discord", DISCORD_INVITE)
    end)

    abortBtn.MouseButton1Click:Connect(function()
        getgenv().UI_CLOSED = true
        getgenv().MULTYHUB_KEYUI_DISMISS = nil
        playExit()
    end)

    task.wait()
    task.wait()

    local keyH = pageHeight(keyPage)
    if keyH < 60 then keyH = 360 end
    setCardHeight(keyH)
    cardScale.Scale = 0.94

    TweenService:Create(backdrop, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundTransparency = 0.35 }):Play()
    TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
    TweenService:Create(cardStroke, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 0 }):Play()
    TweenService:Create(cardScale, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

    task.delay(240, function()
        if closed then return end
        if getgenv().SCRIPT_KEY then
            playExit()
        end
    end)

    local saved = savedKeys(LOCK and { LOCK } or ORDER)
    if #saved > 0 then
        inputBox.Text = saved[1].key
        setStatus("Saved key found. Validating automatically...", Color3.fromRGB(200, 200, 210))

        task.spawn(function()
            task.wait(0.5)
            for _, entry in ipairs(saved) do
                if closed then return end
                inputBox.Text = entry.key
                if tryValidate(entry.key, entry.file) ~= "failed" then
                    return
                end
            end
        end)
    end

    while not getgenv().SCRIPT_KEY and not getgenv().UI_CLOSED do
        task.wait(0.1)
    end

    return getgenv().SCRIPT_KEY
end
