point={--单点对象
}
function point:new(Base,tag)--Base={x=100,y=100,color=0xFFFFFF,fuzz=95}
	local o={
		_type="point",
		offset=Base.offset,	--偏色(选填)
		fuzz=Base.fuzz or 95,--模糊度(选填)
		index=Base.index or 1,--点击的index(选填)
		Anchor=Base.Anchor,--锚点(选填)
		MainPoint=Base.MainPoint,--锚点坐标(选填)
		DstMainPoint=Base.DstMainPoint,--按照此锚点为基准点进行换算(选填)
		Dev={
			x=Base.x,	--x(必填)
			y=Base.y,	--y(必填)
			--color=Color3B(Base.color),--颜色值(选填)
		},
		Cur={
--			x=
--			y=
		},
	}
	o.Arry=Base.Arry or _const.Arry;Arry=o.Arry
	if Base.color then
		o.Dev.color=Color3B(Base.color)
	end
	if tag then 
		o.Cur={x=Base.Cur.x,y=Base.Cur.y} 
		setmetatable(o,{__index = self} ) 
		return o 
	end
	---------------------------------------------------
	if o.DstMainPoint then
		o.Cur.x,o.Cur.y=getScaleXY(o.Dev,o.MainPoint,o.DstMainPoint,Arry)
	elseif not o.Anchor then
		o.Cur.x=(o.Dev.x-Arry.Dev.Left)*Arry.AppurtenantScaleMode+Arry.Cur.Left
		o.Cur.y=(o.Dev.y-Arry.Dev.Top)*Arry.AppurtenantScaleMode+Arry.Cur.Top
	else	
		o.DstMainPoint=getScaleMainPoint(o.MainPoint,o.Anchor,Arry)	--计算锚点
		o.Cur.x,o.Cur.y=getScaleXY(o.Dev,o.MainPoint,o.DstMainPoint,Arry)
	end

	setmetatable(o,{__index = self} )	
	return o
end
function point:touchHold(T)--按住屏幕,单位/秒
	touch.down(self.index,self.Cur.x,self.Cur.y)
	slp(T)
	touch.up(self.index,self.Cur.x,self.Cur.y)
	slp()
end
function point:Click(T)	--单点屏幕
	touch.down(self.index,self.Cur.x,self.Cur.y)
	slp()
	touch.up(self.index,self.Cur.x,self.Cur.y)
	slp(T)
end
function point:getColor()--获取点的颜色R,G,B
	local color=screen.getColor(self.Cur.x,self.Cur.y)
	self.Cur.color=color
end
function point:getBilinear()--二次插值取点 
_K:keep(true)
local point=self.Cur
	local ZoomX,ZoomY=math.floor(point.x),math.floor(point.y)	--缩放后的临近点
	local u,v=(point.x-ZoomX),(point.y-ZoomY)
		local r0,g0,b0=screen.getRGB(ZoomX,ZoomY)
		local r1,g1,b1=screen.getRGB(ZoomX+1,ZoomY)
		local r2,g2,b2=screen.getRGB(ZoomX,ZoomY+1)
		local r3,g3,b3=screen.getRGB(ZoomX+1,ZoomY+1)
		local	tmpColor0={
					r=(r0*(1-u)+r1*u),
					g=(g0*(1-u)+g1*u),
					b=(b0*(1-u)+b1*u),
				}
		local	tmpColor1={
					r=(r2*(1-u)+r3*u),
					g=(g2*(1-u)+g3*u),
					b=(b2*(1-u)+b3*u),
				}
		local	DstColor={
					r=tmpColor0.r*(1-v)+tmpColor1.r*v,
					g=tmpColor0.g*(1-v)+tmpColor1.g*v,
					b=tmpColor0.b*(1-v)+tmpColor1.b*v,
				}
		self.Cur.color=Color3B(DstColor.r,DstColor.g,DstColor.b)
end
function point:cmpColor()--比色
local floor=math.floor
local abs=math.abs
	local fuzz = floor(0xff * (100 - self.fuzz) * 0.01)
	local lr,lg,lb=self.Cur.color.r,self.Cur.color.g,self.Cur.color.b
	local r,g,b=self.Dev.color.r,self.Dev.color.g,self.Dev.color.b
	local r3,g3,b3=abs(lr-r),abs(lg-g),abs(lb-b)
	local diff=math.sqrt(r3*r3+g3*g3+b3*b3)
		if diff>fuzz then
			return false
		end
	return true
end
function point:getandCmpColor(touchmode,T)
	--self:getBilinear()
	self[_const.GetColorMode](self)
	local bool=self:cmpColor()
	if touchmode==true then
		if bool then self:Click(T) end
	elseif touchmode==false then
		if not bool then self:Click(T) end
	end
	return bool
end
function point:getDev()
	return self.Dev
end
function point:getXY()
	return self.Cur
end
function point:getXYtoPoint()
	return Point(self.Cur.x,self.Cur.y)
end
function point:ClearText()
	self:Click()
	runtime.inputText("CLEAR")
end
function point:inputText(Text)
	self:Click()
	runtime.inputText(Text)
end
function point:resetDev(x,y)--重设Dev坐标
	self.Dev.x=x
	self.Dev.y=y
end
function point:refresh(x,y)	--刷新
local o=self
local Arry=o.Arry
	if o.DstMainPoint then
		o.Cur.x,o.Cur.y=getScaleXY(o.Dev,o.MainPoint,o.DstMainPoint,Arry)
	elseif not o.Anchor then
		o.Cur.x=(o.Dev.x-Arry.Dev.Left)*Arry.AppurtenantScaleMode+Arry.Cur.Left
		o.Cur.y=(o.Dev.y-Arry.Dev.Top)*Arry.AppurtenantScaleMode+Arry.Cur.Top
	else	
		o.DstMainPoint=getScaleMainPoint(o.MainPoint,o.Anchor,Arry)	--计算锚点
		o.Cur.x,o.Cur.y=getScaleXY(o.Dev,o.MainPoint,o.DstMainPoint,Arry)
	end
end
function point:offsetXY(x,y,offsetMode)--偏移坐标
	if offsetMode=="withArry" then
		pointx=self.Cur.x-(x*self.Arry.AppurtenantScaleMode)
		pointy=self.Cur.y-(y*self.Arry.AppurtenantScaleMode)
	else
		pointx=self.Cur.x-x
		pointy=self.Cur.y-y		
	end
	self.Cur.x=pointx
	self.Cur.y=pointy
end
function point:printXY()--打印坐标
	print(string.format("{x=%.2f,y=%.2f}",self.Cur.x,self.Cur.y))
end
function point:printSelf()
	Print(self)
end

