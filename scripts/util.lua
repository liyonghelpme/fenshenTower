function getDS()
	return {DESIGN_WIDTH, DESIGN_HEIGHT}
end
function getVS()
	return CCDirector:sharedDirector():getVisibleSize()
end

function createSpawn(actions)
	local arr = CCArray:create()
	for k, v in ipairs(actions) do
		arr:addObject(v)
	end
	return CCSpawn:create(arr)
end
function createSequence(actions)
	local arr = CCArray:create()
	for k, v in ipairs(actions) do
		arr:addObject(v)
	end
	return CCSequence:create(arr)
end

function registerUpdate(obj)
	local function update(diff)
		obj:update(diff)
	end
	obj:scheduleUpdate(update)
end

--点内部坐标
function registerTouch(obj, delegate, callback)
	obj:setTouchEnabled(true)
	local function onTouch(name, x, y, prex, prey)
		--obj:onTouch(name, x, y, prex, prey)
		return callback(delegate, name, x, y, prex, prey)
	end
	obj:addTouchEventListener(onTouch)
end

--世界坐标
function registerNewTouch(obj, delegate, callback)
	obj:setTouchEnabled(true)
	local function onTouch(eventType, x, y)
		return callback(delegate, eventType, x, y)
	end
	obj:registerScriptTouchHandler(onTouch, false)
end



--网格到 图片的坐标
function gridToPos(x, y)
	return x*80+40, y*80+40+82
end

--图片坐标 到最近的网格 + 1/2 * 80 用来计算 round
function posToGrid(px, py)
	print("pxy", px, py)
	return math.floor((px-40+40)/80), math.floor((py-40-82+40)/80) 
end

function centerBottom(sp)
    local vs = getVS()
    local ds = getDS()
    local sca = math.min(vs.width/ds[1], vs.height/ds[2])
    sp:scale(sca)
    local cx = ds[1]/2
    local nx = vs.width/2-cx*sca
    sp:pos(nx, 0)
end

function centerFull(sp)
    local vs = getVS()
    local ds = getDS()
    local sca = math.max(vs.width/ds[1], vs.height/ds[2])
    local cx, cy = ds[1]/2, ds[2]/2
    local nx, ny = vs.width/2-cx*sca, vs.height/2-cy*sca
    print("centerTemp", sca, nx, ny, vs.width, vs.height, ds[1], ds[2])
	
	sp:scale(sca):pos(nx, ny)
    
end

function getMapKey(x, y)
	return x*10000+y
end
function getXY(k)
	return math.floor(k/10000), math.floor(k%10000)
end

function waitForTime(obj, t)
	local passTime = 0
	while passTime < t do
		coroutine.yield()
		passTime = passTime + obj.diff
	end
end

function waitForOver(obj)
	while not obj.over do
		coroutine.yield()
	end
end



