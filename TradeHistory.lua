local playerSlot = {}
local targetName
local money_temp = 0
local flag = nil

function HRGT:checkDroptable(itemName)
	if itemName == nil then
		return nil
	end
	local named1 = {
		194299,
		195475,
		195476,
		195477,
		195478,
		195479,
		195480,
		195482,
		195490
	}
		
	local named2 = {
		194303,
		195497,
		195498,
		195499,
		195500,
		195501,
		195502,
		195503,
		195504
	}
	
	local named3 = {
		194300,
		194301,
		195484,
		195485,
		195486,
		195487,
		195488,
		195489,
		195518
	}

	local named4 = {
		194304,
		195505,
		195506,
		195507,
		195508,
		195509,
		195510,
		195511,
		196588,
		196593,
		196598,
		196603
	}
	
	local named5 = {
		194302,
		195481,
		195491,
		195492,
		195493,
		195494,
		195495,
		195496,
		196587,
		196592,
		196597,
		196602
	}

	local named6 = {
		194305,
		194306,
		195483,
		195512,
		195513,
		195514,
		195515,
		195516,
		195517,
		196586,
		196591,
		196596,
		196601
	}
	
	local named7 = {
		194307,
		194308,
		195519,
		195520,
		195521,
		195522,
		195523,
		195524,
		195525,
		195526,
		196589,
		196594,
		196599,
		196604
	}

	local named8 = {
		194309,
		194310,
		195527,
		195528,
		195529,
		195530,
		195531,
		195532,
		195533,
		196590,
		196595,
		196600,
		196605
	}

	for key, val in next, named1, nil do
		if itemName == GetItemInfo(val) then
			return "named1"
		end
	end

	for key, val in next, named2, nil do
		if itemName == GetItemInfo(val) then
			return "named2"
		end
	end

	for key, val in next, named3, nil do
		if itemName == GetItemInfo(val) then
			return "named3"
		end
	end

	for key, val in next, named4, nil do
		if itemName == GetItemInfo(val) then
			return "named4"
		end
	end

	for key, val in next, named5, nil do
		if itemName == GetItemInfo(val) then
			return "named5"
		end
	end

	for key, val in next, named6, nil do
		if itemName == GetItemInfo(val) then
			return "named6"
		end
	end

	for key, val in next, named7, nil do
		if itemName == GetItemInfo(val) then
			return "named7"
		end
	end

	for key, val in next, named8, nil do
		if itemName == GetItemInfo(val) then
			return "named8"
		end
	end

	return nil
end

function HRGT:TRADE_SHOW()
	targetName = UnitName("NPC")
	money_temp = tonumber(GetMoney())
	for i = 1, 6 do
		playerSlot[i] = nil
	end
end

function HRGT:TRADE_PLAYER_ITEM_CHANGED(_, index)
	if 6 < index then
		return
	end
	local itemName = GetTradePlayerItemInfo(index)
	playerSlot[index] = itemName
end

function HRGT:UI_INFO_MESSAGE(_, code, msg)
	if code == 242 and msg == "거래가 완료되었습니다." then
		flag = true
	end	
end

function HRGT:PLAYER_MONEY()
	if flag then

		local index = 1
		for key, val in next, self.db.char.tradeHis, nil do
			index = index + 1
		end
		local temp = self.db.char.tradeHis[index]
		local time_H, time_M = GetGameTime()
		if time_H < 10 then
			time_H = "0"..time_H
		end
		if time_M < 10 then
			time_M = "0"..time_M
		end
		
		local named = nil
		
		for i = 1, 6 do
			named = HRGT:checkDroptable(playerSlot[i])
			if named ~= nil then
				temp.serverTime = time_H..":"..time_M
				temp.targetName = targetName
				temp.price = (tonumber(GetMoney()) - money_temp) / 100 / 100
				local itemName
				if playerSlot[i] ~= nil then
					itemName = GetItemInfo(playerSlot[i])
					self.db.char[named][itemName]["price"] = temp.price
				end
				temp.itemLink[i] = playerSlot[i]
			end
		end
		flag = nil
		HRGT:TradeHistory(trade_container)
	end
end

function HRGT:TradeHistory(container)
	trade_container = container
	function AddText(scroll, serverTime, targetName, itemLink, price)
		local blink = GUI:Create("Label")
		blink:SetWidth(550)
		blink:SetFont(STANDARD_TEXT_FONT, 1, "")
		scroll:AddChild(blink)
		
		local block = GUI:Create("Label")
		block:SetWidth(10)
		scroll:AddChild(block)

		local box1 = GUI:Create("Label")
		box1:SetText(serverTime)
		box1:SetFont(STANDARD_TEXT_FONT, 13, "")
		box1:SetWidth(60)
		scroll:AddChild(box1)
			
		local box2 = GUI:Create("Label")
		box2:SetText(targetName)
		box2:SetFont(STANDARD_TEXT_FONT, 13, "")
		box2:SetWidth(120)
		scroll:AddChild(box2)
		
		local box3 = GUI:Create("Label")
		if itemLink == "아이템" then
			box3:SetText(itemLink)
		else
			local temp = ""
			for i = 1, 6 do
				if itemLink[i] ~= nil then
					local _, link = GetItemInfo(itemLink[i])
					temp = temp.." "..link
				end
			end
			box3:SetText(temp)
		end
		box3:SetFont(STANDARD_TEXT_FONT, 13, "")
		box3:SetWidth(250)
		scroll:AddChild(box3)
		
		local box4 = GUI:Create("Label")
		if tonumber(price) ~= nil then
			box4:SetText(comma_value(price))
		else
			box4:SetText(price)
		end
		box4:SetFont(STANDARD_TEXT_FONT, 13, "")
		box4:SetWidth(80)
		scroll:AddChild(box4)
	end
	
	container:ReleaseChildren()
	
	local scrollcontainer = GUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetLayout("Fill")
	container:AddChild(scrollcontainer)

	scroll = GUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)
	
	AddText(scroll, "시간", "상대", "아이템", "골드")
	local header = GUI:Create("SFX-Header-II")
	scroll:AddChild(header)
	
	for key, val in next, self.db.char.tradeHis, nil do
		AddText(scroll, val.serverTime, val.targetName, val.itemLink, val.price)
	end
	
	local refresh = GUI:Create("Button")
	refresh:SetText("↻")
	refresh:SetWidth(50)
	scroll:AddChild(refresh)
	refresh:SetCallback("OnClick",
	function(widget)
		HRGT:TradeHistory(container)
	end)
	
end
