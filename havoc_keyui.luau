local api=loadstring(game:HttpGet(
'https://sdkapi-public.luarmor.net/library.lua'))()api.script_id=
'b72cb788dfef6ec345fb57e66eedcd0d'local TweenService=game:GetService(
'TweenService')local CoreGui=game:GetService('CoreGui')local ACCENT=Color3.
fromRGB(240,167,51)local ACCENT_HOVER=Color3.fromRGB(250,182,74)local DISCORD=
Color3.fromRGB(40,40,44)local DISCORD_HOVER=Color3.fromRGB(52,52,58)local BG=
Color3.fromRGB(14,14,16)local PANEL=Color3.fromRGB(20,20,24)local PANEL_2=Color3
.fromRGB(24,24,28)local STROKE=Color3.fromRGB(23,23,29)local STROKE_2=Color3.
fromRGB(34,34,40)local TEXT=Color3.fromRGB(230,230,235)local MUTED=Color3.
fromRGB(145,145,150)local ERROR=Color3.fromRGB(235,80,95)local SUCCESS=Color3.
fromRGB(120,200,110)local WARNING=Color3.fromRGB(235,180,80)local KEY_FILE=
'havoc_key.txt'local DISCORD_INVITE='https://discord.gg/UPRtgK6tEJ'local
fontBold,fontMedium local fontOk=pcall(function()fontBold=Font.new(
getcustomasset('SemiBold.font'),Enum.FontWeight.Regular,Enum.FontStyle.Normal)
fontMedium=Font.new(getcustomasset('Medium.font'),Enum.FontWeight.Regular,Enum.
FontStyle.Normal)end)if not fontOk then fontBold=Font.fromEnum(Enum.Font.
GothamBold)fontMedium=Font.fromEnum(Enum.Font.GothamMedium)end local hasFS=
pcall(function()return type(writefile)=='function'and type(readfile)=='function'
and type(isfile)=='function'end)local function loadSavedKey()if not hasFS then
return nil end local ok,data=pcall(function()if isfile(KEY_FILE)then return
readfile(KEY_FILE)end end)if ok and data and#data>0 then return data end return
nil end local function saveKey(key)if not hasFS then return end pcall(function()
writefile(KEY_FILE,key)end)end local function deleteSavedKey()if not hasFS then
return end pcall(function()if isfile(KEY_FILE)then delfile(KEY_FILE)end end)end
local ERROR_MESSAGES={KEY_INCORRECT='Key not found or deleted.',KEY_INVALID=
'Key is in an invalid format.',KEY_EXPIRED=
[[This key has expired. Ask staff on Discord for a new beta key.]],KEY_BANNED=
'This key is blacklisted.',KEY_HWID_LOCKED=
[[Key is locked to a different HWID. Reset it with our Discord bot.]],
SCRIPT_ID_INCORRECT='Script configuration error. Contact staff.',
SCRIPT_ID_INVALID='Script configuration error. Contact staff.',INVALID_EXECUTOR=
'Your executor is not supported.',SECURITY_ERROR=
'Security check failed. Try again.',TIME_ERROR=
'System clock is off. Fix your time and retry.',UNKNOWN_ERROR=
'Server error. Please try again shortly.',ERROR=
'Network error. Please try again.'}local function makeCorner(parent,radius)local
corner=Instance.new('UICorner')corner.CornerRadius=UDim.new(0,radius)corner.
Parent=parent return corner end local function makeStroke(parent,color,thickness
)local stroke=Instance.new('UIStroke')stroke.Color=color stroke.Thickness=
thickness or 1 stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border stroke.Parent=
parent return stroke end local function makeButton(parent,text,color,textColor)
local btn=Instance.new('TextButton')btn.Size=UDim2.new(1,0,1,0)btn.
BackgroundColor3=color btn.BorderSizePixel=0 btn.Text=text btn.TextColor3=
textColor or Color3.fromRGB(15,15,20)btn.FontFace=fontBold btn.TextSize=16 btn.
AutoButtonColor=false btn.ZIndex=9005 btn.Parent=parent makeCorner(btn,7)return
btn end local result=(function()getgenv().SCRIPT_KEY=nil getgenv().UI_CLOSED=
false if type(getgenv().MULTYHUB_KEYUI_DISMISS)=='function'then pcall(getgenv().
MULTYHUB_KEYUI_DISMISS)end getgenv().MULTYHUB_KEYUI_DISMISS=nil local RunService
=game:GetService('RunService')local UserInputService=game:GetService(
'UserInputService')local function cursorRefs()local g=(type(getgenv)=='function'
and getgenv())or _G g.MULTYHUB_CURSOR_REFS=g.MULTYHUB_CURSOR_REFS or{}return g.
MULTYHUB_CURSOR_REFS end local function installCursorOverride()local g=(type(
getgenv)=='function'and getgenv())or _G if g.MULTYHUB_CURSOR_HOOKED then return
end local in_havoc=false pcall(function()in_havoc=game.GameId==4827308727 end)if
not in_havoc then return end if type(getgc)~='function'then return end local
proto pcall(function()for _,v in next,getgc(true)do if type(v)=='table'and
rawget(v,'__index')==v and type(rawget(v,'Update'))=='function'and type(rawget(v
,'_update'))=='function'and type(rawget(v,'SetBlockedPosition'))=='function'and
type(rawget(v,'new'))=='function'then proto=v break end end end)if not proto
then return end local old_update=proto.Update local wrap=(type(newcclosure)==
'function'and newcclosure)or function(f)return f end proto.Update=wrap(function(
self,...)old_update(self,...)local refs=rawget(g,'MULTYHUB_CURSOR_REFS')if refs
and next(refs)~=nil then pcall(function()UserInputService.MouseIconEnabled=true
UserInputService.MouseBehavior=Enum.MouseBehavior.Default end)end end)g.
MULTYHUB_CURSOR_HOOKED=true end local gui=Instance.new('ScreenGui')gui.Name='\0'
gui.Parent=CoreGui gui.ZIndexBehavior=Enum.ZIndexBehavior.Global gui.
IgnoreGuiInset=true local backdrop=Instance.new('Frame')backdrop.Name='\0'
backdrop.Size=UDim2.new(1,0,1,0)backdrop.BackgroundColor3=Color3.fromRGB(0,0,0)
backdrop.BackgroundTransparency=1 backdrop.BorderSizePixel=0 backdrop.ZIndex=
9000 backdrop.Parent=gui local card=Instance.new('CanvasGroup')card.Name='\0'
card.Size=UDim2.new(0,430,0,140)card.Position=UDim2.new(0.5,0,0.5,0)card.
AnchorPoint=Vector2.new(0.5,0.5)card.BackgroundColor3=BG card.BorderSizePixel=0
card.GroupTransparency=1 card.ZIndex=9001 card.Parent=gui makeCorner(card,10)
local cardStroke=makeStroke(card,STROKE,1)cardStroke.Transparency=1 local
cardScale=Instance.new('UIScale')cardScale.Scale=1 cardScale.Parent=card local
topClip=Instance.new('Frame')topClip.Name='\0'topClip.Size=UDim2.new(1,0,0,3)
topClip.Position=UDim2.new(0,0,0,0)topClip.BackgroundTransparency=1 topClip.
BorderSizePixel=0 topClip.ClipsDescendants=true topClip.ZIndex=9004 topClip.
Parent=card local topBar=Instance.new('Frame')topBar.Name='\0'topBar.Size=UDim2.
new(1,0,0,20)topBar.Position=UDim2.new(0,0,0,0)topBar.BackgroundColor3=ACCENT
topBar.BorderSizePixel=0 topBar.ZIndex=9004 topBar.Parent=topClip makeCorner(
topBar,10)local keyPage=Instance.new('CanvasGroup')keyPage.Name='\0'keyPage.Size
=UDim2.new(1,0,0,0)keyPage.AutomaticSize=Enum.AutomaticSize.Y keyPage.Position=
UDim2.new(0,0,0,3)keyPage.BackgroundTransparency=1 keyPage.BorderSizePixel=0
keyPage.GroupTransparency=0 keyPage.ZIndex=9002 keyPage.Parent=card local
padding=Instance.new('UIPadding')padding.PaddingTop=UDim.new(0,18)padding.
PaddingBottom=UDim.new(0,20)padding.PaddingLeft=UDim.new(0,22)padding.
PaddingRight=UDim.new(0,22)padding.Parent=keyPage local layout=Instance.new(
'UIListLayout')layout.Padding=UDim.new(0,11)layout.SortOrder=Enum.SortOrder.
LayoutOrder layout.HorizontalAlignment=Enum.HorizontalAlignment.Center layout.
Parent=keyPage local title=Instance.new('TextLabel')title.Size=UDim2.new(1,0,0,0
)title.AutomaticSize=Enum.AutomaticSize.Y title.BackgroundTransparency=1 title.
RichText=true title.Text=
[[<font color="rgb(240, 167, 51)">multy</font><font color="rgb(255,255,255)">hub</font>]]
title.FontFace=fontBold title.TextSize=28 title.TextXAlignment=Enum.
TextXAlignment.Center title.LayoutOrder=1 title.ZIndex=9003 title.Parent=keyPage
local subtitle=Instance.new('TextLabel')subtitle.Size=UDim2.new(1,0,0,0)subtitle
.AutomaticSize=Enum.AutomaticSize.Y subtitle.BackgroundTransparency=1 subtitle.
RichText=true subtitle.Text='<font color="rgb(205,205,215)">Havoc</font>'
subtitle.FontFace=fontMedium subtitle.TextSize=16 subtitle.TextXAlignment=Enum.
TextXAlignment.Center subtitle.LayoutOrder=2 subtitle.ZIndex=9003 subtitle.
Parent=keyPage local betaBox=Instance.new('Frame')betaBox.Size=UDim2.new(1,0,0,
72)betaBox.BackgroundColor3=PANEL betaBox.BorderSizePixel=0 betaBox.LayoutOrder=
3 betaBox.ZIndex=9003 betaBox.Parent=keyPage makeCorner(betaBox,8)makeStroke(
betaBox,STROKE_2,1)local betaTitle=Instance.new('TextLabel')betaTitle.Size=UDim2
.new(1,-24,0,28)betaTitle.Position=UDim2.new(0,12,0,10)betaTitle.
BackgroundTransparency=1 betaTitle.RichText=true betaTitle.Text=
[[<font color="rgb(240,167,51)">Public Beta</font> - Free Access]]betaTitle.
TextColor3=TEXT betaTitle.FontFace=fontBold betaTitle.TextSize=18 betaTitle.
TextXAlignment=Enum.TextXAlignment.Center betaTitle.ZIndex=9004 betaTitle.Parent
=betaBox local betaInfo=Instance.new('TextLabel')betaInfo.Size=UDim2.new(1,-24,0
,24)betaInfo.Position=UDim2.new(0,12,0,38)betaInfo.BackgroundTransparency=1
betaInfo.Text=
[[Invite-only beta. Keys are handed out by staff on our Discord below.]]betaInfo
.TextColor3=MUTED betaInfo.FontFace=fontMedium betaInfo.TextSize=14 betaInfo.
TextWrapped=true betaInfo.TextXAlignment=Enum.TextXAlignment.Center betaInfo.
ZIndex=9004 betaInfo.Parent=betaBox local statusLabel=Instance.new('TextLabel')
statusLabel.Size=UDim2.new(1,0,0,0)statusLabel.AutomaticSize=Enum.AutomaticSize.
Y statusLabel.BackgroundTransparency=1 statusLabel.Text=
'Enter your key below to continue.'statusLabel.TextColor3=MUTED statusLabel.
FontFace=fontMedium statusLabel.TextSize=15 statusLabel.TextWrapped=true
statusLabel.TextXAlignment=Enum.TextXAlignment.Center statusLabel.LayoutOrder=4
statusLabel.ZIndex=9003 statusLabel.Parent=keyPage local inputFrame=Instance.
new('Frame')inputFrame.Size=UDim2.new(1,0,0,40)inputFrame.BackgroundColor3=
PANEL_2 inputFrame.BorderSizePixel=0 inputFrame.LayoutOrder=5 inputFrame.ZIndex=
9003 inputFrame.Parent=keyPage makeCorner(inputFrame,7)local inputStroke=
makeStroke(inputFrame,STROKE_2,1)local inputBox=Instance.new('TextBox')inputBox.
Size=UDim2.new(1,-18,1,0)inputBox.Position=UDim2.new(0,9,0,0)inputBox.
BackgroundTransparency=1 inputBox.Text=''inputBox.PlaceholderText=
'Paste your beta key here...'inputBox.PlaceholderColor3=Color3.fromRGB(95,95,110
)inputBox.TextColor3=TEXT inputBox.FontFace=fontMedium inputBox.TextSize=16
inputBox.TextXAlignment=Enum.TextXAlignment.Left inputBox.ClearTextOnFocus=false
inputBox.ZIndex=9004 inputBox.Parent=inputFrame inputBox.Focused:Connect(
function()TweenService:Create(inputStroke,TweenInfo.new(0.15),{Color=ACCENT}):
Play()end)inputBox.FocusLost:Connect(function()TweenService:Create(inputStroke,
TweenInfo.new(0.15),{Color=STROKE_2}):Play()end)local validateRow=Instance.new(
'Frame')validateRow.Size=UDim2.new(1,0,0,36)validateRow.BackgroundTransparency=1
validateRow.LayoutOrder=6 validateRow.ZIndex=9003 validateRow.Parent=keyPage
local validateBtn=makeButton(validateRow,'Validate Key',ACCENT,Color3.fromRGB(
255,255,255))local buttonRow=Instance.new('Frame')buttonRow.Size=UDim2.new(1,0,0
,36)buttonRow.BackgroundTransparency=1 buttonRow.LayoutOrder=7 buttonRow.ZIndex=
9003 buttonRow.Parent=keyPage local buttonLayout=Instance.new('UIListLayout')
buttonLayout.FillDirection=Enum.FillDirection.Horizontal buttonLayout.Padding=
UDim.new(0,10)buttonLayout.SortOrder=Enum.SortOrder.LayoutOrder buttonLayout.
HorizontalAlignment=Enum.HorizontalAlignment.Center buttonLayout.Parent=
buttonRow local discordHolder=Instance.new('Frame')discordHolder.Size=UDim2.new(
0.5,-5,1,0)discordHolder.BackgroundTransparency=1 discordHolder.LayoutOrder=1
discordHolder.Parent=buttonRow local abortHolder=Instance.new('Frame')
abortHolder.Size=UDim2.new(0.5,-5,1,0)abortHolder.BackgroundTransparency=1
abortHolder.LayoutOrder=2 abortHolder.Parent=buttonRow local discordBtn=
makeButton(discordHolder,'Discord',DISCORD,Color3.fromRGB(230,230,235))local
abortBtn=makeButton(abortHolder,'Abort',Color3.fromRGB(30,30,34),Color3.fromRGB(
205,205,215))makeStroke(abortBtn,Color3.fromRGB(40,40,46),1)local footer=
Instance.new('TextLabel')footer.Size=UDim2.new(1,0,0,0)footer.AutomaticSize=Enum
.AutomaticSize.Y footer.BackgroundTransparency=1 footer.RichText=true footer.
Text=
[[<font color="rgb(120,120,130)">Havoc is in public beta. Access is by invite - request a key from staff on our Discord.</font>]]
footer.TextColor3=MUTED footer.FontFace=fontMedium footer.TextSize=15 footer.
TextWrapped=true footer.TextXAlignment=Enum.TextXAlignment.Center footer.
LayoutOrder=8 footer.ZIndex=9003 footer.Parent=keyPage local loadPage=Instance.
new('CanvasGroup')loadPage.Name='\0'loadPage.Size=UDim2.new(1,0,0,0)loadPage.
AutomaticSize=Enum.AutomaticSize.Y loadPage.Position=UDim2.new(0,0,0,3)loadPage.
BackgroundTransparency=1 loadPage.BorderSizePixel=0 loadPage.GroupTransparency=1
loadPage.Visible=false loadPage.ZIndex=9002 loadPage.Parent=card local loadPad=
Instance.new('UIPadding')loadPad.PaddingTop=UDim.new(0,26)loadPad.PaddingBottom=
UDim.new(0,26)loadPad.PaddingLeft=UDim.new(0,28)loadPad.PaddingRight=UDim.new(0,
28)loadPad.Parent=loadPage local loadLayout=Instance.new('UIListLayout')
loadLayout.Padding=UDim.new(0,14)loadLayout.SortOrder=Enum.SortOrder.LayoutOrder
loadLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center loadLayout.Parent
=loadPage local loadTitle=Instance.new('TextLabel')loadTitle.Size=UDim2.new(1,0,
0,0)loadTitle.AutomaticSize=Enum.AutomaticSize.Y loadTitle.
BackgroundTransparency=1 loadTitle.RichText=true loadTitle.Text=
[[<font color="rgb(240, 167, 51)">multy</font><font color="rgb(255,255,255)">hub</font>]]
loadTitle.FontFace=fontBold loadTitle.TextSize=28 loadTitle.TextXAlignment=Enum.
TextXAlignment.Center loadTitle.LayoutOrder=1 loadTitle.ZIndex=9003 loadTitle.
Parent=loadPage local loadStatus=Instance.new('TextLabel')loadStatus.Size=UDim2.
new(1,0,0,0)loadStatus.AutomaticSize=Enum.AutomaticSize.Y loadStatus.
BackgroundTransparency=1 loadStatus.RichText=true loadStatus.Text=
'<font color="rgb(120,200,110)">Key validated</font>'loadStatus.FontFace=
fontBold loadStatus.TextSize=16 loadStatus.TextXAlignment=Enum.TextXAlignment.
Center loadStatus.LayoutOrder=2 loadStatus.ZIndex=9003 loadStatus.Parent=
loadPage local barTrack=Instance.new('Frame')barTrack.Size=UDim2.new(1,-16,0,6)
barTrack.BackgroundColor3=PANEL_2 barTrack.BorderSizePixel=0 barTrack.
ClipsDescendants=true barTrack.LayoutOrder=3 barTrack.ZIndex=9003 barTrack.
Parent=loadPage makeCorner(barTrack,3)local barPill=Instance.new('Frame')barPill
.Size=UDim2.new(0.4,0,1,0)barPill.Position=UDim2.new(0,0,0,0)barPill.
BackgroundColor3=ACCENT barPill.BorderSizePixel=0 barPill.ZIndex=9004 barPill.
Parent=barTrack makeCorner(barPill,3)local loadMsg=Instance.new('TextLabel')
loadMsg.Size=UDim2.new(1,0,0,0)loadMsg.AutomaticSize=Enum.AutomaticSize.Y
loadMsg.BackgroundTransparency=1 loadMsg.RichText=true loadMsg.Text=
[[<font color="rgb(178,178,185)">Loading the main script. This can take a while depending on your executor and device, especially on the first launch, please be patient.</font>

<font color="rgb(130,130,138)">Do not exit the game.</font>]]
loadMsg.TextColor3=MUTED loadMsg.FontFace=fontMedium loadMsg.TextSize=15 loadMsg
.TextWrapped=true loadMsg.TextXAlignment=Enum.TextXAlignment.Center loadMsg.
LayoutOrder=4 loadMsg.ZIndex=9003 loadMsg.Parent=loadPage local function hover(
btn,normal,hovered)btn.MouseEnter:Connect(function()TweenService:Create(btn,
TweenInfo.new(0.15,Enum.EasingStyle.Quint),{BackgroundColor3=hovered}):Play()end
)btn.MouseLeave:Connect(function()TweenService:Create(btn,TweenInfo.new(0.15,
Enum.EasingStyle.Quint),{BackgroundColor3=normal}):Play()end)end hover(
validateBtn,ACCENT,ACCENT_HOVER)hover(discordBtn,DISCORD,DISCORD_HOVER)hover(
abortBtn,Color3.fromRGB(30,30,34),Color3.fromRGB(43,43,51))local TOP_BAR=3 local 
function pageHeight(page)local s=cardScale.Scale if s<=0 then s=1 end return
page.AbsoluteSize.Y/s end local function setCardHeight(h)card.Size=UDim2.new(0,
430,0,TOP_BAR+h)end local busy=false local closed=false local barConn=nil local
cursorConn=nil local function setStatus(msg,color)statusLabel.Text=msg
statusLabel.TextColor3=color or MUTED end local function setBusy(state)busy=
state validateBtn.Text=state and'Validating...'or'Validate Key'validateBtn.
BackgroundTransparency=state and 0.15 or 0 end local function stopBar()if
barConn then pcall(function()barConn:Disconnect()end)barConn=nil end end local 
function startBar()if barConn then return end barConn=RunService.RenderStepped:
Connect(function()local t=(os.clock()%1.5)/1.5 local pp=t<0.5 and t*2 or 2-t*2
pp=pp*pp*(3-2*pp)barPill.Position=UDim2.new(pp*0.6,0,0,0)end)end cursorRefs()[
'keyui']=true installCursorOverride()cursorConn=RunService.RenderStepped:
Connect(function()pcall(function()if not UserInputService.MouseIconEnabled then
UserInputService.MouseIconEnabled=true end if UserInputService.MouseBehavior~=
Enum.MouseBehavior.Default then UserInputService.MouseBehavior=Enum.
MouseBehavior.Default end end)end)local function playExit(after)if closed then
return end closed=true stopBar()if cursorConn then pcall(function()cursorConn:
Disconnect()end)cursorConn=nil end cursorRefs()['keyui']=nil TweenService:
Create(backdrop,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.
In),{BackgroundTransparency=1}):Play()TweenService:Create(card,TweenInfo.new(
0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{GroupTransparency=1}):
Play()TweenService:Create(cardStroke,TweenInfo.new(0.22,Enum.EasingStyle.Quint,
Enum.EasingDirection.In),{Transparency=1}):Play()TweenService:Create(cardScale,
TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Scale=0.97})
:Play()task.delay(0.24,function()pcall(function()gui:Destroy()end)if after then
pcall(after)end end)end getgenv().MULTYHUB_KEYUI_DISMISS=function()playExit()end
local function goToLoading()loadPage.Visible=true loadPage.GroupTransparency=1
task.wait()local loadH=pageHeight(loadPage)if loadH<60 then loadH=170 end
loadPage.Visible=false TweenService:Create(keyPage,TweenInfo.new(0.2,Enum.
EasingStyle.Quint,Enum.EasingDirection.Out),{GroupTransparency=1}):Play()task.
wait(0.22)keyPage.Visible=false task.wait(0.06)loadPage.Visible=true startBar()
TweenService:Create(card,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out),{Size=UDim2.new(0,430,0,TOP_BAR+loadH)}):Play()TweenService
:Create(loadPage,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.
Out),{GroupTransparency=0}):Play()task.wait(0.32)end local function onValidated(
key)if closed then return end saveKey(key)goToLoading()local fh=pageHeight(
loadPage)if fh<60 then fh=170 end setCardHeight(fh)keyPage.Visible=false keyPage
.GroupTransparency=1 loadPage.Visible=true loadPage.GroupTransparency=0 task.
wait()getgenv().SCRIPT_KEY=key end local function tryValidate(key)if busy or
closed then return end key=tostring(key or''):gsub('^%s+',''):gsub('%s+$','')if#
key<1 then setStatus('Please enter your key first.',ERROR)return end setBusy(
true)setStatus('Checking your key...',Color3.fromRGB(200,200,210))local ok,
status=pcall(function()return api.check_key(key)end)if not ok or type(status)~=
'table'then setStatus('Network error. Please try again.',ERROR)setBusy(false)
return end if status.code=='KEY_VALID'then setBusy(false)onValidated(key)return
end local errCode=status.code or'ERROR'local errMsg=ERROR_MESSAGES[errCode]or
tostring(status.message or errCode)if errCode=='KEY_BANNED'then setStatus(
'This key is blacklisted.',ERROR)getgenv().MULTYHUB_KEYUI_DISMISS=nil playExit(
function()pcall(function()game.Players.LocalPlayer:Kick('Key blacklisted')end)
end)return end if errCode=='UNKNOWN_ERROR'or errCode=='SECURITY_ERROR'or errCode
=='TIME_ERROR'then setStatus((ERROR_MESSAGES[errCode]or'Temporary error')..
' Retrying in 10s...',WARNING)validateBtn.Text='Waiting...'task.spawn(function()
task.wait(10)busy=false tryValidate(key)end)return end if errCode~=
'KEY_HWID_LOCKED'then deleteSavedKey()end setStatus(errMsg,ERROR)setBusy(false)
end validateBtn.MouseButton1Click:Connect(function()tryValidate(inputBox.Text)
end)local copyGen={}local function copyFeedback(btn,label,url)pcall(function()
setclipboard(url)end)copyGen[btn]=(copyGen[btn]or 0)+1 local gen=copyGen[btn]btn
.Text='Copied!'task.delay(1.5,function()if copyGen[btn]==gen and not closed then
pcall(function()btn.Text=label end)end end)end discordBtn.MouseButton1Click:
Connect(function()copyFeedback(discordBtn,'Discord',DISCORD_INVITE)end)abortBtn.
MouseButton1Click:Connect(function()getgenv().UI_CLOSED=true getgenv().
MULTYHUB_KEYUI_DISMISS=nil playExit()end)task.wait()task.wait()local keyH=
pageHeight(keyPage)if keyH<60 then keyH=360 end setCardHeight(keyH)cardScale.
Scale=0.94 TweenService:Create(backdrop,TweenInfo.new(0.25,Enum.EasingStyle.
Quint,Enum.EasingDirection.Out),{BackgroundTransparency=0.35}):Play()
TweenService:Create(card,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.
EasingDirection.Out),{GroupTransparency=0}):Play()TweenService:Create(cardStroke
,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
Transparency=0}):Play()TweenService:Create(cardScale,TweenInfo.new(0.34,Enum.
EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()task.delay(240,
function()if closed then return end if getgenv().SCRIPT_KEY then playExit()end
end)local savedKey=loadSavedKey()if savedKey then inputBox.Text=savedKey
setStatus('Saved key found. Validating automatically...',Color3.fromRGB(200,200,
210))task.spawn(function()task.wait(0.5)tryValidate(savedKey)end)end while not
getgenv().SCRIPT_KEY and not getgenv().UI_CLOSED do task.wait(0.1)end return
getgenv().SCRIPT_KEY end)()if not result then return end