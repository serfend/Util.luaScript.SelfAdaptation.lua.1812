滑动=multiPoint:new({
	{x=100,y=200},
	{x=257,y=400}
})

Base={
	point=滑动:getXY(),	--通过多点对象获取最少两个坐标
	holdtime=0.5,		--滑动结束后touchup前的延迟,可以防止滑动的惯性效果
	steplen=10,			--步长
	steptime=10,		--每次滑动的延迟
}

--具体效果可以在安卓机打开开发者选项中的指针位置
test=Slide:new(Base)
test:move()
slp(2)
test:Close()
slp(2)
test:Enlarge()