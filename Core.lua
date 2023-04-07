HRGT = LibStub("AceAddon-3.0"):NewAddon("HRGT", "AceConsole-3.0", "AceEvent-3.0")
GUI = LibStub("AceGUI-3.0")

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

function HRGT:MainPanel()
	local headcount = 1
	local gold = {}
	local total = 0

	StaticPopupDialogs["resetPopup"] = {
		text = "모든 데이터가 초기화됩니다",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			local temp = HRGT_DB.minimapPos
			self.db:ResetDB()
			HRGT_DB.minimapPos = temp
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
					"1넴 : "..comma_value(gold["test"]).." + ".."2넴 : "..comma_value(gold["named2"]).." + "..
					"3넴 : "..comma_value(gold["named3"]).." + ".."4넴 : "..comma_value(gold["named4"]).." + "..
					"5넴 : "..comma_value(gold["named5"]).." + ".."6넴 : "..comma_value(gold["named6"]).." + "..
					"7넴 : "..comma_value(gold["named7"]).." + ".."8넴 : "..comma_value(gold["named8"]).." = "..comma_value(total), 
					"RAID")
				SendChatMessage("총 "..comma_value(total).." / 분배인원 "..headcount.."명 = "..comma_value(total / headcount), "RAID")
			else
				SendChatMessage(
				"1넴 : "..comma_value(gold["test"]).." + ".."2넴 : "..comma_value(gold["named2"]).." + "..
				"3넴 : "..comma_value(gold["named3"]).." + ".."4넴 : "..comma_value(gold["named4"]).." + "..
				"5넴 : "..comma_value(gold["named5"]).." + ".."6넴 : "..comma_value(gold["named6"]).." + "..
				"7넴 : "..comma_value(gold["named7"]).." + ".."8넴 : "..comma_value(gold["named8"]).." = "..comma_value(total), 
				"PARTY")
				SendChatMessage("총 "..comma_value(total).." / 분배인원 "..headcount.."명 = "..comma_value(total / headcount), "PARTY")
			end
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}

	local MainPanel = GUI:Create("Window")
   	MainPanel:SetWidth(600)
    MainPanel:SetHeight(700)
	MainPanel:SetTitle("HRGT MainPanel")
	MainPanel:SetCallback("OnClose",
	function(widget) 
		MainPanel:Hide()
	end)
	MainPanel:SetLayout("Fill")
	MainPanel:EnableResize(false)
	
	local function calculator(named, container)
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
		frame:SetWidth(400)
		container:AddChild(frame)
		gold[named] = temp
		total = total + temp
	end
	
	local function statistics(container)
		container:ReleaseChildren()
		total = 0

		local header1 = GUI:Create("SFX-Header-II")
		local header2 = GUI:Create("SFX-Header-II")
		local header3 = GUI:Create("SFX-Header-II")
		local header4 = GUI:Create("SFX-Header-II")
		local header5 = GUI:Create("SFX-Header-II")
		local header6 = GUI:Create("SFX-Header-II")
		local header7 = GUI:Create("SFX-Header-II")
		local header8 = GUI:Create("SFX-Header-II")

		header1:SetText("1넴 : 에라노그")
		container:AddChild(header1)
		calculator("test", container)
		
		header2:SetText("2넴 : 테로스")
		container:AddChild(header2)
		calculator("named2", container)
		
		header3:SetText("3넴 : 원시 의회")
		container:AddChild(header3)
		calculator("named3", container)
		
		header4:SetText("4넴 : 세나스")
		container:AddChild(header4)
		calculator("named4", container)
		
		header5:SetText("5넴 : 다테아")
		container:AddChild(header5)
		calculator("named5", container)
		
		header6:SetText("6넴 : 그림토템")
		container:AddChild(header6)
		calculator("named6", container)
		
		header7:SetText("7넴 : 디우르나")
		container:AddChild(header7)
		calculator("named7", container)
		
		header8:SetText("8넴 : 라자게스")
		container:AddChild(header8)
		calculator("named8", container)
		
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
				statistics(container)
			end)
		container:AddChild(heacountbox)
		
		local allotment = GUI:Create("Label")
		allotment:SetText("분배금 : "..comma_value(total / headcount))
		allotment:SetFont(STANDARD_TEXT_FONT, 16, "")
		allotment:SetWidth(400)
		container:AddChild(allotment)
		
		local refresh = GUI:Create("Button")
		refresh:SetText("↻")
		refresh:SetWidth(50)
		container:AddChild(refresh)
		refresh:SetCallback("OnClick",
		function(widget)
			statistics(container)
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
	
	local function SelectGroup(container, event, group)
		if group == "tab1" then
			statistics(container)
		elseif group == "tab2" then
			HRGT:TradeHistory(container)
		end
	end
	
	local Tab = GUI:Create("TabGroup")
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

function HRGT:RemotePanel()
	local texture = {}
	local editbox = {}

	local function UpdatePrice(named)
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
	
	local function UpdateRemotePanel(named, container, headertex)
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
					--테스트 종료시 레이드로 바꿀것 "RAID"
					SendChatMessage(adr.itemTooltip.." 가격 설정 : "..comma_value(text), "PARTY")
				else
					HRGT:Print(adr.itemTooltip.." 가격 설정 : "..comma_value(text))
				end
				adr.price = text
				UpdatePrice(named)
			end)
			container:AddChild(editbox[i])
			i = i + 1
		end
		local refresh = GUI:Create("Button")
		refresh:SetText("↻")
		refresh:SetWidth(50)
		container:AddChild(refresh)
		refresh:SetCallback("OnClick",
		function(widget)
			UpdateRemotePanel(named, container, headertex)
		end)
	end
	
	local function SelectGroup(container, event, group)
		if group == "tab1" then
			UpdateRemotePanel("test", container, "1넴 : 에라노그")
		elseif group == "tab2" then
			UpdateRemotePanel("named2", container, "2넴 : 테로스")
		elseif group == "tab3" then
			UpdateRemotePanel("named3", container, "3넴 : 원시 의회")
		elseif group == "tab4" then
			UpdateRemotePanel("named4", container, "4넴 : 세나스")
		elseif group == "tab5" then
			UpdateRemotePanel("named5", container, "5넴 : 다테아")
		elseif group == "tab6" then
			UpdateRemotePanel("named6", container, "6넴 : 그림토템")
		elseif group == "tab7" then
			UpdateRemotePanel("named7", container, "7넴 : 디우르나")
		elseif group == "tab8" then
			UpdateRemotePanel("named8", container, "8넴 : 라자게스")
		end
	end

	local RemotePanel = GUI:Create("Window")
	RemotePanel:SetTitle("HRGT RemotePanel")
	RemotePanel:SetCallback("OnClose", 
	function(widget) 
		RemotePanel:Hide()
	end)
	RemotePanel:SetWidth(360)
	RemotePanel:SetHeight(550)
	RemotePanel:EnableResize(false)
	RemotePanel:SetLayout("Fill")
	
	local Tab = GUI:Create("TabGroup")
	Tab:SetLayout("Flow")
	Tab:SetTabs({
		{text="에라노그", value="tab1"}, 
		{text="테로스", value="tab2"},
		{text="원시 의회", value="tab3"},
		{text="세나스", value="tab4"},
		{text="다테아", value="tab5"},
		{text="그림토템", value="tab6"},
		{text="디우르나", value="tab7"},
		{text="라자게스", value="tab8"}
		})
	Tab:SetCallback("OnGroupSelected", SelectGroup)
	Tab:SelectTab("tab1")

	RemotePanel:AddChild(Tab)
	return RemotePanel
end

function HRGT:SlashCommand(msg)
	if msg == "HRGT" or msg == "hrgt" then
		MainPanel:Show()
	end
end


function HRGT:OnInitialize()
	self:Print("HRGT Init")

	self:RegisterChatCommand("HRGT", "SlashCommand")
	self:RegisterChatCommand("hrgt", "SlashCommand")


	self.db = LibStub("AceDB-3.0"):New("HRGT_DB", defaults, true)
	local MinimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("HRGT_DB", 
	{
		icon = "Interface\\AddOns\\HRGT\\Icon",
		OnClick = 
			function(clickedframe, button)
				if button == "RightButton" then
					RemotePanel:Show()
				else
					MainPanel:Show()
				end
			end,
		OnTooltipShow = function(tooltip) 
		
		tooltip:AddLine("HRGT")
		tooltip:AddLine("|cffFFF569Left Click|r".." : Main")
		tooltip:AddLine("|cffFFF569Right Click|r".." : Remote")
		
		end,
	})
	local HRGT_Icon = LibStub("LibDBIcon-1.0")
	HRGT_Icon:Register("HRGT_DATA", MinimapIcon, HRGT_DB)
	
	MainPanel = HRGT:MainPanel()
	MainPanel:Hide()
	RemotePanel = HRGT:RemotePanel()
	RemotePanel:Hide()
end

function HRGT:newDB(named, itemName, itemLink, itemTooltip, itemTexture)

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

function HRGT:LOOT_ITEM_AVAILABLE(itemTooltip, lootHandle)
	self:Print(itemTooltip)
	local itemName, itemLink, _, itemLevel, _, _, _, _, _, itemTexture = GetItemInfo(itemTooltip) 
	local named = HRGT:checkDroptable(itemName)
	if named == nil then
		return
	else
		HRGT:newDB(named, itemName, itemLink, itemTooltip, itemTexture)
	end
end

--[[function HRGT:ENCOUNTER_LOOT_RECEIVED(encounterID, itemID, _, quantity, playerName, className)
	self:Print(quantity)
	local _, itemID1 = strsplit(":", quantity)
	self:Print(itemID1)
	local itemName, itemLink, _, itemLevel, _, _, _, _, _, itemTexture = GetItemInfo(quantity)
	
	print("test new table create!")
	HRGT:newDB("test", itemName, itemID1, quantity, itemTexture)
end
]]

function HRGT:RAID_INSTANCE_WELCOME(mapname)
	--if mapname == 현신의금고 추가하기 (현재 정확한 맵 이름 모름)
	StaticPopupDialogs["resetPopup_INS"] = {
		text = "HRGT : 모든 데이터를 초기화합니다",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			local temp = HRGT_DB.minimapPos
			self.db:ResetDB()
			HRGT_DB.minimapPos = temp
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	StaticPopup_Show("resetPopup_INS")
end

function HRGT:OnEnable()
	self:RegisterEvent("LOOT_ITEM_AVAILABLE")
	self:RegisterEvent("RAID_INSTANCE_WELCOME")
	--self:RegisterEvent("ENCOUNTER_LOOT_RECEIVED") --oldraid 등에서 동작. 테스트용
	
	self:RegisterEvent("TRADE_SHOW")
	self:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED")
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("PLAYER_MONEY")
	
end

function HRGT:OnDisable() end
