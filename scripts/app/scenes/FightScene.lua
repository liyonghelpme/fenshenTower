local TreasureBox = require("app.TreasureBox")
local EntryPoint = require("app.EntryPoint")


local FightScene = class("FightScene", function() return display.newScene("FightScene") end)
local MoveHero = require("app.MoveHero")

local function createHeadBox(self)
	--[[
	local sp = display.newSprite("1000067.png")
	local sz = sp:getContentSize()
	local box = display.newSprite("head_color_1.png")
	box:addTo(sp):pos(sz.width/2, sz.height/2)
	return sp
	--]]
	return MoveHero.new(self)
end


function FightScene:ctor()
	local ds = getDS()
	local bgLayer = display.newLayer()
	bgLayer:setContentSize(CCSizeMake(0, 0))
	bgLayer:addTo(self)
	centerFull(bgLayer)
	self.mapSize = {6, 8}
	

	local sky = display.newSprite("sky.png")
	sky:addTo(bgLayer):pos(ds[1]/2, ds[2]/2)
	
	--bug 用display.newNode 来做 touch 容器存在问题 左右两侧屏幕点击不到 缩放了之后
	--使用Layer 没有这个问题
	local bottomCenterLayer = display.newLayer():addTo(self)
	bottomCenterLayer:setContentSize(CCSizeMake(0, 0))
	bottomCenterLayer:setAnchorPoint(ccp(0, 0))
	centerBottom(bottomCenterLayer)
	self.bottomCenterLayer = bottomCenterLayer


	registerTouch(bottomCenterLayer, self, self.onTouch)


	local mapBack = display.newSprite("mapBack.png")
	mapBack:addTo(bottomCenterLayer):pos(ds[1]/2, ds[2]/2)
	self.mapBack = mapBack
	
	

	--registerTouch(self)
	self.itemLayer = display.newNode():addTo(bottomCenterLayer)

	self.heroBox = createHeadBox(self)
	self.heroBox:addTo(bottomCenterLayer)

	--大遮罩上
	local mist = display.newSprite("mist.png")
	mist:addTo(self):setVisible(false)
	local bf = ccBlendFunc()
	--0 0 0 1 纯褐色不透明 
	--接着渲染 一个 
	bf.src = GL_ZERO
	bf.dst = GL_ONE_MINUS_SRC_COLOR
	mist:setBlendFunc(bf)
	mist:pos(200, 300)
	self.mist = mist


	--上面是空白
	local rt = CCRenderTexture:create(ds[1], 735)
	rt:addTo(bottomCenterLayer):pos(ds[1]/2, 735/2)
	rt:setClearColor(ccc4f(0, 0, 0, 1))
	self.rt = rt
	--beginWithClear 才能修正颜色
	self.rt:beginWithClear(0, 0, 0, 0.5)
	self.rt:endToLua()


	--需要调用beginWithClear才可以设定颜色执行
	--缩放雾气
	--[[
	self.mist:setVisible(true)
	self.rt:beginWithClear(0, 0, 0, 1)
	self.rt:endToLua()
	self.mist:visit()
	self.rt:endToLua()
	self.mist:setVisible(false)
	--]]

	--测试
	--0 普通地块
	--1 宝箱 是否打开了 对应的宝箱图片
	--2 出口
	self.mapInfo = {[10001]={type=1, open=false}, [30004]={type=2}}
	--地图ID 对应的显示对象
	--self.mapObjects = {}


	--初始化英雄和地图
	self:initHero()
	self:initMap()

	--在黑色的遮罩上面 挖出一个洞来
	


	registerUpdate(self)
end

function FightScene:initHero()
	local px, py = gridToPos(4, 6)
	self.heroBox:setPosition(ccp(px, py))
end

--渲染一个 mist 
function FightScene:initMap()
	local px, py = self.heroBox:getPosition()
	print("mxy", px, py)
	local gx, gy = posToGrid(px, py)
	print("gx gy", gx, gy)
 	self:drawMistOnMap(gx, gy)


 	--绘制宝箱和出口
 	for k, v in pairs(self.mapInfo) do
 		local gx, gy = getXY(k)
 		print("宝箱出口", k, gx, gy)
 		local px, py = gridToPos(gx, gy)
 		if v.type == 1 then
 			local tb = TreasureBox.new(self)
 			tb:pos(px, py):addTo(self.itemLayer)
 			v.item = tb
 			self:drawMistOnMap(gx, gy)
 		elseif v.type == 2 then
 			local ep = EntryPoint.new(self):addTo(self.itemLayer):pos(px, py)
 			v.item = ep
 			self:drawMistOnMap(gx, gy)
 		end
 	end
end

function FightScene:getMapInfo()
end


function FightScene:drawMistOnMap(x, y)
	local px, py = gridToPos(x, y)
	self.mist:setVisible(true)
	self.mist:setPosition(ccp(px, py))
	self.rt:begin()
	self.mist:visit()
	self.rt:endToLua()
	self.mist:setVisible(false)
end


--网格坐标 37 682 0 号网格
--480/6 = 80  * 80 的网格地图
--6 * 8 的地图尺寸
--touch 传入的是 node本身的坐标不是世界坐标

--使用世界坐标的接口
--what? 
function FightScene:debugGrid(gx, gy)
	--self:drawMistOnMap(gx, gy)
end

function FightScene:onTouch(eventType, x, y)
	print("touch", eventType, x, y)
	--转化到屏幕坐标
	local np = self.bottomCenterLayer:convertToNodeSpace(ccp(x, y))

	if eventType == "began" then
		return true
	elseif eventType == "moved" then
	elseif eventType == "ended" then
		local gx, gy = posToGrid(np.x, np.y)
		self:drawMistOnMap(gx, gy)
		self.heroBox:doMove(gx, gy)
	end


	--[[
	print("onTouch", name, x, y, prex, prey)
	if name == "began" then
		return true
	elseif name == "moved" then
	elseif name == "ended" then
		local gx, gy = posToGrid(x, y)
		print("grid", gx, gy)
		self:drawMistOnMap(gx, gy)
		print("pxy", gridToPos(gx, gy))
	end
	--]]

end


function FightScene:update()
	if not self.initYet then
		self.initYet = true

		
	end
end


return FightScene
