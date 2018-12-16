
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

