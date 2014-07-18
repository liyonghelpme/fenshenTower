local MovePath = require("app.MovePath")

local MoveHero = class("MoveHero", function() return display.newNode() end)
function MoveHero:ctor(s)
	self.scene = s
	self.map = s

	local sp = display.newSprite("1000067.png")
	local sz = sp:getContentSize()
	local box = display.newSprite("head_color_1.png")
	box:addTo(sp):pos(sz.width/2, sz.height/2)
	self:addChild(sp)

	self.stopMove = false
	self.inMove = false

	registerUpdate(self)
end

--走直线路径
--每次点击立即终止当前的移动然后 开始新的移动
--stop move
--move 

local function moving(self)
	local px, py = self:getPosition()
	local gx, gy = posToGrid(px, py)
	local movePath = MovePath.new(self)
	movePath:init(gx, gy, self.endPoint[1], self.endPoint[2])
	while true do
		movePath:update()
		if movePath.searchYet then
			break
		end
		--waitForTime(self, 1)
		coroutine.yield()
	end
	self.path = movePath:getPath()

	for i=2, #self.path, 1 do
		local p = self.path[i]
		local x, y = getXY(p)
		local px, py = gridToPos(x, y)

		self.scene:drawMistOnMap(x, y)

		local obj = {}
		obj.over = false
		local function finMove()
			obj.over = true
		end
		self:runAction(createSequence({
			CCMoveTo:create(0.1, ccp(px, py)), 
			CCCallFunc:create(finMove)}))

		waitForOver(obj)

		if self.stopMove then
			break
		end
		local key = getMapKey(x, y)
		local item = self.scene.mapInfo[key]
		if item ~= nil then
			if item.type == 2 then
				--local rip = CCRipple3D:create(3, CCSizeMake(20, 20), ccp(200, 200), 300, 10, 160)
				--全屏效果不能只加在单一的元素上面
				--local rip = CCShaky3D:create(3, CCSizeMake(15, 10), 5, false)
				--self.scene:runAction(rip)
			end
		end
	end

	--self.moveProgress = nil
	self.inMove = false
	self.stopMove = false
end

function MoveHero:doMove(gx, gy)
	--[[
	if self.moveProgress ~= nil then
		return
	end
	--]]
	--再次点击则暂停移动
	
	print("doMove to ", gx, gy)
	if self.inMove then
		self.stopMove = true
	else
		self.inMove = true
	end

	self.endPoint = {gx, gy}
	self.moveProgress = coroutine.create(moving) 
end

function MoveHero:update(diff)
	self.diff = diff
	if self.moveProgress ~= nil then
		local res, err = coroutine.resume(self.moveProgress, self)
		if not res then
			print(err)
			--print(debug.traceback())
			self.moveProgress = nil
		end
	end
end


return MoveHero