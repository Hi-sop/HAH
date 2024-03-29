HAH = LibStub("AceAddon-3.0"):NewAddon("HAH", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
GUI = LibStub("AceGUI-3.0")
local mainTab

local defaults = {
	char = {
		['*'] = {
			['*'] = {
				itemTexture = nil, 
				itemTooltip = nil, --클릭가능한 "[]" 형태의 이름
				itemLink = nil, --아이템ID
				price = 0
			},
		},
		tradeHis = {
			['*'] = {
				serverTime = nil,
				targetName = nil,
				itemLink = {},
				price = 0
			},
		},
	}	
}

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function HAH:calculator(named, container)
		local frame = GUI:Create("Label")
		local str = ""
		local temp = 0

		local i = 1
		for key, adr in next, self.db.char[named], nil do
			if 6 < i then
				break
			end
			
			if i ~= 1 then
				str = str.."   +   "
			end
			str = str..comma_value(adr.price)
			temp = temp + tonumber(adr.price)	
			i = i + 1
		end
		str = str.."   =   "..comma_value(temp)

		frame:SetText(str)
		frame:SetFont(STANDARD_TEXT_FONT, 14, "")
		frame:SetWidth(650)
		container:AddChild(frame)
		gold[named] = temp
		total = total + temp
	end

function HAH:statistics(container)
	container:ReleaseChildren()
	statistics_container = container
	total = 0

	local header1 = GUI:Create("SFX-Header-II")
	local header2 = GUI:Create("SFX-Header-II")
	local header3 = GUI:Create("SFX-Header-II")
	local header4 = GUI:Create("SFX-Header-II")
	local header5 = GUI:Create("SFX-Header-II")
	local header6 = GUI:Create("SFX-Header-II")
	local header7 = GUI:Create("SFX-Header-II")
	local header8 = GUI:Create("SFX-Header-II")
	local header9 = GUI:Create("SFX-Header-II")


	header1:SetText("1. 카자라")
	container:AddChild(header1)
	HAH:calculator("named1", container)
	
	header2:SetText("2. 융합체")
	container:AddChild(header2)
	HAH:calculator("named2", container)
	
	header3:SetText("3. 잊힌 실험체")
	container:AddChild(header3)
	HAH:calculator("named3", container)
	
	header4:SetText("4. 자칼리")
	container:AddChild(header4)
	HAH:calculator("named4", container)
	
	header5:SetText("5. 라소크")
	container:AddChild(header5)
	HAH:calculator("named5", container)
	
	header6:SetText("6. 지스카른")
	container:AddChild(header6)
	HAH:calculator("named6", container)
	
	header7:SetText("7. 마그모락스")
	container:AddChild(header7)
	HAH:calculator("named7", container)
	
	header8:SetText("8. 넬타리온")
	container:AddChild(header8)
	HAH:calculator("named8", container)
	
	header9:SetText("9. 사카레스")
	container:AddChild(header9)
	HAH:calculator("named9", container)
	
	local blink = GUI:Create("SFX-Header-II")
	container:AddChild(blink)

	local totalFrame = GUI:Create("Label")
	totalFrame:SetText("총 골드 : "..comma_value(total))
	totalFrame:SetFont(STANDARD_TEXT_FONT, 16, "")
	totalFrame:SetWidth(400)
	
	container:AddChild(totalFrame)
	
	local heacountbox = GUI:Create("EditBox")
	heacountbox:SetWidth(100)
	heacountbox:SetRelativeWidth(0.3)
	heacountbox:SetLabel("분배 인원 : "..headcount)
	heacountbox:SetCallback("OnEnterPressed",
		function(widget, event, text)
			if tonumber(text) == nil then
				return
			end
			headcount = tonumber(text)
			HAH:statistics(container)
		end)
	container:AddChild(heacountbox)
	
	local allotment = GUI:Create("Label")
	allotment:SetText("1인당 분배금 : "..comma_value(total / headcount))
	allotment:SetFont(STANDARD_TEXT_FONT, 16, "")
	allotment:SetWidth(400)
	container:AddChild(allotment)
	
	local allotment_party = GUI:Create("Label")
	allotment_party:SetText("파티당(x5) : "..comma_value((total / headcount) * 5))
	allotment_party:SetFont(STANDARD_TEXT_FONT, 16, "")
	allotment_party:SetWidth(400)
	container:AddChild(allotment_party)
	
	local refresh = GUI:Create("Button")
	refresh:SetText("RL")
	refresh:SetWidth(50)
	container:AddChild(refresh)
	refresh:SetCallback("OnClick",
	function(widget)
		HAH:statistics(container)
	end)
	
	local resetButton = GUI:Create("Button")
	resetButton:SetText("Reset")
	resetButton:SetWidth(100)
	container:AddChild(resetButton)
	resetButton:SetCallback("OnClick",
	function(widget)
		StaticPopup_Show("resetPopup")
	end)

	local reportButton = GUI:Create("Button")
	reportButton:SetText("Report")
	reportButton:SetWidth(100)
	container:AddChild(reportButton)
	reportButton:SetCallback("OnClick",
	function(widget)
		StaticPopup_Show("reportPopup")
	end)
end

function HAH:MainPanel()
	headcount = 1
	gold = {}
	total = 0

	StaticPopupDialogs["resetPopup"] = {
		text = "모든 데이터가 초기화됩니다",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			local temp = HAH_DB.minimapPos
			self.db:ResetDB()
			HAH_DB.minimapPos = temp
			HAH:statistics(statistics_container)
			HAH:UpdateRemotePanel(remoteinfo.named, remoteinfo.container, remoteinfo.headertex)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}

	StaticPopupDialogs["reportPopup"] = {
		text = "*주의* 채팅창에 결과를 보고합니다.",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			if UnitIsGroupLeader("player") then
				SendChatMessage(
					"1넴 : "..comma_value(gold["named1"]).." + ".."2넴 : "..comma_value(gold["named2"]).." + "..
					"3넴 : "..comma_value(gold["named3"]).." + ".."4넴 : "..comma_value(gold["named4"]).." + "..
					"5넴 : "..comma_value(gold["named5"]).." + ".."6넴 : "..comma_value(gold["named6"]).." + "..
					"7넴 : "..comma_value(gold["named7"]).." + ".."8넴 : "..comma_value(gold["named8"]).." + "..
					"8넴 : "..comma_value(gold["named9"]).." = "..comma_value(total), 
					"RAID")
				SendChatMessage("총 "..comma_value(total).." / 분배인원 "..headcount.."명 = "..comma_value(total / headcount), "RAID")
			else
				SendChatMessage(
					"1넴 : "..comma_value(gold["named1"]).." + ".."2넴 : "..comma_value(gold["named2"]).." + "..
					"3넴 : "..comma_value(gold["named3"]).." + ".."4넴 : "..comma_value(gold["named4"]).." + "..
					"5넴 : "..comma_value(gold["named5"]).." + ".."6넴 : "..comma_value(gold["named6"]).." + "..
					"7넴 : "..comma_value(gold["named7"]).." + ".."8넴 : "..comma_value(gold["named8"]).." + "..
					"9넴 : "..comma_value(gold["named9"]).." = "..comma_value(total), 
					"PARTY")
				SendChatMessage("총 "..comma_value(total).." / 분배인원 "..headcount.."명 = "..comma_value(total / headcount), "PARTY")
			end
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}

	local MainPanel = GUI:Create("Window")
   	MainPanel:SetWidth(650)
    MainPanel:SetHeight(750)
	MainPanel:SetTitle("HAH MainPanel")
	MainPanel:SetCallback("OnClose",
	function(widget) 
		MainPanel:Hide()
		mainTab:SelectTab("tab1")
	end)
	
	MainPanel:SetLayout("Fill")
	MainPanel:EnableResize(false)
	
	local function SelectGroup(container, event, group)
		if group == "tab1" then
			HAH:statistics(container)
		elseif group == "tab2" then
			HAH:TradeHistory(container)
		end
	end
	
	local Tab = GUI:Create("TabGroup")
	mainTab = Tab
	Tab:SetLayout("Flow")
	Tab:SetTabs({
		{text="통계", value="tab1"}, 
		{text="거래내역", value="tab2"},
		})
	Tab:SetCallback("OnGroupSelected", SelectGroup)
	Tab:SelectTab("tab1")
	MainPanel:AddChild(Tab)
	
	return MainPanel
end


function HAH:UpdatePrice(named)
	if self.db.char[named] == nil then
		return
	end
	local i = 1
	for key, adr in next, self.db.char[named], nil do
		if 6 < i then
			return
		end
		editbox[i]:SetLabel("낙찰가: "..comma_value(adr.price).." ")
		i = i + 1
	end
end

function HAH:UpdateRemotePanel(named, container, headertex)
	remoteinfo = {named = named, container = container, headertex = headertex}
	container:ReleaseChildren()
	local header = GUI:Create("SFX-Header-II")
	container:AddChild(header)
	header:SetText(headertex)
	

	if self.db.char[named] == nil then
		return
	end
	local i = 1
	for key, adr in next, self.db.char[named], nil do
		if 6 < i then
			break
		end
		texture[i] = GUI:Create("Icon")
		texture[i]:SetImageSize(35, 35)
		texture[i]:SetRelativeWidth(0.6)
		texture[i]:SetImage(adr.itemTexture)
		texture[i]:SetLabel(adr.itemTooltip)
		
		texture[i]:SetCallback("OnClick", 
		function()
			if UnitIsGroupLeader("player") then
				SendChatMessage(adr.itemTooltip, "RAID")
			else
				SendChatMessage(adr.itemTooltip, "PARTY")
			end
		end)
		container:AddChild(texture[i])
		
		editbox[i] = GUI:Create("EditBox")
		editbox[i]:SetWidth(150)
		editbox[i]:SetRelativeWidth(0.4)
		editbox[i]:SetLabel("낙찰가: "..comma_value(adr.price).." ")
		editbox[i]:SetCallback("OnEnterPressed", 
		function(widget, event, text)
			if tonumber(text) == nil then
				return
			end
			if UnitIsGroupLeader("player") then
				SendChatMessage(adr.itemTooltip.." 가격 설정 : "..comma_value(text), "RAID")
			else
				HAH:Print(adr.itemTooltip.." 가격 설정 : "..comma_value(text))
			end
			adr.price = text
			HAH:UpdatePrice(named)
			HAH:statistics(statistics_container)
		end)
		container:AddChild(editbox[i])
		i = i + 1
	end
	local refresh = GUI:Create("Button")
	refresh:SetText("RL")
	refresh:SetWidth(50)
	container:AddChild(refresh)
	refresh:SetCallback("OnClick",
	function(widget)
		HAH:UpdateRemotePanel(named, container, headertex)
	end)
end

function HAH:RemotePanel()
texture = {}
editbox = {}
	
	local function SelectGroup(container, event, group)
		if group == "tab1" then
			HAH:UpdateRemotePanel("named1", container, "1넴 : 카자라")
		elseif group == "tab2" then
			HAH:UpdateRemotePanel("named2", container, "2넴 : 융합체")
		elseif group == "tab3" then
			HAH:UpdateRemotePanel("named3", container, "3넴 : 잊힌 실험체")
		elseif group == "tab4" then
			HAH:UpdateRemotePanel("named4", container, "4넴 : 자칼리")
		elseif group == "tab5" then
			HAH:UpdateRemotePanel("named5", container, "5넴 : 라소크")
		elseif group == "tab6" then
			HAH:UpdateRemotePanel("named6", container, "6넴 : 지스카른")
		elseif group == "tab7" then
			HAH:UpdateRemotePanel("named7", container, "7넴 : 마그모락스")
		elseif group == "tab8" then
			HAH:UpdateRemotePanel("named8", container, "8넴 : 넬타리온")
		elseif group == "tab9" then
			HAH:UpdateRemotePanel("named9", container, "9넴 : 사카레스")
		end
	end

	local RemotePanel = GUI:Create("Window")
	RemotePanel:SetTitle("HAH RemotePanel")
	RemotePanel:SetCallback("OnClose", 
	function(widget) 
		RemotePanel:Hide()
	end)
	RemotePanel:SetWidth(360)
	RemotePanel:SetHeight(570)
	RemotePanel:EnableResize(false)
	RemotePanel:SetLayout("Fill")
	
	local Tab = GUI:Create("TabGroup")
	Tab:SetLayout("Flow")
	Tab:SetTabs(
	{
		{text="카자라", value="tab1"}, 
		{text="융합체", value="tab2"},
		{text="잊힌 실험체", value="tab3"},
		{text="자칼리", value="tab4"},
		{text="라소크", value="tab5"},
		{text="지스카른", value="tab6"},
		{text="마그모락스", value="tab7"},
		{text="넬타리온", value="tab8"},
		{text="사카레스", value="tab9"},
	}
	)
	Tab:SetCallback("OnGroupSelected", SelectGroup)
	Tab:SelectTab("tab1")

	RemotePanel:AddChild(Tab)
	return RemotePanel
end

function HAH:SlashCommand()
	MainPanel:Show()
end

function HAH:OnInitialize()
	print("HAH init")
	
	self:RegisterChatCommand("HAH", "SlashCommand")
	self:RegisterChatCommand("hah", "SlashCommand")

	self.db = LibStub("AceDB-3.0"):New("HAH_DB", defaults, true)
	local MinimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("HAH_DB", 
	{
		icon = "Interface\\AddOns\\HAH\\Icon",
		OnClick = 
			function(clickedframe, button)
				if button == "RightButton" then
					HAH:UpdateRemotePanel(remoteinfo.named, remoteinfo.container, remoteinfo.headertex)
					RemotePanel:Show()
				else
					HAH:statistics(statistics_container)
					MainPanel:Show()
				end
			end,
		OnTooltipShow = function(tooltip) 
		
		tooltip:AddLine("HAH")
		tooltip:AddLine("|cffFFF569Left Click|r".." : Main")
		tooltip:AddLine("|cffFFF569Right Click|r".." : Remote")
		
		end,
	})
	local HAH_Icon = LibStub("LibDBIcon-1.0")
	HAH_Icon:Register("HAH_DATA", MinimapIcon, HAH_DB)
	
	MainPanel = HAH:MainPanel()
	MainPanel:Hide()
	_G["HAH_Main"] = MainPanel.frame
	tinsert(UISpecialFrames, "HAH_Main")
	
	RemotePanel = HAH:RemotePanel()
	RemotePanel:Hide()
	_G["HAH_Remote"] = RemotePanel.frame
	tinsert(UISpecialFrames, "HAH_Remote")
end

function HAH:newDB(named, itemName, itemLink, itemTooltip, itemTexture)
	if named == nil then
		return
	end

	function checkOverlap(itemName)
		local i = 1
		for key, adr in next, self.db.char[named], nil do
			if 6 < i then
				break
			end
			if key == itemName then
				return true
			end	
			i = i + 1
		end
		return false
	end
	
	while checkOverlap(itemName) do
		itemName = itemName.."_"
	end
	
	self.db.char[named][itemName] = {
		itemTexture = itemTexture,
		itemTooltip = itemTooltip,
		itemLink = itemLink,
		price = 0,
	}
end

function HAH:CHAT_MSG_LOOT(_, msg)

	local _, _, _, sp = strsplit(":", msg)
	
	if tonumber(sp) == nil then
		return
	end
	
	local itemName, itemTooltip, _, itemLevel, _, _, _, _, _, itemTexture = GetItemInfo(sp)
	if itemName == nil then
		return
	end
	
	local named = HAH:checkDroptable(itemName)
	if named == nil then
		return
	else
		HAH:newDB(named, itemName, sp, itemTooltip, itemTexture)
		HAH:UpdateRemotePanel(remoteinfo.named, remoteinfo.container, remoteinfo.headertex)
	end
	
end

function HAH:BOSS_KILL()
	headcount = GetNumGroupMembers()
end

function HAH:RAID_INSTANCE_WELCOME()
	local mapname = GetInstanceInfo()
	HAH:Print(mapname.." 입장")
	if mapname == "어둠의 도가니 아베루스" then
		StaticPopupDialogs["resetPopup_INS"] = {
			text = "HAH : 모든 데이터를 초기화합니다",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				local temp = HAH_DB.minimapPos
				self.db:ResetDB()
				HAH_DB.minimapPos = temp
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
		StaticPopup_Show("resetPopup_INS")
	end
end

function HAH:OnEnable()
	self:RegisterEvent("RAID_INSTANCE_WELCOME")
	
	self:RegisterEvent("CHAT_MSG_LOOT")
	
	self:RegisterEvent("TRADE_SHOW")
	self:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED")
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("PLAYER_MONEY")
	self:RegisterEvent("BOSS_KILL")
end

function HAH:OnDisable() end