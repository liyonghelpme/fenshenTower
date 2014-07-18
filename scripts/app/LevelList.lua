local LevelList = class("LevelList", function() return display.newLayer() end)

--根据数据初始化 若干Level
--240 697 每层塔的位置
--初始化显示的方式 从上面往下面掉落
local function makeDoor(self, sp)
	local images = {
		normal = "doorOpen.png"
	}
	local door = cc.ui.UIPushButton.new(images)
		:onButtonClicked(function(event)
			print("event", event)
			self:onDoor()
		end)
		:addTo(sp)
		:pos(333, 132-79)
	door:onButtonPressed(function(event)
			door:setScale(1.1)
		end)
		:onButtonRelease(function(event)
			door:setScale(1.0)
		end)
		
	local light = display.newSprite("doorOpenLight.png")
	door:addChild(light)
	light:runAction(CCRepeatForever:create(createSequence({
		CCFadeOut:create(0.5),
		CCFadeIn:create(0.5)
		}) ) ) 
end

function LevelList:ctor()
	self.allLevels = {}
	local initX = 240;
	local initY = 800-706
	local offY = 706-597

	local fromY = 810
	
	--[[
	local touchLayer = TouchGroup:create()
	self:addChild(touchLayer)

	local wid = GUIReader:shareReader():widgetFromJsonFile("allUI.json")
	touchLayer:addWidget(wid)
	local door = UIHelper:seekWidgetByName(wid, "door")
	--]]


	for i=1, 20, 1 do
		local tpos = {initX, initY+offY*(i-1)}
		local sp = display.newSprite("levelTower.png"):addTo(self):pos(initX, fromY)
		table.insert(self.allLevels, sp)
		sp:setOpacity(0)
		sp:runAction(createSequence({CCDelayTime:create((i-1)*0.2), 
			createSpawn({CCFadeIn:create(0.1), 
					CCEaseElastic:create(CCMoveTo:create(0.1, ccp(initX, tpos[2])))
			  		
			  })
		}) )
		if i == 1 then
			makeDoor(self, sp)
		end	
	end
	


end


function LevelList:onDoor()
	GlobalApp:enterScene("FightScene")
end


return LevelList