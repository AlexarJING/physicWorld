local input={
	clickToggle=false,
	lastDown=0,
	clickToggle_r=false,
	lastDown_r=0
}
function input:test()
	local dt=love.timer.getTime()-self.lastDown
	local mx,my = love.mouse.getPosition()
	if mx<200 or mx>1080 or my<10 or my>650 then return "offlimit" end

	if love.mouse.isDown("l") and self.clickToggle==false then
		self.clickToggle=true
		self.lastDown = love.timer.getTime()
		return "down"
	end	
	if dt>0.2 and self.clickToggle==true and love.mouse.isDown("l") then
		return "dragging"
	end
	if not love.mouse.isDown("l") and self.clickToggle==true then
		self.clickToggle=false
		if dt<=0.1 then
			return "clicked"
		else
			return "dragged"
		end
	end
	if dt<0.2 then return "waiting" else return "ready" end
end

function input:test_r()
	local dt_r=love.timer.getTime()-self.lastDown_r
	local mx,my = love.mouse.getPosition()
	if mx<200 or mx>1080 or my<10 or my>650 then return "offlimit" end

	if love.mouse.isDown("r") and self.clickToggle_r==false then
		self.clickToggle_r=true
		self.lastDown_r = love.timer.getTime()
		return "down"
	end	
	if dt_r>0.2 and self.clickToggle_r==true and love.mouse.isDown("r") then
		return "dragging"
	end
	if not love.mouse.isDown("r") and self.clickToggle_r==true then
		self.clickToggle_r=false
		if dt_r<=0.2 then
			return "clicked"
		else
			return "dragged"
		end
	end
	return "ready"
end

return input