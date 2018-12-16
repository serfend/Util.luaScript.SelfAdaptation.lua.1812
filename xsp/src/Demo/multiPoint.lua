--[[data={
	{x=100,y=200,color=0xffffff},
	{x=150,y=200,color=0xffffff},
	{x=100,y=250,color=0xffffff},
	fuzz=90,								--模糊值
	offset=0x010101,						--偏色
	index={},								--点击坐标{x1,y1,x2,y2}
	MainPoint={},							--锚点{x=x1,y=y1}
	Anchor=,								--锚点类型(具体见const)
	Area={},								--范围{x1,y1,x2,y2}
	_tag="测试",								--用于标记用于print等打印
}
]]--
--point类的使用方法和multiPoint差不多,实际上multiPoint中的点都是用point创建的,所以都能单独的去访问
test1=multiPoint:new({	--不设置锚点属性
	{x=100,y=200,color=0xffffff},
	{x=150,y=200,color=0xffffff},
	{x=100,y=250,color=0xffffff},
	_tag="测试1"
})
test2=multiPoint:new({	--设置锚点属性通过锚点转换坐标
	{x=100,y=200,color=0xffffff},
	{x=150,y=200,color=0xffffff},
	{x=100,y=250,color=0xffffff},
	MainPoint={x=560,y=400},Anchor="Middle",
	_tag="测试2",
})
test3=multiPoint:new({	--设置转换后的锚点	
--如果预先传入DstMainPoint则会在锚点转换的时候以DstMainPoint作为控件的锚点
--简单下把一个按钮当中一个控件,这个控件的位置会随着锚点的位置变动,但是大小是随着缩放改变的
	{x=100,y=200,color=0xffffff},
	{x=150,y=200,color=0xffffff},
	{x=100,y=250,color=0xffffff},
	MainPoint={x=560,y=400},Anchor="Middle",
	DstMainPoint={x=373,y=266},
	_tag="测试3"
})

test1:printXY()
test2:printXY()
test3:printXY()

test1:getandCmpColor()	--比色
AllCur=test1:getXY()--获取所有转换后的色组坐标
Allpoint=test1:getAllpoint()--获取所有点的所以
GetPoint=test1:getXYtoPoint()--获取所有转换后的色组Point类坐标

--findcolor
test_findcolor=multiPoint:new({
	{x=100,y=200,color=0xffffff},
	{x=150,y=200,color=0xffffff},
	{x=100,y=250,color=0xffffff},
	Area={100,100,200,200}--用找色不传入Area会报错的
})
test_findcolor:findColor()

--Click
test_Click=multiPoint:new({
	{x=100,y=200,color=0xffffff},
	{x=150,y=200,color=0xffffff},
	{x=100,y=250,color=0xffffff},
	index={100,100,200,200}--用Click需要传入index坐标,会在这个范围内点击,如果不需要可以自己重写下
})
test_Click:Click()--点击index范围内的坐标
test_Click:AllClick()--点击所有参数点除锚点和index
