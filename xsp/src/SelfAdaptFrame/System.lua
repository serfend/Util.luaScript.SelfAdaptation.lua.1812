
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
