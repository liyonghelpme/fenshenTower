require("heapq")

local MovePath = class("MovePath")
--API 使用方法
--ctor 构建 传入参数
--init 初始化
--update 多帧 得到路径
--获取路径数据 getPath

--地图信息 地图尺寸信息
function MovePath:ctor(tar)
	self.target = tar
	self.map = self.target.map 
	self.endPoint = {2, 2}
	--地图尺寸
	self.mapSize = self.map.mapSize

end

function MovePath:calcG(x, y)
	local key = getMapKey(x, y)
	local data = self.cells[key]
	local parent = data.parent 
	local px, py = getXY(parent)
	dist = 10
	data.gScore = self.cells[parent].gScore+dist
    self.cells[key] = data
end

--到达目的地的 grid信息
function MovePath:calcH(x, y)
	local key = getMapKey(x, y)
    local data = self.cells[key]
    data.hScore = 10*(math.abs(x-self.endPoint[1])+math.abs(y-self.endPoint[2]))
    self.cells[key] = data
end

function MovePath:calcF(x, y)
    local key = getMapKey(x, y)
    local data = self.cells[key]
    data.fScore = data.gScore+data.hScore
end

function MovePath:pushQueue(x, y)
    local key = getMapKey(x, y)
    local fScore = self.cells[key].fScore
    heapq.heappush(self.openList, fScore)
    local fDict = self.pqDict[fScore]
    if fDict == nil then
        fDict = {}
    end
    table.insert(fDict, key)
    self.pqDict[fScore] = fDict
end

function MovePath:checkNeibor(x, y)
    --近的邻居先访问
    --只允许 正边
    local neibors = {
        {x-1, y},
        {x+1, y},
        {x, y+1},
        {x, y-1},
    }
    local curKey = getMapKey(x, y)
    for n, nv in ipairs(neibors) do
    	local key = getMapKey(nv[1], nv[2])
    	--邻居点超出地图边界障碍物
    	if nv[1] < 0 or nv[1] >= self.mapSize[1] or nv[2] < 0 or nv[2] >= self.mapSize[2]  then
    	else

    		if self.cells[key] == nil then
    			self.cells[key] = {}
    			self.cells[key].parent = curKey
    			self:calcG(nv[1], nv[2])
    			self:calcH(nv[1], nv[2])
    			self:calcF(nv[1], nv[2])
    			self:pushQueue(nv[1], nv[2])
    		end
    	end
    end

end

--初始化到目标点的移动
function MovePath:init(mx, my, tx, ty)
	self.startPoint = {mx, my}
	self.endPoint = {tx, ty}
	self.openList = {}
	self.pqDict = {}
	self.closedList = {}
	self.path = {}
	self.cells = {}

	local sk = getMapKey(mx, my)
	self.cells[sk] = {}
	self.cells[sk].gScore = 0
	self:calcH(mx, my)
	self:calcF(mx, my)
	self:pushQueue(mx, my)

	self.searchYet = false
    print("initial path", json.encode(self.startPoint), json.encode(self.endPoint))
    print("mapSize", json.encode(self.mapSize))

end

function MovePath:update()
	local n = 1
    local findTarget = false

	while n < 10 do
		if #self.openList == 0 then
			break
		end
		local fScore = heapq.heappop(self.openList)
        local possible = self.pqDict[fScore]
        if #possible > 0 then
            local n = math.random(#possible)
            local point = table.remove(possible, n)
            local x, y = getXY(point)
            
            self.map:debugGrid(x, y)
            
            print("x, y is", x, y)
            if x == self.endPoint[1] and y == self.endPoint[2] then
                print("找到目标", self.endPoint[1], self.endPoint[2])
                findTarget = true
                break
            end
            self:checkNeibor(x, y)
        end
        n = n+1
	end

	if #self.openList == 0 or findTarget then
		self.searchYet = true
	end
end

function MovePath:getPath()
    --print("cellinfor", json.encode(self.cells))
    
	if self.endPoint ~= nil then
		
        local eid = getMapKey(self.endPoint[1], self.endPoint[2])
        print("eid is", eid, json.encode(self.cells[eid]))
		local path = {eid}

        local parent = self.cells[eid].parent
        while parent ~= nil do
            table.insert(path, parent)
            if parent == self.startPoint then
                break
            end
            parent = self.cells[parent].parent
        end
        --包括最后一个点 只是在行走的时候 调整一下 到最后一个点的时候 要消失 或者每半个作为一个移动单位 
        for i =#path, 1, -1 do
            table.insert(self.path, path[i])
        end
        print("get Map Cat Path", json.encode(self.endPoint), json.encode(self.path))
        --self.target.scene:updateDebugNode(self.path)
	end
	return self.path
end



return MovePath
