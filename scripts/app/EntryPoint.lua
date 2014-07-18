local EntryPoint = class("EntryPoint", function() return display.newNode() end)
function EntryPoint:ctor(s)
	self.scene = s
	local sp = display.newSprite("entry.png"):addTo(self)
end
return EntryPoint