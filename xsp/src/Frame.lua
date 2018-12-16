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


--没用2.0 用的旧得api
HUD={
}
function HUD:new(Baseinfo)	--Baseinfo={point=multipoint:getXY(),color,text,bg,size}
	local o={
		origin=Baseinfo.point[1],
		size=Size(Baseinfo.point[2]-Baseinfo.point[1]),
		color=Baseinfo.color or "0xffffffff",
		bg=Baseinfo.bg or "0xffffffff",
		textsize=Baseinfo.textsize*_const.Arry.AppurtenantScaleMode or 20,
		id=createHUD(),
		pos=Baseinfo.pos or 0,
		text=Baseinfo.text or "",
	}
	setmetatable(o,{__index = self} )	
	return o
end
function HUD:show(text)
local o=self:getdata(text)
	showHUD(self.id,o.text,o.size,o.color,o.bg,o.pos,o.x,o.y,o.width,o.height)
end
function HUD:hide()
local o=self:getdata()
	showHUD(self.id,"",o.size,"0x00000000","0x00000000",o.pos,o.x,o.y,o.width,o.height)
end
function HUD:getdata(text)
	local o={
			text=text or self.text,
			size=self.textsize,
			color=self.color,
			bg=self.bg,
			pos=self.pos,
			x=self.origin.x,
			y=self.origin.y,
			width=self.size.width,
			height=self.size.height,
	}		
	return o
end


runTime={--计时器
}
function runTime:new()
	local o={
		startTime=os.milliTime()
	}
	
	setmetatable(o,{__index=self} )
	return o
end
function runTime:resetTime(T)--重设计时器时间起点
	self.startTime=T or os.milliTime()
end
function runTime:setcheckTime(T)--设置检查点T为间隔时间/秒 必填
	self.Time=T*1000
end
function runTime:checkTime()--检查时间
	if self.startTime+self.Time<os.milliTime() then
		self:resetTime()	--重设起点时间
		return true
	end
	return false
end
function runTime:cmpTime()--与计时器时间起点比较时间差
	local diff=(os.milliTime()-self.startTime)
	printf("间隔:%s 秒",diff/1000)
	return diff	--返回毫秒
end


--文件对象
File={
}
function File:new(filename,Path)--File:new("userconfig","自定义路径")
	local o={
		PublicPath=xmod.getPublicPath(),	--引擎公共文件夹目录路径
		PrivatePath=xmod.getPrivatePath,	--脚本私有文件夹目录路径
		Filename=filename,					--文件名
		FilePath="",
	}
	if Path=="public" then 
		o.FilePath=xmod.resolvePath('[public]'..filename)
	elseif Path=="private" then
		o.FilePath=xmod.resolvePath('[private]'..filename)
	elseif Path=="Path" then
		o.FilePath=Filename	--选择Path需要自己补全路径
	else
		print("请选择public或private")
		xmod.exit()
	end
	setmetatable(o,{ __index = self})
	return o
end
function File:WriteNewByJson(tbl)--以Json格式写入文件tbl={["xxxxx"]="123",["aaaaaa"]=true}
	local json=require("cjson")
	local file=io.open(self.FilePath,"r+")
	assert(file,"path of the file don't exist or can't open")
	local str=json.encode(tbl)	--table转为json格式
	file:write(str)
	file:flush()
	file:close()
end
function File:ReadByJson()--读取Json格式的文件
	local json=require("cjson")
	local file=io.open(self.FilePath,"r")
	assert(file,"path of the file don't exist or can't open")
	local tbl=json.decode(file:read("*a"))
	file:close()
	return tbl
end
function File:ReadByJsontoStr()--读取Json格式的文件
	local json=require("cjson")
	local file=io.open(self.FilePath,"r")
	assert(file,"path of the file don't exist or can't open")
	local tbl=json.decode(file:read("*a"))
	local str=table.concat(tbl,",")
	file:close()
	return str
end
function File:ClearFile()--清除当前文件内容
	local file=io.open(self.FilePath,"w")
	file:flush()
	file:close()
end
function File:check(data)--检查是否有文件没有则会创建,并且写入data里的内容
	if io.open(self.FilePath,"r")==nil then
		print("没有"..self.Filename.."这个文件")
		io.open(self.FilePath,"w"):close()
		self:WriteNewByJson(data)
	else
		local file=io.open(self.FilePath,"r") 
		if file:seek("end")==0 then
			self:WriteNewByJson(data)
		end
	end
end
function File:printPath()--打印当前文件路径
	printf("路径为 : %s",self.FilePath)
end


--OCR对象
OCR={
}
function OCR:new(data)--{Edition="tessocr_3.02.02",path="res/",lang="chi_sim"}
	local o={
		Edition=data.Edition or "tessocr_3.05.02",
		path=data.path or "[external]",
		lang=data.lang or "eng",
		PSM=6,
		White="",
		Black="",
		reset=false,
	}
	local tessocr=require(o.Edition)	
	local ocr,msg=tessocr.create({
		path=o.path,
		lang=o.lang,
	})
	if ocr==nil then
		print("ocr创建失败:"..msg)
		xmod.exit()
	end	
	setmetatable(o,{__index = self} )
	o.ocr=ocr
	return o
end
function OCR:getText(data)--{rect={},diff={},PSM=6,white="123456789"}
	string.trim = function(s)
			return s:match'^%s*(.*%S)'  or ''
	end
	if data.binarize then Data=data.binarize else --二值化图片
		local img=Image.fromScreen(Rect(data.Rect))
		local Data=img:binarize(data.diff)	
	end
	local PSM=data.PSM or self.PSM
	local White=data.white or self.White
	local Black=data.Black or self.Black
	self.ocr:setPSM(PSM)--设置PSM
	self.ocr:setWhitelist(White)--设置白名单	
	self.ocr:setBlacklist(Black)
	local code,result,detail=self.ocr:getText(Data)
		if code == 0 then
			local text=result:trim()
			 printf('text = %s', text)
			 return text
		else
			print('ocr:getText failed!')
		end
end
function OCR:release()--释放字库(释放后再次使用需要重新启动)
	self.reset=true
	self.ocr:release()
end
function OCR:restart()--释放后重新启动
local ocr,msg=tessocr.create({
		path=self.path,
		lang=self.lang,
	})
	if ocr==nil then
		print("ocr创建失败:"..msg)
		xmod.exit()
	end	
	self.ocr=ocr
end


--滑动对象
Slide={
}
function Slide:new(Base)
local o={
	MoveStart=Base.point[1],			--起始点
	MoveEnd=Base.point[2],				--结束点
	holdtime=Base.holdtime or 0,	--滑动结束后touchup前的延迟,可以防止滑动的惯性效果
	steplen=Base.steplen or 10,		--步长
	steptime=Base.steptime or 10,	--每次滑动后的延迟
	index=Base.index or 1,
}
	setmetatable(o,{__index = self})
	return o
end
function Slide:move()--双指移动
local x,y
local x1,y1=self.MoveStart.x,self.MoveStart.y
local x2,y2=self.MoveEnd.x,self.MoveEnd.y
local t=self.steplen/100
	touch.down(self.index,x1,y1)
	for i=0,1,t do
		x=(1-i)*x1+i*x2
		y=(1-i)*y1+i*y2
		touch.move(self.index,x,y)
		sleep(steptime)
	end
	if x<x2 or y<y2 then
		x=x+(x2-x)
		y=y+(y2-y)
		touch.move(self.index,x,y)
	end
	slp(self.holdtime)
	touch.up(self.index,x,y)
end
function Slide:Close()--双指缩小
local x1,y1,x2,y2
local Move={
	{x=self.MoveStart.x,y=self.MoveStart.y},
	{x=self.MoveEnd.x,y=self.MoveEnd.y},
}
local middle={
	x=math.abs(self.MoveStart.x-self.MoveEnd.y),
	y=math.abs(self.MoveStart.y-self.MoveEnd.y),
}
local t=self.steplen/100
	touch.down(self.index,Move[1].x,Move[1].y)
	touch.down(self.index+1,Move[2].x,Move[2].y)
	for i=0,1,t do
		x1=(1-i)*Move[1].x+i*middle.x
		x2=(1-i)*Move[2].x+i*middle.x
		y1=(1-i)*Move[1].y+i*middle.y
		y2=(1-i)*Move[2].y+i*middle.y
		touch.move(self.index,x1,y1)
		touch.move(self.index+1,x2,y2)
		sleep(steptime)
	end
	slp(self.holdtime)
	touch.up(self.index,x1,y1)
	touch.up(self.index+1,x2,y2)
end
function Slide:Enlarge()--双指扩大
local x1,y1,x2,y2
local Move={
	{x=self.MoveStart.x,y=self.MoveStart.y},
	{x=self.MoveEnd.x,y=self.MoveEnd.y},
}
local middle={
	x=math.abs(self.MoveStart.x-self.MoveEnd.y),
	y=math.abs(self.MoveStart.y-self.MoveEnd.y),
}
local t=self.steplen/100
	touch.down(self.index,middle.x,middle.y)
	touch.down(self.index+1,middle.x,middle.y)
	for i=0,1,t do
		x1=(1-i)*middle.x+i*Move[1].x
		x2=(1-i)*middle.x+i*Move[2].x
		y1=(1-i)*middle.y+i*Move[1].y
		y2=(1-i)*middle.y+i*Move[2].y
		touch.move(self.index,x1,y1)
		touch.move(self.index+1,x2,y2)
		sleep(steptime)
	end
	slp(self.holdtime)
	touch.up(self.index,x1,y1)
	touch.up(self.index+1,x2,y2)

end


--system对象
System={ --
}
function System:new(DevScreen,CurScreen,initfor,MainPointsScaleMode,AppurtenantScaleMode,GameAspect)
--Dev(开发机布局),Cur(客户机布局) width>height
--MainPointsScaleMode为对象中锚点的缩放方式,AppurtenantScaleMode为多点对象中从属点的缩放方式
--GameAspect为游戏的比例
	local o={
		Dev=DevScreen,
		Cur=CurScreen,
		keepTime=0,
		Arry={
			Cur=TableCopy(CurScreen),
			Dev=TableCopy(DevScreen),
			MainPointsScaleMode=MainPointsScaleMode or false,
			AppurtenantScaleMode=AppurtenantScaleMode or false,
		},
	}
	-----------------------------------------------------------------
	local DevX,DevY,CurX,CurY
	if initfor==1 or initfor==2 then 
		DevX=o.Dev.Width-o.Dev.Left-o.Dev.Right		--开发机X减去黑边
		DevY=o.Dev.Height-o.Dev.Top-o.Dev.Bottom		--开发机Y减去黑边
		CurX=o.Cur.Width-o.Cur.Left-o.Cur.Right		--当前机器X减去黑边
		CurY=o.Cur.Height-o.Cur.Top-o.Cur.Bottom		--当前机器Y减去黑边
	elseif initfor==3 then
		DevX=o.Dev.Height-o.Dev.Top-o.Dev.Bottom
		DevY=o.Dev.Width-o.Dev.Left-o.Dev.Right
		CurX=o.Cur.Height-o.Cur.Top-o.Cur.Bottom
		CurY=o.Cur.Width-o.Cur.Left-o.Cur.Right
	end
		o.Arry.Dev.x,o.Arry.Dev.y,o.Arry.Cur.x,o.Arry.Cur.y=DevX,DevY,CurX,CurY
		o.Arry.x=CurX/DevX
		o.Arry.y=CurY/DevY
		o.Arry.Dev.scale,o.Arry.Cur.scale=DevX/DevY,CurX/CurY--宽高比
	--------------------------------------------------------------------------
	if MainPointsScaleMode=="Height" then		--锚点的相对坐标缩放
		o.Arry.MainPointsScaleMode=o.Arry.Cur.y/o.Arry.Dev.y
	elseif MainPointsScaleMode=="Width" then	
		o.Arry.MainPointsScaleMode=o.Arry.Cur.x/o.Arry.Dev.x
	elseif MainPointsScaleMode=="unequal" then ---全屏游戏用
		if o.Arry.Cur.scale>GameAspect then
			o.Arry.MainPointsScaleMode=o.Arry.Cur.y/o.Arry.Dev.y
		else
			o.Arry.MainPointsScaleMode=(o.Arry.Cur.y/o.Arry.Dev.y)*(1/GameAspect)
		end
	else
		print("没有设置锚点缩放模式")
		xmod.exit()
	end	

	if AppurtenantScaleMode=="Height" then		--多点从属点的相对坐标缩放
		o.Arry.AppurtenantScaleMode=o.Arry.Cur.y/o.Arry.Dev.y
	elseif AppurtenantScaleMode=="Width" then
		o.Arry.AppurtenantScaleMode=o.Arry.Cur.x/o.Arry.Dev.x
	elseif AppurtenantScaleMode=="unequal" then	--全屏游戏用
		if o.Arry.Cur.scale>GameAspect then
			o.Arry.AppurtenantScaleMode=o.Arry.Cur.y/o.Arry.Dev.y
		else
			o.Arry.AppurtenantScaleMode=(o.Arry.Cur.y/o.Arry.Dev.y)*(1/GameAspect)
		end
	else
		print("没有设置多点从属点")
		xmod.exit()
	end
	
	setmetatable(o,{__index=self} )
	_const.Arry=o.Arry
	return o
end
function System:keep(boole,T)--和scren.keep()一样
	if boole then if self.KeepScreen then return end end
	slp(T or self.keepTime)	
	screen.keep(boole)
	self.KeepScreen=boole
end
function System:Switchkeep()--一次false,一次true保证是截到最新的页面
	self:keep(false)
	self:keep(true)
end
function System:setKeepTime(T)--设置截图前的延迟
	self.KeepTime=T
end
function System:getSystemData()--一些系统的属性,按照需求自己添加
local UserInfo,code = script.getUserInfo()
local ScriptInfo, code = script.getScriptInfo()
	local data={
		ver=xmod.PLATFORM,
		dpi=screen.getDPI(),
		screen=screen.getSize(),
		uid=UserInfo.id,
		scriptid=ScriptInfo.id,
		val=runtime.android.getSystemProperty('ro.build.product'),
		code=xmod.PRODUCT_NAME,
	}
	self.SystemData=data
	return data
end
function System:printSelf()--打印自身
	Print(self)
end
function System:getArry()--获取Arry缩放参数
	return self.Arry
end
