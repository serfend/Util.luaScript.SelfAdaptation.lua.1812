local point=multiPoint:new({
	{x=200,y=0,color=0xdddddd},
	{x=550,y=60,color=0xd8d8d8},
})

local data={
	point=point:getXYtoPoint(),				--传入一个多点对象
	color="0xffffffff",							--字体颜色
	bg="0x80222a15",							--背景颜色
	textsize=40,								--字体大小
	--pos=,										--提示信息的原点位置
	--text=,									--默认显示的文字
}
hud=HUD:new(data)


hud:show("测试")--显示text传入字符串
slp(5)
hud:hide()--隐藏hud
slp(2)
hud:show("重新开启")
slp(3)