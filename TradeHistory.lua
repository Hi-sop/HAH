local playerSlot = {}
local targetName
local money_temp = 0
local flag = nil
local trade_container = nil

function HAH:checkDroptable(itemName)
	if itemName == nil then
		return nil
	end
	local named1 = {
		202573,
		202600,
		202589,
		202602,
		202594,
		202583,
		202590,
		202557,
		202576,
		202616,
		202612,
		202559
	}
		
	local named2 = {
		202572,
		202579,
		202593,
		202596,
		202598,
		202605,
		202568,
		202595,
		202617,
		202615,
		202563
	}
	
	local named3 = {
		202652,
		202575,
		202588,
		204318,
		202566,
		202582,
		202571,
		202624,
		202625,
		202626,
		202638,
		203729
	}

	local named4 = {
		202618,
		202578,
		202580,
		202586,
		202574,
		202591,
		202604,
		204279,
		202597,
		202577,
		202607,
		202613
	}
	
	local named5 = {
		204466,
		202603,
		202655,
		202659,
		204319,
		202592,
		202634,
		202635,
		202636,
		202640,
		202614,
		202569
	}

	local named6 = {
		204467,
		204393,
		204391,
		204320,
		202555,
		204400,
		204322,
		202631,
		202632,
		202633,
		202639,
		202610
	}
	
	local named7 = {
		204397,
		204394,
		204395,
		202560,
		202570,
		204396,
		202627,
		202628,
		202629,
		202630,
		203996
	}

	local named8 = {
		204398,
		204392,
		204324,
		202601,
		202558,
		202621,
		202622,
		202623,
		202637,
		204201,
		204202,
		204211,
		203714,
		202606
	}
	
	local named9 = {
		204465,
		202585,
		202587,
		204399,
		204424,
		202584,
		202564,
		202599,
		204390,
		206046,
		203963,
		202565
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
	
	for key, val in next, named9, nil do
		if itemName == GetItemInfo(val) then
			return "named9"
		end
	end

	return nil
end

function HAH:TRADE_SHOW()
	targetName = UnitName("NPC")
	money_temp = tonumber(GetMoney())
	for i = 1, 6 do
		playerSlot[i] = nil
	end
end

function HAH:TRADE_PLAYER_ITEM_CHANGED(_, index)
	if 6 < index then
		return
	end
	local itemName = GetTradePlayerItemInfo(index)
	playerSlot[index] = itemName
end

function HAH:UI_INFO_MESSAGE(_, code, msg)
	if code == 242 and msg == "거래가 완료되었습니다." then
		flag = true
	end
	self:ScheduleTimer("Resetflag", 3)
end

function HAH:Resetflag()
	local itemflag = true
	local named = nil
	for i = 1, 6 do
		named = HAH:checkDroptable(playerSlot[i])
		if named ~= nil then
			if itemflag then
				itemflag = false
			end
		end
	end
	if itemflag then
		return
	end

	local index = 1
	for key, val in next, self.db.char.tradeHis, nil do
		index = index + 1
	end
	local temp = self.db.char.tradeHis[index]
	
	for i = 1, 6 do
		temp.itemLink[i] = playerSlot[i]
	end
	
	local time_H, time_M = GetGameTime()
	if time_H < 10 then
		time_H = "0"..time_H
	end
	if time_M < 10 then
		time_M = "0"..time_M
	end
	
	temp.serverTime = time_H..":"..time_M
	temp.targetName = targetName
	temp.price = 0

	flag = false
	if trade_container ~= nil then
		HAH:TradeHistory(trade_container)
	end
end

function HAH:PLAYER_MONEY()
	HAH:CancelAllTimers()
	if flag == true then
		local index = 1
		for key, val in next, self.db.char.tradeHis, nil do
			index = index + 1
		end
		local temp = self.db.char.tradeHis[index]
		local named = nil
		
		for i = 1, 6 do
			named = HAH:checkDroptable(playerSlot[i])
			if named ~= nil then
				local itemName
				if playerSlot[i] ~= nil then
					itemName = GetItemInfo(playerSlot[i])
					self.db.char[named][itemName]["price"] = temp.price
				end
				temp.itemLink[i] = playerSlot[i]
			end
		end
		
		local time_H, time_M = GetGameTime()
		if time_H < 10 then
			time_H = "0"..time_H
		end
		if time_M < 10 then
			time_M = "0"..time_M
		end
		
		temp.serverTime = time_H..":"..time_M
		temp.targetName = targetName
		temp.price = (tonumber(GetMoney()) - money_temp) / 100 / 100
		
		flag = false
		if trade_container ~= nil then
		HAH:TradeHistory(trade_container)
		end
	end
end

function HAH:TradeHistory(container)
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
	
	if trade_container ~= nil then
		trade_container:ReleaseChildren()
	end
	
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
	refresh:SetText("RL")
	refresh:SetWidth(50)
	scroll:AddChild(refresh)
	refresh:SetCallback("OnClick",
	function(widget)
		HAH:TradeHistory(container)
	end)
	
end
