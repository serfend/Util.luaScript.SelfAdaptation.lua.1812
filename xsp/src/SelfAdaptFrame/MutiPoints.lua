
multiPoint={--多点对象
}
function multiPoint:new(Base)
	local o={
		_type="multiPoint",
		_tag=Base._tag,
		fuzz=Base.fuzz or 95,--模糊值(选填)
		index=Base.index,--点击范围(选填)
		Area=Base.Area,--范围坐标{x1,y1,x2,y2}(findcolor等需要范围坐标的必选)
		MainPoint=Base.MainPoint,--锚点{x,y}(选填)
		Anchor=Base.Anchor,--锚点(选填)
		DstMainPoint=Base.DstMainPoint,--按照此锚点为基准点进行换算(选填)
		offset=Base.offset,--偏色值(用于二值化 选填)
		limit=Base.limit,--(多点找色的返回值数量)
		priority=Base.priority or screen.PRIORITY_DEFAULT,--(找色扫描方向)
	}
	o.Arry=Base.Arry or _const.Arry;Arry=o.Arry
	------------------------------------------------------------------------------
	if o.DstMainPoint then	
		table.foreachi(Base,function(k,v) v.Cur={}
			v.Cur.x,v.Cur.y=getScaleXY(v,o.MainPoint,o.DstMainPoint,Arry)
			o[k]=point:new(v,true)	--缩放
		end)
	elseif not o.Anchor then 
		table.foreachi(Base,function(k,v) v.Cur={}
			v.Cur.x=(v.x-Arry.Dev.Left)*Arry.AppurtenantScaleMode+Arry.Cur.Left
			v.Cur.y=(v.y-Arry.Dev.Top)*Arry.AppurtenantScaleMode+Arry.Cur.Top
			v.MainPoint=o.MainPoint
			o[k]=point:new(v,true)
		end)
	else	
		o.DstMainPoint=getScaleMainPoint(o.MainPoint,o.Anchor,Arry)	--计算锚点
		table.foreachi(Base,function(k,v) v.Cur={}
			v.Cur.x,v.Cur.y=getScaleXY(v,o.MainPoint,o.DstMainPoint,Arry)
			o[k]=point:new(v,true)--缩放
		end)
	end
	if o.index then o.index=getScaleArea(o.index,o.DstMainPoint,o.MainPoint,Arry) end--如果有设置点击点
	if o.Area then o.Area=getScaleArea(o.Area,o.DstMainPoint,o.MainPoint,Arry) end	--缩放范围
	
	setmetatable(o,{__index = self})
	
	return o
end
function multiPoint:newBypoint(Base)
	local o={
		_type="multiPoint",
		_tag=Base._tag,
		fuzz=Base.fuzz or 95,--模糊值(选填)
		index=Base.index,--点击范围(选填)
		Area=Base.Area,--范围坐标{x1,y1,x2,y2}(findcolor等需要范围坐标的必选)
		MainPoint=Base.MainPoint,--锚点{x,y}(选填)
		Anchor=Base.Anchor,--锚点(选填)
		DstMainPoint=Base.DstMainPoint,--按照此锚点为基准点进行换算(选填)
		offset=Base.offset,--偏色值(用于二值化 选填)
		priority=Base.priority or screen.PRIORITY_DEFAULT,
	}
	o.Arry=Base.Arry or _const.Arry;Arry=o.Arry
	------------------------------------------------------------------------------
	table.foreachi(Base,function(k,v) o[k]=v end)
	setmetatable(o,{__index=self})
	return o
end
function multiPoint:Click(T)
math.randomseed(tonumber(string.reverse(tostring(os.milliTime())):sub(1,6)))
local p=self.index
local point1,point2=p:tl(),p:br()
local point={math.random(point1.x,point2.x),math.random(point1.y,point2.y)}
	touch.down(1,point[1],point[2])
	slp()
	touch.up(1,point[1],point[2])
	slp(T)
end
function multiPoint:AllClick(T)
	for k,v in ipairs(self) do
		self[k]:Click(T)
	end
end
function multiPoint:getColor()
_K:keep(true)
	for k,v in ipairs(self) do
		self[k]:getColor()
	end
end
function multiPoint:getBilinear()
_K:keep(true)
	for k,v in ipairs(self) do
		self[k]:getBilinear()
	end
end
function multiPoint:cmpColor()--比色
local floor=math.floor
local abs=math.abs
  for k,v in ipairs(self) do
	local fuzz = floor(0xff * (100 - v.fuzz) * 0.01)
	local lr,lg,lb=v.Cur.color.r,v.Cur.color.g,v.Cur.color.b
	local r,g,b=v.Dev.color.r,v.Dev.color.g,v.Dev.color.b
	local r3,g3,b3=abs(lr-r),abs(lg-g),abs(lb-b)
	local diff=math.sqrt(r3*r3+g3*g3+b3*b3)
		if diff>fuzz then
			--printf(">>>>>>>>>>>>>>>>>>>>>>>错误位置:%s",(self._tag or ""))
			--printf("错误点[%s]:x=%s,y=%s",k,v.Cur.x,v.Cur.y)
			--printf("缩放后:r=%.0f,g=%.0f,b=%.0f",lr,lg,lb)
			--printf("缩放前:r=%s,g=%s,b=%s",r,g,b)
			--printf("Diff=%s,Degree=%s",diff,v.Degree)
			--print(">>>>>>>>>>>>>>>>找色结果:fasle")
			return false
		end
  end
	--printf(">>>>>>>>>>>>>>>>%s:true",(self._tag or ""))
  return true
end
function multiPoint:getandCmpColor(touchmode,T)
	self[_const.GetColorMode](self)
	local bool=self:cmpColor()
	if touchmode==true then
		if bool then self:Click(T) end
	elseif touchmode==false then
		if not bool then self:Click(T) end
	end
	return bool
end
function multiPoint:findColor(returnType)--区域找色
assert(self.Area, "findColor没有传入Area")
local color={}
	table.foreachi(self,function (k,v) 
		color[k]={
			pos=self[k]:getXYtoPoint(),
			color=Color3B(v.Dev.color),
			fuzz=v.fuzz,
			offset=v.DiffColor or nil
			} 
	end)
	local pos=screen.findColor(self.Area,color,self.fuzz,self.priority)
		if pos ~= Point.INVALID then
			if returnType=="getXY" then
				return point:new({Cur={x=pos.x,y=pos.y}},true):getXY()
			else
				return point:new({Cur={x=pos.x,y=pos.y}},true)
			end
		end
	return false
end
function multiPoint:findColors(returnType)	--区域多点找色
assert(self.Area, "findColors没有传入Area")
local color,postbl={},{}
	table.foreachi(self,function (k,v) 
		color[k]={
			pos=self[k]:getXYtoPoint(),
			color=Color3B(v.Dev.color),
			fuzz=v.fuzz,
			offset=v.DiffColor or nil
			} 
	end)
	local result=screen.findColors(self.Area,color,self.fuzz,self.priority,(self.limit or 200))
		if #result > 0 then
			if returnType=="getXY" then
				for i,pos in pairs(result) do
					postbl[i]=point:new({Cur={x=pos.x,y=pos.y}},true):getXY()
				end
			else
				for i,pos in pairs(result) do
					postbl[i]=point:new({Cur={x=pos.x,y=pos.y}},true)
				end
			end
			return postbl
		end
	return false
end
function multiPoint:findColorEX(Ac)--瞎写的,用多点找色返回的点去取比色,Ac设置number,会调用new时的Ac个点给找色
assert(self.Area, "findColors没有传入Area")
Ac=Ac or 2
local color,returnTbl={},{}
	for i=1,Ac do v=self[i]
		color[i]={
			pos=self[i]:getXYtoPoint(),
			color=Color3B(v.Dev.color),
			fuzz=v.fuzz,
			offset=v.DiffColor or nil
		}
	end 
	local initpoint=screen.findColors(self.Area,color,self.fuzz,self.priority,999)
	Print(#initpoint)
		if #initpoint > 0 then
			local Allpoint=self:getAllpoint()
			for k,v in ipairs(initpoint) do
				local Dst={x=initpoint[k].x,y=initpoint[k].y}
				table.foreachi(Allpoint,function(k,v) v.DstMainPoint=Dst v.fuzz=95 v:refresh() end)
				--table.foreachi(Allpoint,function(k,v) v:printXY() end)
				if multiPoint:newBypoint(Allpoint):getandCmpColor() then
					returnTbl[#returnTbl+1]=v
				end
			end
			return returnTbl
		end
end
function multiPoint:binarizeImage()--二值化图片
	local img = Image.fromScreen(self.Area)
	local data = img:binarize(self.offset)
	self.binarize=data
end
function multiPoint:getText(data)--识字
	if not self.binarize then self:binarizeImage() end
	local ocr=OCR:new({lang="eng"})
	data.binarize=self.binarize
	data.rect=self.Area
	return ocr:getText(data)
end
function multiPoint:getXY()
	local tbl={}
	table.foreachi(self,function (k,v) tbl[k]=v:getXY() end)
	return tbl
end
function multiPoint:getXYtoPoint()--获取参数点
	local tbl={}
	table.foreachi(self,function (k,v) tbl[k]=v:getXYtoPoint() end)
	return tbl
end
function multiPoint:getAllpoint()
	local tbl={}
	table.foreachi(self,function (k,v) tbl[k]=v end)
	return tbl	
end
function multiPoint:printbinarize()--打印二值化data
local data=self.binarize
	for _,v in pairs(data) do
		print(table.concat(v, ''))
	end
end
function multiPoint:printXY()--打印所有的点参数
print(string.format(">>>>>>>>>>>>>>>>%s",(self._tag or "")))
	table.foreachi(self, function(k,v) 
		self[k]:printXY()
	end)
print(">>>>>>>>>>>>>>>>")
end
function multiPoint:printSelf()
	Print(self)
end

