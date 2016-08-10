local connection=class{
	init=function(self,j_type,joint,targetA,targetB,others)
		self.j_type=j_type
		self.targetA=targetA
		self.targetB=targetB
		self.joint=joint
		self.others=others
		self.anchorA={x=self.targetA.body:getX(),y=self.targetA.body:getY()}
		self.anchorB={x=self.targetB.body:getX(),y=self.targetB.body:getY()}
		self.property={}
	end 	
}

function connection:linkTo(body,how)

end 

function connection:getProperty()
	if self.j_type=="distance" then
		self.property.x1,self.property.y1,self.property.x2,self.property.y2=self.joint:getAnchors()
		self.inter=self.joint:getCollideConnected()
	elseif self.j_type=="rope" then
		self.property.x1,self.property.y1,self.property.x2,self.property.y2=self.joint:getAnchors()
		self.property.distance=((self.property.x1-self.property.x2)^2+(self.property.y1-self.property.y2)^2)^0.5
		self.inter=self.joint:getCollideConnected()
	elseif self.j_type=="rot" then
		self.property.x1,self.property.y1,self.property.x2,self.property.y2=self.joint:getAnchors()
		self.inter=self.joint:getCollideConnected()
	elseif self.j_type=="weld" then
		self.property.x1,self.property.y1,self.property.x2,self.property.y2=self.joint:getAnchors()
		self.inter=self.joint:getCollideConnected()
	elseif self.j_type=="para" then
		self.property.x1,self.property.y1,self.property.x2,self.property.y2=self.joint:getAnchors()
		self.inter=self.joint:getCollideConnected()
	elseif self.j_type=="wheel" then
		self.property.x1,self.property.y1,self.property.x2,self.property.y2=self.joint:getAnchors()
		self.inter=self.joint:getCollideConnected()
	end
end


function connection:reBuild()
	self.joint:destroy()
	local x1=self.property.x1
	local y1=self.property.y1
	local x2=self.property.x2
	local y2=self.property.y2
	local collideConnected=self.property.inter
	local ax=self.property.ax
	local ay=self.property.ay
	local lenth=self.property.distance
	if self.j_type=="distance" then
		self.joint = love.physics.newDistanceJoint(self.targetA.body, self.targetB.body, x1, y1, x2, y2, collideConnected)
	elseif self.j_type=="rope" then
		self.joint = love.physics.newRopeJoint(self.targetA.body, self.targetB.body, x1, y1, x2, y2, lenth, collideConnected)
	elseif self.j_type=="rot" then
		self.joint = love.physics.newRevoluteJoint(self.targetA.body, self.targetB.body, x1, y1, collideConnected)
	elseif self.j_type=="weld" then
		self.joint = love.physics.newWeldJoint(self.targetA.body, self.targetB.body, x1, y1, x2, y2, collideConnected)
	elseif self.j_type=="para" then
		self.joint = love.physics.newPrismaticJoint(self.targetA.body, self.targetB.body, x1, y1, x2, y2, collideConnected)
	elseif self.j_type=="wheel" then
		self.joint = love.physics.newWheelJoint(self.targetA.body, self.targetB.body, x1, y1, x2, y2, collideConnected)
	end
	interface.selectJoint=self
end


function connection:select(mousex,mousey)

	self.anchorA.x,self.anchorA.y,self.anchorB.x,self.anchorB.y=self.joint:getAnchors()
	if physic:getDistance(self.anchorA.x,self.anchorA.y,mousex,mousey)<=10 then return 1 end
	if physic:getDistance(self.anchorB.x,self.anchorB.y,mousex,mousey)<=10 then return 2 end
end

function connection:delete()
	self.joint:destroy()
	interface.selectJoint=nil
	physic:removeJoint(self)
end

function connection:draw(how)
	local v=self
	if how=="temp" then
		love.graphics.setColor(255,0,0,255)
	else
		love.graphics.setColor(0,255,255,255)
	end
	if 	v.j_type=="distance" then
		local tab={v.joint:getAnchors()}
		local tab1={}
		local tab2={}
		local rad=physic:getRelativeRad(self.targetA,self.targetB)
		for i=1,#tab,2 do
			love.graphics.circle("line", tab[i], tab[i+1], 3)
			local x1,y1=physic:getRelativePos(0,3,rad)
			local x2,y2=physic:getRelativePos(0,-3,rad)
			table.insert(tab1, 1, tab[i]+x1)
			table.insert(tab1, 2, tab[i+1]+y1)
			table.insert(tab2, 1, tab[i]+x2)
			table.insert(tab2, 2, tab[i+1]+y2)
		end
		--love.graphics.line(v.joint:getAnchors())
		love.graphics.line(unpack(tab1))
		love.graphics.line(unpack(tab2))
	end		
	if 	v.j_type=="rope" then
		local tab={v.joint:getAnchors()}
		for i=1,#tab,2 do
			love.graphics.circle("line", tab[i], tab[i+1], 3)
		end
		love.graphics.line(v.joint:getAnchors())
	end
	if 	v.j_type=="wheel" then
		love.graphics.line(v.joint:getAnchors())
	end
	if 	v.j_type=="weld" then
		local ox=v.targetA.body:getX()
		local oy=v.targetA.body:getY()
		local tx=v.targetB.body:getX()
		local ty=v.targetB.body:getY()
		love.graphics.rectangle("line", ox-3, oy-3, 7, 7)
		love.graphics.rectangle("line", tx-3, ty-3, 7, 7)
		local rad=physic:getRelativeRad(self.targetA,self.targetB)
		local x1,y1=physic:getRelativePos(0,3,rad)
		local x2,y2=physic:getRelativePos(0,-3,rad)
		love.graphics.line(ox+x1, oy+y1, tx+x1, ty+y1)
		love.graphics.line(ox+x2, oy+y2, tx+x2, ty+y2)
	end
	if 	v.j_type=="rot" then
		local ox=v.targetA.body:getX()
		local oy=v.targetA.body:getY()
		local tx=v.targetB.body:getX()
		local ty=v.targetB.body:getY()
		love.graphics.rectangle("line", tx-3, ty-3, 7, 7)
		love.graphics.circle("line", ox, oy, 3)
		local rad=physic:getRelativeRad(self.targetB,self.targetA)
		local x1,y1=physic:getRelativePos(0,3,rad)
		local x2,y2=physic:getRelativePos(0,-3,rad)
		love.graphics.line(ox+x1, oy+y1, tx+x1, ty+y1)
		love.graphics.line(ox+x2, oy+y2, tx+x2, ty+y2)
	end	
	if 	v.j_type=="para" then
		local ox=v.targetA.body:getX()
		local oy=v.targetA.body:getY()
		local tx=v.targetB.body:getX()
		local ty=v.targetB.body:getY()
		local rad=physic:getRelativeRad(self.targetA,self.targetB)
		local ang=self.targetA.body:getAngle()+self.others[3]
		local lower,upper=v.joint:getLimits()
		love.graphics.rectangle("line", tx-3, ty-3, 7, 7)
		local dx1,dy1=physic:getRelativePos(-7-upper/64*2,-7,ang)
		local dx2,dy2=physic:getRelativePos(7-lower/64*2,-7,ang)
		local dx3,dy3=physic:getRelativePos(7-lower/64*2,7,ang)
		local dx4,dy4=physic:getRelativePos(-7-upper/64*2,7,ang)
		love.graphics.line(ox+dx3,oy+dy3,ox+dx4,oy+dy4,ox+dx1,oy+dy1,ox+dx2,oy+dy2)
		love.graphics.rectangle("line", ox-3, oy-3, 7, 7)
		local x1,y1=physic:getRelativePos(0,3,rad)
		local x2,y2=physic:getRelativePos(0,-3,rad)
		love.graphics.line(ox+x1, oy+y1, tx+x1, ty+y1)
		love.graphics.line(ox+x2, oy+y2, tx+x2, ty+y2)
	end	

	love.graphics.setColor(255,255,255,255)

end
return connection