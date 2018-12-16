local 计时器=runTime:new()

计时器:setcheckTime(10)
slp(2)
计时器:cmpTime()
计时器:resetTime()--可以传入T,直接设置启动时间,比如要往前设置一秒,则T=os.milliTime()-1000
while not 计时器:checkTime() do	--checkTime判断到时间后会自动重新设置启动时间
 slp(1)
 计时器:cmpTime()
end
