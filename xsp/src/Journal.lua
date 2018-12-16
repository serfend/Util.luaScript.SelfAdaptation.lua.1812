--2018-11-16 v1.0.1
--更改多点对象中不设置锚点属性时的逻辑
--更改锚点属性Middle的算法
--更新多点对象Area属性,存在锚点时的算法
--
--2018-11-16 v1.0.2
--	增加System对象中的锚点和从属点缩放模式"unequal",可以对一些全屏显示的游戏进行转换
--
--2018-11-16 v1.0.3
--	修改锚点转换Left,Right,Top,Bottom,之前写错了
--
--2018-11-18 v1.0.4
--	在point(multipoint):getandCmpcolor类中,增加属性,可以传入布尔值,当比色得结果等于这个传入的布尔值时,则点击
--	新旧对比
--		旧
--			local a=point:new({x=100,y=100,color=oxffffff})
--				if a:getandCmpcolor() then
--				a:Click(1)
--			end
--		新
--			point:new({x=100,y=100,color=oxffffff}):getandCmpcolor(true,1)
--	新增函数mulitpoint:AllClick(T),作用是点击new时所传入的所有参数点(不包含锚点和index)

--2018-11-19 9:30 v1.0.5
--	整合multipoint和point类,把锚点缩放代码拿了出来

--2018-11-23 15:19 v1.0.6
--	之前忘了加了,进行了增加,现在开发设备有黑边也可以进行缩放了

--2018-12-01 20:05 v1.0.7
--	修改findcolor对象,找到后会返回以x,y组成的point对象
--	优化,把创建点对象时的TableCopy删除了,减少了部分内存消耗

--2018-12-07 00:44 v1.0.8
--	删除了创建对象时不必要的代码

--2018-12-07 16:41 v1.1.0
--	修改为调用2.0的api
--		修改point:getXY()为point:getPoint(),将会已缩放后的点创建Point类
--		修改point类,保留传入的参数,并把缩放后的锚点和从属点放入self.Cur中
--		修改File类,增加new时Path的传参,对应引擎目录Public和Private
--		增加runTime计时器类
--			new之后setcheckTime(T)设置计时器时长 单位/秒
--			checkTime()检查时间,返回true并重设起点时间,或false
--			cmpTime()比较当前与起点时间的时间差 单位/毫秒
--		增加多点对象中的findColors方法
--2018-12-09 23:02 v1.2.0		

--	内部格式大改,我也不记得改了啥了

--2018-12-11 21:32 v1.3.1
--	修改多点对象中findcolor和findcolors,可以选择传入getXY(string)则{x=(number),y=(number)},默认为返回以找到的点构建的单点对象

--2018-12-12 13:04 v1.3.3
--	增加了const常量表,在传参的时候可以简化点了

--2018-12-12 16:27 v1.3.4
--	写了个我也不知道好不好用的findcolors,原理就是调用screen.findcolors的返回点,去进行比色,再返回比色成功的点
--	findcolorEX(Ac) Ac填写需要提交给findcolors的点的数量,会调用new时传入的点,同时必须要添加MainPoint属性

--2018-12-13 18:15 v1.3.6
--	增加了Slide函数,在_const中增加参数,可以通过修改GetColorMode修改getandCmpcolor时的取色方式