
local LevelList = require("app.LevelList")


local TowerScene = class("TowerScene", function() return display.newScene("TowerScene") end)
function TowerScene:ctor()

	local ds = getDS()
	--local testLayer = CCLayerColor:create(ccc4(32, 128, 32, 255)):addTo(self)
	
	--local node = CCNode:create()
	--testLayer:addChild(node)
	
	--[[
	local rip = CCRipple3D:create(3, CCSizeMake(10, 15), ccp(200, 200), 340, 10, 60)
				--local rip = CCShaky3D:create(3, CCSizeMake(15, 10), 5, false)
				--local rip = CCWaves3D:create(3, CCSizeMake(15, 10), 5, 40)
				--self:runAction(rip)
				--local node = CCNode:create()
				--self:addChild(node)
	node:runAction(rip)
	--]]		

	--local sp = CCSprite:create("sky.png")
	--sp:addTo(node):pos(240, 240)

	local bgLayer = display.newLayer():addTo(self)
	centerFull(bgLayer)


	local sky = display.newSprite("sky.png")
	sky:addTo(bgLayer):pos(ds[1]/2, ds[2]/2)

	--setGLProgram(sky);
	--self.levelList = LevelList.new(self):addTo(bgLayer)

	--[[
	local initX = 240;
	local initY = 800-706
	local offY = 706-597

	local fromY = 810

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
	--]]

	local vs = getVS()
	local sz = sky:getContentSize()
	local rt = CCRenderTexture:create(sz.width, sz.height)
	rt:addTo(self):pos(vs.width/2, vs.height/2)
	rt:beginWithClear(0, 0, 0, 0)
	bgLayer:visit()
	rt:endToLua()

	bgLayer:setVisible(false)

	setGLProgram(rt:getSprite())

	

	--[[
	local images = {
		normal = "doorOpen.png"
	}
	local but = cc.ui.UIPushButton.new(images)
		:onButtonClicked(function(event)
				print("onevent", event)
				
				--sky:runAction(CCFadeIn:create(1))
				--sky:runAction(CCMoveBy:create(1, ccp(10, 10)))
			end)
		:addTo(self)
		:pos(100, 100)
	--]]

	--local bg = display.newSprite("towerBack.png")
	--bg:addTo(self):pos(ds[1]/2, ds[2]/2)
	
	--self.levelList = LevelList.new(self):addTo(self)

	--整个屏幕都是touchLayer 如何在UI组件 和 非UI组建之间进行互相协作呢？ 
	--通过中立的shadow 组建通知么?
	
	--[[
	local touchLayer = TouchGroup:create()
	self:addChild(touchLayer)

	local wid = GUIReader:shareReader():widgetFromJsonFile("allUI.json")
	local but = UIHelper:seekWidgetByName(wid, "sweep")
	
	touchLayer:addWidget(wid)
	--]]
	

	--[[
	local panel = Layout:create()
	touchLayer:addWidget(panel)


	local but = Button:create()
	but:loadTextureNormal("go_sweep_btn_normal.png")
	but:loadTexturePressed("go_sweep_btn_pressed.png")
	but:setPosition(ccp(351, 662))
	panel:addChild(but)
	--]]
end

return TowerScene
