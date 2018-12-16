
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
