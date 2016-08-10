local input=require("input")
local interface={
	selectObj=nil, --选中物体
	selectJoint=nil, --选中连接
	createObj=nil, --按下创造物体按键
	createJoint=nil, --按下创造链接按键
	oPop=nil,--原始显示组，用于擦除弹出界面的
	cPop=nil, --当前显示组
	createTag=nil, --创造物体的标签，标记其步骤
	createTemp={},
	input=nil,
	input_r=nil,
	selectPos=1,
	dragOx=nil,
	dragOy=nil,
	widget={},
	uiGroup={},
	oSelectObj=nil,
	oSelectJoint=nil,
	helpShow=false,
	dragJoint=nil
}
function interface:reset()
	ui:reset()
	self.selectObj=nil
	self.selectJoint=nil
	self.createObj=nil
	self.createJoint=nil
	self.oPop=nil
	self.cPop=nil
	self.createTag=nil
	self.createTemp={}
	self.input=nil
	self.input_r=nil
	self.selectPos=1
	self.dragOx=nil
	self.dragOy=nil
	self.widget={}
	self.uiGroup={}
	self:loadWidgets()
	self.oSelectObj=nil
	self.oSelectJoint=nil
	self.helpShow=false
	for i,v in ipairs(self.uiGroup) do
		ui:groupHide(v)
	end
	ui:groupShow(self.uiGroup.worldPop)
end
function interface:uiSynchronization()
	if self.selectObj~=nil then 
		if self.selectObj.obj_type=="circle" then
			self.uiGroup.circlePop_update()
		elseif self.selectObj.obj_type=="polygon" then
			self.uiGroup.boxPop_update() 
		end
	end
	if self.selectJoint~=nil then
		if self.selectJoint.j_type=="distance" then
			self.uiGroup.distancePop_update()
		end
	end
end

function interface:uiInit()
	if self.selectObj~=nil then
		if self.selectObj.obj_type=="circle" then
			self.uiGroup.circlePop_init()
		elseif  self.selectObj.obj_type=="polygon" then
			self.uiGroup.boxPop_init()
		end
	end
	if self.selectJoint~=nil then
		if self.selectJoint.j_type=="distance" then
			self.uiGroup.distancePop_init()
		end
	end

end

function interface:inputTest(dt)
	if self.input=="down"  then  self:select() end
	if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
	if self:objectDrag(dt) or self.input~="offlimit" then self:uiInit() else self:uiSynchronization() end
end	

function interface:select()
	local mousex,mousey= love.mouse.getPosition()
	local toggle=false
	local tab={}
	if love.keyboard.isDown("lctrl") then
		self.selectObj=nil
		for k,v in pairs(physic.joints) do
			local ret=v:select(mousex,mousey)
			if ret~=nil then
				table.insert(tab,v)
				table.insert(tab,ret)
				toggle=true
			end
		end
		if #tab==0 then return end
		if self.selectPos>#tab then self.selectPos=1 end
		self.selectJoint=tab[self.selectPos*2-1]
		self.selectJoint:getProperty()
		if toggle==false then self.selectJoint=nil;self.selectObj=nil end
		self:popSwitch()--只要选中就调用
		self.oSelectJoint=self.selectJoint
	else 
		self.selectJoint=nil
		for i,v in ipairs(physic.objects) do
			if v:select(mousex,mousey) then 
				table.insert(tab,v)
				toggle=true
			end
		end	
		if self.selectPos>#tab then self.selectPos=1 end
		self.selectObj=tab[self.selectPos]

		if toggle==false then self.selectObj=nil;self.selectJoint=nil end
		self:popSwitch()--只要选中就调用
		self.oSelectObj=self.selectObj
	end
--------------连接选择部分-------
end

function interface:objectDrag(dt)
	local mousex,mousey= love.mouse.getPosition()
	if self.createObj~=nil or self.createJoint~=nil then return end
	if self.selectObj~=nil then
		if self.selectObj.fixture:testPoint(mousex,mousey) and self.input=="down" then
			self.dragOx= mousex
			self.dragOy= mousey
			return true
		end

		if self.dragOx~=nil and (self.input=="dragging" or  self.input=="waiting") then

			local dx=mousex-self.dragOx
			local dy=mousey-self.dragOy
			self.selectObj.body:setX(self.selectObj.body:getX()+dx)
			self.selectObj.body:setY(self.selectObj.body:getY()+dy)
			self.selectObj.body:setLinearVelocity( 0, 0 )
			self.dragOx= mousex
			self.dragOy= mousey
			return true
		end
		if self.input=="dragged" or self.input=="clicked" then
			local dx=mousex-self.dragOx
			local dy=mousey-self.dragOy
			self.selectObj.body:setLinearVelocity( dx/dt, dy/dt )
			self.dragOx=nil
			self.dragOy=nil
			return true
		end
		return false
	elseif self.selectJoint~=nil then
		self.selectJoint:getProperty()
		if self.dragJoint==nil and self.input=="down" then
			self.dragOx= mousex
			self.dragOy= mousey
			self.dragJoint=self.selectJoint:select(mousex,mousey)
			return true
		end

		if self.dragOx~=nil and (self.input=="dragging" or  self.input=="waiting") then
			local dx=mousex-self.dragOx
			local dy=mousey-self.dragOy
			return true
		end
		if self.dragOx~=nil and (self.input=="dragged" or self.input=="clicked") then
			local dx=mousex-self.dragOx
			local dy=mousey-self.dragOy
			local dx=mousex-self.dragOx
			local dy=mousey-self.dragOy
			if self.dragJoint==1 then
				local function getRad(x1,y1,x2,y2)
					local rad=math.atan((x1-x2)/(y1-y2))
					if y1<y2 then rad=rad-math.pi end
					return -rad+math.pi/2
				end
				local rad=getRad(mousex,mousey,self.selectJoint.property.x2,self.selectJoint.property.y2)
				local ang=self.selectJoint.targetA.body:getAngle()
				local ax,ay=physic:getRelativePos(1,0,rad)
				self.others={ax,ay,rad-ang}
				self.selectJoint.property.x1=self.selectJoint.property.x1+dx
				self.selectJoint.property.y1=self.selectJoint.property.y1+dy
				self.selectJoint.property.ax=ax
				self.selectJoint.property.ay=ay
				self.selectJoint.property.distance=physic:getDistance(mousex,mousey,self.selectJoint.property.x2,self.selectJoint.property.y2)
				self.selectJoint:reBuild()
			else
				local function getRad(x1,y1,x2,y2)
					local rad=math.atan((x1-x2)/(y1-y2))
					if y1<y2 then rad=rad-math.pi end
					return -rad+math.pi/2
				end
				local rad=getRad(mousex,mousey,self.selectJoint.property.x1,self.selectJoint.property.y1)
				local ang=self.selectJoint.targetA.body:getAngle()
				local ax,ay=physic:getRelativePos(1,0,rad)
				self.selectJoint.property.x2=self.selectJoint.property.x2+dx
				self.selectJoint.property.y2=self.selectJoint.property.y2+dy
				self.selectJoint:reBuild()
			end
			self.dragOx=nil
			self.dragOy=nil
			self.dragJoint=nil
			return true
		end
		return false
	end
end

function interface:popSwitch()
	if self.selectObj~=nil then
		--展现关联菜单
		if self.selectObj.obj_type=="circle" then
			self.cPop=self.uiGroup.circlePop
			if self.oPop~=nil then 
				ui:groupHide(self.oPop)
				if self.selectObj~=self.oSelectObj then self.uiGroup.circlePop_init() end
				ui:groupShow(self.cPop)
			end
			self.oPop=self.cPop
			return
		end
		if self.selectObj.obj_type=="polygon" then
			self.cPop=self.uiGroup.boxPop
			if self.oPop~=nil then 
				ui:groupHide(self.oPop) 
				if self.selectObj~=self.oSelectObj then self.uiGroup.boxPop_init() end
				ui:groupShow(self.cPop)
			end
			self.oPop=self.cPop
			return
		end
	end

	if self.selectJoint~=nil then
		if self.selectJoint.j_type=="distance" then
			self.cPop=self.uiGroup.distancePop
			if self.oPop~=nil then 
				ui:groupHide(self.oPop) 
				if self.selectJoint~=self.oSelectJoint then self.uiGroup.distancePop_init() end
				ui:groupShow(self.cPop)
			end
			self.oPop=self.cPop
			return
		end
	end

	if self.cPop~=self.uiGroup.worldPop and self.oPop~=self.uiGroup.worldPop then	
		if self.oPop~=nil then ui:groupHide(self.oPop) end
		ui:groupShow(self.uiGroup.worldPop)
		self.cPop=self.uiGroup.worldPop
		self.oPop=self.uiGroup.worldPop
	end

end

function interface:draw() 
	--绘制选中的物体
	if self.selectObj~=nil then
		self.selectObj:draw("temp")
	end

	if self.selectJoint~=nil then
		self.selectJoint:draw("temp")
		if self.dragOx~=nil then
			local mousex,mousey = love.mouse.getPosition()
			if self.dragJoint==1 then
				love.graphics.setColor(255, 0, 0, 255)
				love.graphics.circle("line", mousex, mousey, 3)
				love.graphics.circle("line", self.selectJoint.property.x2, self.selectJoint.property.y2, 3)
				love.graphics.line(mousex, mousey,self.selectJoint.property.x2, self.selectJoint.property.y2)
				love.graphics.setColor(255, 255, 255, 255)
			elseif  self.dragJoint==2 then
				love.graphics.setColor(255, 0, 0, 255)
				love.graphics.circle("line", mousex, mousey, 3)
				love.graphics.circle("line", self.selectJoint.property.x1, self.selectJoint.property.y1, 3)
				love.graphics.line(mousex, mousey,self.selectJoint.property.x1, self.selectJoint.property.y1)
				love.graphics.setColor(255, 255, 255, 255)
			end
		end
	end
	--绘制由界面产生的临时图
	if self.createObj~=nil and self.createTag~="start" then 
		local x={};local y={}
		if self.createTemp.x==nil then return end
		for i=1,#self.createTemp.x do
			x[i]=self.createTemp.x[i]
			y[i]=self.createTemp.y[i]
		end
		local ox=x[1]
		local oy=y[1]
		local tx=x[2]
		local ty=y[2]
		if self.createObj=="circle" then 	
			love.graphics.setColor(255,0,0,255)
			local distance=((ox-tx)^2+(oy-ty)^2)^0.5
			love.graphics.circle("line", (ox+tx)/2, (oy+ty)/2, distance/2)
			love.graphics.setColor(255,255,255,255)
		end
		if self.createObj=="box" then
			love.graphics.setColor(255,0,0,255)
			love.graphics.polygon("line", ox,oy,ox,ty,tx,ty,tx,oy)
			love.graphics.setColor(255,255,255,255)
		end
		if self.createObj=="line" then 	
			love.graphics.setColor(255,0,0,255)
			love.graphics.line(ox,oy,tx,ty)
			love.graphics.setColor(255,255,255,255)
		end
		if self.createObj=="polygon" then 	
			love.graphics.setColor(255,0,0,255)
			local tab={}
			for i=1,#x do
				table.insert(tab,x[i])
				table.insert(tab,y[i])
			end
			table.insert(tab, love.mouse.getX())
			table.insert(tab, love.mouse.getY())
			table.insert(tab,x[1])
			table.insert(tab,y[1])			
			love.graphics.line(unpack(tab))
			love.graphics.setColor(255,255,255,255)
		end	
	end
	if self.createJoint~=nil then
		if self.createJoint~="gear" then
			if self.createTag=="select2" then
				self.createTemp.target1:draw("temp")
				love.graphics.setColor(255, 0, 0, 255)
				love.graphics.line(self.createTemp.target1.body:getX(),self.createTemp.target1.body:getY(),love.mouse.getPosition())
				love.graphics.setColor(255, 0, 0, 255)
			elseif self.createTag=="confirm" then
				self.createTemp.target1:draw("temp")
				self.createTemp.target2:draw("temp")
				love.graphics.setColor(255, 0, 0, 255)
				love.graphics.line(self.createTemp.target1.body:getX(),self.createTemp.target1.body:getY(),self.createTemp.target2.body:getX(),self.createTemp.target2.body:getY())
				love.graphics.setColor(255, 0, 0, 255)
			end
		end
	end
end

function interface:update(dt) --循环	
	self.input=input:test()
	self.input_r=input:test_r()

	if self.createObj~=nil then self:createObjFunc();return end
	if self.createJoint~=nil then self:createJointFunc(); return end
	self:inputTest(dt) --等以后换个名吧，这个是针对未按下任何创建的时候选择或拖动的
end

function interface:createObjFunc()
	self.createTag=self.createTag or "start"
	local test=self.input

	if self.createObj=="circle" then
		if self.createTag=="start" then
			if test=="down" then
				self.createTag="making"
				self.createTemp={}
				self.createTemp.x={};self.createTemp.y={}
				self.createTemp.x[1],self.createTemp.y[1]= love.mouse.getPosition()
			end
		end
		if self.createTag=="making" then
			if test=="clicked" then
				self.createTag="start"
				return
			elseif test=="dragged" then
				self.createTemp.x[2],self.createTemp.y[2]= love.mouse.getPosition()
				self.createTag="end"
			elseif test=="dragging" or test=="down"then
				self.createTemp.x[2],self.createTemp.y[2]= love.mouse.getPosition()
			end
		end
		if self.createTag=="end" then
			if self.createTemp.x[2]~=nil then
				local distance=((self.createTemp.x[1]-self.createTemp.x[2])^2+(self.createTemp.y[1]-self.createTemp.y[2])^2)^0.5--add circle
				physic:addBall( (self.createTemp.x[1]+self.createTemp.x[2])/2, (self.createTemp.y[1]+self.createTemp.y[2])/2, distance/2)
			end
			self.createTag=nil
			self.createObj=nil
			ui:groupReset(self.uiGroup.leftZone)
		end
	end

	if self.createObj=="box" then
		if self.createTag=="start" then
			if test=="down" then
				self.createTag="making"
				self.createTemp={}
				self.createTemp.x={};self.createTemp.y={}
				self.createTemp.x[1],self.createTemp.y[1]= love.mouse.getPosition()
			end
		end
		if self.createTag=="making" then
			if test=="clicked" then
				self.createTag="start"
				return
			elseif test=="dragged" then
				self.createTemp.x[2],self.createTemp.y[2]= love.mouse.getPosition()
				self.createTag="end"
			elseif test=="dragging" or test=="down"then
				self.createTemp.x[2],self.createTemp.y[2]= love.mouse.getPosition()
			end
		end
		if self.createTag=="end" then
			if self.createTemp.x[2]~=nil then
				physic:addBox( (self.createTemp.x[1]+self.createTemp.x[2])/2, (self.createTemp.y[1]+self.createTemp.y[2])/2, math.abs(self.createTemp.x[1]-self.createTemp.x[2]),math.abs(self.createTemp.y[1]-self.createTemp.y[2]))
			end
			self.createTag=nil
			self.createObj=nil
			ui:groupReset(self.uiGroup.leftZone)
		end
	end

	if self.createObj=="line" then
		if self.createTag=="start" then
			if test=="down" then
				self.createTag="making"
				self.createTemp={}
				self.createTemp.x={};self.createTemp.y={}
				self.createTemp.x[1],self.createTemp.y[1]= love.mouse.getPosition()
			end
		end
		if self.createTag=="making" then
			if test=="clicked" then
				self.createTag="start"
				return
			elseif test=="dragged" then
				self.createTemp.x[2],self.createTemp.y[2]= love.mouse.getPosition()
				self.createTag="end"
			elseif test=="dragging" or test=="down"then
				self.createTemp.x[2],self.createTemp.y[2]= love.mouse.getPosition()
			end
		end
		if self.createTag=="end" then
			if self.createTemp.x[2]~=nil then
				physic:addBorder(0,0,{self.createTemp.x[1],self.createTemp.y[1],self.createTemp.x[2],self.createTemp.y[2]})
			end
			self.createTag=nil
			self.createObj=nil
			ui:groupReset(self.uiGroup.leftZone)
		end
	end

	if self.createObj=="chain" then
		if self.createTag=="start" then
			if test=="down" then
				self.createTag="making"
				self.createTemp={}
				self.createTemp.x={};self.createTemp.y={}
				self.createTemp.x[1],self.createTemp.y[1]= love.mouse.getPosition()
			end
		end
		if self.createTag=="making" then
			if test=="clicked" then
				self.createTag="start"
				return
			elseif test=="dragged" then
				self.createTemp.x[2],self.createTemp.y[2]= love.mouse.getPosition()
				self.createTag="end"
			elseif test=="dragging" or test=="down"then
				self.createTemp.x[2],self.createTemp.y[2]= love.mouse.getPosition()
			end
		end
		if self.createTag=="end" then
			if self.createTemp.x[2]~=nil then
				local len = physic:getDistance(self.createTemp.x[1],self.createTemp.y[1],self.createTemp.x[2],self.createTemp.y[2])
				physic:addChain(self.createTemp.x[1],self.createTemp.y[1],len,math.floor(len/10))
			end
			self.createTag=nil
			self.createObj=nil
			ui:groupReset(self.uiGroup.leftZone)
		end
	end
	if self.createObj=="polygon" then
		if self.createTag=="start" then
			if test=="down" then
				self.createTag="making"
				self.createTemp={}
				self.createTemp.x={};self.createTemp.y={}
				self.createTemp.x[1],self.createTemp.y[1]= love.mouse.getPosition()
			end
		end
		if self.createTag=="making" then
			local test_r=self.input_r
			if test=="clicked" then
				self.createTag="start"
				return
			elseif test=="dragged" then
				self.createTemp.x[#self.createTemp.x+1],self.createTemp.y[#self.createTemp.x+1]= love.mouse.getPosition()
				self.createTag="end"
			elseif (test=="dragging" or test=="down") and test_r=="clicked" or test_r=="dragged" then
				if #self.createTemp.x==7 then
					self.createTag="end"
					return
				end
				self.createTemp.x[#self.createTemp.x+1],self.createTemp.y[#self.createTemp.x+1]= love.mouse.getPosition()
			end
		end
		if self.createTag=="end" then
			if #self.createTemp.x>=3 then
				local tab={}
				for i=1,#self.createTemp.x do
					table.insert(tab,self.createTemp.x[i]-self.createTemp.x[1])
					table.insert(tab,self.createTemp.y[i]-self.createTemp.y[1])
				end
				table.insert(tab,tab[1])
				table.insert(tab,tab[2])			
				local x=self.createTemp.x[1]
				local y=self.createTemp.y[1]
				physic:addPolygon(x,y,tab)
			end
			self.createTag=nil
			self.createObj=nil
			ui:groupReset(self.uiGroup.leftZone)
		end
	end
end

function interface:createJointFunc()
	self.createTag=self.createTag or "start"
	if self.createJoint=="rope" then
		if self.createTag=="start" then
			self.createTemp={}
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			else 
				self.createTag="select1"
			end
		end
		if self.createTag=="select1" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="select2" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil and self.selectObj~= self.createTemp.target1 then
				self.createTag="confirm"
				self.createTemp.target2=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="confirm" then
			ui:groupShow(self.uiGroup.confirmPop)
		end
		if self.createTag=="done" then
			physic:addRope(self.createTemp.target1,self.createTemp.target2)
			ui:groupReset(self.uiGroup.leftZone)
			self.createTag=nil
        	self.createJoint=nil
		end
	end

	if self.createJoint=="distance" then
		if self.createTag=="start" then
			self.createTemp={}
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			else 
				self.createTag="select1"
			end
		end
		if self.createTag=="select1" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="select2" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil and self.selectObj~= self.createTemp.target1 then
				self.createTag="confirm"
				self.createTemp.target2=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="confirm" then
			ui:groupShow(self.uiGroup.confirmPop)
		end
		if self.createTag=="done" then
			physic:addDistance(self.createTemp.target1,self.createTemp.target2)
			ui:groupReset(self.uiGroup.leftZone)
			self.createTag=nil
        	self.createJoint=nil
		end
	end

	if self.createJoint=="rot" then
		if self.createTag=="start" then
			self.createTemp={}
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			else 
				self.createTag="select1"
			end
		end
		if self.createTag=="select1" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="select2" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil and self.selectObj~= self.createTemp.target1 then
				self.createTag="confirm"
				self.createTemp.target2=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="confirm" then
			ui:groupShow(self.uiGroup.confirmPop)
		end
		if self.createTag=="done" then
			physic:addRot(self.createTemp.target1,self.createTemp.target2)
			ui:groupReset(self.uiGroup.leftZone)
			self.createTag=nil
        	self.createJoint=nil
		end
	end

	if self.createJoint=="para" then
		if self.createTag=="start" then
			self.createTemp={}
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			else 
				self.createTag="select1"
			end
		end
		if self.createTag=="select1" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="select2" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil and self.selectObj~= self.createTemp.target1 then
				self.createTag="confirm"
				self.createTemp.target2=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="confirm" then
			ui:groupShow(self.uiGroup.confirmPop)
		end
		if self.createTag=="done" then
			physic:addPara(self.createTemp.target1,self.createTemp.target2)
			ui:groupReset(self.uiGroup.leftZone)
			self.createTag=nil
        	self.createJoint=nil
		end
	end

	if self.createJoint=="pully" then
		if self.createTag=="start" then
			self.createTemp={}
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			else 
				self.createTag="select1"
			end
		end
		if self.createTag=="select1" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="select2" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil and self.selectObj~= self.createTemp.target1 then
				self.createTag="confirm"
				self.createTemp.target2=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="confirm" then
			ui:groupShow(self.uiGroup.confirmPop)
		end
		if self.createTag=="done" then
			physic:addPully(self.createTemp.target1,self.createTemp.target2)
			ui:groupReset(self.uiGroup.leftZone)
			self.createTag=nil
        	self.createJoint=nil
		end
	end	

	if self.createJoint=="weld" then
		if self.createTag=="start" then
			self.createTemp={}
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			else 
				self.createTag="select1"
			end
		end
		if self.createTag=="select1" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil then
				self.createTag="select2"
				self.createTemp.target1=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="select2" then
			if self.input=="down" then  self:select() end
			if self.input_r=="clicked" then self.selectPos=self.selectPos+1;self:select() end
			if self.selectObj~=nil and self.selectObj~= self.createTemp.target1 then
				self.createTag="confirm"
				self.createTemp.target2=self.selectObj
				self.selectObj=nil
			end
		end
		if self.createTag=="confirm" then
			ui:groupShow(self.uiGroup.confirmPop)
		end
		if self.createTag=="done" then
			physic:addWeld(self.createTemp.target1,self.createTemp.target2)
			ui:groupReset(self.uiGroup.leftZone)
			self.createTag=nil
        	self.createJoint=nil
		end
	end	


end

function interface:loadWidgets()
	require("buttons")(self)
	ui:groupShow(interface.uiGroup.worldPop)
	interface.oPop=interface.uiGroup.worldPop
	interface.cPop=interface.uiGroup.worldPop
end
interface:loadWidgets()

return interface
