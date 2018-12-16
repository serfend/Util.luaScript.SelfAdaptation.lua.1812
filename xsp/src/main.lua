--参考手册为叉叉2.0  https://www.zybuluo.com/xxzhushou/note/1271276
--把自定义取色放到叉叉集成开发环境下的data.lua,可以直接覆盖,抓图的时候用Anchor
--打印函数为Print()没有覆盖print()
--初始化必须调用
--	K=System:new(DevScreen,CurScreen,1,"Height","Height")
--	需要自己调用screen.init
--所有的取色操作都会自动keep一次,为了保证性能,因此会对keep的状态进行了保留
--因此在需要的时候务必运行System中的keep(false)或Switchkeep
require"base"require'Frame'require'const' --必须要的前置代码
--Top,Bottom为上下黑边,Left和Right为左右黑边,Widht为宽,height为高 width需要大于height
DevScreen={	--开发分辨率
	Top=0,Bottom=0,Left=0,Right=0,
	Width=1920,Height=1080,
}
CurScreen={	--本机分辨率
	Top=0,Bottom=0,Left=0,Right=0,
	Width=2246,Height=1246,
}

_K=System:new(DevScreen,DevScreen,1,"Height","Height")
screen.init(1)
--需要什么demo就取消哪个的注释
--require'Demo.multiPoint'

--require'Demo.File'

--require'Demo.HUD'

--require'Demo.runTime'

--require'Demo.Slide'