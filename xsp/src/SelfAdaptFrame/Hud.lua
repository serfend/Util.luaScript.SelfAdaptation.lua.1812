
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

