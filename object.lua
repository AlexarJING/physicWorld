local object=class{
	init=function(self,o_type,body,shape,fixture,color)
		self.obj_type=o_type
		self.body=body
		self.shape=shape
		self.fixture=fixture
		self.color=color or {255,255,255,255}
		self.isFix=self.body:getType()=="static"
		self.joints={}
	end 	
}

function object:linkTo(body,how)

end 

function object:select(mousex,mousey)
	if self.fixture:testPoint(mousex,mousey) then
		return true
	end
end

function object:delete()
	self.fixture:destroy()
	interface.selectObj=nil
	physic:removeObj(self)
end

function object:draw(how)
	local v=self
	if how=="temp" then
		love.graphics.setColor(255,0,0,255)
	else
		love.graphics.setColor(unpack(v.color))
	end
	if v.obj_type=="circle" then
		love.graphics.circle("line", v.body:getX(),v.body:getY(), v.shape:getRadius())
		local x=v.shape:getRadius()
		local y=0
		local rot=v.body:getAngle()
		local x1=math.cos(rot)*x-math.sin(rot)*y
		local y1=math.cos(rot)*y+math.sin(rot)*x
		love.graphics.line(v.body:getX(),v.body:getY(),v.body:getX()+x1,v.body:getY()+y1)		
	elseif v.obj_type=="polygon" then			
		love.graphics.polygon("line", v.body:getWorldPoints(v.shape:getPoints()))
	elseif v.obj_type=="border" then
		love.graphics.line(v.body:getWorldPoints(v.shape:getPoints()))
		
	end 
	love.graphics.setColor(255,255,255,255)
end

return object
