local world=class{
	init=function(self)
		self.world= love.physics.newWorld(0, 0, true)
		self.objects={}
	end 	
}

function world:addCircle(x,y,r,o_type,density,color)
	x=x or 0
	y=y or 0
	r=r or 10
	o_type= o_type or "dynamic"
	color=color or {0,0,0,255}
	print(self.world)
	local body = love.physics.newBody(self.world, x, y, type)
	local shape = love.physics.newCircleShape(r)
	local fixture = love.physics.newFixture(body, shape, density)
	table.insert(self.objects,{
		obj_type="circle",
		obj_body=body,
		obj_shape=shape,
		obj_fixture=fixture,
		obj_color=color
		})
end


function world:draw()
	if #self.objects==0 then return end
	for k,v in pairs(self.objects) do
		if v.obj_type=="circle" then
			love.graphics.setColor(unpack(v.obj_color))
			love.graphics.circle("line", v.obj_body:getX(),v.obj_body:getY(), v.obj_shape:getRadius())
			local x=v.obj_shape:getRadius()
			local y=0
			local rot=v.obj_body:getAngle()
			local x1=math.cos(rot)*x-math.sin(rot)*y
			local y1=-math.cos(rot)*y-math.sin(rot)*x
			love.graphics.line(x,y,x1,y1)
			love.graphics.setColor(0,0,0,255)
		elseif v.obj_type=="rect" then
		elseif v.obj_type=="polygon" then
		elseif v.obj_type=="line" then	
		end  
	end
end

function world:update()
	self.world:upadt()
end	

return world