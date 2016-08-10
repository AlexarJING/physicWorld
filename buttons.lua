local function loadUi(interface)
    local label 
    local helpZone=ui:creatGroup()
    label=ui:addLabel("123",230,60)
    ui:addToGroup(label,helpZone)
    interface.uiGroup.helpZone=helpZone
    ui:groupHide(helpZone)
    ------------顶部控制区-------------------
    local topZone=ui:creatGroup()
    local f=function(this) 
        physic.isPause=false
        ui:groupReset(topZone)
        this.state="active"
    end
    local startButton=ui:addButton("开始",380,20,100,30,f)
    ui:addToGroup(startButton,topZone)
    local f=function(this) 
        physic.isPause=true
        ui:groupReset(topZone)
        this.state="active"
    end
    local pauseButton=ui:addButton("暂停",580,20,100,30,f)
    ui:addToGroup(pauseButton,topZone)
    local f=function()
        physic=require("physicWorld")()
        ui:reset()
        interface:reset()
        physic:addBorder(0,0,{200,10,200,650,1080,650,1080,10})
    end
    ui:addToGroup(ui:addButton("重置",780,20,100,30,f),topZone)
    local f=function()
        if interface.helpShow==false then
            if interface.cPop==interface.uiGroup.worldPop then
                interface.uiGroup.helpZone[1].txt=
    [[
    欢迎来到物理世界!
    在这个世界里，可以制定物理规则，创造物体等。

    基本操作：
    鼠标单击物体来选中，可拖动，释放鼠标时的速度决定物体速度。
    单击后将弹出物体的基本属性，调整滑块来设置
    点击右键来实现同一位置不同物体的切换
    esc取消选择和各种操作
    上方开始、暂停、重置按钮来控制世界
    点击左侧上方各种创建按钮后，世界框内拖动来创建物体。
    点击左侧下方各种按钮来创建连接，点击后单击物体来选择，需选择2个不同物体。
    选中物体后点击下方施力区可模拟施力。
    现在你可以尝试一下咯。
    --世界控制
    X轴重力，横向的重力，可为负数
    Y轴重力，纵向的重力，可为负数
    比例尺，屏幕上的距离与真实物体的比例，默认1:64,
    ]]
            end
            if interface.cPop==interface.uiGroup.circlePop then
                interface.uiGroup.helpZone[1].txt=
    [[
    --圆形控制
    x,y决定圆的位置，r决定圆的半径
    密度决定圆的质量
    弹性决定圆的回弹程度1为完全反弹
    摩擦决定圆对于界面的减速程度
    删除为删除物体
    固定可将物体位置固定
    ]]
            end
            ui:groupShow(interface.uiGroup.helpZone)
            interface.helpShow=true
        else
            ui:groupHide(interface.uiGroup.helpZone)
            interface.helpShow=false
        end
    end
    ui:addToGroup(ui:addButton("帮助",1100,670,150,30,f),topZone)

    interface.uiGroup.topZone=topZone
    ----------左侧物体添加区------------------------
    local leftZone=ui:creatGroup()
    interface.uiGroup.leftZone=leftZone
    local f=function(this)
        interface.createJoint=nil
        interface.createTag=nil
        interface.createObj="circle"
        ui:groupReset(leftZone)
        this.state="active"
    end
    local circleButton=ui:addButton("圆形",50,50,100,30,f)
    ui:addToGroup(circleButton,leftZone)
    local f=function(this)
        interface.createJoint=nil
        interface.createTag=nil
        interface.createObj="box"
        ui:groupReset(leftZone)
        this.state="active"   
    end
    local boxButton=ui:addButton("矩形",50,100,100,30,f)
    ui:addToGroup(boxButton,leftZone)
    local f=function(this) 
        interface.createJoint=nil
        interface.createTag=nil
        interface.createObj="line"
        ui:groupReset(leftZone)
        this.state="active"  
    end
    local lineButton=ui:addButton("直线",50,150,100,30,f)
    ui:addToGroup(lineButton,leftZone)
    local f=function(this) 
        interface.createObj="polygon"
        interface.createJoint=nil
        interface.createTag=nil
        ui:groupReset(leftZone)
        this.state="active"  
    end
    local polyButton=ui:addButton("多边形",50,200,100,30,f)
    ui:addToGroup(polyButton,leftZone)
    local f=function(this) 
        interface.createObj="chain"
        interface.createJoint=nil
        interface.createTag=nil
        ui:groupReset(leftZone)
        this.state="active"  
    end
    local chainButton=ui:addButton("绳索",50,250,100,30,f)
    ui:addToGroup(chainButton,leftZone)
    ----------左侧关节添加区-------------------------
   local f=function(this) 
        interface.createObj=nil
        interface.createTag=nil
        interface.createJoint="rope"
        ui:groupReset(leftZone)
        this.state="active"
    end
    local ropeButton=ui:addButton("绳索连接",50,350,100,30,f)
    ui:addToGroup(ropeButton,leftZone)
    local f=function(this)
        interface.createObj=nil
        interface.createTag=nil
        interface.createJoint="distance"
        ui:groupReset(leftZone)
        this.state="active"
    end
    local distanceButton=ui:addButton("硬杆连接",50,400,100,30,f)
    ui:addToGroup(distanceButton,leftZone)
    local f=function(this)
        interface.createObj=nil
        interface.createTag=nil
        interface.createJoint="rot"
        ui:groupReset(leftZone)
        this.state="active"
    end
    local rollButton=ui:addButton("轴连接",50,450,100,30,f)
    ui:addToGroup(rollButton,leftZone)
    local f=function(this)
        interface.createObj=nil
        interface.createTag=nil
        interface.createJoint="para"
        ui:groupReset(leftZone)
        this.state="active"
    end
    local paraButton=ui:addButton("活塞连接",50,500,100,30,f)
    ui:addToGroup(paraButton,leftZone)
    local f=function(this) 
        interface.createObj=nil
        interface.createTag=nil
        interface.createJoint="pully"
        ui:groupReset(leftZone)
        this.state="active"
    end
    local pullyButton=ui:addButton("滑轮连接",50,550,100,30,f)  
    ui:addToGroup(pullyButton,leftZone)
    local f=function(this)
        interface.createObj=nil
        interface.createTag=nil
        interface.createJoint="weld"
        ui:groupReset(leftZone)
        this.state="active"   
    end
    local weldButton=ui:addButton("焊接连接",50,600,100,30,f)
    ui:addToGroup(weldButton,leftZone)
    local f=function(this)
        interface.createObj=nil
        interface.createTag=nil
        --interface.createJoint="gear"
        ui:groupReset(leftZone)
        --this.state="active" 
    end
    local gearButton=ui:addButton("传动连接",50,650,100,30,f)
    ui:addToGroup(gearButton,leftZone)
    
    --------底部施力区------------------------
    local downZone=ui:creatGroup()
    local f=function() 
        if interface.selectObj~=nil then 
            interface.selectObj.body:applyLinearImpulse( 500, 0 )
        end
    end
    local lineImpButton=ui:addButton("施加线性冲量",250,670,150,30,f)
    ui:addToGroup(lineImpButton,downZone)
    local f=function() 
        if interface.selectObj~=nil then 
            interface.selectObj.body:applyAngularImpulse( 50000 )
        end
    end
    local radImpButton=ui:addButton("施加角冲量",450,670,150,30,f)     
    ui:addToGroup(radImpButton,downZone)
    local f=function() 
        if interface.selectObj~=nil then 
            interface.selectObj.body:applyLinearImpulse( -500, 0 )
        end
    end
    local lineMotorButton=ui:addButton("施加反向线性",650,670,150,30,f)
    ui:addToGroup(lineMotorButton,downZone)
    local f=function()
        if interface.selectObj~=nil then 
            interface.selectObj.body:applyAngularImpulse( -50000 )
        end
    end
    local radMotorButton=ui:addButton("施加反向角",850,670,150,30,f) 
    ui:addToGroup(radMotorButton,downZone)
    interface.uiGroup.downZone=downZone
end

local function loadObjPop(interface)
    local label
    -----------世界弹出----------------
    local worldPop=ui:creatGroup()
    label=ui:addLabel("X轴重力",1100,30)
    local gx,gy=physic.world:getGravity()
    local gxlabel=ui:addLabel(gx/love.physics.getMeter(),1200,30)
    local f=function(this)
        gxlabel.txt=this.value
        gx=this.value*love.physics.getMeter()
        physic.world:setGravity(gx,gy)
    end
    local gxctrl=ui:addSlider(gx,-100,100,1100,60,150,20,f)
    ui:addToGroup(label,worldPop)
    ui:addToGroup(gxlabel,worldPop)
    ui:addToGroup(gxctrl,worldPop)


    label=ui:addLabel("Y轴重力",1100,100)
    local gx,gy=physic.world:getGravity()
    local gylabel=ui:addLabel(gy/love.physics.getMeter(),1200,100)
    local f=function(this) 
        gylabel.txt=this.value 
        gy=this.value*love.physics.getMeter()
        physic.world:setGravity(gx,gy)
    end
    local gyctrl=ui:addSlider(gy/love.physics.getMeter(),-100,100,1100,130,150,20,f)

    ui:addToGroup(label,worldPop)
    ui:addToGroup(gylabel,worldPop)
    ui:addToGroup(gyctrl,worldPop)

    label=ui:addLabel("比例尺",1100,170)
    local meter=love.physics.getMeter()
    local meterlabel=ui:addLabel(tostring(meter),1200,170)
    local f=function(this) 
        meterlabel.txt=this.value 
        love.physics.setMeter(this.value)
    end
    local meterctrl=ui:addSlider(meter,0.1,100,1100,200,150,20,f)      
    ui:addToGroup(label,worldPop)
    ui:addToGroup(meterlabel,worldPop)
    ui:addToGroup(meterctrl,worldPop)
    ui:groupHide(worldPop)
    interface.uiGroup.worldPop=worldPop
    -------------圆形弹出-------------
    local circlePop=ui:creatGroup()
    label=ui:addLabel("X坐标",1100,30)
    local xlabel=ui:addLabel(200,1200,30)
    local f=function(this) 
        xlabel.txt=this.value
        interface.selectObj.body:setX(this.value)
    end
    local xctrl=ui:addSlider(200,200,1020,1100,60,150,20,f)
    ui:addToGroup(label,circlePop)
    ui:addToGroup(xlabel,circlePop)
    ui:addToGroup(xctrl,circlePop)

    label=ui:addLabel("Y坐标",1100,100)
    local ylabel=ui:addLabel(tostring(0),1200,100)
    local f=function(this) 
        ylabel.txt=this.value
        interface.selectObj.body:setY(this.value)
    end
    local yctrl=ui:addSlider(250,0,800,1100,130,150,20,f)
    ui:addToGroup(label,circlePop)
    ui:addToGroup(ylabel,circlePop)
    ui:addToGroup(yctrl,circlePop)

    label=ui:addLabel("半径R",1100,170)
    local rlabel=ui:addLabel(tostring(0),1200,170)
    local f=function(this) 
        if this.value~=rlabel then
            rlabel.txt=this.value 
            interface.selectObj.fixture:getShape():setRadius(this.value)
            interface.selectObj.shape:setRadius(this.value)
        end
    end
    local rctrl=ui:addSlider(0,1,500,1100,200,150,20,f)
    ui:addToGroup(label,circlePop)
    ui:addToGroup(rlabel,circlePop)
    ui:addToGroup(rctrl,circlePop)

    label=ui:addLabel("密度D",1100,240)
    local dlabel=ui:addLabel(tostring(1),1200,240)
    local f=function(this) 
        dlabel.txt=this.value 
        interface.selectObj.fixture:setDensity(this.value)
    end
    local dctrl=ui:addSlider(1,1,10,1100,270,150,20,f)
    ui:addToGroup(label,circlePop)
    ui:addToGroup(dlabel,circlePop)
    ui:addToGroup(dctrl,circlePop)

    label=ui:addLabel("弹性re",1100,310)
    local relabel=ui:addLabel(tostring(1),1200,310)
    local f=function(this)
        relabel.txt=this.value
        interface.selectObj.fixture:setRestitution(this.value)
    end
    local rectrl=ui:addSlider(1,0,1,1100,340,150,20,f)
    ui:addToGroup(label,circlePop)
    ui:addToGroup(relabel,circlePop)
    ui:addToGroup(rectrl,circlePop)

    label=ui:addLabel("摩擦f",1100,380)
    local flabel=ui:addLabel(tostring(0),1200,380)
    local f=function(this) 
        flabel.txt=this.value
        interface.selectObj.fixture:setFriction(this.value) 
    end
    local fctrl=ui:addSlider(0,0,10,1100,410,150,20,f)
    ui:addToGroup(label,circlePop)
    ui:addToGroup(flabel,circlePop)
    ui:addToGroup(fctrl,circlePop)

    label=ui:addLabel("删除物体",1100,450)
    f=function(this) 
      interface.selectObj:delete()
    end
    local delbutton=ui:addButton("删除",1200,450,60,20,f)
    ui:addToGroup(label,circlePop)
    ui:addToGroup(delbutton,circlePop)

    label=ui:addLabel("固定/释放",1100,490)
    f=function(this) 
        if interface.selectObj.body:getType()=="static" then
            interface.selectObj.body:setType("dynamic")
        else 
            interface.selectObj.body:setType("static")
        end
    end
    local fixbutton=ui:addButton("执行",1200,490,60,20,f) 
    ui:addToGroup(label,circlePop)
    ui:addToGroup(fixbutton,circlePop)
    label=ui:addLabel("选择连接",1100,530)
    f=function(this) 
        print("show")
    end
    local selbutton=ui:addButton("选择",1200,530,60,20,f) 
    ui:addToGroup(label,circlePop)
    ui:addToGroup(selbutton,circlePop)    



    ui:groupHide(circlePop)
    interface.uiGroup.circlePop=circlePop
    interface.uiGroup.circlePop_init=function()
        xctrl.value=interface.selectObj.body:getX()
        xctrl.callback(xctrl)
        yctrl.value=interface.selectObj.body:getY()
        yctrl.callback(yctrl)
        rctrl.value=interface.selectObj.shape:getRadius()
        rctrl.callback(rctrl)
        dctrl.value=interface.selectObj.fixture:getDensity()
        dctrl.callback(dctrl)
        rectrl.value=interface.selectObj.fixture:getRestitution()
        rectrl.callback(rectrl)
        fctrl.value=interface.selectObj.fixture:getFriction()
        fctrl.callback(fctrl)
    end
    interface.uiGroup.circlePop_update=function()
        
        xlabel.txt=xctrl.value
        ylabel.txt=yctrl.value
        rlabel.txt=rctrl.value
        dlabel.txt=dctrl.value
        relabel.txt=rectrl.value
        flabel.txt=fctrl.value
    end
    -------------矩形弹出-------------
   local boxPop=ui:creatGroup()
    label=ui:addLabel("X坐标",1100,30)
    local xlabel=ui:addLabel(200,1200,30)
    local f=function(this) 
        xlabel.txt=this.value
        interface.selectObj.body:setX(this.value)
    end
    local xctrl=ui:addSlider(200,200,1020,1100,60,150,20,f)
    ui:addToGroup(label,boxPop)
    ui:addToGroup(xlabel,boxPop)
    ui:addToGroup(xctrl,boxPop)

    label=ui:addLabel("Y坐标",1100,100)
    local ylabel=ui:addLabel(tostring(0),1200,100)
    local f=function(this) 
        ylabel.txt=this.value
        interface.selectObj.body:setY(this.value)
    end
    local yctrl=ui:addSlider(250,0,800,1100,130,150,20,f)
    ui:addToGroup(label,boxPop)
    ui:addToGroup(ylabel,boxPop)
    ui:addToGroup(yctrl,boxPop)


    label=ui:addLabel("密度D",1100,240)
    local dlabel=ui:addLabel(tostring(1),1200,240)
    local f=function(this) 
        dlabel.txt=this.value 
        interface.selectObj.fixture:setDensity(this.value)
    end
    local dctrl=ui:addSlider(1,1,10,1100,270,150,20,f)
    ui:addToGroup(label,boxPop)
    ui:addToGroup(dlabel,boxPop)
    ui:addToGroup(dctrl,boxPop)

    label=ui:addLabel("弹性re",1100,310)
    local relabel=ui:addLabel(tostring(1),1200,310)
    local f=function(this)
        relabel.txt=this.value
        interface.selectObj.fixture:setRestitution(this.value)
    end
    local rectrl=ui:addSlider(1,0,1,1100,340,150,20,f)
    ui:addToGroup(label,boxPop)
    ui:addToGroup(relabel,boxPop)
    ui:addToGroup(rectrl,boxPop)

    label=ui:addLabel("摩擦f",1100,380)
    local flabel=ui:addLabel(tostring(0),1200,380)
    local f=function(this) 
        flabel.txt=this.value
        interface.selectObj.fixture:setFriction(this.value) 
    end
    local fctrl=ui:addSlider(0,0,10,1100,410,150,20,f)
    ui:addToGroup(label,boxPop)
    ui:addToGroup(flabel,boxPop)
    ui:addToGroup(fctrl,boxPop)

    label=ui:addLabel("删除物体",1100,450)
    f=function(this) 
      interface.selectObj:delete()
    end
    local delbutton=ui:addButton("删除",1200,450,60,20,f)
    ui:addToGroup(label,boxPop)
    ui:addToGroup(delbutton,boxPop)

    label=ui:addLabel("固定/释放",1100,490)
    f=function(this) 
        if interface.selectObj.body:getType()=="static" then
            interface.selectObj.body:setType("dynamic")
        else 
            interface.selectObj.body:setType("static")
        end
    end
    local delbutton=ui:addButton("执行",1200,490,60,20,f)
    ui:addToGroup(label,boxPop)
    ui:addToGroup(delbutton,boxPop)
    ui:groupHide(boxPop)
    interface.uiGroup.boxPop=boxPop
    interface.uiGroup.boxPop_init=function()
        xctrl.value=interface.selectObj.body:getX()
        xctrl.callback(xctrl)
        yctrl.value=interface.selectObj.body:getY()
        yctrl.callback(yctrl)
        dctrl.value=interface.selectObj.fixture:getDensity()
        dctrl.callback(dctrl)
        rectrl.value=interface.selectObj.fixture:getRestitution()
        rectrl.callback(rectrl)
        fctrl.value=interface.selectObj.fixture:getFriction()
        fctrl.callback(fctrl)
    end
    interface.uiGroup.boxPop_update=function()
        xlabel.txt=xctrl.value
        ylabel.txt=yctrl.value
        dlabel.txt=dctrl.value
        relabel.txt=rectrl.value
        flabel.txt=fctrl.value
    end
    --------------确定及取消-----------
    local confirmPop=ui:creatGroup()
    label=ui:addLabel("是否建立连接？",1100,570)
    local f=function(this) 
        ui:groupHide(interface.uiGroup.confirmPop)
        interface.createTag="done"
    end
    local confirmButton=ui:addButton("确定",1100,600,60,20,f)
    local f=function(this) 
        ui:groupHide(interface.uiGroup.confirmPop)
        interface.createTag=nil
        interface.createJoint=nil
        ui:groupReset(interface.uiGroup.leftZone)
    end
    local cancelButton=ui:addButton("取消",1200,600,60,20,f)
    ui:addToGroup(label,confirmPop)
    ui:addToGroup(confirmButton,confirmPop)
    ui:addToGroup(cancelButton,confirmPop)
    ui:groupHide(confirmPop)
    interface.uiGroup.confirmPop=confirmPop
end

local function loadJointPop(interface)
    local distancePop=ui:creatGroup()
    label=ui:addLabel("物体A",1100,30)
    local alabel=ui:addLabel("",1200,30)
    ui:addToGroup(label,distancePop)
    ui:addToGroup(alabel,distancePop)

    label=ui:addLabel("锚点A",1100,60)
    local aPointLabel=ui:addLabel("",1200,60)
    ui:addToGroup(label,distancePop)
    ui:addToGroup(aPointLabel,distancePop)   


    label=ui:addLabel("物体B",1100,100)
    local blabel=ui:addLabel("",1200,100)
    ui:addToGroup(label,distancePop)
    ui:addToGroup(blabel,distancePop)

    label=ui:addLabel("锚点B",1100,130)
    local bPointLabel=ui:addLabel("",1200,130)
    ui:addToGroup(label,distancePop)
    ui:addToGroup(bPointLabel,distancePop) 

    label=ui:addLabel("内部碰撞",1100,170)
    f=function(this) 
        if interface.selectJoint.joint:getCollideConnected( )==true then
            interface.selectJoint.joint:setCollideConnected(false)
            interface.selectJoint.property.inter=false
        else 
            print(interface.selectJoint.joint:getCollideConnected( ))
            interface.selectJoint.joint:setCollideConnected(true)
            interface.selectJoint.property.inter=true
        end
    end
    local swbutton=ui:addButton("切换",1200,170,60,20,f)
    ui:addToGroup(label,distancePop)
    ui:addToGroup(swbutton,distancePop) 

    label=ui:addLabel("响应频率",1100,210)
    local frlabel=ui:addLabel(tostring(1),1200,210   )
    local f=function(this) 
        frlabel.txt=this.value 
        interface.selectJoint.joint:setFrequency(this.value)
    end
    local frctrl=ui:addSlider(1,1,1000,1100,240,150,20,f)
    ui:addToGroup(label,distancePop)
    ui:addToGroup(frlabel,distancePop)
    ui:addToGroup(frctrl,distancePop)

    label=ui:addLabel("阻尼率",1100,280)
    local dplabel=ui:addLabel(tostring(1),1200,280 )
    local f=function(this) 
        dplabel.txt=this.value 
        interface.selectJoint.joint:setDampingRatio(this.value)
    end
    local dpctrl=ui:addSlider(1,0,100,1100,310,150,20,f)
    ui:addToGroup(label,distancePop)
    ui:addToGroup(dplabel,distancePop)
    ui:addToGroup(dpctrl,distancePop)


    ui:groupHide(distancePop)
    interface.uiGroup.distancePop=distancePop
    interface.uiGroup.distancePop_init=function()
        alabel.txt=interface.selectJoint.targetA.obj_type
        blabel.txt=interface.selectJoint.targetB.obj_type
        aPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x1))..","..tostring(math.floor(interface.selectJoint.property.y1))
        bPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x2))..","..tostring(math.floor(interface.selectJoint.property.y2))   
        local mousex,mousey = love.mouse.getPosition()
        if interface.dragJoint==1 then
             aPointLabel.txt = tostring(math.floor(love.mouse.getX()))..","..tostring(math.floor(love.mouse.getY()))
        elseif  interface.dragJoint==2 then
             bPointLabel.txt = tostring(math.floor(love.mouse.getX()))..","..tostring(math.floor(love.mouse.getY()))
        end 
    end
    interface.uiGroup.distancePop_update=function()
        aPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x1))..","..tostring(math.floor(interface.selectJoint.property.y1))
        bPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x2))..","..tostring(math.floor(interface.selectJoint.property.y2))     
    end

    -----------------------绳索连接----------------------
    local ropePop=ui:creatGroup()
    local pop=ropePop
    label=ui:addLabel("物体A",1100,30)
    local alabel=ui:addLabel("",1200,30)
    ui:addToGroup(label,pop)
    ui:addToGroup(alabel,pop)

    label=ui:addLabel("锚点A",1100,60)
    local aPointLabel=ui:addLabel("",1200,60)
    ui:addToGroup(label,pop)
    ui:addToGroup(aPointLabel,pop)   


    label=ui:addLabel("物体B",1100,100)
    local blabel=ui:addLabel("",1200,100)
    ui:addToGroup(label,pop)
    ui:addToGroup(blabel,pop)

    label=ui:addLabel("锚点B",1100,130)
    local bPointLabel=ui:addLabel("",1200,130)
    ui:addToGroup(label,pop)
    ui:addToGroup(bPointLabel,pop) 

    label=ui:addLabel("内部碰撞",1100,170)
    f=function(this) 
        if interface.selectJoint.joint:getCollideConnected( )==true then
            interface.selectJoint.joint:setCollideConnected(false)
            interface.selectJoint.property.inter=false
        else 
            print(interface.selectJoint.joint:getCollideConnected( ))
            interface.selectJoint.joint:setCollideConnected(true)
            interface.selectJoint.property.inter=true
        end
    end
    local swbutton=ui:addButton("切换",1200,170,60,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(swbutton,pop) 

    label=ui:addLabel("响应频率",1100,210)
    local frlabel=ui:addLabel(tostring(1),1200,210   )
    local f=function(this) 
        frlabel.txt=this.value 
        interface.selectJoint.joint:setFrequency(this.value)
    end
    local frctrl=ui:addSlider(1,1,1000,1100,240,150,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(frlabel,pop)
    ui:addToGroup(frctrl,pop)

    label=ui:addLabel("阻尼率",1100,280)
    local dplabel=ui:addLabel(tostring(1),1200,280 )
    local f=function(this) 
        dplabel.txt=this.value 
        interface.selectJoint.joint:setDampingRatio(this.value)
    end
    local dpctrl=ui:addSlider(1,0,100,1100,310,150,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(dplabel,pop)
    ui:addToGroup(dpctrl,pop)


    ui:groupHide(pop)
    interface.uiGroup.ropePop=pop
    interface.uiGroup.ropePop_init=function()
        aPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x1))..","..tostring(math.floor(interface.selectJoint.property.y1))
        bPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x2))..","..tostring(math.floor(interface.selectJoint.property.y2))   
        local mousex,mousey = love.mouse.getPosition()
        if interface.dragJoint==1 then
             aPointLabel.txt = tostring(math.floor(love.mouse.getX()))..","..tostring(math.floor(love.mouse.getY()))
        elseif  interface.dragJoint==2 then
             bPointLabel.txt = tostring(math.floor(love.mouse.getX()))..","..tostring(math.floor(love.mouse.getY()))
        end 
    end
    interface.uiGroup.ropePop_update=function()
        aPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x1))..","..tostring(math.floor(interface.selectJoint.property.y1))
        bPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x2))..","..tostring(math.floor(interface.selectJoint.property.y2))     
    end

 -------------------焊接连接-----------------
    local weldPop=ui:creatGroup()
    local pop=weldPop
    label=ui:addLabel("物体A",1100,30)
    local alabel=ui:addLabel("",1200,30)
    ui:addToGroup(label,pop)
    ui:addToGroup(alabel,pop)

    label=ui:addLabel("锚点A",1100,60)
    local aPointLabel=ui:addLabel("",1200,60)
    ui:addToGroup(label,pop)
    ui:addToGroup(aPointLabel,pop)   


    label=ui:addLabel("物体B",1100,100)
    local blabel=ui:addLabel("",1200,100)
    ui:addToGroup(label,pop)
    ui:addToGroup(blabel,pop)

    label=ui:addLabel("锚点B",1100,130)
    local bPointLabel=ui:addLabel("",1200,130)
    ui:addToGroup(label,pop)
    ui:addToGroup(bPointLabel,pop) 

    label=ui:addLabel("内部碰撞",1100,170)
    f=function(this) 
        if interface.selectJoint.joint:getCollideConnected( )==true then
            interface.selectJoint.joint:setCollideConnected(false)
            interface.selectJoint.property.inter=false
        else 
            print(interface.selectJoint.joint:getCollideConnected( ))
            interface.selectJoint.joint:setCollideConnected(true)
            interface.selectJoint.property.inter=true
        end
    end
    local swbutton=ui:addButton("切换",1200,170,60,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(swbutton,pop) 

    label=ui:addLabel("响应频率",1100,210)
    local frlabel=ui:addLabel(tostring(1),1200,210   )
    local f=function(this) 
        frlabel.txt=this.value 
        interface.selectJoint.joint:setFrequency(this.value)
    end
    local frctrl=ui:addSlider(1,1,1000,1100,240,150,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(frlabel,pop)
    ui:addToGroup(frctrl,pop)

    label=ui:addLabel("阻尼率",1100,280)
    local dplabel=ui:addLabel(tostring(1),1200,280 )
    local f=function(this) 
        dplabel.txt=this.value 
        interface.selectJoint.joint:setDampingRatio(this.value)
    end
    local dpctrl=ui:addSlider(1,0,100,1100,310,150,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(dplabel,pop)
    ui:addToGroup(dpctrl,pop)


    ui:groupHide(pop)
    interface.uiGroup.weldPop=pop
    interface.uiGroup.weldPop_init=function()
        aPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x1))..","..tostring(math.floor(interface.selectJoint.property.y1))
        bPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x2))..","..tostring(math.floor(interface.selectJoint.property.y2))   
        local mousex,mousey = love.mouse.getPosition()
        if interface.dragJoint==1 then
             aPointLabel.txt = tostring(math.floor(love.mouse.getX()))..","..tostring(math.floor(love.mouse.getY()))
        elseif  interface.dragJoint==2 then
             bPointLabel.txt = tostring(math.floor(love.mouse.getX()))..","..tostring(math.floor(love.mouse.getY()))
        end 
    end
    interface.uiGroup.weldPop_update=function()
        aPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x1))..","..tostring(math.floor(interface.selectJoint.property.y1))
        bPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x2))..","..tostring(math.floor(interface.selectJoint.property.y2))     
    end
    -------------------------转轴连接-------------------------------
    local weldPop=ui:creatGroup()
    local pop=weldPop
    label=ui:addLabel("物体A",1100,30)
    local alabel=ui:addLabel("",1200,30)
    ui:addToGroup(label,pop)
    ui:addToGroup(alabel,pop)

    label=ui:addLabel("锚点A",1100,60)
    local aPointLabel=ui:addLabel("",1200,60)
    ui:addToGroup(label,pop)
    ui:addToGroup(aPointLabel,pop)   


    label=ui:addLabel("物体B",1100,100)
    local blabel=ui:addLabel("",1200,100)
    ui:addToGroup(label,pop)
    ui:addToGroup(blabel,pop)

    label=ui:addLabel("锚点B",1100,130)
    local bPointLabel=ui:addLabel("",1200,130)
    ui:addToGroup(label,pop)
    ui:addToGroup(bPointLabel,pop) 

    label=ui:addLabel("内部碰撞",1100,170)
    f=function(this) 
        if interface.selectJoint.joint:getCollideConnected( )==true then
            interface.selectJoint.joint:setCollideConnected(false)
            interface.selectJoint.property.inter=false
        else 
            print(interface.selectJoint.joint:getCollideConnected( ))
            interface.selectJoint.joint:setCollideConnected(true)
            interface.selectJoint.property.inter=true
        end
    end
    local swbutton=ui:addButton("切换",1200,170,60,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(swbutton,pop) 

    label=ui:addLabel("响应频率",1100,210)
    local frlabel=ui:addLabel(tostring(1),1200,210   )
    local f=function(this) 
        frlabel.txt=this.value 
        interface.selectJoint.joint:setFrequency(this.value)
    end
    local frctrl=ui:addSlider(1,1,1000,1100,240,150,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(frlabel,pop)
    ui:addToGroup(frctrl,pop)

    label=ui:addLabel("阻尼率",1100,280)
    local dplabel=ui:addLabel(tostring(1),1200,280 )
    local f=function(this) 
        dplabel.txt=this.value 
        interface.selectJoint.joint:setDampingRatio(this.value)
    end
    local dpctrl=ui:addSlider(1,0,100,1100,310,150,20,f)
    ui:addToGroup(label,pop)
    ui:addToGroup(dplabel,pop)
    ui:addToGroup(dpctrl,pop)


    ui:groupHide(pop)
    interface.uiGroup.weldPop=pop
    interface.uiGroup.weldPop_init=function()
        aPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x1))..","..tostring(math.floor(interface.selectJoint.property.y1))
        bPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x2))..","..tostring(math.floor(interface.selectJoint.property.y2))   
        local mousex,mousey = love.mouse.getPosition()
        if interface.dragJoint==1 then
             aPointLabel.txt = tostring(math.floor(love.mouse.getX()))..","..tostring(math.floor(love.mouse.getY()))
        elseif  interface.dragJoint==2 then
             bPointLabel.txt = tostring(math.floor(love.mouse.getX()))..","..tostring(math.floor(love.mouse.getY()))
        end 
    end
    interface.uiGroup.weldPop_update=function()
        aPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x1))..","..tostring(math.floor(interface.selectJoint.property.y1))
        bPointLabel.txt=tostring(math.floor(interface.selectJoint.property.x2))..","..tostring(math.floor(interface.selectJoint.property.y2))     
    end
end














return function(interface)
    loadUi(interface)
    loadObjPop(interface)
    loadJointPop(interface)
end