local object=require("object")
local joint=require("joint")
local input=require("input")
local physic=class{
	init=function(self)
		love.physics.setMeter(64)
		self.world= love.physics.newWorld(0, 9.8*64, false)
		self.objects={}
		self.joints={}
		self.isPause=false
		self.selected=0
		self.selectPos=1
		self.selectTable={}
		self.maxPos=1
		self.target=0
	end 	
}

function physic:getDistance(x1,y1,x2,y2)
	return math.sqrt((x1-x2)^2+(y1-y2)^2)
end



function physic:getRelativeRad(obj1,obj2)
	local x1=obj1.body:getX()
	local y1=obj1.body:getY()
	local x2=obj2.body:getX()
	local y2=obj2.body:getY()
	local rad=math.atan((x1-x2)/(y1-y2))
	if y1<y2 then rad=rad-math.pi end
	return -rad+math.pi/2
end

function physic:getRelativePos(x,y,rot)
	local x1=math.cos(rot)*x-math.sin(rot)*y
	local y1=math.cos(rot)*y+math.sin(rot)*x
	return x1,y1
end

function physic:removeObj(object)
	for i,v in ipairs(self.objects) do
		if v==object then
			table.remove(self.objects, i)
			break
		end
	end
end

function physic:removeJoint(joint)
	for i,v in ipairs(joint.targetA.joints) do
		if v==joint then
			table.remove(joint.targetA.joints, i)
			break
		end
	end
	for i,v in ipairs(joint.targetB.joints) do
		if v==joint then
			table.remove(joint.targetB.joints, i)
			break
		end
	end
	
	for i,v in ipairs(self.joints) do
		if v==joint then
			table.remove(self.joints, i)
			break
		end
	end
end

function physic:addBall(x,y,r,o_type,color)
	x=x or 0
	y=y or 0
	r=r or 10
	o_type= o_type or "dynamic"
	color=color or {255,255,255,255}
	local body = love.physics.newBody(self.world, x, y, o_type)
	local shape = love.physics.newCircleShape(r)
	local fixture = love.physics.newFixture(body, shape)
	local obj=object("circle",body,shape,fixture,color)
	table.insert(self.objects,obj)
	self:setMaterial(fixture,"wood")
	return obj
end

function physic:addBox(x,y,long,width,o_type,color)
	x=x or 0
	y=y or 0
	o_type= o_type or "dynamic"
	color=color or {255,255,255,255}
	local body = love.physics.newBody(self.world, x, y, o_type)
	local shape = love.physics.newRectangleShape(long,width)
	local fixture = love.physics.newFixture(body, shape)
	local obj=object("polygon",body,shape,fixture,color)
	table.insert(self.objects,obj)
	self:setMaterial(fixture,"wood")
	return obj
end

function physic:addBorder(x,y,pointsTable,color,isloop)
	x=x or 0
	y=y or 0
	if type(pointsTable)~="table" or #pointsTable<4 then print("false");return end
	color=color or {255,255,255,255}
	local body = love.physics.newBody(self.world, x, y)
	local shape = love.physics.newChainShape(isloop, unpack(pointsTable))
	local fixture = love.physics.newFixture(body, shape)
	local obj=object("border",body,shape,fixture,color)
	table.insert(self.objects,obj)
	self:setMaterial(fixture,"wood")
	return obj
end

function physic:addPolygon(x,y,pointsTable,color)
	x=x or 0
	y=y or 0
	if type(pointsTable)~="table" or #pointsTable<4 then print(#pointsTable);return end
	color=color or {255,255,255,255}
	local body = love.physics.newBody(self.world, x, y,"dynamic")
	local shape = love.physics.newPolygonShape(unpack(pointsTable))
	local fixture = love.physics.newFixture(body, shape)
	local obj=object("polygon",body,shape,fixture,color)
	table.insert(self.objects,obj)
	self:setMaterial(fixture,"wood")
	return obj
end


function physic:addChain(x,y,len,pointsCount,color)
	x=x or 0
	y=y or 0 
	color=color or {255,255,255,255}
	local oneLen=math.floor(len/pointsCount)
	local bodys={}
	local shape = love.physics.newRectangleShape(0,0,oneLen,1)
	local joint
	local ball1=self:addBall(x,y,4)
	ball1.fixture:setGroupIndex(-1)
	ball1.body:setGravityScale( 0.01 )
	local ball2=self:addBall(x+len,y,4)
	ball2.fixture:setGroupIndex(-1)
	ball2.body:setGravityScale( 0.1 )
	for i=1,pointsCount do
		bodys[i]=love.physics.newBody(self.world, x+oneLen*(i-1)+oneLen/2, y,"dynamic")
		bodys[i]:setGravityScale( 0.1 )
		fixture = love.physics.newFixture(bodys[i], shape)
		if i~=1 then
			joint = love.physics.newDistanceJoint(bodys[i-1], bodys[i], x+oneLen*(i-1), y, x+oneLen*(i-1), y, false)
		end
		fixture:setDensity(0.01)
		fixture:setFriction(100)
		fixture:setRestitution(0.01)
		fixture:setGroupIndex(-1)
		if joint then
			joint:setDampingRatio(100)
			joint:setFrequency(10000)
		end
		local obj=object("polygon",bodys[i],shape,fixture,color)
		if i==1 then
			j=love.physics.newDistanceJoint(ball1.body, bodys[1], x, y, x, y, false)
			j:setDampingRatio(100)
			j:setFrequency(10000)
		end
		if i==pointsCount then
			j=love.physics.newDistanceJoint(ball2.body, bodys[i], x+len, y, x+len, y, false)
			print("ok")
			j:setDampingRatio(100)
			j:setFrequency(10000)
		end
		table.insert(self.objects,obj)


	end

end

function physic:setMaterial(fixture,m_type)
	if m_type=="wood" then
		fixture:setDensity(1)
		fixture:setFriction(1)
		fixture:setRestitution(0.2)
	elseif m_type=="rock" then
	end
end

function physic:draw()

------------------------绘制所有物体--------------------------------------------------

	if #self.objects==0 then return end
	for i,v in ipairs(self.objects) do
		v:draw()
	end

--------------------绘制所有连接-----------------------------
	if #self.joints==0  then return end
	for i,v in ipairs(self.joints) do
		v:draw()
	end
end



function physic:update(dt)
	if self.isPause==false then self.world:update(dt) end
end



function physic:addDistance(obj1,obj2,arg)
	local body1=obj1.body
	local body2=obj2.body
	local jointTemp
	if arg==nil then
		jointTemp = love.physics.newDistanceJoint(body1, body2, body1:getX(),body1:getY(), body2:getX(),body2:getY(), true)
	else
		jointTemp = love.physics.newDistanceJoint(body1, body2, arg.x1,arg.y1,arg.x2,arg.y2, arg.inter)
	end
	local createdJoint=joint("distance",jointTemp,obj1,obj2)
	table.insert(self.joints,createdJoint)
	table.insert(createdJoint.targetA.joints,createdJoint)
	table.insert(createdJoint.targetB.joints,createdJoint)
	return createdJoint
end

function physic:addWheel(obj1,obj2,arg) 
	local body1=obj1.body
	local body2=obj2.body
	local rad=physic:getRelativeRad(obj1,obj2)
	local ang=body1:getAngle()
	local ax,ay=physic:getRelativePos(1,0,rad)
	local jointTemp
	if arg==nil then
		jointTemp = love.physics.newWheelJoint(body1, body2, body2:getX(),body2:getY(), ax, ay, false)--第一个为线性，第二个为点
	else
		jointTemp = love.physics.newWheelJoint(body1, body2, arg.x1,arg.x2, arg.ax, arg.ay, arg.inter)
	end
	local createdJoint=joint("wheel",jointTemp,obj1,obj2)
	table.insert(self.joints,createdJoint)
	table.insert(createdJoint.targetA.joints,createdJoint)
	table.insert(createdJoint.targetB.joints,createdJoint)
	return createdJoint
end

function physic:addRope(obj1,obj2,arg)
	local body1=obj1.body
	local body2=obj2.body
	local distance=((body1:getX()-body2:getX())^2+(body1:getY()-body2:getY())^2)^0.5
	local jointTemp
	if arg==nil then
		jointTemp = love.physics.newRopeJoint(body1, body2, body1:getX(),body1:getY(), body2:getX(),body2:getY(),distance,true)
	else
		jointTemp = love.physics.newRopeJoint(body1, body2, arg.x1,arg.y1,arg.x2,arg.y2,arg.distance,arg.inter)
	end
	local createdJoint=joint("rope",jointTemp,obj1,obj2)
	table.insert(self.joints,createdJoint)
	table.insert(createdJoint.targetA.joints,createdJoint)
	table.insert(createdJoint.targetB.joints,createdJoint)
	return createdJoint
end 

function physic:addWeld(obj1,obj2,arg)
	local body1=obj1.body
	local body2=obj2.body
	local jointTemp
	if arg==nil then
		jointTemp = love.physics.newWeldJoint(body1, body2, body1:getX(),body1:getY(), false)
	else
		jointTemp = love.physics.newWeldJoint(body1, body2,  arg.x1,arg.y1,arg.x2,arg.y2, arg.inter)
	end
	local createdJoint=joint("weld",jointTemp,obj1,obj2)
	table.insert(self.joints,createdJoint)
	table.insert(createdJoint.targetA.joints,createdJoint)
	table.insert(createdJoint.targetB.joints,createdJoint)
	return createdJoint
end 

function physic:addRot(obj1,obj2,arg)
	local body1=obj1.body
	local body2=obj2.body
	local jointTemp
	if arg==nil then
		jointTemp = love.physics.newRevoluteJoint(body1, body2, body1:getX(),body1:getY(), false)
	else
		jointTemp = love.physics.newRevoluteJoint(body1, body2,arg.x1,arg.y1,arg.x2,arg.y2, arg.inter)
	end
	local createdJoint=joint("rot",jointTemp,obj1,obj2)
	table.insert(self.joints,createdJoint)
	table.insert(createdJoint.targetA.joints,createdJoint)
	table.insert(createdJoint.targetB.joints,createdJoint)
	return createdJoint
end

function physic:addPara(obj1,obj2,arg)
	local body1=obj1.body
	local body2=obj2.body
	local rad=physic:getRelativeRad(obj1,obj2)
	local ang=body1:getAngle()
	local ax,ay=physic:getRelativePos(1,0,rad)
	local jointTemp
	if arg==nil then
		jointTemp = love.physics.newPrismaticJoint(body1, body2, body1:getX(),body1:getY(),ax,ay, false)
	else
		jointTemp = love.physics.newPrismaticJoint(body1, body2, arg.x1,arg.x2, arg.ax, arg.ay, arg.inter)	
	end
	local createdJoint=joint("para",jointTemp,obj1,obj2,{ax,ay,rad-ang})
	table.insert(self.joints,createdJoint)
	table.insert(createdJoint.targetA.joints,createdJoint)
	table.insert(createdJoint.targetB.joints,createdJoint)
	return createdJoint
end	

function physic:addPully(obj1,obj2,arg)
	return createdJoint
end

return physic