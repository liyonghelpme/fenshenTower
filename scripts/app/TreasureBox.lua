local TreasureBox = class("TreasureBox", function() return display.newNode() end)
function TreasureBox:ctor(s)
	self.scene = s
	local sp = display.newSprite("treasureBox.png"):addTo(self)
end


return TreasureBox
